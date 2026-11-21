package com.hjh.practice.mapper.site;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.site.MainPageSettings;

@Mapper
public interface MainPageSettingsMapper {

    MainPageSettings selectSettings(@Param("siteId") String siteId);

    int saveSettings(@Param("siteId") String siteId,
                     @Param("settings") MainPageSettings settings);
}
