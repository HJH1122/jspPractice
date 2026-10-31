<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파일 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .menu-group-toggle {
            display: flex;
            width: 100%;
            align-items: center;
            justify-content: space-between;
            padding: 12px 24px;
            border: 0;
            border-left: 4px solid transparent;
            background: transparent;
            color: rgba(255,255,255,.82);
            font: inherit;
            font-size: 14px;
            text-align: left;
            cursor: pointer;
        }

        .menu-group-toggle[aria-expanded="true"] { color: #fff; }
        .menu-group-toggle:hover { background: rgba(255,255,255,.06); }

        .menu-chevron {
            width: 8px;
            height: 8px;
            margin-right: 2px;
            border-right: 1px solid currentColor;
            border-bottom: 1px solid currentColor;
            transform: rotate(45deg);
        }

        .menu-group-toggle[aria-expanded="true"] .menu-chevron { transform: rotate(225deg); }
        .menu-submenu { margin: 0; padding: 0 0 6px; list-style: none; }
        .menu-submenu[hidden] { display: none; }
        .menu-leaf {
            display: block;
            padding: 9px 24px 9px 42px;
            border-left: 4px solid transparent;
            color: rgba(255,255,255,.68);
            font-size: 13px;
        }
        .menu-leaf.active {
            border-left-color: var(--accent);
            background: rgba(255,255,255,.06);
            color: #fff;
        }

        .page-note {
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid #c5d9ed;
            border-radius: 8px;
            background: #f0f6fc;
            color: #245780;
            font-size: 13px;
            line-height: 1.55;
        }

        .storage-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .storage-value {
            margin: 0;
            font-size: 27px;
            font-weight: 700;
        }

        .storage-note {
            margin: 8px 0 0;
            color: var(--muted);
            font-size: 12px;
        }

        .usage-track {
            height: 8px;
            overflow: hidden;
            margin-top: 15px;
            border-radius: 99px;
            background: #e8eaec;
        }

        .usage-track span { display: block; width: 0; height: 100%; background: var(--accent); }

        .section-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 16px;
        }

        .section-heading h3 { margin: 0; font-size: 18px; }
        .section-heading p { margin: 6px 0 0; color: var(--muted); font-size: 13px; }

        .filter-panel {
            display: grid;
            grid-template-columns: minmax(220px, 1fr) repeat(3, minmax(140px, .55fr)) auto;
            gap: 10px;
            margin-bottom: 18px;
        }

        .filter-panel input,
        .filter-panel select {
            width: 100%;
            min-width: 0;
            height: 40px;
            padding: 0 11px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            color: var(--text);
        }

        .filter-panel button:disabled,
        .bulk-toolbar button:disabled,
        .file-table input:disabled {
            cursor: not-allowed;
            opacity: .58;
        }

        .bulk-toolbar {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .bulk-toolbar .selection-count { margin-right: auto; color: var(--muted); font-size: 13px; }

        .table-wrap {
            overflow-x: auto;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #fff;
        }

        .file-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .file-table th, .file-table td {
            padding: 13px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }
        .file-table th { background: #fafafa; color: var(--muted); font-weight: 600; }
        .file-table tbody tr:last-child td { border-bottom: 0; }
        .file-name-cell { display: flex; align-items: center; gap: 10px; min-width: 220px; }
        .file-icon {
            display: grid;
            width: 38px;
            height: 38px;
            flex: 0 0 38px;
            place-items: center;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #f5f7f9;
            color: var(--accent);
            font-size: 10px;
            font-weight: 700;
        }
        .file-name-cell strong { display: block; max-width: 250px; overflow: hidden; text-overflow: ellipsis; }
        .file-name-cell span { display: block; margin-top: 4px; color: var(--muted); font-size: 11px; }

        .empty-state {
            padding: 56px 20px;
            color: var(--muted);
            text-align: center;
        }
        .empty-state strong { display: block; margin-bottom: 8px; color: var(--text); font-size: 16px; }
        .empty-state p { margin: 0; font-size: 13px; line-height: 1.6; }

        @media (max-width: 1000px) {
            .filter-panel { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 720px) {
            .storage-summary { grid-template-columns: 1fr; }
            .filter-panel { grid-template-columns: 1fr; }
            .section-heading { flex-direction: column; }
            .content { padding: 16px; }
        }
    </style>
</head>
<body>
<c:url value="/main" var="mainUrl"/>
<c:url value="/media" var="mediaUrl"/>
<c:url value="/media/files" var="mediaFilesUrl"/>

<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h1 class="brand-title"><a href="${mainUrl}" style="color:inherit;text-decoration:none;">Practice CMS</a></h1>
            <p class="brand-subtitle">WordPress 스타일 관리 화면</p>
        </div>
        <nav class="menu" aria-label="관리 메뉴">
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-content">
                    <span>콘텐츠</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-content" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/pages">페이지</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/posts">게시글</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/categories">카테고리</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/tags">태그</a></li>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/comments">댓글</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="true" aria-controls="menu-media">
                    <span>미디어</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-media">
                    <li><a class="menu-leaf" href="${mediaUrl}">미디어 라이브러리</a></li>
                    <li><a class="menu-leaf active" href="${mediaFilesUrl}" aria-current="page">파일 관리</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-site">
                    <span>사이트</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-site" hidden>
                    <li><a class="menu-leaf" href="${pageContext.request.contextPath}/site/main-page">메인 페이지</a></li>
                    <li><span class="menu-leaf">메뉴 관리</span></li>
                    <li><span class="menu-leaf">배너 관리</span></li>
                    <li><span class="menu-leaf">팝업 관리</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-statistics">
                    <span>통계</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-statistics" hidden>
                    <li><span class="menu-leaf">방문자 통계</span></li>
                    <li><span class="menu-leaf">콘텐츠 통계</span></li>
                </ul>
            </div>
            <div class="menu-group">
                <button class="menu-group-toggle" type="button" aria-expanded="false" aria-controls="menu-settings">
                    <span>설정</span><span class="menu-chevron" aria-hidden="true"></span>
                </button>
                <ul class="menu-submenu" id="menu-settings" hidden>
                    <li><span class="menu-leaf">사이트 설정</span></li>
                    <li><span class="menu-leaf">관리자 설정</span></li>
                    <li><span class="menu-leaf">시스템 설정</span></li>
                </ul>
            </div>
        </nav>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h2 class="page-title">파일 관리</h2>
                <p class="page-desc">저장된 파일을 한눈에 확인하고 정리하는 운영 화면입니다.</p>
            </div>
            <div class="toolbar">
                <a class="button" href="${mediaUrl}">미디어 라이브러리</a>
                <button class="button primary" type="button" disabled>파일 업로드</button>
            </div>
        </div>

        <div class="page-note" role="note">
            화면 시안입니다. 파일 조회, 저장 공간 집계, 검색·필터, 선택 및 일괄 작업은 아직 연결되지 않았습니다.
        </div>

        <section class="storage-summary" aria-label="저장 공간 요약">
            <div class="card">
                <p class="stat-label">전체 저장 공간</p>
                <p class="storage-value">-</p>
                <p class="storage-note">저장 공간 집계 기능 미연결</p>
            </div>
            <div class="card">
                <p class="stat-label">파일 개수</p>
                <p class="storage-value">-</p>
                <p class="storage-note">파일 조회 기능 미연결</p>
            </div>
            <div class="card">
                <p class="stat-label">사용 용량</p>
                <p class="storage-value">-</p>
                <div class="usage-track" aria-hidden="true"><span></span></div>
            </div>
        </section>

        <section class="card">
            <div class="section-heading">
                <div>
                    <h3>파일 목록</h3>
                    <p>파일 유형, 크기, 업로드 일시, 연결된 콘텐츠 사용 여부를 관리합니다.</p>
                </div>
                <button class="button" type="button" disabled>목록 / 썸네일 보기</button>
            </div>

            <div class="filter-panel" aria-label="파일 검색 및 필터 시안">
                <input type="search" placeholder="파일명 검색" aria-label="파일명 검색" disabled>
                <select aria-label="파일 유형" disabled>
                    <option>모든 유형</option>
                    <option>이미지</option>
                    <option>동영상</option>
                    <option>문서</option>
                </select>
                <select aria-label="사용 여부" disabled>
                    <option>사용 여부</option>
                    <option>사용 중</option>
                    <option>미사용</option>
                </select>
                <select aria-label="정렬 기준" disabled>
                    <option>업로드 일시</option>
                    <option>파일 크기</option>
                    <option>파일명</option>
                </select>
                <button class="button primary" type="button" disabled>검색</button>
            </div>

            <div class="bulk-toolbar">
                <span class="selection-count">선택된 파일 0개</span>
                <button class="button" type="button" disabled>상태 변경</button>
                <button class="button" type="button" disabled>다운로드</button>
                <button class="button" type="button" disabled>선택 파일 삭제</button>
            </div>

            <div class="table-wrap">
                <table class="file-table">
                    <thead>
                    <tr>
                        <th><input type="checkbox" aria-label="전체 파일 선택" disabled></th>
                        <th>파일</th>
                        <th>유형</th>
                        <th>크기</th>
                        <th>업로드 일시</th>
                        <th>콘텐츠 사용</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <strong>파일 목록 UI</strong>
                                <p>파일 조회 기능을 연결하면 업로드된 파일과 사용처가 여기에 표시됩니다.<br>
                                    사용 중인 파일은 삭제 전 연결된 콘텐츠를 확인할 수 있도록 설계할 수 있습니다.</p>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
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
