package com.hjh.practice.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hjh.practice.service.category.CategoryService;
import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.service.comment.CommentService;
import com.hjh.practice.service.media.MediaService;
import com.hjh.practice.service.post.PostService;
import com.hjh.practice.service.tag.TagService;
import com.hjh.practice.service.site.SiteManagementService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/posts")
public class PostController {

        private final PostService postService;
        private final CategoryService categoryService;
        private final MediaService mediaService;
        private final CommentService commentService;
        private final TagService tagService;
        private final SiteManagementService siteManagementService;

        public PostController(
                        PostService postService,
                        CategoryService categoryService,
                        MediaService mediaService,
                        CommentService commentService,
                        TagService tagService,
                        SiteManagementService siteManagementService) {
                this.postService = postService;
                this.categoryService = categoryService;
                this.mediaService = mediaService;
                this.commentService = commentService;
                this.tagService = tagService;
                this.siteManagementService = siteManagementService;
        }

        @GetMapping
        public String posts(
                        @RequestParam(required = false) String status,
                        @RequestParam(required = false) String query,
                        @RequestParam(required = false) Long tagId,
                        @RequestParam(defaultValue = "1") int page,
                        @RequestParam(defaultValue = "10") int size,
                        Model model,
                        HttpSession session) {
                String siteId = resolveSiteId(session);

                int totalCount = postService.getTotalCount(siteId);
                int publishedCount = postService.getPublishedCount(siteId);
                int scheduledCount = postService.getScheduledCount(siteId);
                int draftCount = postService.getDraftCount(siteId);

                int filteredCount = postService.getPostListCount(siteId, status, query, tagId);

                var posts = postService.getPostList(
                                siteId,
                                status,
                                query,
                                tagId,
                                page,
                                size);

                int totalPages = (int) Math.ceil(
                                (double) filteredCount / size);

                // 페이지 범위
                int pageBlockSize = 5;

                int startPage = ((page - 1) / pageBlockSize)
                                * pageBlockSize + 1;

                int endPage = Math.min(
                                startPage + pageBlockSize - 1,
                                totalPages);

                boolean hasPrev = page > 1;
                boolean hasNext = page < totalPages;

                model.addAttribute("postRows", posts);
                model.addAttribute("categories", categoryService.findCategories());
                model.addAttribute("tags", tagService.findTags());

                model.addAttribute("totalCount", totalCount);
                model.addAttribute("publishedCount", publishedCount);
                model.addAttribute("scheduledCount", scheduledCount);
                model.addAttribute("draftCount", draftCount);
                model.addAttribute("mainPageCount", postService.getMainPostCount(siteId));
                model.addAttribute("sites", siteManagementService.getSites());
                model.addAttribute("currentSite", siteManagementService.getSite(siteId));

                model.addAttribute("status", status);
                model.addAttribute("query", query);
                model.addAttribute("tagId", tagId);

                var mediaItems = mediaService.findMedia(siteId, null, null, null, "latest");
                model.addAttribute("mediaItems", mediaItems);

                model.addAttribute("page", page);
                model.addAttribute("size", size);

                model.addAttribute("filteredCount", filteredCount);
                model.addAttribute("totalPages", totalPages);

                model.addAttribute("startPage", startPage);
                model.addAttribute("endPage", endPage);
                model.addAttribute("hasPrev", hasPrev);
                model.addAttribute("hasNext", hasNext);

                return "posts";
        }

        @GetMapping("/detail")
        public String detail(
                        @RequestParam("id") Long id,
                        Model model,
                        HttpSession session) {

                String siteId = resolveSiteId(session);
                var post = postService.getPostById(siteId, id);
                var comments = commentService.findCommentsByPostId(id);

                model.addAttribute("post", post);
                model.addAttribute("comments", comments);

                return "post-detail";
        }

        @PostMapping
        public String createPost(
                        @RequestParam String title,
                        @RequestParam String slug,
                        @RequestParam(required = false) String summary,
                        @RequestParam String content,
                        @RequestParam String author,
                        @RequestParam(required = false) Long categoryId,
                        @RequestParam(required = false) List<Long> tagIds,
                        @RequestParam(required = false) String thumbnailUrl,
                        @RequestParam(defaultValue = "DRAFT") String status,
                        RedirectAttributes redirectAttributes,
                        HttpSession session) {

                CmsPost post = new CmsPost();

                post.setTitle(title);
                post.setSlug(slug);
                post.setSummary(summary);
                post.setContent(content);
                post.setAuthor(author);
                post.setCategoryId(categoryId);
                post.setTagIds(tagIds);
                post.setThumbnailUrl(thumbnailUrl);
                post.setStatus(status);

                postService.createPost(resolveSiteId(session), post);

                redirectAttributes.addFlashAttribute(
                                "message",
                                "게시글이 저장되었습니다.");

                return "redirect:/posts";
        }

        @GetMapping("/edit")
        public String edit(
                        @RequestParam("id") Long id,
                        Model model,
                        HttpSession session) {

                String siteId = resolveSiteId(session);
                CmsPost post = postService.getPostById(siteId, id);
                var existingSlugs = postService.getAllSlugs(siteId);
                var mediaItems = mediaService.findMedia(siteId, null, null, null, "latest");

                model.addAttribute("post", post);
                model.addAttribute("categories", categoryService.findCategories());
                model.addAttribute("tags", tagService.findTags());
                model.addAttribute("existingSlugs", existingSlugs);
                model.addAttribute("mediaItems", mediaItems);

                return "post-edit";
        }

        @PostMapping("/edit")
        public String updatePost(
                        CmsPost post,
                        RedirectAttributes redirectAttributes,
                        HttpSession session) {

                postService.updatePost(resolveSiteId(session), post);

                redirectAttributes.addFlashAttribute(
                                "message",
                                "게시글이 수정되었습니다.");

                return "redirect:/posts/detail?id=" + post.getId();
        }

        @PostMapping("/delete")
        public String deletePost(
                        @RequestParam Long id,
                        @RequestParam(required = false) String returnQuery,
                        @RequestParam(required = false) String returnStatus,
                        @RequestParam(required = false) Long returnTagId,
                        @RequestParam(required = false, defaultValue = "1") int returnPage,
                        RedirectAttributes redirectAttributes,
                        HttpSession session) {

                postService.deletePost(resolveSiteId(session), id);

                redirectAttributes.addFlashAttribute(
                                "message",
                                "게시글이 삭제되었습니다.");

                redirectAttributes.addAttribute(
                                "query",
                                returnQuery == null ? "" : returnQuery);
                redirectAttributes.addAttribute(
                                "status",
                                returnStatus == null ? "" : returnStatus);
                redirectAttributes.addAttribute(
                                "tagId",
                                returnTagId == null ? "" : returnTagId);
                redirectAttributes.addAttribute(
                                "page",
                                returnPage);

                return "redirect:/posts";
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
}