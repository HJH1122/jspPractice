package com.hjh.practice.mapper.post;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.post.CmsPost;

@Mapper
public interface PostMapper {

        // 게시글 목록
        List<CmsPost> selectPostList(
                        @Param("status") String status,
                        @Param("query") String query,
                        @Param("limit") int limit,
                        @Param("offset") int offset);

        // 게시글 목록 개수
        int countPostList(
                        @Param("status") String status,
                        @Param("query") String query);

        // 게시글 상세 조회
        CmsPost selectPostById(@Param("id") Long id);

        // 게시글 등록
        int insertPost(CmsPost post);

        // 게시글 수정
        int updatePost(CmsPost post);

        // 게시글 삭제
        int deletePost(@Param("id") Long id);

        // 예약 게시글 발행
        int publishScheduledPost(
                        @Param("id") Long id);

        // 전체 게시글 수
        int countAllPosts();

        // 상태별 게시글 수
        int countPostsByStatus(@Param("status") String status);

        // slug 중복 체크
        boolean existsSlug(
                        @Param("slug") String slug,
                        @Param("excludeId") Long excludeId);

        // 전체 slug 목록 조회 (수정 폼 프런트 검증용)
        List<String> selectAllSlugs();
}