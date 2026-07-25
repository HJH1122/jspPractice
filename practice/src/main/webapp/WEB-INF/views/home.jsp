<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Practice CMS</title>
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
            margin-bottom: 24px;
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

        .stats {
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

        .grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 16px;
        }

        .section-title {
            margin: 0 0 16px;
            font-size: 18px;
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
        }

        .table th {
            color: var(--muted);
            font-weight: 600;
            background: #fafafa;
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

        .activity-list {
            display: grid;
            gap: 12px;
        }

        .activity-item {
            padding: 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fcfcfc;
        }

        .activity-item strong {
            display: block;
            margin-bottom: 4px;
        }

        .activity-item span {
            color: var(--muted);
            font-size: 13px;
        }

        @media (max-width: 1100px) {
            .layout,
            .grid,
            .stats {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
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
            <a class="menu-item active" href="/main">대시보드</a>
            <a class="menu-item" href="/pages">페이지</a>
            <a class="menu-item" href="/posts">게시글</a>
            <a class="menu-item" href="#">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">대시보드</h2>
                <p class="page-desc">대시보드 화면</p>
            </div>
            <div class="toolbar">
                <a class="button" href="#">미리보기</a>
                <a class="button primary" href="/pages">새 페이지 작성</a>
            </div>
        </div>

        <section class="stats">
            <div class="card">
                <p class="stat-label">게시 페이지</p>
                <p class="stat-value">18</p>
                <p class="stat-note">최근 7일 기준 +3</p>
            </div>
            <div class="card">
                <p class="stat-label">미디어 파일</p>
                <p class="stat-value">124</p>
                <p class="stat-note">업로드 공간 64% 사용</p>
            </div>
            <div class="card">
                <p class="stat-label">예약 발행</p>
                <p class="stat-value">5</p>
                <p class="stat-note">오늘 2건 예정</p>
            </div>
            <div class="card">
                <p class="stat-label">댓글 검토</p>
                <p class="stat-value">9</p>
                <p class="stat-note">승인 대기 2건 포함</p>
            </div>
        </section>

        <section class="grid">
            <div class="card">
                <h3 class="section-title">최근 편집 콘텐츠</h3>
                <table class="table">
                    <thead>
                    <tr>
                        <th>제목</th>
                        <th>유형</th>
                        <th>상태</th>
                        <th>수정일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>메인 배너 영역</td>
                        <td>페이지</td>
                        <td><span class="badge success">발행됨</span></td>
                        <td>2026-07-22</td>
                    </tr>
                    <tr>
                        <td>공지사항 영역</td>
                        <td>게시글</td>
                        <td><span class="badge warning">예약됨</span></td>
                        <td>2026-07-21</td>
                    </tr>
                    <tr>
                        <td>서비스 소개</td>
                        <td>페이지</td>
                        <td><span class="badge success">발행됨</span></td>
                        <td>2026-07-20</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="card">
                <h3 class="section-title">작업 알림</h3>
                <div class="activity-list">
                    <div class="activity-item">
                        <strong>새 이미지 업로드 필요</strong>
                        <span>대표 섹션용 썸네일을 갱신하세요.</span>
                    </div>
                    <div class="activity-item">
                        <strong>예약 발행 확인</strong>
                        <span>내일 오전 9시 발행 콘텐츠가 2건 있습니다.</span>
                    </div>
                    <div class="activity-item">
                        <strong>상단 메뉴 정리</strong>
                        <span>관리 메뉴를 CMS 구조에 맞게 재배치할 예정입니다.</span>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>