package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class HomeController {

    private final PageManagementService pageManagementService;

    public HomeController(PageManagementService pageManagementService) {
        this.pageManagementService = pageManagementService;
    }

    @GetMapping("/")
    public String login(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            return "redirect:/main";
        }

        return "login";
    }

    @GetMapping("/main")
    public String home() {
        return "home";
    }

    @GetMapping("/posts")
    public String posts() {
        return "posts";
    }

    @GetMapping("/pages")
    public String pages(@RequestParam(required = false) String query,
                        @RequestParam(required = false) String status,
                        @RequestParam(defaultValue = "1") int page,
                        Model model) {
        return renderPages(query, status, null, page, model);
    }

    @GetMapping("/pages/{editId}")
    public String pages(@RequestParam(required = false) String query,
                        @RequestParam(required = false) String status,
                        @RequestParam(defaultValue = "1") int page,
                        @PathVariable Long editId,
                        Model model) {
        return renderPages(query, status, editId, page, model);
    }

    @PostMapping("/pages/search")
    public String searchPages(@RequestParam(required = false) String query,
                              @RequestParam(required = false) String status,
                              @RequestParam(defaultValue = "1") int page,
                              Model model) {
        return renderPages(query, status, null, page, model);
    }

    private String renderPages(String query, String status, Long editId, int page, Model model) {
        int pageSize = 10;
        int safePage = Math.max(page, 1);

        int totalCount = pageManagementService.countPages(query, status);
        int totalPages = Math.max(1, (int) Math.ceil(totalCount / (double) pageSize));
        int currentPage = Math.min(safePage, totalPages);
        int startPage = ((currentPage - 1) / 5) * 5 + 1;
        int endPage = Math.min(totalPages, startPage + 4);

        CmsPage pageForm = pageManagementService.createDraft(editId);
        CmsPage draftPage = pageManagementService.createDraft(null);

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
        model.addAttribute("pageRows", pageManagementService.findPages(query, status, currentPage, pageSize));
        model.addAttribute("parentOptions", pageManagementService.findAllPages());
        model.addAttribute("totalCount", pageManagementService.countAll());
        model.addAttribute("publishedCount", pageManagementService.countByStatus(PageStatus.PUBLISHED));
        model.addAttribute("scheduledCount", pageManagementService.countByStatus(PageStatus.SCHEDULED));
        model.addAttribute("draftCount", pageManagementService.countByStatus(PageStatus.DRAFT));
        return "pages";
    }

    @PostMapping("/pages/save")
    public String savePage(CmsPage pageForm,
                           @RequestParam(required = false) String returnQuery,
                           @RequestParam(required = false) String returnStatus,
                           @RequestParam(required = false, defaultValue = "1") int returnPage,
                           RedirectAttributes redirectAttributes) {
        boolean isNew = pageForm.getId() == null;
        CmsPage savedPage = pageManagementService.save(pageForm);

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
                             RedirectAttributes redirectAttributes) {
        pageManagementService.delete(id);

        redirectAttributes.addFlashAttribute("message", "페이지를 삭제했습니다.");
        redirectAttributes.addAttribute("query", returnQuery == null ? "" : returnQuery);
        redirectAttributes.addAttribute("status", returnStatus == null ? "" : returnStatus);
        redirectAttributes.addAttribute("page", returnPage);
        return "redirect:/pages";
    }

    @ModelAttribute("statusOptions")
    public PageStatus[] statusOptions() {
        return PageStatus.values();
    }
}