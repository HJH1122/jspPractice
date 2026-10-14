package com.hjh.practice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TagController {

    @GetMapping("/tags")
    public String tags() {
        return "tags";
    }
}
