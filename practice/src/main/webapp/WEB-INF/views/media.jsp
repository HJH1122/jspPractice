<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>미디어 관리</title>
    <style>
        :root {
            --bg: #f0f0f1;
            --panel: #ffffff;
            --sidebar: #1d2327;
            --sidebar-2: #23282d;
            --accent: #2271b1;
            --accent-soft: #e8f1fb;
            --text: #1d2327;
            --muted: #646970;
            --border: #dcdcde;
            --success: #00a32a;
            --warning: #dba617;
            --danger: #d63638;
            --neutral: #6d6d6d;
            --shadow: rgba(0, 0, 0, 0.04);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        a { text-decoration: none; }

        .layout {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 240px 1fr;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar-2) 100%);
            color: #fff;
            padding: 24px 0;
        }

        .brand {
            padding: 0 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .brand-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .brand-subtitle {
            margin: 6px 0 0;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
        }

        .menu { padding: 16px 0; }

        .menu-item {
            display: block;
            padding: 14px 24px;
            color: rgba(255, 255, 255, 0.82);
            font-size: 14px;
            border-left: 4px solid transparent;
        }

        .menu-item.active,
        .menu-item:hover {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            border-left-color: var(--accent);
        }

        .content { padding: 24px; }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
        }

        .page-title {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .page-desc {
            margin: 8px 0 0;
            color: var(--muted);
            font-size: 14px;
        }

        .toolbar {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            padding: 0 16px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .button.primary {
            background: var(--accent);
            border-color: var(--accent);
            color: #fff;
        }

        .button.ghost {
            background: var(--accent-soft);
            border-color: rgba(34, 113, 177, 0.18);
            color: var(--accent);
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 1px 2px var(--shadow);
        }

        .stat-label {
            margin: 0 0 10px;
            color: var(--muted);
            font-size: 13px;
        }

        .stat-value {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .stat-note {
            margin: 10px 0 0;
            font-size: 12px;
            color: var(--muted);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .section-title {
            margin: 0;
            font-size: 18px;
        }

        .section-desc {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
        }

        .controls {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 16px;
        }

        .upload-panel {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr 1fr;
            gap: 12px;
            padding: 16px;
            margin-bottom: 16px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fafafa;
        }

        .upload-panel input,
        .upload-panel select {
            width: 100%;
            min-height: 40px;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 9px 10px;
            background: #fff;
            color: var(--text);
            font-size: 13px;
        }

        .upload-panel .file-input { grid-column: span 2; }

        .notice {
            padding: 12px 14px;
            margin-bottom: 16px;
            border: 1px solid rgba(0, 163, 42, 0.2);
            border-radius: 8px;
            background: rgba(0, 163, 42, 0.08);
            color: var(--success);
            font-size: 13px;
        }

        .notice.error {
            border-color: rgba(214, 54, 56, 0.2);
            background: rgba(214, 54, 56, 0.08);
            color: var(--danger);
        }

        .filters input,
        .filters select,
        .field input,
        .field select,
        .field textarea {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 11px 12px;
            font-size: 14px;
            background: #fff;
            color: var(--text);
        }

        .search-box {
            min-width: 240px;
            flex: 1;
        }

        .table-wrap {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fff;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .table th,
        .table td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .table th {
            color: var(--muted);
            font-weight: 600;
            background: #fafafa;
        }

        .file-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .thumb {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background: linear-gradient(135deg, #eef5ff 0%, #f8f9fb 100%);
            position: relative;
            overflow: hidden;
            flex-shrink: 0;
        }

        .thumb::before {
            content: "";
            position: absolute;
            inset: 9px;
            border-radius: 8px;
            background: linear-gradient(135deg, rgba(34,113,177,0.9), rgba(34,113,177,0.2));
        }

        .thumb.video::before {
            background: linear-gradient(135deg, rgba(67, 160, 71, 0.9), rgba(67, 160, 71, 0.25));
        }

        .thumb.doc::before {
            background: linear-gradient(135deg, rgba(166, 132, 0, 0.9), rgba(166, 132, 0, 0.2));
        }

        .file-name {
            font-weight: 600;
            color: var(--text);
        }

        .meta {
            color: var(--muted);
            font-size: 12px;
            margin-top: 4px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        .badge.success {
            background: rgba(0, 163, 42, 0.12);
            color: var(--success);
        }

        .badge.warning {
            background: rgba(219, 166, 23, 0.14);
            color: #8a6d00;
        }

        .badge.neutral {
            background: rgba(100, 105, 112, 0.12);
            color: var(--neutral);
        }

        .media-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .media-card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 2px var(--shadow);
        }

        .media-preview {
            height: 160px;
            background: linear-gradient(135deg, #edf5ff, #f8f9fb);
            border-bottom: 1px solid var(--border);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .media-preview img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .media-preview .placeholder {
            position: relative;
            z-index: 1;
            display: grid;
            place-items: center;
            width: 58px;
            height: 58px;
            border-radius: 50%;
            background: rgba(34, 113, 177, 0.14);
            color: var(--accent);
            font-size: 12px;
            font-weight: 700;
        }

        .media-preview::before {
            content: "";
            position: absolute;
            inset: 24px 32px;
            border-radius: 12px;
            background: linear-gradient(135deg, rgba(34,113,177,0.18), rgba(34,113,177,0.04));
        }

        .media-preview::after {
            content: "";
            position: absolute;
            width: 52px;
            height: 52px;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            border-radius: 50%;
            background: rgba(34,113,177,0.12);
        }

        .media-card:nth-child(2n) .media-preview {
            background: linear-gradient(135deg, #f8f5ff, #f9fafb);
        }

        .media-card:nth-child(2n) .media-preview::before {
            background: linear-gradient(135deg, rgba(118, 92, 255, 0.16), rgba(118, 92, 255, 0.04));
        }

        .media-card:nth-child(3n) .media-preview {
            background: linear-gradient(135deg, #f5fff8, #f9fafb);
        }

        .media-card:nth-child(3n) .media-preview::before {
            background: linear-gradient(135deg, rgba(1, 151, 95, 0.14), rgba(1, 151, 95, 0.04));
        }

        .media-info {
            padding: 14px;
        }

        .media-file-name {
            margin: 0;
            font-size: 15px;
            font-weight: 700;
        }

        .media-meta {
            margin: 8px 0 0;
            font-size: 12px;
            color: var(--muted);
        }

        .media-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
        }

        .mini-tag {
            display: inline-flex;
            align-items: center;
            height: 24px;
            padding: 0 8px;
            border-radius: 999px;
            background: rgba(34, 113, 177, 0.08);
            color: var(--accent);
            font-size: 11px;
            font-weight: 700;
        }

        .icon-button {
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            border-radius: 8px;
            padding: 6px 10px;
            font-size: 12px;
            cursor: pointer;
        }

        @media (max-width: 1100px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
            }

            .summary,
            .media-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            .summary,
            .media-grid {
                grid-template-columns: 1fr;
            }

            .content {
                padding: 16px;
            }

            .topbar,
            .panel-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .upload-panel { grid-template-columns: 1fr; }
            .upload-panel .file-input { grid-column: auto; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/media" var="mediaUrl"/>
<c:url value="/media/upload" var="uploadUrl"/>

<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title">Practice CMS</h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>

        <nav class="menu">
            <a class="menu-item" href="/main">대시보드</a>
            <a class="menu-item" href="/pages">페이지</a>
            <a class="menu-item" href="/posts">게시글</a>
            <a class="menu-item active" href="/media">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">미디어 관리</h2>
                <p class="page-desc">업로드된 이미지, 영상, 문서를 관리하고 배치합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mainUrl}">대시보드로 이동</a>
                <a class="button primary" href="#upload-form">새 미디어 추가</a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="notice"><c:out value="${message}" /></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="notice error"><c:out value="${error}" /></div>
        </c:if>

        <section class="summary">
            <div class="card">
                <p class="stat-label">전체 파일</p>
                <p class="stat-value">${totalFiles}</p>
                <p class="stat-note">라이브러리 누적 수</p>
            </div>
            <div class="card">
                <p class="stat-label">이미지</p>
                <p class="stat-value">${imageFiles}</p>
                <p class="stat-note">메인 배너 및 썸네일</p>
            </div>
            <div class="card">
                <p class="stat-label">동영상</p>
                <p class="stat-value">${videoFiles}</p>
                <p class="stat-note">홍보 및 소개 영상</p>
            </div>
            <div class="card">
                <p class="stat-label">문서</p>
                <p class="stat-value">${documentFiles}</p>
                <p class="stat-note">설명자료 및 자료집</p>
            </div>
        </section>

        <section class="card">
            <div class="panel-header">
                <div>
                    <h3 class="section-title">파일 목록</h3>
                    <p class="section-desc">최근 업로드된 항목과 상태를 함께 확인할 수 있습니다.</p>
                </div>
                <div class="controls">
                    <button class="button ghost" type="button">필터</button>
                    <button class="button" type="button">정렬: 최신순</button>
                </div>
            </div>

            <form id="upload-form" class="upload-panel" action="${uploadUrl}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input class="file-input" type="file" name="files" multiple required accept="image/*,video/*,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt" aria-label="업로드 파일" />
                <input type="text" name="title" placeholder="제목 (선택)" aria-label="미디어 제목" />
                <input type="text" name="altText" placeholder="대체 텍스트 (선택)" aria-label="대체 텍스트" />
                <input type="text" name="tags" placeholder="태그 (선택)" aria-label="태그" />
                <input type="text" name="description" placeholder="설명 (선택)" aria-label="설명" />
                <select name="status" aria-label="공개 상태">
                    <option value="공개">공개</option>
                    <option value="비공개">비공개</option>
                    <option value="보류">보류</option>
                    <option value="검토">검토</option>
                </select>
                <button class="button primary" type="submit">파일 업로드</button>
            </form>

            <form class="filters" action="${mediaUrl}" method="get">
                <div class="search-box">
                    <input type="text" name="query" value="${query}" placeholder="파일명 또는 제목 검색" aria-label="파일 검색" />
                </div>
                <select name="fileType" aria-label="미디어 유형">
                    <option value="">모든 유형</option>
                    <option value="이미지" ${fileType == '이미지' ? 'selected' : ''}>이미지</option>
                    <option value="동영상" ${fileType == '동영상' ? 'selected' : ''}>동영상</option>
                    <option value="문서" ${fileType == '문서' ? 'selected' : ''}>문서</option>
                </select>
                <select name="status" aria-label="업로드 상태">
                    <option value="">모든 상태</option>
                    <option value="공개" ${status == '공개' ? 'selected' : ''}>공개</option>
                    <option value="비공개" ${status == '비공개' ? 'selected' : ''}>비공개</option>
                    <option value="보류" ${status == '보류' ? 'selected' : ''}>보류</option>
                    <option value="검토" ${status == '검토' ? 'selected' : ''}>검토</option>
                </select>
                <button class="button primary" type="submit">검색</button>
            </form>

            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th>파일</th>
                        <th>유형</th>
                        <th>크기</th>
                        <th>업로드일</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${mediaItems}" var="item">
                        <tr>
                            <td>
                                <div class="file-cell">
                                    <div class="thumb ${item.previewClass}">
                                        <c:if test="${item.fileType == '이미지'}">
                                            <img src="${item.fileUrl}" alt="${item.altText}" onerror="this.style.display='none'" />
                                        </c:if>
                                    </div>
                                    <div>
                                        <div class="file-name"><c:out value="${item.originalFilename}" /></div>
                                        <div class="meta">제목: <c:out value="${item.title}" /></div>
                                    </div>
                                </div>
                            </td>
                            <td><c:out value="${item.fileType}" /></td>
                            <td><c:out value="${item.fileSizeDisplay}" /></td>
                            <td><c:out value="${item.uploadedAtDisplay}" /></td>
                            <td>
                                <span class="badge ${item.statusCssClass}">
                                    <c:out value="${item.status}" />
                                </span>
                            </td>
                            <td>
                                <button class="icon-button" type="button">편집</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="media-grid">
                <c:forEach items="${mediaItems}" var="item">
                    <div class="media-card">
                        <div class="media-preview">
                            <c:choose>
                                <c:when test="${item.fileType == '이미지'}">
                                    <img src="${item.fileUrl}" alt="${item.altText}" onerror="this.style.display='none'" />
                                </c:when>
                                <c:otherwise><span class="placeholder"><c:out value="${item.fileType}" /></span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="media-info">
                            <p class="media-file-name"><c:out value="${item.title}" /></p>
                            <p class="media-meta"><c:out value="${item.fileType}" /> · <c:out value="${item.fileSizeDisplay}" /> · <c:out value="${item.status}" /></p>
                            <div class="media-actions">
                                <span class="mini-tag"><c:out value="${item.tags}" /></span>
                                <a class="icon-button" href="${item.fileUrl}" target="_blank" rel="noopener">보기</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </main>
</div>
</body>
</html>
