<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        /* =========================
           Layout
           ========================= */

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

        /* =========================
           Content / Topbar
           ========================= */

        .content {
            padding: 24px;
        }

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

        /* =========================
           Buttons
           ========================= */

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

        .button:hover {
            opacity: 0.92;
        }

        /* =========================
           Summary
           ========================= */

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

        /* =========================
           Workspace
           ========================= */

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

        /* =========================
           Filters
           ========================= */

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

        /* =========================
           Table
           ========================= */

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

        /* =========================
           Badge
           ========================= */

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

        /* =========================
           Row Actions
           ========================= */

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

        .mini-button:hover {
            opacity: 0.92;
        }

        /* =========================
           Post Composer
           ========================= */

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

        /* =========================
           Info Boxes
           ========================= */

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

        /* =========================
           Routing
           ========================= */

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

        /* =========================
           Responsive
           ========================= */

        @media (max-width: 1100px) {
            .layout,
            .summary,
            .workspace {
                grid-template-columns: 1fr;
            }

            .topbar,
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
            <h1 class="brand-title">Practice CMS</h1>
            <p class="brand-subtitle">관리자 중심 콘텐츠 운영 화면</p>
        </div>

        <nav class="menu">
            <a class="menu-item" href="${mainUrl}">대시보드</a>
            <a class="menu-item" href="${pagesUrl}">페이지</a>
            <a class="menu-item active" href="${postsUrl}">게시글</a>
            <a class="menu-item" href="#">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>

        <div class="sidebar-footer">
            현재 화면은 게시글 UI 전용이며 저장, 삭제, 검색 동작은 연결하지 않았습니다.
        </div>
    </aside>

    <main class="content">
        <section class="hero">
            <div>
                <p class="hero-eyebrow">Posts Studio</p>
                <h2 class="page-title">게시글 관리</h2>
               
            </div>

            <div class="toolbar">
                <a class="button" href="${mainUrl}">대시보드</a>
                <a class="button ghost" href="${pagesUrl}">페이지 관리</a>
                <a class="button primary" href="#composer">새 게시글 작성</a>
            </div>
        </section>

        <section class="summary">
            <div class="card">
                <p class="stat-label">전체 게시글</p>
                <p class="stat-value">${totalCount}</p>
                <p class="stat-note">전체 관리 대상 게시물 수를 보여주는 요약 카드입니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">발행됨</p>
                <p class="stat-value">${publishedCount}</p>
                <p class="stat-note">외부 공개 상태의 게시글을 시각적으로 구분합니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">예약됨</p>
                <p class="stat-value">${scheduledCount}</p>
                <p class="stat-note">발행 시점을 보류한 예약 콘텐츠 영역입니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">초안</p>
                <p class="stat-value">${draftCount}</p>
                <p class="stat-note">작성 중이거나 검토 대기인 콘텐츠를 뜻합니다.</p>
            </div>
        </section>

        <div class="workspace">
            <section class="card stack">
                <div class="panel-header">
                    <div>
                        <h3 class="section-title">게시글 목록</h3>
                        
                    </div>

                    <div class="filters">
                        <span class="chip active">전체</span>
                        <span class="chip">발행됨</span>
                        <span class="chip">예약됨</span>
                        <span class="chip">초안</span>
                    </div>
                </div>

                <div class="table-wrap">
                    <table class="table">
                        <thead>
                        <tr>
                            <th style="width: 30%;">제목</th>
                            <th>카테고리</th>
                            <th>상태</th>
                            <th>작성자</th>
                            <th>수정일</th>
                            <th style="width: 18%;">작업</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <p class="post-title">서비스 개편 안내</p>
                                <p class="post-meta">업데이트 배너와 본문 요약이 함께 노출되는 게시글 카드형 행입니다.</p>
                            </td>
                            <td><span class="badge neutral">공지</span></td>
                            <td><span class="badge success">발행됨</span></td>
                            <td>관리자</td>
                            <td>2026-07-24</td>
                            <td>
                                <div class="row-actions">
                                    <a class="mini-button primary" href="#composer">보기</a>
                                    <a class="mini-button" href="#composer">수정</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p class="post-title">주간 운영 리포트</p>
                                <p class="post-meta">예약 발행 시각과 발행 상태를 강조하는 예시 행입니다.</p>
                            </td>
                            <td><span class="badge neutral">업무</span></td>
                            <td><span class="badge warning">예약됨</span></td>
                            <td>운영팀</td>
                            <td>2026-07-23</td>
                            <td>
                                <div class="row-actions">
                                    <a class="mini-button primary" href="#composer">보기</a>
                                    <a class="mini-button" href="#composer">수정</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p class="post-title">콘텐츠 초안 정리</p>
                                <p class="post-meta">초안과 검토 상태를 보여주는 내부 작성용 카드입니다.</p>
                            </td>
                            <td><span class="badge neutral">기획</span></td>
                            <td><span class="badge danger">초안</span></td>
                            <td>기획팀</td>
                            <td>2026-07-22</td>
                            <td>
                                <div class="row-actions">
                                    <a class="mini-button primary" href="#composer">보기</a>
                                    <a class="mini-button" href="#composer">수정</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p class="post-title">고객 사례 인터뷰</p>
                                <p class="post-meta">대표 이미지, 제목, 짧은 요약이 함께 배치되는 예시입니다.</p>
                            </td>
                            <td><span class="badge neutral">사례</span></td>
                            <td><span class="badge success">발행됨</span></td>
                            <td>콘텐츠팀</td>
                            <td>2026-07-20</td>
                            <td>
                                <div class="row-actions">
                                    <a class="mini-button primary" href="#composer">보기</a>
                                    <a class="mini-button" href="#composer">수정</a>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <aside class="stack">
                <section class="card" id="composer">
                    <div class="panel-header">
                        <div>
                            <h3 class="section-title">게시글 작성 패널</h3>
                            <p class="section-desc">
                                입력 컴포넌트의 배치만 보여주는 UI 목업입니다.
                            </p>
                        </div>
                    </div>

                    <div class="draft-preview">
                        <div class="field">
                            <label>제목</label>
                            <div class="field-value">서비스 개편 안내</div>
                        </div>

                        <div class="field">
                            <label>카테고리</label>
                            <div class="field-value">공지 / 운영 / 기획</div>
                        </div>

                        <div class="field">
                            <label>게시 상태</label>
                            <div class="field-value">발행됨</div>
                        </div>

                        <div class="field">
                            <label>본문 미리보기</label>
                            <div class="field-surface">
                                게시글 본문이 들어갈 영역입니다. 실제 에디터나 저장 기능은 연결하지 않았고,
                                레이아웃과 간격만 검토할 수 있도록 미리보기 박스로 구성했습니다.
                            </div>
                        </div>

                        <div class="row-actions">
                            <a class="mini-button primary" href="#">임시 저장</a>
                            <a class="mini-button" href="#">미리보기</a>
                            <a class="mini-button danger" href="#">삭제</a>
                        </div>
                    </div>
                </section>

                <section class="card">
                    <div class="panel-header">
                        <div>
                            <h3 class="section-title">라우팅 안내</h3>
                            <p class="section-desc">이 화면에서 사용하는 실제 이동 경로만 정리했습니다.</p>
                        </div>
                    </div>

                    <div class="route-list">
                        <div class="route-item">
                            <span>대시보드</span>
                            <span>${mainUrl}</span>
                        </div>
                        <div class="route-item">
                            <span>페이지 관리</span>
                            <span>${pagesUrl}</span>
                        </div>
                        <div class="route-item">
                            <span>게시글 화면</span>
                            <span>${postsUrl}</span>
                        </div>
                    </div>
                </section>

                <section class="card">
                    <div class="panel-header">
                        <div>
                            <h3 class="section-title">화면 메모</h3>
                            <p class="section-desc">기능 연결 전 상태를 명확히 보여주기 위한 설명 카드입니다.</p>
                        </div>
                    </div>

                    <div class="panel-list">
                        <div class="info-box">
                            <strong>UI 전용</strong>
                            <span>목록, 작성, 미리보기 구조만 배치했습니다.</span>
                        </div>
                        <div class="info-box">
                            <strong>실제 동작 없음</strong>
                            <span>검색, 저장, 삭제, 편집 로직은 아직 연결하지 않았습니다.</span>
                        </div>
                    </div>
                </section>
            </aside>
        </div>
    </main>
</div>
</body>
</html>
