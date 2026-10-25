package com.hjh.practice.dto.site;

public class MainPageSettings {

    private String bannerTitle;
    private String bannerDescription;
    private String bannerImageUrl;
    private String buttonLinkType;

    public String getBannerTitle() {
        return bannerTitle;
    }

    public void setBannerTitle(String bannerTitle) {
        this.bannerTitle = bannerTitle;
    }

    public String getBannerDescription() {
        return bannerDescription;
    }

    public void setBannerDescription(String bannerDescription) {
        this.bannerDescription = bannerDescription;
    }

    public String getBannerImageUrl() {
        return bannerImageUrl;
    }

    public void setBannerImageUrl(String bannerImageUrl) {
        this.bannerImageUrl = bannerImageUrl;
    }

    public String getButtonLinkType() {
        return buttonLinkType;
    }

    public void setButtonLinkType(String buttonLinkType) {
        this.buttonLinkType = buttonLinkType;
    }
}
