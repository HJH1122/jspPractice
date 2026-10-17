package com.hjh.practice.controller;

import java.util.List;

import com.hjh.practice.dto.category.CmsCategory;
import com.hjh.practice.service.category.CategoryService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        List<CmsCategory> categories = categoryService.findCategories();
        model.addAttribute("categories", categories);
        model.addAttribute("parentCategories", categories);
        return "categories";
    }

    @PostMapping("/categories")
    public String addCategory(
            @ModelAttribute("categoryForm") CmsCategory category,
            RedirectAttributes redirectAttributes) {
        try {
            categoryService.addCategory(category);
            redirectAttributes.addFlashAttribute("categorySuccess", "카테고리를 등록했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("categoryError", exception.getMessage());
            redirectAttributes.addFlashAttribute("categoryForm", category);
        }
        return "redirect:/categories";
    }

    @PostMapping("/categories/{id}")
    public String updateCategory(
            @PathVariable Long id,
            @ModelAttribute CmsCategory category,
            RedirectAttributes redirectAttributes) {
        try {
            categoryService.updateCategory(id, category);
            redirectAttributes.addFlashAttribute("categoryManageSuccess", "카테고리를 수정했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("categoryManageError", exception.getMessage());
        }
        return "redirect:/categories";
    }

    @PostMapping("/categories/{id}/delete")
    public String deleteCategory(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {
        try {
            categoryService.deleteCategory(id);
            redirectAttributes.addFlashAttribute("categoryManageSuccess", "카테고리를 삭제했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("categoryManageError", exception.getMessage());
        }
        return "redirect:/categories";
    }
}
