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
    <title>Ocean View Resort | Create Account</title>

    <!-- ── INSTANT LOAD ── -->
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1540541338287-41700207dee6?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --teal: #0e7490;
            --glass: rgba(255,255,255,0.06);
            --glass-border: rgba(255,255,255,0.18);
            --text-dim: rgba(255,255,255,0.65);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--deep-navy);
            min-height: 100vh;
            color: white;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            overscroll-behavior: none;
        }

        /* ── HERO BG ── */
        .hero-bg {
            position: fixed;
            inset: 0; z-index: 0;
            background: url('https://images.unsplash.com/photo-1540541338287-41700207dee6?w=1920&q=80') center/cover no-repeat;
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }
        .hero-bg::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(5,13,26,0.94) 0%, rgba(5,13,26,0.82) 50%, rgba(5,13,26,0.96) 100%);
        }

        /* ── WAVES ── */
        .wave-container {
            position: fixed;
            bottom: 0; left: 0;
            width: 100%; height: 100px;
            z-index: 1; overflow: hidden;
            opacity: 0.16;
            will-change: transform;
            transform: translateZ(0);
            contain: layout style;
        }
        .wave {
            position: absolute;
            bottom: 0; left: -50%;
            width: 200%; height: 70px;
            background: linear-gradient(to right, transparent, var(--teal), transparent);
            border-radius: 50%;
            animation: wave 8s ease-in-out infinite;
        }
        .wave:nth-child(2) {
            height: 50px;
            animation: wave 12s ease-in-out infinite reverse;
            opacity: 0.6;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }
        @keyframes wave {
            0%,100% { transform: translateX(0) translateY(0); }
            50%      { transform: translateX(8%) translateY(-10px); }
        }

        /* ── FLOATING PARTICLES ── */
        .particles {
            position: fixed;
            inset: 0; z-index: 2;
            pointer-events: none;
            overflow: hidden;
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }
        .particle {
            position: absolute;
            width: 2px; height: 2px;
            border-radius: 50%;
            background: var(--gold-light);
            opacity: 0;
            animation: floatUp var(--dur, 15s) linear var(--delay, 0s) infinite;
            left: var(--x, 50%);
            bottom: -10px;
        }
        @keyframes floatUp {
            0%   { opacity: 0; transform: translateY(0) translateX(0); }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.2; }
            100% { opacity: 0; transform: translateY(-100vh) translateX(20px); }
        }

        /* ── PAGE LAYOUT ── */
        .page-wrap {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            animation: pageIn 0.6s ease both;
        }

        @keyframes pageIn {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── LEFT PANEL ── */
        .left-panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 50px 60px 80px;
            position: relative;
        }

        .brand {
            margin-bottom: 40px;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 24px;
        }

        .brand-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: linear-gradient(135deg, var(--teal), var(--gold));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: 0 12px 32px rgba(201,169,110,0.3);
        }

        .brand-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 0.02em;
            line-height: 1.2;
        }

        .brand-name span { color: var(--gold-light); }

        .hero-text h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 56px;
            font-weight: 300;
            line-height: 1.1;
            margin-bottom: 20px;
            max-width: 480px;
        }

        .hero-text h1 em {
            font-style: italic;
            color: var(--gold-light);
        }

        .hero-text p {
            font-size: 15px;
            color: var(--text-dim);
            line-height: 1.8;
            max-width: 420px;
        }

        .benefit-list {
            margin-top: 32px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            color: var(--text-dim);
        }

        .benefit-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: rgba(201,169,110,0.15);
            border: 1px solid rgba(201,169,110,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }

        /* ── RIGHT PANEL ── */
        .right-panel {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 80px 60px 50px;
        }

        /* ── REGISTER BOX ── */
        .register-container {
            width: 100%;
            max-width: 460px;
            background: rgba(4, 11, 24, 0.88);
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 24px;
            padding: 40px;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.7), 0 0 0 1px rgba(201,169,110,0.1);
        }

        .register-header {
            margin-bottom: 28px;
            text-align: center;
        }

        .register-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(201,169,110,0.15);
            border: 1px solid rgba(201,169,110,0.3);
            color: var(--gold-light);
            font-size: 11px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            padding: 4px 14px;
            border-radius: 100px;
            margin-bottom: 16px;
        }

        .register-header h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 32px;
            font-weight: 300;
            margin-bottom: 6px;
        }

        .register-header p {
            font-size: 13px;
            color: var(--text-dim);
        }

        /* ── MESSAGES ── */
        .error-message {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #fca5a5;
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 12px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: shake 0.5s;
        }

        .success-message {
            background: linear-gradient(135deg, rgba(16,185,129,0.25), rgba(5,150,105,0.15));
            color: #6ee7b7;
            border: 1px solid rgba(16,185,129,0.35);
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 12px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideDown 0.4s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-6px); }
            20%, 40%, 60%, 80% { transform: translateX(6px); }
        }

        /* ── FORM ── */
        .form-group {
            margin-bottom: 16px;
        }

        label {
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-bottom: 6px;
            display: block;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            color: rgba(255,255,255,0.3);
            pointer-events: none;
            z-index: 1;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 13px 14px 13px 44px;
            background: rgba(3, 9, 20, 0.80);
            border: 1px solid rgba(255,255,255,0.22);
            border-radius: 12px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            outline: none;
            transition: border-color 0.25s, background 0.25s, box-shadow 0.25s;
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: rgba(255,255,255,0.30);
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: var(--gold);
            background: rgba(201,169,110,0.08);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.15);
        }

        /* INPUT VALIDATION */
        .input-error {
            border-color: rgba(239, 68, 68, 0.5) !important;
        }

        .input-error:focus {
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.15) !important;
        }

        .field-error {
            color: #fca5a5;
            font-size: 11px;
            margin-top: 5px;
            display: none;
        }

        .field-error.active {
            display: block;
        }

        /* PASSWORD STRENGTH */
        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: rgba(255,255,255,0.1);
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
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .password-strength.medium .password-strength-bar {
            width: 66%;
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }

        .password-strength.strong .password-strength-bar {
            width: 100%;
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .password-hint {
            font-size: 10px;
            color: rgba(255,255,255,0.4);
            margin-top: 6px;
            display: none;
        }

        .password-hint.active {
            display: block;
        }

        /* CHECKBOX */
        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 20px;
            margin-top: 20px;
        }

        input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-top: 1px;
            cursor: pointer;
            accent-color: var(--gold);
            border-radius: 4px;
        }

        .checkbox-label {
            font-size: 12px;
            color: var(--text-dim);
            line-height: 1.5;
            flex: 1;
            text-transform: none;
            letter-spacing: 0;
        }

        .checkbox-label a {
            color: var(--gold-light);
            text-decoration: none;
            font-weight: 500;
        }

        .checkbox-label a:hover {
            color: var(--gold);
            text-decoration: underline;
        }

        /* ── SUBMIT BUTTON ── */
        input[type="submit"] {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #c9a96e, #e8c98a);
            border: none;
            border-radius: 12px;
            color: var(--deep-navy);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        input[type="submit"]::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, #e8c98a, #fff3cc);
            opacity: 0;
            transition: opacity 0.3s;
        }

        input[type="submit"]:hover:not(:disabled)::before { opacity: 1; }
        input[type="submit"]:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(201,169,110,0.5);
        }
        input[type="submit"]:active { transform: translateY(0); }

        input[type="submit"]:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* Loading state */
        .btn-loading {
            pointer-events: none;
            color: transparent !important;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            width: 18px;
            height: 18px;
            top: 50%;
            left: 50%;
            margin-left: -9px;
            margin-top: -9px;
            border: 2px solid var(--deep-navy);
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 0.6s linear infinite;
            z-index: 2;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* ── DIVIDER ── */
        .divider {
            text-align: center;
            margin: 24px 0 20px;
            position: relative;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.12);
        }

        .divider span {
            color: var(--text-dim);
            font-size: 11px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
        }

        /* ── LOGIN LINK ── */
        .login-link {
            text-align: center;
            font-size: 13px;
            color: var(--text-dim);
        }

        .login-link a {
            color: var(--gold-light);
            text-decoration: none;
            font-weight: 600;
            margin-left: 4px;
            transition: color 0.2s;
        }

        .login-link a:hover {
            color: var(--gold);
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 960px) {
            .page-wrap { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 40px 20px; }
        }

        @media (max-width: 480px) {
            .register-container { padding: 32px 24px; }
            .register-header h2 { font-size: 26px; }
        }
    </style>
