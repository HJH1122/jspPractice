package com.hjh.practice.service.page;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PagePublishScheduler {

    private final PageManagementService pageManagementService;

    public PagePublishScheduler(PageManagementService pageManagementService) {
        this.pageManagementService = pageManagementService;
    }

    @Scheduled(fixedDelay = 60000)
    @Transactional
    public void publishDuePages() {
        pageManagementService.publishScheduledPages();
    }
}