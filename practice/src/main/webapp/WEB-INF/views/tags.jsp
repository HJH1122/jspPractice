<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>태그 관리</title>
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
            color: rgba(255, 255, 255, 0.82);
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

        .menu-leaf.active {
            border-left-color: var(--accent);
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
        }

        .menu-leaf-unavailable {
            color: rgba(255, 255, 255, 0.45);
        }

        a.menu-leaf:hover,
        a.menu-leaf:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .tag-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
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
            color: var(--muted);
            font-size: 12px;
        }

        .tag-layout {
            display: grid;
            grid-template-columns: minmax(260px, 0.8fr) minmax(0, 2fr);
            gap: 16px;
            align-items: start;
        }

        .panel-title {
            margin: 0;
            font-size: 18px;
        }

        .panel-description {
            margin: 6px 0 18px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .tag-form {
            display: grid;
            gap: 14px;
        }

        .field-label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        .tag-form input,
        .tag-form textarea {
            width: 100%;
            min-height: 40px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            color: var(--text);
            font: inherit;
            font-size: 13px;
        }

        .tag-form textarea {
            min-height: 96px;
            resize: vertical;
        }

        .field-hint {
            display: block;
            margin-top: 5px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .tag-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .table-wrap {
            overflow-x: auto;
            border: 1px solid var(--border);
            border-radius: 10px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .table th,
        .table td {
            padding: 13px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .table th {
            background: #fafafa;
            color: var(--muted);
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .table tbody tr:last-child td {
            border-bottom: 0;
        }

        .tag-name {
            font-weight: 700;
        }

        .tag-slug {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .empty-state {
            color: var(--muted);
            font-size: 13px;
            text-align: center !important;
        }

        .form-notice {
            padding: 11px 12px;
            border: 1px solid rgba(0, 163, 42, 0.2);
            border-radius: 8px;
            background: rgba(0, 163, 42, 0.08);
            color: var(--success);
            font-size: 13px;
        }

        .form-notice.error {
            border-color: rgba(214, 54, 56, 0.2);
            background: rgba(214, 54, 56, 0.08);
            color: var(--danger);
        }

        @media (max-width: 1100px) {
            .layout,
            .tag-layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
            }
        }

        @media (max-width: 720px) {
            .content {
                padding: 16px;
            }

            .topbar,
            .tag-list-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .tag-summary {
                grid-template-columns: 1fr;
            }

        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title"><a href="${pageContext.request.contextPath}/main" style="color: inherit; text-decoration: none;">Practice CMS</a></h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>

        <nav class="menu" aria-label="관리 메뉴">
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-content">
                    <span>콘텐츠</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-content">
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/pages">페이지</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/posts">게시글</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/categories">카테고리</a></li>
                    <li><a class="menu-leaf active" href="${pageContext.request.contextPath}/tags" aria-current="page">태그</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/comments">댓글</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-media">
                    <span>미디어</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-media" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/main">메인 페이지</a></li>
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
                <h2 class="page-title">태그 관리</h2>
                <p class="page-desc">게시글의 핵심 키워드를 태그로 정리하고 연결 현황을 확인합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${pageContext.request.contextPath}/main">대시보드로 이동</a>
            </div>
        </div>

        <section class="tag-summary" aria-label="태그 요약">
            <div class="card">
                <p class="stat-label">전체 태그</p>
                <p class="stat-value">${fn:length(tags)}</p>
                <p class="stat-note">등록된 태그 수</p>
            </div>
        </section>

        <section class="tag-layout">
            <div class="card">
                <h3 class="panel-title">새 태그 추가</h3>
                <p class="panel-description">새 태그를 등록합니다.</p>
                <c:if test="${not empty tagSuccess}">
                    <p class="form-notice" role="status"><c:out value="${tagSuccess}"/></p>
                </c:if>
                <c:if test="${not empty tagError}">
                    <p class="form-notice error" role="alert"><c:out value="${tagError}"/></p>
                </c:if>
                <form class="tag-form" method="post" action="${pageContext.request.contextPath}/tags">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <label>
                        <span class="field-label">이름</span>
                        <input type="text" name="name" maxlength="100" required
                               value="${fn:escapeXml(tagForm.name)}" placeholder="태그 이름">
                    </label>
                    <label>
                        <span class="field-label">슬러그</span>
                        <input type="text" name="slug" maxlength="100"
                               pattern="[a-z0-9]+(-[a-z0-9]+)*" required
                               value="${fn:escapeXml(tagForm.slug)}" placeholder="예: product-update">
                        <span class="field-hint">URL에 사용되는 영문 이름입니다.</span>
                    </label>
                    <label>
                        <span class="field-label">설명</span>
                        <textarea name="description" maxlength="500"
                                  placeholder="태그에 대한 설명을 입력하세요."><c:out value="${tagForm.description}"/></textarea>
                    </label>
                    <button class="button primary" type="submit">태그 추가</button>
                </form>
            </div>

            <div class="card">
                <div class="tag-list-header">
                    <div>
                        <h3 class="panel-title">태그 목록</h3>
                        <p class="panel-description">등록된 태그의 이름과 설명을 확인합니다.</p>
                    </div>
                </div>

                <div class="table-wrap">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>이름</th>
                            <th>설명</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty tags}">
                                <c:forEach items="${tags}" var="tag">
                                    <tr>
                                        <td>
                                            <span class="tag-name"><c:out value="${tag.name}"/></span>
                                            <span class="tag-slug"><c:out value="${tag.slug}"/></span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty tag.description}"><c:out value="${tag.description}"/></c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="2" class="empty-state">등록된 태그가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
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
