<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>${post.title} - 게시글 상세</title>

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

        a {
            color: inherit;
        }

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
            gap: 10px;
            flex-wrap: wrap;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            padding: 0 16px;
            border: 1px solid var(--border);
            border-radius: 6px;
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

        .button:hover {
            opacity: 0.92;
        }

        .detail-card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .post-header {
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border);
        }

        .post-category {
            display: inline-flex;
            align-items: center;
            height: 28px;
            padding: 0 10px;
            margin-bottom: 14px;
            border-radius: 999px;
            background: rgba(100, 105, 112, 0.12);
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
        }

        .post-title {
            margin: 0;
            font-size: 32px;
            line-height: 1.35;
            word-break: break-word;
        }

        .post-summary {
            margin: 16px 0 0;
            color: var(--muted);
            font-size: 16px;
            line-height: 1.7;
        }

        .post-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 18px;
            margin-top: 20px;
            color: var(--muted);
            font-size: 13px;
        }

        .post-meta-item {
            display: inline-flex;
            gap: 5px;
        }

        .post-meta-item strong {
            color: var(--text);
            font-weight: 600;
        }

        .post-content {
            padding: 32px 0;
            min-height: 300px;
            font-size: 15px;
            line-height: 1.8;
            word-break: break-word;
        }

        .post-content img {
            max-width: 100%;
            height: auto;
        }

        .post-content p {
            margin: 0 0 16px;
        }

        .post-content h1,
        .post-content h2,
        .post-content h3 {
            margin: 28px 0 14px;
        }

        .post-content ul,
        .post-content ol {
            padding-left: 24px;
        }

        .post-content blockquote {
            margin: 20px 0;
            padding: 12px 18px;
            border-left: 4px solid var(--accent);
            background: var(--accent-soft);
            color: var(--muted);
        }

        .post-footer {
            padding-top: 24px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .footer-left,
        .footer-right {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        @media (max-width: 1100px) {

            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                display: none;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 760px) {

            .content {
                padding: 16px;
            }

            .detail-card {
                padding: 20px;
            }

            .post-title {
                font-size: 24px;
            }

            .post-summary {
                font-size: 14px;
            }

            .post-content {
                padding: 24px 0;
                font-size: 14px;
            }

            .post-footer {
                align-items: flex-start;
                flex-direction: column;
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

            <h1 class="brand-title">
                Practice CMS
            </h1>

            <p class="brand-subtitle">
                관리자 중심 콘텐츠 운영 화면
            </p>

        </div>

        <nav class="menu">

            <a
                    class="menu-item"
                    href="${mainUrl}">
                대시보드
            </a>

            <a
                    class="menu-item"
                    href="${pagesUrl}">
                페이지
            </a>

            <a
                    class="menu-item active"
                    href="${postsUrl}">
                게시글
            </a>

            <a
                    class="menu-item"
                    href="#">
                미디어
            </a>

            <a
                    class="menu-item"
                    href="#">
                댓글
            </a>

            <a
                    class="menu-item"
                    href="#">
                설정
            </a>

        </nav>

        <div class="sidebar-footer">
            게시글 상세보기
        </div>

    </aside>

    <main class="content">

        <section class="topbar">

            <div>

                <p class="page-desc">
                    Posts Studio
                </p>

                <h2 class="page-title">
                    게시글 상세보기
                </h2>

            </div>

            <div class="toolbar">

                <a
                        class="button"
                        href="${postsUrl}">
                    목록으로
                </a>

                <a
                        class="button primary"
                        href="${postsUrl}/edit?id=${post.id}">
                    수정
                </a>

            </div>

        </section>

        <article class="detail-card">

            <header class="post-header">

                <c:if test="${not empty post.category}">

                    <span class="post-category">
                        ${post.category}
                    </span>

                </c:if>

                <h1 class="post-title">
                    ${post.title}
                </h1>

                <c:if test="${not empty post.summary}">

                    <p class="post-summary">
                        ${post.summary}
                    </p>

                </c:if>

                <div class="post-meta">

                    <span class="post-meta-item">
                        <strong>작성자</strong>
                        <span>${post.author}</span>
                    </span>

                    <span class="post-meta-item">
                        <strong>상태</strong>
                        <span>${post.status}</span>
                    </span>

                    <span class="post-meta-item">
                        <strong>조회수</strong>
                        <span>${post.viewCount}</span>
                    </span>

                    <span class="post-meta-item">
                        <strong>작성일</strong>
                        <span>${post.createdAt}</span>
                    </span>

                    <span class="post-meta-item">
                        <strong>수정일</strong>
                        <span>${post.updatedAt}</span>
                    </span>

                </div>

            </header>

            <section class="post-content">
                ${post.content}
            </section>

            <footer class="post-footer">

                <div class="footer-left">

                    <a
                            class="button"
                            href="${postsUrl}">
                        목록으로
                    </a>

                </div>

                <div class="footer-right">

                    <a
                            class="button"
                            href="${postsUrl}/edit?id=${post.id}">
                        수정
                    </a>

                </div>

            </footer>

        </article>

    </main>

</div>

</body>

</html>
