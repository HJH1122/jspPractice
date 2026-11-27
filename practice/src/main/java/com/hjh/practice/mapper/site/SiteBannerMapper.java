package com.hjh.practice.mapper.site;

import com.hjh.practice.dto.site.SiteBanner;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SiteBannerMapper {

    List<SiteBanner> selectBanners(@Param("siteId") String siteId);

    SiteBanner selectBanner(@Param("siteId") String siteId, @Param("bannerId") Long bannerId);

    int countBanners(@Param("siteId") String siteId);

    int countVisibleBanners(@Param("siteId") String siteId);

    Integer selectMaxDisplayOrder(@Param("siteId") String siteId);

    int insertBanner(@Param("siteId") String siteId, @Param("banner") SiteBanner banner);

    int updateBanner(@Param("siteId") String siteId, @Param("banner") SiteBanner banner);

    int updateBannerVisibility(@Param("siteId") String siteId,
                               @Param("bannerId") Long bannerId,
                               @Param("visible") boolean visible);

    int deleteBanner(@Param("siteId") String siteId, @Param("bannerId") Long bannerId);
}
