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
        }

        .grid {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
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
        }

        .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filters input,
        .filters select,
        .field input,
        .field select,
        .field textarea {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 11px 12px;
            font-size: 14px;
            background: #fff;
            color: var(--text);
        }

        .filters input:focus,
        .filters select:focus,
        .field input:focus,
        .field select:focus,
        .field textarea:focus {
            outline: 2px solid rgba(34, 113, 177, 0.18);
            border-color: var(--accent);
        }

        .filters input {
            min-width: 220px;
        }

        .filters select {
            min-width: 130px;
        }

        .field-row {
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
        }

        .field textarea {
            min-height: 140px;
            resize: vertical;
        }

        .conditional-field[hidden] {
            display: none;
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
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: top;
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

        .badge.neutral {
            background: rgba(100, 105, 112, 0.12);
            color: var(--muted);
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
            cursor: pointer;
        }

        .mini-button.danger {
            color: var(--danger);
        }

        .mini-button.active {
            background: var(--accent);
            border-color: var(--accent);
            color: #fff;
        }

        .mini-button:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }

        .notice {
            margin-bottom: 16px;
            padding: 14px 16px;
            border: 1px solid rgba(34, 113, 177, 0.18);
            border-radius: 10px;
            background: var(--accent-soft);
            color: var(--accent);
            font-size: 13px;
            line-height: 1.6;
        }

        .empty-state {
            padding: 18px;
            border: 1px dashed var(--border);
            border-radius: 10px;
            color: var(--muted);
            font-size: 14px;
            background: #fcfcfc;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .muted-line {
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .pagination {
            margin-top: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            padding-top: 14px;
            border-top: 1px solid var(--border);
        }

        .pagination-info {
            font-size: 13px;
            color: var(--muted);
        }

        .pagination-form {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
        }

        .ck-editor__editable {
            min-height: 400px;
        }

        @media (max-width: 1100px) {
            .layout,
            .summary,
            .grid {
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

            .pagination {
                align-items: flex-start;
            }
        }
    </style>
</head>

<body>

<c:url value="/main" var="mainUrl"/>
<c:url value="/posts" var="postsUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/posts" var="saveUrl"/>
<c:url value="/posts/delete" var="deleteUrl"/>

<div class="layout">

    <aside class="sidebar">

        <div class="brand">
            <h1 class="brand-title">Practice CMS</h1>
            <p class="brand-subtitle">
                WordPress 스타일 관리 화면
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

    </aside>

    <main class="content">

        <div class="topbar">

            <div>

                <h2 class="page-title">
                    게시글 관리
                </h2>

                <p class="page-desc">
                    게시글 목록 조회, 검색, 작성, 수정, 삭제를 한 화면에서 처리합니다.
                </p>

            </div>

            <div class="toolbar">

                <a class="button"
                   href="${mainUrl}">
                    대시보드로 이동
                </a>

                <a class="button ghost"
                   href="${postsUrl}">
                    새 게시글 작성
                </a>

            </div>

        </div>

        <c:if test="${not empty message}">

            <div class="notice">
                <c:out value="${message}"/>
            </div>

        </c:if>

        <section class="summary">

            <div class="card">

                <p class="stat-label">
                    전체 게시글
                </p>

                <p class="stat-value">
                    ${totalCount}
                </p>

                <p class="stat-note">
                    전체 게시글 수
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    발행됨
                </p>

                <p class="stat-value">
                    ${publishedCount}
                </p>

                <p class="stat-note">
                    외부에 공개된 게시글
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    예약됨
                </p>

                <p class="stat-value">
                    ${scheduledCount}
                </p>

                <p class="stat-note">
                    예약 발행 상태의 게시글
                </p>

            </div>

            <div class="card">

                <p class="stat-label">
                    초안
                </p>

                <p class="stat-value">
                    ${draftCount}
                </p>

                <p class="stat-note">
                    아직 공개되지 않은 게시글
                </p>

            </div>

        </section>

        <div class="grid">

            <section class="card">

                <div class="panel-header">

                    <div>

                        <h3 class="section-title">
                            게시글 목록
                        </h3>

                        <p class="section-desc">
                            검색과 상태 필터를 적용한 게시글 목록입니다.
                        </p>

                    </div>

                    <form class="filters"
                          method="get"
                          action="${postsUrl}">

                        <input
                            type="text"
                            name="query"
                            placeholder="제목, 슬러그, 내용 검색"
                            value="${fn:escapeXml(query)}"
                        >

                        <select name="status">

                            <option
                                value=""
                                <c:if test="${empty status}">
                                    selected
                                </c:if>
                            >
                                전체 상태
                            </option>

                            <option
                                value="PUBLISHED"
                                <c:if test="${status eq 'PUBLISHED'}">
                                    selected
                                </c:if>
                            >
                                발행
                            </option>

                            <option
                                value="SCHEDULED"
                                <c:if test="${status eq 'SCHEDULED'}">
                                    selected
                                </c:if>
                            >
                                예약
                            </option>

                            <option
                                value="DRAFT"
                                <c:if test="${status eq 'DRAFT'}">
                                    selected
                                </c:if>
                            >
                                초안
                            </option>

                        </select>

                        <input
                            type="hidden"
                            name="page"
                            value="1"
                        >

                        <input
                            type="hidden"
                            name="size"
                            value="${size}"
                        >

                        <button
                            class="button primary"
                            type="submit">
                            검색
                        </button>

                    </form>

                </div>

                <div class="table-wrap">

                    <table class="table">

                        <thead>

                        <tr>

                            <th style="width: 25%;">
                                제목
                            </th>

                            <th>
                                슬러그
                            </th>

                            <th>
                                상태
                            </th>

                            <th>
                                작성자
                            </th>

                            <th>
                                조회수
                            </th>

                            <th>
                                수정일
                            </th>

                            <th style="width: 18%;">
                                작업
                            </th>

                        </tr>

                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${empty postRows}">

                                <tr>

                                    <td colspan="7">

                                        <div class="empty-state">
                                            조건에 맞는 게시글이 없습니다.
                                        </div>

                                    </td>

                                </tr>

                            </c:when>

                            <c:otherwise>

                                <c:forEach
                                    items="${postRows}"
                                    var="postRow">

                                    <tr data-id="${postRow.id}" data-slug="${fn:escapeXml(postRow.slug)}">

                                        <td>

                                            <strong>
                                                <c:out value="${postRow.title}"/>
                                            </strong>

                                            <br>

                                            <span class="muted-line">
                                                <c:out value="${postRow.summary}"/>
                                            </span>

                                        </td>

                                        <td>
                                            <c:out value="${postRow.slug}"/>
                                        </td>

                                        <td>

                                            <c:choose>

                                                <c:when test="${postRow.status eq 'PUBLISHED'}">

                                                    <span class="badge success">
                                                        발행
                                                    </span>

                                                </c:when>

                                                <c:when test="${postRow.status eq 'SCHEDULED'}">

                                                    <span class="badge warning">
                                                        예약
                                                    </span>

                                                </c:when>

                                                <c:when test="${postRow.status eq 'DRAFT'}">

                                                    <span class="badge neutral">
                                                        초안
                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span class="badge neutral">
                                                        <c:out value="${postRow.status}"/>
                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </td>

                                        <td>
                                            <c:out value="${postRow.author}"/>
                                        </td>

                                        <td>
                                            <c:out value="${postRow.viewCount}"/>
                                        </td>

                                        <td>
                                            <c:out value="${postRow.updatedAt}"/>
                                        </td>

                                        <td>

                                            <div class="row-actions">

                                                <c:url
                                                    value="/posts/edit"
                                                    var="editPostUrl">

                                                    <c:param
                                                        name="id"
                                                        value="${postRow.id}"/>

                                                    <c:param
                                                        name="query"
                                                        value="${query}"/>

                                                    <c:param
                                                        name="status"
                                                        value="${status}"/>

                                                    <c:param
                                                        name="page"
                                                        value="${page}"/>

                                                </c:url>

                                                <a
                                                    class="mini-button"
                                                    href="${editPostUrl}">
                                                    수정
                                                </a>

                                                <form
                                                    method="post"
                                                    action="${deleteUrl}"
                                                    style="margin: 0; display: inline;"
                                                >

                                                    <input
                                                        type="hidden"
                                                        name="id"
                                                        value="${postRow.id}"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="returnQuery"
                                                        value="${query}"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="returnStatus"
                                                        value="${status}"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="returnPage"
                                                        value="${page}"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="${_csrf.parameterName}"
                                                        value="${_csrf.token}"
                                                    >

                                                    <button
                                                        class="mini-button danger delete-button"
                                                        type="submit">
                                                        삭제
                                                    </button>

                                                </form>

                                            </div>

                                        </td>

                                    </tr>

                                </c:forEach>

                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

                <div class="pagination">

                    <div class="pagination-info">

                        총 ${filteredCount}개 중

                        ${page} / ${totalPages}페이지

                    </div>

                    <div class="pagination-form">

                        <c:url
                            value="/posts"
                            var="prevPageUrl">

                            <c:param
                                name="page"
                                value="${page - 1}"/>

                            <c:param
                                name="size"
                                value="${size}"/>

                            <c:param
                                name="query"
                                value="${query}"/>

                            <c:param
                                name="status"
                                value="${status}"/>

                        </c:url>

                        <c:choose>

                            <c:when test="${hasPrev}">

                                <a
                                    class="mini-button"
                                    href="${prevPageUrl}">
                                    이전
                                </a>

                            </c:when>

                            <c:otherwise>

                                <button
                                    class="mini-button"
                                    type="button"
                                    disabled>
                                    이전
                                </button>

                            </c:otherwise>

                        </c:choose>


                        <c:forEach
                            begin="${startPage}"
                            end="${endPage}"
                            var="pageNo">

                            <c:url
                                value="/posts"
                                var="pageUrl">

                                <c:param
                                    name="page"
                                    value="${pageNo}"/>

                                <c:param
                                    name="size"
                                    value="${size}"/>

                                <c:param
                                    name="query"
                                    value="${query}"/>

                                <c:param
                                    name="status"
                                    value="${status}"/>

                            </c:url>

                            <c:choose>

                                <c:when test="${pageNo eq page}">

                                    <button
                                        class="mini-button active"
                                        type="button"
                                        disabled>
                                        ${pageNo}
                                    </button>

                                </c:when>

                                <c:otherwise>

                                    <a
                                        class="mini-button"
                                        href="${pageUrl}">
                                        ${pageNo}
                                    </a>

                                </c:otherwise>

                            </c:choose>

                        </c:forEach>


                        <c:url
                            value="/posts"
                            var="nextPageUrl">

                            <c:param
                                name="page"
                                value="${page + 1}"/>

                            <c:param
                                name="size"
                                value="${size}"/>

                            <c:param
                                name="query"
                                value="${query}"/>

                            <c:param
                                name="status"
                                value="${status}"/>

                        </c:url>

                        <c:choose>

                            <c:when test="${hasNext}">

                                <a
                                    class="mini-button"
                                    href="${nextPageUrl}">
                                    다음
                                </a>

                            </c:when>

                            <c:otherwise>

                                <button
                                    class="mini-button"
                                    type="button"
                                    disabled>
                                    다음
                                </button>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

            </section>


            <aside class="card">

                <div class="panel-header">

                    <div>

                        <c:choose>

                            <c:when test="${empty postForm.id}">

                                <h3 class="section-title">
                                    새 게시글 작성
                                </h3>

                                <p class="section-desc">
                                    새 게시글을 등록합니다.
                                </p>

                            </c:when>

                            <c:otherwise>

                                <h3 class="section-title">
                                    게시글 수정
                                </h3>

                                <p class="section-desc">
                                    선택한 게시글의 내용을 수정합니다.
                                </p>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>


                <form
                    id="post-form"
                    method="post"
                    action="${saveUrl}"
                >

                    <input
                        type="hidden"
                        name="id"
                        value="${postForm.id}"
                    >

                    <input
                        type="hidden"
                        name="returnQuery"
                        value="${query}"
                    >

                    <input
                        type="hidden"
                        name="returnStatus"
                        value="${status}"
                    >

                    <input
                        type="hidden"
                        name="returnPage"
                        value="${page}"
                    >

                    <input
                        type="hidden"
                        name="${_csrf.parameterName}"
                        value="${_csrf.token}"
                    >

                    <div class="field-row">

                        <div class="field">

                            <label for="title">
                                제목
                            </label>

                            <input
                                id="title"
                                type="text"
                                name="title"
                                value="${fn:escapeXml(postForm.title)}"
                                placeholder="게시글 제목을 입력하세요"
                                maxlength="100"
                                required
                            >

                        </div>


                        <div class="field">

                            <label for="slug">
                                슬러그
                            </label>

                            <input
                                id="slug"
                                type="text"
                                name="slug"
                                value="${fn:escapeXml(postForm.slug)}"
                                placeholder="예: hello-world"
                                maxlength="150"
                            >

                        </div>


                        <div class="field">

                            <label for="author">
                                작성자
                            </label>

                            <input
                                id="author"
                                type="text"
                                name="author"
                                value="${fn:escapeXml(postForm.author)}"
                                placeholder="작성자"
                                readonly
                            >

                        </div>


                        <div class="field">

                            <label for="status">
                                상태
                            </label>

                            <select
                                id="status"
                                name="status"
                            >

                                <option
                                    value="DRAFT"
                                    <c:if test="${postForm.status eq 'DRAFT'}">
                                        selected
                                    </c:if>
                                >
                                    초안
                                </option>

                                <option
                                    value="SCHEDULED"
                                    <c:if test="${postForm.status eq 'SCHEDULED'}">
                                        selected
                                    </c:if>
                                >
                                    예약
                                </option>

                                <option
                                    value="PUBLISHED"
                                    <c:if test="${postForm.status eq 'PUBLISHED'}">
                                        selected
                                    </c:if>
                                >
                                    발행
                                </option>

                            </select>

                        </div>


                        <div
                            class="field conditional-field"
                            id="scheduledAtField"
                            hidden
                        >

                            <label for="publishedAt">
                                예약 발행 시각
                            </label>

                            <input
                                id="publishedAt"
                                type="datetime-local"
                                name="publishedAt"
                                value="${postForm.publishedAtInputValue}"
                                step="60"
                            >

                            <p class="muted-line">
                                예약됨 상태일 때만 사용됩니다.
                            </p>

                        </div>


                        <div class="field">

                            <label for="summary">
                                요약
                            </label>

                            <textarea
                                id="summary"
                                name="summary"
                                placeholder="목록에 표시될 간단한 설명"
                                maxlength="100"
                            ><c:out value="${postForm.summary}"/></textarea>

                        </div>


                        <div class="field">

                            <label for="content">
                                본문
                            </label>

                            <textarea
                                id="content"
                                name="content"
                                placeholder="게시글 본문을 입력하세요"
                                maxlength="3000"
                            ><c:out value="${postForm.content}"/></textarea>

                        </div>


                        <p class="muted-line">
                            본문은 CKEditor로 작성됩니다.
                        </p>


                        <div class="form-actions">

                            <button
                                class="button primary"
                                type="submit">
                                저장
                            </button>

                            <c:if test="${empty postForm.id}">

                                <button
                                    class="button ghost"
                                    type="button"
                                    id="new-post-button"
                                >
                                    초기화
                                </button>

                            </c:if>

                        </div>

                    </div>

                </form>

            </aside>

        </div>

    </main>

</div>


<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>

<script>

    (function () {

        const form =
            document.getElementById('post-form');

        const statusSelect =
            document.getElementById('status');

        const scheduledAtField =
            document.getElementById('scheduledAtField');

        const scheduledAtInput =
            document.getElementById('publishedAt');

        const slugInput =
            document.getElementById('slug');

        const newPostButton =
            document.getElementById('new-post-button');


        if (
            !form ||
            !statusSelect ||
            !scheduledAtField ||
            !scheduledAtInput
        ) {
            return;
        }


        const normalizeSlug = function (value) {
            return (value || '')
                .trim()
                .toLowerCase()
                .replace(/[^a-z0-9가-힣]+/g, '-')
                .replace(/^-+|-+$/g, '')
                .replace(/-+/g, '-');
        };

        const checkDuplicateSlug = function (event) {
            const inputValue = slugInput ? slugInput.value : '';
            const normalized = normalizeSlug(inputValue);

            if (!normalized) {
                return;
            }

            const currentId = Number(form.elements.id?.value || 0) || null;
            const duplicateRow = Array.from(
                document.querySelectorAll('.table tbody tr[data-slug]')
            ).find(function (row) {
                const rowSlug = normalizeSlug(row.dataset.slug || '');
                const rowId = Number(row.dataset.id || 0) || null;
                return rowSlug === normalized && rowId !== currentId;
            });

            if (duplicateRow) {
                event.preventDefault();
                alert('이미 사용 중인 slug입니다. 다른 slug를 입력해주세요.');
                if (slugInput) {
                    slugInput.focus();
                    slugInput.select();
                }
                return false;
            }
        };


        form.addEventListener('submit', checkDuplicateSlug);

        let editor = null;


        const toDatetimeLocalValue =
            function (date) {

                const offset =
                    date.getTimezoneOffset();

                const localDate =
                    new Date(
                        date.getTime()
                        - offset * 60000
                    );

                return localDate
                    .toISOString()
                    .slice(0, 16);
            };


        const syncScheduledField =
            function () {

                const isScheduled =
                    statusSelect.value === 'SCHEDULED';

                scheduledAtField.hidden =
                    !isScheduled;

                scheduledAtInput.required =
                    isScheduled;

                if (
                    isScheduled &&
                    !scheduledAtInput.value
                ) {

                    scheduledAtInput.value =
                        toDatetimeLocalValue(
                            new Date()
                        );
                }
            };


        document
            .querySelectorAll('.delete-button')
            .forEach(function (btn) {

                btn.addEventListener(
                    'click',
                    function (e) {

                        if (
                            !confirm(
                                '정말 삭제하시겠습니까?'
                            )
                        ) {
                            e.preventDefault();
                        }

                    }
                );

            });


        statusSelect.addEventListener(
            'change',
            syncScheduledField
        );


        if (newPostButton) {

            newPostButton.addEventListener(
                'click',
                function () {

                    form.elements.id.value = '';
                    form.elements.title.value = '';
                    form.elements.slug.value = '';
                    form.elements.author.value = '';
                    form.elements.status.value = 'DRAFT';
                    form.elements.publishedAt.value = '';
                    form.elements.summary.value = '';

                    if (editor) {

                        editor.setData('');

                    } else {

                        form.elements.content.value = '';

                    }

                    syncScheduledField();

                }
            );

        }


        syncScheduledField();


        const contentElement =
            document.getElementById('content');


        if (contentElement) {

            ClassicEditor
                .create(contentElement)
                .then(function (createdEditor) {

                    editor = createdEditor;

                })
                .catch(function (error) {

                    console.error(
                        'CKEditor 초기화 실패:',
                        error
                    );

                });

        }

    })();

</script>

</body>
</html>