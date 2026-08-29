package com.hjh.practice.service.post;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.mapper.post.PostMapper;

@Service
public class PostService {

    private final PostMapper postMapper;

    public PostService(PostMapper postMapper) {
        this.postMapper = postMapper;
    }

    /**
     * 게시글 목록 조회
     */
    public List<CmsPost> getPostList(
            String status,
            String query,
            int page,
            int size) {

        int offset = (page - 1) * size;

        return postMapper.selectPostList(
                status,
                query,
                size,
                offset);
    }

    /**
     * 검색/상태 필터가 적용된 게시글 개수
     */
    public int getPostListCount(
            String status,
            String query) {

        return postMapper.countPostList(
                status,
                query);
    }

    /**
     * 게시글 상세 조회
     */
    public CmsPost getPostById(Long id) {
        return postMapper.selectPostById(id);
    }

    @Transactional
    public void createPost(CmsPost post) {
        normalizePost(post, null);
        postMapper.insertPost(post);
    }

    /**
     * 게시글 수정
     */
    @Transactional
    public void updatePost(CmsPost post) {
        if (post == null || post.getId() == null) {
            throw new IllegalArgumentException("수정할 게시글 ID가 필요합니다.");
        }

        normalizePost(post, post.getId());
        postMapper.updatePost(post);
    }

    private void normalizePost(CmsPost post, Long excludeId) {
        if (post == null) {
            throw new IllegalArgumentException("게시글 정보가 없습니다.");
        }

        String title = normalizeText(post.getTitle());
        String slug = normalizeSlug(post.getSlug(), title);

        if (existsSlug(slug, excludeId)) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.");
        }

        post.setTitle(title);
        post.setSlug(slug);
        post.setSummary(normalizeText(post.getSummary()));
        post.setContent(normalizeText(post.getContent()));
        post.setAuthor(defaultIfBlank(post.getAuthor(), "관리자"));
        post.setStatus(normalizeStatus(post.getStatus()));

        if (post.getViewCount() == null) {
            post.setViewCount(0);
        }

        if ("PUBLISHED".equals(post.getStatus())) {
            if (post.getPublishedAt() == null) {
                post.setPublishedAt(LocalDateTime.now());
            }
        } else {
            post.setPublishedAt(null);
        }
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "DRAFT";
        }

        String normalized = status.trim().toUpperCase(Locale.ROOT);

        if ("PUBLISHED".equals(normalized)
                || "SCHEDULED".equals(normalized)
                || "DRAFT".equals(normalized)) {
            return normalized;
        }

        return "DRAFT";
    }

    private String normalizeText(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String defaultIfBlank(String value, String defaultValue) {
        if (value == null || value.isBlank()) {
            return defaultValue;
        }

        return value.trim();
    }

    private String normalizeSlug(String rawSlug, String title) {
        String source = rawSlug == null || rawSlug.isBlank()
                ? title
                : rawSlug;

        if (source == null || source.isBlank()) {
            return "post";
        }

        String slug = source.trim()
                .toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9가-힣]+", "-")
                .replaceAll("^-+|-+$", "")
                .replaceAll("-+", "-");

        if (slug.isBlank()) {
            return "post";
        }

        return slug;
    }

    /**
     * 게시글 삭제
     */
    @Transactional
    public void deletePost(Long id) {
        postMapper.deletePost(id);
    }

    /**
     * 예약 게시글 발행
     */
    @Transactional
    public void publishScheduledPost(Long id) {
        postMapper.publishScheduledPost(id);
    }

    /**
     * 전체 게시글 수
     */
    public int getTotalCount() {
        return postMapper.countAllPosts();
    }

    /**
     * 발행 게시글 수
     */
    public int getPublishedCount() {
        return postMapper.countPostsByStatus("PUBLISHED");
    }

    /**
     * 예약 게시글 수
     */
    public int getScheduledCount() {
        return postMapper.countPostsByStatus("SCHEDULED");
    }

    /**
     * 임시저장 게시글 수
     */
    public int getDraftCount() {
        return postMapper.countPostsByStatus("DRAFT");
    }

    /**
     * slug 중복 확인
     *
     * 신규 등록: excludeId = null
     * 수정: excludeId = 현재 게시글 ID
     */
    public boolean existsSlug(
            String slug,
            Long excludeId) {

        return postMapper.existsSlug(
                slug,
                excludeId);
    }

    public List<String> getAllSlugs() {
        return postMapper.selectAllSlugs();
    }
}