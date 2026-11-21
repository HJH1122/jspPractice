package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.CmsSite;
import com.hjh.practice.mapper.site.SiteManagementMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URI;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
public class SiteManagementService {

    private static final Set<String> SITE_STATUSES = Set.of("ACTIVE", "INACTIVE");

    private final SiteManagementMapper siteManagementMapper;
    private final SiteMenuService siteMenuService;
    private final MainPageSettingsService mainPageSettingsService;

    public SiteManagementService(SiteManagementMapper siteManagementMapper,
                                 SiteMenuService siteMenuService,
                                 MainPageSettingsService mainPageSettingsService) {
        this.siteManagementMapper = siteManagementMapper;
        this.siteMenuService = siteMenuService;
        this.mainPageSettingsService = mainPageSettingsService;
    }

    public List<CmsSite> getSites() {
        return siteManagementMapper.selectSites();
    }

    public CmsSite getSite(String siteId) {
        CmsSite site = siteManagementMapper.selectSite(siteId);
        if (site == null) {
            throw new IllegalArgumentException("수정할 사이트를 찾을 수 없습니다.");
        }
        return site;
    }

    @Transactional
    public void createSite(CmsSite form) {
        String templateSiteId = getSites().stream()
                .filter(CmsSite::isDefaultSite)
                .map(CmsSite::getSiteId)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("기본 사이트를 찾을 수 없습니다."));
        CmsSite site = normalizeAndValidate(form, null);
        site.setSiteId(UUID.randomUUID().toString().replace("-", ""));
        saveSite(site, true);
        siteMenuService.copyMenus(templateSiteId, site.getSiteId());
        mainPageSettingsService.copySettings(templateSiteId, site.getSiteId());
    }

    @Transactional
    public void updateSite(String siteId, CmsSite form) {
        getSite(siteId);
        CmsSite site = normalizeAndValidate(form, siteId);
        site.setSiteId(siteId);
        saveSite(site, false);
    }

    @Transactional
    public String changeSiteStatus(String siteId, String status) {
        CmsSite site = getSite(siteId);
        if (status == null || !SITE_STATUSES.contains(status)) {
            throw new IllegalArgumentException("올바른 운영 상태를 선택해 주세요.");
        }
        if (status.equals(site.getStatus())) {
            throw new IllegalArgumentException("사이트가 이미 선택한 운영 상태입니다.");
        }
        if (siteManagementMapper.updateSiteStatus(siteId, status) != 1) {
            throw new IllegalStateException("사이트 운영 상태를 변경하지 못했습니다.");
        }
        return status;
    }

    @Transactional
    public void designateDefaultSite(String siteId) {
        CmsSite site = getSite(siteId);
        if (site.isDefaultSite()) {
            return;
        }

        siteManagementMapper.clearDefaultSites(siteId);
        if (siteManagementMapper.setDefaultSite(siteId) != 1) {
            throw new IllegalStateException("기본 사이트를 지정하지 못했습니다.");
        }
    }

    private CmsSite normalizeAndValidate(CmsSite form, String excludeSiteId) {
        String siteName = trim(form.getSiteName());
        if (siteName.isEmpty() || siteName.length() > 100) {
            throw new IllegalArgumentException("사이트명은 1자 이상 100자 이하로 입력해 주세요.");
        }

        String siteUrl = normalizeSiteUrl(form.getSiteUrl());
        if (!siteUrl.isEmpty() && siteManagementMapper.existsSiteUrl(siteUrl, excludeSiteId)) {
            throw new IllegalArgumentException("이미 등록된 사이트 주소입니다.");
        }

        String status = form.getStatus();
        if (status == null || !SITE_STATUSES.contains(status)) {
            throw new IllegalArgumentException("사이트 운영 상태를 선택해 주세요.");
        }

        CmsSite site = new CmsSite();
        site.setSiteName(siteName);
        site.setSiteUrl(siteUrl);
        site.setStatus(status);
        site.setDefaultSite(form.isDefaultSite());
        return site;
    }

    private void saveSite(CmsSite site, boolean create) {
        if (site.isDefaultSite()) {
            siteManagementMapper.clearDefaultSites(site.getSiteId());
        }
        int affectedRows = create
                ? siteManagementMapper.insertSite(site)
                : siteManagementMapper.updateSite(site);
        if (affectedRows != 1) {
            throw new IllegalStateException(create ? "사이트를 등록하지 못했습니다." : "사이트 정보를 수정하지 못했습니다.");
        }
    }

    private String normalizeSiteUrl(String value) {
        String siteUrl = trim(value);
        if (siteUrl.isEmpty()) {
            return "";
        }
        if (siteUrl.length() > 500) {
            throw new IllegalArgumentException("사이트 주소는 500자 이하로 입력해 주세요.");
        }

        try {
            URI uri = URI.create(siteUrl);
            if (uri.isAbsolute()
                    && ("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null
                    && uri.getUserInfo() == null) {
                return uri.toASCIIString();
            }
        } catch (IllegalArgumentException ignored) {
        }
        throw new IllegalArgumentException("사이트 주소는 http 또는 https URL로 입력해 주세요.");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
