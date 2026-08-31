package com.hjh.practice.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MediaController {

    @GetMapping("/media")
    public String media(Model model) {
        int totalFiles = 128;
        int imageFiles = 94;
        int videoFiles = 18;
        int documentFiles = 16;

        List<Map<String, Object>> mediaItems = new ArrayList<>();

        mediaItems.add(createMediaItem("hero-banner.jpg", "이미지", "2.4MB", "2026-09-01", "공개", "success", "HB"));
        mediaItems.add(createMediaItem("product-showcase.png", "이미지", "1.8MB", "2026-08-29", "보류", "warning", "PS"));
        mediaItems.add(createMediaItem("intro-video.mp4", "동영상", "18.7MB", "2026-08-27", "공개", "success", "IV"));
        mediaItems.add(createMediaItem("company-profile.pdf", "문서", "840KB", "2026-08-25", "비공개", "neutral", "CP"));
        mediaItems.add(createMediaItem("team-photo.jpg", "이미지", "3.2MB", "2026-08-21", "공개", "success", "TP"));
        mediaItems.add(createMediaItem("promo-reel.mp4", "동영상", "24.6MB", "2026-08-20", "검토", "warning", "PR"));
        mediaItems.add(createMediaItem("monthly-report.pdf", "문서", "1.1MB", "2026-08-18", "공개", "success", "MR"));
        mediaItems.add(createMediaItem("icon-set.svg", "이미지", "540KB", "2026-08-16", "공개", "success", "IS"));

        model.addAttribute("totalFiles", totalFiles);
        model.addAttribute("imageFiles", imageFiles);
        model.addAttribute("videoFiles", videoFiles);
        model.addAttribute("documentFiles", documentFiles);
        model.addAttribute("mediaItems", mediaItems);

        return "media";
    }

    private Map<String, Object> createMediaItem(String name, String type, String size, String uploadedAt,
            String status, String statusClass, String badgeText) {
        Map<String, Object> item = new HashMap<>();
        item.put("name", name);
        item.put("type", type);
        item.put("size", size);
        item.put("uploadedAt", uploadedAt);
        item.put("status", status);
        item.put("statusClass", statusClass);
        item.put("badgeText", badgeText);
        return item;
    }
}
