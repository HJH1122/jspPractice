package com.hjh.practice.controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class CommentsController {

    private static final List<Map<String, Object>> COMMENT_STORE = new ArrayList<>();
    private static final List<Map<String, Object>> REPORT_STORE = new ArrayList<>();

    @GetMapping("/comments")
    public String comments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "false") boolean reportedOnly,
            Model model) {

        String selectedStatus = status == null ? "all" : status;
        String searchKeyword = keyword == null ? "" : keyword.trim();

        List<Map<String, Object>> filtered = COMMENT_STORE.stream()
                .filter(comment -> matchesStatus(comment, selectedStatus))
                .filter(comment -> matchesKeyword(comment, searchKeyword))
                .filter(comment -> !reportedOnly || reportedCount(comment.get("id")) > 0)
                .map(comment -> {
                    comment.put("reportCount", reportedCount(comment.get("id")));
                    return comment;
                })
                .sorted(Comparator.comparing(item -> String.valueOf(item.get("createdAt")), Comparator.reverseOrder()))
                .collect(Collectors.toList());

        model.addAttribute("comments", filtered);
        model.addAttribute("totalCount", COMMENT_STORE.size());
        model.addAttribute("pendingCount", countByStatus("pending"));
        model.addAttribute("approvedCount", countByStatus("approved"));
        model.addAttribute("hiddenCount", countByStatus("hidden"));
        model.addAttribute("reportedCount", REPORT_STORE.size());
        model.addAttribute("selectedStatus", selectedStatus);
        model.addAttribute("keyword", searchKeyword);
        model.addAttribute("reportedOnly", reportedOnly);

        return "comments";
    }

    @GetMapping("/comments/{id}")
    public String detail(@PathVariable Long id, Model model) {
        Map<String, Object> comment = findCommentById(id);
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

        Map<String, Object> comment = findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        comment.put("status", normalizeStatus(status));
        comment.put("statusClass", statusClass(comment.get("status").toString()));
        comment.put("statusLabel", statusLabel(comment.get("status").toString()));
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
            Map<String, Object> comment = findCommentById(id);
            if (comment != null) {
                comment.put("status", normalizeStatus(status));
                comment.put("statusClass", statusClass(comment.get("status").toString()));
                comment.put("statusLabel", statusLabel(comment.get("status").toString()));
            }
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

        COMMENT_STORE.removeIf(comment -> selectedIds.contains(Long.valueOf(comment.get("id").toString())));
        REPORT_STORE.removeIf(report -> selectedIds.contains(Long.valueOf(report.get("commentId").toString())));
        redirectAttributes.addFlashAttribute("message", "선택한 댓글이 삭제되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/{id}/report")
    public String reportComment(
            @PathVariable Long id,
            @RequestParam String reason,
            RedirectAttributes redirectAttributes) {

        Map<String, Object> comment = findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        REPORT_STORE.add(report(id, reason, "2026-09-27 11:00"));
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

        Map<String, Object> comment = findCommentById(id);
        if (comment == null) {
            redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
            return "redirect:/comments";
        }

        comment.put("author", author);
        comment.put("postTitle", postTitle);
        comment.put("content", content);
        comment.put("status", normalizeStatus(status));
        comment.put("statusClass", statusClass(comment.get("status").toString()));
        comment.put("statusLabel", statusLabel(comment.get("status").toString()));

        redirectAttributes.addFlashAttribute("message", "댓글이 수정되었습니다.");
        return "redirect:/comments";
    }

    @PostMapping("/comments/{id}/delete")
    public String deleteComment(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {

        COMMENT_STORE.removeIf(comment -> Objects.equals(comment.get("id"), id));
        redirectAttributes.addFlashAttribute("message", "댓글이 삭제되었습니다.");
        return "redirect:/comments";
    }

    private static Map<String, Object> comment(Long id, String author, String postTitle, String status,
                                              String content, String createdAt) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", id);
        item.put("author", author);
        item.put("postTitle", postTitle);
        item.put("status", normalizeStatus(status));
        item.put("statusClass", statusClass(item.get("status").toString()));
        item.put("statusLabel", statusLabel(item.get("status").toString()));
        item.put("content", content);
        item.put("createdAt", createdAt);
        return item;
    }

    private boolean matchesStatus(Map<String, Object> comment, String selectedStatus) {
        if (selectedStatus == null || "all".equals(selectedStatus)) {
            return true;
        }
        return selectedStatus.equals(comment.get("status"));
    }

    private boolean matchesKeyword(Map<String, Object> comment, String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return true;
        }

        String lowerKeyword = keyword.toLowerCase();
        return String.valueOf(comment.get("author")).toLowerCase().contains(lowerKeyword)
                || String.valueOf(comment.get("postTitle")).toLowerCase().contains(lowerKeyword)
                || String.valueOf(comment.get("content")).toLowerCase().contains(lowerKeyword);
    }

    private Map<String, Object> findCommentById(Long id) {
        return COMMENT_STORE.stream()
                .filter(comment -> Objects.equals(comment.get("id"), id))
                .findFirst()
                .orElse(null);
    }

    private int reportedCount(Object commentId) {
        if (commentId == null) {
            return 0;
        }
        return (int) REPORT_STORE.stream()
                .filter(report -> Objects.equals(report.get("commentId"), Long.valueOf(commentId.toString())))
                .count();
    }

    private static Map<String, Object> report(Long commentId, String reason, String reportedAt) {
        Map<String, Object> item = new HashMap<>();
        item.put("commentId", commentId);
        item.put("reason", reason);
        item.put("reportedAt", reportedAt);
        return item;
    }

    private int countByStatus(String status) {
        return (int) COMMENT_STORE.stream()
                .filter(comment -> Objects.equals(comment.get("status"), normalizeStatus(status)))
                .count();
    }

    private static String normalizeStatus(String status) {
        if (status == null) {
            return "pending";
        }
        switch (status) {
            case "approved":
            case "승인됨":
                return "approved";
            case "hidden":
            case "숨김":
                return "hidden";
            case "pending":
            case "대기":
            default:
                return "pending";
        }
    }

    private static String statusLabel(String status) {
        switch (normalizeStatus(status)) {
            case "approved":
                return "승인됨";
            case "hidden":
                return "숨김";
            case "pending":
            default:
                return "대기";
        }
    }

    private static String statusClass(String status) {
        switch (normalizeStatus(status)) {
            case "approved":
                return "success";
            case "hidden":
                return "neutral";
            case "pending":
            default:
                return "warning";
        }
    }
}
