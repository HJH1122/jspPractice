package com.hjh.practice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.service.post.PostService;


@Controller
@RequestMapping("/posts")
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping
    public String posts(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        int totalCount = postService.getTotalCount();
        int publishedCount = postService.getPublishedCount();
        int scheduledCount = postService.getScheduledCount();
        int draftCount = postService.getDraftCount();

        int filteredCount =
                postService.getPostListCount(status, query);

        var posts =
                postService.getPostList(
                        status,
                        query,
                        page,
                        size
                );

        int totalPages =
                (int) Math.ceil(
                        (double) filteredCount / size
                );

        // 페이지 범위
        int pageBlockSize = 5;

        int startPage =
                ((page - 1) / pageBlockSize)
                        * pageBlockSize + 1;

        int endPage =
                Math.min(
                        startPage + pageBlockSize - 1,
                        totalPages
                );

        boolean hasPrev = page > 1;
        boolean hasNext = page < totalPages;

        model.addAttribute("postRows", posts);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("publishedCount", publishedCount);
        model.addAttribute("scheduledCount", scheduledCount);
        model.addAttribute("draftCount", draftCount);

        model.addAttribute("status", status);
        model.addAttribute("query", query);

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
            Model model) {

        var post = postService.getPostById(id);

        model.addAttribute("post", post);

        return "post-detail";
    }
    
    @PostMapping
    public String createPost(
            @RequestParam String title,
            @RequestParam String slug,
            @RequestParam(required = false) String summary,
            @RequestParam String content,
            @RequestParam String author,
            @RequestParam(required = false) String thumbnailUrl,
            @RequestParam(defaultValue = "DRAFT") String status,
            RedirectAttributes redirectAttributes) {


        CmsPost post = new CmsPost();

        post.setTitle(title);
        post.setSlug(slug);
        post.setSummary(summary);
        post.setContent(content);
        post.setAuthor(author);
        post.setThumbnailUrl(thumbnailUrl);
        post.setStatus(status);


        postService.createPost(post);

        redirectAttributes.addFlashAttribute(
                "message",
                "게시글이 저장되었습니다."
        );

        return "redirect:/posts";
    }

    @GetMapping("/edit")
    public String edit(
            @RequestParam("id") Long id,
            Model model) {

        CmsPost post = postService.getPostById(id);

        model.addAttribute("post", post);

        return "post-edit";
    }

    @PostMapping("/edit")
    public String updatePost(
            CmsPost post,
            RedirectAttributes redirectAttributes) {

        postService.updatePost(post);

        redirectAttributes.addFlashAttribute(
                "message",
                "게시글이 수정되었습니다."
        );

        return "redirect:/posts/detail?id=" + post.getId();
    }
}