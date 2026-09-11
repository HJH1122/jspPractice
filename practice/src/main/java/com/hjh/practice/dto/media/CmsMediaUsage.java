package com.hjh.practice.dto.media;

public class CmsMediaUsage {

    private String usageType;
    private String targetTypeLabel;
    private Long targetId;
    private String targetTitle;
    private String targetSlug;
    private String targetStatus;
    private String targetUrl;

    public String getUsageType() {
        return usageType;
    }

    public void setUsageType(String usageType) {
        this.usageType = usageType;
    }

    public String getTargetTypeLabel() {
        return targetTypeLabel;
    }

    public void setTargetTypeLabel(String targetTypeLabel) {
        this.targetTypeLabel = targetTypeLabel;
    }

    public Long getTargetId() {
        return targetId;
    }

    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }

    public String getTargetTitle() {
        return targetTitle;
    }

    public void setTargetTitle(String targetTitle) {
        this.targetTitle = targetTitle;
    }

    public String getTargetSlug() {
        return targetSlug;
    }

    public void setTargetSlug(String targetSlug) {
        this.targetSlug = targetSlug;
    }

    public String getTargetStatus() {
        return targetStatus;
    }

    public void setTargetStatus(String targetStatus) {
        this.targetStatus = targetStatus;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }
}
