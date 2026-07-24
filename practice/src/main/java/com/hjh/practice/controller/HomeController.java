package com.hjh.practice.controller;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class HomeController {

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
    public String pages() {
        return "pages";
    }

}