package com.hjh.practice.controller;

import com.hjh.practice.dto.page.CmsPage;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.dto.site.CmsSite;
import com.hjh.practice.dto.site.MainPageSettings;
import com.hjh.practice.dto.site.SiteMenu;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.page.PageManagementService;
import com.hjh.practice.service.page.PageStatus;
import com.hjh.practice.service.post.PostService;
import com.hjh.practice.service.site.MainPageSettingsService;
import com.hjh.practice.service.site.SiteManagementService;
import com.hjh.practice.service.site.SiteMenuService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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
    private final SiteManagementService siteManagementService;
    private final SiteMenuService siteMenuService;

    public SiteController(MainPageSettingsService settingsService,
                          MediaService mediaService,
                          PageManagementService pageManagementService,
                          PostService postService,
                          SiteManagementService siteManagementService,
                          SiteMenuService siteMenuService) {
        this.settingsService = settingsService;
        this.mediaService = mediaService;
        this.pageManagementService = pageManagementService;
        this.postService = postService;
        this.siteManagementService = siteManagementService;
        this.siteMenuService = siteMenuService;
    }

    @GetMapping("/site/main-page")
    public String mainPage() {
        return "redirect:/site/" + defaultSiteId() + "/main-page";
    }

    @GetMapping("/site/{siteId}/main-page")
    public String mainPage(@PathVariable String siteId, Model model, HttpSession session) {
        CmsSite currentSite = requireSite(siteId);
        session.setAttribute("selectedSiteId", siteId);
        MainPageSettings settings = model.containsAttribute("settings")
                ? (MainPageSettings) model.getAttribute("settings")
                : settingsService.getSettings(siteId);
        model.addAttribute("sites", siteManagementService.getSites());
        model.addAttribute("currentSite", currentSite);
        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("visibleSectionItems", settingsService.getVisibleSections(settings.getVisibleSections()));
        model.addAttribute("mediaItems", mediaService.findMedia(siteId, null, "이미지", "공개", "latest"));
        model.addAttribute("publishedPages",
                pageManagementService.findPages(siteId, null, PageStatus.PUBLISHED.name(), 1, 500));
        model.addAttribute("publishedPosts", postService.getPostList(siteId, "PUBLISHED", null, 1, 500));
        return "site-main-page";
    }

    @GetMapping("/site/management")
    public String siteManagement(Model model) {
        CmsSite siteForm = new CmsSite();
        siteForm.setStatus("ACTIVE");
        return renderSiteManagement(siteForm, false, null, model);
    }

    @PostMapping("/site/select/{siteId}")
    public String selectSite(@PathVariable String siteId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes,
                             @RequestParam(required = false, defaultValue = "/main") String returnUrl) {
        try {
            CmsSite site = siteManagementService.getSite(siteId);
            session.setAttribute("selectedSiteId", site.getSiteId());
            redirectAttributes.addFlashAttribute("message", site.getSiteName() + " 사이트를 선택했습니다.");
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        if (!returnUrl.startsWith("/") || returnUrl.startsWith("//")) {
            returnUrl = "/main";
        }
        return "redirect:" + returnUrl;
    }

    @GetMapping("/site/management/new")
    public String newSite(Model model) {
        CmsSite siteForm = new CmsSite();
        siteForm.setStatus("ACTIVE");
        return renderSiteManagement(siteForm, false, null, model);
    }

    @GetMapping("/site/management/{siteId}")
    public String editSite(@PathVariable String siteId, Model model) {
        try {
            return renderSiteManagement(siteManagementService.getSite(siteId), true, null, model);
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/site/management/register")
    public String createSite(@ModelAttribute("siteForm") CmsSite siteForm,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            siteManagementService.createSite(siteForm);
            redirectAttributes.addFlashAttribute("message", "사이트를 등록했습니다.");
            return "redirect:/site/management";
        } catch (IllegalArgumentException exception) {
            return renderSiteManagement(siteForm, false, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/management/{siteId}")
    public String updateSite(@PathVariable String siteId,
                             @ModelAttribute("siteForm") CmsSite siteForm,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            siteManagementService.updateSite(siteId, siteForm);
            redirectAttributes.addFlashAttribute("message", "사이트 정보를 수정했습니다.");
            return "redirect:/site/management";
        } catch (IllegalArgumentException exception) {
            if (siteManagementService.getSites().stream().noneMatch(site -> siteId.equals(site.getSiteId()))) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND);
            }
            siteForm.setSiteId(siteId);
            return renderSiteManagement(siteForm, true, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/management/{siteId}/status")
    public String changeSiteStatus(@PathVariable String siteId,
                                   @RequestParam String status,
                                   RedirectAttributes redirectAttributes) {
        try {
            String updatedStatus = siteManagementService.changeSiteStatus(siteId, status);
            redirectAttributes.addFlashAttribute("message",
                    "사이트를 " + ("ACTIVE".equals(updatedStatus) ? "운영 중으로" : "운영 중지로") + " 변경했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
        }
        return "redirect:/site/management";
    }

    @PostMapping("/site/management/{siteId}/default")
    public String designateDefaultSite(@PathVariable String siteId,
                                       RedirectAttributes redirectAttributes) {
        try {
            siteManagementService.designateDefaultSite(siteId);
            redirectAttributes.addFlashAttribute("message", "기본 사이트를 변경했습니다.");
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        return "redirect:/site/management";
    }

    @PostMapping("/site/management/{siteId}/delete")
    public String deleteSite(@PathVariable String siteId, RedirectAttributes redirectAttributes) {
        try {
            siteManagementService.deleteSite(siteId);
            redirectAttributes.addFlashAttribute("message", "사이트를 삭제했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
        }
        return "redirect:/site/management";
    }

    private String renderSiteManagement(CmsSite siteForm, boolean editingSite, String error, Model model) {
        List<CmsSite> sites = siteManagementService.getSites();
        long activeSiteCount = sites.stream()
                .filter(site -> "ACTIVE".equals(site.getStatus()))
                .count();
        model.addAttribute("sites", sites);
        model.addAttribute("siteCount", sites.size());
        model.addAttribute("activeSiteCount", activeSiteCount);
        model.addAttribute("inactiveSiteCount", sites.size() - activeSiteCount);
        model.addAttribute("siteForm", siteForm);
        model.addAttribute("editingSite", editingSite);
        model.addAttribute("siteFormAction", editingSite
                ? "/site/management/" + siteForm.getSiteId()
                : "/site/management/register");
        if (error != null) {
            model.addAttribute("error", error);
        }
        return "site-management";
    }

    @GetMapping("/site/menu")
    public String menuManagement() {
        return "redirect:/site/" + defaultSiteId() + "/menu";
    }

    @GetMapping("/site/banner")
    public String bannerManagement() {
        return "redirect:/site/" + defaultSiteId() + "/banner";
    }

    @GetMapping("/site/{siteId}/banner")
    public String bannerManagement(@PathVariable String siteId, Model model, HttpSession session) {
        CmsSite currentSite = requireSite(siteId);
        session.setAttribute("selectedSiteId", siteId);
        model.addAttribute("sites", siteManagementService.getSites());
        model.addAttribute("currentSite", currentSite);
        return "site-banner";
    }

    @GetMapping("/site/{siteId}/menu")
    public String menuManagement(@PathVariable String siteId) {
        requireSite(siteId);
        List<SiteMenu> menus = siteMenuService.getMenus(siteId);
        if (menus.isEmpty()) {
            siteMenuService.addMenu(siteId);
            menus = siteMenuService.getMenus(siteId);
        }
        String firstMenuId = menus.stream()
                .findFirst()
                .map(SiteMenu::getMenuId)
                .orElseThrow(() -> new IllegalStateException("메뉴가 등록되어 있지 않습니다."));
        return "redirect:/site/" + siteId + "/menu/" + firstMenuId;
    }

    @PostMapping("/site/{siteId}/menu/add")
    public String addMenu(@PathVariable String siteId, RedirectAttributes redirectAttributes) {
        requireSite(siteId);
        String menuId = siteMenuService.addMenu(siteId);
        redirectAttributes.addFlashAttribute("message", "새 메뉴를 추가했습니다. 메뉴명을 설정해 주세요.");
        return "redirect:/site/" + siteId + "/menu/" + menuId;
    }

    @GetMapping("/site/{siteId}/menu/{menuId}")
    public String menuManagement(@PathVariable String siteId, @PathVariable String menuId, Model model) {
        return renderMenuManagement(siteId, menuId, null, null, model);
    }

    @PostMapping("/site/{siteId}/menu/{menuId}")
    public String saveMenuDetails(@PathVariable String siteId,
                                  @PathVariable String menuId,
                                  @ModelAttribute("menuForm") SiteMenu menuForm,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        try {
            siteMenuService.saveMenuDetails(siteId, menuId, menuForm);
            redirectAttributes.addFlashAttribute("message", "메뉴 상세 설정을 저장했습니다.");
            return "redirect:/site/" + siteId + "/menu/" + menuId;
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(siteId, menuId, menuForm, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/{siteId}/menu/{menuId}/delete")
    public String deleteMenu(@PathVariable String siteId,
                             @PathVariable String menuId, Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            siteMenuService.deleteMenu(siteId, menuId);
            redirectAttributes.addFlashAttribute("message", "메뉴를 삭제했습니다.");
            return menuManagement(siteId);
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(siteId, menuId, null, exception.getMessage(), model);
        }
    }

    @PostMapping("/site/{siteId}/menu/{menuId}/order")
    public String moveMenu(@PathVariable String siteId,
                           @PathVariable String menuId,
                           @RequestParam(required = false) String direction,
                           @RequestParam(required = false) List<String> menuIds,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        try {
            if (menuIds != null) {
                siteMenuService.reorderMenus(siteId, menuId, menuIds);
            } else {
                siteMenuService.moveMenu(siteId, menuId, direction);
            }
            redirectAttributes.addFlashAttribute("message", "메뉴 순서를 변경했습니다.");
            return "redirect:/site/" + siteId + "/menu/" + menuId;
        } catch (IllegalArgumentException exception) {
            return renderMenuManagement(siteId, menuId, null, exception.getMessage(), model);
        }
    }

    private String renderMenuManagement(String siteId, String menuId, SiteMenu form, String error, Model model) {
        CmsSite currentSite = requireSite(siteId);
        List<SiteMenu> menuItems = siteMenuService.getMenus(siteId);
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
        model.addAttribute("sites", siteManagementService.getSites());
        model.addAttribute("currentSite", currentSite);
        model.addAttribute("totalMenuCount", menuItems.size());
        model.addAttribute("selectedMenu", selectedMenu);
        model.addAttribute("parentMenuOptions", siteMenuService.getParentMenuOptions(siteId, menuId));
        model.addAttribute("publishedPages",
                pageManagementService.findPages(siteId, null, PageStatus.PUBLISHED.name(), 1, 500));
        model.addAttribute("visibleMenuCount", menuItems.stream().filter(SiteMenu::isVisible).count());
        if (error != null) {
            model.addAttribute("error", error);
        }
        return "site-menu";
    }

    @GetMapping("/site/main-page/preview")
    public String legacyPreviewMainPage() {
        return "redirect:/site/" + defaultSiteId() + "/main-page/preview";
    }

    @GetMapping("/site/{siteId}/main-page/preview")
    public String previewMainPage(@PathVariable String siteId, Model model, HttpServletRequest request) {
        requireSite(siteId);
        MainPageSettings settings = settingsService.getSettings(siteId);
        List<CmsPage> featuredPages = pageManagementService.findMainPages(siteId).stream()
                .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                .limit(6)
                .toList();
        List<CmsPost> featuredPosts = postService.getMainPosts(siteId).stream()
                .filter(post -> "PUBLISHED".equals(post.getStatus()))
                .limit(6)
                .toList();
        List<CmsPost> recentPosts = postService.getPostList(siteId, "PUBLISHED", null, 1, 6);

        model.addAttribute("settings", settings);
        model.addAttribute("sectionOrderItems", settingsService.getOrderedSections(settings.getSectionOrder()));
        model.addAttribute("visibleSectionItems", settingsService.getVisibleSections(settings.getVisibleSections()));
        model.addAttribute("featuredPages", featuredPages);
        model.addAttribute("featuredPosts", featuredPosts);
        model.addAttribute("recentPosts", recentPosts);
        model.addAttribute("buttonHref", resolveButtonHref(siteId, settings, request.getContextPath()));
        return "site-main-page-preview";
    }

    @GetMapping("/site/page/{pageId}")
    public String publishedPageLegacy(@PathVariable Long pageId) {
        return "redirect:/site/" + defaultSiteId() + "/page/" + pageId;
    }

    @GetMapping("/site/{siteId}/page/{pageId}")
    public String publishedPage(@PathVariable String siteId,
                                @PathVariable Long pageId,
                                Model model) {
        requireSite(siteId);
        CmsPage page = pageManagementService.findById(siteId, pageId)
                .filter(item -> item.getStatus() == PageStatus.PUBLISHED)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        model.addAttribute("page", page);
        return "site-page";
    }

    @GetMapping("/site/{siteId}/posts/detail")
    public String publishedPost(@PathVariable String siteId,
                               @RequestParam Long id,
                               Model model) {
        requireSite(siteId);
        CmsPost post = postService.getPostById(siteId, id);
        if (post == null || !"PUBLISHED".equals(post.getStatus())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        model.addAttribute("post", post);
        model.addAttribute("comments", java.util.List.of());
        return "post-detail";
    }

    @PostMapping("/site/{siteId}/main-page/save")
    public String saveMainPage(@PathVariable String siteId,
                               @ModelAttribute("settings") MainPageSettings settings,
                               RedirectAttributes redirectAttributes) {
        requireSite(siteId);
        String validationMessage = validateButtonTarget(siteId, settings);
        if (validationMessage != null) {
            redirectAttributes.addFlashAttribute("error", validationMessage);
            redirectAttributes.addFlashAttribute("settings", settings);
            return "redirect:/site/" + siteId + "/main-page";
        }

        try {
            settingsService.saveSettings(siteId, settings);
            redirectAttributes.addFlashAttribute("message", "메인페이지 설정을 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
            redirectAttributes.addFlashAttribute("settings", settings);
        }
        return "redirect:/site/" + siteId + "/main-page";
    }

    private CmsSite requireSite(String siteId) {
        try {
            return siteManagementService.getSite(siteId);
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    private String defaultSiteId() {
        return siteManagementService.getSites().stream()
                .filter(CmsSite::isDefaultSite)
                .map(CmsSite::getSiteId)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("기본 사이트를 찾을 수 없습니다."));
    }

    private String validateButtonTarget(String siteId, MainPageSettings settings) {
        if (settings.getButtonLinkTarget() == null || settings.getButtonLinkTarget().isBlank()) {
            return null;
        }
        if ("PAGE".equals(settings.getButtonLinkType())) {
            Long pageId = parseTargetId(settings.getButtonLinkTarget());
            if (pageId == null || pageManagementService.findById(siteId, pageId)
                    .filter(page -> page.getStatus() == PageStatus.PUBLISHED)
                    .isEmpty()) {
                return "버튼으로 연결할 발행 페이지를 선택해 주세요.";
            }
        } else if ("POST".equals(settings.getButtonLinkType())) {
            Long postId = parseTargetId(settings.getButtonLinkTarget());
            CmsPost post = postId == null ? null : postService.getPostById(siteId, postId);
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

    private String resolveButtonHref(String siteId, MainPageSettings settings, String contextPath) {
        String target = settings.getButtonLinkTarget();
        if (target == null || target.isBlank()) {
            return "#home-content";
        }
        if ("PAGE".equals(settings.getButtonLinkType())) {
            return contextPath + "/site/" + siteId + "/page/" + target;
        }
        if ("POST".equals(settings.getButtonLinkType())) {
            return contextPath + "/site/" + siteId + "/posts/detail?id=" + target;
        }
        return target.startsWith("/") ? contextPath + target : target;
    }
}
