package com.hjh.practice.service.media;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.mapper.media.MediaMapper;

@Service
@Transactional
public class MediaService {

    private static final long MAX_FILE_SIZE = 50L * 1024 * 1024;
    private static final Set<String> IMAGE_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp", "svg");
    private static final Set<String> VIDEO_EXTENSIONS = Set.of("mp4", "webm", "mov", "avi");
    private static final Set<String> DOCUMENT_EXTENSIONS = Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt");

    private final MediaMapper mediaMapper;
    private final Path uploadDirectory;

    public MediaService(MediaMapper mediaMapper, @Value("${app.media.upload-dir:./uploads/media}") String uploadDirectory) {
        this.mediaMapper = mediaMapper;
        this.uploadDirectory = Paths.get(uploadDirectory).toAbsolutePath().normalize();
    }

    public List<CmsMedia> findMedia(String query, String fileType, String status) {
        return mediaMapper.selectMediaList(trim(query), trim(fileType), trim(status));
    }

    public int countMedia(String query, String fileType, String status) {
        return mediaMapper.countMedia(trim(query), trim(fileType), trim(status));
    }

    public int countByType(String fileType) {
        return mediaMapper.countByType(fileType);
    }

    public void upload(MultipartFile[] files, String title, String description, String altText, String tags,
            String status) throws IOException {
        Files.createDirectories(uploadDirectory);
        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) continue;
            validate(file);

            String originalName = sanitizeOriginalName(file.getOriginalFilename());
            String extension = extensionOf(originalName);
            String storedName = UUID.randomUUID() + "." + extension;
            Path target = uploadDirectory.resolve(storedName).normalize();
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
            }

            CmsMedia media = new CmsMedia();
            media.setOriginalFilename(originalName);
            media.setStoredFilename(storedName);
            media.setFileUrl("/media/files/" + storedName);
            media.setFileType(resolveType(extension));
            media.setFileSize(file.getSize());
            media.setTitle(blankAsDefault(title, originalName));
            media.setDescription(trim(description));
            media.setAltText(trim(altText));
            media.setTags(trim(tags));
            media.setStatus(blankAsDefault(status, "공개"));
            mediaMapper.insertMedia(media);
        }
    }

    public void update(CmsMedia media) {
        mediaMapper.updateMedia(media);
    }

    public void delete(Long id) throws IOException {
        CmsMedia media = mediaMapper.selectMediaById(id);
        if (media == null) return;
        mediaMapper.deleteMedia(id);
        Files.deleteIfExists(uploadDirectory.resolve(media.getStoredFilename()).normalize());
    }

    public Path resolveStoredFile(String storedFilename) {
        Path resolved = uploadDirectory.resolve(storedFilename).normalize();
        return resolved.startsWith(uploadDirectory) ? resolved : uploadDirectory.resolve("__invalid__");
    }

    private void validate(MultipartFile file) {
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("파일 크기는 50MB를 초과할 수 없습니다.");
        }
        String extension = extensionOf(file.getOriginalFilename());
        if (!IMAGE_EXTENSIONS.contains(extension) && !VIDEO_EXTENSIONS.contains(extension)
                && !DOCUMENT_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException("허용되지 않는 파일 형식입니다.");
        }
    }

    private String resolveType(String extension) {
        if (IMAGE_EXTENSIONS.contains(extension)) return "이미지";
        if (VIDEO_EXTENSIONS.contains(extension)) return "동영상";
        return "문서";
    }

    private String extensionOf(String filename) {
        String safeName = filename == null ? "" : filename;
        int dot = safeName.lastIndexOf('.');
        return dot < 0 ? "" : safeName.substring(dot + 1).toLowerCase(Locale.ROOT);
    }

    private String sanitizeOriginalName(String filename) {
        String safeName = filename == null ? "unnamed" : Paths.get(filename).getFileName().toString();
        return safeName.isBlank() ? "unnamed" : safeName;
    }

    private String trim(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private String blankAsDefault(String value, String fallback) {
        String trimmed = trim(value);
        return trimmed == null ? fallback : trimmed;
    }
}
