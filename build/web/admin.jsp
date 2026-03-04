<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    // ── All data injected by AdminDashboard.java servlet ──────
    String adminName       = (String)  request.getAttribute("adminName");
    int    totalRes        = request.getAttribute("totalRes")   != null ? (int) request.getAttribute("totalRes")   : 0;
    int    totalUsers      = request.getAttribute("totalUsers") != null ? (int) request.getAttribute("totalUsers") : 0;
    int    totalStaff      = request.getAttribute("totalStaff") != null ? (int) request.getAttribute("totalStaff") : 0;
    String today           = (String)  request.getAttribute("today");
    String dbErr           = (String)  request.getAttribute("dbErr");
    List<String[]> recentRes = (List<String[]>) request.getAttribute("recentRes");

    if (adminName == null) { response.sendRedirect("login.jsp"); return; }
    if (dbErr     == null)  dbErr     = "";
    if (today     == null)  today     = "";
    if (recentRes == null)  recentRes = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
:root{
  --bg:#080c14;--sidebar:#050810;--card:#0e1521;
  --border:rgba(255,255,255,0.07);
  --gold:#c9a96e;--gl:#e8c98a;--teal:#38bdf8;--green:#22c55e;
  --red:#ef4444;--amber:#f59e0b;
  --text:#eef2f7;--dim:rgba(238,242,247,0.45);--dim2:rgba(238,242,247,0.22);
  --sidebar-w:240px;
}
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;overflow-x:hidden;}

/* SIDEBAR */
.sidebar{width:var(--sidebar-w);background:var(--sidebar);border-right:1px solid var(--border);display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:50;}
.sidebar-logo{padding:26px 22px 20px;border-bottom:1px solid var(--border);}
.logo-badge{display:inline-flex;align-items:center;gap:10px;}
.logo-icon{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,var(--gold),#a07840);display:flex;align-items:center;justify-content:center;font-size:18px;}
.logo-text{font-size:15px;font-weight:700;line-height:1.2;}
.logo-text span{display:block;font-size:10px;font-weight:400;color:var(--dim);letter-spacing:0.12em;text-transform:uppercase;margin-top:1px;}
.sidebar-nav{flex:1;padding:16px 12px;overflow-y:auto;}
.nav-section{font-size:9px;font-weight:700;letter-spacing:0.2em;text-transform:uppercase;color:var(--dim2);padding:0 10px;margin:18px 0 8px;}
.nav-item{display:flex;align-items:center;gap:12px;padding:9px 12px;border-radius:10px;font-size:13.5px;font-weight:500;color:var(--dim);text-decoration:none;transition:all 0.2s;margin-bottom:2px;}
.nav-item:hover{background:rgba(255,255,255,0.05);color:var(--text);}
.nav-item.active{background:linear-gradient(135deg,rgba(201,169,110,0.18),rgba(201,169,110,0.06));border:1px solid rgba(201,169,110,0.2);color:var(--gl);}
.nav-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:15px;background:rgba(255,255,255,0.04);}
.nav-item.active .nav-icon{background:rgba(201,169,110,0.15);}
.nav-badge{margin-left:auto;background:rgba(201,169,110,0.2);border:1px solid rgba(201,169,110,0.3);color:var(--gold);font-size:10px;font-weight:700;padding:2px 7px;border-radius:100px;}
.sidebar-footer{padding:16px 12px;border-top:1px solid var(--border);}
.user-card{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:12px;margin-bottom:10px;}
.avatar{width:34px;height:34px;border-radius:9px;background:linear-gradient(135deg,var(--gold),#8B6914);display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:800;color:#050810;}
.user-name{font-size:13px;font-weight:600;}
.user-role{font-size:10px;color:var(--gold);font-weight:600;letter-spacing:0.08em;text-transform:uppercase;}
.logout-link{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;background:rgba(239,68,68,0.08);border:1px solid rgba(239,68,68,0.18);color:rgba(239,68,68,0.8);text-decoration:none;font-size:13px;font-weight:500;transition:all 0.2s;}
.logout-link:hover{background:rgba(239,68,68,0.18);color:#fca5a5;}

/* MAIN */
.main{margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column;min-height:100vh;}
.topbar{background:rgba(5,8,16,0.85);backdrop-filter:blur(12px);border-bottom:1px solid var(--border);padding:0 32px;height:60px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:40;}
.topbar-title{font-size:16px;font-weight:600;}
.topbar-title span{color:var(--gold);}
.topbar-right{display:flex;align-items:center;gap:14px;}
.date-badge{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--dim);background:rgba(255,255,255,0.04);border:1px solid var(--border);padding:5px 12px;border-radius:8px;}
.status-pill{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--green);background:rgba(34,197,94,0.1);border:1px solid rgba(34,197,94,0.2);padding:5px 12px;border-radius:8px;}
.status-dot{width:6px;height:6px;border-radius:50%;background:var(--green);box-shadow:0 0 6px var(--green);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:0.5;}}
.content{padding:28px 32px;flex:1;}
.page-title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin-bottom:4px;}
.page-title em{font-style:normal;color:var(--gold);}
.page-sub{font-size:13px;color:var(--dim);margin-bottom:28px;}
.db-err{background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.25);color:#fca5a5;padding:12px 16px;border-radius:10px;font-size:13px;margin-bottom:20px;}

