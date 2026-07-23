<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <style>
        :root {
            --bg-a: #f8efe4;
            --bg-b: #dff0ea;
            --panel: #ffffff;
            --text: #1f2a2e;
            --muted: #5f6b70;
            --primary: #0d7a5f;
            --border: #d7dfdb;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at 15% 20%, #fff6e8 0%, transparent 42%),
                        radial-gradient(circle at 85% 80%, #d9f3eb 0%, transparent 45%),
                        linear-gradient(135deg, var(--bg-a), var(--bg-b));
            display: grid;
            place-items: center;
            padding: 20px;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 14px 38px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin: 0 0 10px;
            font-size: 28px;
            letter-spacing: -0.3px;
        }

        .desc {
            margin: 0 0 22px;
            color: var(--muted);
            font-size: 14px;
        }

        .field {
            margin-bottom: 14px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
        }

        input {
            width: 100%;
            height: 44px;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0 12px;
            font-size: 15px;
        }

        input:focus {
            outline: 2px solid rgba(13, 122, 95, 0.25);
            border-color: var(--primary);
        }

        .actions {
            margin-top: 16px;
        }

        button {
            width: 100%;
            height: 46px;
            border: none;
            border-radius: 10px;
            background: var(--primary);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
        }

        .hint {
            margin-top: 14px;
            font-size: 12px;
            color: var(--muted);
            text-align: center;
        }
    </style>
</head>
<body>
<div class="login-card">
    <h1>관리자 로그인</h1>
    <p class="desc">기능 구현 없이 라우팅 확인용 로그인 화면입니다.</p>

    <form method="post" action="/login">
        <div class="field">
            <label for="username">아이디</label>
            <input id="username" type="text" name="username" placeholder="아이디를 입력하세요" required>
        </div>

        <div class="field">
            <label for="password">비밀번호</label>
            <input id="password" type="password" name="password" placeholder="비밀번호를 입력하세요" required>
        </div>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

        <div class="actions">
            <button type="submit">로그인</button>
        </div>
    </form>

    <p class="hint">로그인 처리 로직은 Spring Security 기본 동작을 사용합니다.</p>
</div>
</body>
</html>
