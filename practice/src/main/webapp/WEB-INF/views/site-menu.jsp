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
            grid-template-columns: 20px 18px minmax(0, 1fr) auto;
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

        .tree-grip {
            color: #a7adb4;
            font-size: 15px;
            letter-spacing: -3px;
        }

        .tree-caret {
            color: #8c939b;
            font-size: 12px;
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

        .radio-options,
        .check-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .option {
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

        .option.selected .option-mark {
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

        .option.checked .check-mark {
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
                <button class="button primary" type="button" disabled>변경사항 저장</button>
            </div>
        </div>

        <p class="ui-notice" role="note">화면 시안입니다. 메뉴 추가·편집·순서 변경 및 저장 기능은 아직 연결되지 않았습니다.</p>

        <section class="summary" aria-label="메뉴 현황">
            <article class="card">
                <p class="stat-label">전체 메뉴</p>
                <p class="stat-value">8</p>
            </article>
            <article class="card">
                <p class="stat-label">노출 중</p>
                <p class="stat-value">7</p>
            </article>
            <article class="card">
                <p class="stat-label">최대 단계</p>
                <p class="stat-value">3단계</p>
            </article>
        </section>

        <div class="workspace">
            <section class="panel" aria-labelledby="menu-tree-title">
                <div class="panel-header">
                    <div>
                        <h3 class="panel-title" id="menu-tree-title">메뉴 구조</h3>
                        <p class="panel-desc">드래그하여 메뉴 순서를 변경할 수 있습니다.</p>
                    </div>
                    <button class="button" type="button" disabled>＋ 메뉴 추가</button>
                </div>
                <div class="panel-body">
                    <label class="site-select">
                        관리 사이트
                        <select disabled>
                            <option>Practice CMS 기본 사이트</option>
                        </select>
                    </label>

                    <ul class="menu-tree" aria-label="메뉴 트리 예시">
                        <li class="tree-item selected" aria-current="true">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">⌄</span>
                            <span class="tree-label">
                                <span class="tree-name">회사소개</span>
                                <span class="tree-path">/about</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item child">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">인사말</span>
                                <span class="tree-path">/about/greeting</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item child">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">연혁</span>
                                <span class="tree-path">/about/history</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item child">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">오시는 길</span>
                                <span class="tree-path">/about/location</span>
                            </span>
                            <span class="status hidden">숨김</span>
                        </li>
                        <li class="tree-item">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">⌄</span>
                            <span class="tree-label">
                                <span class="tree-name">서비스</span>
                                <span class="tree-path">/services</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item child">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">서비스 소개</span>
                                <span class="tree-path">/services/intro</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">공지사항</span>
                                <span class="tree-path">/posts/notices</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                        <li class="tree-item">
                            <span class="tree-grip" aria-hidden="true">⠿</span>
                            <span class="tree-caret" aria-hidden="true">·</span>
                            <span class="tree-label">
                                <span class="tree-name">문의하기</span>
                                <span class="tree-path">/contact</span>
                            </span>
                            <span class="status">노출</span>
                        </li>
                    </ul>
                    <div class="tree-footer">
                        <span>메뉴 8개 · 최대 3단계</span>
                        <span>순서 변경 기능 준비 중</span>
                    </div>
                </div>
            </section>

            <section class="panel" aria-labelledby="menu-detail-title">
                <div class="panel-header">
                    <div>
                        <h3 class="panel-title" id="menu-detail-title">메뉴 상세 설정</h3>
                        <p class="panel-desc">선택한 메뉴의 이름, 연결 대상과 노출 설정입니다.</p>
                    </div>
                    <span class="status">1차 메뉴</span>
                </div>
                <div class="panel-body">
                    <div class="form-grid">
                        <div class="field">
                            <label for="menu-name">메뉴명</label>
                            <input id="menu-name" type="text" value="회사소개" readonly>
                        </div>
                        <div class="field">
                            <label for="parent-menu">상위 메뉴</label>
                            <select id="parent-menu" disabled>
                                <option>최상위 메뉴</option>
                            </select>
                        </div>

                        <div class="field full">
                            <span class="field-label">메뉴 유형</span>
                            <div class="radio-options" aria-label="메뉴 유형 예시">
                                <span class="option selected"><span class="option-mark"></span>내부 페이지</span>
                                <span class="option"><span class="option-mark"></span>외부 링크</span>
                                <span class="option"><span class="option-mark"></span>메뉴 그룹</span>
                            </div>
                        </div>

                        <div class="field full">
                            <label for="menu-target">연결 페이지</label>
                            <select id="menu-target" disabled>
                                <option>회사소개 페이지 (/about)</option>
                            </select>
                            <span class="field-hint">내부 페이지를 선택하면 해당 페이지로 이동합니다.</span>
                        </div>

                        <div class="form-divider"></div>

                        <div class="field full">
                            <span class="field-label">노출 위치</span>
                            <div class="check-options" aria-label="노출 위치 예시">
                                <span class="option checked"><span class="check-mark">✓</span>PC LNB</span>
                                <span class="option checked"><span class="check-mark">✓</span>모바일 메뉴</span>
                            </div>
                        </div>

                        <div class="field full">
                            <span class="field-label">노출 상태</span>
                            <div class="radio-options" aria-label="노출 상태 예시">
                                <span class="option selected"><span class="option-mark"></span>노출</span>
                                <span class="option"><span class="option-mark"></span>숨김</span>
                            </div>
                        </div>

                        <div class="field full">
                            <span class="field-label">링크 옵션</span>
                            <div class="check-options" aria-label="링크 옵션 예시">
                                <span class="option"><span class="check-mark"></span>새 창에서 열기</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button class="button" type="button" disabled>메뉴 삭제</button>
                        <div class="action-group">
                            <button class="button" type="button" disabled>취소</button>
                            <button class="button primary" type="button" disabled>메뉴 저장</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>
</body>
</html>
