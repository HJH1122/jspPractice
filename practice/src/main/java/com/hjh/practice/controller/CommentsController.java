package com.hjh.practice.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hjh.practice.dto.comment.CmsComment;
import com.hjh.practice.service.comment.CommentService;

@Controller
public class CommentsController {

    private final CommentService commentService;

    public CommentsController(CommentService commentService) {
        this.commentService = commentService;
    }

    @PostMapping("/posts/{postId}/comments")
    public String createComment(
            @PathVariable Long postId,
            @RequestParam String author,
            @RequestParam String content,
            RedirectAttributes redirectAttributes) {

        try {
            CmsComment comment = new CmsComment();
            comment.setPostId(postId);
            comment.setAuthor(author);
            comment.setPostTitle("게시글 " + postId);
            comment.setContent(content);
            comment.setStatus("approved");
            commentService.createComment(comment);
            redirectAttributes.addFlashAttribute("message", "댓글이 등록되었습니다.");
            return "redirect:/posts/detail?id=" + postId;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("message", e.getMessage());
            return "redirect:/posts/detail?id=" + postId;
        }
    }

    @GetMapping("/comments")
    public String comments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "false") boolean reportedOnly,
            Model model) {

        String selectedStatus = status == null ? "all" : status;
        String searchKeyword = keyword == null ? "" : keyword.trim();

        List<CmsComment> comments = commentService.findComments(selectedStatus, searchKeyword, reportedOnly);
        model.addAttribute("comments", comments);
        model.addAttribute("totalCount", commentService.countAllComments());
        model.addAttribute("approvedCount", commentService.countCommentsByStatus("approved"));
        model.addAttribute("hiddenCount", commentService.countCommentsByStatus("hidden"));
        model.addAttribute("reportedCount", 0);
        model.addAttribute("selectedStatus", selectedStatus);
        model.addAttribute("keyword", searchKeyword);
        model.addAttribute("reportedOnly", reportedOnly);

        return "comments";
    }

    @GetMapping("/comments/{id}")
    public String detail(@PathVariable Long id, Model model) {
        CmsComment comment = commentService.findCommentById(id);
        if (comment == null) {
            model.addAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        model.addAttribute("comment", comment);
        model.addAttribute("commentId", id);
        return "comment-detail";
    }

    @PostMapping("/comments/{id}/status")
    public String updateStatus(
            @PathVariable Long id,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {

        CmsComment comment = commentService.findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        commentService.updateStatus(id, status);
        redirectAttributes.addFlashAttribute("message", "댓글 상태가 변경되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/bulk-status")
    public String bulkStatus(
            @RequestParam(required = false) List<Long> selectedIds,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {

        if (selectedIds == null || selectedIds.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "대상 댓글을 선택해 주세요.");
            return "redirect:/comments";
        }

        for (Long id : selectedIds) {
            commentService.updateStatus(id, status);
        }

        redirectAttributes.addFlashAttribute("message", "선택한 댓글 상태가 변경되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/bulk-delete")
    public String bulkDelete(
            @RequestParam(required = false) List<Long> selectedIds,
            RedirectAttributes redirectAttributes) {

        if (selectedIds == null || selectedIds.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "삭제할 댓글을 선택해 주세요.");
            return "redirect:/comments";
        }

        commentService.deleteCommentsByIds(selectedIds);
        redirectAttributes.addFlashAttribute("message", "선택한 댓글이 삭제되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/{id}/report")
    public String reportComment(
            @PathVariable Long id,
            @RequestParam String reason,
            RedirectAttributes redirectAttributes) {

        CmsComment comment = commentService.findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        redirectAttributes.addFlashAttribute("message", "신고가 접수되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/{id}/edit")
    public String editComment(
            @PathVariable Long id,
            @RequestParam String author,
            @RequestParam String postTitle,
            @RequestParam String content,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {

        CmsComment comment = commentService.findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        comment.setAuthor(author);
        comment.setPostTitle(postTitle);
        comment.setContent(content);
        comment.setStatus(status);
        commentService.updateComment(comment);
        redirectAttributes.addFlashAttribute("message", "댓글이 수정되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/{id}/delete")
    public String deleteComment(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {

        commentService.deleteComment(id);
        redirectAttributes.addFlashAttribute("message", "댓글이 삭제되었습니다.");
        return "redirect:/comments";
    }

    public static List<CmsComment> getCommentsByPostId(Long postId) {
        return List.of();
    }
}
