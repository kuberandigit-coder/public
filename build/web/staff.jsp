<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // ── Session guard ──────────────────────────────────────────
    String staffName = (String) session.getAttribute("staff");
    if (staffName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ── DB config ──────────────────────────────────────────────
    String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    String DB_USER = "root";
    String DB_PASS = "";

    // ── Search param ───────────────────────────────────────────
    String searchNo = request.getParameter("search");
    if (searchNo == null) searchNo = "";

    // ── Data containers ────────────────────────────────────────
    java.util.List<java.util.Map<String,String>> reservations = new java.util.ArrayList<>();
    int totalBookings = 0;

    // ── Rate map by room type ──────────────────────────────────
    java.util.Map<String,Integer> rateMap = new java.util.LinkedHashMap<>();
    rateMap.put("standard", 80);
    rateMap.put("deluxe",  150);
    rateMap.put("suite",   250);
    rateMap.put("family",  180);
    rateMap.put("ocean",   220);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        // Total count
        PreparedStatement stTotal = conn.prepareStatement("SELECT COUNT(*) FROM reservations");
        ResultSet rsTotal = stTotal.executeQuery();
        if (rsTotal.next()) totalBookings = rsTotal.getInt(1);
        rsTotal.close(); stTotal.close();

        // Fetch rows — filtered by reservation_no when search is provided
        PreparedStatement ps;
        if (!searchNo.trim().isEmpty()) {
            ps = conn.prepareStatement(
                "SELECT reservation_no, guest_name, address, contact, room_type, checkin_date, checkout_date " +
                "FROM reservations WHERE reservation_no LIKE ? ORDER BY checkin_date DESC"
            );
            ps.setString(1, "%" + searchNo.trim() + "%");
        } else {
            ps = conn.prepareStatement(
                "SELECT reservation_no, guest_name, address, contact, room_type, checkin_date, checkout_date " +
                "FROM reservations ORDER BY checkin_date DESC"
            );
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            java.util.Map<String,String> row = new java.util.LinkedHashMap<>();
            row.put("reservation_no", rs.getString("reservation_no"));
            row.put("guest_name",     rs.getString("guest_name"));
            row.put("address",        rs.getString("address"));
            row.put("contact",        rs.getString("contact"));
            row.put("room_type",      rs.getString("room_type"));
            row.put("checkin_date",   rs.getString("checkin_date"));
            row.put("checkout_date",  rs.getString("checkout_date"));
            reservations.add(row);
        }
        rs.close(); ps.close(); conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Staff Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        :root {
            --gold: #c9a96e; --gold-light: #e8c98a;
            --deep-navy: #050d1a; --teal: #0e7490; --emerald: #10b981;
            --glass: rgba(255,255,255,0.06);
            --glass-border: rgba(255,255,255,0.11);
            --text-dim: rgba(255,255,255,0.55);
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        html { scroll-behavior:smooth; }
        body {
            font-family:'DM Sans',sans-serif;
            background:var(--deep-navy); color:white;
            min-height:100vh; overflow-x:hidden;
            -webkit-font-smoothing:antialiased;
        }

        .hero-bg {
            position:fixed; inset:0; z-index:0;
            background:url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80') center/cover no-repeat;
            will-change:transform; transform:translateZ(0); contain:strict;
        }
        .hero-bg::before {
            content:''; position:absolute; inset:0;
            background:linear-gradient(180deg,rgba(5,13,26,0.88) 0%,rgba(5,13,26,0.72) 40%,rgba(5,13,26,0.96) 100%);
        }

        .wave-container { position:fixed; bottom:0; left:0; width:100%; height:110px; z-index:1; overflow:hidden; opacity:0.14; }
        .wave { position:absolute; bottom:0; left:-50%; width:200%; height:75px; background:linear-gradient(to right,transparent,var(--teal),transparent); border-radius:50%; animation:wave 9s ease-in-out infinite; }
        .wave:nth-child(2) { height:55px; opacity:0.6; animation:wave 13s ease-in-out infinite reverse; background:linear-gradient(to right,transparent,var(--gold),transparent); }
        @keyframes wave { 0%,100%{transform:translateX(0) translateY(0);} 50%{transform:translateX(8%) translateY(-12px);} }

        .particles { position:fixed; inset:0; z-index:2; pointer-events:none; overflow:hidden; }
        .particle { position:absolute; width:2px; height:2px; border-radius:50%; background:var(--gold-light); opacity:0; animation:floatUp var(--dur,15s) linear var(--delay,0s) infinite; left:var(--x,50%); bottom:-10px; }
        @keyframes floatUp { 0%{opacity:0;transform:translateY(0);} 10%{opacity:0.4;} 90%{opacity:0.2;} 100%{opacity:0;transform:translateY(-100vh);} }

        /* NAVBAR */
        .navbar { position:fixed; top:0; width:100%; z-index:100; background:rgba(5,13,26,0.92); backdrop-filter:blur(14px); border-bottom:1px solid var(--glass-border); padding:14px 40px; display:flex; justify-content:space-between; align-items:center; animation:pageIn 0.4s ease both; }
        .navbar h1 { font-family:'Cormorant Garamond',serif; font-size:23px; font-weight:600; letter-spacing:0.04em; display:flex; align-items:center; gap:10px; }
        .wave-icon { font-size:19px; animation:sway 3s ease-in-out infinite; display:inline-block; }
        @keyframes sway { 0%,100%{transform:rotate(-5deg);} 50%{transform:rotate(5deg);} }
        .nav-gold { color:var(--gold); }
        .staff-badge { background:linear-gradient(135deg,rgba(16,185,129,0.3),rgba(16,185,129,0.1)); border:1px solid rgba(16,185,129,0.5); color:#6ee7b7; font-size:10px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase; padding:4px 10px; border-radius:100px; margin-left:4px; }
        .navbar-right { display:flex; align-items:center; gap:14px; }
        .user-badge { display:flex; align-items:center; gap:10px; background:var(--glass); border:1px solid var(--glass-border); padding:7px 16px 7px 10px; border-radius:100px; font-size:13px; font-weight:500; }
        .user-avatar { width:30px; height:30px; border-radius:50%; background:linear-gradient(135deg,var(--emerald),var(--teal)); display:flex; align-items:center; justify-content:center; font-size:13px; font-weight:700; text-transform:uppercase; }
        .logout-btn { background:rgba(255,59,48,0.18); border:1px solid rgba(255,59,48,0.4); color:white; padding:7px 16px; border-radius:100px; font-size:13px; text-decoration:none; transition:all 0.3s; }
        .logout-btn:hover { background:rgba(255,59,48,0.38); color:#ff6b6b; }

        /* MAIN */
        .container { position:relative; z-index:10; padding:120px 40px 80px; max-width:1380px; margin:0 auto; animation:pageIn 0.5s ease both; }
        @keyframes pageIn { from{opacity:0;transform:translateY(8px);} to{opacity:1;transform:translateY(0);} }

        .page-header { display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:16px; margin-bottom:32px; }
        .page-eyebrow { font-size:11px; font-weight:500; letter-spacing:0.25em; text-transform:uppercase; color:var(--gold); margin-bottom:10px; display:flex; align-items:center; gap:10px; }
        .page-eyebrow::before { content:''; width:28px; height:1px; background:var(--gold); }
        .page-header h2 { font-family:'Cormorant Garamond',serif; font-size:44px; font-weight:300; line-height:1.1; }
        .page-header h2 em { font-style:italic; color:var(--gold-light); }

        /* KPI */
        .kpi-strip { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:32px; }
        .kpi-card { background:var(--glass); border:1px solid var(--glass-border); border-radius:16px; padding:20px 22px; position:relative; overflow:hidden; transition:transform 0.3s,border-color 0.3s; }
        .kpi-card::before { content:''; position:absolute; top:0; left:0; right:0; height:2px; background:linear-gradient(90deg,transparent,var(--gold),transparent); opacity:0.5; }
        .kpi-card:hover { transform:translateY(-3px); border-color:rgba(201,169,110,0.3); }
        .kpi-top { display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; }
        .kpi-icon { font-size:22px; }
        .kpi-badge { font-size:10px; font-weight:600; letter-spacing:0.08em; padding:3px 8px; border-radius:100px; }
        .badge-gold  { background:rgba(201,169,110,0.2); border:1px solid rgba(201,169,110,0.4); color:var(--gold-light); }
        .badge-teal  { background:rgba(14,116,144,0.2);  border:1px solid rgba(14,116,144,0.35); color:#67e8f9; }
        .badge-green { background:rgba(16,185,129,0.2);  border:1px solid rgba(16,185,129,0.3);  color:#6ee7b7; }
        .kpi-num { font-family:'Cormorant Garamond',serif; font-size:38px; font-weight:700; color:var(--gold-light); line-height:1; margin-bottom:4px; }
        .kpi-label { font-size:11px; letter-spacing:0.1em; text-transform:uppercase; color:var(--text-dim); }

        .section-label { font-size:10px; letter-spacing:0.3em; text-transform:uppercase; color:var(--text-dim); margin-bottom:16px; display:flex; align-items:center; gap:14px; }
        .section-label::after { content:''; flex:1; height:1px; background:var(--glass-border); }

        /* SEARCH */
        .search-form { display:flex; gap:10px; margin-bottom:16px; flex-wrap:wrap; align-items:center; }
        .search-wrapper { position:relative; flex:1; max-width:420px; }
        .search-icon { position:absolute; left:14px; top:50%; transform:translateY(-50%); font-size:15px; color:var(--text-dim); pointer-events:none; }
        .search-wrapper input { width:100%; padding:11px 14px 11px 42px; background:rgba(3,9,20,0.78); border:1px solid var(--glass-border); border-radius:12px; color:white; font-family:'DM Sans',sans-serif; font-size:13px; outline:none; transition:border-color 0.25s,box-shadow 0.25s; }
        .search-wrapper input:focus { border-color:var(--gold); box-shadow:0 0 0 3px rgba(201,169,110,0.12); }
        .search-wrapper input::placeholder { color:var(--text-dim); }
        .btn-search { padding:11px 26px; border-radius:12px; border:none; background:linear-gradient(135deg,#c9a96e,#e8c98a); color:var(--deep-navy); font-family:'DM Sans',sans-serif; font-size:13px; font-weight:700; letter-spacing:0.05em; cursor:pointer; transition:all 0.3s; }
        .btn-search:hover { transform:translateY(-2px); box-shadow:0 6px 20px rgba(201,169,110,0.4); }
        .btn-reset { padding:11px 18px; border-radius:12px; background:rgba(255,255,255,0.05); border:1px solid var(--glass-border); color:var(--text-dim); font-family:'DM Sans',sans-serif; font-size:13px; cursor:pointer; transition:all 0.2s; text-decoration:none; display:inline-flex; align-items:center; }
        .btn-reset:hover { background:rgba(255,255,255,0.1); color:white; }

        .search-banner { background:linear-gradient(135deg,rgba(201,169,110,0.15),rgba(201,169,110,0.06)); border:1px solid rgba(201,169,110,0.3); border-radius:12px; padding:11px 18px; font-size:13px; color:var(--gold-light); margin-bottom:16px; display:flex; align-items:center; gap:10px; }

        /* TABLE */
        .table-wrap { background:var(--glass); border:1px solid var(--glass-border); border-radius:20px; overflow:hidden; margin-bottom:28px; overflow-x:auto; }
        table { width:100%; border-collapse:collapse; min-width:860px; }
        thead tr { background:rgba(255,255,255,0.04); border-bottom:1px solid var(--glass-border); }
        th { padding:14px 16px; text-align:left; font-size:10px; font-weight:600; letter-spacing:0.18em; text-transform:uppercase; color:var(--text-dim); white-space:nowrap; }
        tbody tr { border-bottom:1px solid rgba(255,255,255,0.05); transition:background 0.2s; }
        tbody tr:last-child { border-bottom:none; }
        tbody tr:hover { background:rgba(201,169,110,0.06); }
        td { padding:13px 16px; font-size:13px; vertical-align:middle; }

        .res-no { font-family:'Cormorant Garamond',serif; font-size:16px; font-weight:700; color:var(--gold-light); letter-spacing:0.06em; }
        .guest-name { font-weight:500; color:white; }
        .address-cell { font-size:12px; color:var(--text-dim); }
        .contact-cell { font-size:12px; color:#67e8f9; white-space:nowrap; }
        .room-badge { display:inline-flex; align-items:center; background:rgba(14,116,144,0.18); border:1px solid rgba(14,116,144,0.3); color:#67e8f9; padding:3px 10px; border-radius:100px; font-size:11px; font-weight:600; white-space:nowrap; }
        .date-cell { font-size:12px; color:var(--text-dim); white-space:nowrap; }

        .btn-sm { padding:7px 14px; border-radius:9px; font-family:'DM Sans',sans-serif; font-size:11px; font-weight:700; cursor:pointer; border:none; transition:all 0.2s; letter-spacing:0.04em; white-space:nowrap; }
        .btn-bill { background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1)); border:1px solid rgba(201,169,110,0.45); color:var(--gold-light); }
        .btn-bill:hover { background:linear-gradient(135deg,rgba(201,169,110,0.5),rgba(201,169,110,0.25)); transform:translateY(-1px); box-shadow:0 4px 14px rgba(201,169,110,0.25); }

        .empty-state { text-align:center; padding:60px 20px; color:var(--text-dim); }
        .empty-state .empty-icon { font-size:42px; margin-bottom:12px; opacity:0.5; }
        .empty-state p { font-size:14px; }

        /* BILL MODAL */
        .modal-overlay { position:fixed; inset:0; z-index:200; background:rgba(5,13,26,0.88); backdrop-filter:blur(10px); display:none; align-items:center; justify-content:center; padding:20px; }
        .modal-overlay.open { display:flex; }
        .modal { background:linear-gradient(145deg,rgba(10,22,40,0.99),rgba(5,13,26,0.99)); border:1px solid rgba(201,169,110,0.28); border-radius:24px; padding:40px; width:100%; max-width:560px; box-shadow:0 40px 100px rgba(0,0,0,0.8); position:relative; animation:slideUp 0.3s cubic-bezier(0.25,0.46,0.45,0.94); }
        @keyframes slideUp { from{opacity:0;transform:translateY(22px);} to{opacity:1;transform:translateY(0);} }
        .modal-close { position:absolute; top:18px; right:20px; background:rgba(255,255,255,0.06); border:1px solid var(--glass-border); color:var(--text-dim); width:32px; height:32px; border-radius:50%; cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:16px; transition:all 0.2s; }
        .modal-close:hover { background:rgba(255,59,48,0.25); border-color:rgba(255,59,48,0.4); color:#ff6b6b; }

        .bill-header { text-align:center; margin-bottom:22px; }
        .bill-resort-name { font-family:'Cormorant Garamond',serif; font-size:26px; font-weight:600; letter-spacing:0.04em; margin-bottom:4px; }
        .bill-resort-name span { color:var(--gold); }
        .bill-subtitle { font-size:11px; letter-spacing:0.2em; text-transform:uppercase; color:var(--text-dim); }
        .bill-ref { font-size:12px; letter-spacing:0.12em; color:var(--gold-light); margin-top:8px; font-weight:600; }
        .bill-divider { height:1px; margin:18px 0; background:linear-gradient(90deg,transparent,var(--gold),transparent); opacity:0.35; }

        .bill-info-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:20px; }
        .bill-info-item { background:rgba(255,255,255,0.04); border:1px solid var(--glass-border); border-radius:10px; padding:11px 14px; }
        .bill-info-label { font-size:10px; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-dim); margin-bottom:4px; }
        .bill-info-value { font-size:13px; font-weight:500; color:white; }

        .bill-items { margin-bottom:16px; }
        .bill-item { display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid rgba(255,255,255,0.06); font-size:13px; }
        .bill-item:last-child { border-bottom:none; }
        .bill-item-label { color:var(--text-dim); }
        .bill-item-value { font-weight:500; color:white; }

        .bill-total { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-radius:14px; background:linear-gradient(135deg,rgba(201,169,110,0.2),rgba(201,169,110,0.08)); border:1px solid rgba(201,169,110,0.35); margin-top:12px; }
        .bill-total-label { font-family:'Cormorant Garamond',serif; font-size:20px; font-weight:600; }
        .bill-total-value { font-family:'Cormorant Garamond',serif; font-size:32px; font-weight:700; color:var(--gold-light); }

        .bill-actions { display:flex; gap:10px; margin-top:20px; }
        .btn-print { flex:1; padding:13px; border:none; border-radius:12px; background:linear-gradient(135deg,#c9a96e,#e8c98a); color:var(--deep-navy); font-family:'DM Sans',sans-serif; font-size:13px; font-weight:700; letter-spacing:0.06em; text-transform:uppercase; cursor:pointer; transition:all 0.3s; }
        .btn-print:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(201,169,110,0.4); }
        .btn-close-bill { padding:13px 20px; border-radius:12px; background:rgba(255,255,255,0.05); border:1px solid var(--glass-border); color:var(--text-dim); font-family:'DM Sans',sans-serif; font-size:13px; cursor:pointer; transition:all 0.2s; }
        .btn-close-bill:hover { background:rgba(255,255,255,0.1); color:white; }

        /* PRINT */
        @media print {
            body * { visibility:hidden; }
            .modal, .modal * { visibility:visible; }
            .modal { position:fixed; inset:0; border:none; box-shadow:none; background:white; color:black; padding:36px; border-radius:0; max-width:100%; }
            .modal-close, .bill-actions { display:none !important; }
            .bill-resort-name { color:black !important; }
            .bill-resort-name span, .bill-total-value, .bill-ref { color:#8B6914 !important; }
            .bill-info-item, .bill-total { background:#f9f5ef !important; border-color:#d4b483 !important; }
            .bill-info-label, .bill-item-label, .bill-subtitle { color:#666 !important; }
            .bill-info-value, .bill-item-value, .bill-total-label { color:#111 !important; }
        }

        .footer { text-align:center; margin-top:60px; font-size:12px; color:var(--text-dim); letter-spacing:0.08em; }
        .footer::before { content:''; display:block; width:50px; height:1px; background:var(--gold); margin:0 auto 14px; }

        @media(max-width:1024px){ .kpi-strip{grid-template-columns:1fr 1fr 1fr;} }
        @media(max-width:768px){ .container{padding:110px 18px 60px;} .navbar{padding:12px 18px;} .kpi-strip{grid-template-columns:1fr 1fr;} .page-header h2{font-size:32px;} .bill-info-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>

<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

<!-- NAVBAR -->
<div class="navbar">
    <h1>
        <span class="wave-icon">🌊</span>
        Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        <span class="staff-badge">Staff</span>
    </h1>
    <div class="navbar-right">
        <div class="user-badge">
            <div class="user-avatar" id="avatarInitial">S</div>
            <span>Staff, <strong><%= staffName %></strong></span>
        </div>
        <a href="logout" class="logout-btn">↩ Logout</a>
    </div>
</div>

<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div>
            <div class="page-eyebrow">Staff Operations Panel</div>
            <h2>Booking <em>Management</em></h2>
        </div>
    </div>

    <!-- KPI STRIP -->
    <div class="kpi-strip">
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">📋</span><span class="kpi-badge badge-gold">TOTAL</span></div>
            <div class="kpi-num"><%= totalBookings %></div>
            <div class="kpi-label">Total Reservations</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🔍</span><span class="kpi-badge badge-teal">RESULTS</span></div>
            <div class="kpi-num"><%= reservations.size() %></div>
            <div class="kpi-label"><%= searchNo.isEmpty() ? "Showing All" : "Search Results" %></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🧾</span><span class="kpi-badge badge-green">READY</span></div>
            <div class="kpi-num"><%= reservations.size() %></div>
            <div class="kpi-label">Bills Available</div>
        </div>
    </div>

    <!-- SECTION LABEL -->
    <div class="section-label">Reservations</div>

    <!-- SEARCH FORM -->
    <form class="search-form" method="GET" action="staffDashboard.jsp">
        <div class="search-wrapper">
            <span class="search-icon">🔍</span>
            <input type="text" name="search" id="searchInput"
                   placeholder="Search by Reservation No  (e.g. RES-002)"
                   value="<%= searchNo %>"/>
        </div>
        <button type="submit" class="btn-search">🔎 Search</button>
        <% if (!searchNo.isEmpty()) { %>
        <a href="staffDashboard.jsp" class="btn-reset">✕ Clear</a>
        <% } %>
    </form>

    <!-- RESULT BANNER -->
    <% if (!searchNo.isEmpty()) { %>
    <div class="search-banner">
        🔎 &nbsp;Results for &nbsp;<strong>"<%= searchNo %>"</strong>
        &nbsp;— &nbsp;<%= reservations.size() %> record(s) found
    </div>
    <% } %>

    <!-- TABLE -->
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Reservation No</th>
                    <th>Guest Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>Room Type</th>
                    <th>Check-In Date</th>
                    <th>Check-Out Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
            if (reservations.isEmpty()) {
            %>
                <tr><td colspan="8">
                    <div class="empty-state">
                        <div class="empty-icon"><%= searchNo.isEmpty() ? "🏖️" : "🔍" %></div>
                        <p><%= searchNo.isEmpty()
                            ? "No reservations found in the system."
                            : "No reservation found matching &quot;" + searchNo + "&quot;." %></p>
                    </div>
                </td></tr>
            <%
            } else {
                for (java.util.Map<String,String> r : reservations) {
                    String resNo    = r.get("reservation_no") != null ? r.get("reservation_no") : "—";
                    String guest    = r.get("guest_name")     != null ? r.get("guest_name")     : "—";
                    String address  = r.get("address")        != null ? r.get("address")        : "—";
                    String contact  = r.get("contact")        != null ? r.get("contact")        : "—";
                    String roomType = r.get("room_type")      != null ? r.get("room_type")      : "—";
                    String checkIn  = r.get("checkin_date")   != null ? r.get("checkin_date")   : "—";
                    String checkOut = r.get("checkout_date")  != null ? r.get("checkout_date")  : "—";

                    // Match rate from rateMap
                    int rate = 80;
                    String rtKey = roomType.toLowerCase().trim();
                    for (java.util.Map.Entry<String,Integer> e : rateMap.entrySet()) {
                        if (rtKey.contains(e.getKey())) { rate = e.getValue(); break; }
                    }
            %>
                <tr>
                    <td><span class="res-no"><%= resNo %></span></td>
                    <td><span class="guest-name"><%= guest %></span></td>
                    <td><span class="address-cell"><%= address %></span></td>
                    <td><span class="contact-cell">📞 <%= contact %></span></td>
                    <td><span class="room-badge">🏨 <%= roomType %></span></td>
                    <td class="date-cell">📅 <%= checkIn %></td>
                    <td class="date-cell">📅 <%= checkOut %></td>
                    <td>
                        <button class="btn-sm btn-bill" onclick="openBill(
                            '<%= resNo %>',
                            '<%= guest.replace("'","\\'") %>',
                            '<%= address.replace("'","\\'") %>',
                            '<%= contact %>',
                            '<%= roomType %>',
                            '<%= checkIn %>',
                            '<%= checkOut %>',
                            '<%= rate %>'
                        )">🧾 Calculate Bill</button>
                    </td>
                </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>

    <div class="footer">
        © 2026 Ocean View Resort &nbsp;·&nbsp; Staff Operations &nbsp;·&nbsp; All rights reserved
    </div>
</div>

<!-- BILL MODAL -->
<div class="modal-overlay" id="billModal">
    <div class="modal">
        <button class="modal-close" onclick="closeBill()">✕</button>

        <div class="bill-header">
            <div class="bill-resort-name">🌊 Ocean <span>View</span> Resort</div>
            <div class="bill-subtitle">Official Guest Invoice</div>
            <div class="bill-ref" id="billRef">—</div>
        </div>

        <div class="bill-divider"></div>

        <div class="bill-info-grid">
            <div class="bill-info-item"><div class="bill-info-label">Guest Name</div><div class="bill-info-value" id="billGuest">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Contact No</div><div class="bill-info-value" id="billContact">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Address</div><div class="bill-info-value" id="billAddress">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Room Type</div><div class="bill-info-value" id="billRoomType">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-In Date</div><div class="bill-info-value" id="billCheckIn">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-Out Date</div><div class="bill-info-value" id="billCheckOut">—</div></div>
        </div>

        <div class="bill-divider"></div>

        <div class="bill-items">
            <div class="bill-item"><span class="bill-item-label">🌙 Number of Nights</span><span class="bill-item-value" id="billNights">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🛏️ Rate Per Night</span><span class="bill-item-value" id="billRate">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🏨 Room Charges</span><span class="bill-item-value" id="billRoomCharge">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🧹 Service & Housekeeping (10%)</span><span class="bill-item-value" id="billService">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🏛️ Tax (8%)</span><span class="bill-item-value" id="billTax">—</span></div>
        </div>

        <div class="bill-total">
            <span class="bill-total-label">Total Amount Due</span>
            <span class="bill-total-value" id="billTotal">$0.00</span>
        </div>

        <div class="bill-actions">
            <button class="btn-print" onclick="window.print()">🖨️ Print Invoice</button>
            <button class="btn-close-bill" onclick="closeBill()">Close</button>
        </div>
    </div>
</div>

<script>
    // Avatar initial
    var sn = "<%= staffName %>";
    document.getElementById("avatarInitial").textContent = sn ? sn.charAt(0).toUpperCase() : "S";

    // Particles
    var pc = document.getElementById("particles");
    for (var i = 0; i < 16; i++) {
        var p = document.createElement("div");
        p.className = "particle";
        p.style.cssText = "--x:"+Math.random()*100+"%;--dur:"+(12+Math.random()*14)+"s;--delay:"+(Math.random()*12)+"s";
        pc.appendChild(p);
    }

    // Navbar scroll
    var ticking = false;
    window.addEventListener("scroll", function(){
        if (!ticking) {
            requestAnimationFrame(function(){
                document.querySelector(".navbar").style.background =
                    window.scrollY > 50 ? "rgba(5,13,26,0.98)" : "rgba(5,13,26,0.92)";
                ticking = false;
            });
            ticking = true;
        }
    }, {passive:true});

    // ── Bill Modal ──
    function openBill(resNo, guest, address, contact, roomType, checkIn, checkOut, rate) {
        document.getElementById("billRef").textContent      = "Reservation No: " + resNo;
        document.getElementById("billGuest").textContent    = guest;
        document.getElementById("billContact").textContent  = contact;
        document.getElementById("billAddress").textContent  = address;
        document.getElementById("billRoomType").textContent = roomType;
        document.getElementById("billCheckIn").textContent  = checkIn;
        document.getElementById("billCheckOut").textContent = checkOut;

        var rateNum = parseFloat(rate) || 0;
        document.getElementById("billRate").textContent = "$" + rateNum.toFixed(2) + " / night";

        var nights = 0;
        if (checkIn && checkOut && checkIn !== "—" && checkOut !== "—") {
            var diff = new Date(checkOut) - new Date(checkIn);
            if (diff > 0) nights = Math.round(diff / 86400000);
        }

        var roomCharge = rateNum * nights;
        var service    = roomCharge * 0.10;
        var tax        = roomCharge * 0.08;
        var total      = roomCharge + service + tax;

        document.getElementById("billNights").textContent     = nights + (nights === 1 ? " night" : " nights");
        document.getElementById("billRoomCharge").textContent = "$" + roomCharge.toFixed(2);
        document.getElementById("billService").textContent    = "$" + service.toFixed(2);
        document.getElementById("billTax").textContent        = "$" + tax.toFixed(2);
        document.getElementById("billTotal").textContent      = "$" + total.toFixed(2);

        document.getElementById("billModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }

    function closeBill() {
        document.getElementById("billModal").classList.remove("open");
        document.body.style.overflow = "";
    }

    document.getElementById("billModal").addEventListener("click", function(e){
        if (e.target === this) closeBill();
    });

    document.addEventListener("keydown", function(e){
        if (e.key === "Escape") closeBill();
    });
</script>
</body>
</html>
