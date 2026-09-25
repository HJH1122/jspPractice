<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>댓글 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
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
            margin-bottom: 16px;
        }

        .filters input,
        .filters select {
            min-width: 170px;
            flex: 1;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 11px 12px;
            font-size: 14px;
            background: #fff;
            color: var(--text);
        }

        .filter-actions {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }

        .table-wrap {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fff;
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

        .comment-text {
            max-width: 420px;
            line-height: 1.6;
            color: var(--text);
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

        .badge.neutral {
            background: rgba(100, 105, 112, 0.12);
            color: var(--muted);
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

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .row-actions form {
            display: inline-block;
        }

        @media (max-width: 1100px) {
            .layout,
            .stats {
                grid-template-columns: 1fr;
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
            <a class="menu-item" href="/posts">게시글</a>
            <a class="menu-item" href="/media">미디어</a>
            <a class="menu-item active" href="/comments">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">댓글 관리</h2>
                <p class="page-desc">댓글 목록과 상태를 관리합니다.</p>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="card" style="margin-bottom: 16px; border-color: rgba(0, 163, 42, 0.28); background: rgba(0, 163, 42, 0.04);">
                <p style="margin: 0; color: var(--success); font-weight: 700;">${message}</p>
            </div>
        </c:if>

        <section class="stats">
            <div class="card">
                <p class="stat-label">전체 댓글</p>
                <p class="stat-value">${totalCount}</p>
                <p class="stat-note">등록된 전체 댓글 수</p>
            </div>
            <div class="card">
                <p class="stat-label">대기 댓글</p>
                <p class="stat-value">${pendingCount}</p>
                <p class="stat-note">승인 대기 중인 댓글</p>
            </div>
            <div class="card">
                <p class="stat-label">승인 댓글</p>
                <p class="stat-value">${approvedCount}</p>
                <p class="stat-note">공개된 댓글 수</p>
            </div>
            <div class="card">
                <p class="stat-label">숨김 댓글</p>
                <p class="stat-value">${hiddenCount}</p>
                <p class="stat-note">관리자가 숨긴 댓글</p>
            </div>
        </section>

        <section class="card">
            <div class="panel-header">
                <div>
                    <h3 class="section-title">댓글 목록</h3>
                    <p class="section-desc">댓글 상태를 확인하고 관리할 수 있습니다.</p>
                </div>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/comments">
                <div class="filters">
                    <input type="text" name="keyword" value="${keyword}" placeholder="작성자, 내용, 게시글 검색">
                    <select name="status">
                        <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체 상태</option>
                        <option value="approved" ${selectedStatus == 'approved' ? 'selected' : ''}>승인됨</option>
                        <option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>대기</option>
                        <option value="hidden" ${selectedStatus == 'hidden' ? 'selected' : ''}>숨김</option>
                    </select>
                    <div class="filter-actions">
                        <button class="button primary" type="submit">검색</button>
                        <a class="button" href="${pageContext.request.contextPath}/comments">초기화</a>
                    </div>
                </div>
            </form>

            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th style="width: 8%;">ID</th>
                        <th style="width: 12%;">작성자</th>
                        <th style="width: 20%;">게시글</th>
                        <th style="width: 38%;">내용</th>
                        <th style="width: 10%;">상태</th>
                        <th style="width: 12%;">일시</th>
                        <th style="width: 12%;">작업</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${comments}" var="comment">
                        <tr>
                            <td>#${comment.id}</td>
                            <td><strong><c:out value="${comment.author}" /></strong></td>
                            <td><c:out value="${comment.postTitle}" /></td>
                            <td>
                                <div class="comment-text">
                                    <c:out value="${comment.content}" />
                                </div>
                            </td>
                            <td>
                                <span class="badge ${comment.statusClass}">
                                    <c:out value="${comment.statusLabel}" />
                                </span>
                            </td>
                            <td><c:out value="${comment.createdAt}" /></td>
                            <td>
                                <div class="row-actions">
                                    <button class="mini-button" type="button">보기</button>
                                    <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/status">
                                        <input type="hidden" name="status" value="approved" />
                                        <button class="mini-button" type="submit">승인</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/status">
                                        <input type="hidden" name="status" value="hidden" />
                                        <button class="mini-button" type="submit">숨김</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/delete">
                                        <button class="mini-button danger" type="submit">삭제</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
