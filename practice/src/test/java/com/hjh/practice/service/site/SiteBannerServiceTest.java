package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.SiteBanner;
import com.hjh.practice.mapper.site.SiteBannerMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class SiteBannerServiceTest {

    private SiteBannerMapper mapper;
    private SiteBannerService service;

    @BeforeEach
    void setUp() {
        mapper = mock(SiteBannerMapper.class);
        service = new SiteBannerService(mapper);
    }

    @Test
    void saveBannerPersistsNormalizedSiteScopedBanner() {
        SiteBanner form = validBanner();
        form.setBannerName("  Promotion  ");
        form.setLinkType("INTERNAL");
        form.setLinkTarget("/pages/promotion");
        when(mapper.insertBanner(eq("site-a"), any(SiteBanner.class))).thenReturn(1);

        service.saveBanner("site-a", form);

        verify(mapper).insertBanner(eq("site-a"), org.mockito.ArgumentMatchers.argThat(banner ->
                "Promotion".equals(banner.getBannerName())
                        && "/pages/promotion".equals(banner.getLinkTarget())
                        && "site-a".equals(banner.getSiteId())));
    }

    @Test
    void saveBannerRejectsUnsafeImageUrlBeforePersistence() {
        SiteBanner form = validBanner();
        form.setImageUrl("javascript:alert(1)");

        assertThrows(IllegalArgumentException.class, () -> service.saveBanner("site-a", form));

        verify(mapper, never()).insertBanner(eq("site-a"), any(SiteBanner.class));
    }

    @Test
    void saveBannerRejectsEndDateBeforeStartDate() {
        SiteBanner form = validBanner();
        form.setStartDate(LocalDate.of(2026, 12, 2));
        form.setEndDate(LocalDate.of(2026, 12, 1));

        assertThrows(IllegalArgumentException.class, () -> service.saveBanner("site-a", form));

        verify(mapper, never()).insertBanner(eq("site-a"), any(SiteBanner.class));
    }

    private SiteBanner validBanner() {
        SiteBanner banner = new SiteBanner();
        banner.setBannerName("Promotion");
        banner.setPosition("MAIN_TOP");
        banner.setImageUrl("/uploads/banner.png");
        banner.setLinkType("NONE");
        banner.setDisplayOrder(1);
        banner.setVisible(true);
        return banner;
    }
}
