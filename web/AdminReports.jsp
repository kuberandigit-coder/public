<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map,java.util.List,java.util.LinkedHashMap" %>
<%
    String adminName = (String) request.getAttribute("adminName");
    if (adminName == null) { response.sendRedirect("login.jsp"); return; }

    int    totalRes  = request.getAttribute("totalReservations") != null ? (int)request.getAttribute("totalReservations") : 0;
    int    totalG    = request.getAttribute("totalGuests")       != null ? (int)request.getAttribute("totalGuests")       : 0;
    String totalRev  = request.getAttribute("totalRevenue")      != null ? (String)request.getAttribute("totalRevenue")   : "0.00";
    int    ciToday   = request.getAttribute("checkedInToday")    != null ? (int)request.getAttribute("checkedInToday")    : 0;
    int    coToday   = request.getAttribute("checkingOutToday")  != null ? (int)request.getAttribute("checkingOutToday")  : 0;
    String dbErr     = (String) request.getAttribute("dbErr");

    @SuppressWarnings("unchecked")
    Map<String,Integer> roomCounts  = (Map<String,Integer>) request.getAttribute("roomCounts");
    @SuppressWarnings("unchecked")
    Map<String,Double>  roomRevenue = (Map<String,Double>)  request.getAttribute("roomRevenue");
    @SuppressWarnings("unchecked")
    List<Map<String,String>> recentList = (List<Map<String,String>>) request.getAttribute("recentList");

    if (roomCounts  == null) roomCounts  = new LinkedHashMap<String,Integer>();
    if (roomRevenue == null) roomRevenue = new LinkedHashMap<String,Double>();
    if (recentList  == null) recentList  = new java.util.ArrayList<Map<String,String>>();

    String[] roomTypes  = {"Standard","Deluxe","Family","Ocean View","Suite"};
    String[] roomColors = {"#6b7280","#38bdf8","#22c55e","#d4a855","#a78bfa"};
    int maxCount = 1;
    for (int c : roomCounts.values()) if (c > maxCount) maxCount = c;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Reports — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet"/>
<style>
:root{
  --bg:#06090f;--panel:#0b1120;--card:#0e1628;--card2:#0a1020;--input:#111827;
  --border:rgba(255,255,255,0.06);--border2:rgba(255,255,255,0.10);--border3:rgba(255,255,255,0.16);
  --text:#f0f4ff;--dim:rgba(240,244,255,0.50);--dim2:rgba(240,244,255,0.25);--dim3:rgba(240,244,255,0.10);
  --gold:#d4a855;--gl:#f0c878;--gd:#9a7030;
  --gg1:rgba(212,168,85,0.18);--gg2:rgba(212,168,85,0.08);
  --gbr:rgba(212,168,85,0.25);--gbr2:rgba(212,168,85,0.12);
  --glow:rgba(212,168,85,0.35);
  --green:#22c55e;--red:#ef4444;--teal:#38bdf8;--amber:#f59e0b;--purple:#a78bfa;
  --sw:220px;--r:14px;--rs:8px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html,body{height:100%;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;width:100%;}
a{text-decoration:none;color:inherit;}

/* SIDEBAR */
.sidebar{position:fixed;left:0;top:0;width:var(--sw);height:100vh;background:var(--panel);border-right:1px solid var(--border);display:flex;flex-direction:column;z-index:200;}
.s-logo{padding:22px 18px 18px;border-bottom:1px solid var(--border);}
.s-logo-wave{font-size:24px;display:block;margin-bottom:5px;}
.s-logo-name{font-size:13px;font-weight:700;color:var(--gold);}
.s-logo-sub{font-size:9px;color:var(--dim2);letter-spacing:2px;text-transform:uppercase;margin-top:2px;}
.s-nav{flex:1;padding:14px 10px;overflow-y:auto;}
.s-lbl{font-size:9px;font-weight:800;letter-spacing:2px;text-transform:uppercase;color:var(--dim2);padding:12px 8px 5px;}
.s-link{display:flex;align-items:center;gap:9px;padding:9px 10px;border-radius:var(--rs);font-size:13px;font-weight:500;color:var(--dim);transition:all .15s;margin-bottom:2px;border:1px solid transparent;}
.s-link:hover{background:var(--dim3);color:var(--text);}
.s-link.on{background:var(--gg2);color:var(--gold);border-color:var(--gbr2);}
.s-icon{font-size:15px;width:18px;text-align:center;flex-shrink:0;}
.s-foot{padding:14px;border-top:1px solid var(--border);}
.s-user{display:flex;align-items:center;gap:9px;padding:9px 11px;background:var(--gg2);border:1px solid var(--gbr2);border-radius:var(--rs);margin-bottom:8px;}
.s-av{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--gold),var(--gd));display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;color:#000;flex-shrink:0;}
.s-uname{font-size:12px;font-weight:700;}
.s-urole{font-size:10px;color:var(--gold);}
.s-logout{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:var(--rs);background:rgba(239,68,68,.07);border:1px solid rgba(239,68,68,.15);color:var(--red);font-size:12px;font-weight:600;transition:all .15s;}
.s-logout:hover{background:rgba(239,68,68,.15);}

