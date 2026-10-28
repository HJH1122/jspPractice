<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${page.title}"/> - Practice Site</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #f4f6f8;
            color: #20252b;
            font-family: Arial, Helvetica, sans-serif;
        }

        .site-header {
            padding: 22px max(24px, calc((100vw - 900px) / 2));
            border-bottom: 1px solid #e2e6ea;
            background: #fff;
        }

        .site-header a {
            color: #182d40;
            font-size: 19px;
            font-weight: 700;
            text-decoration: none;
        }

        main {
            width: min(900px, calc(100% - 40px));
            min-height: calc(100vh - 130px);
            margin: 0 auto;
            padding: 56px 0;
        }

        h1 {
            margin: 0;
            font-size: clamp(30px, 5vw, 44px);
            line-height: 1.2;
        }

        .summary {
            margin: 18px 0 36px;
            color: #646970;
            font-size: 18px;
            line-height: 1.7;
            white-space: pre-line;
        }

        .page-content {
            padding-top: 28px;
            border-top: 1px solid #dcdcde;
            font-size: 16px;
            line-height: 1.8;
        }

        .back-link {
            display: inline-block;
            margin-top: 36px;
            color: #2271b1;
            font-weight: 700;
            text-decoration: none;
        }
    </style>
</head>
<body>
<header class="site-header">
    <a href="${pageContext.request.contextPath}/site/main-page/preview">Practice Site</a>
</header>
<main>
    <h1><c:out value="${page.title}"/></h1>
    <c:if test="${not empty page.summary}">
        <p class="summary"><c:out value="${page.summary}"/></p>
    </c:if>
    <article class="page-content">${page.content}</article>
    <a class="back-link" href="${pageContext.request.contextPath}/site/main-page/preview">메인으로 돌아가기</a>
</main>
</body>
</html>
