package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.SiteMenu;
import com.hjh.practice.mapper.site.SiteMenuMapper;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URI;
import java.util.List;
import java.util.Set;

@Service
public class SiteMenuService {

    private static final Set<String> MENU_TYPES = Set.of("PAGE", "URL", "GROUP");

    private final SiteMenuMapper siteMenuMapper;
    private final PageManagementService pageManagementService;

    public SiteMenuService(SiteMenuMapper siteMenuMapper, PageManagementService pageManagementService) {
        this.siteMenuMapper = siteMenuMapper;
        this.pageManagementService = pageManagementService;
    }

    public List<SiteMenu> getMenus() {
        return siteMenuMapper.selectMenus();
    }

    @Transactional
    public void saveMenuDetails(String menuId, SiteMenu form) {
        SiteMenu existing = siteMenuMapper.selectMenu(menuId);
        if (existing == null) {
            throw new IllegalArgumentException("수정할 메뉴를 찾을 수 없습니다.");
        }

        String menuName = trim(form.getMenuName());
        if (menuName.isEmpty() || menuName.length() > 100) {
            throw new IllegalArgumentException("메뉴명은 1자 이상 100자 이하로 입력해 주세요.");
        }

        String menuType = form.getMenuType();
        if (menuType == null || !MENU_TYPES.contains(menuType)) {
            throw new IllegalArgumentException("올바른 메뉴 유형을 선택해 주세요.");
        }

        SiteMenu update = new SiteMenu();
        update.setMenuName(menuName);
        update.setMenuType(menuType);
        update.setDisplayPc(form.isDisplayPc());
        update.setDisplayMobile(form.isDisplayMobile());
        update.setVisible(form.isVisible());

        if ("PAGE".equals(menuType)) {
            if (form.getPageId() == null || pageManagementService.findById(form.getPageId())
                    .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                    .isEmpty()) {
                throw new IllegalArgumentException("연결할 발행 페이지를 선택해 주세요.");
            }
            update.setPageId(form.getPageId());
            update.setExternalUrl("");
        } else if ("URL".equals(menuType)) {
            update.setPageId(null);
            update.setExternalUrl(normalizeExternalUrl(form.getExternalUrl()));
            update.setOpenNewWindow(form.isOpenNewWindow());
        } else {
            update.setPageId(null);
            update.setExternalUrl("");
            update.setOpenNewWindow(false);
        }

        int updatedRows = siteMenuMapper.updateMenuDetails(menuId, update);
        if (updatedRows != 1) {
            throw new IllegalStateException("메뉴 상세 설정을 저장하지 못했습니다.");
        }
    }

    private String normalizeExternalUrl(String value) {
        String url = trim(value);
        if (url.isEmpty() || url.length() > 2000) {
            throw new IllegalArgumentException("외부 링크 주소를 1자 이상 2000자 이하로 입력해 주세요.");
        }
        try {
            URI uri = URI.create(url);
            if (uri.isAbsolute()
                    && ("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null) {
                return uri.toASCIIString();
            }
        } catch (IllegalArgumentException ignored) {
        }
        throw new IllegalArgumentException("외부 링크는 http 또는 https 주소를 입력해 주세요.");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
