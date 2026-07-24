<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>페이지 관리</title>
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

        .card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .section-title {
            margin: 0 0 12px;
            font-size: 18px;
        }

        .section-desc {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .notice {
            margin-top: 16px;
            padding: 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: var(--accent-soft);
            color: var(--accent);
            font-size: 13px;
            line-height: 1.6;
        }

        @media (max-width: 1100px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .topbar {
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
            <a class="menu-item active" href="/pages">페이지</a>
            <a class="menu-item" href="/posts">게시글</a>
            <a class="menu-item" href="#">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">페이지 관리</h2>
                <p class="page-desc">페이지 버튼을 눌렀을 때 이동하는 라우트만 연결한 화면입니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="/main">대시보드로 이동</a>
                <a class="button primary" href="/posts">게시글 관리로 이동</a>
            </div>
        </div>

        <section class="card">
            <h3 class="section-title">페이지 화면</h3>
            <p class="section-desc">
                현재는 실제 페이지 편집 기능을 구현하지 않고, 페이지 메뉴 클릭 시 이 화면으로 이동만 되도록
                라우팅만 연결했습니다.
            </p>
            <div class="notice">
                기능 구현은 제외하고 화면 진입만 확인할 수 있도록 구성했습니다.
            </div>
        </section>
    </main>
</div>
</body>
</html>