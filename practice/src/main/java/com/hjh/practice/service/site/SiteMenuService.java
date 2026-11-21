package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.SiteMenu;
import com.hjh.practice.mapper.site.SiteMenuMapper;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Service
public class SiteMenuService {

    private static final Set<String> MENU_TYPES = Set.of("PAGE", "URL", "GROUP");

    private final SiteMenuMapper siteMenuMapper;
    private final PageManagementService pageManagementService;

    public SiteMenuService(SiteMenuMapper siteMenuMapper, PageManagementService pageManagementService) {
        this.siteMenuMapper = siteMenuMapper;
        this.pageManagementService = pageManagementService;
    }

    public List<SiteMenu> getMenus(String siteId) {
        List<SiteMenu> menus = siteMenuMapper.selectMenus(siteId);
        Map<String, List<SiteMenu>> siblingsByParent = new HashMap<>();
        for (SiteMenu menu : menus) {
            String parentKey = menu.getParentMenuId() == null ? "" : menu.getParentMenuId();
            siblingsByParent.computeIfAbsent(parentKey, key -> new ArrayList<>()).add(menu);
        }
        for (List<SiteMenu> siblings : siblingsByParent.values()) {
            for (int index = 0; index < siblings.size(); index++) {
                siblings.get(index).setFirstSibling(index == 0);
                siblings.get(index).setLastSibling(index == siblings.size() - 1);
            }
        }
        return menus;
    }

    @Transactional
    public String addMenu(String siteId) {
        SiteMenu menu = new SiteMenu();
        menu.setSiteId(siteId);
        menu.setMenuId(UUID.randomUUID().toString().replace("-", ""));
        menu.setMenuName("새 메뉴");
        menu.setMenuType("GROUP");
        menu.setExternalUrl("");
        menu.setDisplayPc(true);
        menu.setDisplayMobile(true);
        menu.setVisible(true);
        menu.setOpenNewWindow(false);
        menu.setDisplayOrder(siteMenuMapper.selectMaxDisplayOrder(siteId, null) + 1);

        if (siteMenuMapper.insertMenu(siteId, menu) != 1) {
            throw new IllegalStateException("새 메뉴를 추가하지 못했습니다.");
        }
        return menu.getMenuId();
    }

    @Transactional
    public void copyMenus(String sourceSiteId, String targetSiteId) {
        List<SiteMenu> sourceMenus = siteMenuMapper.selectMenus(sourceSiteId);
        if (sourceMenus.isEmpty()) {
            addMenu(targetSiteId);
            return;
        }

        Map<String, String> copiedIds = new HashMap<>();
        for (SiteMenu source : sourceMenus) {
            copiedIds.put(source.getMenuId(), UUID.randomUUID().toString().replace("-", ""));
        }
        for (SiteMenu source : sourceMenus) {
            SiteMenu copy = new SiteMenu();
            copy.setSiteId(targetSiteId);
            copy.setMenuId(copiedIds.get(source.getMenuId()));
            copy.setMenuName(source.getMenuName());
            copy.setParentMenuId(source.getParentMenuId() == null
                    ? null
                    : copiedIds.get(source.getParentMenuId()));
            copy.setMenuType(source.getMenuType());
            copy.setPageId(source.getPageId());
            copy.setExternalUrl(source.getExternalUrl());
            copy.setDisplayPc(source.isDisplayPc());
            copy.setDisplayMobile(source.isDisplayMobile());
            copy.setVisible(source.isVisible());
            copy.setOpenNewWindow(source.isOpenNewWindow());
            copy.setDisplayOrder(source.getDisplayOrder());
            if (siteMenuMapper.insertMenu(targetSiteId, copy) != 1) {
                throw new IllegalStateException("새 사이트에 메뉴 구조를 복사하지 못했습니다.");
            }
        }
    }

    @Transactional
    public void deleteMenu(String siteId, String menuId) {
        SiteMenu menu = requireMenu(siteId, menuId);
        if (siteMenuMapper.selectMenus(siteId).size() <= 1) {
            throw new IllegalArgumentException("사이트에는 메뉴가 하나 이상 있어야 합니다.");
        }
        if (siteMenuMapper.countChildMenus(siteId, menuId) > 0) {
            throw new IllegalArgumentException("하위 메뉴가 있는 메뉴는 삭제할 수 없습니다. 하위 메뉴를 먼저 이동하거나 삭제해 주세요.");
        }
        if (siteMenuMapper.deleteMenu(siteId, menuId) != 1) {
            throw new IllegalStateException("메뉴를 삭제하지 못했습니다.");
        }
        normalizeOrder(siteId, menu.getParentMenuId());
    }

    @Transactional
    public void moveMenu(String siteId, String menuId, String direction) {
        if (!"up".equals(direction) && !"down".equals(direction)) {
            throw new IllegalArgumentException("올바른 메뉴 이동 방향이 아닙니다.");
        }

        SiteMenu selected = requireMenu(siteId, menuId);
        List<SiteMenu> siblings = siteMenuMapper.selectMenus(siteId).stream()
                .filter(menu -> sameParent(menu.getParentMenuId(), selected.getParentMenuId()))
                .toList();
        int currentIndex = -1;
        for (int index = 0; index < siblings.size(); index++) {
            if (menuId.equals(siblings.get(index).getMenuId())) {
                currentIndex = index;
                break;
            }
        }

        int targetIndex = currentIndex + ("up".equals(direction) ? -1 : 1);
        if (currentIndex < 0 || targetIndex < 0 || targetIndex >= siblings.size()) {
            throw new IllegalArgumentException("해당 방향으로 메뉴를 이동할 수 없습니다.");
        }

        SiteMenu adjacent = siblings.get(targetIndex);
        int selectedOrder = selected.getDisplayOrder();
        int adjacentOrder = adjacent.getDisplayOrder();
        if (siteMenuMapper.updateMenuOrder(siteId, menuId, adjacentOrder) != 1
                || siteMenuMapper.updateMenuOrder(siteId, adjacent.getMenuId(), selectedOrder) != 1) {
            throw new IllegalStateException("메뉴 순서를 변경하지 못했습니다.");
        }
    }

