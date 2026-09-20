package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.service.media.MediaService;
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
    private final MediaService mediaService;

    public HomeController(PageManagementService pageManagementService,
                          PostService postService,
                          MediaService mediaService) {
        this.pageManagementService = pageManagementService;
        this.postService = postService;
        this.mediaService = mediaService;
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

        List<Map<String, Object>> taskNotifications = buildTaskNotifications(scheduledCount);
        model.addAttribute("taskNotifications", taskNotifications);

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
            item.put("updatedAtDisplay", post.getUpdatedAtDisplay());
            items.add(item);
        }

        items.sort(Comparator.comparing(item -> (LocalDateTime) item.get("updatedAt"), Comparator.reverseOrder()));

        List<Map<String, Object>> recentItems = new ArrayList<>();
        for (int i = 0; i < Math.min(items.size(), 5); i++) {
            recentItems.add(items.get(i));
        }

        return recentItems;
    }

    private List<Map<String, Object>> buildTaskNotifications(int scheduledCount) {
        List<Map<String, Object>> notifications = new ArrayList<>();

        int mediaCount = mediaService.countMedia(null, null, null);
        if (mediaCount == 0) {
            notifications.add(notification("새 이미지 업로드 필요", "대표 섹션용 썸네일을 갱신하세요."));
        }

        if (scheduledCount > 0) {
            notifications.add(notification("예약 발행 확인",
                    "발행 예정 콘텐츠가 " + scheduledCount + "건 있습니다."));
        }

        int draftCount = pageManagementService.countByStatus(PageStatus.DRAFT)
                + postService.getDraftCount();
        if (draftCount > 0) {
            notifications.add(notification("임시 저장 콘텐츠 점검",
                    "초안 상태의 콘텐츠가 " + draftCount + "건 남아 있습니다."));
        }

        if (notifications.isEmpty()) {
            notifications.add(notification("작업 알림", "현재 확인할 알림이 없습니다."));
        }

        return notifications;
    }

    private Map<String, Object> notification(String title, String message) {
        Map<String, Object> item = new HashMap<>();
        item.put("title", title);
        item.put("message", message);
        return item;
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