package com.hjh.practice.controller;

import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.site.MainPageSettingsService;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class SiteController {

    private final MainPageSettingsService settingsService;
    private final MediaService mediaService;

    public SiteController(MainPageSettingsService settingsService, MediaService mediaService) {
        this.settingsService = settingsService;
        this.mediaService = mediaService;
    }

    @GetMapping("/site/main-page")
    public String mainPage(Model model) {
        MainPageSettings settings = settingsService.getSettings();
        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("mediaItems", mediaService.findMedia(null, "이미지", "공개", "latest"));
        return "site-main-page";
    }

    @PostMapping("/site/main-page/save")
    public String saveMainPage(@ModelAttribute("settings") MainPageSettings settings,
                               RedirectAttributes redirectAttributes) {
        settingsService.saveSettings(settings);
        redirectAttributes.addFlashAttribute("message", "메인페이지 설정을 저장했습니다.");
        return "redirect:/site/main-page";
    }
}