/* STAT CARDS */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:28px;}
.stat-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:22px;position:relative;overflow:hidden;transition:transform 0.25s;}
.stat-card:hover{transform:translateY(-3px);}
.stat-card::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;}
.c1::after{background:linear-gradient(90deg,transparent,var(--gold),transparent);}
.c2::after{background:linear-gradient(90deg,transparent,var(--teal),transparent);}
.c3::after{background:linear-gradient(90deg,transparent,var(--green),transparent);}
.c4::after{background:linear-gradient(90deg,transparent,var(--amber),transparent);}
.stat-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:16px;}
.stat-icon{width:46px;height:46px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;}
.ic1{background:rgba(201,169,110,0.12);border:1px solid rgba(201,169,110,0.2);}
.ic2{background:rgba(56,189,248,0.12);border:1px solid rgba(56,189,248,0.2);}
.ic3{background:rgba(34,197,94,0.12);border:1px solid rgba(34,197,94,0.2);}
.ic4{background:rgba(245,158,11,0.12);border:1px solid rgba(245,158,11,0.2);}
.stat-trend{font-size:11px;font-weight:600;padding:3px 8px;border-radius:6px;}
.trend-up{background:rgba(34,197,94,0.12);color:var(--green);}
.trend-info{background:rgba(56,189,248,0.12);color:var(--teal);}
.stat-num{font-family:'JetBrains Mono',monospace;font-size:36px;font-weight:700;line-height:1;margin-bottom:5px;}
.c1 .stat-num{color:var(--gl);}
.c2 .stat-num{color:var(--teal);}
.c3 .stat-num{color:var(--green);}
.c4 .stat-num{color:var(--amber);}
.stat-label{font-size:12px;font-weight:500;color:var(--dim);text-transform:uppercase;letter-spacing:0.1em;}

