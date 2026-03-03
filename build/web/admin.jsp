<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort | Admin Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="dns-prefetch" href="https://images.unsplash.com">

    <!-- Preload hero -->
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80" fetchpriority="high">

    <!-- Preload card images -->
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1455587734955-081b22074882?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80">
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&q=80">

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --navy: #0a1628;
            --ocean: #0d2b4e;
            --teal: #0e7490;
            --crimson: #c0392b;
            --emerald: #10b981;
            --glass: rgba(255,255,255,0.06);
            --glass-border: rgba(255,255,255,0.12);
            --text-dim: rgba(255,255,255,0.55);
            --admin-accent: rgba(201,169,110,0.15);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        html { scroll-behavior: smooth; -webkit-overflow-scrolling: touch; }

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
            inset: 0;
            z-index: 0;
            background: url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80') center/cover no-repeat;
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }
        .hero-bg::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(5,13,26,0.82) 0%, rgba(5,13,26,0.65) 40%, rgba(5,13,26,0.93) 100%);
            pointer-events: none;
        }
        .hero-bg::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
            opacity: 0.4;
            pointer-events: none;
        }

        /* ── WAVES ── */
        .wave-container {
            position: fixed;
            bottom: 0; left: 0;
            width: 100%; height: 120px;
            z-index: 1; overflow: hidden;
            opacity: 0.18;
            will-change: transform;
            transform: translateZ(0);
            contain: layout style;
        }
        .wave {
            position: absolute;
            bottom: 0; left: -50%;
            width: 200%; height: 80px;
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
            top: 0; width: 100%;
            z-index: 100;
            background: rgba(5,13,26,0.90);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--glass-border);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            will-change: transform;
            transform: translateZ(0);
            contain: layout style;
            animation: pageIn 0.4s ease both;
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
        .wave-icon {
            font-size: 20px;
            animation: sway 3s ease-in-out infinite;
            display: inline-block;
        }
        @keyframes sway {
            0%, 100% { transform: rotate(-5deg); }
            50%       { transform: rotate(5deg); }
        }
        .nav-gold { color: var(--gold); }

        /* Admin badge in nav */
        .admin-nav-badge {
            background: linear-gradient(135deg, rgba(201,169,110,0.3), rgba(201,169,110,0.1));
            border: 1px solid rgba(201,169,110,0.5);
            color: var(--gold-light);
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            padding: 4px 10px;
            border-radius: 100px;
            margin-left: 4px;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
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
            width: 30px; height: 30px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--gold), #a07840);
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
            background: rgba(255,59,48,0.2);
            border: 1px solid rgba(255,59,48,0.4);
            padding: 7px 16px;
            border-radius: 100px;
            font-size: 13px;
            transition: all 0.3s;
        }
        .logout-btn:hover {
            background: rgba(255,59,48,0.4) !important;
            color: #ff6b6b !important;
        }
        .switch-btn {
            background: rgba(14,116,144,0.2);
            border: 1px solid rgba(14,116,144,0.4);
            color: #67e8f9 !important;
            padding: 7px 16px;
            border-radius: 100px;
            font-size: 13px;
            transition: all 0.3s;
        }
        .switch-btn:hover {
            background: rgba(14,116,144,0.4) !important;
        }

        /* ── MAIN ── */
        .container {
            position: relative;
            z-index: 10;
            padding: 130px 40px 80px;
            max-width: 1340px;
            margin: 0 auto;
            animation: pageIn 0.5s ease both;
        }

        @keyframes pageIn {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── WELCOME ── */
        .welcome {
            margin-bottom: 40px;
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
            width: 30px; height: 1px;
            background: var(--gold);
        }
        .welcome h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 48px;
            font-weight: 300;
            line-height: 1.1;
            margin-bottom: 14px;
        }
        .welcome h2 em {
            font-style: italic;
            color: var(--gold-light);
        }
        .welcome p {
            font-size: 14px;
            color: var(--text-dim);
            max-width: 440px;
            line-height: 1.7;
        }

        /* ── KPI STRIP ── */
        .kpi-strip {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 40px;
        }
        .kpi-card {
            background: var(--glass);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 20px 22px;
            position: relative;
            overflow: hidden;
            transition: border-color 0.3s, transform 0.3s;
        }
        .kpi-card:hover {
            border-color: rgba(201,169,110,0.35);
            transform: translateY(-3px);
        }
        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            opacity: 0.6;
        }
        .kpi-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .kpi-icon {
            font-size: 22px;
            opacity: 0.85;
        }
        .kpi-badge {
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.1em;
            padding: 3px 8px;
            border-radius: 100px;
        }
        .badge-up {
            background: rgba(16,185,129,0.2);
            border: 1px solid rgba(16,185,129,0.3);
            color: #6ee7b7;
        }
        .badge-warn {
            background: rgba(245,158,11,0.2);
            border: 1px solid rgba(245,158,11,0.3);
            color: #fcd34d;
        }
        .badge-info {
            background: rgba(14,116,144,0.2);
            border: 1px solid rgba(14,116,144,0.4);
            color: #67e8f9;
        }
        .badge-crit {
            background: rgba(192,57,43,0.2);
            border: 1px solid rgba(192,57,43,0.3);
            color: #fca5a5;
        }
        .kpi-num {
            font-family: 'Cormorant Garamond', serif;
            font-size: 38px;
            font-weight: 700;
            color: var(--gold-light);
            line-height: 1;
            margin-bottom: 4px;
        }
        .kpi-label {
            font-size: 11px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--text-dim);
        }
        .kpi-sub {
            font-size: 11px;
            color: var(--text-dim);
            margin-top: 8px;
        }

        /* ── SECTION LABEL ── */
        .section-label {
            font-size: 10px;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .section-label::after {
            content: '';
            flex: 1; height: 1px;
            background: var(--glass-border);
        }

        /* ── CARDS GRID ── */
        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        /* Featured = first card spans 2 cols + 2 rows */
        .cards > .card:first-child {
            grid-column: span 2;
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
            min-height: 180px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            contain: layout style;
            transform: translateZ(0);
        }
        .card:hover {
            transform: translateY(-6px);
            border-color: rgba(201,169,110,0.45);
            box-shadow: 0 24px 60px rgba(0,0,0,0.55), 0 0 0 1px rgba(201,169,110,0.15);
        }
        .card-img {
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            transition: transform 0.6s ease;
            z-index: 0;
            will-change: transform;
            transform: translateZ(0);
        }
        .card:hover .card-img { transform: scale(1.06); }
        .card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(5,13,26,0.93) 0%, rgba(5,13,26,0.45) 55%, rgba(5,13,26,0.15) 100%);
            z-index: 1;
            transition: opacity 0.3s;
        }
        .card:hover::before {
            background: linear-gradient(to top, rgba(5,13,26,0.97) 0%, rgba(5,13,26,0.6) 60%, rgba(5,13,26,0.2) 100%);
        }
        .card-content {
            position: relative;
            z-index: 2;
            padding: 24px;
        }
        .card-icon {
            width: 42px; height: 42px;
            border-radius: 11px;
            background: linear-gradient(135deg, rgba(201,169,110,0.3), rgba(201,169,110,0.1));
            border: 1px solid rgba(201,169,110,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-bottom: 12px;
            transition: all 0.3s;
        }
        .card:hover .card-icon {
            background: linear-gradient(135deg, rgba(201,169,110,0.5), rgba(201,169,110,0.2));
            transform: scale(1.1);
        }
        .card h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 6px;
            letter-spacing: 0.01em;
        }
        .card p {
            font-size: 12px;
            color: var(--text-dim);
            line-height: 1.6;
            max-width: 260px;
        }
        .card-arrow {
            position: absolute;
            right: 20px; bottom: 20px;
            z-index: 2;
            width: 34px; height: 34px;
            border-radius: 50%;
            border: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            transition: all 0.3s;
            background: var(--glass);
        }
        .card:hover .card-arrow {
            background: var(--gold);
            border-color: var(--gold);
            transform: translate(3px, -3px);
        }

        /* Featured overrides */
        .card:first-child { min-height: 400px; }
        .card:first-child h3 { font-size: 28px; }
        .card:first-child p  { font-size: 13px; max-width: 340px; }
        .card:first-child .card-icon { width: 50px; height: 50px; font-size: 22px; border-radius: 14px; }

        /* Danger-tinted card variant */
        .card.danger-card .card-icon {
            background: linear-gradient(135deg, rgba(192,57,43,0.3), rgba(192,57,43,0.1));
            border-color: rgba(192,57,43,0.4);
        }
        .card.danger-card:hover {
            border-color: rgba(192,57,43,0.5);
        }
        .card.danger-card:hover .card-arrow {
            background: var(--crimson);
            border-color: var(--crimson);
        }

        /* ── BOTTOM ROW: QUICK ACTIONS + LIVE STATUS ── */
        .bottom-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 18px;
        }

        .panel {
            background: var(--glass);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 26px 28px;
            position: relative;
            overflow: hidden;
        }
        .panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold-light), transparent);
            opacity: 0.3;
        }
        .panel-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .panel-sub {
            font-size: 12px;
            color: var(--text-dim);
            margin-bottom: 22px;
        }

        /* Quick links */
        .quick-links {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .quick-link {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            transition: all 0.3s;
            font-size: 13px;
        }
        .quick-link:hover {
            background: rgba(201,169,110,0.12);
            border-color: rgba(201,169,110,0.35);
            transform: translateX(4px);
        }
        .quick-link-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .quick-link-icon {
            width: 32px; height: 32px;
            border-radius: 8px;
            background: var(--admin-accent);
            border: 1px solid rgba(201,169,110,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }
        .quick-link-chevron {
            color: var(--text-dim);
            font-size: 12px;
            transition: transform 0.2s;
        }
        .quick-link:hover .quick-link-chevron { transform: translateX(3px); color: var(--gold); }

        /* Status list */
        .status-list { display: flex; flex-direction: column; gap: 14px; }
        .status-item {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .status-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            flex-shrink: 0;
            box-shadow: 0 0 6px currentColor;
        }
        .dot-green  { background: #10b981; color: #10b981; }
        .dot-gold   { background: var(--gold); color: var(--gold); }
        .dot-teal   { background: #0e7490; color: #0e7490; }
        .dot-orange { background: #f59e0b; color: #f59e0b; }
        .dot-red    { background: #ef4444; color: #ef4444; }

        .status-info { flex: 1; }
        .status-label {
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 2px;
        }
        .status-meta {
            font-size: 11px;
            color: var(--text-dim);
        }
        .status-value {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--gold-light);
            white-space: nowrap;
        }

        /* Occupancy bar */
        .occ-bar-wrap {
            margin-top: 18px;
            background: rgba(255,255,255,0.06);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 16px 18px;
        }
        .occ-bar-header {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: var(--text-dim);
            margin-bottom: 10px;
        }
        .occ-bar-header strong { color: var(--gold-light); font-size: 15px; }
        .bar-track {
            height: 6px;
            background: rgba(255,255,255,0.08);
            border-radius: 100px;
            overflow: hidden;
        }
        .bar-fill {
            height: 100%;
            border-radius: 100px;
            background: linear-gradient(90deg, var(--teal), var(--gold));
            transition: width 1s ease;
        }

        /* ── PARTICLES ── */
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
            0%   { opacity: 0;   transform: translateY(0) translateX(0); }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.2; }
            100% { opacity: 0;   transform: translateY(-100vh) translateX(20px); }
        }

        /* ── FOOTER ── */
        .footer {
            text-align: center;
            margin-top: 60px;
            font-size: 12px;
            color: var(--text-dim);
            letter-spacing: 0.08em;
            position: relative;
            z-index: 10;
        }
        .footer::before {
            content: '';
            display: block;
            width: 60px; height: 1px;
            background: var(--gold);
            margin: 0 auto 16px;
        }

        /* ── ALERT BANNER ── */
        .alert-banner {
            background: linear-gradient(135deg, rgba(245,158,11,0.18), rgba(245,158,11,0.06));
            border: 1px solid rgba(245,158,11,0.35);
            color: #fcd34d;
            padding: 12px 20px;
            margin-bottom: 28px;
            border-radius: 12px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-icon { font-size: 16px; }

        /* ── RESPONSIVE ── */
        @media (max-width: 1100px) {
            .kpi-strip { grid-template-columns: repeat(2, 1fr); }
            .cards { grid-template-columns: repeat(2, 1fr); }
            .cards > .card:first-child { grid-column: span 2; min-height: 280px; }
        }
        @media (max-width: 768px) {
            .bottom-grid { grid-template-columns: 1fr; }
            .kpi-strip { grid-template-columns: repeat(2, 1fr); }
            .welcome h2 { font-size: 34px; }
            .cards { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 600px) {
            .cards { grid-template-columns: 1fr; }
            .cards > .card:first-child { grid-column: span 1; }
            .navbar { padding: 12px 20px; }
            .container { padding: 110px 18px 60px; }
            .kpi-strip { grid-template-columns: 1fr 1fr; }
            .welcome h2 { font-size: 28px; }
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

    <!-- ── NAVBAR ── -->
    <div class="navbar">
        <h1>
            <span class="wave-icon">🌊</span>
            Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
            <span class="admin-nav-badge">Admin</span>
        </h1>
        <div class="navbar-right">
            <a href="dashboard.jsp" class="switch-btn">⬡ Guest View</a>
            <div class="user-badge">
                <div class="user-avatar" id="avatarInitial">A</div>
                <span>Admin, <strong><%= session.getAttribute("admin") != null ? session.getAttribute("admin") : "Administrator" %></strong></span>
            </div>
            <a href="logout" class="logout-btn">↩ Logout</a>
        </div>
    </div>

    <!-- ── CONTAINER ── -->
    <div class="container">

        <%-- Optional alert --%>
        <%
            String alert = (String) session.getAttribute("adminAlert");
            if (alert != null) {
        %>
        <div class="alert-banner">
            <span class="alert-icon">⚠</span>
            <%= alert %>
        </div>
        <%
            session.removeAttribute("adminAlert");
            }
        %>

        <!-- ── WELCOME ── -->
        <div class="welcome">
            <div class="welcome-left">
                <div class="welcome-eyebrow">Administration Control Panel</div>
                <h2>Resort <em>Command</em><br>Center</h2>
                <p>Full control over reservations, rooms, guests, staff, and revenue. Monitor and manage every aspect of Ocean View Resort from one unified dashboard.</p>
            </div>
        </div>

        <!-- ── KPI STRIP ── -->
        <div class="kpi-strip">
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-icon">🛏️</span>
                    <span class="kpi-badge badge-up">↑ LIVE</span>
                </div>
                <div class="kpi-num">18</div>
                <div class="kpi-label">Rooms Occupied</div>
                <div class="kpi-sub">6 available · 24 total</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-icon">📅</span>
                    <span class="kpi-badge badge-info">TODAY</span>
                </div>
                <div class="kpi-num">4</div>
                <div class="kpi-label">Check-ins Today</div>
                <div class="kpi-sub">3 check-outs pending</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-icon">💰</span>
                    <span class="kpi-badge badge-up">+12%</span>
                </div>
                <div class="kpi-num">$9.4k</div>
                <div class="kpi-label">Revenue This Month</div>
                <div class="kpi-sub">vs $8.4k last month</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-icon">🔧</span>
                    <span class="kpi-badge badge-warn">ACTION</span>
                </div>
                <div class="kpi-num">2</div>
                <div class="kpi-label">Maintenance Alerts</div>
                <div class="kpi-sub">Room 104, Pool area</div>
            </div>
        </div>

        <!-- ── MANAGEMENT CARDS ── -->
        <div class="section-label">Management Modules</div>
        <div class="cards">

            <!-- 1. FEATURED: All Reservations -->
            <div class="card" onclick="location.href='Adminviewreservation.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">📋</div>
                    <h3>Manage All Reservations</h3>
                    <p>View, edit, confirm, or cancel any reservation across all rooms. Full override access and booking history for every guest stay.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 2. Room Management -->
            <div class="card" onclick="location.href='adminRooms.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🏨</div>
                    <h3>Room Management</h3>
                    <p>Configure room types, pricing, availability, and status. Mark rooms for maintenance or housekeeping.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 3. Guest Directory -->
            <div class="card" onclick="location.href='adminGuests.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">👥</div>
                    <h3>Guest Directory</h3>
                    <p>Search the complete guest database, view profiles, stay history, and preferences.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 4. Revenue & Billing -->
            <div class="card" onclick="location.href='adminRevenue.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">💳</div>
                    <h3>Revenue & Billing</h3>
                    <p>View all invoices, process refunds, run revenue reports, and export financial summaries.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 5. Staff Management -->
            <div class="card" onclick="location.href='adminStaff.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1455587734955-081b22074882?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🪪</div>
                    <h3>Staff Management</h3>
                    <p>Add, edit, or deactivate staff accounts. Assign roles, manage shifts, and track activity logs.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 6. Housekeeping -->
            <div class="card" onclick="location.href='adminHousekeeping.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">🧹</div>
                    <h3>Housekeeping</h3>
                    <p>Track cleaning schedules, room status, and assign housekeeping tasks by floor or room type.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 7. Reports & Analytics -->
            <div class="card" onclick="location.href='adminReports.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">📊</div>
                    <h3>Reports & Analytics</h3>
                    <p>Occupancy rates, revenue trends, guest demographics, and seasonal forecasting dashboards.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

            <!-- 8. System Settings -->
            <div class="card danger-card" onclick="location.href='adminSettings.jsp'">
                <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&q=80')"></div>
                <div class="card-content">
                    <div class="card-icon">⚙️</div>
                    <h3>System Settings</h3>
                    <p>Configure system parameters, manage user roles, reset passwords, and adjust global policies.</p>
                </div>
                <div class="card-arrow">→</div>
            </div>

        </div>

        <!-- ── BOTTOM: QUICK ACTIONS + LIVE STATUS ── -->
        <div class="bottom-grid">

            <!-- Quick Actions Panel -->
            <div class="panel">
                <div class="panel-title">⚡ Quick Actions</div>
                <div class="panel-sub">Common administrative tasks at a glance</div>
                <div class="quick-links">
                    <a href="addReservation.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">🛎️</div>
                            <span>Create New Reservation</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                    <a href="adminCheckIn.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">✅</div>
                            <span>Process Check-In</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                    <a href="adminCheckOut.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">🚪</div>
                            <span>Process Check-Out</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                    <a href="adminPrintBill.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">🧾</div>
                            <span>Generate & Print Bill</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                    <a href="adminAddRoom.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">🏨</div>
                            <span>Add / Edit Room</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                    <a href="adminAddStaff.jsp" class="quick-link">
                        <div class="quick-link-left">
                            <div class="quick-link-icon">👤</div>
                            <span>Add New Staff Account</span>
                        </div>
                        <span class="quick-link-chevron">›</span>
                    </a>
                </div>
            </div>

            <!-- Live Status Panel -->
            <div class="panel">
                <div class="panel-title">📡 Live Status</div>
                <div class="panel-sub">Real-time resort overview</div>
                <div class="status-list">
                    <div class="status-item">
                        <div class="status-dot dot-green"></div>
                        <div class="status-info">
                            <div class="status-label">Front Desk System</div>
                            <div class="status-meta">All services operational</div>
                        </div>
                        <div class="status-value">Online</div>
                    </div>
                    <div class="status-item">
                        <div class="status-dot dot-gold"></div>
                        <div class="status-info">
                            <div class="status-label">Active Reservations</div>
                            <div class="status-meta">Updated just now</div>
                        </div>
                        <div class="status-value">18</div>
                    </div>
                    <div class="status-item">
                        <div class="status-dot dot-teal"></div>
                        <div class="status-info">
                            <div class="status-label">Guests On-Property</div>
                            <div class="status-meta">As of today</div>
                        </div>
                        <div class="status-value">34</div>
                    </div>
                    <div class="status-item">
                        <div class="status-dot dot-orange"></div>
                        <div class="status-info">
                            <div class="status-label">Pending Confirmations</div>
                            <div class="status-meta">Require admin approval</div>
                        </div>
                        <div class="status-value">3</div>
                    </div>
                    <div class="status-item">
                        <div class="status-dot dot-red"></div>
                        <div class="status-info">
                            <div class="status-label">Maintenance Requests</div>
                            <div class="status-meta">Room 104 · Pool deck</div>
                        </div>
                        <div class="status-value">2</div>
                    </div>
                </div>

                <!-- Occupancy Bar -->
                <div class="occ-bar-wrap">
                    <div class="occ-bar-header">
                        <span>Occupancy Rate</span>
                        <strong>75%</strong>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill" style="width:75%"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── FOOTER ── -->
        <div class="footer">
            © 2026 Ocean View Resort &nbsp;·&nbsp; Admin Control Panel &nbsp;·&nbsp; All rights reserved
        </div>

    </div>

    <script>
        // Avatar initial
        var adminName = "<%= session.getAttribute("admin") != null ? session.getAttribute("admin") : "A" %>";
        var av = document.getElementById("avatarInitial");
        if (adminName && adminName !== "null") {
            av.textContent = adminName.charAt(0).toUpperCase();
        }

        // Floating particles
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

        // Navbar scroll
        var ticking = false;
        window.addEventListener("scroll", function() {
            if (!ticking) {
                requestAnimationFrame(function() {
                    var nb = document.querySelector(".navbar");
                    nb.style.background = window.scrollY > 50
                        ? "rgba(5,13,26,0.98)"
                        : "rgba(5,13,26,0.90)";
                    ticking = false;
                });
                ticking = true;
            }
        }, { passive: true });

        // Animate bar on load
        window.addEventListener("load", function() {
            var bar = document.querySelector(".bar-fill");
            if (bar) {
                bar.style.width = "0";
                setTimeout(function() { bar.style.width = "75%"; }, 300);
            }
        });
    </script>

</body>
</html>
