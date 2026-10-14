<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>태그 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group {
            margin: 2px 0;
        }

        .menu-group-toggle {
            display: flex;
            width: 100%;
            align-items: center;
            justify-content: space-between;
            padding: 12px 24px;
            border: 0;
            border-left: 4px solid transparent;
            background: transparent;
            color: rgba(255, 255, 255, 0.82);
            font: inherit;
            font-size: 14px;
            text-align: left;
            cursor: pointer;
        }

        .menu-group-toggle:hover,
        .menu-group-toggle:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .menu-group-toggle[aria-expanded="true"] {
            color: #fff;
        }

        .menu-chevron {
            width: 8px;
            height: 8px;
            margin-right: 2px;
            border-right: 1px solid currentColor;
            border-bottom: 1px solid currentColor;
            transform: rotate(45deg);
            transition: transform 0.15s ease;
        }

        .menu-group-toggle[aria-expanded="true"] .menu-chevron {
            transform: rotate(225deg);
        }

        .menu-submenu {
            margin: 0;
            padding: 0 0 6px;
            list-style: none;
        }

        .menu-submenu[hidden] {
            display: none;
        }

        .menu-leaf {
            display: block;
            padding: 9px 24px 9px 42px;
            border-left: 4px solid transparent;
            color: rgba(255, 255, 255, 0.68);
            font-size: 13px;
        }

        .menu-leaf.active {
            border-left-color: var(--accent);
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
        }

        .menu-leaf-unavailable {
            color: rgba(255, 255, 255, 0.45);
        }

        a.menu-leaf:hover,
        a.menu-leaf:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .tag-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 20px;
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
            color: var(--muted);
            font-size: 12px;
        }

        .tag-layout {
            display: grid;
            grid-template-columns: minmax(260px, 0.8fr) minmax(0, 2fr);
            gap: 16px;
            align-items: start;
        }

        .panel-title {
            margin: 0;
            font-size: 18px;
        }

        .panel-description {
            margin: 6px 0 18px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .tag-form {
            display: grid;
            gap: 14px;
        }

        .field-label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        .tag-form input,
        .tag-form textarea,
        .tag-search input {
            width: 100%;
            min-height: 40px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            color: var(--text);
            font: inherit;
            font-size: 13px;
        }

        .tag-form textarea {
            min-height: 96px;
            resize: vertical;
        }

        .field-hint {
            display: block;
            margin-top: 5px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .tag-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .tag-search {
            width: min(100%, 280px);
        }

        .table-wrap {
            overflow-x: auto;
            border: 1px solid var(--border);
            border-radius: 10px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .table th,
        .table td {
            padding: 13px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .table th {
            background: #fafafa;
            color: var(--muted);
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .table tbody tr:last-child td {
            border-bottom: 0;
        }

        .tag-name {
            font-weight: 700;
        }

        .tag-slug {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .tag-count {
            color: var(--accent);
            font-weight: 700;
        }

        .row-actions {
            display: flex;
            gap: 8px;
            white-space: nowrap;
        }

        .text-action {
            padding: 0;
            border: 0;
            background: none;
            color: var(--accent);
            font: inherit;
            font-size: 12px;
        }

        .text-action.danger {
            color: var(--danger);
        }

        .prototype-note {
            margin: 14px 0 0;
            color: var(--muted);
            font-size: 12px;
        }

        @media (max-width: 1100px) {
            .layout,
            .tag-layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
            }
        }

        @media (max-width: 720px) {
            .content {
                padding: 16px;
            }

            .topbar,
            .tag-list-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .tag-summary {
                grid-template-columns: 1fr;
            }

            .tag-search {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title"><a href="${pageContext.request.contextPath}/main" style="color: inherit; text-decoration: none;">Practice CMS</a></h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>

        <nav class="menu" aria-label="관리 메뉴">
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-content">
                    <span>콘텐츠</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-content">
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/pages">페이지</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/posts">게시글</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/categories">카테고리</a></li>
                    <li><a class="menu-leaf active" href="${pageContext.request.contextPath}/tags" aria-current="page">태그</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/comments">댓글</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-media">
                    <span>미디어</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-media" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/media">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/main">메인 페이지</a></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">메뉴 관리</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">배너 관리</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">팝업 관리</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-statistics">
                    <span>통계</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-statistics" hidden>
                    <li><span class="menu-leaf menu-leaf-unavailable">방문자 통계</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">콘텐츠 통계</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-settings">
                    <span>설정</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-settings" hidden>
                    <li><span class="menu-leaf menu-leaf-unavailable">사이트 설정</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">관리자 설정</span></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">시스템 설정</span></li>
                </ul>
            </div>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">태그 관리</h2>
                <p class="page-desc">게시글의 핵심 키워드를 태그로 정리하고 연결 현황을 확인합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${pageContext.request.contextPath}/main">대시보드로 이동</a>
            </div>
        </div>

        <section class="tag-summary" aria-label="태그 요약">
            <div class="card">
                <p class="stat-label">전체 태그</p>
                <p class="stat-value">5</p>
                <p class="stat-note">등록된 태그 예시</p>
            </div>
            <div class="card">
                <p class="stat-label">사용 중인 태그</p>
                <p class="stat-value">5</p>
                <p class="stat-note">게시글에 연결된 태그</p>
            </div>
            <div class="card">
                <p class="stat-label">태그가 연결된 게시글</p>
                <p class="stat-value">18</p>
                <p class="stat-note">중복 게시글 포함 예시 수치</p>
            </div>
        </section>

        <section class="tag-layout">
            <div class="card">
                <h3 class="panel-title">새 태그 추가</h3>
                <p class="panel-description">태그 등록 화면 미리보기입니다. 저장 기능은 제공하지 않습니다.</p>
                <div class="tag-form">
                    <label>
                        <span class="field-label">이름</span>
                        <input type="text" placeholder="태그 이름">
                    </label>
                    <label>
                        <span class="field-label">슬러그</span>
                        <input type="text" placeholder="예: product-update">
                        <span class="field-hint">URL에 사용되는 영문 이름입니다.</span>
                    </label>
                    <label>
                        <span class="field-label">설명</span>
                        <textarea placeholder="태그에 대한 설명을 입력하세요."></textarea>
                    </label>
                    <button class="button primary" type="button" disabled>태그 추가</button>
                </div>
            </div>

            <div class="card">
                <div class="tag-list-header">
                    <div>
                        <h3 class="panel-title">태그 목록</h3>
                        <p class="panel-description">이름, 슬러그, 연결된 게시글 수를 확인합니다.</p>
                    </div>
                    <label class="tag-search">
                        <span class="field-label">태그 검색</span>
                        <input type="search" placeholder="이름 검색" aria-label="태그 이름 검색">
                    </label>
                </div>

                <div class="table-wrap">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>이름</th>
                            <th>설명</th>
                            <th>게시글</th>
                            <th>작업</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td><span class="tag-name">업데이트</span><span class="tag-slug">updates</span></td>
                            <td>제품 및 서비스 변경 소식</td>
                            <td><span class="tag-count">7</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="tag-name">가이드</span><span class="tag-slug">guide</span></td>
                            <td>사용 방법과 단계별 안내</td>
                            <td><span class="tag-count">5</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="tag-name">이벤트</span><span class="tag-slug">event</span></td>
                            <td>행사 및 프로모션 소식</td>
                            <td><span class="tag-count">3</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="tag-name">공지</span><span class="tag-slug">notice</span></td>
                            <td>중요 안내 및 공지사항</td>
                            <td><span class="tag-count">2</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="tag-name">자료</span><span class="tag-slug">resources</span></td>
                            <td>다운로드 가능한 참고 자료</td>
                            <td><span class="tag-count">1</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <p class="prototype-note">표시된 태그와 수치는 화면 확인용 예시입니다.</p>
            </div>
        </section>
    </main>
</div>
<script>
    document.querySelectorAll(".menu-group-toggle").forEach(function (toggle) {
        toggle.addEventListener("click", function () {
            var expanded = toggle.getAttribute("aria-expanded") === "true";
            var submenu = document.getElementById(toggle.getAttribute("aria-controls"));

            toggle.setAttribute("aria-expanded", String(!expanded));
            submenu.hidden = expanded;
        });
    });
</script>
</body>
</html>
