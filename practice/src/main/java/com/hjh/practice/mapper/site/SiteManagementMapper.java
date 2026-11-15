package com.hjh.practice.mapper.site;

import com.hjh.practice.dto.site.CmsSite;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SiteManagementMapper {

    List<CmsSite> selectSites();
}
