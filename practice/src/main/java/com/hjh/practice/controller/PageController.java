package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import com.hjh.practice.service.site.SiteManagementService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class PageController {

    private final PageManagementService pageManagementService;
    private final MediaService mediaService;
    private final SiteManagementService siteManagementService;

    public PageController(PageManagementService pageManagementService,
                          MediaService mediaService,
                          SiteManagementService siteManagementService) {
        this.pageManagementService = pageManagementService;
        this.mediaService = mediaService;
        this.siteManagementService = siteManagementService;
    }

    @GetMapping("/pages")
    public String pages(@RequestParam(required = false) String query,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            Model model,
            HttpSession session) {
        return renderPages(query, status, null, page, model, session);
    }

    @GetMapping("/pages/{editId}")
    public String pages(@RequestParam(required = false) String query,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @PathVariable Long editId,
            Model model,
            HttpSession session) {
        return renderPages(query, status, editId, page, model, session);
    }

    @PostMapping("/pages/search")
    public String searchPages(@RequestParam(required = false) String query,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            Model model,
            HttpSession session) {
        return renderPages(query, status, null, page, model, session);
    }

    private String renderPages(String query, String status, Long editId, int page, Model model, HttpSession session) {
        String siteId = resolveSiteId(session);
        int pageSize = 10;
        int safePage = Math.max(page, 1);

        int totalCount = pageManagementService.countPages(siteId, query, status);
        int totalPages = Math.max(1, (int) Math.ceil(totalCount / (double) pageSize));
        int currentPage = Math.min(safePage, totalPages);
        int startPage = ((currentPage - 1) / 5) * 5 + 1;
        int endPage = Math.min(totalPages, startPage + 4);

        CmsPage pageForm = pageManagementService.createDraft(siteId, editId);
        CmsPage draftPage = pageManagementService.createDraft(siteId, null);

        model.addAttribute("query", query == null ? "" : query);
        model.addAttribute("status", status == null ? "" : status);
        model.addAttribute("page", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("hasPrev", currentPage > 1);
        model.addAttribute("hasNext", currentPage < totalPages);
        model.addAttribute("pageForm", pageForm);
        model.addAttribute("draftPage", draftPage);
        model.addAttribute("pageRows", pageManagementService.findPages(siteId, query, status, currentPage, pageSize));
        model.addAttribute("parentOptions", pageManagementService.findAllPages(siteId));
        model.addAttribute("mediaItems", mediaService.findMedia(siteId, null, null, null, "latest"));
        model.addAttribute("mainPageCount", pageManagementService.countMainPages(siteId));
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("publishedCount", pageManagementService.countByStatus(siteId, PageStatus.PUBLISHED));
        model.addAttribute("scheduledCount", pageManagementService.countByStatus(siteId, PageStatus.SCHEDULED));
        model.addAttribute("draftCount", pageManagementService.countByStatus(siteId, PageStatus.DRAFT));
        model.addAttribute("sites", siteManagementService.getSites());
        model.addAttribute("currentSite", siteManagementService.getSite(siteId));
        return "pages";
    }

    @PostMapping("/pages/save")
    public String savePage(CmsPage pageForm,
            @RequestParam(required = false) String returnQuery,
            @RequestParam(required = false) String returnStatus,
            @RequestParam(required = false, defaultValue = "1") int returnPage,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        boolean isNew = pageForm.getId() == null;
        CmsPage savedPage = pageManagementService.save(resolveSiteId(session), pageForm);

        redirectAttributes.addFlashAttribute("message", isNew ? "새 페이지를 등록했습니다." : "페이지를 수정했습니다.");
        redirectAttributes.addAttribute("query", returnQuery == null ? "" : returnQuery);
        redirectAttributes.addAttribute("status", returnStatus == null ? "" : returnStatus);
        redirectAttributes.addAttribute("page", returnPage);
        redirectAttributes.addAttribute("editId", savedPage.getId());
        return "redirect:/pages";
    }

    @PostMapping("/pages/delete")
    public String deletePage(@RequestParam Long id,
            @RequestParam(required = false) String returnQuery,
            @RequestParam(required = false) String returnStatus,
            @RequestParam(required = false, defaultValue = "1") int returnPage,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        pageManagementService.delete(resolveSiteId(session), id);

        redirectAttributes.addFlashAttribute("message", "페이지를 삭제했습니다.");
        redirectAttributes.addAttribute("query", returnQuery == null ? "" : returnQuery);
        redirectAttributes.addAttribute("status", returnStatus == null ? "" : returnStatus);
        redirectAttributes.addAttribute("page", returnPage);
        return "redirect:/pages";
    }

    private String resolveSiteId(HttpSession session) {
        Object selected = session.getAttribute("selectedSiteId");
        if (selected instanceof String siteId) {
            try {
                siteManagementService.getSite(siteId);
                return siteId;
            } catch (IllegalArgumentException ignored) {
            }
        }
        String defaultSiteId = siteManagementService.getSites().stream()
                .filter(com.hjh.practice.dto.site.CmsSite::isDefaultSite)
                .map(com.hjh.practice.dto.site.CmsSite::getSiteId)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("기본 사이트를 찾을 수 없습니다."));
        session.setAttribute("selectedSiteId", defaultSiteId);
        return defaultSiteId;
    }

    @ModelAttribute("statusOptions")
    public PageStatus[] statusOptions() {
        return PageStatus.values();
    }
}
