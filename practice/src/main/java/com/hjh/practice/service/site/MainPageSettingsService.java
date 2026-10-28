package com.hjh.practice.service.site;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.mapper.site.MainPageSettingsMapper;

@Service
public class MainPageSettingsService {

    private static final List<String> DEFAULT_SECTION_ORDER =
            List.of("FEATURED_PAGE", "FEATURED_POSTS", "RECENT_POSTS");
    private static final Set<String> SECTION_IDS = Set.copyOf(DEFAULT_SECTION_ORDER);

    private final MainPageSettingsMapper settingsMapper;

    public MainPageSettingsService(MainPageSettingsMapper settingsMapper) {
        this.settingsMapper = settingsMapper;
    }

    public MainPageSettings getSettings() {
        MainPageSettings settings = settingsMapper.selectSettings();
        if (settings != null) {
            return settings;
        }

        MainPageSettings defaults = new MainPageSettings();
        defaults.setBannerTitle("우리의 이야기를 시작합니다");
        defaults.setBannerDescription("사이트의 주요 소식과 콘텐츠를 방문자에게 소개하는 문구를 입력합니다.");
        defaults.setBannerImageUrl("");
        defaults.setButtonLinkType("PAGE");
        defaults.setButtonLinkTarget("");
        defaults.setSectionOrder(String.join(",", DEFAULT_SECTION_ORDER));
        return defaults;
    }

    public List<String> getOrderedSections(String sectionOrder) {
        List<String> orderedSections = new ArrayList<>();
        if (sectionOrder != null && !sectionOrder.isBlank()) {
            for (String sectionId : sectionOrder.split(",")) {
                String normalizedId = sectionId.trim();
                if (SECTION_IDS.contains(normalizedId) && !orderedSections.contains(normalizedId)) {
                    orderedSections.add(normalizedId);
                }
            }
        }
        for (String sectionId : DEFAULT_SECTION_ORDER) {
            if (!orderedSections.contains(sectionId)) {
                orderedSections.add(sectionId);
            }
        }
        return orderedSections;
    }

    @Transactional
    public void saveSettings(MainPageSettings settings) {
        settings.setBannerTitle(trim(settings.getBannerTitle()));
        settings.setBannerDescription(trim(settings.getBannerDescription()));
        settings.setBannerImageUrl(trim(settings.getBannerImageUrl()));
        settings.setButtonLinkType(normalizeLinkType(settings.getButtonLinkType()));
        settings.setButtonLinkTarget(normalizeLinkTarget(
                settings.getButtonLinkType(), settings.getButtonLinkTarget()));
        settings.setSectionOrder(String.join(",", getOrderedSections(settings.getSectionOrder())));

        int updatedRows = settingsMapper.saveSettings(settings);
        if (updatedRows != 1) {
            throw new IllegalStateException("메인페이지 설정을 저장하지 못했습니다.");
        }
    }

    private String normalizeLinkType(String linkType) {
        if ("PAGE".equals(linkType) || "POST".equals(linkType) || "URL".equals(linkType)) {
            return linkType;
        }
        throw new IllegalArgumentException("올바른 버튼 연결 유형을 선택해 주세요.");
    }

    private String normalizeLinkTarget(String linkType, String linkTarget) {
        String target = trim(linkTarget);
        if ("PAGE".equals(linkType) || "POST".equals(linkType)) {
            try {
                if (Long.parseLong(target) <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException exception) {
                throw new IllegalArgumentException("버튼으로 연결할 콘텐츠를 선택해 주세요.");
            }
            return target;
        }

        try {
            java.net.URI uri = java.net.URI.create(target);
            if (uri.isAbsolute()
                    && ("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null) {
                return uri.toASCIIString();
            }
            if (!uri.isAbsolute() && target.startsWith("/")
                    && !target.startsWith("//") && !target.contains("\\")) {
                return target;
            }
        } catch (IllegalArgumentException ignored) {
        }
        throw new IllegalArgumentException("버튼 주소는 http(s) URL 또는 사이트 내부 경로로 입력해 주세요.");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