/* MAIN */
.main{margin-left:var(--sw);flex:1;display:flex;flex-direction:column;min-width:0;animation:fadeUp .35s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(8px);}to{opacity:1;}}
.topbar{position:sticky;top:0;z-index:100;height:58px;background:rgba(6,9,15,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 28px;gap:14px;}
.tb-title{font-size:16px;font-weight:800;flex:1;}
.tb-title em{color:var(--gold);font-style:normal;}
.tb-badge{display:flex;align-items:center;gap:6px;padding:5px 14px;border-radius:20px;background:var(--gg2);border:1px solid var(--gbr);font-size:11px;font-weight:700;color:var(--gl);}
.tb-dot{width:6px;height:6px;border-radius:50%;background:var(--gold);animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.2;}}
.tb-print{padding:7px 16px;background:var(--gg2);border:1px solid var(--gbr);border-radius:var(--rs);color:var(--gl);font-size:12px;font-weight:700;cursor:pointer;transition:all .15s;}
.tb-print:hover{background:var(--gg1);}
.page{flex:1;padding:28px;display:flex;flex-direction:column;gap:22px;}

/* ERROR */
.err-bar{padding:13px 18px;background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.25);border-radius:var(--rs);color:#f87171;font-size:13px;}

/* HERO */
.hero{display:flex;align-items:center;justify-content:space-between;padding:22px 28px;background:linear-gradient(135deg,var(--gg1),var(--gg2),transparent);border:1px solid var(--gbr);border-radius:var(--r);position:relative;overflow:hidden;}
.hero::before{content:'';position:absolute;top:-50px;right:-50px;width:200px;height:200px;border-radius:50%;background:radial-gradient(circle,var(--glow),transparent 70%);pointer-events:none;}
.hero-l{display:flex;align-items:center;gap:16px;}
.hero-icon{width:52px;height:52px;border-radius:var(--rs);background:linear-gradient(135deg,var(--gold),var(--gd));display:flex;align-items:center;justify-content:center;font-size:24px;box-shadow:0 4px 20px var(--glow);}
.hero h1{font-size:22px;font-weight:900;}
.hero h1 em{color:var(--gold);font-style:normal;}
.hero p{font-size:13px;color:var(--dim);margin-top:3px;}
.hero-r{display:flex;gap:10px;flex-shrink:0;}
.hs{background:rgba(0,0,0,.3);border:1px solid var(--border2);border-radius:var(--rs);padding:10px 18px;text-align:center;}
.hs-n{font-family:'JetBrains Mono',monospace;font-size:22px;font-weight:800;color:var(--gold);}
.hs-l{font-size:10px;color:var(--dim2);text-transform:uppercase;letter-spacing:.7px;margin-top:2px;}

