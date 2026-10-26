<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인페이지 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group-toggle {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 24px;
            border: 0;
            background: transparent;
            color: rgba(255,255,255,0.72);
            font-size: 12px;
            font-weight: 700;
            text-align: left;
            cursor: pointer;
        }

        .menu-group-toggle:hover,
        .menu-group-toggle:focus-visible {
            color: #fff;
            outline: none;
        }

        .menu-chevron {
            width: 7px;
            height: 7px;
            border-right: 1px solid currentColor;
            border-bottom: 1px solid currentColor;
            transform: rotate(45deg);
            transition: transform 0.15s ease;
        }

        .menu-group-toggle[aria-expanded="true"] .menu-chevron {
            transform: rotate(225deg);
        }

        .menu-submenu {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .menu-submenu[hidden] { display: none; }

        .menu-leaf {
            display: block;
            padding: 10px 24px 10px 36px;
            color: rgba(255,255,255,0.75);
            font-size: 13px;
            border-left: 4px solid transparent;
        }

        .menu-leaf:hover,
        .menu-leaf.active {
            color: #fff;
            background: rgba(255,255,255,0.07);
            border-left-color: var(--accent);
        }

        .menu-leaf-unavailable { color: rgba(255,255,255,0.45); }

        .workspace {
            display: grid;
            grid-template-columns: minmax(0, 1.05fr) minmax(360px, 0.95fr);
            align-items: start;
            gap: 18px;
        }

        .editor-column,
        .preview-column {
            display: grid;
            gap: 16px;
        }

        .panel-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 18px;
        }

        .panel-title {
            margin: 0;
            font-size: 17px;
        }

        .panel-desc {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .field {
            display: grid;
            gap: 8px;
            margin-top: 16px;
        }

        .field label {
            font-size: 13px;
            font-weight: 600;
        }

        .field input,
        .field textarea,
        .field select {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 11px 12px;
            background: #fff;
            color: var(--text);
            font: inherit;
            font-size: 14px;
        }

        .field textarea {
            min-height: 86px;
            resize: vertical;
        }

        .field-hint,
        .ui-notice {
            color: var(--muted);
            font-size: 12px;
            line-height: 1.55;
        }

        .ui-notice {
            margin: 0 0 18px;
            padding: 12px 14px;
            border: 1px solid #c5d9ed;
            border-radius: 8px;
            background: #f0f6fc;
            color: #245780;
        }

        .media-placeholder {
            min-height: 142px;
            display: grid;
            place-items: center;
            border: 1px dashed #a7aaad;
            border-radius: 10px;
            background: linear-gradient(135deg, #eef2f6, #dce6ef);
            color: #50575e;
            text-align: center;
        }

        .media-placeholder strong {
            display: block;
            margin-bottom: 6px;
        }

        .media-placeholder.has-image {
            position: relative;
            display: block;
            min-height: 0;
            overflow: hidden;
            border-style: solid;
        }

        .media-placeholder img {
            display: block;
            width: 100%;
            max-height: 240px;
            object-fit: cover;
        }

        .media-placeholder-empty {
            min-height: 142px;
            display: grid;
            place-items: center;
            text-align: center;
        }

        .media-picker-modal {
            position: fixed;
            inset: 0;
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
            background: rgba(17, 24, 39, 0.55);
        }

        .media-picker-modal.open { display: flex; }

        .media-picker-dialog {
            width: min(840px, 100%);
            max-height: 85vh;
            overflow: auto;
            padding: 20px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        .media-picker-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }

        .media-picker-header h3 { margin: 0; font-size: 18px; }

        .media-picker-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
            gap: 12px;
        }

        .media-picker-item {
            display: grid;
            gap: 8px;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: #fcfcfc;
        }

        .media-picker-item img {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 6px;
            background: #f3f3f3;
        }

        .media-picker-item strong {
            overflow: hidden;
            font-size: 13px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .media-picker-empty {
            grid-column: 1 / -1;
            padding: 20px;
            border: 1px dashed var(--border);
            border-radius: 9px;
            color: var(--muted);
            text-align: center;
        }

        .notice {
            margin-bottom: 16px;
            padding: 12px 14px;
            border: 1px solid #b8e6bf;
            border-radius: 8px;
            background: #f0fff2;
            color: #116329;
        }

        .section-list {
            display: grid;
            gap: 10px;
        }

        .section-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: #fff;
        }

        .section-row[draggable="true"] { cursor: grab; }
        .section-row.dragging { opacity: 0.45; }
        .section-row:focus-within { outline: 2px solid rgba(34, 113, 177, 0.22); }

        .drag-mark {
            color: #8c8f94;
            font-size: 18px;
            letter-spacing: -3px;
            user-select: none;
        }

        .section-row-main {
            flex: 1;
            min-width: 0;
        }

        .section-row-main strong {
            display: block;
            font-size: 13px;
        }

        .section-row-main span {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .section-state {
            padding: 5px 9px;
            border-radius: 999px;
            background: var(--accent-soft);
            color: var(--accent);
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .section-order-actions {
            display: flex;
            gap: 6px;
        }

        .section-order-actions .button {
            width: 34px;
            height: 34px;
            padding: 0;
        }

        .section-order-actions .button:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .preview-frame {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fff;
        }

        .preview-browser {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 11px 13px;
            border-bottom: 1px solid var(--border);
            background: #f6f7f7;
        }

        .browser-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #c3c4c7;
        }

        .preview-site {
            padding: 18px;
        }

        .preview-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            font-size: 11px;
        }

        .preview-nav strong { font-size: 13px; }
        .preview-nav span { color: var(--muted); }

        .preview-hero {
            min-height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 24px;
            border-radius: 8px;
            background: linear-gradient(125deg, #173c5a, #3977a1);
            color: #fff;
        }

        .preview-hero .eyebrow {
            margin: 0 0 8px;
            font-size: 10px;
            opacity: 0.8;
        }

        .preview-hero h3 {
            max-width: 300px;
            margin: 0;
            font-size: 25px;
            line-height: 1.25;
        }

        .preview-hero p {
            max-width: 300px;
            margin: 10px 0 16px;
            font-size: 11px;
            line-height: 1.6;
            opacity: 0.88;
        }

        .preview-cta {
            width: fit-content;
            padding: 8px 12px;
            border-radius: 5px;
            background: #fff;
            color: #173c5a;
            font-size: 10px;
            font-weight: 700;
        }

        .preview-section-title {
            margin: 18px 0 10px;
            font-size: 13px;
        }

        .preview-cards {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 9px;
        }

        .preview-card {
            min-height: 72px;
            padding: 11px;
            border: 1px solid #e2e4e7;
            border-radius: 7px;
        }

        .preview-card span {
            color: var(--accent);
            font-size: 9px;
            font-weight: 700;
        }

        .preview-card strong {
            display: block;
            margin-top: 6px;
            font-size: 11px;
        }

        .toolbar .button:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }

        @media (max-width: 1050px) {
            .workspace { grid-template-columns: 1fr; }
        }

        @media (max-width: 640px) {
            .content { padding: 16px; }
            .topbar { align-items: flex-start; flex-direction: column; }
            .toolbar { justify-content: flex-start; }
            .preview-site { padding: 12px; }
            .preview-hero { min-height: 190px; padding: 18px; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/site/main-page" var="siteMainPageUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/posts" var="postsUrl"/>
<c:url value="/media" var="mediaUrl"/>

<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title"><a href="${mainUrl}" style="color: inherit; text-decoration: none;">Practice CMS</a></h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>
        <nav class="menu" aria-label="관리 메뉴">
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-content">
                    <span>콘텐츠</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-content" hidden>
                    <li><a class="menu-leaf" href="${pagesUrl}">페이지</a></li>
                    <li><a class="menu-leaf" href="${postsUrl}">게시글</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/categories">카테고리</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/tags">태그</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/comments">댓글</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-media">
                    <span>미디어</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-media" hidden>
                    <li><a class="menu-leaf" href="${mediaUrl}">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf" href="${mediaUrl}">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site">
                    <li><a class="menu-leaf active" href="${siteMainPageUrl}" aria-current="page">메인 페이지</a></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">메뉴 관리</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">배너 관리</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">팝업 관리</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-statistics">
                    <span>통계</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-statistics" hidden>
                    <li><span class="menu-leaf menu-leaf-unavailable">방문자 통계</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">콘텐츠 통계</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-settings">
                    <span>설정</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-settings" hidden>
                    <li><span class="menu-leaf menu-leaf-unavailable">사이트 설정</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">관리자 설정</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">시스템 설정</span></li>
                </ul>
            </div>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">메인페이지 관리</h2>
                <p class="page-desc">방문자에게 보여줄 홈 화면의 배너와 콘텐츠 구성을 관리합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mainUrl}">대시보드</a>
                <button class="button primary" type="submit" form="main-page-settings-form">변경사항 저장</button>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="notice" role="status"><c:out value="${message}"/></div>
        </c:if>
        <p class="ui-notice">홈 화면 구성 항목을 드래그하거나 위·아래 버튼으로 순서를 바꾼 뒤, 변경사항 저장을 눌러 적용하세요. 실제 미리보기는 아직 연결되지 않았습니다.</p>

        <div class="workspace">
            <div class="editor-column">
                <form id="main-page-settings-form" method="post" action="${pageContext.request.contextPath}/site/main-page/save">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <section class="card">
                    <div class="panel-heading">
                        <div>
                            <h3 class="panel-title">메인 배너</h3>
                            <p class="panel-desc">홈 화면 상단에 표시할 대표 문구와 이미지를 설정합니다.</p>
                        </div>
                        <span class="section-state">상단 영역</span>
                    </div>
                    <div class="media-placeholder ${not empty settings.bannerImageUrl ? 'has-image' : ''}" id="banner-image-preview">
                        <c:choose>
                            <c:when test="${not empty settings.bannerImageUrl}">
                                <img src="<c:out value='${settings.bannerImageUrl}'/>" alt="선택한 메인 배너 이미지">
                            </c:when>
                            <c:otherwise>
                        <div class="media-placeholder-empty">
                            <div>
                            <strong>대표 이미지 미리보기</strong>
                            <span class="field-hint">메인 배너에 사용할 이미지를 선택하세요.</span>
                            </div>
                        </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="toolbar" style="justify-content:flex-start; margin-top:10px;">
                        <button class="button" type="button" id="open-media-picker">미디어 선택</button>
                        <button class="button" type="button" id="clear-banner-image" <c:if test="${empty settings.bannerImageUrl}">hidden</c:if>>이미지 제거</button>
                    </div>
                    <input type="hidden" id="banner-image-url" name="bannerImageUrl" value="<c:out value='${settings.bannerImageUrl}'/>">
                    <div class="field">
                        <label for="hero-title">메인 문구</label>
                        <input id="hero-title" type="text" name="bannerTitle" value="<c:out value='${settings.bannerTitle}'/>">
                    </div>
                    <div class="field">
                        <label for="hero-description">설명 문구</label>
                        <textarea id="hero-description" name="bannerDescription"><c:out value="${settings.bannerDescription}"/></textarea>
                    </div>
                    <div class="field">
                        <label for="hero-link">버튼 연결 대상</label>
                        <select id="hero-link" name="buttonLinkType">
                            <option value="PAGE" <c:if test="${settings.buttonLinkType eq 'PAGE'}">selected</c:if>>페이지 선택</option>
                            <option value="POST" <c:if test="${settings.buttonLinkType eq 'POST'}">selected</c:if>>게시글 선택</option>
                            <option value="URL" <c:if test="${settings.buttonLinkType eq 'URL'}">selected</c:if>>직접 입력한 주소</option>
                        </select>
                    </div>
                    <input type="hidden" id="section-order" name="sectionOrder" value="<c:out value='${settings.sectionOrder}'/>">
                </section>
                </form>

                <section class="card">
                    <div class="panel-heading">
                        <div>
                            <h3 class="panel-title">홈 화면 구성</h3>
                            <p class="panel-desc">항목을 드래그하거나 위·아래 버튼으로 배치 순서를 정합니다.</p>
                        </div>
                    </div>
                    <div class="section-list" id="home-section-list">
                        <c:forEach items="${sectionOrderItems}" var="sectionId" varStatus="sectionStatus">
                            <div class="section-row" draggable="true" data-section-id="<c:out value='${sectionId}'/>">
                                <span class="drag-mark" aria-hidden="true">⠿</span>
                                <div class="section-row-main">
                                    <c:choose>
                                        <c:when test="${sectionId eq 'FEATURED_PAGE'}">
                                            <strong>대표 페이지</strong>
                                            <span>페이지 콘텐츠 · 메인 노출로 지정한 페이지</span>
                                        </c:when>
                                        <c:when test="${sectionId eq 'FEATURED_POSTS'}">
                                            <strong>주요 게시글</strong>
                                            <span>게시글 콘텐츠 · 메인 노출로 지정한 게시글</span>
                                        </c:when>
                                        <c:otherwise>
                                            <strong>최근 게시글</strong>
                                            <span>최신 게시글을 목록으로 표시</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="section-state">노출</span>
                                <div class="section-order-actions">
                                    <button class="button move-section-up" type="button"
                                            aria-label="위로 이동"
                                            <c:if test="${sectionStatus.first}">disabled</c:if>>↑</button>
                                    <button class="button move-section-down" type="button"
                                            aria-label="아래로 이동"
                                            <c:if test="${sectionStatus.last}">disabled</c:if>>↓</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <p class="field-hint" id="section-order-status" aria-live="polite">현재 설정 순서입니다. 변경 후 저장하세요.</p>
                </section>
            </div>

            <div class="preview-column">
                <section class="card">
                    <div class="panel-heading">
                        <div>
                            <h3 class="panel-title">화면 미리보기</h3>
                            <p class="panel-desc">방문자 화면 구성을 보여주는 정적 예시입니다.</p>
                        </div>
                        <span class="section-state">데스크톱</span>
                    </div>
                    <div class="preview-frame">
                        <div class="preview-browser" aria-hidden="true">
                            <span class="browser-dot"></span>
                            <span class="browser-dot"></span>
                            <span class="browser-dot"></span>
                        </div>
                        <div class="preview-site">
                            <div class="preview-nav">
                                <strong>Practice Site</strong>
                                <span>소개　 콘텐츠　 소식</span>
                            </div>
                            <div class="preview-hero">
                                <p class="eyebrow">WELCOME</p>
                                <h3>우리의 이야기를 시작합니다</h3>
                                <p>사이트의 주요 소식과 콘텐츠를 방문자에게 소개합니다.</p>
                                <span class="preview-cta">자세히 보기</span>
                            </div>
                            <h4 class="preview-section-title">주요 콘텐츠</h4>
                            <div class="preview-cards">
                                <div class="preview-card">
                                    <span>페이지</span>
                                    <strong>소개 페이지</strong>
                                </div>
                                <div class="preview-card">
                                    <span>게시글</span>
                                    <strong>새로운 소식</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card">
                    <div class="panel-heading">
                        <div>
                            <h3 class="panel-title">연결 가능한 콘텐츠</h3>
                            <p class="panel-desc">기존 페이지·게시글 편집 화면에서 메인 노출을 지정할 수 있습니다.</p>
                        </div>
                    </div>
                    <div class="section-list">
                        <div class="section-row">
                            <div class="section-row-main">
                                <strong>페이지</strong>
                                <span>페이지 관리에서 대표 이미지와 메인 노출 여부 설정</span>
                            </div>
                            <a class="button" href="${pagesUrl}">페이지 관리</a>
                        </div>
                        <div class="section-row">
                            <div class="section-row-main">
                                <strong>게시글</strong>
                                <span>게시글 편집에서 썸네일과 메인 노출 여부 설정</span>
                            </div>
                            <a class="button" href="${postsUrl}">게시글 관리</a>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</div>

<div class="media-picker-modal" id="media-picker-modal" role="dialog" aria-modal="true" aria-labelledby="media-picker-title">
    <div class="media-picker-dialog">
        <div class="media-picker-header">
            <h3 id="media-picker-title">미디어 목록에서 이미지 선택</h3>
            <button type="button" class="button" id="close-media-picker" aria-label="닫기">닫기</button>
        </div>
        <div class="media-picker-list">
            <c:choose>
                <c:when test="${empty mediaItems}">
                    <div class="media-picker-empty">선택할 수 있는 공개 이미지가 없습니다. 미디어 라이브러리에 이미지를 먼저 업로드해 주세요.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${mediaItems}" var="item">
                        <button type="button" class="media-picker-item media-picker-select"
                                data-media-url="<c:out value='${item.fileUrl}'/>"
                                data-media-preview="<c:out value='${not empty item.thumbnailUrl ? item.thumbnailUrl : item.fileUrl}'/>">
                            <img src="<c:out value='${not empty item.thumbnailUrl ? item.thumbnailUrl : item.fileUrl}'/>"
                                 alt="<c:out value='${item.altText}'/>">
                            <strong><c:out value="${not empty item.title ? item.title : item.originalFilename}"/></strong>
                            <span class="field-hint"><c:out value="${item.originalFilename}"/></span>
                            <span class="button">이 이미지 선택</span>
                        </button>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll(".menu-group-toggle").forEach(function (toggle) {
        toggle.addEventListener("click", function () {
            var expanded = toggle.getAttribute("aria-expanded") === "true";
            var submenu = document.getElementById(toggle.getAttribute("aria-controls"));

            toggle.setAttribute("aria-expanded", String(!expanded));
            submenu.hidden = expanded;
        });
    });

    (function () {
        var sectionList = document.getElementById("home-section-list");
        var orderInput = document.getElementById("section-order");
        var orderStatus = document.getElementById("section-order-status");
        var draggedRow = null;

        function updateOrder() {
            var rows = Array.prototype.slice.call(sectionList.querySelectorAll(".section-row"));
            orderInput.value = rows.map(function (row) {
                return row.getAttribute("data-section-id");
            }).join(",");

            rows.forEach(function (row, index) {
                row.querySelector(".move-section-up").disabled = index === 0;
                row.querySelector(".move-section-down").disabled = index === rows.length - 1;
            });
            orderStatus.textContent = "순서가 변경되었습니다. 변경사항 저장을 눌러 적용하세요.";
        }

        sectionList.addEventListener("click", function (event) {
            var button = event.target.closest(".move-section-up, .move-section-down");
            if (!button) {
                return;
            }
            var row = button.closest(".section-row");
            if (button.classList.contains("move-section-up") && row.previousElementSibling) {
                sectionList.insertBefore(row, row.previousElementSibling);
                updateOrder();
                row.querySelector(".move-section-up").focus();
            } else if (button.classList.contains("move-section-down") && row.nextElementSibling) {
                sectionList.insertBefore(row.nextElementSibling, row);
                updateOrder();
                row.querySelector(".move-section-down").focus();
            }
        });

        sectionList.addEventListener("dragstart", function (event) {
            draggedRow = event.target.closest(".section-row");
            if (!draggedRow) {
                return;
            }
            draggedRow.classList.add("dragging");
            event.dataTransfer.effectAllowed = "move";
            event.dataTransfer.setData("text/plain", draggedRow.getAttribute("data-section-id"));
        });

        sectionList.addEventListener("dragover", function (event) {
            event.preventDefault();
            if (!draggedRow) {
                return;
            }
            var targetRow = event.target.closest(".section-row");
            if (!targetRow || targetRow === draggedRow) {
                return;
            }
            var bounds = targetRow.getBoundingClientRect();
            var insertAfter = event.clientY > bounds.top + bounds.height / 2;
            sectionList.insertBefore(draggedRow, insertAfter ? targetRow.nextElementSibling : targetRow);
        });

        sectionList.addEventListener("drop", function (event) {
            event.preventDefault();
            if (draggedRow) {
                updateOrder();
            }
        });

        sectionList.addEventListener("dragend", function () {
            if (draggedRow) {
                draggedRow.classList.remove("dragging");
                draggedRow = null;
            }
        });
    })();

    (function () {
        var modal = document.getElementById("media-picker-modal");
        var openButton = document.getElementById("open-media-picker");
        var closeButton = document.getElementById("close-media-picker");
        var imageUrlInput = document.getElementById("banner-image-url");
        var imagePreview = document.getElementById("banner-image-preview");
        var clearButton = document.getElementById("clear-banner-image");

        function closeModal() {
            modal.classList.remove("open");
        }

        function updateImage(url, previewUrl) {
            imagePreview.classList.toggle("has-image", Boolean(url));
            imagePreview.replaceChildren();
            if (url) {
                var image = document.createElement("img");
                image.src = previewUrl || url;
                image.alt = "선택한 메인 배너 이미지";
                imagePreview.appendChild(image);
            } else {
                var empty = document.createElement("div");
                empty.className = "media-placeholder-empty";
                var content = document.createElement("div");
                var title = document.createElement("strong");
                var hint = document.createElement("span");
                title.textContent = "대표 이미지 미리보기";
                hint.className = "field-hint";
                hint.textContent = "메인 배너에 사용할 이미지를 선택하세요.";
                content.append(title, hint);
                empty.appendChild(content);
                imagePreview.appendChild(empty);
            }
            clearButton.hidden = !url;
        }

        openButton.addEventListener("click", function () {
            modal.classList.add("open");
            closeButton.focus();
        });
        closeButton.addEventListener("click", closeModal);
        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                closeModal();
            }
        });
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && modal.classList.contains("open")) {
                closeModal();
            }
        });
        document.querySelectorAll(".media-picker-select").forEach(function (button) {
            button.addEventListener("click", function () {
                var url = button.getAttribute("data-media-url");
                var previewUrl = button.getAttribute("data-media-preview");
                imageUrlInput.value = url || "";
                updateImage(url || "", previewUrl || "");
                closeModal();
            });
        });
        clearButton.addEventListener("click", function () {
            imageUrlInput.value = "";
            updateImage("", "");
        });
    })();
</script>
</body>
</html>
