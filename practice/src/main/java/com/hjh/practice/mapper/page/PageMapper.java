package com.hjh.practice.mapper.page;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.service.page.PageStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface PageMapper {

    List<CmsPage> selectAllPages(@Param("siteId") String siteId);

    List<CmsPage> selectScheduledPagesToPublish(@Param("now") LocalDateTime now);

    CmsPage selectPageById(@Param("siteId") String siteId, @Param("id") Long id);

    int insertPage(@Param("siteId") String siteId, @Param("page") CmsPage page);

    int updatePage(@Param("siteId") String siteId, @Param("page") CmsPage page);

    int publishScheduledPage(@Param("id") Long id);

    int deletePage(@Param("siteId") String siteId, @Param("id") Long id);

    int countAllPages(@Param("siteId") String siteId);

    int countPagesByStatus(@Param("siteId") String siteId, @Param("status") PageStatus status);

    List<CmsPage> selectMainPages(@Param("siteId") String siteId);

    int countMainPages(@Param("siteId") String siteId);

    Integer findMaxSortOrder(@Param("siteId") String siteId);

    boolean existsSlug(@Param("siteId") String siteId, @Param("slug") String slug, @Param("excludeId") Long excludeId);

    List<CmsPage> selectPageList(@Param("query") String query,
                             @Param("status") PageStatus status,
                             @Param("siteId") String siteId,
                             @Param("limit") int limit,
                             @Param("offset") int offset);

    int countPageList(@Param("query") String query,
                       @Param("status") PageStatus status,
                       @Param("siteId") String siteId);
}