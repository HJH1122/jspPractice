package com.hjh.practice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SiteController {

    @GetMapping("/site/main-page")
    public String mainPage() {
        return "site-main-page";
    }
}
