package com.hjh.practice.mapper.tag;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.tag.CmsTag;

@Mapper
public interface TagMapper {

    List<CmsTag> selectTags();

    boolean existsBySlug(@Param("slug") String slug);

    int insertTag(CmsTag tag);
}
