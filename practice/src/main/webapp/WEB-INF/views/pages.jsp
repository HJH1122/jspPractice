<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
            --success: #00a32a;
            --warning: #dba617;
            --danger: #d63638;
        }

        * { box-sizing: border-box; }

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

        .menu { padding: 16px 0; }

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

        .content { padding: 24px; }

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

        .field-row { display: grid; gap: 12px; }

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

        .two-col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .table-wrap { overflow-x: auto; }

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

        .table tr:hover td { background: #fcfcfc; }

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

        .mini-button.danger { color: var(--danger); }
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

        .pagination-spacer {
            width: 8px;
        }

        @media (max-width: 1100px) {
            .layout,
            .summary,
            .grid,
            .two-col {
                grid-template-columns: 1fr;
            }

            .topbar,
            .panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .toolbar { justify-content: flex-start; }
            .pagination { align-items: flex-start; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/posts" var="postsUrl"/>
<c:url value="/pages" var="pagesUrl"/>
<c:url value="/pages/search" var="searchUrl"/>
<c:url value="/pages/save" var="saveUrl"/>
<c:url value="/pages/delete" var="deleteUrl"/>

<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title">Practice CMS</h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>
        <nav class="menu">
            <a class="menu-item" href="${mainUrl}">대시보드</a>
            <a class="menu-item active" href="${pagesUrl}">페이지</a>
            <a class="menu-item" href="${postsUrl}">게시글</a>
            <a class="menu-item" href="#">미디어</a>
            <a class="menu-item" href="#">댓글</a>
            <a class="menu-item" href="#">설정</a>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">페이지 관리</h2>
                <p class="page-desc">목록 조회, 검색, 작성, 수정, 삭제를 한 화면에서 처리합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mainUrl}">대시보드로 이동</a>
                <a class="button ghost" href="${pagesUrl}">새 페이지 작성</a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="notice"><c:out value="${message}"/></div>
        </c:if>

        <section class="summary">
            <div class="card">
                <p class="stat-label">전체 페이지</p>
                <p class="stat-value">${totalCount}</p>
                <p class="stat-note">현재 등록된 페이지 수</p>
            </div>
            <div class="card">
                <p class="stat-label">발행됨</p>
                <p class="stat-value">${publishedCount}</p>
                <p class="stat-note">외부에 노출되는 페이지</p>
            </div>
            <div class="card">
                <p class="stat-label">예약됨</p>
                <p class="stat-value">${scheduledCount}</p>
                <p class="stat-note">시간 지정 발행 상태</p>
            </div>
            <div class="card">
                <p class="stat-label">초안</p>
                <p class="stat-value">${draftCount}</p>
                <p class="stat-note">아직 공개되지 않은 페이지</p>
            </div>
        </section>

        <div class="grid">
            <section class="card">
                <div class="panel-header">
                    <div>
                        <h3 class="section-title">페이지 목록</h3>
                        <p class="section-desc">검색과 상태 필터를 적용한 페이지 목록입니다.</p>
                    </div>
                    <form class="filters" method="post" action="${searchUrl}">
                        <input type="text" name="query" placeholder="제목, 슬러그, 내용 검색" value="${fn:escapeXml(query)}">
                        <select name="status">
                            <option value="" <c:if test="${empty status}">selected</c:if>>전체 상태</option>
                            <c:forEach items="${statusOptions}" var="statusOption">
                                <option value="${statusOption.value}" <c:if test="${status eq statusOption.value}">selected</c:if>>${statusOption.label}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button class="button primary" type="submit">검색</button>
                    </form>
                </div>

                <div class="table-wrap">
                    <table class="table">
                        <thead>
                        <tr>
                            <th style="width: 22%;">제목</th>
                            <th>슬러그</th>
                            <th>상태</th>
                            <th>상위 페이지</th>
                            <th>작성자</th>
                            <th>수정일</th>
                            <th style="width: 18%;">작업</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty pageRows}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">조건에 맞는 페이지가 없습니다.</div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${pageRows}" var="pageRow">
                                    <tr>
                                        <td>
                                            <strong><c:out value="${pageRow.title}"/></strong><br>
                                            <span class="muted-line"><c:out value="${pageRow.summary}"/></span>
                                        </td>
                                        <td><c:out value="${pageRow.slug}"/></td>
                                        <td><span class="badge ${pageRow.statusCssClass}">${pageRow.statusLabel}</span></td>
                                        <td><c:out value="${empty pageRow.parentTitle ? '-' : pageRow.parentTitle}"/></td>
                                        <td><c:out value="${pageRow.author}"/></td>
                                        <td><c:out value="${pageRow.updatedAtDisplay}"/></td>
                                        <td>
                                            <div class="row-actions">
                                                <c:url value="/pages/${pageRow.id}" var="editPageUrl">
                                                    <c:param name="query" value="${query}"/>
                                                    <c:param name="status" value="${status}"/>
                                                    <c:param name="page" value="${page}"/>
                                                </c:url>
                                                <a class="mini-button" href="${editPageUrl}">수정</a>
                                                <form method="post" action="${deleteUrl}" style="margin: 0; display: inline;">
                                                    <input type="hidden" name="id" value="${pageRow.id}">
                                                    <input type="hidden" name="returnQuery" value="${query}">
                                                    <input type="hidden" name="returnStatus" value="${status}">
                                                    <input type="hidden" name="returnPage" value="${page}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                    <button class="mini-button danger delete-button" type="submit">삭제</button>
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
                        총 ${totalCount}개 중 ${page} / ${totalPages}페이지
                    </div>

                    <form class="pagination-form" method="post" action="${searchUrl}">
                        <input type="hidden" name="query" value="${fn:escapeXml(query)}">
                        <input type="hidden" name="status" value="${status}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                        <button class="mini-button" type="submit" name="page" value="${page - 1}"
                                <c:if test="${!hasPrev}">disabled</c:if>>
                            이전
                        </button>

                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNo">
                            <button class="mini-button ${pageNo eq page ? 'active' : ''}"
                                    type="submit"
                                    name="page"
                                    value="${pageNo}"
                                    <c:if test="${pageNo eq page}">disabled</c:if>>
                                ${pageNo}
                            </button>
                        </c:forEach>

                        <button class="mini-button" type="submit" name="page" value="${page + 1}"
                                <c:if test="${!hasNext}">disabled</c:if>>
                            다음
                        </button>
                    </form>
                </div>
                
            </section>

            <aside class="card">
                <div class="panel-header">
                    <div>
                        <c:choose>
                            <c:when test="${empty pageForm.id}">
                                <h3 class="section-title">새 페이지 작성</h3>
                                <p class="section-desc">새 페이지를 등록하거나 기존 페이지를 수정합니다.</p>
                            </c:when>
                            <c:otherwise>
                                <h3 class="section-title">페이지 수정</h3>
                                <p class="section-desc">선택한 페이지의 내용을 업데이트합니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <form id="page-form" method="post" action="${saveUrl}"
                      data-default-author="${fn:escapeXml(draftPage.author)}"
                      data-default-sort-order="${draftPage.sortOrder}"
                      data-initial-published-at="${pageForm.publishedAtInputValue}">
                    <input type="hidden" name="id" value="${pageForm.id}">
                    <input type="hidden" name="returnQuery" value="${query}">
                    <input type="hidden" name="returnStatus" value="${status}">
                    <input type="hidden" name="returnPage" value="${page}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <div class="field-row">
                        <div class="field">
                            <label for="title">제목</label>
                            <input id="title" type="text" name="title" value="${fn:escapeXml(pageForm.title)}" placeholder="페이지 제목을 입력하세요" maxlength="100" required>
                        </div>

                        <div class="field">
                            <label for="slug">슬러그</label>
                            <input id="slug" type="text" name="slug" value="${fn:escapeXml(pageForm.slug)}" placeholder="예: about-us">
                        </div>

                        <div class="two-col">
                            <div class="field">
                                <label for="author">작성자</label>
                                <input id="author" type="text" name="author" value="${fn:escapeXml(pageForm.author)}" placeholder="작성자" readonly>
                            </div>
                            <div class="field">
                                <label for="sortOrder">정렬 순서</label>
                                <input id="sortOrder" type="number" name="sortOrder" value="${pageForm.sortOrder}" min="1">
                            </div>
                        </div>

                        <div class="two-col">
                            <div class="field">
                                <label for="status">상태</label>
                                <select id="status" name="status">
                                    <c:forEach items="${statusOptions}" var="statusOption">
                                        <option value="${statusOption.value}" <c:if test="${pageForm.status eq statusOption}">selected</c:if>>${statusOption.label}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="field">
                                <label for="parentId">상위 페이지</label>
                                <select id="parentId" name="parentId">
                                    <option value="">없음</option>
                                    <c:forEach items="${parentOptions}" var="parentPage">
                                        <c:if test="${empty pageForm.id or parentPage.id ne pageForm.id}">
                                            <option value="${parentPage.id}" <c:if test="${pageForm.parentId eq parentPage.id}">selected</c:if>>${parentPage.title}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="field conditional-field" id="scheduledAtField" hidden>
                            <label for="publishedAt">예약 발행 시각</label>
                            <input id="publishedAt" type="datetime-local" name="publishedAt" value="${pageForm.publishedAtInputValue}" step="60">
                            <p class="muted-line">예약됨 상태일 때만 사용됩니다.</p>
                        </div>

                        <div class="field">
                            <label for="summary">요약</label>
                            <textarea id="summary" name="summary" placeholder="목록에 표시될 간단한 설명"><c:out value="${pageForm.summary}"/></textarea>
                        </div>

                        <div class="field">
                            <label for="content">본문</label>
                            <textarea id="content" name="content" placeholder="페이지 본문을 입력하세요"><c:out value="${pageForm.content}"/></textarea>
                        </div>

                        <p class="muted-line">현재는 CKEditor 없이도 동작하도록 일반 텍스트 입력으로 구현했습니다. 이후 본문 입력창에 에디터를 교체하면 됩니다.</p>

                        <div class="form-actions">
                            <button class="button primary" type="submit">저장</button>

                            <c:if test="${empty pageForm.id}">
                                <button class="button ghost" type="button" id="new-page-button">
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
<script>
    (function () {
        const form = document.getElementById('page-form');
        const statusSelect = document.getElementById('status');
        const scheduledAtField = document.getElementById('scheduledAtField');
        const scheduledAtInput = document.getElementById('publishedAt');
        const newPageButton = document.getElementById('new-page-button');

        if (!form || !statusSelect || !scheduledAtField || !scheduledAtInput || !newPageButton) {
            return;
        }

        const toDatetimeLocalValue = function (date) {
            const offset = date.getTimezoneOffset();
            const localDate = new Date(date.getTime() - offset * 60000);
            return localDate.toISOString().slice(0, 16);
        };

        const syncScheduledField = function () {
            const isScheduled = statusSelect.value === 'SCHEDULED';
            scheduledAtField.hidden = !isScheduled;
            scheduledAtInput.required = isScheduled;

            if (isScheduled && !scheduledAtInput.value) {
                scheduledAtInput.value = form.dataset.initialPublishedAt || toDatetimeLocalValue(new Date());
            }
        };

        document.querySelectorAll('.delete-button').forEach(btn=>{
            btn.addEventListener('click',function(e){
                if(!confirm('삭제하시겠습니까?')){
                    e.preventDefault();
                }
            });
        });

        statusSelect.addEventListener('change', syncScheduledField);

        newPageButton.addEventListener('click', function () {
            form.elements.id.value = '';
            form.elements.title.value = '';
            form.elements.slug.value = '';
            form.elements.author.value = form.dataset.defaultAuthor || '';
            form.elements.sortOrder.value = form.dataset.defaultSortOrder || '';
            form.elements.status.value = 'DRAFT';
            form.elements.parentId.value = '';
            form.elements.publishedAt.value = '';
            form.elements.summary.value = '';
            form.elements.content.value = '';
            syncScheduledField();
        });

        syncScheduledField();
    })();
</script>
<!-- CKEditor CDN -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>

<script>
ClassicEditor
    .create(document.querySelector('#content'))
    .catch(error => {
        console.error(error);
    });
</script>
</body>
</html>