/* KPI CARDS */
.kpi-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:14px;}
.kpi{background:var(--card);border:1px solid var(--border);border-radius:var(--r);padding:18px 20px;position:relative;overflow:hidden;transition:border-color .2s,transform .2s;}
.kpi:hover{border-color:var(--border2);transform:translateY(-2px);}
.kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;}
.kpi.gold::before{background:linear-gradient(90deg,var(--gold),var(--gl));}
.kpi.teal::before{background:linear-gradient(90deg,var(--teal),#67e8f9);}
.kpi.green::before{background:linear-gradient(90deg,var(--green),#4ade80);}
.kpi.amber::before{background:linear-gradient(90deg,var(--amber),#fcd34d);}
.kpi.purple::before{background:linear-gradient(90deg,var(--purple),#c4b5fd);}
.kpi-icon{font-size:22px;margin-bottom:10px;}
.kpi-val{font-family:'JetBrains Mono',monospace;font-size:28px;font-weight:800;line-height:1;}
.kpi.gold .kpi-val{color:var(--gl);}
.kpi.teal .kpi-val{color:var(--teal);}
.kpi.green .kpi-val{color:var(--green);}
.kpi.amber .kpi-val{color:var(--amber);}
.kpi.purple .kpi-val{color:var(--purple);}
.kpi-lbl{font-size:12px;color:var(--dim);margin-top:5px;font-weight:500;}

/* SECTION GRID */
.g2{display:grid;grid-template-columns:1fr 1fr;gap:22px;align-items:start;}

/* CARD */
.sc{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;}
.sc:hover{border-color:var(--border2);}
.sc-head{padding:16px 20px;border-bottom:1px solid var(--border);background:linear-gradient(90deg,var(--gg2),transparent);display:flex;align-items:center;gap:10px;}
.sc-ico{width:36px;height:36px;border-radius:var(--rs);background:var(--gg1);border:1px solid var(--gbr);display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;}
.sc-head h3{font-size:14px;font-weight:800;}
.sc-head h3 em{color:var(--gold);font-style:normal;}
.sc-head p{font-size:11px;color:var(--dim);margin-top:1px;}
.sc-body{padding:20px;}

/* BAR CHART */
.bar-row{margin-bottom:14px;}
.bar-row:last-child{margin-bottom:0;}
.bar-meta{display:flex;justify-content:space-between;align-items:center;margin-bottom:5px;}
.bar-name{font-size:13px;font-weight:600;display:flex;align-items:center;gap:7px;}
.bar-dot{width:8px;height:8px;border-radius:50%;}
.bar-val{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--dim);font-weight:600;}
.bar-track{height:8px;background:var(--dim3);border-radius:4px;overflow:hidden;}
.bar-fill{height:100%;border-radius:4px;transition:width 1s ease;}

/* REVENUE TABLE */
.rev-table{width:100%;border-collapse:collapse;}
.rev-table th{font-size:10px;font-weight:800;color:var(--dim2);text-transform:uppercase;letter-spacing:.8px;padding:8px 10px;text-align:left;border-bottom:1px solid var(--border);}
.rev-table td{padding:10px 10px;font-size:13px;border-bottom:1px solid var(--border);vertical-align:middle;}
.rev-table tr:last-child td{border-bottom:none;}
.rev-table tr:hover td{background:var(--dim3);}
.rev-badge{display:inline-flex;align-items:center;gap:6px;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;}
.mono{font-family:'JetBrains Mono',monospace;font-weight:600;}

/* RECENT TABLE */
.r-table{width:100%;border-collapse:collapse;}
.r-table th{font-size:10px;font-weight:800;color:var(--dim2);text-transform:uppercase;letter-spacing:.8px;padding:8px 12px;text-align:left;border-bottom:1px solid var(--border);}
.r-table td{padding:11px 12px;font-size:13px;border-bottom:1px solid var(--border);vertical-align:middle;}
.r-table tr:last-child td{border-bottom:none;}
.r-table tr:hover td{background:var(--dim3);}
.r-room{display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;background:var(--gg2);color:var(--gl);border:1px solid var(--gbr2);}
.empty-row td{text-align:center;color:var(--dim2);padding:30px;font-size:13px;}

/* SUMMARY CARD */
.sum-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.si{background:var(--card2);border:1px solid var(--border);border-radius:var(--rs);padding:13px 15px;}
.si-l{font-size:10px;font-weight:700;color:var(--dim2);text-transform:uppercase;letter-spacing:.7px;margin-bottom:4px;}
.si-v{font-size:14px;font-weight:700;}
.si-v.mono{font-family:'JetBrains Mono',monospace;color:var(--gl);}

@media print{
  .sidebar,.topbar,.tb-print{display:none!important;}
  .main{margin-left:0;}
  body{background:#fff;color:#000;}
  .kpi,.sc{border:1px solid #ddd;background:#fff;}
  .page{padding:10px;}
}
@media(max-width:1100px){.kpi-grid{grid-template-columns:repeat(3,1fr);}}
@media(max-width:900px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}}
@media(max-width:700px){.kpi-grid{grid-template-columns:1fr 1fr;}.g2{grid-template-columns:1fr;}.hero-r{display:none;}}
@media(max-width:480px){.kpi-grid{grid-template-columns:1fr;}}
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="s-logo">
    <span class="s-logo-wave">🌊</span>
    <div class="s-logo-name">Ocean View Resort</div>
    <div class="s-logo-sub">Admin Portal</div>
  </div>
  <nav class="s-nav">
    <div class="s-lbl">Main</div>
    <a class="s-link" href="AdminDashboard"><span class="s-icon">📊</span> Dashboard</a>
    <a class="s-link" href="AdminViewReservation"><span class="s-icon">📋</span> Reservations</a>
    <a class="s-link" href="UserManagement"><span class="s-icon">👥</span> Users &amp; Staff</a>
    <div class="s-lbl">Operations</div>
    <a class="s-link on" href="AdminReports"><span class="s-icon">📈</span> Reports</a>
    <a class="s-link" href="calculateBill.jsp"><span class="s-icon">🧾</span> Bill Calculator</a>
    <div class="s-lbl">System</div>
    <a class="s-link" href="AdminSettings"><span class="s-icon">⚙️</span> Settings</a>
  </nav>
  <div class="s-foot">
    <div class="s-user">
      <div class="s-av"><%= String.valueOf(adminName.charAt(0)).toUpperCase() %></div>
      <div>
        <div class="s-uname"><%= adminName %></div>
        <div class="s-urole">Administrator</div>
      </div>
    </div>
    <a class="s-logout" href="logout">↩ Sign Out</a>
  </div>
</aside>

<!-- MAIN -->
<div class="main">
  <div class="topbar">
    <div class="tb-title">Admin <em>Reports</em></div>
    <div class="tb-badge"><div class="tb-dot"></div> 📈 Live Analytics</div>
    <button class="tb-print" onclick="window.print()">🖨️ Print Report</button>
  </div>

  <div class="page">

    <% if (dbErr != null && !dbErr.isEmpty()) { %>
    <div class="err-bar">⚠️ Database Error: <%= dbErr %></div>
    <% } %>

    <!-- HERO -->
    <div class="hero">
      <div class="hero-l">
        <div class="hero-icon">📈</div>
        <div>
          <h1>Resort <em>Analytics</em></h1>
          <p>Real-time overview of reservations, guests and revenue.</p>
        </div>
      </div>
      <div class="hero-r">
        <div class="hs"><div class="hs-n"><%= totalRes %></div><div class="hs-l">Reservations</div></div>
        <div class="hs"><div class="hs-n">$<%= totalRev %></div><div class="hs-l">Est. Revenue</div></div>
      </div>
    </div>

    <!-- KPI ROW -->
    <div class="kpi-grid">
      <div class="kpi gold">
        <div class="kpi-icon">📋</div>
        <div class="kpi-val"><%= totalRes %></div>
        <div class="kpi-lbl">Total Reservations</div>
      </div>
      <div class="kpi teal">
        <div class="kpi-icon">👥</div>
        <div class="kpi-val"><%= totalG %></div>
        <div class="kpi-lbl">Unique Guests</div>
      </div>
      <div class="kpi green">
        <div class="kpi-icon">💰</div>
        <div class="kpi-val" style="font-size:20px;">$<%= totalRev %></div>
        <div class="kpi-lbl">Est. Revenue</div>
      </div>
      <div class="kpi amber">
        <div class="kpi-icon">🏨</div>
        <div class="kpi-val"><%= ciToday %></div>
        <div class="kpi-lbl">Check-Ins Today</div>
      </div>
      <div class="kpi purple">
        <div class="kpi-icon">🚪</div>
        <div class="kpi-val"><%= coToday %></div>
        <div class="kpi-lbl">Check-Outs Today</div>
      </div>
    </div>

    <!-- CHARTS ROW -->
    <div class="g2">

      <!-- Reservations by Room Type (Bar Chart) -->
      <div class="sc">
        <div class="sc-head">
          <div class="sc-ico">📊</div>
          <div><h3>Bookings by <em>Room Type</em></h3><p>Distribution of all reservations</p></div>
        </div>
        <div class="sc-body">
          <% for (int i = 0; i < roomTypes.length; i++) {
               String rt  = roomTypes[i];
               String col = roomColors[i];
               int cnt    = roomCounts.containsKey(rt) ? roomCounts.get(rt) : 0;
               int pct    = maxCount > 0 ? (cnt * 100 / maxCount) : 0;
          %>
          <div class="bar-row">
            <div class="bar-meta">
              <span class="bar-name">
                <span class="bar-dot" style="background:<%= col %>;"></span>
                <%= rt %>
              </span>
              <span class="bar-val"><%= cnt %> bookings</span>
            </div>
            <div class="bar-track">
              <div class="bar-fill" style="width:<%= pct %>%;background:<%= col %>;"></div>
            </div>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Revenue by Room Type -->
      <div class="sc">
        <div class="sc-head">
          <div class="sc-ico">💵</div>
          <div><h3>Revenue by <em>Room Type</em></h3><p>Estimated earnings per category</p></div>
        </div>
        <div class="sc-body">
          <table class="rev-table">
            <thead>
              <tr>
                <th>Room Type</th>
                <th>Rate/Night</th>
                <th>Bookings</th>
                <th>Est. Revenue</th>
              </tr>
            </thead>
            <tbody>
            <% double[] rates = {80,150,180,220,250};
               for (int i = 0; i < roomTypes.length; i++) {
                 String rt  = roomTypes[i];
                 String col = roomColors[i];
                 int    cnt = roomCounts.containsKey(rt)  ? roomCounts.get(rt)  : 0;
                 double rev = roomRevenue.containsKey(rt) ? roomRevenue.get(rt) : 0;
            %>
            <tr>
              <td>
                <span class="rev-badge" style="background:rgba(0,0,0,.2);border:1px solid <%= col %>22;color:<%= col %>;">
                  <span style="width:6px;height:6px;border-radius:50%;background:<%= col %>;display:inline-block;"></span>
                  <%= rt %>
                </span>
              </td>
              <td class="mono" style="color:var(--dim);">$<%= (int)rates[i] %></td>
              <td class="mono"><%= cnt %></td>
              <td class="mono" style="color:var(--green);">$<%= String.format("%.2f", rev) %></td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>

    </div>

    <!-- RECENT RESERVATIONS -->
    <div class="sc">
      <div class="sc-head">
        <div class="sc-ico">🕐</div>
        <div><h3>Recent <em>Reservations</em></h3><p>Latest 10 bookings ordered by check-in date</p></div>
      </div>
      <div class="sc-body" style="padding:0;">
        <table class="r-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Reservation No</th>
              <th>Guest Name</th>
              <th>Room Type</th>
              <th>Check-In</th>
              <th>Check-Out</th>
              <th>Nights</th>
              <th>Est. Revenue</th>
            </tr>
          </thead>
          <tbody>
          <% if (recentList.isEmpty()) { %>
            <tr class="empty-row"><td colspan="8">📭 No reservations found.</td></tr>
          <% } else {
               int idx = 1;
               for (Map<String,String> row : recentList) {
                 String rm = row.containsKey("room") ? row.get("room") : "";
                 String colorStyle = "var(--gl)";
                 for(int i=0;i<roomTypes.length;i++){if(roomTypes[i].equalsIgnoreCase(rm)){colorStyle=roomColors[i];break;}}
          %>
            <tr>
              <td class="mono" style="color:var(--dim2);"><%= idx++ %></td>
              <td class="mono" style="color:var(--teal);"><%= row.containsKey("res_no")  ? row.get("res_no")  : "" %></td>
              <td style="font-weight:600;"><%= row.containsKey("guest")   ? row.get("guest")   : "" %></td>
              <td><span class="r-room" style="color:<%= colorStyle %>;border-color:<%= colorStyle %>33;"><%= rm %></span></td>
              <td class="mono" style="color:var(--dim);"><%= row.containsKey("checkin")  ? row.get("checkin")  : "" %></td>
              <td class="mono" style="color:var(--dim);"><%= row.containsKey("checkout") ? row.get("checkout") : "" %></td>
              <td class="mono" style="color:var(--amber);"><%= row.containsKey("nights")  ? row.get("nights")  : "1" %></td>
              <td class="mono" style="color:var(--green);">$<%= row.containsKey("revenue") ? row.get("revenue") : "0.00" %></td>
            </tr>
          <% }  } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- SUMMARY -->
    <div class="sc">
      <div class="sc-head">
        <div class="sc-ico">📌</div>
        <div><h3>Report <em>Summary</em></h3><p>Quick overview of all key metrics</p></div>
      </div>
      <div class="sc-body">
        <div class="sum-grid">
          <div class="si"><div class="si-l">Total Reservations</div><div class="si-v mono"><%= totalRes %></div></div>
          <div class="si"><div class="si-l">Unique Guests</div><div class="si-v mono"><%= totalG %></div></div>
          <div class="si"><div class="si-l">Estimated Revenue</div><div class="si-v mono" style="color:var(--green);">$<%= totalRev %></div></div>
          <div class="si"><div class="si-l">Check-Ins Today</div><div class="si-v mono" style="color:var(--amber);"><%= ciToday %></div></div>
          <div class="si"><div class="si-l">Check-Outs Today</div><div class="si-v mono" style="color:var(--purple);"><%= coToday %></div></div>
          <div class="si"><div class="si-l">Most Popular Room</div>
            <div class="si-v" style="font-size:13px;">
              <% String topRoom="N/A"; int topCnt=0;
                 for(Map.Entry<String,Integer> e:roomCounts.entrySet()){if(e.getValue()>topCnt){topCnt=e.getValue();topRoom=e.getKey();}}
              %><%= topRoom %>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>

<script>
/* Animate bars on load */
window.addEventListener('load', function(){
  document.querySelectorAll('.bar-fill').forEach(function(el){
    var w = el.style.width;
    el.style.width = '0';
    setTimeout(function(){ el.style.width = w; }, 100);
  });
});
</script>
</body>
</html>
