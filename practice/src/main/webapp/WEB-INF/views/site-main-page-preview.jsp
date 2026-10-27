<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${settings.bannerTitle}"/> - Practice Site</title>
    <style>
        :root {
            color-scheme: light;
            font-family: Arial, Helvetica, sans-serif;
            color: #20252b;
            background: #f4f6f8;
        }

        * { box-sizing: border-box; }

        body { margin: 0; }

        .site-header {
            min-height: 72px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            padding: 0 max(24px, calc((100vw - 1120px) / 2));
            background: #fff;
            border-bottom: 1px solid #e2e6ea;
        }

        .site-name {
            color: #182d40;
            font-size: 20px;
            font-weight: 700;
        }

        .site-nav {
            display: flex;
            gap: 24px;
            color: #58636f;
            font-size: 14px;
        }

        .hero {
            position: relative;
            min-height: 360px;
            display: flex;
            align-items: center;
            padding: 56px 24px;
            background: linear-gradient(120deg, #173c5a, #3977a1);
            background-size: cover;
            background-position: center;
            color: #fff;
            overflow: hidden;
        }

        .hero.has-image::before {
            position: absolute;
            inset: 0;
            z-index: 1;
            background: linear-gradient(90deg, rgba(13,35,53,.82), rgba(13,35,53,.35));
            content: "";
        }

        .hero-image {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            width: min(1120px, 100%);
            margin: 0 auto;
        }

        .hero h1 {
            max-width: 760px;
            margin: 0;
            font-size: clamp(32px, 5vw, 54px);
            line-height: 1.16;
            white-space: pre-line;
        }

        .hero p {
            max-width: 680px;
            margin: 18px 0 0;
            font-size: 17px;
            line-height: 1.7;
            white-space: pre-line;
        }

        .hero-cta {
            display: inline-flex;
            margin-top: 24px;
            padding: 12px 18px;
            border-radius: 6px;
            background: #fff;
            color: #173c5a;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
        }

        .content {
            width: min(1120px, calc(100% - 48px));
            margin: 0 auto;
            padding: 44px 0 64px;
        }

        .content-section { margin-bottom: 48px; }

        .content-section h2 {
            margin: 0 0 18px;
            color: #20252b;
            font-size: 25px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
            gap: 18px;
        }

        .content-card {
            overflow: hidden;
            border: 1px solid #e2e6ea;
            border-radius: 10px;
            background: #fff;
        }

        .content-card img {
            display: block;
            width: 100%;
            height: 165px;
            object-fit: cover;
            background: #e7edf2;
        }

        .content-card-body { padding: 17px; }

        .content-kind {
            color: #2271b1;
            font-size: 12px;
            font-weight: 700;
        }

        .content-card h3 {
            margin: 8px 0;
            font-size: 17px;
            line-height: 1.4;
        }

        .content-card p {
            margin: 0;
            color: #646970;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-line;
        }

        .empty-content {
            padding: 24px;
            border: 1px dashed #c4c9ce;
            border-radius: 10px;
            color: #646970;
            background: #fff;
        }

        .site-footer {
            padding: 24px;
            color: #727980;
            background: #202a33;
            text-align: center;
            font-size: 13px;
        }

        @media (max-width: 600px) {
            .site-header { min-height: 60px; padding: 0 18px; }
            .site-nav { gap: 12px; font-size: 12px; }
            .hero { min-height: 300px; padding: 42px 22px; }
            .hero p { font-size: 15px; }
            .content { width: calc(100% - 36px); padding-top: 32px; }
        }
    </style>
</head>
<body>
<header class="site-header">
    <div class="site-name">Practice Site</div>
    <nav class="site-nav" aria-label="사이트 메뉴">
        <span>소개</span>
        <span>콘텐츠</span>
        <span>소식</span>
    </nav>
</header>

<section class="hero ${not empty settings.bannerImageUrl ? 'has-image' : ''}">
    <c:if test="${not empty settings.bannerImageUrl}">
        <img class="hero-image" src="<c:out value='${settings.bannerImageUrl}'/>" alt="">
    </c:if>
    <div class="hero-content">
        <h1><c:out value="${settings.bannerTitle}"/></h1>
        <p><c:out value="${settings.bannerDescription}"/></p>
        <a class="hero-cta" href="#home-content">자세히 보기</a>
    </div>
</section>

<main class="content" id="home-content">
    <c:forEach items="${sectionOrderItems}" var="sectionId">
        <c:choose>
            <c:when test="${sectionId eq 'FEATURED_PAGE'}">
                <section class="content-section">
                    <h2>대표 페이지</h2>
                    <c:choose>
                        <c:when test="${empty featuredPages}">
                            <div class="empty-content">메인에 노출하도록 지정된 발행 페이지가 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="content-grid">
                                <c:forEach items="${featuredPages}" var="page">
                                    <article class="content-card">
                                        <c:if test="${not empty page.thumbnailUrl}">
                                            <img src="<c:out value='${page.thumbnailUrl}'/>" alt="">
                                        </c:if>
                                        <div class="content-card-body">
                                            <span class="content-kind">페이지</span>
                                            <h3><c:out value="${page.title}"/></h3>
                                            <p><c:out value="${page.summary}"/></p>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </c:when>
            <c:when test="${sectionId eq 'FEATURED_POSTS'}">
                <section class="content-section">
                    <h2>주요 게시글</h2>
                    <c:choose>
                        <c:when test="${empty featuredPosts}">
                            <div class="empty-content">메인에 노출하도록 지정된 발행 게시글이 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="content-grid">
                                <c:forEach items="${featuredPosts}" var="post">
                                    <article class="content-card">
                                        <c:if test="${not empty post.thumbnailUrl}">
                                            <img src="<c:out value='${post.thumbnailUrl}'/>" alt="">
                                        </c:if>
                                        <div class="content-card-body">
                                            <span class="content-kind">게시글</span>
                                            <h3><c:out value="${post.title}"/></h3>
                                            <p><c:out value="${post.summary}"/></p>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </c:when>
            <c:when test="${sectionId eq 'RECENT_POSTS'}">
                <section class="content-section">
                    <h2>최근 게시글</h2>
                    <c:choose>
                        <c:when test="${empty recentPosts}">
                            <div class="empty-content">표시할 발행 게시글이 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="content-grid">
                                <c:forEach items="${recentPosts}" var="post">
                                    <article class="content-card">
                                        <c:if test="${not empty post.thumbnailUrl}">
                                            <img src="<c:out value='${post.thumbnailUrl}'/>" alt="">
                                        </c:if>
                                        <div class="content-card-body">
                                            <span class="content-kind">게시글</span>
                                            <h3><c:out value="${post.title}"/></h3>
                                            <p><c:out value="${post.summary}"/></p>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </c:when>
        </c:choose>
    </c:forEach>
</main>

<footer class="site-footer">Practice Site</footer>
</body>
</html>
