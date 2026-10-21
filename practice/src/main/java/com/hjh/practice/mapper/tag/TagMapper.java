package com.hjh.practice.mapper.tag;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.tag.CmsTag;

@Mapper
public interface TagMapper {

    List<CmsTag> selectTags();

    boolean existsBySlug(@Param("slug") String slug);

    boolean existsBySlugExcludingId(@Param("slug") String slug, @Param("id") Long id);

    boolean existsById(@Param("id") Long id);

    int countExistingByIds(@Param("ids") List<Long> ids);

    int insertTag(CmsTag tag);

    int updateTag(CmsTag tag);

    int deleteTag(@Param("id") Long id);
}
