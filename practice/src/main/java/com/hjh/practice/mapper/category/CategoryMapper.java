package com.hjh.practice.mapper.category;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.category.CmsCategory;

@Mapper
public interface CategoryMapper {

    List<CmsCategory> selectCategories();

    boolean existsBySlug(@Param("slug") String slug);

    boolean existsBySlugExcludingId(@Param("slug") String slug, @Param("id") Long id);

    boolean existsById(@Param("id") Long id);

    boolean wouldCreateCycle(@Param("id") Long id, @Param("parentId") Long parentId);

    int insertCategory(CmsCategory category);

    int updateCategory(CmsCategory category);

    int deleteCategory(@Param("id") Long id);
}
