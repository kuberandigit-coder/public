<%-- 
    Document   : Register
    Created on : 12 Feb 2026, 10:30:00
    Author     : PC
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Create Account</title>
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

        .register-container {
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

        .password-strength {
            margin-top: 4px;
            height: 3px;
            background: #e2e8f0;
            border-radius: 2px;
            overflow: hidden;
            display: none;
        }

        .password-strength.active {
            display: block;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .password-strength.weak .password-strength-bar {
            width: 33%;
            background: #fc8181;
        }

        .password-strength.medium .password-strength-bar {
            width: 66%;
            background: #f6ad55;
        }

        .password-strength.strong .password-strength-bar {
            width: 100%;
            background: #48bb78;
        }

        .password-hint {
            font-size: 10px;
            color: #a0aec0;
            margin-top: 3px;
            display: none;
        }

        .password-hint.active {
            display: block;
        }

        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            margin-bottom: 10px;
        }

        input[type="checkbox"] {
            width: 15px;
            height: 15px;
            margin-top: 1px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .checkbox-label {
            font-size: 11px;
            color: #4a5568;
            line-height: 1.4;
            flex: 1;
        }

        .checkbox-label a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .checkbox-label a:hover {
            color: #764ba2;
            text-decoration: underline;
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
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        input[type="submit"]:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        input[type="submit"]:active {
            transform: translateY(0);
        }

        input[type="submit"]:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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

        .success-message {
            background: #f0fff4;
            border: 1px solid #48bb78;
            border-radius: 6px;
            padding: 8px 12px;
            color: #22543d;
            font-size: 11px;
            margin-top: 10px;
            display: <%= request.getAttribute("successMessage") != null ? "block" : "none" %>;
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

        .success-message::before {
            content: '✅ ';
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

        .login-link {
            text-align: center;
            margin-top: 10px;
            font-size: 12px;
            color: #718096;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-left: 4px;
            transition: color 0.2s;
        }

        .login-link a:hover {
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

        /* Validation error styles */
        .input-error {
            border-color: #fc8181 !important;
        }

        .input-error:focus {
            box-shadow: 0 0 0 3px rgba(252, 129, 129, 0.1) !important;
        }

        .field-error {
            color: #c53030;
            font-size: 10px;
            margin-top: 3px;
            display: none;
        }

        .field-error.active {
            display: block;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .register-container {
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
    <div class="register-container">
        <div class="logo">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
        </div>
        
        <h2>Create Account</h2>
        <p class="subtitle">Join us today! It only takes a minute</p>
        
        <form action="register" method="POST" id="registerForm">
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-wrapper">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <input type="text" id="username" name="username" placeholder="johndoe123" required />
                </div>
                <div class="field-error" id="usernameError"></div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                    <input type="password" id="password" name="password" placeholder="Min. 8 characters" required />
                </div>
                <div class="password-strength" id="passwordStrength">
                    <div class="password-strength-bar"></div>
                </div>
                <div class="password-hint" id="passwordHint">
                    Use 8+ characters with a mix of letters, numbers & symbols
                </div>
                <div class="field-error" id="passwordError"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <div class="input-wrapper">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required />
                </div>
                <div class="field-error" id="confirmPasswordError"></div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="terms" name="terms" required />
                <label for="terms" class="checkbox-label">
                    I agree to the <a href="#terms">Terms of Service</a> and <a href="#privacy">Privacy Policy</a>
                </label>
            </div>
            
            <div class="form-group">
                <input type="submit" value="Create Account" id="submitBtn" />
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
        </form>

        <div class="divider">
            <span>or</span>
        </div>

        <div class="login-link">
            Already have an account?<a href="login.jsp">Sign in</a>
        </div>
    </div>


</body>
</html>



