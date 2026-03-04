<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String adminName = (String) session.getAttribute("admin");
    if (adminName == null) adminName = "Administrator";

    int totalReservations = 0, totalUsers = 0, totalStaff = 0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb","root","");
        ResultSet rs;
        rs = c.prepareStatement("SELECT COUNT(*) FROM reservations").executeQuery();
        if (rs.next()) totalReservations = rs.getInt(1); rs.close();
        rs = c.prepareStatement("SELECT COUNT(*) FROM users WHERE role='user'").executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1); rs.close();
        rs = c.prepareStatement("SELECT COUNT(*) FROM users WHERE role='staff'").executeQuery();
        if (rs.next()) totalStaff = rs.getInt(1); rs.close();
        c.close();
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Admin Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root{--gold:#c9a96e;--gold-light:#e8c98a;--deep-navy:#050d1a;--teal:#0e7490;--crimson:#c0392b;--glass:rgba(255,255,255,0.06);--glass-border:rgba(255,255,255,0.12);--text-dim:rgba(255,255,255,0.55);}
        *{margin:0;padding:0;box-sizing:border-box;}html{scroll-behavior:smooth;}
        body{font-family:'DM Sans',sans-serif;background:var(--deep-navy);min-height:100vh;color:white;overflow-x:hidden;-webkit-font-smoothing:antialiased;}
        .hero-bg{position:fixed;inset:0;z-index:0;background:url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80') center/cover no-repeat;will-change:transform;}
        .hero-bg::before{content:'';position:absolute;inset:0;background:linear-gradient(180deg,rgba(5,13,26,0.88) 0%,rgba(5,13,26,0.68) 40%,rgba(5,13,26,0.95) 100%);}
        .wave-container{position:fixed;bottom:0;left:0;width:100%;height:120px;z-index:1;overflow:hidden;opacity:0.18;}
        .wave{position:absolute;bottom:0;left:-50%;width:200%;height:80px;background:linear-gradient(to right,transparent,var(--teal),transparent);border-radius:50%;animation:wave 8s ease-in-out infinite;}
        .wave:nth-child(2){height:60px;animation:wave 12s ease-in-out infinite reverse;opacity:0.6;background:linear-gradient(to right,transparent,var(--gold),transparent);}
        @keyframes wave{0%,100%{transform:translateX(0) translateY(0);}50%{transform:translateX(8%) translateY(-12px);}}
        .particles{position:fixed;inset:0;z-index:2;pointer-events:none;overflow:hidden;}
        .particle{position:absolute;width:2px;height:2px;border-radius:50%;background:var(--gold-light);opacity:0;animation:floatUp var(--dur,15s) linear var(--delay,0s) infinite;left:var(--x,50%);bottom:-10px;}
        @keyframes floatUp{0%{opacity:0;transform:translateY(0);}10%{opacity:0.4;}90%{opacity:0.2;}100%{opacity:0;transform:translateY(-100vh);}}
        /* NAVBAR */
        .navbar{position:fixed;top:0;width:100%;z-index:100;background:rgba(5,13,26,0.92);backdrop-filter:blur(14px);border-bottom:1px solid var(--glass-border);padding:14px 40px;display:flex;justify-content:space-between;align-items:center;animation:pageIn 0.4s ease both;}
        .navbar-brand{font-family:'Cormorant Garamond',serif;font-size:23px;font-weight:600;letter-spacing:0.04em;display:flex;align-items:center;gap:10px;}
        .wave-icon{display:inline-block;animation:sway 3s ease-in-out infinite;}
        @keyframes sway{0%,100%{transform:rotate(-5deg);}50%{transform:rotate(5deg);}}
        .nav-gold{color:var(--gold);}
        .admin-badge{background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.5);color:var(--gold-light);font-size:10px;font-weight:600;letter-spacing:0.2em;text-transform:uppercase;padding:4px 10px;border-radius:100px;margin-left:4px;}
        .navbar-right{display:flex;align-items:center;gap:12px;}
        .user-badge{display:flex;align-items:center;gap:9px;background:var(--glass);border:1px solid var(--glass-border);padding:6px 14px 6px 8px;border-radius:100px;font-size:13px;}
        .user-avatar{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,var(--gold),#a07840);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:var(--deep-navy);}
        .nav-btn{padding:7px 16px;border-radius:100px;font-size:13px;text-decoration:none;transition:all 0.3s;border:1px solid;}
        .btn-logout{background:rgba(255,59,48,0.18);border-color:rgba(255,59,48,0.4);color:white;}
        .btn-logout:hover{background:rgba(255,59,48,0.38);color:#ff6b6b;}
        /* MAIN */
        .container{position:relative;z-index:10;padding:120px 40px 80px;max-width:1340px;margin:0 auto;animation:pageIn 0.5s ease both;}
        @keyframes pageIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
        .welcome{margin-bottom:36px;}
        .welcome-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.25em;text-transform:uppercase;color:var(--gold);margin-bottom:10px;display:flex;align-items:center;gap:10px;}
        .welcome-eyebrow::before{content:'';width:28px;height:1px;background:var(--gold);}
        .welcome h2{font-family:'Cormorant Garamond',serif;font-size:46px;font-weight:300;line-height:1.1;margin-bottom:10px;}
        .welcome h2 em{font-style:italic;color:var(--gold-light);}
        .welcome p{font-size:14px;color:var(--text-dim);max-width:500px;line-height:1.7;}
        /* KPI */
        .kpi-strip{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:36px;}
        .kpi-card{background:var(--glass);border:1px solid var(--glass-border);border-radius:16px;padding:20px 22px;position:relative;overflow:hidden;transition:transform 0.3s,border-color 0.3s;}
        .kpi-card:hover{border-color:rgba(201,169,110,0.35);transform:translateY(-3px);}
        .kpi-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.55;}
        .kpi-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;}
        .kpi-icon{font-size:22px;}
        .kpi-badge{font-size:10px;font-weight:600;letter-spacing:0.08em;padding:3px 8px;border-radius:100px;}
        .bg{background:rgba(16,185,129,0.2);border:1px solid rgba(16,185,129,0.35);color:#6ee7b7;}
        .bi{background:rgba(14,116,144,0.2);border:1px solid rgba(14,116,144,0.4);color:#67e8f9;}
        .bw{background:rgba(245,158,11,0.2);border:1px solid rgba(245,158,11,0.35);color:#fcd34d;}
        .bp{background:rgba(168,85,247,0.2);border:1px solid rgba(168,85,247,0.35);color:#d8b4fe;}
        .kpi-num{font-family:'Cormorant Garamond',serif;font-size:38px;font-weight:700;color:var(--gold-light);line-height:1;margin-bottom:4px;}
        .kpi-label{font-size:11px;letter-spacing:0.12em;text-transform:uppercase;color:var(--text-dim);}
        /* SECTION */
        .section-label{font-size:10px;letter-spacing:0.3em;text-transform:uppercase;color:var(--text-dim);margin-bottom:16px;display:flex;align-items:center;gap:14px;}
        .section-label::after{content:'';flex:1;height:1px;background:var(--glass-border);}
        /* CARDS */
        .cards{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:22px;}
        .card{position:relative;background:var(--glass);border:1px solid var(--glass-border);border-radius:20px;overflow:hidden;cursor:pointer;transition:transform 0.4s cubic-bezier(0.25,0.46,0.45,0.94),border-color 0.3s,box-shadow 0.4s;min-height:180px;display:flex;flex-direction:column;justify-content:flex-end;}
        .card:hover{transform:translateY(-6px);border-color:rgba(201,169,110,0.45);box-shadow:0 24px 60px rgba(0,0,0,0.5);}
        .card-img{position:absolute;inset:0;background-size:cover;background-position:center;transition:transform 0.6s ease;z-index:0;}
        .card:hover .card-img{transform:scale(1.06);}
        .card::before{content:'';position:absolute;inset:0;background:linear-gradient(to top,rgba(5,13,26,0.93) 0%,rgba(5,13,26,0.45) 55%,rgba(5,13,26,0.15) 100%);z-index:1;}
        .card-content{position:relative;z-index:2;padding:22px;}
        .card-icon{width:42px;height:42px;border-radius:11px;background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.4);display:flex;align-items:center;justify-content:center;font-size:18px;margin-bottom:10px;transition:all 0.3s;}
        .card:hover .card-icon{transform:scale(1.1);}
        .card h3{font-family:'Cormorant Garamond',serif;font-size:19px;font-weight:600;margin-bottom:5px;}
        .card p{font-size:12px;color:var(--text-dim);line-height:1.5;max-width:220px;}
        .card-arrow{position:absolute;right:18px;bottom:18px;z-index:2;width:32px;height:32px;border-radius:50%;border:1px solid var(--glass-border);display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--glass);transition:all 0.3s;}
        .card:hover .card-arrow{background:var(--gold);border-color:var(--gold);transform:translate(3px,-3px);}
        .card.feat{grid-column:span 2;grid-row:span 2;min-height:380px;}
        .card.feat h3{font-size:26px;}
        .card.feat p{font-size:13px;max-width:320px;}
        .card.teal-card .card-icon{background:linear-gradient(135deg,rgba(14,116,144,0.3),rgba(14,116,144,0.1));border-color:rgba(14,116,144,0.4);}
        .card.teal-card:hover{border-color:rgba(14,116,144,0.5);}
        .card.teal-card:hover .card-arrow{background:var(--teal);border-color:var(--teal);}
        .card.danger .card-icon{background:linear-gradient(135deg,rgba(192,57,43,0.3),rgba(192,57,43,0.1));border-color:rgba(192,57,43,0.4);}
        .card.danger:hover{border-color:rgba(192,57,43,0.5);}
        .card.danger:hover .card-arrow{background:var(--crimson);border-color:var(--crimson);}
        /* BOTTOM */
        .bottom-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-top:18px;}
        .panel{background:var(--glass);border:1px solid var(--glass-border);border-radius:20px;padding:26px 28px;position:relative;overflow:hidden;}
        .panel::before{content:'';position:absolute;top:0;left:0;right:0;height:1px;background:linear-gradient(90deg,transparent,var(--gold-light),transparent);opacity:0.3;}
        .panel-title{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;margin-bottom:4px;}
        .panel-sub{font-size:12px;color:var(--text-dim);margin-bottom:20px;}
        .quick-links{display:flex;flex-direction:column;gap:10px;}
        .quick-link{display:flex;align-items:center;justify-content:space-between;padding:11px 15px;background:rgba(255,255,255,0.04);border:1px solid var(--glass-border);border-radius:12px;text-decoration:none;color:white;transition:all 0.3s;font-size:13px;}
        .quick-link:hover{background:rgba(201,169,110,0.12);border-color:rgba(201,169,110,0.35);transform:translateX(4px);}
        .ql-left{display:flex;align-items:center;gap:12px;}
        .ql-icon{width:32px;height:32px;border-radius:8px;background:rgba(201,169,110,0.15);border:1px solid rgba(201,169,110,0.2);display:flex;align-items:center;justify-content:center;font-size:14px;}
        .chevron{color:var(--text-dim);font-size:12px;transition:transform 0.2s;}
        .quick-link:hover .chevron{transform:translateX(3px);color:var(--gold);}
        .status-list{display:flex;flex-direction:column;gap:14px;}
        .status-item{display:flex;align-items:center;gap:14px;}
        .sdot{width:10px;height:10px;border-radius:50%;flex-shrink:0;box-shadow:0 0 6px currentColor;}
        .dg{background:#10b981;color:#10b981;}.dau{background:var(--gold);color:var(--gold);}.dt{background:#0e7490;color:#0e7490;}.do{background:#f59e0b;color:#f59e0b;}
        .status-info{flex:1;}
        .status-label{font-size:13px;font-weight:500;margin-bottom:2px;}
        .status-meta{font-size:11px;color:var(--text-dim);}
        .status-val{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;color:var(--gold-light);}
        .occ-bar-wrap{margin-top:18px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);border-radius:12px;padding:16px 18px;}
        .occ-bar-hdr{display:flex;justify-content:space-between;font-size:12px;color:var(--text-dim);margin-bottom:10px;}
        .occ-bar-hdr strong{color:var(--gold-light);font-size:15px;}
        .bar-track{height:6px;background:rgba(255,255,255,0.08);border-radius:100px;overflow:hidden;}
        .bar-fill{height:100%;border-radius:100px;background:linear-gradient(90deg,var(--teal),var(--gold));transition:width 1s ease;}
        .footer{text-align:center;margin-top:60px;font-size:12px;color:var(--text-dim);letter-spacing:0.08em;}
        .footer::before{content:'';display:block;width:60px;height:1px;background:var(--gold);margin:0 auto 16px;}
        @media(max-width:1100px){.kpi-strip{grid-template-columns:repeat(2,1fr);}.cards{grid-template-columns:repeat(2,1fr);}.card.feat{grid-column:span 2;min-height:260px;}}
        @media(max-width:768px){.bottom-grid{grid-template-columns:1fr;}.navbar{padding:12px 20px;}.container{padding:105px 18px 60px;}.welcome h2{font-size:32px;}.cards{grid-template-columns:1fr 1fr;}}
    </style>
</head>
<body>
<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

<div class="navbar">
    <div class="navbar-brand">
        <span class="wave-icon">🌊</span>Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        <span class="admin-badge">Admin</span>
    </div>
    <div class="navbar-right">
        <div class="user-badge">
            <div class="user-avatar" id="avatarInit">A</div>
            <span><%= adminName %></span>
        </div>
        <a href="logout" class="nav-btn btn-logout">↩ Logout</a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <div class="welcome-eyebrow">Administration Control Panel</div>
        <h2>Resort <em>Command</em> Center</h2>
        <p>Full control over reservations, users, staff, and billing. Manage every aspect of Ocean View Resort from one dashboard.</p>
    </div>

    <div class="kpi-strip">
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">📋</span><span class="kpi-badge bi">LIVE</span></div>
            <div class="kpi-num"><%= totalReservations %></div>
            <div class="kpi-label">Total Reservations</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">👥</span><span class="kpi-badge bg">DB</span></div>
            <div class="kpi-num"><%= totalUsers %></div>
            <div class="kpi-label">Registered Guests</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🪪</span><span class="kpi-badge bw">DB</span></div>
            <div class="kpi-num"><%= totalStaff %></div>
            <div class="kpi-label">Staff Accounts</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">💰</span><span class="kpi-badge bp">MONTH</span></div>
            <div class="kpi-num">$9.4k</div>
            <div class="kpi-label">Revenue This Month</div>
        </div>
    </div>

    <div class="section-label">Management Modules</div>
    <div class="cards">
        <div class="card feat" onclick="location.href='adminViewReservation.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">📋</div>
                <h3>Manage Reservations</h3>
                <p>View, add, edit, or delete any reservation. Full search, bill calculation, and booking history for every guest stay.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card teal-card" onclick="location.href='adminUserManagement.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">👥</div>
                <h3>Users & Staff</h3>
                <p>Add, edit, delete user and staff accounts. Assign roles and manage credentials.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card" onclick="location.href='calculateBill.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">💳</div>
                <h3>Bill Calculator</h3>
                <p>Calculate and generate guest invoices with itemised charges.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card" onclick="location.href='adminRooms.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">🏨</div>
                <h3>Room Management</h3>
                <p>Configure room types, pricing and availability status.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card" onclick="location.href='adminReports.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">📊</div>
                <h3>Reports & Analytics</h3>
                <p>Occupancy rates, revenue trends, seasonal forecasting.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card" onclick="location.href='adminHousekeeping.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">🧹</div>
                <h3>Housekeeping</h3>
                <p>Track cleaning schedules and assign tasks by room.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
        <div class="card danger" onclick="location.href='adminSettings.jsp'">
            <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&q=80')"></div>
            <div class="card-content">
                <div class="card-icon">⚙️</div>
                <h3>System Settings</h3>
                <p>Configure system parameters and global policies.</p>
            </div>
            <div class="card-arrow">→</div>
        </div>
    </div>

    <div class="bottom-grid">
        <div class="panel">
            <div class="panel-title">⚡ Quick Actions</div>
            <div class="panel-sub">Common administrative tasks</div>
            <div class="quick-links">
                <a href="adminViewReservation.jsp" class="quick-link"><div class="ql-left"><div class="ql-icon">📋</div><span>View All Reservations</span></div><span class="chevron">›</span></a>
                <a href="adminUserManagement.jsp" class="quick-link"><div class="ql-left"><div class="ql-icon">👥</div><span>Manage Users & Staff</span></div><span class="chevron">›</span></a>
                <a href="calculateBill.jsp" class="quick-link"><div class="ql-left"><div class="ql-icon">🧾</div><span>Calculate Guest Bill</span></div><span class="chevron">›</span></a>
                <a href="staffDashboard.jsp" class="quick-link"><div class="ql-left"><div class="ql-icon">🪪</div><span>Staff Dashboard</span></div><span class="chevron">›</span></a>
            </div>
        </div>
        <div class="panel">
            <div class="panel-title">📡 Live Status</div>
            <div class="panel-sub">Real-time resort overview from database</div>
            <div class="status-list">
                <div class="status-item"><div class="sdot dg"></div><div class="status-info"><div class="status-label">System Status</div><div class="status-meta">All services operational</div></div><div class="status-val">Online</div></div>
                <div class="status-item"><div class="sdot dau"></div><div class="status-info"><div class="status-label">Total Reservations</div><div class="status-meta">From reservations table</div></div><div class="status-val"><%= totalReservations %></div></div>
                <div class="status-item"><div class="sdot dt"></div><div class="status-info"><div class="status-label">Staff Accounts</div><div class="status-meta">Role = staff</div></div><div class="status-val"><%= totalStaff %></div></div>
                <div class="status-item"><div class="sdot do"></div><div class="status-info"><div class="status-label">Guest Accounts</div><div class="status-meta">Role = user</div></div><div class="status-val"><%= totalUsers %></div></div>
            </div>
            <div class="occ-bar-wrap">
                <div class="occ-bar-hdr"><span>Occupancy Rate</span><strong>75%</strong></div>
                <div class="bar-track"><div class="bar-fill" id="occBar" style="width:0%"></div></div>
            </div>
        </div>
    </div>

    <div class="footer">© 2026 Ocean View Resort &nbsp;·&nbsp; Admin Control Panel &nbsp;·&nbsp; All rights reserved</div>
</div>

<script>
    document.getElementById("avatarInit").textContent = "<%= adminName %>".charAt(0).toUpperCase();
    var pc = document.getElementById("particles");
    for (var i = 0; i < 18; i++) {
        var p = document.createElement("div"); p.className = "particle";
        p.style.cssText = "--x:"+Math.random()*100+"%;--dur:"+(12+Math.random()*14)+"s;--delay:"+(Math.random()*12)+"s";
        pc.appendChild(p);
    }
    window.addEventListener("load", function(){ setTimeout(function(){ document.getElementById("occBar").style.width="75%"; }, 300); });
    window.addEventListener("scroll", function(){
        document.querySelector(".navbar").style.background = window.scrollY>50?"rgba(5,13,26,0.99)":"rgba(5,13,26,0.92)";
    },{passive:true});
</script>
</body>
</html>
