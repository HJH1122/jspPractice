package com.hjh.practice.service.category;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.hjh.practice.dto.category.CmsCategory;
import com.hjh.practice.mapper.category.CategoryMapper;

@Service
public class CategoryService {

    private static final Pattern SLUG_PATTERN = Pattern.compile("[a-z0-9]+(?:-[a-z0-9]+)*");

    private final CategoryMapper categoryMapper;

    public CategoryService(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    public List<CmsCategory> findParentCategories() {
        return categoryMapper.selectParentCategories();
    }

    public void addCategory(CmsCategory category) {
        String name = trim(category.getName());
        String slug = trim(category.getSlug());

        if (name == null) {
            throw new IllegalArgumentException("카테고리 이름을 입력해 주세요.");
        }
        if (name.length() > 100) {
            throw new IllegalArgumentException("카테고리 이름은 100자 이내로 입력해 주세요.");
        }
        if (slug == null) {
            throw new IllegalArgumentException("슬러그를 입력해 주세요.");
        }
        if (!SLUG_PATTERN.matcher(slug).matches()) {
            throw new IllegalArgumentException("슬러그는 영문 소문자, 숫자, 하이픈만 사용할 수 있습니다.");
        }
        if (slug.length() > 100) {
            throw new IllegalArgumentException("슬러그는 100자 이내로 입력해 주세요.");
        }
        if (categoryMapper.existsBySlug(slug)) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.");
        }
        if (category.getParentId() != null && !categoryMapper.existsById(category.getParentId())) {
            throw new IllegalArgumentException("선택한 상위 카테고리를 찾을 수 없습니다.");
        }

        category.setName(name);
        category.setSlug(slug);
        category.setDescription(trim(category.getDescription()));
        categoryMapper.insertCategory(category);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