    @Transactional
    public void reorderMenus(String siteId, String menuId, List<String> orderedMenuIds) {
        SiteMenu selected = requireMenu(siteId, menuId);
        List<SiteMenu> siblings = siteMenuMapper.selectMenus(siteId).stream()
                .filter(menu -> sameParent(menu.getParentMenuId(), selected.getParentMenuId()))
                .toList();

        if (orderedMenuIds == null || orderedMenuIds.size() != siblings.size()
                || orderedMenuIds.stream().anyMatch(id -> id == null || id.isBlank())) {
            throw new IllegalArgumentException("같은 단계의 메뉴 전체를 지정해 순서를 변경해 주세요.");
        }

        Set<String> siblingIds = siblings.stream()
                .map(SiteMenu::getMenuId)
                .collect(java.util.stream.Collectors.toSet());
        Set<String> requestedIds = new HashSet<>(orderedMenuIds);
        if (requestedIds.size() != siblings.size()
                || !siblingIds.equals(requestedIds)
                || !siblingIds.contains(menuId)) {
            throw new IllegalArgumentException("서로 다른 단계의 메뉴는 함께 정렬할 수 없습니다.");
        }

        for (int index = 0; index < orderedMenuIds.size(); index++) {
            if (siteMenuMapper.updateMenuOrder(siteId, orderedMenuIds.get(index), index + 1) != 1) {
                throw new IllegalStateException("메뉴 순서를 저장하지 못했습니다.");
            }
        }
    }

    public List<SiteMenu> getParentMenuOptions(String siteId, String menuId) {
        SiteMenu selected = requireMenu(siteId, menuId);
        if (siteMenuMapper.countChildMenus(siteId, menuId) > 0) {
            return List.of();
        }
        return siteMenuMapper.selectMenus(siteId).stream()
                .filter(menu -> menu.getParentMenuId() == null)
                .filter(menu -> !menuId.equals(menu.getMenuId()))
                .toList();
    }

    @Transactional
    public void saveMenuDetails(String siteId, String menuId, SiteMenu form) {
        SiteMenu existing = siteMenuMapper.selectMenu(siteId, menuId);
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

        String parentMenuId = trim(form.getParentMenuId());
        parentMenuId = parentMenuId.isEmpty() ? null : parentMenuId;
        validateParentChange(siteId, existing, parentMenuId);
        update.setParentMenuId(parentMenuId);
        update.setDisplayOrder(sameParent(existing.getParentMenuId(), parentMenuId)
                ? existing.getDisplayOrder()
                : siteMenuMapper.selectMaxDisplayOrder(siteId, parentMenuId) + 1);

        if ("PAGE".equals(menuType)) {
            if (form.getPageId() == null || pageManagementService.findById(siteId, form.getPageId())
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

        int updatedRows = siteMenuMapper.updateMenuDetails(siteId, menuId, update);
        if (updatedRows != 1) {
            throw new IllegalStateException("메뉴 상세 설정을 저장하지 못했습니다.");
        }
        if (!sameParent(existing.getParentMenuId(), parentMenuId)) {
            normalizeOrder(siteId, existing.getParentMenuId());
        }
    }

    private void validateParentChange(String siteId, SiteMenu menu, String parentMenuId) {
        if (parentMenuId == null) {
            return;
        }
        if (menu.getMenuId().equals(parentMenuId)) {
            throw new IllegalArgumentException("자기 자신을 상위 메뉴로 지정할 수 없습니다.");
        }
        SiteMenu parent = siteMenuMapper.selectMenu(siteId, parentMenuId);
        if (parent == null || parent.getParentMenuId() != null) {
            throw new IllegalArgumentException("상위 메뉴는 최상위 메뉴만 선택할 수 있습니다.");
        }
        if (siteMenuMapper.countChildMenus(siteId, menu.getMenuId()) > 0) {
            throw new IllegalArgumentException("하위 메뉴가 있는 메뉴의 위치는 변경할 수 없습니다.");
        }
    }

    private SiteMenu requireMenu(String siteId, String menuId) {
        SiteMenu menu = siteMenuMapper.selectMenu(siteId, menuId);
        if (menu == null) {
            throw new IllegalArgumentException("메뉴를 찾을 수 없습니다.");
        }
        return menu;
    }

    private void normalizeOrder(String siteId, String parentMenuId) {
        List<SiteMenu> siblings = siteMenuMapper.selectMenus(siteId).stream()
                .filter(menu -> sameParent(menu.getParentMenuId(), parentMenuId))
                .toList();
        for (int index = 0; index < siblings.size(); index++) {
            if (siteMenuMapper.updateMenuOrder(siteId, siblings.get(index).getMenuId(), index + 1) != 1) {
                throw new IllegalStateException("메뉴 순서를 정리하지 못했습니다.");
            }
        }
    }

    private boolean sameParent(String first, String second) {
        return first == null ? second == null : first.equals(second);
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
