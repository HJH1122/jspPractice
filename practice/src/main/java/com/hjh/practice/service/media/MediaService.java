package com.hjh.practice.service.media;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.mapper.media.MediaMapper;

@Service
public class MediaService {

    private static final long MAX_FILE_SIZE = 50L * 1024 * 1024;

    private static final Set<String> IMAGE_EXTENSIONS =
            Set.of("jpg", "jpeg", "png", "gif", "webp", "svg");

    private static final Set<String> VIDEO_EXTENSIONS =
            Set.of("mp4", "webm", "mov", "avi");

    private static final Set<String> DOCUMENT_EXTENSIONS =
            Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt");

    private final MediaMapper mediaMapper;
    private final Path uploadDirectory;

    public MediaService(
            MediaMapper mediaMapper,
            @Value("${app.media.upload-dir:./uploads/media}") String uploadDirectory) {

        this.mediaMapper = mediaMapper;

        this.uploadDirectory =
                Paths.get(uploadDirectory)
                        .toAbsolutePath()
                        .normalize();
    }

    public List<CmsMedia> findMedia(
            String query,
            String fileType,
            String status) {

        return mediaMapper.selectMediaList(
                trim(query),
                trim(fileType),
                trim(status));
    }

    public int countMedia(
            String query,
            String fileType,
            String status) {

        return mediaMapper.countMedia(
                trim(query),
                trim(fileType),
                trim(status));
    }

    public int countByType(String fileType) {
        return mediaMapper.countByType(fileType);
    }

    /**
     * 파일 업로드
     *
     * DB 작업과 파일 시스템 작업의 불일치를 보완하기 위해
     * DB 트랜잭션이 롤백되면 이번 요청에서 새로 저장한 파일도 삭제한다.
     */
    @Transactional(rollbackFor = Exception.class)
    public void upload(
            MultipartFile[] files,
            String title,
            String description,
            String altText,
            String tags,
            String status) throws IOException {

        Files.createDirectories(uploadDirectory);

        // 이번 업로드 작업에서 실제로 생성한 파일 목록
        List<Path> storedFiles = new ArrayList<>();

        /*
         * 트랜잭션이 롤백될 경우 파일 시스템도 정리한다.
         *
         * 예:
         * 파일1 저장
         * 파일2 저장
         * DB INSERT
         * 파일3 처리 중 오류
         *
         * → DB ROLLBACK
         * → 파일1, 파일2 삭제
         */
        registerRollbackFileCleanup(storedFiles);

        for (MultipartFile file : files) {

            if (file == null || file.isEmpty()) {
                continue;
            }

            // 파일 크기 및 확장자 검증
            validate(file);

            // 원본 파일명 안전하게 처리
            String originalName =
                    sanitizeOriginalName(file.getOriginalFilename());

            // 확장자 추출
            String extension =
                    extensionOf(originalName);

            // 실제 저장 파일명은 UUID 사용
            String storedName =
                    UUID.randomUUID() + "." + extension;

            // 최종 저장 경로
            Path target =
                    uploadDirectory
                            .resolve(storedName)
                            .normalize();

            /*
             * 혹시라도 uploadDirectory 밖으로 나가는 경로가
             * 만들어지지 않았는지 다시 확인
             */
            if (!target.startsWith(uploadDirectory)) {
                throw new IOException("잘못된 파일 저장 경로입니다.");
            }

            // 실제 파일 저장
            try (InputStream inputStream = file.getInputStream()) {

                Files.copy(
                        inputStream,
                        target,
                        StandardCopyOption.REPLACE_EXISTING);
            }

            // 롤백 시 삭제할 파일 목록에 등록
            storedFiles.add(target);

            /*
             * DB에 저장할 미디어 정보 생성
             */
            CmsMedia media = new CmsMedia();

            media.setOriginalFilename(originalName);
            media.setStoredFilename(storedName);
            media.setFileUrl("/media/files/" + storedName);
            media.setFileType(resolveType(extension));
            media.setFileSize(file.getSize());

            media.setTitle(
                    blankAsDefault(title, originalName));

            media.setDescription(
                    trim(description));

            media.setAltText(
                    trim(altText));

            media.setTags(
                    trim(tags));

            media.setStatus(
                    blankAsDefault(status, "공개"));

            /*
             * DB INSERT
             *
             * 여기서 RuntimeException이 발생하면
             * @Transactional에 의해 DB가 롤백되고,
             * afterCompletion()에서 파일도 삭제된다.
             */
            mediaMapper.insertMedia(media);
        }
    }

