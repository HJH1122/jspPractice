package com.hjh.practice.mapper.site;

import org.apache.ibatis.annotations.Mapper;

import com.hjh.practice.dto.site.MainPageSettings;

@Mapper
public interface MainPageSettingsMapper {

    MainPageSettings selectSettings();

    int saveSettings(MainPageSettings settings);
}
