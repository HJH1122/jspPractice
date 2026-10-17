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

    public List<CmsCategory> findCategories() {
        return categoryMapper.selectCategories();
    }

    public void addCategory(CmsCategory category) {
        validateAndNormalize(category, null);
        categoryMapper.insertCategory(category);
    }

    public void updateCategory(Long id, CmsCategory category) {
        if (id == null || !categoryMapper.existsById(id)) {
            throw new IllegalArgumentException("수정할 카테고리를 찾을 수 없습니다.");
        }

        category.setId(id);
        validateAndNormalize(category, id);
        if (categoryMapper.updateCategory(category) == 0) {
            throw new IllegalArgumentException("수정할 카테고리를 찾을 수 없습니다.");
        }
    }

    public void deleteCategory(Long id) {
        if (id == null || categoryMapper.deleteCategory(id) == 0) {
            throw new IllegalArgumentException("삭제할 카테고리를 찾을 수 없습니다.");
        }
    }

    private void validateAndNormalize(CmsCategory category, Long id) {
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
        boolean duplicateSlug = id == null
                ? categoryMapper.existsBySlug(slug)
                : categoryMapper.existsBySlugExcludingId(slug, id);
        if (duplicateSlug) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.");
        }
        if (category.getParentId() != null && !categoryMapper.existsById(category.getParentId())) {
            throw new IllegalArgumentException("선택한 상위 카테고리를 찾을 수 없습니다.");
        }
        if (id != null && category.getParentId() != null
                && categoryMapper.wouldCreateCycle(id, category.getParentId())) {
            throw new IllegalArgumentException("하위 카테고리를 상위 카테고리로 지정할 수 없습니다.");
        }

        category.setName(name);
        category.setSlug(slug);
        category.setDescription(trim(category.getDescription()));
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
