package com.hjh.practice.service.comment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.comment.CmsComment;
import com.hjh.practice.mapper.comment.CommentMapper;

@Service
public class CommentService {

    private static final Set<String> REPORT_REASONS = Set.of("스팸/광고성", "욕설/비방", "허위 정보", "기타");

    private final CommentMapper commentMapper;

    public CommentService(CommentMapper commentMapper) {
        this.commentMapper = commentMapper;
    }

    @Transactional
    public void createComment(CmsComment comment) {
        if (comment == null) {
            throw new IllegalArgumentException("댓글 정보가 없습니다.");
        }

        String author = normalizeText(comment.getAuthor());
        String content = normalizeText(comment.getContent());
        if (author == null || author.isBlank() || content == null || content.isBlank()) {
            throw new IllegalArgumentException("작성자와 댓글 내용을 입력해 주세요.");
        }

        comment.setAuthor(author);
        comment.setContent(content);
        comment.setStatus("approved");
        comment.setReportCount(0);
        comment.setCreatedAt(LocalDateTime.now());
        comment.setUpdatedAt(LocalDateTime.now());

        if (comment.getPostTitle() == null || comment.getPostTitle().isBlank()) {
            comment.setPostTitle("게시글 " + comment.getPostId());
        }

        commentMapper.insertComment(comment);
    }

    public List<CmsComment> findCommentsByPostId(Long postId) {
        if (postId == null) {
            return List.of();
        }
        return commentMapper.selectCommentsByPostId(postId);
    }

    public List<CmsComment> findComments(String status, String keyword, boolean reportedOnly) {
        return commentMapper.selectComments(status, keyword, reportedOnly);
    }

    public CmsComment findCommentById(Long id) {
        return commentMapper.selectCommentById(id);
    }

    public List<String> findCommentReportReasons(Long commentId) {
        if (commentId == null) {
            return List.of();
        }
        return commentMapper.selectCommentReportReasons(commentId);
    }

    @Transactional
    public CmsComment reportComment(Long id, String reason) {
        String normalizedReason = normalizeText(reason);
        if (normalizedReason == null || !REPORT_REASONS.contains(normalizedReason)) {
            throw new IllegalArgumentException("신고 사유를 선택해 주세요.");
        }

        CmsComment comment = id == null ? null : commentMapper.selectCommentById(id);
        if (comment == null) {
            return null;
        }

        if (commentMapper.increaseCommentReportCount(id) == 0) {
            return null;
        }
        commentMapper.insertCommentReport(id, normalizedReason);
        comment.setReportCount(comment.getReportCount() + 1);
        return comment;
    }

    public int countAllComments() {
        return commentMapper.countAllComments();
    }

    public int countCommentsByStatus(String status) {
        return commentMapper.countCommentsByStatus(normalizeStatus(status));
    }

    public int countReportedComments() {
        return commentMapper.countReportedComments();
    }

    @Transactional
    public void updateStatus(Long id, String status) {
        if (id == null) {
            return;
        }
        commentMapper.updateCommentStatus(id, normalizeStatus(status));
    }

    @Transactional
    public void updateComment(CmsComment comment) {
        if (comment == null || comment.getId() == null) {
            throw new IllegalArgumentException("수정할 댓글 정보가 없습니다.");
        }
        comment.setStatus(normalizeStatus(comment.getStatus()));
        comment.setUpdatedAt(LocalDateTime.now());
        commentMapper.updateComment(comment);
    }

    @Transactional
    public void deleteComment(Long id) {
        if (id != null) {
            commentMapper.deleteComment(id);
        }
    }

    @Transactional
    public void deleteCommentsByIds(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return;
        }
        commentMapper.deleteCommentsByIds(ids);
    }

    private String normalizeText(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "approved";
        }
        String normalized = status.trim().toLowerCase();
        if ("approved".equals(normalized) || "승인됨".equals(status)) {
            return "approved";
        }
        if ("hidden".equals(normalized) || "숨김".equals(status)) {
            return "hidden";
        }
        return "approved";
    }
}
