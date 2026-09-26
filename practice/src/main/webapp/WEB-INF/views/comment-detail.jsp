<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>댓글 상세</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .detail-shell {
            max-width: 900px;
            margin: 32px auto;
            padding: 24px;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
        }

        .detail-header {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: center;
            margin-bottom: 24px;
        }

        .field-row {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .field {
            display: grid;
            gap: 8px;
        }

        .field label {
            font-weight: 700;
            font-size: 13px;
        }

        .field input,
        .field select,
        .field textarea {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 14px;
            background: #fff;
            color: var(--text);
        }

        .field textarea {
            min-height: 160px;
            resize: vertical;
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

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 24px;
            flex-wrap: wrap;
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
                <h2 class="page-title">댓글 상세</h2>
                <p class="page-desc">댓글 내용과 상태를 확인하고 수정합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${pageContext.request.contextPath}/comments">목록으로</a>
            </div>
        </div>

        <section class="detail-shell">
            <div class="detail-header">
                <div>
                    <h3 style="margin: 0; font-size: 24px;">#${comment.id}</h3>
                    <p style="margin: 8px 0 0; color: var(--muted);">게시글: <c:out value="${comment.postTitle}" /></p>
                </div>
                <span class="badge ${comment.statusClass}"><c:out value="${comment.statusLabel}" /></span>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/edit">
                <div class="field-row">
                    <div class="field">
                        <label for="author">작성자</label>
                        <input id="author" name="author" value="<c:out value='${comment.author}' />" />
                    </div>
                    <div class="field">
                        <label for="postTitle">게시글</label>
                        <input id="postTitle" name="postTitle" value="<c:out value='${comment.postTitle}' />" />
                    </div>
                </div>

                <div class="field" style="margin-top: 16px;">
                    <label for="status">상태</label>
                    <select id="status" name="status">
                        <option value="pending" ${comment.status == 'pending' ? 'selected' : ''}>대기</option>
                        <option value="approved" ${comment.status == 'approved' ? 'selected' : ''}>승인됨</option>
                        <option value="hidden" ${comment.status == 'hidden' ? 'selected' : ''}>숨김</option>
                    </select>
                </div>

                <div class="field" style="margin-top: 16px;">
                    <label for="content">내용</label>
                    <textarea id="content" name="content"><c:out value="${comment.content}" /></textarea>
                </div>

                <div class="actions">
                    <button class="button primary" type="submit">수정 저장</button>
                    <a class="button" href="${pageContext.request.contextPath}/comments">목록으로</a>
                </div>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/report" style="margin-top: 20px;">
                <label for="reportReason" style="display:block; margin-bottom:8px; font-weight:700;">신고 사유</label>
                <select id="reportReason" name="reason" style="width: 280px;">
                    <option value="스팸/광고성">스팸/광고성</option>
                    <option value="욕설/비방">욕설/비방</option>
                    <option value="허위 정보">허위 정보</option>
                    <option value="기타">기타</option>
                </select>
                <div style="margin-top: 12px;">
                    <button class="button danger" type="submit">댓글 신고</button>
                </div>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/comments/${comment.id}/delete" style="display: inline-block; margin-top: 12px;">
                <button class="button danger" type="submit">삭제</button>
            </form>
        </section>
    </main>
</div>
</body>
</html>
