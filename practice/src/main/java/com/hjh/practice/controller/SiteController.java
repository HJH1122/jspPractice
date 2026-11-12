package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.dto.site.SiteMenu;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import com.hjh.practice.service.post.PostService;
import com.hjh.practice.service.site.MainPageSettingsService;
import com.hjh.practice.service.site.SiteMenuService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class SiteController {

    private final MainPageSettingsService settingsService;
    private final MediaService mediaService;
    private final PageManagementService pageManagementService;
    private final PostService postService;
    private final SiteMenuService siteMenuService;

    public SiteController(MainPageSettingsService settingsService,
                          MediaService mediaService,
                          PageManagementService pageManagementService,
                          PostService postService,
                          SiteMenuService siteMenuService) {
        this.settingsService = settingsService;
        this.mediaService = mediaService;
        this.pageManagementService = pageManagementService;
        this.postService = postService;
        this.siteMenuService = siteMenuService;
    }

    @GetMapping("/site/main-page")
    public String mainPage(Model model) {
        MainPageSettings settings = model.containsAttribute("settings")
                ? (MainPageSettings) model.getAttribute("settings")
                : settingsService.getSettings();
        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("visibleSectionItems", settingsService.getVisibleSections(settings.getVisibleSections()));
        model.addAttribute("mediaItems", mediaService.findMedia(null, "이미지", "공개", "latest"));
        model.addAttribute("publishedPages",
                pageManagementService.findPages(null, PageStatus.PUBLISHED.name(), 1, 500));
        model.addAttribute("publishedPosts", postService.getPostList("PUBLISHED", null, 1, 500));
        return "site-main-page";
    }

    @GetMapping("/site/menu")
    public String menuManagement() {
        String firstMenuId = siteMenuService.getMenus().stream()
                .findFirst()
                .map(SiteMenu::getMenuId)
                .orElseThrow(() -> new IllegalStateException("메뉴가 등록되어 있지 않습니다."));
        return "redirect:/site/menu/" + firstMenuId;
    }

    @PostMapping("/site/menu/add")
    public String addMenu(RedirectAttributes redirectAttributes) {
        String menuId = siteMenuService.addMenu();
        redirectAttributes.addFlashAttribute("message", "새 메뉴를 추가했습니다. 메뉴명을 설정해 주세요.");
        return "redirect:/site/menu/" + menuId;
    }

    @GetMapping("/site/menu/{menuId}")
    public String menuManagement(@PathVariable String menuId, Model model) {
        return renderMenuManagement(menuId, null, null, model);
    }

    @PostMapping("/site/menu/{menuId}")
    public String saveMenuDetails(@PathVariable String menuId,
                                  @ModelAttribute("menuForm") SiteMenu menuForm,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        try {
            siteMenuService.saveMenuDetails(menuId, menuForm);
            redirectAttributes.addFlashAttribute("message", "메뉴 상세 설정을 저장했습니다.");
            return "redirect:/site/menu/" + menuId;
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(menuId, menuForm, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/menu/{menuId}/delete")
    public String deleteMenu(@PathVariable String menuId, Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            siteMenuService.deleteMenu(menuId);
            redirectAttributes.addFlashAttribute("message", "메뉴를 삭제했습니다.");
            return menuManagement();
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(menuId, null, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/menu/{menuId}/order")
    public String moveMenu(@PathVariable String menuId,
                           @RequestParam String direction,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        try {
            siteMenuService.moveMenu(menuId, direction);
            redirectAttributes.addFlashAttribute("message", "메뉴 순서를 변경했습니다.");
            return "redirect:/site/menu/" + menuId;
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(menuId, null, exception.getMessage(), model);
        }
    }

    private String renderMenuManagement(String menuId, SiteMenu form, String error, Model model) {
        List<SiteMenu> menuItems = siteMenuService.getMenus();
        SiteMenu storedMenu = menuItems.stream()
                .filter(item -> menuId.equals(item.getMenuId()))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        SiteMenu selectedMenu = form == null ? storedMenu : form;
        selectedMenu.setMenuId(storedMenu.getMenuId());
        if (form == null) {
            selectedMenu.setParentMenuId(storedMenu.getParentMenuId());
        }
        String selectedParentId = selectedMenu.getParentMenuId();
        selectedMenu.setParentMenuName(menuItems.stream()
                .filter(item -> selectedParentId != null && selectedParentId.equals(item.getMenuId()))
                .map(SiteMenu::getMenuName)
                .findFirst()
                .orElse(null));

        model.addAttribute("menuItems", menuItems);
        model.addAttribute("totalMenuCount", menuItems.size());
        model.addAttribute("selectedMenu", selectedMenu);
        model.addAttribute("parentMenuOptions", siteMenuService.getParentMenuOptions(menuId));
        model.addAttribute("publishedPages",
                pageManagementService.findPages(null, PageStatus.PUBLISHED.name(), 1, 500));
        model.addAttribute("visibleMenuCount", menuItems.stream().filter(SiteMenu::isVisible).count());
        if (error != null) {
            model.addAttribute("error", error);
        }
        return "site-menu";
    }

    @GetMapping("/site/main-page/preview")
    public String previewMainPage(Model model, HttpServletRequest request) {
        MainPageSettings settings = settingsService.getSettings();
        List<CmsPage> featuredPages = pageManagementService.findMainPages().stream()
                .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                .limit(6)
                .toList();
        List<CmsPost> featuredPosts = postService.getMainPosts().stream()
                .filter(post -> "PUBLISHED".equals(post.getStatus()))
                .limit(6)
                .toList();
        List<CmsPost> recentPosts = postService.getPostList("PUBLISHED", null, 1, 6);

        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("visibleSectionItems", settingsService.getVisibleSections(settings.getVisibleSections()));
        model.addAttribute("featuredPages", featuredPages);
        model.addAttribute("featuredPosts", featuredPosts);
        model.addAttribute("recentPosts", recentPosts);
        model.addAttribute("buttonHref", resolveButtonHref(settings, request.getContextPath()));
        return "site-main-page-preview";
    }

    @GetMapping("/site/page/{pageId}")
    public String publishedPage(@PathVariable Long pageId, Model model) {
        CmsPage page = pageManagementService.findById(pageId)
                .filter(item -> item.getStatus() == PageStatus.PUBLISHED)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        model.addAttribute("page", page);
        return "site-page";
    }

    @PostMapping("/site/main-page/save")
    public String saveMainPage(@ModelAttribute("settings") MainPageSettings settings,
                               RedirectAttributes redirectAttributes) {
        String validationMessage = validateButtonTarget(settings);
        if (validationMessage != null) {
            redirectAttributes.addFlashAttribute("error", validationMessage);
            redirectAttributes.addFlashAttribute("settings", settings);
            return "redirect:/site/main-page";
        }

        try {
            settingsService.saveSettings(settings);
            redirectAttributes.addFlashAttribute("message", "메인페이지 설정을 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
            redirectAttributes.addFlashAttribute("settings", settings);
        }
        return "redirect:/site/main-page";
    }

    private String validateButtonTarget(MainPageSettings settings) {
        if (settings.getButtonLinkTarget() == null || settings.getButtonLinkTarget().isBlank()) {
            return null;
        }
        if ("PAGE".equals(settings.getButtonLinkType())) {
            Long pageId = parseTargetId(settings.getButtonLinkTarget());
            if (pageId == null || pageManagementService.findById(pageId)
                    .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                    .isEmpty()) {
                return "버튼으로 연결할 발행 페이지를 선택해 주세요.";
            }
        } else if ("POST".equals(settings.getButtonLinkType())) {
            Long postId = parseTargetId(settings.getButtonLinkTarget());
            CmsPost post = postId == null ? null : postService.getPostById(postId);
            if (post == null || !"PUBLISHED".equals(post.getStatus())) {
                return "버튼으로 연결할 발행 게시글을 선택해 주세요.";
            }
        } else if (!"URL".equals(settings.getButtonLinkType())) {
            return "올바른 버튼 연결 유형을 선택해 주세요.";
        }
        return null;
    }

    private Long parseTargetId(String target) {
        try {
            long id = Long.parseLong(target);
            return id > 0 ? id : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private String resolveButtonHref(MainPageSettings settings, String contextPath) {
        String target = settings.getButtonLinkTarget();
        if (target == null || target.isBlank()) {
            return "#home-content";
        }
        if ("PAGE".equals(settings.getButtonLinkType())) {
            return contextPath + "/site/page/" + target;
        }
        if ("POST".equals(settings.getButtonLinkType())) {
            return contextPath + "/posts/detail?id=" + target;
        }
        return target.startsWith("/") ? contextPath + target : target;
    }
}
