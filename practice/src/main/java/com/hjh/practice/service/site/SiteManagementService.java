package com.hjh.practice.service.site;

import com.hjh.practice.dto.site.CmsSite;
import com.hjh.practice.mapper.site.SiteManagementMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SiteManagementService {

    private final SiteManagementMapper siteManagementMapper;

    public SiteManagementService(SiteManagementMapper siteManagementMapper) {
        this.siteManagementMapper = siteManagementMapper;
    }

    public List<CmsSite> getSites() {
        return siteManagementMapper.selectSites();
    }
}
