package com.hjh.practice.mapper.site;

import com.hjh.practice.dto.site.SiteMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SiteMenuMapper {

    List<SiteMenu> selectMenus();

    SiteMenu selectMenu(@Param("menuId") String menuId);

    int updateMenuDetails(@Param("menuId") String menuId, @Param("menu") SiteMenu menu);
}
