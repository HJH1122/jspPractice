package com.hjh.practice.controller;

import com.hjh.practice.dto.category.CmsCategory;
import com.hjh.practice.service.category.CategoryService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
        model.addAttribute("parentCategories", categoryService.findParentCategories());
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
}
