package com.hjh.practice.service.page;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.mapper.page.PageMapper;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@Transactional
public class PageManagementService {

    private final PageMapper pageMapper;

    public PageManagementService(PageMapper pageMapper) {
        this.pageMapper = pageMapper;
    }

    @PostConstruct
    public void seedSampleData() {
        if (pageMapper.countAllPages("default") > 0) {
            return;
        }

        saveSeed("회사 소개", "about-us", "관리자", PageStatus.PUBLISHED, 1, null, LocalDateTime.now(), "회사 소개 페이지입니다.", "회사 소개 본문");
        saveSeed("서비스 안내", "services", "관리자", PageStatus.PUBLISHED, 2, null, LocalDateTime.now(), "서비스 안내 페이지입니다.", "서비스 안내 본문");
        saveSeed("문의하기", "contact", "운영팀", PageStatus.DRAFT, 3, null, null, "문의 폼 안내 페이지입니다.", "문의하기 본문");
        saveSeed("이벤트 페이지", "events", "운영팀", PageStatus.SCHEDULED, 4, null, LocalDateTime.now().plusMinutes(5), "이벤트 상세 안내 페이지입니다.", "이벤트 페이지 본문");
    }

    public List<CmsPage> findPages(String siteId, String query, String status, int page, int size) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(size, 1);
        int offset = (safePage - 1) * safeSize;
        return pageMapper.selectPageList(trimToNull(query), parseStatus(status), siteId, safeSize, offset);
    }

    public int countPages(String siteId, String query, String status) {
        return pageMapper.countPageList(trimToNull(query), parseStatus(status), siteId);
    }

    public List<CmsPage> findAllPages(String siteId) {
        return pageMapper.selectAllPages(siteId);
    }

    public Optional<CmsPage> findById(String siteId, Long id) {
        return Optional.ofNullable(pageMapper.selectPageById(siteId, id));
    }

    public CmsPage createDraft(String siteId, Long editId) {
        if (editId != null) {
            CmsPage existing = pageMapper.selectPageById(siteId, editId);
            if (existing != null) {
                return existing;
            }
        }

        CmsPage page = new CmsPage();
        page.setSiteId(siteId);
        page.setStatus(PageStatus.DRAFT);
        page.setSortOrder(nextSortOrder(siteId));
        page.setAuthor("관리자");
        return page;
    }

    public CmsPage save(String siteId, CmsPage form) {
        CmsPage existing = form.getId() == null ? null : pageMapper.selectPageById(siteId, form.getId());
        CmsPage target = existing == null ? new CmsPage() : existing;

        String title = normalizeText(form.getTitle());
        target.setTitle(title);
        target.setSlug(resolveSlug(siteId, form.getSlug(), title, target.getId()));
        target.setSummary(normalizeText(form.getSummary()));
        target.setContent(normalizeText(form.getContent()));
        target.setAuthor(defaultIfBlank(form.getAuthor(), "관리자"));
        target.setParentId(resolveParentId(siteId, form.getParentId(), target.getId()));
        target.setSortOrder(form.getSortOrder() == null ? nextSortOrder(siteId) : form.getSortOrder());
        PageStatus targetStatus = form.getStatus() == null ? PageStatus.DRAFT : form.getStatus();
        target.setStatus(targetStatus);

        if (targetStatus == PageStatus.SCHEDULED) {
            target.setPublishedAt(form.getPublishedAt() == null ? LocalDateTime.now() : form.getPublishedAt());
        } else if (targetStatus == PageStatus.PUBLISHED && (existing == null || existing.getStatus() != PageStatus.PUBLISHED)) {
            target.setPublishedAt(LocalDateTime.now());
        }

        target.setMainPage(Boolean.TRUE.equals(form.getMainPage()));

        if (existing == null) {
            target.setSiteId(siteId);
            pageMapper.insertPage(siteId, target);
            return pageMapper.selectPageById(siteId, target.getId());
        }

        pageMapper.updatePage(siteId, target);
        return pageMapper.selectPageById(siteId, target.getId());
    }

    public int publishScheduledPages() {
        int publishedCount = 0;
        for (CmsPage scheduledPage : pageMapper.selectScheduledPagesToPublish(LocalDateTime.now())) {
            publishedCount += pageMapper.publishScheduledPage(scheduledPage.getId());
        }
        return publishedCount;
    }

    public void delete(String siteId, Long id) {
        if (id != null) {
            pageMapper.deletePage(siteId, id);
        }
    }

    public int countAll(String siteId) {
        return pageMapper.countAllPages(siteId);
    }

    public int countByStatus(String siteId, PageStatus status) {
        return pageMapper.countPagesByStatus(siteId, status);
    }

    public List<CmsPage> findMainPages(String siteId) {
        return pageMapper.selectMainPages(siteId);
    }

    public int countMainPages(String siteId) {
        return pageMapper.countMainPages(siteId);
    }

    public int nextSortOrder(String siteId) {
        return pageMapper.findMaxSortOrder(siteId) + 1;
    }

    private void saveSeed(String title, String slug, String author, PageStatus status, Integer sortOrder, Long parentId, LocalDateTime publishedAt, String summary, String content) {
        CmsPage page = new CmsPage();
        page.setSiteId("default");
        page.setTitle(title);
        page.setSlug(slug);
        page.setAuthor(author);
        page.setStatus(status);
        page.setSortOrder(sortOrder);
        page.setParentId(parentId);
        page.setPublishedAt(publishedAt);
        page.setSummary(summary);
        page.setContent(content);
        pageMapper.insertPage("default", page);
    }

    private Long resolveParentId(String siteId, Long parentId, Long currentId) {
        if (parentId == null) {
            return null;
        }
        if (currentId != null && parentId.equals(currentId)) {
            return null;
        }
        return pageMapper.selectPageById(siteId, parentId) == null ? null : parentId;
    }

    private String resolveSlug(String siteId, String requestedSlug, String title, Long excludeId) {
        String baseSlug = normalizeSlug(requestedSlug);
        if (baseSlug.isEmpty()) {
            baseSlug = normalizeSlug(title);
        }
        if (baseSlug.isEmpty()) {
            baseSlug = "page";
        }

        String candidate = baseSlug;
        int suffix = 2;
        while (pageMapper.existsSlug(siteId, candidate, excludeId)) {
            candidate = baseSlug + "-" + suffix;
            suffix++;
        }

        return candidate;
    }

    private PageStatus parseStatus(String status) {
        if (status == null || status.isBlank()) {
            return null;
        }

        try {
            return PageStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeText(String value) {
        return trimToNull(value);
    }

    private String defaultIfBlank(String value, String defaultValue) {
        String trimmed = trimToNull(value);
        return trimmed == null ? defaultValue : trimmed;
    }

    private String normalizeSlug(String value) {
        String trimmed = trimToNull(value);
        if (trimmed == null) {
            return "";
        }

        return trimmed.toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9가-힣]+", "-")
                .replaceAll("^-+|-+$", "")
                .replaceAll("-+", "-");
    }
}