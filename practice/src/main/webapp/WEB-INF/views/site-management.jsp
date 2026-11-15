<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이트 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group-label {
            padding: 14px 24px 8px;
            color: rgba(255,255,255,0.5);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.06em;
        }

        .menu-submenu {
            margin: 0;
            padding: 0;
            list-style: none;
        }

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

        .panel {
            overflow: hidden;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 1px 2px var(--shadow);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            padding: 20px;
            border-bottom: 1px solid var(--border);
        }

        .section-title {
            margin: 0;
            font-size: 18px;
        }

        .section-desc {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .table-wrap { overflow-x: auto; }

        .table th,
        .table td {
            vertical-align: middle;
        }

        .site-name {
            display: block;
            font-weight: 700;
        }

        .site-address {
            display: block;
            margin-top: 5px;
            color: var(--muted);
            font-size: 12px;
        }

        .badge.neutral {
            background: #f0f0f1;
            color: #50575e;
        }

        .row-actions {
            display: flex;
            gap: 8px;
            white-space: nowrap;
        }

        .button:disabled {
            cursor: not-allowed;
            opacity: 0.6;
        }

        .ui-notice {
            margin: 0 0 18px;
            padding: 12px 14px;
            border: 1px solid #c5d9ed;
            border-radius: 8px;
            background: #f0f6fc;
            color: #245780;
            font-size: 13px;
            line-height: 1.5;
        }

        .empty-hint {
            margin: 0;
            padding: 20px;
            color: var(--muted);
            font-size: 13px;
        }

        @media (max-width: 700px) {
            .topbar,
            .panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .toolbar { justify-content: flex-start; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/site/management" var="siteManagementUrl"/>
<c:url value="/site/main-page" var="siteMainPageUrl"/>
<c:url value="/site/menu" var="siteMenuUrl"/>
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
            <div class="menu-group-label">콘텐츠</div>
            <ul class="menu-submenu">
                <li><a class="menu-leaf" href="${pagesUrl}">페이지</a></li>
                <li><a class="menu-leaf" href="${postsUrl}">게시글</a></li>
            </ul>
            <div class="menu-group-label">사이트</div>
            <ul class="menu-submenu">
                <li><a class="menu-leaf active" href="${siteManagementUrl}" aria-current="page">사이트 관리</a></li>
                <li><a class="menu-leaf" href="${siteMainPageUrl}">메인 페이지</a></li>
                <li><a class="menu-leaf" href="${siteMenuUrl}">메뉴 관리</a></li>
                <li><span class="menu-leaf">배너 관리</span></li>
                <li><span class="menu-leaf">팝업 관리</span></li>
            </ul>
            <div class="menu-group-label">미디어</div>
            <ul class="menu-submenu">
                <li><a class="menu-leaf" href="${mediaUrl}">미디어 라이브러리</a></li>
            </ul>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">사이트 관리</h2>
                <p class="page-desc">CMS에서 관리할 사이트의 기본 정보를 확인합니다.</p>
            </div>
            <div class="toolbar">
                <button class="button primary" type="button" disabled>＋ 사이트 추가</button>
            </div>
        </div>

        <p class="ui-notice" role="note">사이트 목록과 운영 상태는 저장된 정보를 조회합니다. 사이트 추가·수정·삭제 및 사이트별 메뉴 연결은 아직 구현되지 않았습니다.</p>

        <section class="summary" aria-label="사이트 현황">
            <article class="card">
                <p class="stat-label">등록 사이트</p>
                <p class="stat-value"><c:out value="${siteCount}"/></p>
                <p class="stat-note">현재 등록된 사이트</p>
            </article>
            <article class="card">
                <p class="stat-label">운영 중</p>
                <p class="stat-value"><c:out value="${activeSiteCount}"/></p>
                <p class="stat-note">운영 상태가 활성인 사이트</p>
            </article>
            <article class="card">
                <p class="stat-label">운영 중지</p>
                <p class="stat-value"><c:out value="${inactiveSiteCount}"/></p>
                <p class="stat-note">비활성 상태인 사이트</p>
            </article>
        </section>

        <section class="panel" aria-labelledby="site-list-title">
            <div class="panel-header">
                <div>
                    <h3 class="section-title" id="site-list-title">사이트 목록</h3>
                    <p class="section-desc">등록된 사이트의 이름, 주소와 운영 상태입니다.</p>
                </div>
                <button class="button" type="button" disabled>사이트 선택</button>
            </div>
            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th scope="col">사이트명</th>
                        <th scope="col">사이트 주소</th>
                        <th scope="col">상태</th>
                        <th scope="col">기본 사이트</th>
                        <th scope="col">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${sites}" var="site">
                        <tr>
                            <td><span class="site-name"><c:out value="${site.siteName}"/></span></td>
                            <td>
                                <span class="site-address">
                                    <c:choose>
                                        <c:when test="${not empty site.siteUrl}">
                                            <c:out value="${site.siteUrl}"/>
                                        </c:when>
                                        <c:otherwise>주소 미설정</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${site.status eq 'ACTIVE'}">
                                        <span class="badge success">운영 중</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge warning">중지</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${site.defaultSite}">
                                    <span class="badge neutral">기본</span>
                                </c:if>
                                <c:if test="${not site.defaultSite}">-</c:if>
                            </td>
                            <td>
                                <div class="row-actions">
                                    <button class="button" type="button" disabled>수정</button>
                                    <button class="button" type="button" disabled>삭제</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sites}">
                        <tr>
                            <td colspan="5" class="empty-hint">등록된 사이트가 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
