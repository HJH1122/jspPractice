package com.hjh.practice.service.post;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hjh.practice.dto.post.CmsPost;
import com.hjh.practice.mapper.post.PostMapper;

@Service
public class PostService {

    private final PostMapper postMapper;

    public PostService(PostMapper postMapper) {
        this.postMapper = postMapper;
    }

    /**
     * 게시글 목록 조회
     */
    public List<CmsPost> getPostList(
            String status,
            String query,
            int page,
            int size) {

        int offset = (page - 1) * size;

        return postMapper.selectPostList(
                status,
                query,
                size,
                offset
        );
    }

    /**
     * 검색/상태 필터가 적용된 게시글 개수
     */
    public int getPostListCount(
            String status,
            String query) {

        return postMapper.countPostList(
                status,
                query
        );
    }

    /**
     * 게시글 상세 조회
     */
    public CmsPost getPostById(Long id) {
        return postMapper.selectPostById(id);
    }

    /**
     * 게시글 등록
     */
    @Transactional
    public void createPost(CmsPost post) {

        // 조회수 기본값
        if (post.getViewCount() == null) {
            post.setViewCount(0);
        }

        // 상태가 없으면 초안
        if (post.getStatus() == null
                || post.getStatus().isBlank()) {

            post.setStatus("DRAFT");
        }

        // 발행 게시글이면 발행일시 기록
        if ("PUBLISHED".equals(post.getStatus())) {

            if (post.getPublishedAt() == null) {
                post.setPublishedAt(
                        LocalDateTime.now()
                );
            }

        } else {

            // 초안 / 예약은 일단 발행일시 없음
            post.setPublishedAt(null);
        }

        postMapper.insertPost(post);
    }

    /**
     * 게시글 수정
     */
    @Transactional
    public void updatePost(CmsPost post) {
        postMapper.updatePost(post);
    }

    /**
     * 게시글 삭제
     */
    @Transactional
    public void deletePost(Long id) {
        postMapper.deletePost(id);
    }

    /**
     * 예약 게시글 발행
     */
    @Transactional
    public void publishScheduledPost(Long id) {
        postMapper.publishScheduledPost(id);
    }

    /**
     * 전체 게시글 수
     */
    public int getTotalCount() {
        return postMapper.countAllPosts();
    }

    /**
     * 발행 게시글 수
     */
    public int getPublishedCount() {
        return postMapper.countPostsByStatus("PUBLISHED");
    }

    /**
     * 예약 게시글 수
     */
    public int getScheduledCount() {
        return postMapper.countPostsByStatus("SCHEDULED");
    }

    /**
     * 임시저장 게시글 수
     */
    public int getDraftCount() {
        return postMapper.countPostsByStatus("DRAFT");
    }

    /**
     * slug 중복 확인
     *
     * 신규 등록: excludeId = null
     * 수정: excludeId = 현재 게시글 ID
     */
    public boolean existsSlug(
            String slug,
            Long excludeId) {

        return postMapper.existsSlug(
                slug,
                excludeId
        );
    }
}