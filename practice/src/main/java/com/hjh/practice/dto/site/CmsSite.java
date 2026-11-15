package com.hjh.practice.dto.site;

public class CmsSite {

    private String siteId;
    private String siteName;
    private String siteUrl;
    private String status;
    private boolean defaultSite;

    public String getSiteId() {
        return siteId;
    }

    public void setSiteId(String siteId) {
        this.siteId = siteId;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getSiteUrl() {
        return siteUrl;
    }

    public void setSiteUrl(String siteUrl) {
        this.siteUrl = siteUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isDefaultSite() {
        return defaultSite;
    }

    public void setDefaultSite(boolean defaultSite) {
        this.defaultSite = defaultSite;
    }
}
