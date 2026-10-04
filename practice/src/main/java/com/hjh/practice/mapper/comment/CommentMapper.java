package com.hjh.practice.mapper.comment;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.hjh.practice.dto.comment.CmsComment;

@Mapper
public interface CommentMapper {

    int insertComment(CmsComment comment);

    List<CmsComment> selectCommentsByPostId(@Param("postId") Long postId);

    List<CmsComment> selectComments(
            @Param("status") String status,
            @Param("keyword") String keyword,
            @Param("reportedOnly") boolean reportedOnly);

    CmsComment selectCommentById(@Param("id") Long id);

    List<String> selectCommentReportReasons(@Param("commentId") Long commentId);

    int insertCommentReport(@Param("commentId") Long commentId, @Param("reason") String reason);

    int increaseCommentReportCount(@Param("id") Long id);

    int updateComment(CmsComment comment);

    int updateCommentStatus(@Param("id") Long id, @Param("status") String status);

    int deleteComment(@Param("id") Long id);

    int deleteCommentsByIds(@Param("ids") List<Long> ids);

    int countAllComments();

    int countCommentsByStatus(@Param("status") String status);

    int countReportedComments();
}
