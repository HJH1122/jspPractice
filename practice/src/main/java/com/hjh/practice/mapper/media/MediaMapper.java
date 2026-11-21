package com.hjh.practice.mapper.media;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.dto.media.CmsMediaUsage;

@Mapper
public interface MediaMapper {

    List<CmsMedia> selectMediaList(@Param("siteId") String siteId, @Param("query") String query, @Param("fileType") String fileType,
            @Param("status") String status, @Param("sortOrder") String sortOrder);

    int countMedia(@Param("siteId") String siteId, @Param("query") String query, @Param("fileType") String fileType,
            @Param("status") String status);

    int countByType(@Param("siteId") String siteId, @Param("fileType") String fileType);

    int insertMedia(@Param("siteId") String siteId, @Param("media") CmsMedia media);

    int updateMedia(@Param("siteId") String siteId, @Param("media") CmsMedia media);

    int updateMediaStatuses(@Param("siteId") String siteId, @Param("mediaIds") List<Long> mediaIds, @Param("status") String status);

    List<CmsMedia> selectMediaByIds(@Param("siteId") String siteId, @Param("mediaIds") List<Long> mediaIds);

    CmsMedia selectMediaById(@Param("siteId") String siteId, @Param("id") Long id);

    int deleteMedia(@Param("siteId") String siteId, @Param("id") Long id);

    int deleteMediaByIds(@Param("siteId") String siteId, @Param("mediaIds") List<Long> mediaIds);

    List<CmsMediaUsage> selectMediaUsages(@Param("siteId") String siteId,
                                          @Param("storedFilename") String storedFilename);
}
