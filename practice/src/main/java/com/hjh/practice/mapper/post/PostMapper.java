package com.hjh.practice.mapper.post;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.dto.post.CmsPostTag;

@Mapper
public interface PostMapper {

        // 게시글 목록
        List<CmsPost> selectPostList(
                        @Param("siteId") String siteId,
                        @Param("status") String status,
                        @Param("query") String query,
                        @Param("tagId") Long tagId,
                        @Param("limit") int limit,
                        @Param("offset") int offset);

        // 게시글 목록 개수
        int countPostList(
                        @Param("siteId") String siteId,
                        @Param("status") String status,
                        @Param("query") String query,
                        @Param("tagId") Long tagId);

        List<CmsPostTag> selectTagsByPostIds(@Param("postIds") List<Long> postIds);

        // 게시글 상세 조회
        CmsPost selectPostById(@Param("siteId") String siteId, @Param("id") Long id);

        // 게시글 등록
        int insertPost(@Param("siteId") String siteId, @Param("post") CmsPost post);

        // 게시글 수정
        int updatePost(@Param("siteId") String siteId, @Param("post") CmsPost post);

        List<Long> selectTagIdsByPostId(@Param("postId") Long postId);

        int deletePostTags(@Param("postId") Long postId);

        int insertPostTag(
                        @Param("postId") Long postId,
                        @Param("tagId") Long tagId);

        // 게시글 삭제
        int deletePost(@Param("siteId") String siteId, @Param("id") Long id);

        // 예약 게시글 발행
        int publishScheduledPost(
                        @Param("id") Long id);

        // 전체 게시글 수
        int countAllPosts(@Param("siteId") String siteId);

        // 상태별 게시글 수
        int countPostsByStatus(@Param("siteId") String siteId, @Param("status") String status);

        // 메인 노출 게시글 조회
        List<CmsPost> selectMainPosts(@Param("siteId") String siteId);

        int countMainPosts(@Param("siteId") String siteId);

        // slug 중복 체크
        boolean existsSlug(
                        @Param("siteId") String siteId,
                        @Param("slug") String slug,
                        @Param("excludeId") Long excludeId);

        // 전체 slug 목록 조회 (수정 폼 프런트 검증용)
        List<String> selectAllSlugs(@Param("siteId") String siteId);
}