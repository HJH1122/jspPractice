<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>${post.title} - 게시글 수정</title>

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

        /* =========================
           Sidebar
        ========================= */

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
           Content
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
            gap: 10px;
            flex-wrap: wrap;
        }

        /* =========================
           Button
        ========================= */

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
            font-family: inherit;
        }

        .button.primary {
            background: var(--accent);
            border-color: var(--accent);
            color: #fff;
        }

        .button:hover {
            opacity: 0.92;
        }

        /* =========================
           Edit Card
        ========================= */

        .edit-card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .edit-header {
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 24px;
        }

        .edit-header-title {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
        }

        .edit-header-desc {
            margin: 8px 0 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        /* =========================
           Form
        ========================= */

        .edit-form {
            display: grid;
            gap: 20px;
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

        .field input,
        .field select,
        .field textarea {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fff;
            padding: 11px 12px;
            font-size: 14px;
            color: var(--text);
            font-family: inherit;
        }

        .field input {
            height: 44px;
        }

        .field input:focus,
        .field select:focus,
        .field textarea:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 2px rgba(34, 113, 177, 0.1);
        }

        .field textarea {
            min-height: 320px;
            resize: vertical;
            line-height: 1.7;
        }

        .field input::placeholder,
        .field textarea::placeholder {
            color: #a7aaad;
        }

        /* =========================
           Form Actions
        ========================= */

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
            margin-top: 4px;
        }

        .form-actions-left,
        .form-actions-right {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        /* =========================
           Info
        ========================= */

        .info-box {
            margin-top: 20px;
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
           Responsive
        ========================= */

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

            .edit-card {
                padding: 20px;
            }

            .page-title {
                font-size: 24px;
            }

            .edit-header-title {
                font-size: 20px;
            }

            .form-actions {
                align-items: flex-start;
                flex-direction: column;
            }

            .form-actions-left,
            .form-actions-right {
                width: 100%;
            }

            .form-actions .button {
                flex: 1;
            }

        }

    </style>

</head>

<body>

<c:url value="/main" var="mainUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/posts" var="postsUrl"/>

<div class="layout">

    <!-- =========================
         Sidebar
    ========================= -->

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

            <a class="menu-item"
               href="${mainUrl}">
                대시보드
            </a>

            <a class="menu-item"
               href="${pagesUrl}">
                페이지
            </a>

            <a class="menu-item active"
               href="${postsUrl}">
                게시글
            </a>

            <a class="menu-item"
               href="#">
                미디어
            </a>

            <a class="menu-item"
               href="#">
                댓글
            </a>

            <a class="menu-item"
               href="#">
                설정
            </a>

        </nav>

        <div class="sidebar-footer">
            게시글 수정 화면
        </div>

    </aside>


    <!-- =========================
         Main Content
    ========================= -->

    <main class="content">

        <!-- 상단 -->

        <section class="topbar">

            <div>

                <p class="page-desc">
                    Posts Studio
                </p>

                <h2 class="page-title">
                    게시글 수정
                </h2>

            </div>

            <div class="toolbar">

                <a class="button"
                   href="${postsUrl}">
                    목록으로
                </a>

                <a class="button"
                   href="${postsUrl}/detail?id=${post.id}">
                    상세보기
                </a>

            </div>

        </section>


        <!-- =========================
             수정 카드
        ========================= -->

        <section class="edit-card">

            <header class="edit-header">

                <h3 class="edit-header-title">
                    게시글 정보 수정
                </h3>

                <p class="edit-header-desc">
                    게시글의 제목, slug, 요약, 작성자, 썸네일,
                    게시 상태와 본문을 수정할 수 있습니다.
                </p>

            </header>


            <!-- =========================
                 수정 Form
            ========================= -->

            <form method="post"
                  action="${postsUrl}/edit"
                  class="edit-form">

                <!-- ID -->

                <input type="hidden"
                       name="id"
                       value="${post.id}">


                <!-- CSRF -->

                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">


                <!-- 제목 -->

                <div class="field">

                    <label for="post-title">
                        제목
                    </label>

                    <input type="text"
                           id="post-title"
                           name="title"
                           value="${post.title}"
                           maxlength="200"
                           placeholder="게시글 제목을 입력하세요"
                           required>

                </div>


                <!-- Slug -->

                <div class="field">

                    <label for="post-slug">
                        Slug
                    </label>

                    <input type="text"
                           id="post-slug"
                           name="slug"
                           value="${post.slug}"
                           maxlength="200"
                           placeholder="예: service-update"
                           required>

                </div>


                <!-- 요약 -->

                <div class="field">

                    <label for="post-summary">
                        요약
                    </label>

                    <input type="text"
                           id="post-summary"
                           name="summary"
                           value="${post.summary}"
                           maxlength="500"
                           placeholder="게시글 요약을 입력하세요">

                </div>


                <!-- 작성자 -->

                <div class="field">

                    <label for="post-author">
                        작성자
                    </label>

                    <input type="text"
                           id="post-author"
                           name="author"
                           value="${post.author}"
                           maxlength="100"
                           placeholder="작성자를 입력하세요"
                           required>

                </div>


                <!-- 썸네일 URL -->

                <div class="field">

                    <label for="post-thumbnail">
                        썸네일 URL
                    </label>

                    <input type="text"
                           id="post-thumbnail"
                           name="thumbnailUrl"
                           value="${post.thumbnailUrl}"
                           placeholder="https://example.com/image.jpg">

                </div>


                <!-- 상태 -->

                <div class="field">

                    <label for="post-status">
                        게시 상태
                    </label>

                    <select id="post-status"
                            name="status"
                            required>

                        <option value="DRAFT"
                            <c:if test="${post.status == 'DRAFT'}">
                                selected
                            </c:if>>
                            초안
                        </option>

                        <option value="PUBLISHED"
                            <c:if test="${post.status == 'PUBLISHED'}">
                                selected
                            </c:if>>
                            발행됨
                        </option>

                        <option value="SCHEDULED"
                            <c:if test="${post.status == 'SCHEDULED'}">
                                selected
                            </c:if>>
                            예약됨
                        </option>

                    </select>

                </div>


                <!-- 본문 -->

                <div class="field">

                    <label for="post-content">
                        본문
                    </label>

                    <textarea id="post-content"
                              name="content"
                              placeholder="게시글 본문을 입력하세요"
                              required>${post.content}</textarea>

                </div>


                <!-- 버튼 -->

                <div class="form-actions">

                    <div class="form-actions-left">

                        <a class="button"
                           href="${postsUrl}/detail?id=${post.id}">
                            취소
                        </a>

                    </div>

                    <div class="form-actions-right">

                        <button type="reset"
                                class="button">
                            초기화
                        </button>

                        <button type="submit"
                                class="button primary">
                            수정 저장
                        </button>

                    </div>

                </div>

            </form>


            <!-- 안내 -->

            <div class="info-box">

                <strong>
                    게시글 수정 안내
                </strong>

                <span>
                    수정 저장 버튼을 누르면 POST /posts/edit로
                    게시글 수정 요청이 전송됩니다.
                    수정이 완료되면 게시글 목록으로 이동하도록
                    Controller에서 처리할 수 있습니다.
                </span>

            </div>

        </section>

    </main>

</div>

</body>

</html>