<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:url value="/main" var="mainUrl"/>
<c:url value="/site/management" var="siteManagementUrl"/>
<c:url value="/site/${currentSite.siteId}/main-page" var="siteMainPageUrl"/>
<c:url value="/site/${currentSite.siteId}/menu" var="siteMenuUrl"/>
<c:url value="/site/${currentSite.siteId}/banner" var="siteBannerUrl"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배너 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group { margin: 2px 0; }

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

        .panel {
            margin-top: 18px;
            border: 1px solid var(--border);
            background: var(--panel);
            border-radius: 12px;
            box-shadow: 0 1px 2px var(--shadow);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
        }

        .section-title {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
        }

        .section-desc {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .table-wrap { overflow-x: auto; }

        .table th,
        .table td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .banner-name {
            font-weight: 700;
            color: var(--text);
        }

        .banner-meta {
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .thumb {
            width: 120px;
            height: 64px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: linear-gradient(135deg, #e8f1fb 0%, #f7fbff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--muted);
            font-size: 12px;
            font-weight: 600;
        }

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .row-actions .button {
            height: 34px;
            padding: 0 12px;
            font-size: 13px;
        }

        .banner-form {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
            padding: 24px;
        }

        .field {
            display: grid;
            gap: 8px;
            align-content: start;
        }

        .field.full { grid-column: 1 / -1; }

        .field label,
        .field-label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
        }

        .field input[type="text"],
        .field input[type="url"],
        .field input[type="date"],
        .field input[type="number"],
        .field select,
        .field textarea {
            width: 100%;
            min-height: 42px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font: inherit;
            color: var(--text);
            background: #fff;
        }

        .field textarea {
            min-height: 96px;
            resize: vertical;
        }

        .field-hint {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.5;
        }

        .checkbox-option {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
        }

        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 4px;
        }

        .ui-notice {
            margin: 0 0 18px;
            padding: 14px 16px;
            border: 1px solid #d7e3f4;
            border-radius: 10px;
            background: #f4f8fd;
            color: #35516b;
            font-size: 13px;
            line-height: 1.6;
        }

        .site-select {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: var(--muted);
            margin-bottom: 18px;
        }

        .site-select select {
            min-height: 40px;
            padding: 0 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            font: inherit;
            color: var(--text);
            background: #fff;
        }

        .empty-hint {
            color: var(--muted);
            text-align: center;
            padding: 28px 12px;
        }

        @media (max-width: 960px) {
            .topbar,
            .panel-header { flex-direction: column; align-items: stretch; }
            .toolbar { justify-content: flex-start; }
            .banner-form { grid-template-columns: 1fr; }
            .form-actions { flex-direction: column-reverse; }
            .form-actions .button { width: 100%; }
        }
    </style>
</head>
<body>
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
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/pages">페이지</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/posts">게시글</a></li>
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
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media/files">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site">
                    <li><a class="menu-leaf" href="${siteManagementUrl}">사이트 관리</a></li>
                    <li><a class="menu-leaf" href="${siteMainPageUrl}">메인 페이지</a></li>
                    <li><a class="menu-leaf" href="${siteMenuUrl}">메뉴 관리</a></li>
                    <li><a class="menu-leaf active" href="${siteBannerUrl}" aria-current="page">배너 관리</a></li>
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
                <h2 class="page-title">배너 관리</h2>
                <p class="page-desc">사이트에 노출할 배너를 등록하고 노출 순서와 기간을 관리합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mainUrl}">대시보드</a>
                <button class="button primary" type="button">배너 등록</button>
            </div>
        </div>

        <label class="site-select">
            관리 사이트
            <select id="managed-site" aria-label="관리 사이트 선택">
                <c:forEach items="${sites}" var="site">
                    <option value="${pageContext.request.contextPath}/site/${site.siteId}/banner"
                            ${site.siteId eq currentSite.siteId ? 'selected' : ''}>
                        <c:out value="${site.siteName}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <p class="ui-notice" role="note">배너 관리 화면 UI입니다. 실제 등록, 수정, 삭제 기능은 아직 연결되지 않았습니다.</p>

        <section class="summary" aria-label="배너 현황">
            <article class="card">
                <p class="stat-label">전체 배너</p>
                <p class="stat-value">3</p>
                <p class="stat-note">등록된 배너 수</p>
            </article>
            <article class="card">
                <p class="stat-label">노출 중</p>
                <p class="stat-value">2</p>
                <p class="stat-note">현재 사이트에 노출</p>
            </article>
            <article class="card">
                <p class="stat-label">숨김</p>
                <p class="stat-value">1</p>
                <p class="stat-note">비노출 상태 배너</p>
            </article>
        </section>

        <section class="panel" aria-labelledby="banner-list-title">
            <div class="panel-header">
                <div>
                    <h3 class="section-title" id="banner-list-title">배너 목록</h3>
                    <p class="section-desc">등록된 배너의 이미지, 연결 대상, 노출 기간과 상태를 확인합니다.</p>
                </div>
            </div>
            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">배너</th>
                        <th scope="col">이미지</th>
                        <th scope="col">연결 대상</th>
                        <th scope="col">노출 기간</th>
                        <th scope="col">노출 순서</th>
                        <th scope="col">상태</th>
                        <th scope="col">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <div class="banner-name">메인 프로모션 배너</div>
                            <div class="banner-meta">메인 상단 영역</div>
                        </td>
                        <td><div class="thumb">1200 × 420</div></td>
                        <td>/pages/company</td>
                        <td>2026-11-01 ~ 2026-12-31</td>
                        <td>1</td>
                        <td><span class="badge success">노출</span></td>
                        <td>
                            <div class="row-actions">
                                <button class="button" type="button">수정</button>
                                <button class="button" type="button">숨김</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="banner-name">신규 서비스 안내</div>
                            <div class="banner-meta">메인 중단 영역</div>
                        </td>
                        <td><div class="thumb">1200 × 420</div></td>
                        <td>https://example.com/service</td>
                        <td>2026-11-10 ~ 2026-11-30</td>
                        <td>2</td>
                        <td><span class="badge success">노출</span></td>
                        <td>
                            <div class="row-actions">
                                <button class="button" type="button">수정</button>
                                <button class="button" type="button">숨김</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="banner-name">점검 안내 배너</div>
                            <div class="banner-meta">메인 상단 영역</div>
                        </td>
                        <td><div class="thumb">1200 × 420</div></td>
                        <td>연결 없음</td>
                        <td>2026-10-01 ~ 2026-10-31</td>
                        <td>3</td>
                        <td><span class="badge warning">숨김</span></td>
                        <td>
                            <div class="row-actions">
                                <button class="button" type="button">수정</button>
                                <button class="button" type="button">노출</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="panel" aria-labelledby="banner-form-title">
            <div class="panel-header">
                <div>
                    <h3 class="section-title" id="banner-form-title">배너 등록</h3>
                    <p class="section-desc">배너 기본 정보, 이미지, 연결 대상, 노출 기간을 입력합니다.</p>
                </div>
            </div>
            <form class="banner-form" action="#" method="post" onsubmit="return false;">
                <div class="field">
                    <label for="banner-name">배너명</label>
                    <input id="banner-name" type="text" name="bannerName" placeholder="배너명을 입력하세요">
                </div>
                <div class="field">
                    <label for="banner-position">노출 위치</label>
                    <select id="banner-position" name="position">
                        <option value="MAIN_TOP">메인 상단</option>
                        <option value="MAIN_MIDDLE">메인 중단</option>
                        <option value="MAIN_BOTTOM">메인 하단</option>
                    </select>
                </div>
                <div class="field full">
                    <label for="banner-image">이미지 URL</label>
                    <input id="banner-image" type="url" name="imageUrl" placeholder="https://example.com/banner.jpg">
                    <span class="field-hint">배너에 사용할 이미지 URL을 입력하세요. 실제 업로드 기능은 추후 연결할 수 있습니다.</span>
                </div>
                <div class="field">
                    <label for="banner-link-type">연결 유형</label>
                    <select id="banner-link-type" name="linkType">
                        <option value="NONE">연결 없음</option>
                        <option value="INTERNAL">내부 페이지</option>
                        <option value="EXTERNAL">외부 URL</option>
                    </select>
                </div>
                <div class="field">
                    <label for="banner-link-target">연결 대상</label>
                    <input id="banner-link-target" type="text" name="linkTarget" placeholder="/pages/example 또는 https://example.com">
                </div>
                <div class="field">
                    <label for="banner-start-date">노출 시작일</label>
                    <input id="banner-start-date" type="date" name="startDate">
                </div>
                <div class="field">
                    <label for="banner-end-date">노출 종료일</label>
                    <input id="banner-end-date" type="date" name="endDate">
                </div>
                <div class="field">
                    <label for="banner-order">노출 순서</label>
                    <input id="banner-order" type="number" name="displayOrder" min="1" value="1">
                </div>
                <div class="field">
                    <span class="field-label">노출 상태</span>
                    <label class="checkbox-option">
                        <input type="checkbox" name="visible" value="true" checked>
                        사이트에 노출
                    </label>
                    <span class="field-hint">체크 해제 시 배너는 저장만 되고 화면에 노출되지 않습니다.</span>
                </div>
                <div class="field full">
                    <label for="banner-description">설명</label>
                    <textarea id="banner-description" name="description" placeholder="배너 설명 또는 관리자 메모를 입력하세요"></textarea>
                </div>
                <div class="form-actions">
                    <button class="button" type="reset">초기화</button>
                    <button class="button primary" type="button">저장</button>
                </div>
            </form>
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

    document.getElementById("managed-site").addEventListener("change", function (event) {
        window.location.href = event.target.value;
    });
</script>
</body>
</html>