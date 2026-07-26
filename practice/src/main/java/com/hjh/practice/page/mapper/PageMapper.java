package com.hjh.practice.page.mapper;

import com.hjh.practice.page.CmsPage;
import com.hjh.practice.page.PageStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface PageMapper {

    List<CmsPage> selectPageList(@Param("query") String query, @Param("status") PageStatus status);

    List<CmsPage> selectAllPages();

    List<CmsPage> selectScheduledPagesToPublish(@Param("now") LocalDateTime now);

    CmsPage selectPageById(@Param("id") Long id);

    int insertPage(CmsPage page);

    int updatePage(CmsPage page);

    int publishScheduledPage(@Param("id") Long id);

    int deletePage(@Param("id") Long id);

    int countAllPages();

    int countPagesByStatus(@Param("status") PageStatus status);

    Integer findMaxSortOrder();

    boolean existsSlug(@Param("slug") String slug, @Param("excludeId") Long excludeId);
}