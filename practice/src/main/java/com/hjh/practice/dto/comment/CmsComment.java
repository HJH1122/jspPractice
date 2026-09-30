package com.hjh.practice.dto.comment;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CmsComment {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private Long id;
    private Long postId;
    private String author;
    private String postTitle;
    private String content;
    private String status;
    private Integer reportCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPostTitle() {
        return postTitle;
    }

    public void setPostTitle(String postTitle) {
        this.postTitle = postTitle;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getReportCount() {
        return reportCount == null ? 0 : reportCount;
    }

    public void setReportCount(Integer reportCount) {
        this.reportCount = reportCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCreatedAtDisplay() {
        return createdAt == null ? "-" : DATE_TIME_FORMATTER.format(createdAt);
    }

    public String getStatusLabel() {
        return switch (normalizeStatus(status)) {
            case "approved" -> "승인됨";
            case "hidden" -> "숨김";
            default -> "승인됨";
        };
    }

    public String getStatusClass() {
        return switch (normalizeStatus(status)) {
            case "approved" -> "success";
            case "hidden" -> "neutral";
            default -> "warning";
        };
    }

    public static String normalizeStatus(String status) {
        if (status == null) {
            return "approved";
        }
        String normalized = status.trim().toLowerCase();
        if ("approved".equals(normalized) || "승인됨".equals(status)) {
            return "approved";
        }
        if ("hidden".equals(normalized) || "숨김".equals(status)) {
            return "hidden";
        }
        return "approved";
    }
}
