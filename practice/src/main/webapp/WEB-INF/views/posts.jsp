<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .layout {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 240px 1fr;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar-2) 100%);
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

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            padding: 0 16px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
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

        .summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 24px;
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
        }

        .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .chip {
            display: inline-flex;
            align-items: center;
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
            background: var(--accent-soft);
            border-color: rgba(34, 113, 177, 0.18);
            color: var(--accent);
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
            vertical-align: middle;
        }

        .table th {
            color: var(--muted);
            font-weight: 600;
            background: #fafafa;
        }

        .table tr:hover td {
            background: #fcfcfc;
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

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .mini-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 68px;
            height: 30px;
            padding: 0 10px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
        }

        .note-grid {
            display: grid;
            gap: 12px;
        }

        .notice {
            padding: 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fcfcfc;
        }

        .notice strong {
            display: block;
            margin-bottom: 4px;
        }

        .notice span {
            color: var(--muted);
            font-size: 13px;
        }

        @media (max-width: 1100px) {
            .layout,
            .summary {
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
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title">Practice CMS</h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>
        <nav class="menu">
            <a class="menu-item" href="/main">대시보드</a>
            <a class="menu-item" href="/pages">페이지</a>
            <a class="menu-item active" href="/posts">게시글</a>
            <a class="menu-item" href="#">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">게시글 관리</h2>
                <p class="page-desc">게시글 관리 화면</p>
            </div>
            <div class="toolbar">
                <a class="button" href="/main">대시보드로 이동</a>
                <a class="button ghost" href="#">필터 초기화</a>
                <a class="button primary" href="#">새 게시글 작성</a>
            </div>
        </div>

        <section class="summary">
            <div class="card">
                <p class="stat-label">전체 게시글</p>
                <p class="stat-value">86</p>
                <p class="stat-note">지난달 대비 +12</p>
            </div>
            <div class="card">
                <p class="stat-label">발행됨</p>
                <p class="stat-value">64</p>
                <p class="stat-note">현재 게시 상태 기준</p>
            </div>
            <div class="card">
                <p class="stat-label">예약됨</p>
                <p class="stat-value">11</p>
                <p class="stat-note">이번 주 발행 예정</p>
            </div>
            <div class="card">
                <p class="stat-label">초안</p>
                <p class="stat-value">11</p>
                <p class="stat-note">검토 대기 포함</p>
            </div>
        </section>

        <section class="card">
            <div class="panel-header">
                <div>
                    <h3 class="section-title">게시글 목록</h3>
                    <p class="section-desc">상태 확인용 정적 UI만 구성되어 있습니다.</p>
                </div>
                <div class="filters">
                    <span class="chip active">전체</span>
                    <span class="chip">발행됨</span>
                    <span class="chip">예약됨</span>
                    <span class="chip">초안</span>
                </div>
            </div>

            <table class="table">
                <thead>
                <tr>
                    <th style="width: 28%;">제목</th>
                    <th>카테고리</th>
                    <th>상태</th>
                    <th>작성자</th>
                    <th>수정일</th>
                    <th style="width: 18%;">작업</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>서비스 개편 안내</td>
                    <td>공지</td>
                    <td><span class="badge success">발행됨</span></td>
                    <td>관리자</td>
                    <td>2026-07-24</td>
                    <td>
                        <div class="row-actions">
                            <a class="mini-button" href="#">보기</a>
                            <a class="mini-button" href="#">수정</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>주간 운영 리포트</td>
                    <td>업무</td>
                    <td><span class="badge warning">예약됨</span></td>
                    <td>운영팀</td>
                    <td>2026-07-23</td>
                    <td>
                        <div class="row-actions">
                            <a class="mini-button" href="#">보기</a>
                            <a class="mini-button" href="#">수정</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>콘텐츠 초안 정리</td>
                    <td>기획</td>
                    <td><span class="badge danger">초안</span></td>
                    <td>기획팀</td>
                    <td>2026-07-22</td>
                    <td>
                        <div class="row-actions">
                            <a class="mini-button" href="#">보기</a>
                            <a class="mini-button" href="#">수정</a>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </section>

        <section class="card" style="margin-top: 16px;">
            <div class="panel-header">
                <div>
                    <h3 class="section-title">게시글 관리 메모</h3>
                    <p class="section-desc">추후 기능 연결을 위한 화면 가이드 영역입니다.</p>
                </div>
            </div>
            <div class="note-grid">
                <div class="notice">
                    <strong>목록 화면 중심</strong>
                    <span>게시글 생성, 수정, 삭제 로직은 아직 연결하지 않았습니다.</span>
                </div>
                <div class="notice">
                    <strong>상태 UI만 표시</strong>
                    <span>발행, 예약, 초안 상태를 시각적으로 구분하는 용도입니다.</span>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
