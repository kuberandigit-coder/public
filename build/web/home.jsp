<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort | Dashboard</title>

    <!-- ── INSTANT LOAD: DNS + connections pre-warmed ── -->
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="dns-prefetch" href="https://images.unsplash.com">

    <!-- ── PRELOAD hero bg image (highest priority, no layout shift) ── -->
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80" fetchpriority="high">

    <!-- ── PRELOAD card images ── -->
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1504615755583-2916b52192a3?w=800&q=80">

    <!-- ── Fonts: display=swap so text shows instantly with fallback ── -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --navy: #0a1628;
            --ocean: #0d2b4e;
            --teal: #0e7490;
            --glass: rgba(255,255,255,0.06);
            --glass-border: rgba(255,255,255,0.12);
            --text-dim: rgba(255,255,255,0.55);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--deep-navy);
            min-height: 100vh;
            color: white;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            overscroll-behavior: none;
        }

        /* ── HERO BACKGROUND ── */
        .hero-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            /* Separate image layer so GPU handles it independently */
            background:
                url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80') center/cover no-repeat;
            /* Promote to own compositing layer — no scroll repaint */
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }

        /* Gradient overlay as separate layer — never triggers repaint */
        .hero-bg::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(5,13,26,0.72) 0%, rgba(5,13,26,0.55) 40%, rgba(5,13,26,0.88) 100%);
            pointer-events: none;
        }

        /* ── OVERLAY NOISE TEXTURE ── */
        .hero-bg::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
            opacity: 0.4;
            pointer-events: none;
            will-change: auto;
        }

        /* ── ANIMATED WAVES ── */
        .wave-container {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 120px;
            z-index: 1;
            overflow: hidden;
            opacity: 0.18;
            /* Own compositing layer — doesn't affect scroll paint */
            will-change: transform;
            transform: translateZ(0);
            contain: layout style;
        }

        .wave {
            position: absolute;
            bottom: 0;
            left: -50%;
            width: 200%;
            height: 80px;
            background: linear-gradient(to right, transparent, var(--teal), transparent);
            border-radius: 50%;
            animation: wave 8s ease-in-out infinite;
        }

        .wave:nth-child(2) {
            height: 60px;
            animation: wave 12s ease-in-out infinite reverse;
            opacity: 0.6;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }

        @keyframes wave {
            0%, 100% { transform: translateX(0) translateY(0); }
            50%       { transform: translateX(8%) translateY(-12px); }
        }

        /* ── NAVBAR ── */
        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 100;
            background: rgba(5,13,26,0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--glass-border);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s;
            /* Isolate navbar paint from scroll area */
            will-change: transform;
            transform: translateZ(0);
            contain: layout style;
        }

        .navbar h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 24px;
            font-weight: 600;
            letter-spacing: 0.04em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar h1 span.wave-icon {
            font-size: 20px;
            animation: sway 3s ease-in-out infinite;
            display: inline-block;
        }

        @keyframes sway {
            0%, 100% { transform: rotate(-5deg); }
            50%       { transform: rotate(5deg); }
        }

        .nav-gold { color: var(--gold); }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-badge {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--glass);
            border: 1px solid var(--glass-border);
            padding: 7px 16px 7px 10px;
            border-radius: 100px;
            font-size: 13px;
            font-weight: 500;
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--teal), var(--gold));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 13px;
            transition: 0.3s;
        }

        .navbar a:hover { color: var(--gold-light); }

        .logout-btn {
            background: rgba(255, 59, 48, 0.2);
            border: 1px solid rgba(255, 59, 48, 0.4);
            padding: 7px 16px;
            border-radius: 100px;
            font-size: 13px;
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: rgba(255, 59, 48, 0.4) !important;
            color: #ff6b6b !important;
        }

        /* ── MAIN CONTAINER ── */
        .container {
            position: relative;
            z-index: 10;
            padding: 140px 40px 80px;
            max-width: 1300px;
            margin: 0 auto;
        }

        /* ── SUCCESS / MSG BANNERS ── */
        .success-message {
            background: linear-gradient(135deg, rgba(16,185,129,0.25), rgba(5,150,105,0.15));
            color: #6ee7b7;
            border: 1px solid rgba(16,185,129,0.35);
            padding: 14px 20px;
            margin-bottom: 30px;
            border-radius: 12px;
            text-align: center;
            font-size: 14px;
            backdrop-filter: blur(10px);
            animation: fadeSlideDown 0.4s ease;
        }

        .success-box {
            background: linear-gradient(135deg, rgba(201,169,110,0.25), rgba(201,169,110,0.1));
            color: var(--gold-light);
            border: 1px solid rgba(201,169,110,0.35);
            padding: 14px 20px;
            margin-bottom: 30px;
            border-radius: 12px;
            text-align: center;
            font-size: 14px;
            backdrop-filter: blur(10px);
        }

        @keyframes fadeSlideDown {
            from { opacity: 0; transform: translateY(-12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── WELCOME HERO SECTION ── */
        .welcome {
            margin-bottom: 60px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 20px;
        }

        .welcome-left { max-width: 600px; }

        .welcome-eyebrow {
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .welcome-eyebrow::before {
            content: '';
            width: 30px;
            height: 1px;
            background: var(--gold);
        }

        .welcome h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 52px;
            font-weight: 300;
            line-height: 1.1;
            letter-spacing: -0.01em;
            margin-bottom: 16px;
        }

        .welcome h2 em {
            font-style: italic;
            color: var(--gold-light);
        }

        .welcome p {
            font-size: 15px;
            color: var(--text-dim);
            max-width: 420px;
            line-height: 1.7;
        }

        /* STAT PILLS */
        .stat-pills {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .stat-pill {
            background: var(--glass);
            border: 1px solid var(--glass-border);
            padding: 12px 20px;
            border-radius: 12px;
            backdrop-filter: blur(10px);
            text-align: center;
            min-width: 100px;
        }

        .stat-pill .num {
            font-family: 'Cormorant Garamond', serif;
            font-size: 28px;
            font-weight: 700;
            color: var(--gold-light);
            line-height: 1;
        }

        .stat-pill .label {
            font-size: 10px;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-top: 4px;
        }

        /* ── SECTION DIVIDER ── */
        .section-label {
            font-size: 10px;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .section-label::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--glass-border);
        }

        /* ── CARDS GRID ── */
        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        /* FEATURED CARD (first) */
        .cards > .card:first-child {
            grid-column: span 1;
            grid-row: span 2;
        }

        .card {
            position: relative;
            background: var(--glass);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.4s cubic-bezier(0.25,0.46,0.45,0.94),
                        border-color 0.3s, box-shadow 0.4s;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            /* Removed backdrop-filter — major scroll perf killer on many cards */
            contain: layout style;
            transform: translateZ(0);
        }

        .card:hover {
            transform: translateY(-6px);
            border-color: rgba(201,169,110,0.4);
            box-shadow: 0 24px 60px rgba(0,0,0,0.5), 0 0 0 1px rgba(201,169,110,0.15);
        }

        /* Card image backgrounds */
        .card-img {
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            transition: transform 0.6s ease;
            z-index: 0;
            /* Pre-promoted to GPU layer — zoom is instant, no jank */
            will-change: transform;
            transform: translateZ(0);
        }

        .card:hover .card-img { transform: scale(1.06); }

        /* Image overlay gradient */
        .card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(5,13,26,0.92) 0%, rgba(5,13,26,0.4) 50%, rgba(5,13,26,0.15) 100%);
            z-index: 1;
            transition: opacity 0.3s;
        }

        .card:hover::before {
            background: linear-gradient(to top, rgba(5,13,26,0.96) 0%, rgba(5,13,26,0.55) 60%, rgba(5,13,26,0.2) 100%);
        }

        .card-content {
            position: relative;
            z-index: 2;
            padding: 28px;
        }

        .card-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: linear-gradient(135deg, rgba(201,169,110,0.3), rgba(201,169,110,0.1));
            border: 1px solid rgba(201,169,110,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
            transition: all 0.3s;
        }

        .card:hover .card-icon {
            background: linear-gradient(135deg, rgba(201,169,110,0.5), rgba(201,169,110,0.2));
            transform: scale(1.1);
        }

        .card h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: 0.01em;
        }

        .card p {
            font-size: 13px;
            color: var(--text-dim);
            line-height: 1.6;
            max-width: 280px;
        }

        .card-arrow {
            position: absolute;
            right: 24px;
            bottom: 24px;
            z-index: 2;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            transition: all 0.3s;
            background: var(--glass);
        }

        .card:hover .card-arrow {
            background: var(--gold);
            border-color: var(--gold);
            transform: translate(3px, -3px);
        }

        /* Featured card tall */
        .card:first-child { min-height: 440px; }
        .card:first-child h3 { font-size: 30px; }
        .card:first-child p  { font-size: 14px; }

        /* ── FOOTER ── */
        .footer {
            text-align: center;
            margin-top: 70px;
            font-size: 12px;
            color: var(--text-dim);
            letter-spacing: 0.08em;
            position: relative;
            z-index: 10;
        }

        .footer::before {
            content: '';
            display: block;
            width: 60px;
            height: 1px;
            background: var(--gold);
            margin: 0 auto 16px;
        }

        /* ── FLOATING PARTICLES ── */
        .particles {
            position: fixed;
            inset: 0;
            z-index: 2;
            pointer-events: none;
            overflow: hidden;
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }

        .particle {
            position: absolute;
            width: 2px;
            height: 2px;
            border-radius: 50%;
            background: var(--gold-light);
            opacity: 0;
            animation: floatUp var(--dur, 15s) linear var(--delay, 0s) infinite;
            left: var(--x, 50%);
            bottom: -10px;
        }

        @keyframes floatUp {
            0%   { opacity: 0;   transform: translateY(0)   translateX(0); }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.2; }
            100% { opacity: 0;   transform: translateY(-100vh) translateX(20px); }
        }

        /* ── PAGE ENTRY — content fades in after paint, hides any asset flash ── */
        @keyframes pageIn {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .container {
            animation: pageIn 0.5s ease both;
        }

        .navbar {
            animation: pageIn 0.4s ease both;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 900px) {
            .cards { grid-template-columns: 1fr 1fr; }
            .cards > .card:first-child { grid-column: span 2; grid-row: span 1; min-height: 280px; }
            .welcome h2 { font-size: 36px; }
        }

        @media (max-width: 600px) {
            .cards { grid-template-columns: 1fr; }
            .cards > .card:first-child { grid-column: span 1; }
            .navbar { padding: 12px 20px; }
            .container { padding: 120px 20px 60px; }
            .welcome h2 { font-size: 30px; }
            .navbar h1 { font-size: 18px; }
        }
    </style>
</head>
<body>

    <!-- Background -->
    <div class="hero-bg"></div>

    <!-- Waves -->
    <div class="wave-container">
        <div class="wave"></div>
        <div class="wave"></div>
    </div>

    <!-- Floating Particles -->
    <div class="particles" id="particles"></div>

    <!-- ── NAVBAR ── -->
    <div class="navbar">
        <h1>
            <span class="wave-icon">🌊</span>
            Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        </h1>
        <div class="navbar-right">
            <div class="user-badge">
                <div class="user-avatar" id="avatarInitial">?</div>
                <span>Welcome, <strong><%= session.getAttribute("user") %></strong></span>
            </div>
            <a href="logout" class="logout-btn">↩ Logout</a>
        </div>
    </div>

    <!-- ── MAIN CONTAINER ── -->
    <div class="container">

        <!-- SUCCESS MESSAGE (session-based) -->
        <% 
            String success = (String) session.getAttribute("successMessage");
            if (success != null) { 
        %>
            <div class="success-message" id="successBox">
                ✓ &nbsp;<%= success %>
            </div>
            <script>
                setTimeout(function() {
                    var box = document.getElementById("successBox");
                    if (box) { box.style.display = "none"; }
                }, 5000);
            </script>
        <% 
                session.removeAttribute("successMessage");
            } 
        %>

        <!-- SUCCESS MESSAGE (query param) -->
        <%
        String message = request.getParameter("msg");
        if (message != null) {
        %>
        <div class="success-box">
            ✦ &nbsp;<%= message %>
        </div>
        <%
        }
        %>

        <!-- ── WELCOME ── -->
        <div class="welcome">
            <div class="welcome-left">
                <div class="welcome-eyebrow">Reservation Management System</div>
                <h2>Where <em>Luxury</em><br>Meets the Sea</h2>
                <p>Manage bookings, guests, and billing with elegance and precision from your central command center.</p>
            </div>
            <div class="stat-pills">
                <div class="stat-pill">
                    <div class="num">24</div>
                    <div class="label">Suites</div>
                </div>
                <div class="stat-pill">
                    <div class="num">98%</div>
                    <div class="label">Satisfaction</div>
                </div>
                <div class="stat-pill">
                    <div class="num">5★</div>
                    <div class="label">Rating</div>
                </div>
            </div>
        </div>

        <!-- ── CARDS ── -->
        <div class="section-label">Quick Actions</div>

        <div class="cards">

            <!-- 1. Add Reservation (FEATURED) -->
            <div class="card" onclick="location.href='addReservation.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🛎️</div>
                    <h3>Add New Reservation</h3>
                    <p>Register new guest bookings into the system with full room and guest details.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 2. View Reservation -->
            <div class="card" onclick="location.href='viewReservation.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🔍</div>
                    <h3>View Reservation</h3>
                    <p>Search and display detailed booking information.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 3. Calculate Bill -->
            <div class="card" onclick="location.href='calculateBill.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🧾</div>
                    <h3>Calculate & Print Bill</h3>
                    <p>Generate invoices based on room type and stay duration.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 4. Reports -->
            <div class="card" onclick="location.href='reports.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">📊</div>
                    <h3>Reports</h3>
                    <p>View booking summaries, occupancy stats and analytics.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 5. Help -->
            <div class="card" onclick="location.href='help.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">💡</div>
                    <h3>Help Section</h3>
                    <p>Guidelines and documentation for using the system.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 6. Exit -->
            <div class="card" onclick="location.href='exit.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1504615755583-2916b52192a3?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🚪</div>
                    <h3>Exit System</h3>
                    <p>Safely close and exit the application session.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

        </div>

        <!-- ── FOOTER ── -->
        <div class="footer">
            © 2026 Ocean View Resort &nbsp;·&nbsp; Advanced Programming Project &nbsp;·&nbsp; All rights reserved
        </div>

    </div>

    <script>
        // ── Avatar initial from username ──
        var user = "<%= session.getAttribute("user") %>";
        var av = document.getElementById("avatarInitial");
        if (user && user !== "null") {
            av.textContent = user.charAt(0).toUpperCase();
        }

        // ── Floating Particles ──
        var container = document.getElementById("particles");
        for (var i = 0; i < 18; i++) {
            var p = document.createElement("div");
            p.className = "particle";
            p.style.cssText = [
                "--x:" + Math.random() * 100 + "%",
                "--dur:" + (12 + Math.random() * 14) + "s",
                "--delay:" + (Math.random() * 12) + "s"
            ].join(";");
            container.appendChild(p);
        }

        // ── Navbar scroll — rAF throttled, never blocks scroll thread ──
        var ticking = false;
        window.addEventListener("scroll", function() {
            if (!ticking) {
                requestAnimationFrame(function() {
                    var nb = document.querySelector(".navbar");
                    nb.style.background = window.scrollY > 50
                        ? "rgba(5,13,26,0.97)"
                        : "rgba(5,13,26,0.85)";
                    ticking = false;
                });
                ticking = true;
            }
        }, { passive: true });
    </script>

</body>
</html>
