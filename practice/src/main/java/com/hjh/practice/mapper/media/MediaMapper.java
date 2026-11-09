package com.hjh.practice.mapper.media;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.dto.media.CmsMediaUsage;

@Mapper
public interface MediaMapper {

    List<CmsMedia> selectMediaList(@Param("query") String query, @Param("fileType") String fileType,
            @Param("status") String status, @Param("sortOrder") String sortOrder);

    int countMedia(@Param("query") String query, @Param("fileType") String fileType,
            @Param("status") String status);

    int countByType(@Param("fileType") String fileType);

    int insertMedia(CmsMedia media);

    int updateMedia(CmsMedia media);

    int updateMediaStatuses(@Param("mediaIds") List<Long> mediaIds, @Param("status") String status);

    List<CmsMedia> selectMediaByIds(@Param("mediaIds") List<Long> mediaIds);

    CmsMedia selectMediaById(@Param("id") Long id);

    int deleteMedia(@Param("id") Long id);

    int deleteMediaByIds(@Param("mediaIds") List<Long> mediaIds);

    List<CmsMediaUsage> selectMediaUsages(@Param("storedFilename") String storedFilename);
}
