<%--
    Document   : addReservation
    Created on : 15 Feb 2026, 10:39:44
    Author     : PC
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort | Add Reservation</title>

    <!-- ── INSTANT LOAD ── -->
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --teal: #0e7490;
            --glass: rgba(255,255,255,0.06);
            --glass-border: rgba(255,255,255,0.18);
            --text-dim: rgba(255,255,255,0.70);
            --input-bg: rgba(4,12,28,0.75);
            --input-border: rgba(255,255,255,0.22);
            --input-focus: rgba(201,169,110,0.5);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        html { -webkit-overflow-scrolling: touch; }

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
            background: url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920&q=80') center/cover no-repeat;
            will-change: transform;
            transform: translateZ(0);
            contain: strict;
        }

        .hero-bg::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(5,13,26,0.96) 0%, rgba(5,13,26,0.88) 50%, rgba(5,13,26,0.97) 100%);
        }

        /* ── WAVES ── */
        .wave-container {
            position: fixed;
            bottom: 0; left: 0;
            width: 100%; height: 100px;
            z-index: 1; overflow: hidden;
            opacity: 0.14;
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

        /* ── NAVBAR ── */
        .navbar {
            position: fixed;
            top: 0; width: 100%;
            z-index: 100;
            background: rgba(5,13,26,0.85);
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
            font-size: 22px;
            font-weight: 600;
            letter-spacing: 0.04em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .wave-icon {
            display: inline-block;
            animation: sway 3s ease-in-out infinite;
        }

        @keyframes sway {
            0%,100% { transform: rotate(-5deg); }
            50%      { transform: rotate(5deg); }
        }

        .nav-gold { color: var(--gold); }

        .nav-back {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-dim);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            padding: 7px 16px;
            border-radius: 100px;
            border: 1px solid var(--glass-border);
            background: var(--glass);
            transition: all 0.3s;
        }

        .nav-back:hover {
            color: var(--gold-light);
            border-color: rgba(201,169,110,0.4);
        }

        /* ── PAGE LAYOUT ── */
        .page-wrap {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            animation: pageIn 0.5s ease both;
            padding-top: 70px;
        }

        @keyframes pageIn {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── LEFT PANEL (decorative) ── */
        .left-panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 50px 60px 60px;
        }

        .left-eyebrow {
            font-size: 10px;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            color: var(--gold);
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .left-eyebrow::before {
            content: '';
            width: 28px; height: 1px;
            background: var(--gold);
        }

        .left-panel h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 54px;
            font-weight: 300;
            line-height: 1.08;
            margin-bottom: 20px;
        }

        .left-panel h2 em {
            font-style: italic;
            color: var(--gold-light);
        }

        .left-panel p {
            font-size: 14px;
            color: var(--text-dim);
            line-height: 1.8;
            max-width: 380px;
            margin-bottom: 40px;
        }

        /* ROOM PREVIEW CARD */
        .room-preview {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            max-width: 380px;
        }

        .room-card {
            position: relative;
            border-radius: 14px;
            overflow: hidden;
            height: 130px;
            border: 1px solid var(--glass-border);
            cursor: default;
            transition: transform 0.3s, border-color 0.3s;
        }

        .room-card:hover {
            transform: translateY(-3px);
            border-color: rgba(201,169,110,0.4);
        }

        .room-card img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
        }

        .room-card::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(5,13,26,0.85) 0%, transparent 60%);
        }

        .room-card-label {
            position: absolute;
            bottom: 10px; left: 12px;
            z-index: 2;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--gold-light);
        }

        .room-card.featured { grid-column: span 2; height: 150px; }

        /* ── RIGHT PANEL (form) ── */
        .right-panel {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 60px 60px 30px;
        }

        /* ── FORM BOX ── */
        .form-box {
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

        .form-header {
            margin-bottom: 32px;
        }

        .form-header .step-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(201,169,110,0.15);
            border: 1px solid rgba(201,169,110,0.3);
            color: var(--gold-light);
            font-size: 11px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            padding: 4px 12px;
            border-radius: 100px;
            margin-bottom: 14px;
        }

        .form-header h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .form-header p {
            font-size: 13px;
            color: var(--text-dim);
        }

        /* DIVIDER */
        .form-divider {
            font-size: 10px;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.55);
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0 16px;
        }

        .form-divider::before,
        .form-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.15);
        }

        /* FIELD GROUP */
        .field-group {
            display: grid;
            gap: 12px;
        }

        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .field label {
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--text-dim);
        }

        input, select {
            width: 100%;
            padding: 11px 14px;
            background: rgba(3, 9, 20, 0.80);
            border: 1px solid rgba(255,255,255,0.22);
            border-radius: 10px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            outline: none;
            transition: border-color 0.25s, background 0.25s, box-shadow 0.25s;
            -webkit-appearance: none;
            appearance: none;
        }

        input::placeholder { color: rgba(255,255,255,0.35); }

        input:focus, select:focus {
            border-color: var(--gold);
            background: rgba(201,169,110,0.08);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.12);
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1) opacity(0.5);
            cursor: pointer;
        }

        /* SELECT CUSTOM ARROW */
        .select-wrap {
            position: relative;
        }

        .select-wrap::after {
            content: '▾';
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gold);
            font-size: 13px;
            pointer-events: none;
        }

        select option {
            background: #0a1628;
            color: white;
        }

        /* ROOM TYPE PILLS */
        .room-pills {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-bottom: 4px;
        }

        .room-pill {
            position: relative;
        }

        .room-pill input[type="radio"] {
            position: absolute;
            opacity: 0;
            width: 0; height: 0;
        }

        .room-pill label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            padding: 10px 8px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.22);
            background: rgba(3, 9, 20, 0.80);
            cursor: pointer;
            text-transform: none;
            font-size: 13px;
            font-weight: 500;
            letter-spacing: 0;
            color: rgba(255,255,255,0.75);
            transition: all 0.25s;
        }

        .room-pill label .pill-icon { font-size: 20px; }
        .room-pill label .pill-price {
            font-size: 10px;
            color: var(--gold);
            letter-spacing: 0.05em;
        }

        .room-pill input[type="radio"]:checked + label {
            background: rgba(201,169,110,0.15);
            border-color: var(--gold);
            color: white;
            box-shadow: 0 0 0 3px rgba(201,169,110,0.12);
        }

        .room-pill label:hover {
            border-color: rgba(201,169,110,0.4);
            color: white;
        }

        /* SUBMIT BUTTON */
        button {
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
            margin-top: 24px;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        button::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, #e8c98a, #fff3cc);
            opacity: 0;
            transition: opacity 0.3s;
        }

        button:hover::before { opacity: 1; }
        button:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(201,169,110,0.4); }
        button:active { transform: translateY(0); }

        button span { position: relative; z-index: 1; }

        /* ── RESPONSIVE ── */
        @media (max-width: 960px) {
            .page-wrap { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 40px 20px; }
            .form-box { max-width: 100%; }
        }

        @media (max-width: 480px) {
            .field-row { grid-template-columns: 1fr; }
            .navbar { padding: 12px 20px; }
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

    <!-- ── NAVBAR ── -->
    <div class="navbar">
        <h1>
            <span class="wave-icon">🌊</span>
            Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        </h1>
        <a href="home.jsp" class="nav-back">
            ← Go Back
        </a>
    </div>

    <!-- ── PAGE ── -->
    <div class="page-wrap">

        <!-- LEFT PANEL -->
        <div class="left-panel">
            <div class="left-eyebrow">Guest Booking</div>
            <h2>Reserve Your<br><em>Perfect</em><br>Ocean Escape</h2>
            <p>Complete the reservation form to secure your guest's stay at Ocean View Resort — where every detail is handled with care.</p>

            <div class="room-preview">
                <div class="room-card featured">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=700&q=80" alt="Suite">
                    <span class="room-card-label">Ocean Suite</span>
                </div>
                <div class="room-card">
                    <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400&q=80" alt="Standard">
                    <span class="room-card-label">Standard</span>
                </div>
                <div class="room-card">
                    <img src="https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=400&q=80" alt="Deluxe">
                    <span class="room-card-label">Deluxe</span>
                </div>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <div class="form-box">

                <div class="form-header">
                    <div class="step-tag">✦ New Booking</div>
                    <h3>Add New Reservation</h3>
                    <p>Fill in the guest and room details below.</p>
                </div>

                <form action="addReservation" method="post">

                    <!-- GUEST INFO -->
                    <div class="form-divider">Guest Information</div>
                    <div class="field-group">
                        <div class="field-row">
                            <div class="field">
                                <label>Reservation No.</label>
                                <input type="text" name="reservationNo" placeholder="e.g. RES-001" required>
                            </div>
                            <div class="field">
                                <label>Guest Name</label>
                                <input type="text" name="guestName" placeholder="Full name" required>
                            </div>
                        </div>
                        <div class="field">
                            <label>Address</label>
                            <input type="text" name="address" placeholder="Street, City, Country" required>
                        </div>
                        <div class="field">
                            <label>Contact Number</label>
                            <input type="text" name="contact" placeholder="+1 000 000 0000" required>
                        </div>
                    </div>

                    <!-- ROOM TYPE -->
                    <div class="form-divider">Room Type</div>
                    <div class="room-pills">
                        <div class="room-pill">
                            <input type="radio" id="standard" name="roomType" value="Standard" checked>
                            <label for="standard">
                                <span class="pill-icon">🛏️</span>
                                Standard
                                <span class="pill-price">$120/night</span>
                            </label>
                        </div>
                        <div class="room-pill">
                            <input type="radio" id="deluxe" name="roomType" value="Deluxe">
                            <label for="deluxe">
                                <span class="pill-icon">🌅</span>
                                Deluxe
                                <span class="pill-price">$220/night</span>
                            </label>
                        </div>
                        <div class="room-pill">
                            <input type="radio" id="suite" name="roomType" value="Suite">
                            <label for="suite">
                                <span class="pill-icon">👑</span>
                                Suite
                                <span class="pill-price">$380/night</span>
                            </label>
                        </div>
                    </div>

                    <!-- DATES -->
                    <div class="form-divider">Stay Dates</div>
                    <div class="field-group">
                        <div class="field-row">
                            <div class="field">
                                <label>Check-in Date</label>
                                <input type="date" name="checkin" required>
                            </div>
                            <div class="field">
                                <label>Check-out Date</label>
                                <input type="date" name="checkout" required>
                            </div>
                        </div>
                    </div>

                    <button type="submit"><span>✦ &nbsp;Save Reservation</span></button>

                </form>

            </div>
        </div>

    </div>

    <script>
        // Set min date for check-in to today
        var today = new Date().toISOString().split('T')[0];
        document.querySelector('input[name="checkin"]').min = today;

        // Auto-set checkout min to day after checkin
        document.querySelector('input[name="checkin"]').addEventListener('change', function() {
            var nextDay = new Date(this.value);
            nextDay.setDate(nextDay.getDate() + 1);
            document.querySelector('input[name="checkout"]').min = nextDay.toISOString().split('T')[0];
        });
    </script>

</body>
</html>