/* TWO COL */
.two-col{display:grid;grid-template-columns:1fr 380px;gap:16px;margin-bottom:28px;}
.panel{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden;}
.panel-head{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);}
.panel-title{font-size:15px;font-weight:600;display:flex;align-items:center;gap:9px;}
.panel-icon{width:30px;height:30px;border-radius:8px;background:rgba(201,169,110,0.12);border:1px solid rgba(201,169,110,0.2);display:flex;align-items:center;justify-content:center;font-size:14px;}
.view-all{font-size:12px;color:var(--gold);text-decoration:none;font-weight:600;padding:5px 12px;border-radius:8px;border:1px solid rgba(201,169,110,0.25);transition:all 0.2s;}
.view-all:hover{background:rgba(201,169,110,0.1);}
.mini-table{width:100%;border-collapse:collapse;}
.mini-table th{padding:11px 18px;text-align:left;font-size:10px;font-weight:700;letter-spacing:0.14em;text-transform:uppercase;color:var(--dim2);background:rgba(255,255,255,0.02);border-bottom:1px solid var(--border);}
.mini-table td{padding:12px 18px;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04);}
.mini-table tr:last-child td{border-bottom:none;}
.mini-table tr:hover td{background:rgba(255,255,255,0.025);}
.res-no{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--gl);font-weight:500;}
.room-chip{display:inline-flex;align-items:center;gap:4px;background:rgba(56,189,248,0.1);border:1px solid rgba(56,189,248,0.2);color:var(--teal);padding:3px 8px;border-radius:6px;font-size:11px;font-weight:600;}
.qa-grid{display:flex;flex-direction:column;gap:8px;padding:16px;}
.qa-item{display:flex;align-items:center;gap:12px;padding:12px 14px;background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:12px;text-decoration:none;color:var(--text);font-size:13px;font-weight:500;transition:all 0.2s;}
.qa-item:hover{background:rgba(201,169,110,0.08);border-color:rgba(201,169,110,0.25);color:var(--gl);}
.qa-icon{width:34px;height:34px;border-radius:9px;background:rgba(201,169,110,0.1);border:1px solid rgba(201,169,110,0.18);display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;}
.qa-label{font-size:13px;font-weight:600;}
.qa-desc{font-size:11px;color:var(--dim);margin-top:1px;}
.qa-text{flex:1;}
.qa-arrow{color:var(--dim2);font-size:14px;transition:transform 0.2s;}
.qa-item:hover .qa-arrow{transform:translateX(3px);color:var(--gold);}

/* STATUS */
.status-section{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
.status-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px 22px;}
.sc-title{font-size:13px;font-weight:600;color:var(--dim);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:16px;}
.sc-items{display:flex;flex-direction:column;gap:11px;}
.sc-item{display:flex;align-items:center;gap:12px;}
.sc-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0;box-shadow:0 0 5px currentColor;}
.dg{background:var(--green);color:var(--green);}
.da{background:var(--gold);color:var(--gold);}
.dt{background:var(--teal);color:var(--teal);}
.dr{background:var(--red);color:var(--red);}
.sc-label{flex:1;font-size:13px;}
.sc-val{font-family:'JetBrains Mono',monospace;font-size:14px;font-weight:600;color:var(--gl);}
.occ-bar{margin-top:14px;background:rgba(255,255,255,0.05);border-radius:100px;height:6px;overflow:hidden;}
.occ-fill{height:100%;background:linear-gradient(90deg,var(--teal),var(--gold));border-radius:100px;transition:width 1.2s cubic-bezier(0.4,0,0.2,1);}
.occ-label{display:flex;justify-content:space-between;font-size:11px;color:var(--dim);margin-bottom:6px;}
.occ-label strong{color:var(--gl);font-family:'JetBrains Mono',monospace;}

