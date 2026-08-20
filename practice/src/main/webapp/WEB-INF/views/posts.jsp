<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>게시글 관리</title>

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
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        a {
            color: inherit;
        }

        .layout {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 240px 1fr;
        }

        .sidebar {
            background: linear-gradient(
                    180deg,
                    var(--sidebar) 0%,
                    var(--sidebar-2) 100%
            );
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

        .menu {
            padding: 16px 0;
        }

        .menu-item {
            display: block;
            padding: 14px 24px;
            color: rgba(255, 255, 255, 0.82);
            text-decoration: none;
            font-size: 14px;
            border-left: 4px solid transparent;
        }

        .menu-item.active,
        .menu-item:hover {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            border-left-color: var(--accent);
        }

        .sidebar-footer {
            margin-top: 18px;
            padding: 0 24px;
            color: rgba(255, 255, 255, 0.55);
            font-size: 12px;
            line-height: 1.6;
        }

        .content {
            padding: 24px;
        }

        .hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
        }

        .hero-eyebrow {
            margin: 0 0 6px;
            color: var(--accent);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
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

        .button,
        .mini-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            cursor: pointer;
            font-family: inherit;
        }

        .button {
            height: 40px;
            padding: 0 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
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

        .button:hover,
        .mini-button:hover {
            opacity: 0.92;
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
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
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
            line-height: 1.5;
        }

        .workspace {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: 16px;
            align-items: start;
        }

        .stack {
            display: grid;
            gap: 16px;
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
            line-height: 1.6;
        }

        .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .chip {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 34px;
            padding: 0 12px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--muted);
            font-size: 13px;
            font-weight: 600;
        }

        .chip.active {
            background: var(--accent);
            border-color: var(--accent);
            color: #fff;
        }

        .table-wrap {
            overflow-x: auto;
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
            vertical-align: top;
        }

        .table th {
            color: var(--muted);
            font-weight: 600;
            background: #fafafa;
            font-size: 12px;
        }

        .table tr:hover td {
            background: #fcfcfc;
        }

        .post-title {
            margin: 0;
            font-size: 14px;
            font-weight: 700;
        }

        .post-meta {
            margin: 5px 0 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
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

        .badge.danger {
            background: rgba(214, 54, 56, 0.12);
            color: var(--danger);
        }

        .badge.neutral {
            background: rgba(100, 105, 112, 0.12);
            color: var(--muted);
        }

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .mini-button {
            min-width: 68px;
            height: 30px;
            padding: 0 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .mini-button.primary {
            background: var(--accent);
            border-color: var(--accent);
            color: #fff;
        }

        .mini-button.danger {
            color: var(--danger);
        }

        .mini-button.muted {
            color: var(--muted);
        }

        .draft-preview {
            display: grid;
            gap: 12px;
        }

        .field {
            display: grid;
            gap: 8px;
        }

        .field label {
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
        }

        .field-value,
        .field-surface {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fff;
            padding: 11px 12px;
            font-size: 14px;
            color: var(--text);
        }

        .field-surface {
            min-height: 140px;
            color: var(--muted);
            line-height: 1.7;
        }

        .panel-list {
            display: grid;
            gap: 12px;
        }

        .info-box {
            padding: 14px 16px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fcfcfc;
        }

        .info-box strong {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
        }

        .info-box span {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .route-list {
            display: grid;
            gap: 10px;
        }

        .route-item {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fcfcfc;
        }

        .route-item span:first-child {
            font-weight: 600;
        }

        .route-item span:last-child {
            color: var(--muted);
            text-align: right;
            font-size: 13px;
            word-break: break-all;
        }

        @media (max-width: 1100px) {

            .layout,
            .summary,
            .workspace {
                grid-template-columns: 1fr;
            }

            .hero,
            .panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .toolbar {
                justify-content: flex-start;
            }
        }

        @media (max-width: 760px) {

            .content {
                padding: 16px;
            }

            .summary {
                grid-template-columns: 1fr;
            }

            .toolbar,
            .filters {
                justify-content: flex-start;
            }

            .page-title {
                font-size: 24px;
            }

            .table {
                min-width: 760px;
            }

            .route-item {
                flex-direction: column;
            }

            .route-item span:last-child {
                text-align: left;
            }

            .ck-editor__editable {
                min-height: 400px;
            }
        }

    </style>

</head>

<body>

<c:url value="/main" var="mainUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/posts" var="postsUrl"/>

<div class="layout">

    <aside class="sidebar">

        <div class="brand">

            <h1 class="brand-title">
                Practice CMS
            </h1>

            <p class="brand-subtitle">
                관리자 중심 콘텐츠 운영 화면
            </p>

        </div>

        <nav class="menu">

            <a class="menu-item"
               href="${mainUrl}">
                대시보드
            </a>

            <a class="menu-item"
               href="${pagesUrl}">
                페이지
            </a>

            <a class="menu-item active"
               href="${postsUrl}">
                게시글
            </a>

            <a class="menu-item"
               href="#">
                미디어
            </a>

            <a class="menu-item"
               href="#">
                댓글
            </a>

            <a class="menu-item"
               href="#">
                설정
            </a>

        </nav>

        <div class="sidebar-footer">
            게시글 목록에서 보기 버튼을 클릭하면 게시글 상세 페이지로 이동합니다.
        </div>

    </aside>

    <main class="content">

        <section class="hero">

            <div>

                <p class="hero-eyebrow">
                    Posts Studio
                </p>

                <h2 class="page-title">
                    게시글 관리
                </h2>

                <p class="page-desc">
                    게시글 목록을 관리하고 게시글 상세 내용을 확인할 수 있습니다.
                </p>

            </div>

            <div class="toolbar">

                <a class="button"
                   href="${mainUrl}">
                    대시보드
                </a>

                <a class="button primary"
                   href="#composer">
                    새 게시글 작성
                </a>

            </div>

        </section>

        <section class="summary">

            <div class="card">

                <p class="stat-label">
                    전체 게시글
                </p>

                <p class="stat-value">
                    ${totalCount}
                </p>

                <p class="stat-note">
                    전체 관리 대상 게시물 수를 보여주는 요약 카드입니다.
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    발행됨
                </p>

                <p class="stat-value">
                    ${publishedCount}
                </p>

                <p class="stat-note">
                    외부 공개 상태의 게시글을 시각적으로 구분합니다.
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    예약됨
                </p>

                <p class="stat-value">
                    ${scheduledCount}
                </p>

                <p class="stat-note">
                    발행 시점을 보류한 예약 콘텐츠 영역입니다.
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    초안
                </p>

                <p class="stat-value">
                    ${draftCount}
                </p>

                <p class="stat-note">
                    작성 중이거나 검토 대기인 콘텐츠를 뜻합니다.
                </p>

            </div>

        </section>

        <div class="workspace">

            <section class="card stack">

                <div class="panel-header">

                    <div>

                        <h3 class="section-title">
                            게시글 목록
                        </h3>

                        <p class="section-desc">
                            게시글을 선택하면 상세 내용을 확인할 수 있습니다.
                        </p>

                    </div>

                    <div class="filters">

                        <span class="chip active">
                            전체
                        </span>

                        <span class="chip">
                            발행됨
                        </span>

                        <span class="chip">
                            예약됨
                        </span>

                        <span class="chip">
                            초안
                        </span>

                    </div>

                </div>

                <div class="table-wrap">

                    <table class="table">

                        <thead>

                        <tr>

                            <th style="width: 35%;">
                                제목
                            </th>

                            <th>
                                상태
                            </th>

                            <th>
                                작성자
                            </th>

                            <th>
                                수정일
                            </th>

                            <th style="width: 18%;">
                                작업
                            </th>

                        </tr>

                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty posts}">

                                <c:forEach var="post"
                                           items="${posts}">

                                    <tr>

                                        <td>

                                            <p class="post-title">
                                                ${post.title}
                                            </p>

                                            <p class="post-meta">

                                                <c:choose>

                                                    <c:when test="${not empty post.summary}">
                                                        ${post.summary}
                                                    </c:when>

                                                    <c:otherwise>
                                                        ${post.content}
                                                    </c:otherwise>

                                                </c:choose>

                                            </p>

                                        </td>

                                        <td>

                                            <c:choose>

                                                <c:when test="${post.status == 'PUBLISHED'}">

                                                    <span class="badge success">
                                                        발행됨
                                                    </span>

                                                </c:when>

                                                <c:when test="${post.status == 'SCHEDULED'}">

                                                    <span class="badge warning">
                                                        예약됨
                                                    </span>

                                                </c:when>

                                                <c:when test="${post.status == 'DRAFT'}">

                                                    <span class="badge neutral">
                                                        초안
                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span class="badge neutral">
                                                        ${post.status}
                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </td>

                                        <td>
                                            ${post.author}
                                        </td>

                                        <td>
                                            ${post.updatedAt}
                                        </td>

                                        <td>

                                            <div class="row-actions">

                                                <c:url value="/posts/detail"
                                                       var="detailUrl">

                                                    <c:param name="id"
                                                             value="${post.id}"/>

                                                </c:url>

                                                <a class="mini-button primary"
                                                   href="${detailUrl}">
                                                    보기
                                                </a>

                                                <c:url value="/posts/edit"
                                                       var="editUrl">

                                                    <c:param name="id"
                                                             value="${post.id}"/>

                                                </c:url>

                                                <a class="mini-button"
                                                   href="${editUrl}">
                                                    수정
                                                </a>

                                            </div>

                                        </td>

                                    </tr>

                                </c:forEach>

                            </c:when>

                            <c:otherwise>

                                <tr>

                                    <td colspan="5"
                                        style="text-align: center; padding: 40px;">

                                        <p class="post-title">
                                            게시글이 없습니다.
                                        </p>

                                        <p class="post-meta">
                                            등록된 게시글이 없습니다.
                                        </p>

                                    </td>

                                </tr>

                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

            </section>

            <aside class="stack">

                <section class="card"
                         id="composer">

                    <div class="panel-header">

                        <div>

                            <h3 class="section-title">
                                게시글 작성 패널
                            </h3>

                            <p class="section-desc">
                                게시글 작성 영역입니다.
                            </p>

                        </div>

                    </div>

                    <div class="draft-preview">

                        <div class="field">

                            <label>
                                제목
                            </label>

                            <div class="field-value">
                                서비스 개편 안내
                            </div>

                        </div>

                        <div class="field">

                            <label>
                                게시 상태
                            </label>

                            <div class="field-value">
                                발행됨
                            </div>

                        </div>

                        <div class="field">

                            <label for="post-content">
                                본문
                            </label>

                            <textarea id="post-content"
                                      name="content"
                                      placeholder="게시글 본문을 입력하세요"></textarea>

                        </div>

                        <p class="post-meta">
                            본문은 CKEditor로 작성됩니다.
                        </p>

                        <div class="row-actions">

                            <a class="mini-button primary"
                               href="#">
                                임시 저장
                            </a>

                            <a class="mini-button"
                               href="#">
                                미리보기
                            </a>

                            <a class="mini-button danger"
                               href="#">
                                삭제
                            </a>

                        </div>

                    </div>

                </section>

                <section class="card">

                    <div class="panel-header">

                        <div>

                            <h3 class="section-title">
                                라우팅 안내
                            </h3>

                            <p class="section-desc">
                                게시글 목록과 상세보기의 이동 경로입니다.
                            </p>

                        </div>

                    </div>

                    <div class="route-list">

                        <div class="route-item">

                            <span>
                                대시보드
                            </span>

                            <span>
                                ${mainUrl}
                            </span>

                        </div>

                        <div class="route-item">

                            <span>
                                게시글 목록
                            </span>

                            <span>
                                ${postsUrl}
                            </span>

                        </div>

                        <div class="route-item">

                            <span>
                                게시글 상세
                            </span>

                            <span>
                                ${postsUrl}/detail?id={id}
                            </span>

                        </div>

                    </div>

                </section>

                <section class="card">

                    <div class="panel-header">

                        <div>

                            <h3 class="section-title">
                                화면 메모
                            </h3>

                            <p class="section-desc">
                                게시글 관리 기능 안내입니다.
                            </p>

                        </div>

                    </div>

                    <div class="panel-list">

                        <div class="info-box">

                            <strong>
                                상세보기
                            </strong>

                            <span>
                                목록의 보기 버튼을 클릭하면 게시글 ID를 기준으로 상세 페이지로 이동합니다.
                            </span>

                        </div>

                        <div class="info-box">

                            <strong>
                                데이터 조회
                            </strong>

                            <span>
                                PostController에서 PostService를 통해 게시글 하나를 조회합니다.
                            </span>

                        </div>

                        <div class="info-box">

                            <strong>
                                상세 페이지
                            </strong>

                            <span>
                                조회된 게시글은 상세 페이지에서 제목, 본문, 작성자, 상태, 조회수 등을 표시합니다.
                            </span>

                        </div>

                    </div>

                </section>

            </aside>

        </div>

    </main>

</div>

<script>

    (function () {

        const contentElement =
                document.getElementById('post-content');

        if (!contentElement) {
            return;
        }

        if (typeof ClassicEditor === 'undefined') {
            console.warn('ClassicEditor가 로드되지 않았습니다.');
            return;
        }

        ClassicEditor
            .create(contentElement)

            .then(function (editor) {
                console.log('게시글 CKEditor 초기화 완료');
            })

            .catch(function (error) {
                console.error(
                    '게시글 CKEditor 초기화 실패:',
                    error
                );
            });

    })();

</script>

</body>

</html>
