<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Sign In</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --teal: #0e7490;
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
        }

        /* ── HERO BG ── */
        .hero-bg {
            position: fixed; inset: 0; z-index: 0;
            background: url('https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1920&q=80') center/cover no-repeat;
            will-change: transform; transform: translateZ(0); contain: strict;
        }
        .hero-bg::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(5,13,26,0.94) 0%, rgba(5,13,26,0.82) 50%, rgba(5,13,26,0.96) 100%);
        }

        /* ── WAVES ── */
        .wave-container {
            position: fixed; bottom: 0; left: 0;
            width: 100%; height: 100px;
            z-index: 1; overflow: hidden; opacity: 0.16;
        }
        .wave {
            position: absolute; bottom: 0; left: -50%;
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

        /* ── PARTICLES ── */
        .particles {
            position: fixed; inset: 0; z-index: 2;
            pointer-events: none; overflow: hidden;
        }
        .particle {
            position: absolute; width: 2px; height: 2px;
            border-radius: 50%; background: var(--gold-light); opacity: 0;
            animation: floatUp var(--dur, 15s) linear var(--delay, 0s) infinite;
            left: var(--x, 50%); bottom: -10px;
        }
        @keyframes floatUp {
            0%   { opacity: 0; transform: translateY(0); }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.2; }
            100% { opacity: 0; transform: translateY(-100vh); }
        }

        /* ── PAGE LAYOUT ── */
        .page-wrap {
            position: relative; z-index: 10;
            min-height: 100vh;
            display: grid; grid-template-columns: 1fr 1fr;
            animation: pageIn 0.6s ease both;
        }
        @keyframes pageIn {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── LEFT PANEL ── */
        .left-panel {
            display: flex; flex-direction: column;
            justify-content: center;
            padding: 60px 50px 60px 80px;
        }
        .brand-logo {
            display: flex; align-items: center;
            gap: 14px; margin-bottom: 40px;
        }
        .brand-icon {
            width: 52px; height: 52px; border-radius: 14px;
            background: linear-gradient(135deg, var(--teal), var(--gold));
            display: flex; align-items: center; justify-content: center;
            font-size: 26px;
            box-shadow: 0 12px 32px rgba(201,169,110,0.3);
        }
        .brand-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 28px; font-weight: 600;
            letter-spacing: 0.02em; line-height: 1.2;
        }
        .brand-name span { color: var(--gold-light); }
        .hero-text h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 54px; font-weight: 300;
            line-height: 1.1; margin-bottom: 20px;
        }
        .hero-text h1 em { font-style: italic; color: var(--gold-light); }
        .hero-text p { font-size: 15px; color: var(--text-dim); line-height: 1.8; max-width: 420px; }
        .feature-pills { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 32px; }
        .pill {
            display: flex; align-items: center; gap: 8px;
            padding: 8px 16px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 100px; font-size: 12px; color: var(--text-dim);
        }

        /* ── RIGHT PANEL ── */
        .right-panel {
            display: flex; align-items: center; justify-content: center;
            padding: 60px 80px 60px 50px;
        }

        /* ── LOGIN BOX ── */
        .login-container {
            width: 100%; max-width: 460px;
            background: rgba(4,11,24,0.88);
            border: 1px solid var(--glass-border);
            border-radius: 24px; padding: 40px;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.7), 0 0 0 1px rgba(201,169,110,0.1);
        }

        /* ── HEADER ── */
        .login-header { margin-bottom: 32px; text-align: center; }
        .login-eyebrow {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(201,169,110,0.15);
            border: 1px solid rgba(201,169,110,0.3);
            color: var(--gold-light); font-size: 11px;
            letter-spacing: 0.12em; text-transform: uppercase;
            padding: 4px 14px; border-radius: 100px; margin-bottom: 16px;
        }
        .login-header h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 32px; font-weight: 300; margin-bottom: 6px;
        }
        .login-header p { font-size: 13px; color: var(--text-dim); }

        /* ── MESSAGES ── */
        .logout-message {
            background: linear-gradient(135deg, rgba(16,185,129,0.25), rgba(5,150,105,0.15));
            color: #6ee7b7; border: 1px solid rgba(16,185,129,0.35);
            padding: 12px 16px; margin-bottom: 20px; border-radius: 12px;
            text-align: center; font-size: 13px;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            animation: slideDown 0.4s ease;
        }
        .error-message {
            background: rgba(239,68,68,0.15); border: 1px solid rgba(239,68,68,0.35);
            color: #fca5a5; padding: 12px 16px; margin-bottom: 20px;
            border-radius: 12px; font-size: 13px;
            display: flex; align-items: center; gap: 8px;
            animation: shake 0.5s;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes shake {
            0%,100% { transform: translateX(0); }
            10%,30%,50%,70%,90% { transform: translateX(-6px); }
            20%,40%,60%,80%     { transform: translateX(6px); }
        }

        /* ── FORM ── */
        .form-group { margin-bottom: 18px; }
        label {
            font-size: 11px; font-weight: 500;
            letter-spacing: 0.1em; text-transform: uppercase;
            color: var(--text-dim); margin-bottom: 6px; display: block;
        }
        .input-wrapper { position: relative; }
        .input-icon {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%);
            width: 18px; height: 18px;
            color: rgba(255,255,255,0.3);
            pointer-events: none; z-index: 1;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 13px 14px 13px 44px;
            background: rgba(3,9,20,0.80);
            border: 1px solid rgba(255,255,255,0.22);
            border-radius: 12px; color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; outline: none;
            transition: border-color 0.25s, background 0.25s, box-shadow 0.25s;
        }
        input[type="text"]::placeholder,
        input[type="password"]::placeholder { color: rgba(255,255,255,0.30); }
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: var(--gold);
            background: rgba(201,169,110,0.07);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.15);
        }
        /* ── EYE TOGGLE ── */
        .eye-toggle {
            position: absolute; right: 14px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: rgba(255,255,255,0.3);
            cursor: pointer; padding: 4px;
            display: flex; align-items: center;
            transition: color 0.2s; z-index: 2;
        }
        .eye-toggle:hover { color: var(--gold); }
        .eye-toggle svg { width: 18px; height: 18px; }
        #password { padding-right: 44px; }

        .forgot-password { text-align: right; margin-top: 6px; }
        .forgot-password a {
            font-size: 11px; color: var(--gold); text-decoration: none;
            font-weight: 500; letter-spacing: 0.05em; transition: color 0.2s;
        }
        .forgot-password a:hover { color: var(--gold-light); }

        /* ── SUBMIT ── */
        input[type="submit"] {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #c9a96e, #e8c98a);
            border: none; border-radius: 12px;
            color: var(--deep-navy);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 700;
            letter-spacing: 0.06em; text-transform: uppercase;
            cursor: pointer; margin-top: 8px;
            transition: all 0.3s; position: relative; overflow: hidden;
        }
        input[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(201,169,110,0.5);
        }
        input[type="submit"]:active { transform: translateY(0); }
        .btn-loading { pointer-events: none; color: transparent !important; }
        .btn-loading::after {
            content: ''; position: absolute;
            width: 18px; height: 18px;
            top: 50%; left: 50%;
            margin-left: -9px; margin-top: -9px;
            border: 2px solid var(--deep-navy);
            border-radius: 50%; border-top-color: transparent;
            animation: spin 0.6s linear infinite; z-index: 2;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ── DIVIDER ── */
        .divider {
            margin: 24px 0 20px;
            display: flex; align-items: center; gap: 14px;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px;
            background: rgba(255,255,255,0.12);
        }
        .divider span {
            color: var(--text-dim); font-size: 11px;
            letter-spacing: 0.1em; text-transform: uppercase;
        }

        /* ── SIGNUP ── */
        .signup-link { text-align: center; font-size: 13px; color: var(--text-dim); }
        .signup-link a {
            color: var(--gold-light); text-decoration: none;
            font-weight: 600; margin-left: 4px; transition: color 0.2s;
        }
        .signup-link a:hover { color: var(--gold); }

        /* ── RESPONSIVE ── */
        @media (max-width: 960px) {
            .page-wrap { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 40px 20px; }
        }
        @media (max-width: 480px) {
            .login-container { padding: 32px 22px; }
            .login-header h2 { font-size: 26px; }
        }
    </style>
</head>
<body>

    <div class="hero-bg"></div>
    <div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
    <div class="particles" id="particles"></div>

    <div class="page-wrap">

        <!-- LEFT PANEL -->
        <div class="left-panel">
            <div class="brand-logo">
                <div class="brand-icon">🌊</div>
                <div class="brand-name">Ocean<span> View</span><br>Resort</div>
            </div>
            <div class="hero-text">
                <h1>Your Gateway to<br><em>Coastal Paradise</em></h1>
                <p>Welcome to Ocean View Resort's management portal. Sign in to access reservations, guest services, and property management tools.</p>
            </div>
            <div class="feature-pills">
                <div class="pill"><span>🛏️</span> Luxury Suites</div>
                <div class="pill"><span>🌅</span> Ocean Views</div>
                <div class="pill"><span>⭐</span> 5-Star Service</div>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <div class="login-container">

                <div class="login-header">
                    <div class="login-eyebrow">✦ Resort Portal</div>
                    <h2>Welcome Back</h2>
                    <p>Enter your credentials to access the system</p>
                </div>

                <!-- LOGOUT MESSAGE -->
                <%
                    String logoutMsg = (String) session.getAttribute("logoutMessage");
                    if (logoutMsg != null) {
                %>
                <div class="logout-message" id="logoutBox">✓ &nbsp;<%= logoutMsg %></div>
                <script>
                    setTimeout(function(){
                        var b = document.getElementById("logoutBox");
                        if(b) b.style.display = "none";
                    }, 5000);
                </script>
                <% session.removeAttribute("logoutMessage"); } %>

                <!-- ERROR MESSAGE -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">⚠ &nbsp;<%= request.getAttribute("errorMessage") %></div>
                <% } %>

                <!-- FORM -->
                <form action="login" method="POST" id="loginForm">

                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            <input type="text" id="username" name="username"
                                   placeholder="Enter your username" required autofocus/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                            <input type="password" id="password" name="password"
                                   placeholder="Enter your password" required/>
                            <!-- Eye toggle -->
                            <button type="button" class="eye-toggle" id="eyeBtn"
                                    onclick="togglePassword()" aria-label="Show/hide password">
                                <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" fill="none"
                                     viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7
                                             -1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                        </div>
                        <div class="forgot-password">
                            <a href="#forgot">Forgot password?</a>
                        </div>
                    </div>

                    <div class="form-group">
                        <input type="submit" value="Sign In" id="submitBtn"/>
                    </div>

                </form>

                <div class="divider"><span>or</span></div>
                <div class="signup-link">
                    Don't have an account? <a href="register.jsp">Create one</a>
                </div>

            </div>
        </div>
    </div>

    <script>
        // Particles
        var pc = document.getElementById("particles");
        for (var i = 0; i < 14; i++) {
            var p = document.createElement("div");
            p.className = "particle";
            p.style.cssText = "--x:" + Math.random()*100 + "%;--dur:" + (12+Math.random()*14) + "s;--delay:" + (Math.random()*12) + "s";
            pc.appendChild(p);
        }
        // Show / Hide password toggle
        function togglePassword() {
            var input = document.getElementById("password");
            var btn   = document.getElementById("eyeBtn");
            var isHidden = input.type === "password";

            input.type = isHidden ? "text" : "password";
            btn.style.color = isHidden ? "var(--gold)" : "rgba(255,255,255,0.3)";

            // Swap icon: eye-off when visible, eye when hidden
            btn.querySelector("svg").innerHTML = isHidden
                ? /* eye-off */
                  '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>'
                : /* eye-on */
                  '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>';
        }

        // Loading state
        document.getElementById("loginForm").addEventListener("submit", function(){
            var btn = document.getElementById("submitBtn");
            btn.classList.add("btn-loading");
            btn.disabled = true;
        });
    </script>

</body>
</html>
