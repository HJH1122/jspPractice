package com.hjh.practice.service.media;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.FileStore;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import com.hjh.practice.dto.media.CmsMedia;
import com.hjh.practice.dto.media.CmsMediaUsage;
import com.hjh.practice.dto.media.MediaStorageSummary;
import com.hjh.practice.mapper.media.MediaMapper;

@Service
public class MediaService {

    private static final Logger LOGGER = Logger.getLogger(MediaService.class.getName());
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
                        String status,
                        String sortOrder) {

        return mediaMapper.selectMediaList(
                trim(query),
                trim(fileType),
                                trim(status),
                                sortOrder);
    }

    public List<CmsMediaUsage> findMediaUsages(Long mediaId) {
        CmsMedia media = findById(mediaId);
        if (media == null || media.getStoredFilename() == null) {
            return List.of();
        }
        return mediaMapper.selectMediaUsages(media.getStoredFilename());
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

    @Transactional
    public int updateMediaStatuses(List<Long> mediaIds, String status) {
        if (mediaIds == null || mediaIds.isEmpty()) {
            throw new IllegalArgumentException("상태를 변경할 파일을 선택해 주세요.");
        }
        if (status == null || !Set.of("공개", "비공개", "보류", "검토").contains(status)) {
            throw new IllegalArgumentException("변경할 상태를 올바르게 선택해 주세요.");
        }

        LinkedHashSet<Long> uniqueMediaIds = new LinkedHashSet<>();
        for (Long mediaId : mediaIds) {
            if (mediaId == null || mediaId <= 0) {
                throw new IllegalArgumentException("파일 선택 정보가 올바르지 않습니다.");
            }
            uniqueMediaIds.add(mediaId);
        }

        return mediaMapper.updateMediaStatuses(new ArrayList<>(uniqueMediaIds), status);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteSelectedMedia(List<Long> mediaIds) throws IOException {
        List<Long> uniqueMediaIds = validateMediaIds(mediaIds, "삭제할");
        List<CmsMedia> mediaItems = mediaMapper.selectMediaByIds(uniqueMediaIds);
        if (mediaItems.size() != uniqueMediaIds.size()) {
            throw new IllegalArgumentException("선택한 파일 중 일부를 찾을 수 없습니다. 목록을 새로고침해 주세요.");
        }

        for (CmsMedia media : mediaItems) {
            if (media.getStoredFilename() == null || media.getStoredFilename().isBlank()) {
                throw new IOException("파일의 저장 정보를 확인할 수 없습니다.");
            }
            if (isMediaInUse(media)) {
                throw new IllegalStateException(
                        "선택한 파일 중 콘텐츠에서 사용 중인 파일이 있습니다: " + media.getOriginalFilename());
            }
        }

        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            throw new IllegalStateException("일괄 삭제 트랜잭션을 시작할 수 없습니다.");
        }

        Path realUploadDirectory = uploadDirectory.toRealPath();
        Path stagingDirectory = Files.createTempDirectory(uploadDirectory, ".bulk-delete-");
        List<StagedFile> stagedFiles = new ArrayList<>();
        registerStagedFileCleanup(stagingDirectory, stagedFiles);

        int stagedIndex = 0;
        for (CmsMedia media : mediaItems) {
            stageFile(media.getStoredFilename(), realUploadDirectory, stagingDirectory, stagedFiles, stagedIndex++);
            if (media.getThumbnailFilename() != null && !media.getThumbnailFilename().isBlank()) {
                stageFile(media.getThumbnailFilename(), realUploadDirectory, stagingDirectory, stagedFiles, stagedIndex++);
            }
        }

        int deletedCount = mediaMapper.deleteMediaByIds(uniqueMediaIds);
        if (deletedCount != uniqueMediaIds.size()) {
            throw new IllegalStateException("선택한 파일 전체를 삭제하지 못했습니다.");
        }
        return deletedCount;
    }

    private void stageFile(
            String filename,
            Path realUploadDirectory,
            Path stagingDirectory,
            List<StagedFile> stagedFiles,
            int stagedIndex) throws IOException {
        Path sourcePath = uploadDirectory.resolve(filename).normalize();
        if (!sourcePath.startsWith(uploadDirectory) || !uploadDirectory.equals(sourcePath.getParent())) {
            throw new IOException("잘못된 파일 삭제 경로입니다.");
        }
        if (Files.notExists(sourcePath, LinkOption.NOFOLLOW_LINKS)) {
            return;
        }

        if (Files.isSymbolicLink(sourcePath)
                || !Files.isRegularFile(sourcePath, LinkOption.NOFOLLOW_LINKS)) {
            throw new IOException("일반 파일이 아닌 항목은 삭제할 수 없습니다.");
        }

        Path realSourcePath = sourcePath.toRealPath();
        if (!realSourcePath.startsWith(realUploadDirectory)) {
            throw new IOException("업로드 경로를 벗어났거나 일반 파일이 아닌 항목은 삭제할 수 없습니다.");
        }

        Path stagedPath = stagingDirectory.resolve(String.valueOf(stagedIndex));
        Files.move(sourcePath, stagedPath);
        stagedFiles.add(new StagedFile(sourcePath, stagedPath));
    }

    private boolean isMediaInUse(CmsMedia media) {
        if (!mediaMapper.selectMediaUsages(media.getStoredFilename()).isEmpty()) {
            return true;
        }
        return media.getThumbnailFilename() != null
                && !media.getThumbnailFilename().isBlank()
                && !mediaMapper.selectMediaUsages(media.getThumbnailFilename()).isEmpty();
    }

    private void registerStagedFileCleanup(Path stagingDirectory, List<StagedFile> stagedFiles) {
        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCompletion(int status) {
                if (status == TransactionSynchronization.STATUS_COMMITTED) {
                    try {
                        deleteStagingDirectory(stagingDirectory);
                    } catch (IOException exception) {
                        LOGGER.log(Level.SEVERE, "삭제 완료 후 임시 파일 정리에 실패했습니다: " + stagingDirectory, exception);
                    }
                    return;
                }

                boolean restored = true;
                for (int index = stagedFiles.size() - 1; index >= 0; index--) {
                    StagedFile stagedFile = stagedFiles.get(index);
                    try {
                        Files.move(stagedFile.stagedPath(), stagedFile.originalPath());
                    } catch (IOException exception) {
                        restored = false;
                        LOGGER.log(Level.SEVERE, "삭제 롤백 중 파일 복구에 실패했습니다: " + stagedFile.originalPath(), exception);
                    }
                }
                if (restored) {
                    try {
                        deleteStagingDirectory(stagingDirectory);
                    } catch (IOException exception) {
                        LOGGER.log(Level.SEVERE, "삭제 롤백 후 임시 폴더 정리에 실패했습니다: " + stagingDirectory, exception);
                    }
                }
            }
        });
    }

    private void deleteStagingDirectory(Path stagingDirectory) throws IOException {
        if (Files.notExists(stagingDirectory, LinkOption.NOFOLLOW_LINKS)) {
            return;
        }
        Files.walkFileTree(stagingDirectory, new SimpleFileVisitor<>() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) throws IOException {
                Files.delete(file);
                return FileVisitResult.CONTINUE;
            }

            @Override
            public FileVisitResult postVisitDirectory(Path directory, IOException exception) throws IOException {
                if (exception != null) {
                    throw exception;
                }
                Files.delete(directory);
                return FileVisitResult.CONTINUE;
            }
        });
    }

    public List<DownloadFile> prepareSelectedFilesForDownload(List<Long> mediaIds) throws IOException {
        List<Long> uniqueMediaIds = validateMediaIds(mediaIds, "다운로드할");
        List<CmsMedia> mediaItems = mediaMapper.selectMediaByIds(uniqueMediaIds);
        if (mediaItems.size() != uniqueMediaIds.size()) {
            throw new IllegalArgumentException("선택한 파일 중 일부를 찾을 수 없습니다. 목록을 새로고침해 주세요.");
        }

        Path realUploadDirectory = uploadDirectory.toRealPath();
        List<DownloadFile> downloadFiles = new ArrayList<>(mediaItems.size());
        for (CmsMedia media : mediaItems) {
            if (media.getStoredFilename() == null || media.getStoredFilename().isBlank()) {
                throw new IOException("파일의 저장 정보를 확인할 수 없습니다.");
            }

            Path filePath = resolveStoredFile(media.getStoredFilename());
            if (!Files.isRegularFile(filePath) || !Files.isReadable(filePath)) {
                throw new IOException("파일을 읽을 수 없습니다: " + media.getOriginalFilename());
            }

            Path realFilePath = filePath.toRealPath();
            if (!realFilePath.startsWith(realUploadDirectory)) {
                throw new IOException("업로드 경로를 벗어난 파일은 다운로드할 수 없습니다.");
            }

            downloadFiles.add(new DownloadFile(
                    realFilePath,
                    media.getId() + "_" + safeArchiveFilename(media.getOriginalFilename())));
        }
        return downloadFiles;
    }

    public void writeZip(List<DownloadFile> downloadFiles, OutputStream outputStream) throws IOException {
        ZipOutputStream zipOutputStream = new ZipOutputStream(outputStream);
        byte[] buffer = new byte[8192];
        for (DownloadFile downloadFile : downloadFiles) {
            zipOutputStream.putNextEntry(new ZipEntry(downloadFile.archiveFilename()));
            try (InputStream inputStream = Files.newInputStream(downloadFile.path())) {
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    zipOutputStream.write(buffer, 0, bytesRead);
                }
            }
            zipOutputStream.closeEntry();
        }
        zipOutputStream.finish();
        zipOutputStream.flush();
    }

    private List<Long> validateMediaIds(List<Long> mediaIds, String action) {
        if (mediaIds == null || mediaIds.isEmpty()) {
            throw new IllegalArgumentException(action + " 파일을 선택해 주세요.");
        }

        LinkedHashSet<Long> uniqueMediaIds = new LinkedHashSet<>();
        for (Long mediaId : mediaIds) {
            if (mediaId == null || mediaId <= 0) {
                throw new IllegalArgumentException("파일 선택 정보가 올바르지 않습니다.");
            }
            uniqueMediaIds.add(mediaId);
        }
        return new ArrayList<>(uniqueMediaIds);
    }

    private String safeArchiveFilename(String filename) {
        String normalizedFilename = filename == null ? "" : filename.replace('\\', '/');
        int lastSeparator = normalizedFilename.lastIndexOf('/');
        String basename = normalizedFilename.substring(lastSeparator + 1);
        return basename.isBlank() ? "unnamed" : basename;
    }

    public record DownloadFile(Path path, String archiveFilename) {
    }

    private record StagedFile(Path originalPath, Path stagedPath) {
    }

    public MediaStorageSummary getStorageSummary() throws IOException {
        Path existingStoragePath = uploadDirectory;
        while (existingStoragePath != null && Files.notExists(existingStoragePath)) {
            existingStoragePath = existingStoragePath.getParent();
        }
        if (existingStoragePath == null || !Files.exists(existingStoragePath)) {
            throw new IOException("미디어 저장 경로가 위치한 저장 장치를 확인할 수 없습니다.");
        }
        if (!Files.isDirectory(existingStoragePath)) {
            throw new IOException("미디어 저장 경로의 상위 경로가 디렉터리가 아닙니다.");
        }

        FileStore fileStore = Files.getFileStore(existingStoragePath);
        long[] usedSpace = {0};
        if (Files.exists(uploadDirectory)) {
            if (!Files.isDirectory(uploadDirectory)) {
                throw new IOException("미디어 저장 경로가 디렉터리가 아닙니다.");
            }
            Files.walkFileTree(uploadDirectory, new SimpleFileVisitor<>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) {
                    if (attributes.isRegularFile()) {
                        usedSpace[0] = Math.addExact(usedSpace[0], attributes.size());
                    }
                    return FileVisitResult.CONTINUE;
                }
            });
        } else if (!Files.notExists(uploadDirectory)) {
            throw new IOException("미디어 저장 경로에 접근할 수 없습니다.");
        }

        return new MediaStorageSummary(fileStore.getTotalSpace(), usedSpace[0]);
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
        int uploadedCount = 0;

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

            if ("이미지".equals(media.getFileType())) {
                Path thumbnailPath = createThumbnailImage(target, storedName);
                if (thumbnailPath != null) {
                    storedFiles.add(thumbnailPath);
                    media.setThumbnailFilename(thumbnailPath.getFileName().toString());
                    media.setThumbnailUrl("/media/files/" + thumbnailPath.getFileName());
                }
            }

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
                        int insertedRows = mediaMapper.insertMedia(media);

                        if (insertedRows != 1) {
                                throw new IllegalStateException(
                                                "미디어 정보가 DB에 저장되지 않았습니다.");
                        }

                        uploadedCount++;
                }

                if (uploadedCount == 0) {
                        throw new IllegalArgumentException(
                                        "업로드할 파일이 없습니다.");
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
        public CmsMedia findById(Long id) {

                return mediaMapper.selectMediaById(id);
        }

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

        if (isMediaInUse(media)) {
            throw new IllegalStateException(
                    "이 미디어는 게시글/페이지에서 사용 중이라 삭제할 수 없습니다.");
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

        if (media.getThumbnailFilename() != null && !media.getThumbnailFilename().isBlank()) {
            Path thumbnailPath =
                    uploadDirectory
                            .resolve(media.getThumbnailFilename())
                            .normalize();
            if (!thumbnailPath.startsWith(uploadDirectory)) {
                throw new IOException("잘못된 썸네일 삭제 경로입니다.");
            }
            Files.deleteIfExists(thumbnailPath);
        }
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

    private Path createThumbnailImage(Path sourceFile, String originalStoredName) throws IOException {
        String extension = extensionOf(originalStoredName);
        if (!"jpg".equals(extension) && !"jpeg".equals(extension) && !"png".equals(extension)
                && !"gif".equals(extension) && !"webp".equals(extension)) {
            return null;
        }

        Path thumbnailPath = uploadDirectory.resolve("thumb_" + UUID.randomUUID() + ".jpg").normalize();
        if (!thumbnailPath.startsWith(uploadDirectory)) {
            throw new IOException("잘못된 썸네일 저장 경로입니다.");
        }

        BufferedImage originalImage = ImageIO.read(sourceFile.toFile());
        if (originalImage == null) {
            return null;
        }

        int targetWidth = 320;
        int targetHeight = 220;

        BufferedImage thumbnailImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = thumbnailImage.createGraphics();
        graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, targetWidth, targetHeight);

        double scale = Math.max((double) targetWidth / originalImage.getWidth(), (double) targetHeight / originalImage.getHeight());
        int scaledWidth = (int) Math.round(originalImage.getWidth() * scale);
        int scaledHeight = (int) Math.round(originalImage.getHeight() * scale);
        int x = (targetWidth - scaledWidth) / 2;
        int y = (targetHeight - scaledHeight) / 2;
        graphics.drawImage(originalImage, x, y, scaledWidth, scaledHeight, null);
        graphics.dispose();

        ImageIO.write(thumbnailImage, "jpg", thumbnailPath.toFile());
        return thumbnailPath;
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
