package com.hjh.practice.service.site;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.mapper.site.MainPageSettingsMapper;

@Service
public class MainPageSettingsService {

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
        return defaults;
    }

    @Transactional
    public void saveSettings(MainPageSettings settings) {
        settings.setBannerTitle(trim(settings.getBannerTitle()));
        settings.setBannerDescription(trim(settings.getBannerDescription()));
        settings.setBannerImageUrl(trim(settings.getBannerImageUrl()));
        settings.setButtonLinkType(normalizeLinkType(settings.getButtonLinkType()));

        int updatedRows = settingsMapper.saveSettings(settings);
        if (updatedRows != 1) {
            throw new IllegalStateException("메인페이지 설정을 저장하지 못했습니다.");
        }
    }

    private String normalizeLinkType(String linkType) {
        if ("POST".equals(linkType) || "URL".equals(linkType)) {
            return linkType;
        }
        return "PAGE";
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
