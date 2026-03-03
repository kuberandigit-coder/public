<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Register.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | View Reservation</title>

    <!-- ── INSTANT LOAD ── -->
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80" fetchpriority="high">
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
            background: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80') center/cover no-repeat;
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

        /* ── PAGE WRAP ── */
        .page-wrap {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            padding-top: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-bottom: 40px;
            animation: pageIn 0.5s ease both;
        }

        @keyframes pageIn {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── MAIN CARD ── */
        .main-card {
            width: 100%;
            max-width: 560px;
            margin: 40px 20px;
        }

        /* ── PAGE HEADER ── */
        .page-header {
            text-align: center;
            margin-bottom: 28px;
        }
        .page-eyebrow {
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
            margin-bottom: 14px;
        }
        .page-header h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 38px;
            font-weight: 300;
            line-height: 1.1;
            margin-bottom: 8px;
        }
        .page-header h2 em {
            font-style: italic;
            color: var(--gold-light);
        }
        .page-header p {
            font-size: 13px;
            color: var(--text-dim);
        }

        /* ── SEARCH BOX ── */
        .form-box {
            background: rgba(4, 11, 24, 0.88);
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 24px;
            padding: 36px;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.7), 0 0 0 1px rgba(201,169,110,0.1);
        }

        .search-group {
            display: flex;
            gap: 10px;
            align-items: stretch;
        }

        input[type="text"] {
            flex: 1;
            padding: 13px 18px;
            background: rgba(3, 9, 20, 0.80);
            border: 1px solid rgba(255,255,255,0.22);
            border-radius: 12px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            outline: none;
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        input[type="text"]::placeholder { color: rgba(255,255,255,0.30); }
        input[type="text"]:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.15);
        }

        button {
            padding: 13px 22px;
            background: linear-gradient(135deg, #c9a96e, #e8c98a);
            border: none;
            border-radius: 12px;
            color: var(--deep-navy);
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
            white-space: nowrap;
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
        button span { position: relative; z-index: 1; }
        button:hover::before { opacity: 1; }
        button:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(201,169,110,0.4); }
        button:active { transform: translateY(0); }

        /* ── ERROR MESSAGE ── */
        .error-message {
            margin-top: 20px;
            padding: 14px 18px;
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            border-radius: 12px;
            color: #fca5a5;
            font-size: 14px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* ── RESERVATION DETAILS ── */
        .reservation-details {
            margin-top: 24px;
            background: rgba(3, 9, 20, 0.75);
            border: 1px solid rgba(201,169,110,0.25);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 16px 40px rgba(0,0,0,0.5);
            animation: slideUp 0.4s ease both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .details-header {
            background: linear-gradient(135deg, rgba(201,169,110,0.2), rgba(201,169,110,0.08));
            border-bottom: 1px solid rgba(201,169,110,0.2);
            padding: 20px 28px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .details-header-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: rgba(201,169,110,0.2);
            border: 1px solid rgba(201,169,110,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .details-header h3 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--gold-light);
        }

        .details-header p {
            font-size: 12px;
            color: var(--text-dim);
            margin-top: 2px;
        }

        .details-body {
            padding: 24px 28px;
            display: grid;
            gap: 0;
        }

        .detail-row {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            gap: 14px;
        }

        .detail-row:last-child { border-bottom: none; }

        .detail-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }

        .detail-text { flex: 1; }

        .detail-label {
            font-size: 10px;
            font-weight: 500;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-bottom: 2px;
        }

        .detail-value {
            font-size: 15px;
            font-weight: 500;
            color: white;
        }

        .detail-value.highlight {
            color: var(--gold-light);
            font-family: 'Cormorant Garamond', serif;
            font-size: 17px;
            font-weight: 600;
        }

        /* DATE ROW */
        .date-pair {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding: 16px 28px 20px;
            background: rgba(201,169,110,0.04);
            border-top: 1px solid rgba(255,255,255,0.06);
        }

        .date-box {
            background: rgba(3,9,20,0.6);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 12px;
            padding: 14px 16px;
            text-align: center;
        }

        .date-box .date-type {
            font-size: 10px;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--text-dim);
            margin-bottom: 6px;
        }

        .date-box .date-value {
            font-family: 'Cormorant Garamond', serif;
            font-size: 18px;
            font-weight: 600;
            color: white;
        }

        .date-box.checkin { border-color: rgba(14,116,144,0.4); }
        .date-box.checkout { border-color: rgba(201,169,110,0.4); }
        .date-box.checkin .date-type { color: #67e8f9; }
        .date-box.checkout .date-type { color: var(--gold-light); }

        /* ── GO BACK BTN ── */
        .go-back-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 20px;
            padding: 13px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 12px;
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            transition: all 0.3s;
        }
        .go-back-btn:hover {
            background: rgba(255,255,255,0.09);
            border-color: rgba(201,169,110,0.4);
            color: var(--gold-light);
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 600px) {
            .navbar { padding: 12px 20px; }
            .navbar h1 { font-size: 18px; }
            .search-group { flex-direction: column; }
            .form-box { padding: 24px; }
            .details-body, .date-pair { padding-left: 20px; padding-right: 20px; }
            .details-header { padding: 16px 20px; }
            .page-header h2 { font-size: 28px; }
        }
    </style>
</head>
<body>

    <div class="hero-bg"></div>

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
        <a href="home.jsp" class="nav-back">← Back to Dashboard</a>
    </div>

    <!-- ── PAGE ── -->
    <div class="page-wrap">
        <div class="main-card">

            <!-- Header -->
            <div class="page-header">
                <div class="page-eyebrow">✦ Booking Lookup</div>
                <h2>View <em>Reservation</em></h2>
                <p>Enter a reservation number to retrieve full guest & room details.</p>
            </div>

            <!-- Search Form -->
            <div class="form-box">
                <form action="ViewReservation" method="get">
                    <div class="search-group">
                        <input type="text" name="reservationNumber" placeholder="Enter Reservation Number (e.g. RES-001)" required>
                        <button type="submit"><span>🔍 Search</span></button>
                    </div>
                </form>

                <!-- ERROR -->
                <%
                    String errorMessage = (String) request.getAttribute("error");
                    if (errorMessage != null) {
                %>
                <div class="error-message">
                    ⚠ &nbsp;<%= errorMessage %>
                </div>
                <% } %>

                <!-- RESERVATION DETAILS -->
                <%
                    Reservation reservation = (Reservation) request.getAttribute("reservation");
                    if (reservation != null) {
                %>
                <div class="reservation-details">

                    <div class="details-header">
                        <div class="details-header-icon">📋</div>
                        <div>
                            <h3>Reservation Found</h3>
                            <p>All details for this booking are shown below</p>
                        </div>
                    </div>

                    <div class="details-body">

                        <div class="detail-row">
                            <div class="detail-icon">🔖</div>
                            <div class="detail-text">
                                <div class="detail-label">Reservation Number</div>
                                <div class="detail-value highlight"><%= reservation.getReservationNumber() %></div>
                            </div>
                        </div>

                        <div class="detail-row">
                            <div class="detail-icon">👤</div>
                            <div class="detail-text">
                                <div class="detail-label">Guest Name</div>
                                <div class="detail-value"><%= reservation.getGuestName() %></div>
                            </div>
                        </div>

                        <div class="detail-row">
                            <div class="detail-icon">📍</div>
                            <div class="detail-text">
                                <div class="detail-label">Address</div>
                                <div class="detail-value"><%= reservation.getAddress() %></div>
                            </div>
                        </div>

                        <div class="detail-row">
                            <div class="detail-icon">📞</div>
                            <div class="detail-text">
                                <div class="detail-label">Contact Number</div>
                                <div class="detail-value"><%= reservation.getContactNumber() %></div>
                            </div>
                        </div>

                        <div class="detail-row">
                            <div class="detail-icon">🛏️</div>
                            <div class="detail-text">
                                <div class="detail-label">Room Type</div>
                                <div class="detail-value highlight"><%= reservation.getRoomType() %></div>
                            </div>
                        </div>

                    </div>

                    <!-- DATE PAIR -->
                    <div class="date-pair">
                        <div class="date-box checkin">
                            <div class="date-type">✈ Check-in</div>
                            <div class="date-value"><%= reservation.getCheckInDate() %></div>
                        </div>
                        <div class="date-box checkout">
                            <div class="date-type">🏖 Check-out</div>
                            <div class="date-value"><%= reservation.getCheckOutDate() %></div>
                        </div>
                    </div>

                </div>
                <% } %>

                <!-- GO BACK -->
                <a href="home.jsp" class="go-back-btn">← Return to Dashboard</a>

            </div>
        </div>
    </div>

</body>
</html>