</head>
<body>

    <div class="hero-bg"></div>

    <div class="wave-container">
        <div class="wave"></div>
        <div class="wave"></div>
    </div>

    <div class="particles" id="particles"></div>

    <!-- ── PAGE ── -->
    <div class="page-wrap">

        <!-- LEFT PANEL -->
        <div class="left-panel">
            <div class="brand">
                <div class="brand-logo">
                    <div class="brand-icon">🌊</div>
                    <div class="brand-name">
                        Ocean<span> View</span><br>Resort
                    </div>
                </div>
            </div>

            <div class="hero-text">
                <h1>Join Our Team of<br><em>Excellence</em></h1>
                <p>Create your staff account to access Ocean View Resort's management system and contribute to our world-class guest experience.</p>
            </div>

            <div class="benefit-list">
                <div class="benefit-item">
                    <div class="benefit-icon">🔐</div>
                    Secure account with encryption
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">⚡</div>
                    Instant access to all tools
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">📊</div>
                    Real-time reservation management
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">🌐</div>
                    Cloud-based & accessible anywhere
                </div>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <div class="register-container">

                <div class="register-header">
                    <div class="register-eyebrow">✦ Customer Registration</div>
                    <h2>Create Account</h2>
                    <p>Join us today! It only takes a minute</p>
                </div>

                <!-- ERROR MESSAGE -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    ⚠ &nbsp;<%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <!-- SUCCESS MESSAGE -->
                <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    ✓ &nbsp;<%= request.getAttribute("successMessage") %>
                </div>
                <% } %>

                <!-- REGISTER FORM -->
                <form action="register" method="POST" id="registerForm">

                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <input type="text" id="username" name="username" placeholder="johndoe123" required autofocus />
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

                </form>

                <div class="divider"><span>or</span></div>

                <div class="login-link">
                    Already have an account?<a href="login.jsp">Sign in</a>
                </div>

            </div>
        </div>

    </div>

    <script>
        // ── Floating Particles ──
        var container = document.getElementById("particles");
        for (var i = 0; i < 14; i++) {
            var p = document.createElement("div");
            p.className = "particle";
            p.style.cssText = [
                "--x:" + Math.random() * 100 + "%",
                "--dur:" + (12 + Math.random() * 14) + "s",
                "--delay:" + (Math.random() * 12) + "s"
            ].join(";");
            container.appendChild(p);
        }

        // ── Password Strength Indicator ──
        const passwordInput = document.getElementById('password');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordHint = document.getElementById('passwordHint');

        passwordInput.addEventListener('input', function() {
            const value = this.value;
            
            if (value.length === 0) {
                passwordStrength.classList.remove('active', 'weak', 'medium', 'strong');
                passwordHint.classList.remove('active');
                return;
            }

            passwordStrength.classList.add('active');
            passwordHint.classList.add('active');

            let strength = 0;
            if (value.length >= 8) strength++;
            if (/[a-z]/.test(value) && /[A-Z]/.test(value)) strength++;
            if (/\d/.test(value)) strength++;
            if (/[^a-zA-Z0-9]/.test(value)) strength++;

            passwordStrength.classList.remove('weak', 'medium', 'strong');
            if (strength <= 1) {
                passwordStrength.classList.add('weak');
            } else if (strength <= 3) {
                passwordStrength.classList.add('medium');
            } else {
                passwordStrength.classList.add('strong');
            }
        });

        // ── Client-side Validation ──
        const form = document.getElementById('registerForm');
        const username = document.getElementById('username');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');

        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Clear previous errors
            document.querySelectorAll('.field-error').forEach(err => {
                err.classList.remove('active');
                err.textContent = '';
            });
            document.querySelectorAll('.input-error').forEach(input => {
                input.classList.remove('input-error');
            });

            // Username validation
            if (username.value.length < 3) {
                isValid = false;
                username.classList.add('input-error');
                document.getElementById('usernameError').textContent = 'Username must be at least 3 characters';
                document.getElementById('usernameError').classList.add('active');
            }

            // Password validation
            if (password.value.length < 8) {
                isValid = false;
                password.classList.add('input-error');
                document.getElementById('passwordError').textContent = 'Password must be at least 8 characters';
                document.getElementById('passwordError').classList.add('active');
            }

            // Confirm password validation
            if (password.value !== confirmPassword.value) {
                isValid = false;
                confirmPassword.classList.add('input-error');
                document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
                document.getElementById('confirmPasswordError').classList.add('active');
            }

            if (!isValid) {
                e.preventDefault();
                return false;
            }

            // Loading state
            submitBtn.classList.add('btn-loading');
            submitBtn.disabled = true;
        });
    </script>

</body>
</html>
