package com.hjh.practice.service.page;

public enum PageStatus {

    DRAFT("초안", "danger"),
    PUBLISHED("발행됨", "success"),
    SCHEDULED("예약됨", "warning"),
    PRIVATE("비공개", "neutral");

    private final String label;
    private final String cssClass;

    PageStatus(String label, String cssClass) {
        this.label = label;
        this.cssClass = cssClass;
    }

    public String getLabel() {
        return label;
    }

    public String getCssClass() {
        return cssClass;
    }

    public String getValue() {
        return name();
    }
}