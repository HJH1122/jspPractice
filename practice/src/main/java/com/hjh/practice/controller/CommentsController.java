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

    static {
        COMMENT_STORE.add(comment(101L, "김관리자", "신규 기능 안내", "approved",
                "정말 유용한 내용이네요. 운영에 바로 반영하겠습니다.", "2026-09-25 09:10"));
        COMMENT_STORE.add(comment(102L, "박사용자", "서비스 개선 제안", "pending",
                "메인 페이지 슬라이더가 조금 더 넓으면 좋겠습니다.", "2026-09-25 08:42"));
        COMMENT_STORE.add(comment(103L, "최고객", "업데이트 일정", "hidden",
                "이번 배포 일정이 아직 안 정해진 걸로 보입니다.", "2026-09-24 18:05"));
        COMMENT_STORE.add(comment(104L, "정회원", "문의 답변", "approved",
                "답변 감사합니다. 다음에도 도움이 필요하면 다시 문의하겠습니다.", "2026-09-24 16:30"));
        COMMENT_STORE.add(comment(105L, "이기자", "디자인 피드백", "pending",
                "버튼 간격이 조금 좁아서 모바일에서 다닥다닥 보입니다.", "2026-09-24 11:20"));
    }

    @GetMapping("/comments")
    public String comments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            Model model) {

        String selectedStatus = status == null ? "all" : status;
        String searchKeyword = keyword == null ? "" : keyword.trim();

        List<Map<String, Object>> filtered = COMMENT_STORE.stream()
                .filter(comment -> matchesStatus(comment, selectedStatus))
                .filter(comment -> matchesKeyword(comment, searchKeyword))
                .sorted(Comparator.comparing(item -> String.valueOf(item.get("createdAt")), Comparator.reverseOrder()))
                .collect(Collectors.toList());

        model.addAttribute("comments", filtered);
        model.addAttribute("totalCount", COMMENT_STORE.size());
        model.addAttribute("pendingCount", countByStatus("pending"));
        model.addAttribute("approvedCount", countByStatus("approved"));
        model.addAttribute("hiddenCount", countByStatus("hidden"));
        model.addAttribute("selectedStatus", selectedStatus);
        model.addAttribute("keyword", searchKeyword);

        return "comments";
    }

    @PostMapping("/comments/{id}/status")
    public String updateStatus(
            @PathVariable Long id,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {

        for (Map<String, Object> comment : COMMENT_STORE) {
            if (Objects.equals(comment.get("id"), id)) {
                comment.put("status", normalizeStatus(status));
                comment.put("statusClass", statusClass(comment.get("status").toString()));
                comment.put("statusLabel", statusLabel(comment.get("status").toString()));
                redirectAttributes.addFlashAttribute("message", "댓글 상태가 변경되었습니다.");
                return "redirect:/comments";
            }
        }

        redirectAttributes.addFlashAttribute("message", "해당 댓글을 찾을 수 없습니다.");
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
