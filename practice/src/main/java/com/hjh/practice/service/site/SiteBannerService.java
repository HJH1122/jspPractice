package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.SiteBanner;
import com.hjh.practice.mapper.site.SiteBannerMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URI;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

@Service
public class SiteBannerService {

    private static final Set<String> POSITIONS = Set.of("MAIN_TOP", "MAIN_MIDDLE", "MAIN_BOTTOM");
    private static final Set<String> LINK_TYPES = Set.of("NONE", "INTERNAL", "EXTERNAL");

    private final SiteBannerMapper siteBannerMapper;

    public SiteBannerService(SiteBannerMapper siteBannerMapper) {
        this.siteBannerMapper = siteBannerMapper;
    }

    public List<SiteBanner> getBanners(String siteId) {
        return siteBannerMapper.selectBanners(siteId);
    }

    public SiteBanner getBanner(String siteId, Long bannerId) {
        SiteBanner banner = siteBannerMapper.selectBanner(siteId, bannerId);
        if (banner == null) {
            throw new IllegalArgumentException("배너를 찾을 수 없습니다.");
        }
        return banner;
    }

    public int countBanners(String siteId) {
        return siteBannerMapper.countBanners(siteId);
    }

    public int countVisibleBanners(String siteId) {
        return siteBannerMapper.countVisibleBanners(siteId);
    }

    public SiteBanner newBanner(String siteId) {
        SiteBanner banner = new SiteBanner();
        banner.setSiteId(siteId);
        banner.setPosition("MAIN_TOP");
        banner.setImageUrl("");
        banner.setLinkType("NONE");
        banner.setLinkTarget("");
        banner.setDisplayOrder(siteBannerMapper.selectMaxDisplayOrder(siteId) + 1);
        banner.setVisible(true);
        banner.setDescription("");
        return banner;
    }

    @Transactional
    public void saveBanner(String siteId, SiteBanner form) {
        SiteBanner banner = normalizeAndValidate(form);
        banner.setSiteId(siteId);

        if (form.getBannerId() == null) {
            if (siteBannerMapper.insertBanner(siteId, banner) != 1) {
                throw new IllegalStateException("배너를 등록하지 못했습니다.");
            }
            return;
        }

        getBanner(siteId, form.getBannerId());
        banner.setBannerId(form.getBannerId());
        if (siteBannerMapper.updateBanner(siteId, banner) != 1) {
            throw new IllegalStateException("배너 정보를 저장하지 못했습니다.");
        }
    }

    @Transactional
    public void changeVisibility(String siteId, Long bannerId, boolean visible) {
        getBanner(siteId, bannerId);
        if (siteBannerMapper.updateBannerVisibility(siteId, bannerId, visible) != 1) {
            throw new IllegalStateException("배너 노출 상태를 변경하지 못했습니다.");
        }
    }

    @Transactional
    public void deleteBanner(String siteId, Long bannerId) {
        getBanner(siteId, bannerId);
        if (siteBannerMapper.deleteBanner(siteId, bannerId) != 1) {
            throw new IllegalStateException("배너를 삭제하지 못했습니다.");
        }
    }

    private SiteBanner normalizeAndValidate(SiteBanner form) {
        String bannerName = trim(form.getBannerName());
        if (bannerName.isEmpty() || bannerName.length() > 100) {
            throw new IllegalArgumentException("배너명은 1자 이상 100자 이하로 입력해 주세요.");
        }
        if (form.getPosition() == null || !POSITIONS.contains(form.getPosition())) {
            throw new IllegalArgumentException("올바른 배너 노출 위치를 선택해 주세요.");
        }
        if (form.getLinkType() == null || !LINK_TYPES.contains(form.getLinkType())) {
            throw new IllegalArgumentException("올바른 배너 연결 유형을 선택해 주세요.");
        }
        if (form.getDisplayOrder() == null || form.getDisplayOrder() < 1) {
            throw new IllegalArgumentException("노출 순서는 1 이상의 숫자로 입력해 주세요.");
        }

        LocalDate startDate = form.getStartDate();
        LocalDate endDate = form.getEndDate();
        if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("노출 종료일은 시작일보다 빠를 수 없습니다.");
        }

        SiteBanner banner = new SiteBanner();
        banner.setBannerName(bannerName);
        banner.setPosition(form.getPosition());
        banner.setImageUrl(normalizeImageUrl(form.getImageUrl()));
        banner.setLinkType(form.getLinkType());
        banner.setLinkTarget(normalizeLinkTarget(form.getLinkType(), form.getLinkTarget()));
        banner.setStartDate(startDate);
        banner.setEndDate(endDate);
        banner.setDisplayOrder(form.getDisplayOrder());
        banner.setVisible(form.isVisible());
        banner.setDescription(limit(trim(form.getDescription()), 2000, "설명은 2000자 이하로 입력해 주세요."));
        return banner;
    }

    private String normalizeImageUrl(String value) {
        String imageUrl = trim(value);
        if (imageUrl.isEmpty()) {
            throw new IllegalArgumentException("배너 이미지 URL을 입력해 주세요.");
        }
        if (imageUrl.length() > 2000) {
            throw new IllegalArgumentException("이미지 URL은 2000자 이하로 입력해 주세요.");
        }
        if (imageUrl.startsWith("/") && !imageUrl.startsWith("//") && !imageUrl.contains("\\")
                && imageUrl.chars().noneMatch(Character::isISOControl)) {
            return imageUrl;
        }
        return normalizeHttpUrl(imageUrl, "이미지 URL은 http 또는 https 주소나 사이트 내부 경로를 입력해 주세요.");
    }

    private String normalizeLinkTarget(String linkType, String value) {
        String target = trim(value);
        if ("NONE".equals(linkType)) {
            return "";
        }
        if (target.isEmpty() || target.length() > 2000) {
            throw new IllegalArgumentException("배너 연결 대상을 1자 이상 2000자 이하로 입력해 주세요.");
        }
        if ("INTERNAL".equals(linkType)) {
            if (!target.startsWith("/") || target.startsWith("//") || target.contains("\\")
                    || target.chars().anyMatch(Character::isISOControl)) {
                throw new IllegalArgumentException("내부 페이지 연결 대상은 사이트 내부 경로로 입력해 주세요.");
            }
            return target;
        }
        return normalizeHttpUrl(target, "외부 연결 대상은 http 또는 https URL로 입력해 주세요.");
    }

    private String normalizeHttpUrl(String value, String errorMessage) {
        try {
            URI uri = URI.create(value);
            if (uri.isAbsolute()
                    && ("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null
                    && uri.getUserInfo() == null) {
                return uri.toASCIIString();
            }
        } catch (IllegalArgumentException ignored) {
        }
        throw new IllegalArgumentException(errorMessage);
    }

    private String limit(String value, int maxLength, String errorMessage) {
        if (value.length() > maxLength) {
            throw new IllegalArgumentException(errorMessage);
        }
        return value;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
