<%-- 
    Document   : calculateBill.jsp
    Author     : Ocean View Resort
    For        : Guest / User usage
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Calculate Your Bill</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preload" as="image"
          href="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80"
          fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e;
            --gold-light: #e8c98a;
            --deep-navy: #050d1a;
            --teal: #0e7490;
            --glass: rgba(255,255,255,0.055);
            --glass-border: rgba(255,255,255,0.12);
            --text-dim: rgba(255,255,255,0.55);
        }

        * { margin:0; padding:0; box-sizing:border-box; }
        html { scroll-behavior:smooth; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--deep-navy);
            color: white;
            min-height: 100vh;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* ── BACKGROUND ── */
        .hero-bg {
            position: fixed; inset: 0; z-index: 0;
            background: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80')
                        center/cover no-repeat;
            will-change: transform; transform: translateZ(0); contain: strict;
        }
        .hero-bg::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg,
                rgba(5,13,26,0.97) 0%,
                rgba(5,13,26,0.85) 50%,
                rgba(5,13,26,0.97) 100%);
        }

        /* ── WAVES ── */
        .wave-container {
            position: fixed; bottom: 0; left: 0;
            width: 100%; height: 110px; z-index: 1;
            overflow: hidden; opacity: 0.13;
        }
        .wave {
            position: absolute; bottom: 0; left: -50%;
            width: 200%; height: 75px;
            background: linear-gradient(to right, transparent, var(--teal), transparent);
            border-radius: 50%;
            animation: wave 9s ease-in-out infinite;
        }
        .wave:nth-child(2) {
            height: 50px; opacity: 0.6;
            animation: wave 13s ease-in-out infinite reverse;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }
        @keyframes wave {
            0%,100% { transform: translateX(0) translateY(0); }
            50%      { transform: translateX(8%) translateY(-12px); }
        }

        /* ── PARTICLES ── */
        .particles { position: fixed; inset: 0; z-index: 2; pointer-events: none; overflow: hidden; }
        .particle {
            position: absolute; width: 2px; height: 2px; border-radius: 50%;
            background: var(--gold-light); opacity: 0;
            animation: floatUp var(--dur,15s) linear var(--delay,0s) infinite;
            left: var(--x,50%); bottom: -10px;
        }
        @keyframes floatUp {
            0%   { opacity: 0; transform: translateY(0); }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.15; }
            100% { opacity: 0; transform: translateY(-100vh); }
        }

        /* ── NAVBAR ── */
        .navbar {
            position: fixed; top: 0; width: 100%; z-index: 100;
            background: rgba(5,13,26,0.88);
            backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--glass-border);
            padding: 14px 40px;
            display: flex; justify-content: space-between; align-items: center;
            animation: pageIn 0.4s ease both;
        }
        .navbar-brand {
            font-family: 'Cormorant Garamond', serif;
            font-size: 22px; font-weight: 600; letter-spacing: 0.04em;
            display: flex; align-items: center; gap: 10px;
        }
        .wave-icon { display: inline-block; animation: sway 3s ease-in-out infinite; }
        @keyframes sway { 0%,100% { transform: rotate(-5deg); } 50% { transform: rotate(5deg); } }
        .nav-gold { color: var(--gold); }
        .nav-back {
            display: flex; align-items: center; gap: 8px;
            background: var(--glass); border: 1px solid var(--glass-border);
            color: var(--text-dim); padding: 8px 18px;
            border-radius: 100px; font-size: 13px;
            text-decoration: none; transition: all 0.3s;
        }
        .nav-back:hover { border-color: rgba(201,169,110,0.45); color: var(--gold-light); }

        /* ── PAGE WRAP ── */
        .page-wrap {
            position: relative; z-index: 10;
            min-height: 100vh; padding-top: 72px;
            display: flex; align-items: center; justify-content: center;
            padding-bottom: 60px;
            animation: pageIn 0.5s ease both;
        }
        @keyframes pageIn {
            from { opacity:0; transform: translateY(10px); }
            to   { opacity:1; transform: translateY(0); }
        }

        /* ── MAIN CARD ── */
        .main-card { width: 100%; max-width: 560px; margin: 40px 20px; }

        /* ── PAGE HEADER ── */
        .page-header { text-align: center; margin-bottom: 28px; }
        .page-eyebrow {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(201,169,110,0.13);
            border: 1px solid rgba(201,169,110,0.3);
            color: var(--gold-light); font-size: 11px;
            letter-spacing: 0.14em; text-transform: uppercase;
            padding: 4px 14px; border-radius: 100px; margin-bottom: 14px;
        }
        .page-header h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 40px; font-weight: 300; line-height: 1.1; margin-bottom: 8px;
        }
        .page-header h2 em { font-style: italic; color: var(--gold-light); }
        .page-header p { font-size: 13px; color: var(--text-dim); line-height: 1.6; }

        /* ── FORM BOX ── */
        .form-box {
            background: rgba(4,11,24,0.90);
            border: 1px solid rgba(255,255,255,0.13);
            border-radius: 24px; padding: 38px;
            backdrop-filter: blur(22px); -webkit-backdrop-filter: blur(22px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.7),
                        0 0 0 1px rgba(201,169,110,0.07);
        }

        /* ── FORM FIELDS ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1/-1; }

        .form-label {
            font-size: 10px; font-weight: 600;
            letter-spacing: 0.16em; text-transform: uppercase;
            color: var(--text-dim);
        }

        .form-input, .form-select {
            padding: 12px 14px;
            background: rgba(3,9,20,0.80);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 12px; color: white;
            font-family: 'DM Sans', sans-serif; font-size: 14px; outline: none;
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        .form-input:focus, .form-select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.13);
        }
        .form-input::placeholder { color: rgba(255,255,255,0.28); }
        .form-select { appearance: none; cursor: pointer; }
        .form-select option { background: #0a1628; }

        /* Room type card select */
        .room-cards { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .room-card {
            position: relative; cursor: pointer;
        }
        .room-card input[type="radio"] {
            position: absolute; opacity: 0; width: 0; height: 0;
        }
        .room-card-inner {
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 13px; padding: 13px 14px;
            background: rgba(3,9,20,0.70);
            transition: all 0.25s; cursor: pointer;
            display: flex; flex-direction: column; gap: 4px;
        }
        .room-card:hover .room-card-inner {
            border-color: rgba(201,169,110,0.35);
            background: rgba(201,169,110,0.06);
        }
        .room-card input:checked + .room-card-inner {
            border-color: var(--gold);
            background: rgba(201,169,110,0.12);
            box-shadow: 0 0 0 1px rgba(201,169,110,0.3);
        }
        .room-name {
            font-size: 13px; font-weight: 600; color: white;
        }
        .room-price {
            font-family: 'Cormorant Garamond', serif;
            font-size: 16px; font-weight: 700; color: var(--gold-light);
        }
        .room-price span { font-size: 11px; font-weight: 400; color: var(--text-dim); }
        .room-icon { font-size: 18px; margin-bottom: 2px; }

        /* Nights input with stepper */
        .nights-wrap { position: relative; }
        .nights-wrap input { padding-right: 80px; }
        .night-stepper {
            position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
            display: flex; gap: 4px;
        }
        .step-btn {
            width: 28px; height: 28px; border-radius: 8px;
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(255,255,255,0.15);
            color: white; font-size: 16px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.2s; line-height: 1;
        }
        .step-btn:hover { background: rgba(201,169,110,0.2); border-color: rgba(201,169,110,0.5); }

        /* Section divider */
        .section-divider {
            height: 1px; margin: 22px 0;
            background: linear-gradient(90deg, transparent, rgba(201,169,110,0.3), transparent);
        }
        .section-title {
            font-size: 10px; font-weight: 600; letter-spacing: 0.2em;
            text-transform: uppercase; color: var(--text-dim);
            margin-bottom: 14px; display: flex; align-items: center; gap: 10px;
        }
        .section-title::after { content:''; flex:1; height:1px; background: rgba(255,255,255,0.07); }

        /* ── BILL RESULT ── */
        .bill-result {
            display: none; margin-top: 24px;
            border: 1px solid rgba(201,169,110,0.3);
            border-radius: 18px; overflow: hidden;
            animation: slideUp 0.4s ease both;
        }
        @keyframes slideUp {
            from { opacity:0; transform: translateY(14px); }
            to   { opacity:1; transform: translateY(0); }
        }
        .bill-result.show { display: block; }

        .bill-result-header {
            background: linear-gradient(135deg, rgba(201,169,110,0.2), rgba(201,169,110,0.07));
            border-bottom: 1px solid rgba(201,169,110,0.2);
            padding: 20px 24px;
            text-align: center;
        }
        .bill-resort-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 22px; font-weight: 600; letter-spacing: 0.04em; margin-bottom: 3px;
        }
        .bill-resort-name span { color: var(--gold); }
        .bill-tagline {
            font-size: 11px; letter-spacing: 0.18em;
            text-transform: uppercase; color: var(--text-dim);
        }

        .bill-body { padding: 22px 24px; }

        .bill-info-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.055);
            font-size: 14px;
        }
        .bill-info-row:last-child { border-bottom: none; }
        .bill-info-label { color: var(--text-dim); display: flex; align-items: center; gap: 8px; }
        .bill-info-value { font-weight: 500; color: white; }
        .bill-info-value.accent { color: var(--gold-light); font-family: 'Cormorant Garamond', serif; font-size: 16px; font-weight: 600; }

        .bill-subtotal {
            margin-top: 4px; padding: 14px 0;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .bill-total-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 16px 20px; margin-top: 14px;
            background: linear-gradient(135deg, rgba(201,169,110,0.18), rgba(201,169,110,0.06));
            border: 1px solid rgba(201,169,110,0.35);
            border-radius: 14px;
        }
        .bill-total-label {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px; font-weight: 600;
        }
        .bill-total-value {
            font-family: 'Cormorant Garamond', serif;
            font-size: 34px; font-weight: 700; color: var(--gold-light);
        }

        /* ── BUTTONS ── */
        .btn-primary {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #c9a96e, #e8c98a);
            border: none; border-radius: 13px;
            color: var(--deep-navy); font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 700;
            letter-spacing: 0.06em; text-transform: uppercase;
            cursor: pointer; transition: all 0.3s; position: relative; overflow: hidden;
            margin-top: 22px;
        }
        .btn-primary::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, #e8c98a, #fff3cc);
            opacity: 0; transition: opacity 0.3s;
        }
        .btn-primary span { position: relative; z-index: 1; }
        .btn-primary:hover::before { opacity: 1; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(201,169,110,0.4); }
        .btn-primary:active { transform: translateY(0); }

        .btn-secondary {
            width: 100%; padding: 13px;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--glass-border);
            border-radius: 13px; color: var(--text-dim);
            font-family: 'DM Sans', sans-serif; font-size: 13px;
            cursor: pointer; transition: all 0.25s; margin-top: 10px;
            display: none;
        }
        .btn-secondary.show { display: block; }
        .btn-secondary:hover { background: rgba(255,255,255,0.09); color: white; border-color: rgba(201,169,110,0.3); }

        /* Print styles */
        @media print {
            body * { visibility: hidden; }
            .bill-result, .bill-result * { visibility: visible; }
            .bill-result {
                position: fixed; inset: 0;
                background: white; color: black;
                border: none; border-radius: 0;
                padding: 40px; display: block !important;
            }
            .bill-resort-name { color: black !important; }
            .bill-resort-name span { color: #8B6914 !important; }
            .bill-total-value, .bill-info-value.accent { color: #8B6914 !important; }
            .bill-info-label { color: #555 !important; }
            .bill-info-value { color: #111 !important; }
            .bill-total-row { background: #f9f5ef !important; border-color: #d4b483 !important; }
            .bill-result-header { background: #f4ede0 !important; border-color: #d4b483 !important; }
            .btn-secondary { display: none !important; }
        }

        /* Responsive */
        @media (max-width:580px) {
            .navbar { padding: 12px 20px; }
            .form-box { padding: 24px 20px; }
            .form-grid { grid-template-columns: 1fr; }
            .room-cards { grid-template-columns: 1fr 1fr; }
            .page-header h2 { font-size: 30px; }
        }
    </style>
</head>
<body>

<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

<!-- ── NAVBAR ── -->
<div class="navbar">
    <div class="navbar-brand">
        <span class="wave-icon">🌊</span>
        Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
    </div>
    <a href="home.jsp" class="nav-back">← Back to Dashboard</a>
</div>

<!-- ── PAGE ── -->
<div class="page-wrap">
    <div class="main-card">

        <!-- Header -->
        <div class="page-header">
            <div class="page-eyebrow">✦ Guest Services</div>
            <h2>Estimate Your <em>Bill</em></h2>
            <p>Select your room type and number of nights to get an instant cost breakdown.</p>
        </div>

        <!-- Form Box -->
        <div class="form-box">

            <!-- ROOM TYPE SELECTION -->
            <div class="section-title">Choose Room Type</div>
            <div class="room-cards" id="roomCards">

                <label class="room-card">
                    <input type="radio" name="roomTypeRadio" value="Standard" data-rate="5000" checked>
                    <div class="room-card-inner">
                        <div class="room-icon">🛏️</div>
                        <div class="room-name">Standard</div>
                        <div class="room-price">Rs 5,000 <span>/ night</span></div>
                    </div>
                </label>

                <label class="room-card">
                    <input type="radio" name="roomTypeRadio" value="Deluxe" data-rate="8000">
                    <div class="room-card-inner">
                        <div class="room-icon">🌟</div>
                        <div class="room-name">Deluxe</div>
                        <div class="room-price">Rs 8,000 <span>/ night</span></div>
                    </div>
                </label>

                <label class="room-card">
                    <input type="radio" name="roomTypeRadio" value="Family" data-rate="10000">
                    <div class="room-card-inner">
                        <div class="room-icon">👨‍👩‍👧</div>
                        <div class="room-name">Family</div>
                        <div class="room-price">Rs 10,000 <span>/ night</span></div>
                    </div>
                </label>

                <label class="room-card">
                    <input type="radio" name="roomTypeRadio" value="Ocean View" data-rate="14000">
                    <div class="room-card-inner">
                        <div class="room-icon">🌊</div>
                        <div class="room-name">Ocean View</div>
                        <div class="room-price">Rs 14,000 <span>/ night</span></div>
                    </div>
                </label>

                <label class="room-card" style="grid-column:1/-1;">
                    <input type="radio" name="roomTypeRadio" value="Suite" data-rate="18000">
                    <div class="room-card-inner" style="flex-direction:row; align-items:center; gap:14px;">
                        <div class="room-icon" style="font-size:22px;">👑</div>
                        <div>
                            <div class="room-name">Presidential Suite</div>
                            <div class="room-price">Rs 18,000 <span>/ night</span></div>
                        </div>
                    </div>
                </label>

            </div>

            <div class="section-divider"></div>

            <!-- NIGHTS + DATES -->
            <div class="section-title">Stay Duration</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Check-In Date</label>
                    <input class="form-input" type="date" id="checkIn"
                           onchange="syncNights()">
                </div>
                <div class="form-group">
                    <label class="form-label">Check-Out Date</label>
                    <input class="form-input" type="date" id="checkOut"
                           onchange="syncNights()">
                </div>
                <div class="form-group full">
                    <label class="form-label">Number of Nights</label>
                    <div class="nights-wrap">
                        <input class="form-input" type="number" id="nights"
                               placeholder="e.g. 3" min="1" value="1"
                               oninput="clearDates()">
                        <div class="night-stepper">
                            <button class="step-btn" type="button" onclick="stepNights(-1)">−</button>
                            <button class="step-btn" type="button" onclick="stepNights(1)">+</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="section-divider"></div>

            <!-- GUEST NAME (optional) -->
            <div class="section-title">Your Name <span style="color:rgba(255,255,255,0.22);font-size:9px;margin-left:4px;">(optional — appears on invoice)</span></div>
            <div class="form-group full">
                <input class="form-input" type="text" id="guestName"
                       placeholder="Enter your full name">
            </div>

            <!-- CALCULATE BUTTON -->
            <button class="btn-primary" type="button" onclick="calculateBill()">
                <span>🧾 Calculate My Bill</span>
            </button>

            <!-- ── BILL RESULT ── -->
            <div class="bill-result" id="billResult">
                <div class="bill-result-header">
                    <div class="bill-resort-name">🌊 Ocean <span>View</span> Resort</div>
                    <div class="bill-tagline">Official Guest Invoice</div>
                </div>

                <div class="bill-body">

                    <div class="bill-info-row">
                        <span class="bill-info-label">👤 Guest Name</span>
                        <span class="bill-info-value" id="res_guest">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">🏨 Room Type</span>
                        <span class="bill-info-value accent" id="res_room">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">💰 Rate Per Night</span>
                        <span class="bill-info-value" id="res_rate">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">🌙 Number of Nights</span>
                        <span class="bill-info-value" id="res_nights">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">📅 Check-In</span>
                        <span class="bill-info-value" id="res_checkin">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">📅 Check-Out</span>
                        <span class="bill-info-value" id="res_checkout">—</span>
                    </div>

                    <div class="section-divider" style="margin:14px 0;"></div>

                    <!-- CHARGES BREAKDOWN -->
                    <div class="bill-info-row">
                        <span class="bill-info-label">🛏️ Room Charges</span>
                        <span class="bill-info-value" id="res_roomCharge">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">🧹 Service & Housekeeping <small style="color:rgba(255,255,255,0.3)">(10%)</small></span>
                        <span class="bill-info-value" id="res_service">—</span>
                    </div>
                    <div class="bill-info-row">
                        <span class="bill-info-label">🏛️ Government Tax <small style="color:rgba(255,255,255,0.3)">(8%)</small></span>
                        <span class="bill-info-value" id="res_tax">—</span>
                    </div>

                    <div class="bill-total-row">
                        <span class="bill-total-label">Total Amount Due</span>
                        <span class="bill-total-value" id="res_total">Rs 0.00</span>
                    </div>

                    <p style="text-align:center;font-size:11px;color:rgba(255,255,255,0.3);margin-top:14px;letter-spacing:0.06em;">
                        Thank you for choosing Ocean View Resort 🌊
                    </p>
                </div>
            </div>

            <!-- PRINT & RECALCULATE BUTTONS -->
            <button class="btn-secondary" id="btnPrint" onclick="window.print()">
                🖨️ Print Invoice
            </button>
            <button class="btn-secondary" id="btnReset" onclick="resetForm()">
                ↺ Recalculate
            </button>

        </div><!-- /form-box -->
    </div>
</div>

<script>
    // Particles
    var pc = document.getElementById("particles");
    for (var i = 0; i < 14; i++) {
        var p = document.createElement("div");
        p.className = "particle";
        p.style.cssText =
            "--x:"   + Math.random() * 100 + "%;" +
            "--dur:"  + (12 + Math.random() * 14)  + "s;" +
            "--delay:"+ (Math.random() * 12)        + "s";
        pc.appendChild(p);
    }

    // Set min date on check-in to today
    var today = new Date().toISOString().split("T")[0];
    document.getElementById("checkIn").min  = today;
    document.getElementById("checkOut").min = today;

    // Sync nights from date pickers
    function syncNights() {
        var ci = document.getElementById("checkIn").value;
        var co = document.getElementById("checkOut").value;
        if (ci && co) {
            var diff = (new Date(co) - new Date(ci)) / 86400000;
            if (diff > 0) {
                document.getElementById("nights").value = Math.round(diff);
            } else {
                document.getElementById("checkOut").value = "";
                alert("Check-out must be after check-in.");
            }
        }
    }

    // Clear date pickers if nights typed manually
    function clearDates() {
        document.getElementById("checkIn").value  = "";
        document.getElementById("checkOut").value = "";
    }

    // Stepper buttons
    function stepNights(dir) {
        var inp = document.getElementById("nights");
        var val = parseInt(inp.value) || 1;
        val = Math.max(1, val + dir);
        inp.value = val;
        clearDates();
    }

    // Format number as Rs
    function fmt(n) {
        return "Rs " + n.toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    // Main calculate
    function calculateBill() {
        // Get selected room
        var selected = document.querySelector('input[name="roomTypeRadio"]:checked');
        if (!selected) { alert("Please select a room type."); return; }

        var roomType = selected.value;
        var rate     = parseFloat(selected.getAttribute("data-rate")) || 0;

        var nights   = parseInt(document.getElementById("nights").value) || 0;
        if (nights < 1) { alert("Please enter at least 1 night."); return; }

        var guest    = document.getElementById("guestName").value.trim() || "Valued Guest";
        var checkIn  = document.getElementById("checkIn").value  || "—";
        var checkOut = document.getElementById("checkOut").value || "—";

        // Calculations
        var roomCharge = rate * nights;
        var service    = roomCharge * 0.10;
        var tax        = roomCharge * 0.08;
        var total      = roomCharge + service + tax;

        // Populate result
        document.getElementById("res_guest").textContent     = guest;
        document.getElementById("res_room").textContent      = roomType;
        document.getElementById("res_rate").textContent      = fmt(rate) + " / night";
        document.getElementById("res_nights").textContent    = nights + (nights === 1 ? " night" : " nights");
        document.getElementById("res_checkin").textContent   = checkIn  !== "—" ? formatDate(checkIn)  : "—";
        document.getElementById("res_checkout").textContent  = checkOut !== "—" ? formatDate(checkOut) : "—";
        document.getElementById("res_roomCharge").textContent = fmt(roomCharge);
        document.getElementById("res_service").textContent   = fmt(service);
        document.getElementById("res_tax").textContent       = fmt(tax);
        document.getElementById("res_total").textContent     = fmt(total);

        // Show result
        var br = document.getElementById("billResult");
        br.classList.add("show");
        document.getElementById("btnPrint").classList.add("show");
        document.getElementById("btnReset").classList.add("show");

        // Smooth scroll to result
        setTimeout(function() {
            br.scrollIntoView({ behavior: "smooth", block: "nearest" });
        }, 100);
    }

    // Format yyyy-mm-dd → nice label
    function formatDate(d) {
        if (!d || d === "—") return "—";
        var parts = d.split("-");
        var months = ["Jan","Feb","Mar","Apr","May","Jun",
                      "Jul","Aug","Sep","Oct","Nov","Dec"];
        return parts[2] + " " + months[parseInt(parts[1])-1] + " " + parts[0];
    }

    // Reset
    function resetForm() {
        document.getElementById("billResult").classList.remove("show");
        document.getElementById("btnPrint").classList.remove("show");
        document.getElementById("btnReset").classList.remove("show");
        document.getElementById("nights").value    = 1;
        document.getElementById("checkIn").value   = "";
        document.getElementById("checkOut").value  = "";
        document.getElementById("guestName").value = "";
        var first = document.querySelector('input[name="roomTypeRadio"]');
        if (first) first.checked = true;
        window.scrollTo({ top: 0, behavior: "smooth" });
    }
</script>

</body>
</html>
