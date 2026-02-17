<%-- 
    Document   : FirstJsp
    Created on : 8 Feb 2026, 16:12:47
    Author     : PC
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Welcome Back</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Animated background elements */
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -250px;
            right: -250px;
            animation: float 6s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            bottom: -200px;
            left: -200px;
            animation: float 8s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(20px); }
        }

        .login-container {
            background: white;
            padding: 18px 32px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 520px;
            position: relative;
            z-index: 1;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            margin: 0 auto 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
        }

        .logo svg {
            width: 24px;
            height: 24px;
            fill: white;
        }

        h2 {
            text-align: center;
            font-size: 20px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 3px;
        }

        .subtitle {
            text-align: center;
            color: #718096;
            font-size: 12px;
            margin-bottom: 14px;
        }

        .form-group {
            margin-bottom: 10px;
            position: relative;
        }

        label {
            font-size: 12px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 4px;
            display: block;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            color: #a0aec0;
            pointer-events: none;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 9px 12px 9px 38px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 13px;
            color: #2d3748;
            transition: all 0.3s ease;
            background: #f7fafc;
            font-family: inherit;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: #cbd5e0;
        }

        .forgot-password {
            text-align: right;
            margin-top: 4px;
        }

        .forgot-password a {
            font-size: 11px;
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .forgot-password a:hover {
            color: #764ba2;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 6px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        input[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        input[type="submit"]:active {
            transform: translateY(0);
        }

        .error-message {
            background: #fff5f5;
            border: 1px solid #fc8181;
            border-radius: 6px;
            padding: 8px 12px;
            color: #c53030;
            font-size: 11px;
            margin-top: 10px;
            display: <%= request.getAttribute("errorMessage") != null ? "block" : "none" %>;
            animation: shake 0.5s;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        .error-message::before {
            content: '⚠️ ';
            margin-right: 4px;
        }

        .divider {
            text-align: center;
            margin: 10px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #e2e8f0;
        }

        .divider span {
            background: white;
            padding: 0 12px;
            color: #a0aec0;
            font-size: 11px;
            position: relative;
            z-index: 1;
        }

        .signup-link {
            text-align: center;
            margin-top: 10px;
            font-size: 12px;
            color: #718096;
        }

        .signup-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-left: 4px;
            transition: color 0.2s;
        }

        .signup-link a:hover {
            color: #764ba2;
        }

        /* Loading state */
        .btn-loading {
            position: relative;
            pointer-events: none;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            width: 14px;
            height: 14px;
            top: 50%;
            left: 50%;
            margin-left: -7px;
            margin-top: -7px;
            border: 2px solid white;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 0.6s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 600px) {
            .login-container {
                padding: 16px 24px;
                max-width: 400px;
            }

            h2 {
                font-size: 18px;
            }

            input[type="submit"] {
                padding: 9px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
        </div>
        
        <h2>Welcome Back</h2>
        <p class="subtitle">Enter your credentials to access your account</p>
        
        <form action="login" method="POST" id="loginForm">
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-wrapper">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required />
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required />
                </div>
                <div class="forgot-password">
                    <a href="#forgot">Forgot password?</a>
                </div>
            </div>
            
            <div class="form-group">
                <input type="submit" value="Log In" id="submitBtn" />
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            <%
    String logoutMsg = (String) session.getAttribute("logoutMessage");
    if (logoutMsg != null) {
%>
    <div id="logoutBox" style="
        background:#ff4b5c;
        color:white;
        padding:10px;
        margin-bottom:15px;
        border-radius:5px;
        text-align:center;">
        <%= logoutMsg %>
    </div>

    <script>
        setTimeout(function() {
            var box = document.getElementById("logoutBox");
            if (box) {
                box.style.display = "none";
            }
        }, 5000);
    </script>

<%
        session.removeAttribute("logoutMessage");
    }
%>

        </form>

        <div class="divider">
            <span>or</span>
        </div>

        <div class="signup-link">
            Don't have an account?<a href="register.jsp">Sign up</a>
        </div>
    </div>

    <script>
        const form = document.getElementById('loginForm');
        const submitBtn = document.getElementById('submitBtn');

        form.addEventListener('submit', function() {
            submitBtn.classList.add('btn-loading');
            submitBtn.value = '';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>