@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,1fr);}.two-col{grid-template-columns:1fr;}.status-section{grid-template-columns:1fr;}}
@media(max-width:900px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}}
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-badge">
      <div class="logo-icon">🌊</div>
      <div class="logo-text">Ocean View Resort<span>Admin Portal</span></div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Main</div>
    <a class="nav-item active" href="AdminDashboard">
      <div class="nav-icon">📊</div> Dashboard
    </a>
    <a class="nav-item" href="AdminViewReservation">
      <div class="nav-icon">📋</div> Reservations
      <% if (totalRes > 0) { %><span class="nav-badge"><%= totalRes %></span><% } %>
    </a>
    <a class="nav-item" href="UserManagement">
      <div class="nav-icon">👥</div> Users &amp; Staff
    </a>
    <div class="nav-section">Operations</div>
    <a class="nav-item" href="calculateBill.jsp">
      <div class="nav-icon">🧾</div> Bill Calculator
    </a>
    <a class="nav-item" href="adminReports.jsp">
      <div class="nav-icon">📈</div> Reports
    </a>
    <div class="nav-section">System</div>
    <a class="nav-item" href="adminSettings.jsp">
      <div class="nav-icon">⚙️</div> Settings
    </a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-card">
      <div class="avatar"><%= adminName.charAt(0) %></div>
      <div>
        <div class="user-name"><%= adminName %></div>
        <div class="user-role">Administrator</div>
      </div>
    </div>
    <a href="logout" class="logout-link">↩ &nbsp;Sign Out</a>
  </div>
</aside>

