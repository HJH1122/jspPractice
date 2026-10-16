package com.hjh.practice.mapper.category;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.category.CmsCategory;

@Mapper
public interface CategoryMapper {

    List<CmsCategory> selectCategories();

    boolean existsBySlug(@Param("slug") String slug);

    boolean existsById(@Param("id") Long id);

    int insertCategory(CmsCategory category);
}
