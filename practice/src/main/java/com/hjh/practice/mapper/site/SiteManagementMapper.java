package com.hjh.practice.mapper.site;

import com.hjh.practice.dto.site.CmsSite;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SiteManagementMapper {

    List<CmsSite> selectSites();

    CmsSite selectSite(@Param("siteId") String siteId);

    boolean existsSiteUrl(@Param("siteUrl") String siteUrl, @Param("excludeSiteId") String excludeSiteId);

    int insertSite(CmsSite site);

    int updateSite(CmsSite site);

    int updateSiteStatus(@Param("siteId") String siteId, @Param("status") String status);

    int setDefaultSite(@Param("siteId") String siteId);

    int clearDefaultSites(@Param("excludeSiteId") String excludeSiteId);

    int countLinkedPages(@Param("siteId") String siteId);

    int countLinkedPosts(@Param("siteId") String siteId);

    int countLinkedMedia(@Param("siteId") String siteId);

    int deleteSite(@Param("siteId") String siteId);
}