<!-- MAIN -->
<div class="main">
  <div class="topbar">
    <div class="topbar-title">Admin <span>Dashboard</span></div>
    <div class="topbar-right">
      <div class="date-badge">📅 <%= today %></div>
      <div class="status-pill"><span class="status-dot"></span> System Online</div>
    </div>
  </div>

  <div class="content">

    <!-- DB Error -->
    <% if (!dbErr.isEmpty()) { %>
    <div class="db-err">🔌 Database error: <%= dbErr %> — Check MySQL is running in XAMPP.</div>
    <% } %>

    <!-- Header -->
    <div class="page-title">Welcome back, <em><%= adminName %></em></div>
    <div class="page-sub">Here is what is happening at Ocean View Resort today.</div>

    <!-- KPI Cards -->
    <div class="stats-grid">
      <div class="stat-card c1">
        <div class="stat-top"><div class="stat-icon ic1">📋</div><span class="stat-trend trend-up">LIVE</span></div>
        <div class="stat-num"><%= totalRes %></div>
        <div class="stat-label">Total Reservations</div>
      </div>
      <div class="stat-card c2">
        <div class="stat-top"><div class="stat-icon ic2">👥</div><span class="stat-trend trend-info">DB</span></div>
        <div class="stat-num"><%= totalUsers %></div>
        <div class="stat-label">Registered Guests</div>
      </div>
      <div class="stat-card c3">
        <div class="stat-top"><div class="stat-icon ic3">🪪</div><span class="stat-trend trend-up">DB</span></div>
        <div class="stat-num"><%= totalStaff %></div>
        <div class="stat-label">Staff Accounts</div>
      </div>
      <div class="stat-card c4">
        <div class="stat-top"><div class="stat-icon ic4">💰</div><span class="stat-trend trend-up">+12%</span></div>
        <div class="stat-num">$9.4k</div>
        <div class="stat-label">Monthly Revenue</div>
      </div>
    </div>

    <!-- Two Column -->
    <div class="two-col">

      <!-- Recent Reservations -->
      <div class="panel">
        <div class="panel-head">
          <div class="panel-title"><div class="panel-icon">📋</div> Recent Reservations</div>
          <a href="adminViewReservation.jsp" class="view-all">View All →</a>
        </div>
        <table class="mini-table">
          <thead><tr><th>Res. No</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Check-Out</th></tr></thead>
          <tbody>
            <% if (recentRes.isEmpty()) { %>
            <tr><td colspan="5" style="text-align:center;padding:30px;color:var(--dim);">
              No reservations yet. <a href="adminViewReservation.jsp" style="color:var(--gold);">Add one →</a>
            </td></tr>
            <% } else { for (String[] r : recentRes) { %>
            <tr>
              <td><span class="res-no"><%= r[0] %></span></td>
              <td style="font-weight:500;"><%= r[1] %></td>
              <td><span class="room-chip">🏨 <%= r[2] %></span></td>
              <td style="color:var(--dim);font-size:12px;"><%= r[3] %></td>
              <td style="color:var(--dim);font-size:12px;"><%= r[4] %></td>
            </tr>
            <% }} %>
          </tbody>
        </table>
      </div>

      <!-- Quick Actions -->
      <div class="panel">
        <div class="panel-head">
          <div class="panel-title"><div class="panel-icon">⚡</div> Quick Actions</div>
        </div>
        <div class="qa-grid">
          <a href="AdminViewReservation" class="qa-item">
            <div class="qa-icon">📋</div>
            <div class="qa-text"><div class="qa-label">Manage Reservations</div><div class="qa-desc">Add, edit, delete bookings</div></div>
            <span class="qa-arrow">›</span>
          </a>
          <a href="UserManagement" class="qa-item">
            <div class="qa-icon">👥</div>
            <div class="qa-text"><div class="qa-label">Users &amp; Staff</div><div class="qa-desc">Manage accounts &amp; roles</div></div>
            <span class="qa-arrow">›</span>
          </a>
          <a href="calculateBill.jsp" class="qa-item">
            <div class="qa-icon">🧾</div>
            <div class="qa-text"><div class="qa-label">Bill Calculator</div><div class="qa-desc">Generate guest invoices</div></div>
            <span class="qa-arrow">›</span>
          </a>
          <a href="staff.jsp" class="qa-item">
            <div class="qa-icon">🪪</div>
            <div class="qa-text"><div class="qa-label">Staff Dashboard</div><div class="qa-desc">Switch to staff view</div></div>
            <span class="qa-arrow">›</span>
          </a>
          <a href="adminReports.jsp" class="qa-item">
            <div class="qa-icon">📈</div>
            <div class="qa-text"><div class="qa-label">Reports &amp; Analytics</div><div class="qa-desc">Revenue &amp; occupancy data</div></div>
            <span class="qa-arrow">›</span>
          </a>
        </div>
      </div>
    </div>

    <!-- Status Section -->
    <div class="status-section">
      <div class="status-card">
        <div class="sc-title">📡 Live System Status</div>
        <div class="sc-items">
          <div class="sc-item">
            <span class="sc-dot <%= dbErr.isEmpty() ? "dg" : "dr" %>"></span>
            <span class="sc-label">Database Connection</span>
            <span class="sc-val"><%= dbErr.isEmpty() ? "Online" : "Error" %></span>
          </div>
          <div class="sc-item"><span class="sc-dot da"></span><span class="sc-label">Total Reservations</span><span class="sc-val"><%= totalRes %></span></div>
          <div class="sc-item"><span class="sc-dot dt"></span><span class="sc-label">Staff Accounts</span><span class="sc-val"><%= totalStaff %></span></div>
          <div class="sc-item"><span class="sc-dot dg"></span><span class="sc-label">Guest Accounts</span><span class="sc-val"><%= totalUsers %></span></div>
        </div>
      </div>
      <div class="status-card">
        <div class="sc-title">📊 Occupancy Overview</div>
        <div class="occ-label"><span>Room Occupancy</span><strong>75%</strong></div>
        <div class="occ-bar"><div class="occ-fill" id="occFill" style="width:0%"></div></div>
        <div class="sc-items" style="margin-top:16px;">
          <div class="sc-item"><span class="sc-dot dg"></span><span class="sc-label">Rooms Occupied</span><span class="sc-val">18 / 24</span></div>
          <div class="sc-item"><span class="sc-dot dt"></span><span class="sc-label">Available Rooms</span><span class="sc-val">6</span></div>
          <div class="sc-item"><span class="sc-dot dr"></span><span class="sc-label">Maintenance</span><span class="sc-val">2</span></div>
        </div>
      </div>
    </div>

  </div><!-- /content -->
</div><!-- /main -->

<script>
window.addEventListener("load", function () {
    setTimeout(function () {
        document.getElementById("occFill").style.width = "75%";
    }, 400);
});
</script>
</body>
</html>
