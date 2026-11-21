package com.hjh.practice.mapper.site;

import com.hjh.practice.dto.site.SiteMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SiteMenuMapper {

    List<SiteMenu> selectMenus(@Param("siteId") String siteId);

    SiteMenu selectMenu(@Param("siteId") String siteId, @Param("menuId") String menuId);

    int updateMenuDetails(@Param("siteId") String siteId,
                          @Param("menuId") String menuId,
                          @Param("menu") SiteMenu menu);

    int insertMenu(@Param("siteId") String siteId, @Param("menu") SiteMenu menu);

    Integer selectMaxDisplayOrder(@Param("siteId") String siteId,
                                  @Param("parentMenuId") String parentMenuId);

    int updateMenuOrder(@Param("siteId") String siteId,
                        @Param("menuId") String menuId,
                        @Param("displayOrder") int displayOrder);

    int countChildMenus(@Param("siteId") String siteId, @Param("menuId") String menuId);

    int deleteMenu(@Param("siteId") String siteId, @Param("menuId") String menuId);
}
