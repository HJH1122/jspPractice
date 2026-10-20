package com.hjh.practice.service.tag;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.tag.CmsTag;
import com.hjh.practice.mapper.tag.TagMapper;

@Service
public class TagService {

    private static final Pattern SLUG_PATTERN = Pattern.compile("[a-z0-9]+(?:-[a-z0-9]+)*");

    private final TagMapper tagMapper;

    public TagService(TagMapper tagMapper) {
        this.tagMapper = tagMapper;
    }

    public List<CmsTag> findTags() {
        return tagMapper.selectTags();
    }

    @Transactional
    public void addTag(CmsTag tag) {
        validateAndNormalize(tag, null);
        try {
            tagMapper.insertTag(tag);
        } catch (DuplicateKeyException exception) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.", exception);
        }
    }

    @Transactional
    public void updateTag(Long id, CmsTag tag) {
        if (id == null || !tagMapper.existsById(id)) {
            throw new IllegalArgumentException("수정할 태그를 찾을 수 없습니다.");
        }

        validateAndNormalize(tag, id);
        tag.setId(id);
        try {
            if (tagMapper.updateTag(tag) == 0) {
                throw new IllegalArgumentException("수정할 태그를 찾을 수 없습니다.");
            }
        } catch (DuplicateKeyException exception) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.", exception);
        }
    }

    @Transactional
    public void deleteTag(Long id) {
        if (id == null || tagMapper.deleteTag(id) == 0) {
            throw new IllegalArgumentException("삭제할 태그를 찾을 수 없습니다.");
        }
    }

    private void validateAndNormalize(CmsTag tag, Long id) {
        if (tag == null) {
            throw new IllegalArgumentException("태그 정보를 입력해 주세요.");
        }

        String name = trim(tag.getName());
        String slug = trim(tag.getSlug());
        String description = trim(tag.getDescription());

        if (name == null) {
            throw new IllegalArgumentException("태그 이름을 입력해 주세요.");
        }
        if (name.length() > 100) {
            throw new IllegalArgumentException("태그 이름은 100자 이내로 입력해 주세요.");
        }
        if (slug == null) {
            throw new IllegalArgumentException("슬러그를 입력해 주세요.");
        }
        if (slug.length() > 100) {
            throw new IllegalArgumentException("슬러그는 100자 이내로 입력해 주세요.");
        }
        if (!SLUG_PATTERN.matcher(slug).matches()) {
            throw new IllegalArgumentException("슬러그는 영문 소문자, 숫자, 하이픈만 사용할 수 있습니다.");
        }
        if (description != null && description.length() > 500) {
            throw new IllegalArgumentException("설명은 500자 이내로 입력해 주세요.");
        }
        boolean duplicateSlug = id == null
                ? tagMapper.existsBySlug(slug)
                : tagMapper.existsBySlugExcludingId(slug, id);
        if (duplicateSlug) {
            throw new IllegalArgumentException("이미 사용 중인 슬러그입니다.");
        }

        tag.setName(name);
        tag.setSlug(slug);
        tag.setDescription(description);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
