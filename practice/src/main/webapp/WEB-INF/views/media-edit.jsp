<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>미디어 편집</title>
    <style>
        :root {
            --bg: #f0f0f1;
            --panel: #fff;
            --sidebar: #1d2327;
            --sidebar-2: #23282d;
            --accent: #2271b1;
            --text: #1d2327;
            --muted: #646970;
            --border: #dcdcde;
        }

        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, Helvetica, sans-serif; background: var(--bg); color: var(--text); }
        a { color: inherit; text-decoration: none; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 240px 1fr; }
        .sidebar { padding: 24px 0; color: #fff; background: linear-gradient(180deg, var(--sidebar), var(--sidebar-2)); }
        .brand { padding: 0 24px 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.08); }
        .brand-title { margin: 0; font-size: 20px; }
        .brand-subtitle { margin: 6px 0 0; color: rgba(255, 255, 255, 0.7); font-size: 12px; }
        .menu { padding: 16px 0; }
        .menu-item { display: block; padding: 14px 24px; color: rgba(255, 255, 255, 0.82); font-size: 14px; }
        .menu-item.active, .menu-item:hover { background: rgba(255, 255, 255, 0.06); color: #fff; border-left: 4px solid var(--accent); padding-left: 20px; }
        .content { max-width: 900px; padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 20px; }
        .page-title { margin: 0; font-size: 28px; }
        .button { display: inline-flex; align-items: center; justify-content: center; min-height: 40px; padding: 0 16px; border: 1px solid var(--border); border-radius: 6px; background: #fff; font-size: 14px; font-weight: 600; }
        .button.primary { border-color: var(--accent); background: var(--accent); color: #fff; }
        .panel { padding: 28px; border: 1px solid var(--border); border-radius: 12px; background: var(--panel); }
        .file-info { margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--border); }
        .file-name { margin: 0 0 8px; font-size: 18px; font-weight: 700; }
        .file-meta { margin: 0; color: var(--muted); font-size: 13px; }
        .file-actions { display: flex; gap: 10px; margin-top: 16px; }
        .form { display: grid; gap: 18px; }
        .field { display: grid; gap: 8px; }
        label { color: var(--muted); font-size: 13px; font-weight: 600; }
        input, select, textarea { width: 100%; padding: 11px 12px; border: 1px solid var(--border); border-radius: 8px; background: #fff; color: var(--text); font: inherit; }
        textarea { min-height: 130px; resize: vertical; }
        .actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 8px; }
        @media (max-width: 700px) {
            .layout { display: block; }
            .sidebar { padding-bottom: 8px; }
            .menu { display: flex; overflow-x: auto; padding: 8px 0; }
            .menu-item { white-space: nowrap; }
            .content { padding: 20px 16px; }
            .panel { padding: 20px; }
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title">CMS Practice</h1>
            <p class="brand-subtitle">관리자 콘텐츠 운영</p>
        </div>
        <nav class="menu">
            <a class="menu-item" href="${pageContext.request.contextPath}/">대시보드</a>
            <a class="menu-item" href="${pageContext.request.contextPath}/posts">게시글</a>
            <a class="menu-item" href="${pageContext.request.contextPath}/pages">페이지</a>
            <a class="menu-item active" href="${pageContext.request.contextPath}/media">미디어</a>
        </nav>
    </aside>
    <main class="content">
        <div class="topbar">
            <h2 class="page-title">미디어 편집</h2>
            <a class="button" href="${pageContext.request.contextPath}/media">목록으로</a>
        </div>
        <section class="panel">
            <div class="file-info">
                <p class="file-name"><c:out value="${media.originalFilename}" /></p>
                <p class="file-meta"><c:out value="${media.fileType}" /> · <c:out value="${media.fileSizeDisplay}" /> · 업로드 <c:out value="${media.uploadedAtDisplay}" /></p>
                <div class="file-actions">
                    <a class="button" href="${pageContext.request.contextPath}/media/${media.id}/download">파일 다운로드</a>
                </div>
            </div>
            <form class="form" action="${pageContext.request.contextPath}/media/${media.id}/edit" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="field">
                    <label for="title">제목</label>
                    <input id="title" name="title" type="text" value="${fn:escapeXml(media.title)}" maxlength="255">
                </div>
                <div class="field">
                    <label for="description">설명</label>
                    <textarea id="description" name="description"><c:out value="${media.description}" /></textarea>
                </div>
                <div class="field">
                    <label for="altText">대체 텍스트</label>
                    <input id="altText" name="altText" type="text" value="${fn:escapeXml(media.altText)}" maxlength="255">
                </div>
                <div class="field">
                    <label for="tags">태그</label>
                    <input id="tags" name="tags" type="text" value="${fn:escapeXml(media.tags)}" maxlength="255">
                </div>
                <div class="field">
                    <label for="status">상태</label>
                    <select id="status" name="status">
                        <option value="공개" ${media.status == '공개' ? 'selected' : ''}>공개</option>
                        <option value="검토" ${media.status == '검토' ? 'selected' : ''}>검토</option>
                        <option value="보류" ${media.status == '보류' ? 'selected' : ''}>보류</option>
                    </select>
                </div>
                <div class="actions">
                    <a class="button" href="${pageContext.request.contextPath}/media">취소</a>
                    <button class="button primary" type="submit">저장</button>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>