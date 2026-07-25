package com.hjh.practice.controller;

import com.hjh.practice.page.CmsPage;
import com.hjh.practice.page.PageManagementService;
import com.hjh.practice.page.PageStatus;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
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
                        @RequestParam(required = false) Long editId,
                        Model model) {
        CmsPage pageForm = pageManagementService.createDraft(editId);

        model.addAttribute("query", query == null ? "" : query);
        model.addAttribute("status", status == null ? "" : status);
        model.addAttribute("pageForm", pageForm);
        model.addAttribute("pageRows", pageManagementService.findPages(query, status));
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
                           RedirectAttributes redirectAttributes) {
        boolean isNew = pageForm.getId() == null;
        CmsPage savedPage = pageManagementService.save(pageForm);

        redirectAttributes.addFlashAttribute("message", isNew ? "새 페이지를 등록했습니다." : "페이지를 수정했습니다.");
        redirectAttributes.addAttribute("query", returnQuery == null ? "" : returnQuery);
        redirectAttributes.addAttribute("status", returnStatus == null ? "" : returnStatus);
        redirectAttributes.addAttribute("editId", savedPage.getId());
        return "redirect:/pages";
    }

    @PostMapping("/pages/delete")
    public String deletePage(@RequestParam Long id,
                             @RequestParam(required = false) String returnQuery,
                             @RequestParam(required = false) String returnStatus,
                             RedirectAttributes redirectAttributes) {
        pageManagementService.delete(id);

        redirectAttributes.addFlashAttribute("message", "페이지를 삭제했습니다.");
        redirectAttributes.addAttribute("query", returnQuery == null ? "" : returnQuery);
        redirectAttributes.addAttribute("status", returnStatus == null ? "" : returnStatus);
        return "redirect:/pages";
    }

    @ModelAttribute("statusOptions")
    public PageStatus[] statusOptions() {
        return PageStatus.values();
    }

}