package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import com.hjh.practice.service.post.PostService;
import com.hjh.practice.service.site.MainPageSettingsService;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class SiteController {

    private final MainPageSettingsService settingsService;
    private final MediaService mediaService;
    private final PageManagementService pageManagementService;
    private final PostService postService;

    public SiteController(MainPageSettingsService settingsService,
                          MediaService mediaService,
                          PageManagementService pageManagementService,
                          PostService postService) {
        this.settingsService = settingsService;
        this.mediaService = mediaService;
        this.pageManagementService = pageManagementService;
        this.postService = postService;
    }

    @GetMapping("/site/main-page")
    public String mainPage(Model model) {
        MainPageSettings settings = settingsService.getSettings();
        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("mediaItems", mediaService.findMedia(null, "이미지", "공개", "latest"));
        return "site-main-page";
    }

    @GetMapping("/site/main-page/preview")
    public String previewMainPage(Model model) {
        MainPageSettings settings = settingsService.getSettings();
        List<CmsPage> featuredPages = pageManagementService.findMainPages().stream()
                .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                .limit(6)
                .toList();
        List<CmsPost> featuredPosts = postService.getMainPosts().stream()
                .filter(post -> "PUBLISHED".equals(post.getStatus()))
                .limit(6)
                .toList();
        List<CmsPost> recentPosts = postService.getPostList("PUBLISHED", null, 1, 6);

        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("featuredPages", featuredPages);
        model.addAttribute("featuredPosts", featuredPosts);
        model.addAttribute("recentPosts", recentPosts);
        return "site-main-page-preview";
    }

    @PostMapping("/site/main-page/save")
    public String saveMainPage(@ModelAttribute("settings") MainPageSettings settings,
                               RedirectAttributes redirectAttributes) {
        settingsService.saveSettings(settings);
        redirectAttributes.addFlashAttribute("message", "메인페이지 설정을 저장했습니다.");
        return "redirect:/site/main-page";
    }
}
