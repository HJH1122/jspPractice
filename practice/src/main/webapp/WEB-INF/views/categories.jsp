<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리 관리</title>
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

        a.menu-leaf:hover,
        a.menu-leaf:focus-visible {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            outline: none;
        }

        .menu-leaf-unavailable {
            color: rgba(255, 255, 255, 0.45);
        }

        .category-summary {
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

        .category-layout {
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

        .category-form {
            display: grid;
            gap: 14px;
        }

        .field-label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        .category-form input,
        .category-form select,
        .category-form textarea,
        .category-search input {
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

        .category-form textarea {
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

        .category-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .category-search {
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

        .category-name {
            font-weight: 700;
        }

        .category-slug,
        .category-description {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .category-count {
            color: var(--accent);
            font-weight: 700;
            text-decoration: underline;
            text-underline-offset: 2px;
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
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding-bottom: 8px;
            }

            .category-layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 720px) {
            .content {
                padding: 16px;
            }

            .topbar,
            .category-list-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .category-summary {
                grid-template-columns: 1fr;
            }

            .category-search {
                width: 100%;
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

        <nav class="menu" aria-label="관리 메뉴">
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-content">
                    <span>콘텐츠</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-content">
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/pages">페이지</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/posts">게시글</a></li>
                    <li><a class="menu-leaf active" href="${pageContext.request.contextPath}/categories" aria-current="page">카테고리</a></li>
                    <li><span class="menu-leaf menu-leaf-unavailable">태그</span></li>
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
                <h2 class="page-title">카테고리 관리</h2>
                <p class="page-desc">게시글을 주제별로 분류하는 카테고리를 관리합니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${pageContext.request.contextPath}/main">대시보드로 이동</a>
            </div>
        </div>

        <section class="category-summary" aria-label="카테고리 요약">
            <div class="card">
                <p class="stat-label">전체 카테고리</p>
                <p class="stat-value">5</p>
                <p class="stat-note">등록된 카테고리 수</p>
            </div>
            <div class="card">
                <p class="stat-label">게시글이 있는 카테고리</p>
                <p class="stat-value">4</p>
                <p class="stat-note">하나 이상의 게시글이 연결됨</p>
            </div>
            <div class="card">
                <p class="stat-label">분류된 게시글</p>
                <p class="stat-value">24</p>
                <p class="stat-note">카테고리에 연결된 게시글 수</p>
            </div>
        </section>

        <section class="category-layout">
            <div class="card">
                <h3 class="panel-title">새 카테고리 추가</h3>
                <p class="panel-description">카테고리 입력 화면 미리보기입니다. 저장 기능은 아직 제공하지 않습니다.</p>
                <div class="category-form">
                    <label>
                        <span class="field-label">이름</span>
                        <input type="text" placeholder="카테고리 이름">
                    </label>
                    <label>
                        <span class="field-label">슬러그</span>
                        <input type="text" placeholder="예: news-and-notice">
                        <span class="field-hint">URL에 사용되는 영문 이름입니다.</span>
                    </label>
                    <label>
                        <span class="field-label">상위 카테고리</span>
                        <select>
                            <option>없음</option>
                            <option>공지사항</option>
                            <option>이야기</option>
                            <option>자료실</option>
                        </select>
                    </label>
                    <label>
                        <span class="field-label">설명</span>
                        <textarea placeholder="카테고리 설명을 입력하세요."></textarea>
                    </label>
                    <button class="button primary" type="button" disabled>카테고리 추가</button>
                </div>
            </div>

            <div class="card">
                <div class="category-list-header">
                    <div>
                        <h3 class="panel-title">카테고리 목록</h3>
                        <p class="panel-description">이름, 상위 카테고리, 연결된 게시글 수를 확인합니다.</p>
                    </div>
                    <label class="category-search">
                        <span class="field-label">카테고리 검색</span>
                        <input type="search" placeholder="이름 검색" aria-label="카테고리 이름 검색">
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
                            <td><span class="category-name">공지사항</span><span class="category-slug">notice</span></td>
                            <td>서비스 소식과 공지</td>
                            <td><span class="category-count">8</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="category-name">이야기</span><span class="category-slug">stories</span></td>
                            <td>팀과 서비스에 관한 이야기</td>
                            <td><span class="category-count">6</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="category-name">업데이트</span><span class="category-slug">updates</span></td>
                            <td>새로운 기능 및 변경 사항</td>
                            <td><span class="category-count">5</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="category-name">자료실</span><span class="category-slug">resources</span></td>
                            <td>안내 자료와 다운로드 파일</td>
                            <td><span class="category-count">5</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        <tr>
                            <td><span class="category-name">미분류</span><span class="category-slug">uncategorized</span></td>
                            <td>카테고리를 지정하지 않은 게시글</td>
                            <td><span class="category-count">0</span></td>
                            <td><div class="row-actions"><button class="text-action" type="button" disabled>수정</button><button class="text-action danger" type="button" disabled>삭제</button></div></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <p class="prototype-note">표시된 카테고리와 수치는 화면 확인용 예시입니다.</p>
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
