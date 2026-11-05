<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파일 상세 확인</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group {
            margin: 2px 0;
        }

        .menu-group-toggle {
            display: flex;
            width: 100%;
            align-items: center;
            justify-content: space-between;
            padding: 12px 24px;
            border: 0;
            border-left: 4px solid transparent;
            background: transparent;
            color: rgba(255,255,255,.82);
            font: inherit;
            font-size: 14px;
            text-align: left;
            cursor: pointer;
        }

        .menu-group-toggle:hover,
        .menu-group-toggle:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .menu-group-toggle[aria-expanded="true"] {
            color: #fff;
        }

        .menu-chevron {
            width: 8px;
            height: 8px;
            margin-right: 2px;
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
            padding: 0 0 6px;
            list-style: none;
        }

        .menu-submenu[hidden] {
            display: none;
        }

        .menu-leaf {
            display: block;
            padding: 9px 24px 9px 42px;
            border-left: 4px solid transparent;
            color: rgba(255, 255, 255, 0.68);
            font-size: 13px;
        }

        a.menu-leaf:hover,
        a.menu-leaf:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .menu-leaf.active {
            border-left-color: var(--accent);
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
        }

        .menu-leaf-unavailable {
            color: rgba(255, 255, 255, 0.45);
        }

        .detail-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.1fr) minmax(300px, .9fr);
            gap: 20px;
            align-items: start;
        }

        .preview-panel {
            display: grid;
            min-height: 320px;
            place-items: center;
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #f5f7f9;
        }

        .preview-panel img,
        .preview-panel video {
            display: block;
            max-width: 100%;
            max-height: 560px;
            object-fit: contain;
        }

        .document-preview {
            padding: 32px;
            color: var(--muted);
            text-align: center;
        }

        .document-preview strong {
            display: block;
            margin-bottom: 8px;
            color: var(--text);
            font-size: 18px;
        }

        .detail-heading { margin: 0 0 16px; overflow-wrap: anywhere; }
        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th,
        .detail-table td {
            padding: 12px 10px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: top;
            overflow-wrap: anywhere;
        }
        .detail-table th { width: 120px; color: var(--muted); font-weight: 600; }
        .detail-table tr:last-child th,
        .detail-table tr:last-child td { border-bottom: 0; }
        .detail-text { white-space: pre-wrap; }
        .badge.neutral { background: #f0f0f1; color: #50575e; }
        .usage-list { margin: 0; padding-left: 20px; }
        .detail-actions { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 16px; }
        .empty-usage { color: var(--muted); }

        @media (max-width: 1100px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
            }
        }

        @media (max-width: 850px) {
            .detail-layout { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/media" var="mediaUrl"/>
<c:url value="/media/files" var="mediaFilesUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/posts" var="postsUrl"/>
<c:url value="/categories" var="categoriesUrl"/>
<c:url value="/tags" var="tagsUrl"/>
<c:url value="/comments" var="commentsUrl"/>
<c:url value="/site/main-page" var="siteMainPageUrl"/>
<c:url value="/media/files/${media.storedFilename}" var="previewUrl"/>
<c:if test="${not empty media.thumbnailFilename}">
    <c:url value="/media/files/${media.thumbnailFilename}" var="thumbnailPreviewUrl"/>
</c:if>

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
                    <li><a class="menu-leaf" href="${categoriesUrl}">카테고리</a></li>
                    <li><a class="menu-leaf" href="${tagsUrl}">태그</a></li>
                    <li><a class="menu-leaf" href="${commentsUrl}">댓글</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-media">
                    <span>미디어</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-media">
                    <li><a class="menu-leaf" href="${mediaUrl}">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf active" href="${mediaFilesUrl}" aria-current="page">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site" hidden>
                    <li><a class="menu-leaf" href="${siteMainPageUrl}">메인 페이지</a></li>
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
                <h2 class="page-title">파일 상세 확인</h2>
                <p class="page-desc">파일 미리보기와 등록 정보를 확인합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mediaFilesUrl}">파일 목록</a>
                <a class="button primary" href="${pageContext.request.contextPath}/media/${media.id}/edit">정보 수정</a>
            </div>
        </div>

        <section class="detail-layout">
            <div class="card">
                <h3 class="detail-heading"><c:out value="${media.originalFilename}"/></h3>
                <div class="preview-panel">
                    <c:choose>
                        <c:when test="${media.fileType eq '이미지'}">
                            <img src="${not empty media.thumbnailFilename ? thumbnailPreviewUrl : previewUrl}"
                                 alt="<c:out value='${media.altText}'/>">
                        </c:when>
                        <c:when test="${media.fileType eq '동영상'}">
                            <video controls preload="metadata">
                                <source src="<c:out value='${previewUrl}'/>">
                                브라우저에서 동영상을 재생할 수 없습니다.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <div class="document-preview">
                                <strong><c:out value="${media.fileType} 파일"/></strong>
                                <span>문서 미리보기는 제공되지 않습니다. 파일을 열거나 다운로드해 확인하세요.</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-actions">
                    <a class="button" href="${previewUrl}" target="_blank" rel="noopener">파일 열기</a>
                    <a class="button" href="${pageContext.request.contextPath}/media/${media.id}/download">다운로드</a>
                </div>
            </div>

            <div>
                <section class="card">
                    <h3 class="detail-heading">파일 정보</h3>
                    <table class="detail-table">
                        <tbody>
                        <tr><th scope="row">제목</th><td><c:out value="${media.title}"/></td></tr>
                        <tr><th scope="row">유형</th><td><c:out value="${media.fileType}"/></td></tr>
                        <tr><th scope="row">크기</th><td><c:out value="${media.fileSizeDisplay}"/></td></tr>
                        <tr><th scope="row">업로드 일시</th><td><c:out value="${media.uploadedAtDisplay}"/></td></tr>
                        <tr><th scope="row">상태</th><td><span class="badge ${media.statusCssClass}"><c:out value="${media.status}"/></span></td></tr>
                        <tr><th scope="row">설명</th><td class="detail-text"><c:out value="${media.description}"/></td></tr>
                        <tr><th scope="row">대체 텍스트</th><td><c:out value="${media.altText}"/></td></tr>
                        <tr><th scope="row">태그</th><td><c:out value="${media.tags}"/></td></tr>
                        </tbody>
                    </table>
                </section>

                <section class="card" style="margin-top:20px;">
                    <h3 class="detail-heading">사용 중인 콘텐츠</h3>
                    <c:choose>
                        <c:when test="${empty usageItems}">
                            <p class="empty-usage">이 파일을 사용 중인 콘텐츠가 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="usage-list">
                                <c:forEach items="${usageItems}" var="usage">
                                    <li>
                                        <c:out value="${usage.targetTypeLabel}"/> ·
                                        <a href="${pageContext.request.contextPath}/${usage.targetUrl}">
                                            <c:out value="${usage.targetTitle}"/>
                                        </a>
                                        <c:if test="${not empty usage.targetStatus}">
                                            (<c:out value="${usage.targetStatus}"/>)
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </section>
    </main>
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
</script>
</body>
</html>
