<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 관리</title>
    <style>
        :root {
            --bg: #eef2f6;
            --panel: rgba(255, 255, 255, 0.9);
            --panel-strong: #ffffff;
            --sidebar: #0f1720;
            --sidebar-2: #16202c;
            --accent: #1d72b8;
            --accent-soft: rgba(29, 114, 184, 0.12);
            --accent-strong: #0f5f9e;
            --text: #132033;
            --muted: #667085;
            --border: #d8e0ea;
            --success: #0f9d58;
            --warning: #c58b00;
            --danger: #d63d45;
            --shadow: 0 18px 45px rgba(15, 23, 32, 0.08);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(29, 114, 184, 0.12), transparent 26%),
                radial-gradient(circle at top right, rgba(15, 157, 88, 0.10), transparent 22%),
                linear-gradient(180deg, #f5f8fb 0%, var(--bg) 100%);
            font-family: "Pretendard", "Apple SD Gothic Neo", "Noto Sans KR", sans-serif;
        }

        a {
            color: inherit;
        }

        .layout {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 250px 1fr;
        }

        .sidebar {
            position: sticky;
            top: 0;
            height: 100vh;
            overflow: auto;
            padding: 26px 0;
            color: #fff;
            background: linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar-2) 100%);
            box-shadow: inset -1px 0 0 rgba(255, 255, 255, 0.04);
        }

        .brand {
            padding: 0 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .brand-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        .brand-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.68);
            line-height: 1.5;
        }

        .menu {
            padding: 16px 0;
        }

        .menu-item {
            display: block;
            padding: 14px 24px 14px 28px;
            color: rgba(255, 255, 255, 0.82);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border-left: 4px solid transparent;
            transition: background 0.15s ease, color 0.15s ease, border-color 0.15s ease;
        }

        .menu-item:hover,
        .menu-item.active {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            border-left-color: var(--accent);
        }

        .content {
            padding: 28px;
        }

        .hero {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 20px;
            padding: 26px 28px;
            border: 1px solid rgba(255, 255, 255, 0.55);
            border-radius: 22px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.92) 0%, rgba(245, 250, 255, 0.82) 100%);
            box-shadow: var(--shadow);
            backdrop-filter: blur(8px);
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 12px;
            padding: 7px 12px;
            border-radius: 999px;
            background: var(--accent-soft);
            color: var(--accent-strong);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
        }

        .page-title {
            margin: 0;
            font-size: 32px;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .page-desc {
            margin: 10px 0 0;
            max-width: 720px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
        }

        .toolbar {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .button,
        .chip,
        .mini-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            border: 1px solid var(--border);
            transition: transform 0.15s ease, border-color 0.15s ease, background 0.15s ease;
        }

        .button {
            height: 42px;
            padding: 0 16px;
            border-radius: 12px;
            background: var(--panel-strong);
            color: var(--text);
            font-size: 14px;
            font-weight: 700;
            box-shadow: 0 1px 2px rgba(16, 24, 40, 0.05);
        }

        .button:hover,
        .chip:hover,
        .mini-button:hover {
            transform: translateY(-1px);
        }

        .button.primary {
            background: linear-gradient(135deg, var(--accent) 0%, #165f9f 100%);
            border-color: var(--accent);
            color: #fff;
        }

        .button.ghost {
            background: rgba(29, 114, 184, 0.08);
            border-color: rgba(29, 114, 184, 0.16);
            color: var(--accent-strong);
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 18px;
        }

        .card {
            background: var(--panel);
            border: 1px solid rgba(216, 224, 234, 0.8);
            border-radius: 18px;
            padding: 20px;
            box-shadow: var(--shadow);
            backdrop-filter: blur(8px);
        }

        .stat-label {
            margin: 0 0 10px;
            color: var(--muted);
            font-size: 13px;
            font-weight: 600;
        }

        .stat-value {
            margin: 0;
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .stat-note {
            margin: 10px 0 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .workspace {
            display: grid;
            grid-template-columns: 1.6fr 0.9fr;
            gap: 18px;
            align-items: start;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.03em;
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
            justify-content: flex-end;
        }

        .chip {
            height: 36px;
            padding: 0 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.9);
            color: var(--muted);
            font-size: 13px;
            font-weight: 700;
        }

        .chip.active {
            background: var(--accent-soft);
            border-color: rgba(29, 114, 184, 0.18);
            color: var(--accent-strong);
        }

        .stack {
            display: grid;
            gap: 16px;
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
            padding: 15px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: top;
        }

        .table th {
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            background: rgba(248, 250, 253, 0.9);
        }

        .table tr:hover td {
            background: rgba(245, 249, 253, 0.9);
        }

        .post-title {
            margin: 0;
            font-size: 14px;
            font-weight: 800;
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
            gap: 6px;
            min-height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.01em;
        }

        .badge.success {
            background: rgba(15, 157, 88, 0.12);
            color: var(--success);
        }

        .badge.warning {
            background: rgba(197, 139, 0, 0.14);
            color: var(--warning);
        }

        .badge.danger {
            background: rgba(214, 61, 69, 0.12);
            color: var(--danger);
        }

        .badge.neutral {
            background: rgba(102, 112, 133, 0.12);
            color: var(--muted);
        }

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .mini-button {
            min-width: 68px;
            height: 32px;
            padding: 0 12px;
            border-radius: 10px;
            background: #fff;
            color: var(--text);
            font-size: 12px;
            font-weight: 700;
        }

        .mini-button.primary {
            border-color: rgba(29, 114, 184, 0.18);
            background: var(--accent-soft);
            color: var(--accent-strong);
        }

        .mini-button.danger {
            color: var(--danger);
        }

        .mini-button.muted {
            color: var(--muted);
        }

        .panel-list {
            display: grid;
            gap: 12px;
        }

        .info-box {
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.84);
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

        .draft-preview {
            display: grid;
            gap: 12px;
        }

        .field {
            display: grid;
            gap: 8px;
        }

        .field label {
            font-size: 12px;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .field-value,
        .field-surface {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: #fff;
            padding: 12px 14px;
            font-size: 14px;
        }

        .field-surface {
            min-height: 110px;
            color: var(--muted);
            line-height: 1.7;
            background: linear-gradient(180deg, #fff 0%, #fbfdff 100%);
        }

        .sidebar-footer {
            margin-top: 18px;
            padding: 0 24px;
            color: rgba(255, 255, 255, 0.55);
            font-size: 12px;
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
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.82);
        }

        .route-item span:first-child {
            font-weight: 700;
        }

        .route-item span:last-child {
            color: var(--muted);
            text-align: right;
            font-size: 13px;
        }

        @media (max-width: 1200px) {
            .layout,
            .workspace {
                grid-template-columns: 1fr;
            }

            .sidebar {
                position: static;
                height: auto;
            }

            .summary {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .content {
                padding: 16px;
            }

            .hero,
            .panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .summary {
                grid-template-columns: 1fr;
            }

            .toolbar,
            .filters {
                justify-content: flex-start;
            }

            .page-title {
                font-size: 28px;
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
                <p class="stat-value">86</p>
                <p class="stat-note">전체 관리 대상 게시물 수를 보여주는 요약 카드입니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">발행됨</p>
                <p class="stat-value">64</p>
                <p class="stat-note">외부 공개 상태의 게시글을 시각적으로 구분합니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">예약됨</p>
                <p class="stat-value">11</p>
                <p class="stat-note">발행 시점을 보류한 예약 콘텐츠 영역입니다.</p>
            </div>
            <div class="card">
                <p class="stat-label">초안</p>
                <p class="stat-value">11</p>
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
