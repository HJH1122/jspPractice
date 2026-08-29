package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import com.hjh.practice.service.post.PostService;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    private final PageManagementService pageManagementService;
    private final PostService postService;

    public HomeController(PageManagementService pageManagementService, PostService postService) {
        this.pageManagementService = pageManagementService;
        this.postService = postService;
    }

    @GetMapping("/")
    public String login(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            return "redirect:/main";
        }

        return "login";
    }

    @GetMapping("/main")
    public String home(Model model) {
        int totalPageCount = pageManagementService.countAll();
        int totalPostCount = postService.getTotalCount();
        int scheduledCount = pageManagementService.countByStatus(PageStatus.SCHEDULED)
                + postService.getScheduledCount();

        model.addAttribute("totalPageCount", totalPageCount);
        model.addAttribute("totalPostCount", totalPostCount);
        model.addAttribute("scheduledCount", scheduledCount);

        List<Map<String, Object>> recentEditedContent = buildRecentEditedContent();
        model.addAttribute("recentEditedContent", recentEditedContent);

        return "home";
    }

    private List<Map<String, Object>> buildRecentEditedContent() {
        List<Map<String, Object>> items = new ArrayList<>();

        List<CmsPage> pageRows = pageManagementService.findPages(null, null, 1, 10);
        for (CmsPage page : pageRows) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", page.getId());
            item.put("title", page.getTitle());
            item.put("type", "페이지");
            item.put("typeKey", "page");
            item.put("link", "/pages/" + page.getId());
            item.put("status", page.getStatus() == null ? "DRAFT" : page.getStatus().name());
            item.put("statusLabel", page.getStatus() == null ? "초안" : page.getStatus().getLabel());
            item.put("statusCssClass", page.getStatus() == null ? "neutral" : page.getStatus().getCssClass());
            item.put("updatedAt", page.getUpdatedAt() == null ? LocalDateTime.now() : page.getUpdatedAt());
            item.put("updatedAtDisplay", page.getUpdatedAtDisplay());
            items.add(item);
        }

        List<CmsPost> postRows = postService.getPostList(null, null, 1, 10);
        for (CmsPost post : postRows) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", post.getId());
            item.put("title", post.getTitle());
            item.put("type", "게시글");
            item.put("typeKey", "post");
            item.put("link", "/posts/edit?id=" + post.getId());
            item.put("status", post.getStatus() == null ? "DRAFT" : post.getStatus());
            item.put("statusLabel", toPostStatusLabel(post.getStatus()));
            item.put("statusCssClass", toPostStatusCssClass(post.getStatus()));
            item.put("updatedAt", post.getUpdatedAt() == null ? LocalDateTime.now() : post.getUpdatedAt());
            item.put("updatedAtDisplay",
                    post.getUpdatedAt() == null ? "-" : post.getUpdatedAt().toLocalDate().toString());
            items.add(item);
        }

        items.sort(Comparator.comparing(item -> (LocalDateTime) item.get("updatedAt"), Comparator.reverseOrder()));

        List<Map<String, Object>> recentItems = new ArrayList<>();
        for (int i = 0; i < Math.min(items.size(), 5); i++) {
            recentItems.add(items.get(i));
        }

        return recentItems;
    }

    private String toPostStatusLabel(String status) {
        if (status == null) {
            return "초안";
        }
        switch (status) {
            case "PUBLISHED":
                return "발행됨";
            case "SCHEDULED":
                return "예약됨";
            case "DRAFT":
            default:
                return "초안";
        }
    }

    private String toPostStatusCssClass(String status) {
        if (status == null) {
            return "neutral";
        }
        switch (status) {
            case "PUBLISHED":
                return "success";
            case "SCHEDULED":
                return "warning";
            case "DRAFT":
            default:
                return "neutral";
        }
    }
}