    /**
     * DB 트랜잭션이 롤백될 경우
     * 이번 트랜잭션에서 생성한 파일들을 삭제한다.
     */
    private void registerRollbackFileCleanup(List<Path> storedFiles) {

        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            return;
        }

        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {

                    @Override
                    public void afterCompletion(int status) {

                        /*
                         * STATUS_ROLLED_BACK:
                         * DB 트랜잭션이 롤백된 경우
                         */
                        if (status == TransactionSynchronization.STATUS_ROLLED_BACK) {

                            for (Path path : storedFiles) {

                                try {
                                    Files.deleteIfExists(path);

                                } catch (IOException exception) {

                                    /*
                                     * 원래 DB 롤백은 이미 완료되었으므로
                                     * 여기서 예외를 다시 던질 수 없다.
                                     *
                                     * 실제 운영 환경에서는 로그를 남기는 것을 추천.
                                     */
                                    System.err.println(
                                            "롤백된 업로드 파일 삭제 실패: "
                                                    + path);

                                    exception.printStackTrace();
                                }
                            }
                        }
                    }
                });
    }

    /**
     * 미디어 정보 수정
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(CmsMedia media) {

        mediaMapper.updateMedia(media);
    }

    /**
     * 미디어 삭제
     *
     * DB 삭제와 실제 파일 삭제를 함께 처리한다.
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) throws IOException {

        CmsMedia media =
                mediaMapper.selectMediaById(id);

        if (media == null) {
            return;
        }

        /*
         * 먼저 DB에서 삭제
         */
        mediaMapper.deleteMedia(id);

        /*
         * 실제 파일 삭제
         */
        Path filePath =
                uploadDirectory
                        .resolve(media.getStoredFilename())
                        .normalize();

        /*
         * 경로 조작 방지
         */
        if (!filePath.startsWith(uploadDirectory)) {
            throw new IOException("잘못된 파일 삭제 경로입니다.");
        }

        Files.deleteIfExists(filePath);
    }

    /**
     * 저장된 파일의 실제 경로 반환
     */
    public Path resolveStoredFile(String storedFilename) {

        Path resolved =
                uploadDirectory
                        .resolve(storedFilename)
                        .normalize();

        /*
         * uploadDirectory 밖의 파일 접근 방지
         */
        return resolved.startsWith(uploadDirectory)
                ? resolved
                : uploadDirectory.resolve("__invalid__");
    }

    /**
     * 업로드 파일 검증
     */
    private void validate(MultipartFile file) {

        /*
         * 파일 크기 검증
         */
        if (file.getSize() > MAX_FILE_SIZE) {

            throw new IllegalArgumentException(
                    "파일 크기는 50MB를 초과할 수 없습니다.");
        }

        /*
         * 확장자 검증
         */
        String extension =
                extensionOf(file.getOriginalFilename());

        if (!IMAGE_EXTENSIONS.contains(extension)
                && !VIDEO_EXTENSIONS.contains(extension)
                && !DOCUMENT_EXTENSIONS.contains(extension)) {

            throw new IllegalArgumentException(
                    "허용되지 않는 파일 형식입니다.");
        }
    }

    /**
     * 파일 타입 결정
     */
    private String resolveType(String extension) {

        if (IMAGE_EXTENSIONS.contains(extension)) {
            return "이미지";
        }

        if (VIDEO_EXTENSIONS.contains(extension)) {
            return "동영상";
        }

        return "문서";
    }

    /**
     * 확장자 추출
     */
    private String extensionOf(String filename) {

        String safeName =
                filename == null ? "" : filename;

        int dot =
                safeName.lastIndexOf('.');

        if (dot < 0) {
            return "";
        }

        return safeName
                .substring(dot + 1)
                .toLowerCase(Locale.ROOT);
    }

    /**
     * 원본 파일명 정리
     */
    private String sanitizeOriginalName(String filename) {

        String safeName =
                filename == null
                        ? "unnamed"
                        : Paths.get(filename)
                                .getFileName()
                                .toString();

        return safeName.isBlank()
                ? "unnamed"
                : safeName;
    }

    /**
     * null 또는 빈 문자열이면 null 반환
     */
    private String trim(String value) {

        return value == null || value.isBlank()
                ? null
                : value.trim();
    }

    /**
     * 값이 비어 있으면 기본값 사용
     */
    private String blankAsDefault(
            String value,
            String fallback) {

        String trimmed =
                trim(value);

        return trimmed == null
                ? fallback
                : trimmed;
    }
}
