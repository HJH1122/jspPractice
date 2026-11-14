<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이트 메뉴 관리</title>
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

        .workspace {
            display: grid;
            grid-template-columns: minmax(320px, 0.9fr) minmax(420px, 1.1fr);
            align-items: start;
            gap: 18px;
        }

        .panel {
            min-width: 0;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 1px 2px var(--shadow);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            padding: 20px 20px 16px;
            border-bottom: 1px solid var(--border);
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

        .panel-body { padding: 20px; }

        .site-select {
            display: grid;
            gap: 8px;
            margin-bottom: 16px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 600;
        }

        .site-select select,
        .field input,
        .field select {
            width: 100%;
            min-height: 42px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #f7f8fa;
            color: var(--text);
            font: inherit;
            font-size: 14px;
        }

        .menu-tree {
            display: grid;
            gap: 6px;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .tree-item {
            display: grid;
            grid-template-columns: 18px minmax(0, 1fr) auto auto;
            align-items: center;
            gap: 8px;
            min-height: 52px;
            padding: 8px 10px;
            border: 1px solid transparent;
            border-radius: 8px;
        }

        .tree-item.selected {
            border-color: #b7d2ec;
            background: #f0f6fc;
        }

        .tree-item.child { margin-left: 26px; }

        .tree-marker {
            color: #8c939b;
            font-size: 12px;
            text-align: center;
        }

        .tree-drag-handle {
            display: inline-block;
            color: #8c939b;
            cursor: grab;
            touch-action: none;
            user-select: none;
        }

        .tree-drag-handle:active { cursor: grabbing; }

        .tree-item.dragging { opacity: 0.45; }

        .tree-item.drag-over {
            border-color: var(--accent);
            background: var(--accent-soft);
        }

        .tree-select {
            display: block;
            min-width: 0;
        }

        .tree-actions {
            display: flex;
            gap: 4px;
        }

        .tree-actions form { margin: 0; }

        .tree-action {
            display: grid;
            width: 30px;
            height: 30px;
            place-items: center;
            padding: 0;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: #fff;
            color: #50575e;
            font-size: 15px;
            cursor: pointer;
        }

        .tree-action:hover:not(:disabled) {
            border-color: var(--accent);
            color: var(--accent);
        }

        .tree-action:disabled {
            color: #a7adb4;
            cursor: not-allowed;
        }

        .tree-label {
            min-width: 0;
        }

        .tree-name {
            display: block;
            overflow: hidden;
            color: var(--text);
            font-size: 14px;
            font-weight: 600;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .tree-path {
            display: block;
            margin-top: 3px;
            overflow: hidden;
            color: var(--muted);
            font-size: 11px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .status {
            padding: 5px 8px;
            border-radius: 999px;
            background: #e8f5ec;
            color: #18743a;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status.hidden {
            background: #f0f0f1;
            color: #646970;
        }

        .tree-footer {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 16px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            color: var(--muted);
            font-size: 12px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .field {
            display: grid;
            align-content: start;
            gap: 8px;
        }

        .field.full { grid-column: 1 / -1; }

        .field label,
        .field-label {
            color: var(--text);
            font-size: 13px;
            font-weight: 600;
        }

        .field-hint {
            color: var(--muted);
            font-size: 12px;
            line-height: 1.45;
        }

        .field input[type="text"],
        .field input[type="url"] {
            background: #fff;
        }

        .field input:focus,
        .field select:focus {
            outline: 2px solid rgba(34, 113, 177, 0.18);
            border-color: var(--accent);
        }

        .field-panel.is-hidden { display: none; }

        .radio-options,
        .check-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .option {
            position: relative;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            min-height: 40px;
            padding: 0 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            color: #50575e;
            font-size: 13px;
        }

        .option input {
            margin: 0;
            accent-color: var(--accent);
        }

        .option input[type="radio"],
        .option input[type="checkbox"] {
            position: absolute;
            width: 1px;
            height: 1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
        }

        .option:focus-within {
            outline: 2px solid rgba(34, 113, 177, 0.3);
            outline-offset: 2px;
        }

        .option.selected {
            border-color: #b7d2ec;
            background: #f0f6fc;
            color: #135e96;
            font-weight: 600;
        }

        .option-mark {
            width: 14px;
            height: 14px;
            border: 1px solid #a7adb4;
            border-radius: 50%;
            background: #fff;
        }

        .option input[type="radio"]:checked + .option-mark {
            border: 4px solid var(--accent);
        }

        .check-mark {
            display: inline-grid;
            width: 15px;
            height: 15px;
            place-items: center;
            border: 1px solid #a7adb4;
            border-radius: 3px;
            background: #fff;
            color: #fff;
            font-size: 10px;
        }

        .option input[type="checkbox"]:checked + .check-mark {
            border-color: var(--accent);
            background: var(--accent);
        }

        .form-divider {
            grid-column: 1 / -1;
            height: 1px;
            margin: 2px 0;
            background: var(--border);
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .action-group {
            display: flex;
            gap: 8px;
        }

        .button:disabled {
            cursor: not-allowed;
            opacity: 0.62;
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

        .ui-notice.success {
            border-color: #b8dfc5;
            background: #effaf2;
            color: #18743a;
        }

        .ui-notice.error {
            border-color: #f0b7b9;
            background: #fcf0f1;
            color: #b32d2e;
        }

        .summary {
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .summary .card { padding: 16px 18px; }
        .summary .stat-value { font-size: 23px; }

        @media (max-width: 1100px) {
            .workspace { grid-template-columns: 1fr; }
            .summary { grid-template-columns: repeat(3, minmax(0, 1fr)); }
        }

        @media (max-width: 640px) {
            .content { padding: 18px 14px; }
            .summary { grid-template-columns: 1fr; }
            .form-grid { grid-template-columns: 1fr; }
            .field.full,
            .form-divider { grid-column: auto; }
            .panel-header,
            .form-actions { flex-direction: column; align-items: stretch; }
            .form-actions > .action-group { justify-content: flex-end; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
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
                <li><a class="menu-leaf" href="${siteMainPageUrl}">메인 페이지</a></li>
                <li><a class="menu-leaf active" href="${siteMenuUrl}" aria-current="page">메뉴 관리</a></li>
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
                <h2 class="page-title">사이트 메뉴 관리</h2>
                <p class="page-desc">사이트 LNB에 표시할 메뉴 구조와 메뉴별 설정을 관리합니다.</p>
            </div>
            <div class="toolbar">
                <button class="button" type="button" disabled>미리보기</button>
                <button class="button primary" type="submit" form="menu-detail-form">변경사항 저장</button>
            </div>
        </div>

        <c:if test="${not empty message}">
            <p class="ui-notice success" role="status"><c:out value="${message}"/></p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="ui-notice error" role="alert"><c:out value="${error}"/></p>
        </c:if>
        <p class="ui-notice" role="note">메뉴를 추가·삭제하고 같은 단계 안에서 순서를 바꿀 수 있습니다. 상세 설정에서 상위 메뉴도 변경할 수 있습니다.</p>

        <section class="summary" aria-label="메뉴 현황">
            <article class="card">
                <p class="stat-label">전체 메뉴</p>
                <p class="stat-value"><c:out value="${totalMenuCount}"/></p>
            </article>
            <article class="card">
                <p class="stat-label">노출 중</p>
                <p class="stat-value"><c:out value="${visibleMenuCount}"/></p>
            </article>
            <article class="card">
                <p class="stat-label">최대 단계</p>
                <p class="stat-value">2단계</p>
            </article>
        </section>

        <div class="workspace">
            <section class="panel" aria-labelledby="menu-tree-title">
                <div class="panel-header">
                    <div>
                        <h3 class="panel-title" id="menu-tree-title">메뉴 구조</h3>
                        <p class="panel-desc">메뉴를 드래그하거나 화살표로 같은 단계 안에서 순서를 조정할 수 있습니다.</p>
                    </div>
                    <form id="menu-add-form" method="post" action="${pageContext.request.contextPath}/site/menu/add">
                        <input id="menu-order-csrf" type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button class="button" type="submit">＋ 메뉴 추가</button>
                    </form>
                </div>
                <div class="panel-body">
                    <label class="site-select">
                        관리 사이트
                        <select disabled>
                            <option>Practice CMS 기본 사이트</option>
                        </select>
                    </label>

                    <ul class="menu-tree" aria-label="메뉴 목록">
                        <c:forEach items="${menuItems}" var="menuItem">
                            <li class="tree-item ${menuItem.menuId eq selectedMenu.menuId ? 'selected' : ''} ${not empty menuItem.parentMenuId ? 'child' : ''}"
                                data-menu-id="${menuItem.menuId}" data-parent-id="${menuItem.parentMenuId}">
                                <span class="tree-marker">
                                    <span class="tree-drag-handle" draggable="true" aria-hidden="true"
                                          title="드래그하여 순서 변경">⠿</span>
                                </span>
                                <a class="tree-select" href="${pageContext.request.contextPath}/site/menu/${menuItem.menuId}"
                                   aria-current="${menuItem.menuId eq selectedMenu.menuId ? 'page' : ''}">
                                    <span class="tree-label">
                                        <span class="tree-name"><c:out value="${menuItem.menuName}"/></span>
                                        <span class="tree-path"><c:out value="${menuItem.targetLabel}"/></span>
                                    </span>
                                </a>
                                <span class="status ${menuItem.visible ? '' : 'hidden'}">
                                    <c:out value="${menuItem.visible ? '노출' : '숨김'}"/>
                                </span>
                                <span class="tree-actions" aria-label="메뉴 순서">
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/site/menu/${menuItem.menuId}/order">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <input type="hidden" name="direction" value="up">
                                        <button class="tree-action" type="submit" aria-label="위로 이동"
                                                ${menuItem.firstSibling ? 'disabled' : ''}>↑</button>
                                    </form>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/site/menu/${menuItem.menuId}/order">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <input type="hidden" name="direction" value="down">
                                        <button class="tree-action" type="submit" aria-label="아래로 이동"
                                                ${menuItem.lastSibling ? 'disabled' : ''}>↓</button>
                                    </form>
                                </span>
                            </li>
                        </c:forEach>
                    </ul>
                    <div class="tree-footer">
                        <span>메뉴 <c:out value="${totalMenuCount}"/>개 · 최대 2단계</span>
                        <span>같은 단계 내 순서 변경</span>
                    </div>
                </div>
            </section>

            <section class="panel" aria-labelledby="menu-detail-title">
                <div class="panel-header">
                    <div>
                        <h3 class="panel-title" id="menu-detail-title">메뉴 상세 설정</h3>
                        <p class="panel-desc">선택한 메뉴의 이름, 연결 대상과 노출 설정입니다.</p>
                    </div>
                    <span class="status">
                        <c:out value="${empty selectedMenu.parentMenuId ? '1차 메뉴' : '하위 메뉴'}"/>
                    </span>
                </div>
                <div class="panel-body">
                    <form id="menu-delete-form" method="post"
                          action="${pageContext.request.contextPath}/site/menu/${selectedMenu.menuId}/delete"
                          onsubmit="return confirm('선택한 메뉴를 삭제하시겠습니까? 하위 메뉴가 있으면 먼저 이동하거나 삭제해야 합니다.');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </form>
                    <form id="menu-detail-form" method="post"
                          action="${pageContext.request.contextPath}/site/menu/${selectedMenu.menuId}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <div class="form-grid">
                            <div class="field">
                                <label for="menu-name">메뉴명</label>
                                <input id="menu-name" name="menuName" type="text" maxlength="100" required
                                       value="<c:out value='${selectedMenu.menuName}'/>">
                            </div>
                            <div class="field">
                                <label for="parent-menu" id="parent-menu-label">상위 메뉴</label>
                                <select id="parent-menu" name="parentMenuId">
                                    <option value="">최상위 메뉴</option>
                                    <c:forEach items="${parentMenuOptions}" var="parentMenu">
                                        <option value="${parentMenu.menuId}"
                                                ${selectedMenu.parentMenuId eq parentMenu.menuId ? 'selected' : ''}>
                                            <c:out value="${parentMenu.menuName}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <span class="field-hint">최대 2단계까지 설정할 수 있습니다.</span>
                            </div>

                            <div class="field full">
                                <span class="field-label" id="menu-type-label">메뉴 유형</span>
                                <div class="radio-options" role="group" aria-labelledby="menu-type-label">
                                    <label class="option ${selectedMenu.menuType eq 'PAGE' ? 'selected' : ''}">
                                        <input type="radio" name="menuType" value="PAGE"
                                               ${selectedMenu.menuType eq 'PAGE' ? 'checked' : ''}>
                                        <span class="option-mark" aria-hidden="true"></span>내부 페이지
                                    </label>
                                    <label class="option ${selectedMenu.menuType eq 'URL' ? 'selected' : ''}">
                                        <input type="radio" name="menuType" value="URL"
                                               ${selectedMenu.menuType eq 'URL' ? 'checked' : ''}>
                                        <span class="option-mark" aria-hidden="true"></span>외부 링크
                                    </label>
                                    <label class="option ${selectedMenu.menuType eq 'GROUP' ? 'selected' : ''}">
                                        <input type="radio" name="menuType" value="GROUP"
                                               ${selectedMenu.menuType eq 'GROUP' ? 'checked' : ''}>
                                        <span class="option-mark" aria-hidden="true"></span>메뉴 그룹
                                    </label>
                                </div>
                            </div>

                            <div class="field full field-panel ${selectedMenu.menuType eq 'PAGE' ? '' : 'is-hidden'}"
                                 id="page-target-panel">
                                <label for="page-target">연결 페이지</label>
                                <select id="page-target" name="pageId">
                                    <option value="">페이지를 선택해 주세요</option>
                                    <c:forEach items="${publishedPages}" var="page">
                                        <option value="${page.id}"
                                                ${selectedMenu.pageId eq page.id ? 'selected' : ''}>
                                            <c:out value="${page.title}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <span class="field-hint">발행된 페이지만 연결할 수 있습니다.</span>
                            </div>

                            <div class="field full field-panel ${selectedMenu.menuType eq 'URL' ? '' : 'is-hidden'}"
                                 id="url-target-panel">
                                <label for="external-url">외부 링크 주소</label>
                                <input id="external-url" name="externalUrl" type="url" maxlength="2000"
                                       placeholder="https://example.com"
                                       value="<c:out value='${selectedMenu.externalUrl}'/>">
                                <span class="field-hint">http 또는 https 주소를 입력해 주세요.</span>
                            </div>

                            <div class="field full field-panel ${selectedMenu.menuType eq 'GROUP' ? '' : 'is-hidden'}"
                                 id="group-target-panel">
                                <span class="field-hint">메뉴 그룹은 하위 메뉴를 묶는 용도로 사용하며 별도 링크는 연결하지 않습니다.</span>
                            </div>

                            <div class="form-divider"></div>

                            <div class="field full">
                                <span class="field-label" id="display-position-label">노출 위치</span>
                                <div class="check-options" role="group" aria-labelledby="display-position-label">
                                    <label class="option ${selectedMenu.displayPc ? 'selected' : ''}">
                                        <input type="checkbox" name="displayPc" value="true"
                                               ${selectedMenu.displayPc ? 'checked' : ''}>
                                        <span class="check-mark" aria-hidden="true">✓</span>PC LNB
                                    </label>
                                    <label class="option ${selectedMenu.displayMobile ? 'selected' : ''}">
                                        <input type="checkbox" name="displayMobile" value="true"
                                               ${selectedMenu.displayMobile ? 'checked' : ''}>
                                        <span class="check-mark" aria-hidden="true">✓</span>모바일 메뉴
                                    </label>
                                </div>
                            </div>

                            <div class="field full">
                                <span class="field-label" id="visibility-label">노출 상태</span>
                                <div class="radio-options" role="group" aria-labelledby="visibility-label">
                                    <label class="option ${selectedMenu.visible ? 'selected' : ''}">
                                        <input type="radio" name="visible" value="true"
                                               ${selectedMenu.visible ? 'checked' : ''}>
                                        <span class="option-mark" aria-hidden="true"></span>노출
                                    </label>
                                    <label class="option ${not selectedMenu.visible ? 'selected' : ''}">
                                        <input type="radio" name="visible" value="false"
                                               ${not selectedMenu.visible ? 'checked' : ''}>
                                        <span class="option-mark" aria-hidden="true"></span>숨김
                                    </label>
                                </div>
                            </div>

                            <div class="field full field-panel ${selectedMenu.menuType eq 'URL' ? '' : 'is-hidden'}"
                                 id="new-window-panel">
                                <span class="field-label" id="link-options-label">링크 옵션</span>
                                <div class="check-options" role="group" aria-labelledby="link-options-label">
                                    <label class="option ${selectedMenu.openNewWindow ? 'selected' : ''}">
                                        <input type="checkbox" name="openNewWindow" value="true"
                                               ${selectedMenu.openNewWindow ? 'checked' : ''}>
                                        <span class="check-mark" aria-hidden="true">✓</span>새 창에서 열기
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button class="button" type="submit" form="menu-delete-form">메뉴 삭제</button>
                            <div class="action-group">
                                <a class="button" href="${pageContext.request.contextPath}/site/menu/${selectedMenu.menuId}">취소</a>
                                <button class="button primary" type="submit">메뉴 저장</button>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
        </div>
    </main>
</div>
<script>
    (function () {
        var form = document.getElementById("menu-detail-form");
        var pagePanel = document.getElementById("page-target-panel");
        var urlPanel = document.getElementById("url-target-panel");
        var groupPanel = document.getElementById("group-target-panel");
        var newWindowPanel = document.getElementById("new-window-panel");
        var pageTarget = document.getElementById("page-target");
        var externalUrl = document.getElementById("external-url");

        function updateMenuTypeFields() {
            var selectedType = form.querySelector('input[name="menuType"]:checked');
            var menuType = selectedType ? selectedType.value : "";
            pagePanel.classList.toggle("is-hidden", menuType !== "PAGE");
            urlPanel.classList.toggle("is-hidden", menuType !== "URL");
            groupPanel.classList.toggle("is-hidden", menuType !== "GROUP");
            newWindowPanel.classList.toggle("is-hidden", menuType !== "URL");
            pageTarget.required = menuType === "PAGE";
            pageTarget.disabled = menuType !== "PAGE";
            externalUrl.required = menuType === "URL";
            externalUrl.disabled = menuType !== "URL";
            form.querySelector('input[name="openNewWindow"]').disabled = menuType !== "URL";
        }

        form.querySelectorAll('input[name="menuType"]').forEach(function (input) {
            input.addEventListener("change", updateMenuTypeFields);
        });
        form.querySelectorAll(".option input").forEach(function (input) {
            input.addEventListener("change", function () {
                var option = input.closest(".option");
                if (input.type === "radio") {
                    form.querySelectorAll('input[name="' + input.name + '"]').forEach(function (groupInput) {
                        groupInput.closest(".option").classList.toggle("selected", groupInput.checked);
                    });
                } else {
                    option.classList.toggle("selected", input.checked);
                }
            });
        });

        updateMenuTypeFields();
    }());

    (function () {
        var tree = document.querySelector(".menu-tree");
        var draggedItem = null;

        if (!tree) {
            return;
        }

        tree.addEventListener("dragstart", function (event) {
            var handle = event.target.closest(".tree-drag-handle");
            if (!handle) {
                event.preventDefault();
                return;
            }

            draggedItem = handle.closest(".tree-item");
            event.dataTransfer.effectAllowed = "move";
            event.dataTransfer.setData("text/plain", draggedItem.dataset.menuId);
            draggedItem.classList.add("dragging");
        });

        tree.addEventListener("dragover", function (event) {
            if (!draggedItem) {
                return;
            }
            var targetItem = event.target.closest(".tree-item");
            if (!targetItem || targetItem === draggedItem
                    || targetItem.dataset.parentId !== draggedItem.dataset.parentId) {
                return;
            }

            event.preventDefault();
            event.dataTransfer.dropEffect = "move";
            tree.querySelectorAll(".tree-item.drag-over").forEach(function (item) {
                item.classList.remove("drag-over");
            });
            targetItem.classList.add("drag-over");

            var insertAfter = event.clientY
                    > targetItem.getBoundingClientRect().top + targetItem.offsetHeight / 2;
            draggedItem.remove();
            tree.insertBefore(draggedItem, insertAfter ? targetItem.nextElementSibling : targetItem);
        });

        tree.addEventListener("drop", function (event) {
            if (!draggedItem) {
                return;
            }
            event.preventDefault();
            var menuId = draggedItem.dataset.menuId;
            var parentId = draggedItem.dataset.parentId;
            var orderedItems = Array.from(tree.querySelectorAll(".tree-item"))
                    .filter(function (item) {
                        return item.dataset.parentId === parentId;
                    });
            var form = document.createElement("form");
            form.method = "post";
            form.action = "${pageContext.request.contextPath}/site/menu/"
                    + encodeURIComponent(menuId) + "/order";

            function appendInput(name, value) {
                var input = document.createElement("input");
                input.type = "hidden";
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }

            appendInput(document.getElementById("menu-order-csrf").name,
                    document.getElementById("menu-order-csrf").value);
            orderedItems.forEach(function (item) {
                appendInput("menuIds", item.dataset.menuId);
            });
            document.body.appendChild(form);
            form.submit();
        });

        tree.addEventListener("dragend", function () {
            tree.querySelectorAll(".tree-item.dragging, .tree-item.drag-over").forEach(function (item) {
                item.classList.remove("dragging", "drag-over");
            });
            draggedItem = null;
        });
    }());
</script>
</body>
</html>
