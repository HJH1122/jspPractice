package com.hjh.practice.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.service.media.MediaService;

@Controller
public class MediaController {

    private final MediaService mediaService;

    public MediaController(MediaService mediaService) {
        this.mediaService = mediaService;
    }

    @GetMapping("/media")
    public String media(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String fileType,
            @RequestParam(required = false) String status,
                        @RequestParam(defaultValue = "latest") String sortOrder,
                        @RequestParam(required = false) String nextSortOrder,
            Model model) {

                if ("oldest".equals(nextSortOrder) || "latest".equals(nextSortOrder)) {
                        sortOrder = nextSortOrder;
                }
                sortOrder = "oldest".equals(sortOrder) ? "oldest" : "latest";

        model.addAttribute(
                "query",
                query == null ? "" : query);

        model.addAttribute(
                "fileType",
                fileType == null ? "" : fileType);

        model.addAttribute(
                "status",
                status == null ? "" : status);

        model.addAttribute("sortOrder", sortOrder);

        model.addAttribute(
                "mediaItems",
                mediaService.findMedia(
                        query,
                        fileType,
                        status,
                        sortOrder));

        model.addAttribute(
                "totalFiles",
                mediaService.countMedia(
                        null,
                        null,
                        null));

        model.addAttribute(
                "imageFiles",
                mediaService.countByType("이미지"));

        model.addAttribute(
                "videoFiles",
                mediaService.countByType("동영상"));

        model.addAttribute(
                "documentFiles",
                mediaService.countByType("문서"));

        return "media";
    }

    /**
     * 파일 업로드
     */
    @PostMapping("/media/upload")
    public String upload(
            @RequestParam("files") MultipartFile[] files,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String altText,
            @RequestParam(required = false) String tags,
            @RequestParam(defaultValue = "공개") String status,
            RedirectAttributes redirectAttributes) {

        try {

            mediaService.upload(
                    files,
                    title,
                    description,
                    altText,
                    tags,
                    status);

            redirectAttributes.addFlashAttribute(
                    "message",
                    "미디어를 업로드했습니다.");

        } catch (IOException | RuntimeException exception) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    exception.getMessage() == null
                            ? "파일 업로드 중 오류가 발생했습니다."
                            : exception.getMessage());
        }

        return "redirect:/media";
    }

        @GetMapping("/media/{id}/edit")
        public String editForm(
                        @PathVariable Long id,
                        Model model,
                        RedirectAttributes redirectAttributes) {

                CmsMedia media = mediaService.findById(id);

                if (media == null) {
                        redirectAttributes.addFlashAttribute("error", "수정할 미디어를 찾을 수 없습니다.");
                        return "redirect:/media";
                }

                model.addAttribute("media", media);
                return "media-edit";
        }

        @PostMapping("/media/{id}/edit")
        public String update(
                        @PathVariable Long id,
                        @RequestParam(required = false) String title,
                        @RequestParam(required = false) String description,
                        @RequestParam(required = false) String altText,
                        @RequestParam(required = false) String tags,
                        @RequestParam(defaultValue = "공개") String status,
                        RedirectAttributes redirectAttributes) {

                CmsMedia media = mediaService.findById(id);

                if (media == null) {
                        redirectAttributes.addFlashAttribute("error", "수정할 미디어를 찾을 수 없습니다.");
                        return "redirect:/media";
                }

                media.setTitle(title);
                media.setDescription(description);
                media.setAltText(altText);
                media.setTags(tags);
                media.setStatus(status);
                mediaService.update(media);

                redirectAttributes.addFlashAttribute("message", "미디어 정보를 수정했습니다.");
                return "redirect:/media";
        }

    /**
     * 저장된 파일 조회
     */
    @GetMapping("/media/files/{storedFilename:.+}")
    public ResponseEntity<Resource> file(
            @PathVariable String storedFilename)
            throws IOException {

        Path path =
                mediaService.resolveStoredFile(
                        storedFilename);

        if (!Files.exists(path)
                || !Files.isRegularFile(path)) {

            return ResponseEntity
                    .notFound()
                    .build();
        }

        Resource resource =
                new UrlResource(path.toUri());

        String contentType =
                Files.probeContentType(path);

        MediaType mediaType =
                contentType == null
                        ? MediaType.APPLICATION_OCTET_STREAM
                        : MediaType.parseMediaType(contentType);

        return ResponseEntity
                .ok()
                .contentType(mediaType)
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\""
                                + storedFilename
                                + "\"")
                .body(resource);
    }

    /**
     * 미디어 원본 파일 다운로드
     */
    @GetMapping("/media/{id}/download")
    public ResponseEntity<Resource> download(
            @PathVariable Long id)
            throws IOException {

        CmsMedia media = mediaService.findById(id);

        if (media == null) {
            return ResponseEntity
                    .notFound()
                    .build();
        }

        Path path = mediaService.resolveStoredFile(media.getStoredFilename());

        if (!Files.exists(path) || !Files.isRegularFile(path)) {
            return ResponseEntity
                    .notFound()
                    .build();
        }

        Resource resource = new UrlResource(path.toUri());
        String contentType = Files.probeContentType(path);
        MediaType mediaType = contentType == null
                ? MediaType.APPLICATION_OCTET_STREAM
                : MediaType.parseMediaType(contentType);

        return ResponseEntity
                .ok()
                .contentType(mediaType)
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename*=UTF-8''"
                                + java.net.URLEncoder.encode(
                                        media.getOriginalFilename(),
                                        StandardCharsets.UTF_8)
                                        .replace("+", "%20"))
                .body(resource);
    }
}
