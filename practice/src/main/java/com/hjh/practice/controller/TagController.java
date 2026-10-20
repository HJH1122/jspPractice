package com.hjh.practice.controller;

import com.hjh.practice.dto.tag.CmsTag;
import com.hjh.practice.service.tag.TagService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class TagController {

    private final TagService tagService;

    public TagController(TagService tagService) {
        this.tagService = tagService;
    }

    @GetMapping("/tags")
    public String tags(Model model) {
        model.addAttribute("tags", tagService.findTags());
        return "tags";
    }

    @PostMapping("/tags")
    public String addTag(
            @ModelAttribute("tagForm") CmsTag tag,
            RedirectAttributes redirectAttributes) {
        try {
            tagService.addTag(tag);
            redirectAttributes.addFlashAttribute("tagSuccess", "태그를 등록했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("tagError", exception.getMessage());
            redirectAttributes.addFlashAttribute("tagForm", tag);
        }
        return "redirect:/tags";
    }

    @PostMapping("/tags/{id}")
    public String updateTag(
            @PathVariable Long id,
            @ModelAttribute CmsTag tag,
            RedirectAttributes redirectAttributes) {
        try {
            tagService.updateTag(id, tag);
            redirectAttributes.addFlashAttribute("tagManageSuccess", "태그를 수정했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("tagManageError", exception.getMessage());
        }
        return "redirect:/tags";
    }

    @PostMapping("/tags/{id}/delete")
    public String deleteTag(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {
        try {
            tagService.deleteTag(id);
            redirectAttributes.addFlashAttribute("tagManageSuccess", "태그를 삭제했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("tagManageError", exception.getMessage());
        }
        return "redirect:/tags";
    }
}
