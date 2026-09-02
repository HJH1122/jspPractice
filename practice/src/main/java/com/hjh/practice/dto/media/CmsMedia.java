package com.hjh.practice.dto.media;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CmsMedia {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private Long id;
    private String originalFilename;
    private String storedFilename;
    private String fileUrl;
    private String fileType;
    private Long fileSize;
    private LocalDateTime uploadedAt;
    private String title;
    private String description;
    private String altText;
    private String tags;
    private String status;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOriginalFilename() { return originalFilename; }
    public void setOriginalFilename(String originalFilename) { this.originalFilename = originalFilename; }
    public String getStoredFilename() { return storedFilename; }
    public void setStoredFilename(String storedFilename) { this.storedFilename = storedFilename; }
    public String getFileUrl() { return fileUrl; }
    public void setFileUrl(String fileUrl) { this.fileUrl = fileUrl; }
    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }
    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
    public LocalDateTime getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(LocalDateTime uploadedAt) { this.uploadedAt = uploadedAt; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getAltText() { return altText; }
    public void setAltText(String altText) { this.altText = altText; }
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getUploadedAtDisplay() {
        return uploadedAt == null ? "-" : DATE_FORMATTER.format(uploadedAt);
    }

    public String getFileSizeDisplay() {
        if (fileSize == null || fileSize < 1024) return (fileSize == null ? 0 : fileSize) + " B";
        if (fileSize < 1024 * 1024) return String.format("%.1f KB", fileSize / 1024.0);
        return String.format("%.1f MB", fileSize / (1024.0 * 1024.0));
    }

    public String getStatusCssClass() {
        if ("공개".equals(status)) return "success";
        if ("보류".equals(status) || "검토".equals(status)) return "warning";
        return "neutral";
    }

    public String getPreviewClass() {
        if ("동영상".equals(fileType)) return "video";
        if ("문서".equals(fileType)) return "doc";
        return "";
    }
}
