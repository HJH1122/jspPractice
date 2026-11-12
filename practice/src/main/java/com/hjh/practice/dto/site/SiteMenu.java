package com.hjh.practice.dto.site;

public class SiteMenu {

    private String menuId;
    private String menuName;
    private Integer displayOrder;
    private String parentMenuId;
    private String parentMenuName;
    private String menuType;
    private Long pageId;
    private String pageTitle;
    private String externalUrl;
    private String targetLabel;
    private boolean displayPc;
    private boolean displayMobile;
    private boolean visible;
    private boolean openNewWindow;
    private boolean firstSibling;
    private boolean lastSibling;

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getParentMenuId() {
        return parentMenuId;
    }

    public void setParentMenuId(String parentMenuId) {
        this.parentMenuId = parentMenuId;
    }

    public String getParentMenuName() {
        return parentMenuName;
    }

    public void setParentMenuName(String parentMenuName) {
        this.parentMenuName = parentMenuName;
    }

    public String getMenuType() {
        return menuType;
    }

    public void setMenuType(String menuType) {
        this.menuType = menuType;
    }

    public Long getPageId() {
        return pageId;
    }

    public void setPageId(Long pageId) {
        this.pageId = pageId;
    }

    public String getPageTitle() {
        return pageTitle;
    }

    public void setPageTitle(String pageTitle) {
        this.pageTitle = pageTitle;
    }

    public String getExternalUrl() {
        return externalUrl;
    }

    public void setExternalUrl(String externalUrl) {
        this.externalUrl = externalUrl;
    }

    public String getTargetLabel() {
        return targetLabel;
    }

    public void setTargetLabel(String targetLabel) {
        this.targetLabel = targetLabel;
    }

    public boolean isDisplayPc() {
        return displayPc;
    }

    public void setDisplayPc(boolean displayPc) {
        this.displayPc = displayPc;
    }

    public boolean isDisplayMobile() {
        return displayMobile;
    }

    public void setDisplayMobile(boolean displayMobile) {
        this.displayMobile = displayMobile;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }

    public boolean isOpenNewWindow() {
        return openNewWindow;
    }

    public void setOpenNewWindow(boolean openNewWindow) {
        this.openNewWindow = openNewWindow;
    }

    public boolean isFirstSibling() {
        return firstSibling;
    }

    public void setFirstSibling(boolean firstSibling) {
        this.firstSibling = firstSibling;
    }

    public boolean isLastSibling() {
        return lastSibling;
    }

    public void setLastSibling(boolean lastSibling) {
        this.lastSibling = lastSibling;
    }
}
