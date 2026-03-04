<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    String adminName = sess != null ? (String) sess.getAttribute("admin") : null;
    String staffName = sess != null ? (String) sess.getAttribute("staff") : null;
    if (adminName == null && staffName == null) { response.sendRedirect("login.jsp"); return; }
    String currentUser = adminName != null ? adminName : staffName;
    String userRole    = adminName != null ? "Administrator" : "Staff Member";
    boolean isAdmin    = adminName != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Bill Calculator — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet"/>
<style>
/* ═══════════════════════════════════════════════════════
   THEME
═══════════════════════════════════════════════════════ */
:root {
  --bg:     #07090e;
  --panel:  #0b0f1a;
  --card:   #0e1425;
  --input:  #111827;
  --border: rgba(255,255,255,0.06);
  --border2:rgba(255,255,255,0.10);
  --text:   #eef2ff;
  --dim:    rgba(238,242,255,0.50);
  --dim2:   rgba(238,242,255,0.25);
  --dim3:   rgba(238,242,255,0.08);
  --green:  #4ade80;
  --red:    #f87171;

  <% if (isAdmin) { %>
  --ac:  #d4a855; --al: #f0c878; --ad: #9a7030;
  --ag1: rgba(212,168,85,0.14); --ag2: rgba(212,168,85,0.07);
  --abr: rgba(212,168,85,0.22); --abr2: rgba(212,168,85,0.10);
  --aglow: rgba(212,168,85,0.35);
  <% } else { %>
  --ac:  #38bdf8; --al: #7dd3fc; --ad: #0369a1;
  --ag1: rgba(56,189,248,0.14); --ag2: rgba(56,189,248,0.07);
  --abr: rgba(56,189,248,0.22); --abr2: rgba(56,189,248,0.10);
  --aglow: rgba(56,189,248,0.35);
  <% } %>

  --sw: 220px; --r: 12px; --rsm: 8px;
}

/* ═══════════════════════════════════════════════════════
   BASE
═══════════════════════════════════════════════════════ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; }
body {
  font-family: 'Sora', sans-serif;
  background: var(--bg);
  color: var(--text);
  display: flex; min-height: 100vh;
}
a { text-decoration: none; color: inherit; }
input, select, button { font-family: inherit; }

/* ═══════════════════════════════════════════════════════
   SIDEBAR
═══════════════════════════════════════════════════════ */
.sidebar {
  position: fixed; left: 0; top: 0;
  width: var(--sw); height: 100vh;
  background: var(--panel);
  border-right: 1px solid var(--border);
  display: flex; flex-direction: column; z-index: 200;
}
.s-logo { padding: 22px 18px 18px; border-bottom: 1px solid var(--border); }
.s-logo-wave { font-size: 22px; display: block; margin-bottom: 4px; }
.s-logo-name { font-size: 13px; font-weight: 700; color: var(--ac); }
.s-logo-sub  { font-size: 9px; color: var(--dim2); letter-spacing: 2px; text-transform: uppercase; margin-top: 2px; }
.s-nav { flex: 1; padding: 14px 10px; overflow-y: auto; }
.s-lbl { font-size: 9px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--dim2); padding: 12px 8px 5px; }
.s-link {
  display: flex; align-items: center; gap: 9px;
  padding: 9px 10px; border-radius: var(--rsm);
  font-size: 13px; font-weight: 500; color: var(--dim);
  transition: all .15s; margin-bottom: 2px; border: 1px solid transparent;
}
.s-link:hover { background: var(--dim3); color: var(--text); }
.s-link.on { background: var(--ag2); color: var(--ac); border-color: var(--abr2); }
.s-icon { font-size: 15px; width: 18px; text-align: center; flex-shrink: 0; }
.s-foot { padding: 14px; border-top: 1px solid var(--border); }
.s-user {
  display: flex; align-items: center; gap: 9px;
  padding: 9px 11px; background: var(--ag2); border: 1px solid var(--abr2);
  border-radius: var(--rsm); margin-bottom: 8px;
}
.s-av {
  width: 32px; height: 32px; border-radius: 50%;
  background: linear-gradient(135deg, var(--ac), var(--ad));
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; font-weight: 800; color: #000; flex-shrink: 0;
}
.s-uname { font-size: 12px; font-weight: 700; }
.s-urole { font-size: 10px; color: var(--ac); }
.s-logout {
  display: flex; align-items: center; justify-content: center; gap: 6px;
  padding: 8px; border-radius: var(--rsm);
  background: rgba(248,113,113,.07); border: 1px solid rgba(248,113,113,.15);
  color: var(--red); font-size: 12px; font-weight: 600; transition: all .15s;
}
.s-logout:hover { background: rgba(248,113,113,.15); }

/* ═══════════════════════════════════════════════════════
   MAIN
═══════════════════════════════════════════════════════ */
.main { margin-left: var(--sw); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
.topbar {
  position: sticky; top: 0; z-index: 100; height: 56px;
  background: rgba(7,9,14,.9); backdrop-filter: blur(20px);
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; padding: 0 28px; gap: 12px;
}
.tb-title { font-size: 15px; font-weight: 700; flex: 1; }
.tb-title em { color: var(--ac); font-style: normal; }
.tb-badge {
  display: flex; align-items: center; gap: 6px;
  padding: 5px 13px; border-radius: 20px;
  background: var(--ag2); border: 1px solid var(--abr);
  font-size: 11px; font-weight: 600; color: var(--al);
}
.tb-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--ac); animation: pulse 2s infinite; }
@keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:.2;} }

/* ═══════════════════════════════════════════════════════
   PAGE
═══════════════════════════════════════════════════════ */
.page { flex: 1; padding: 28px; display: flex; flex-direction: column; gap: 22px; max-width: 900px; margin: 0 auto; width: 100%; }

/* Page header */
.page-hd {
  display: flex; align-items: center; justify-content: space-between;
  padding: 20px 24px;
  background: linear-gradient(120deg, var(--ag1), var(--ag2) 60%, transparent);
  border: 1px solid var(--abr); border-radius: var(--r);
}
.page-hd-left { display: flex; align-items: center; gap: 14px; }
.page-hd-icon {
  width: 48px; height: 48px; border-radius: var(--rsm);
  background: linear-gradient(135deg, var(--ac), var(--ad));
  display: flex; align-items: center; justify-content: center;
  font-size: 22px; box-shadow: 0 4px 18px var(--aglow);
}
.page-hd h1 { font-size: 20px; font-weight: 800; letter-spacing: -.3px; }
.page-hd h1 em { color: var(--ac); font-style: normal; }
.page-hd p { font-size: 12px; color: var(--dim); margin-top: 3px; }

/* Rate cards */
.rate-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; }
.rate-card {
  background: var(--card); border: 1.5px solid var(--border2);
  border-radius: var(--rsm); padding: 12px 10px; text-align: center;
  cursor: default; transition: border-color .2s, background .2s;
}
.rate-card.active { border-color: var(--ac); background: var(--ag2); }
.rc-icon { font-size: 20px; display: block; margin-bottom: 6px; }
.rc-type { font-size: 11px; font-weight: 700; color: var(--dim); }
.rc-price { font-family: 'JetBrains Mono', monospace; font-size: 15px; font-weight: 700; color: var(--al); margin-top: 4px; }
.rc-unit { font-size: 9px; color: var(--dim2); }

/* Calculator card */
.calc-card { background: var(--card); border: 1px solid var(--border); border-radius: var(--r); overflow: hidden; }
.calc-head {
  padding: 18px 24px; border-bottom: 1px solid var(--border);
  background: linear-gradient(90deg, var(--ag2), transparent);
  display: flex; align-items: center; gap: 10px;
}
.calc-head-icon {
  width: 34px; height: 34px; border-radius: var(--rsm);
  background: var(--ag1); border: 1px solid var(--abr);
  display: flex; align-items: center; justify-content: center; font-size: 16px;
}
.calc-head h2 { font-size: 14px; font-weight: 700; }
.calc-head h2 em { color: var(--ac); font-style: normal; }
.calc-head p { font-size: 11px; color: var(--dim); margin-top: 1px; }
.calc-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }

/* Form groups */
.fg-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.fg-row3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; }
.fg { display: flex; flex-direction: column; gap: 6px; }
label { font-size: 10px; font-weight: 700; color: var(--dim); text-transform: uppercase; letter-spacing: .8px; }
.req { color: var(--red); margin-left: 2px; }
.fc {
  width: 100%; background: var(--input);
  border: 1.5px solid var(--border2); border-radius: var(--rsm);
  color: var(--text); font-size: 13px;
  padding: 10px 13px; outline: none;
  transition: border-color .2s, box-shadow .2s;
}
.fc:hover { border-color: var(--border2); filter: brightness(1.1); }
.fc:focus { border-color: var(--ac); box-shadow: 0 0 0 3px var(--ag2); }
.fc::placeholder { color: var(--dim2); }
select.fc option { background: #0e1425; }

/* Divider label */
.section-lbl {
  font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
  color: var(--ac); display: flex; align-items: center; gap: 8px; margin: 4px 0 -4px;
}
.section-lbl::after { content: ''; flex: 1; height: 1px; background: var(--abr2); }

/* Night info bar */
.night-bar {
  display: none; align-items: center; justify-content: space-between;
  padding: 12px 16px; background: var(--ag2); border: 1px solid var(--abr);
  border-radius: var(--rsm);
}
.nb-left { display: flex; align-items: center; gap: 10px; }
.nb-num { font-family: 'JetBrains Mono', monospace; font-size: 26px; font-weight: 800; color: var(--al); }
.nb-label { font-size: 12px; color: var(--dim); }
.nb-right { font-size: 12px; color: var(--dim); text-align: right; }
.nb-right strong { color: var(--al); font-family: 'JetBrains Mono', monospace; font-size: 14px; }

/* Calculate button */
.btn-calc {
  width: 100%; padding: 14px;
  background: linear-gradient(135deg, var(--ac), var(--ad));
  color: #000; font-size: 14px; font-weight: 800;
  border: none; border-radius: var(--rsm); cursor: pointer;
  transition: all .2s; letter-spacing: .3px;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  box-shadow: 0 4px 18px var(--aglow);
}
.btn-calc:hover { transform: translateY(-2px); box-shadow: 0 8px 28px var(--aglow); }
.btn-calc:active { transform: none; }
.btn-reset {
  width: 100%; padding: 10px; margin-top: 6px;
  background: transparent; border: 1px solid var(--border2);
  border-radius: var(--rsm); color: var(--dim);
  font-size: 12px; font-weight: 600; cursor: pointer; transition: all .15s;
}
.btn-reset:hover { background: var(--dim3); color: var(--text); }

/* ═══════════════════════════════════════════════════════
   RESULT PANEL
═══════════════════════════════════════════════════════ */
.result-panel {
  display: none; background: var(--card);
  border: 1px solid var(--abr); border-radius: var(--r); overflow: hidden;
}
.result-panel.show {
  display: block;
  animation: fadeUp .4s cubic-bezier(.22,1,.36,1) both;
}
@keyframes fadeUp { from{opacity:0;transform:translateY(16px);} to{opacity:1;transform:none;} }

.rp-top-stripe { height: 3px; background: linear-gradient(90deg, var(--ad), var(--ac), var(--al), var(--ac), var(--ad)); }

.rp-header {
  padding: 18px 24px; border-bottom: 1px solid var(--border);
  background: linear-gradient(120deg, var(--ag1), transparent);
  display: flex; align-items: center; justify-content: space-between;
}
.rp-header-left { display: flex; align-items: center; gap: 10px; }
.rp-check { font-size: 22px; }
.rp-title { font-size: 15px; font-weight: 800; }
.rp-title em { color: var(--ac); font-style: normal; }
.rp-sub { font-size: 11px; color: var(--dim); margin-top: 2px; }
.rp-badge {
  padding: 4px 12px; border-radius: 20px;
  background: rgba(74,222,128,.1); border: 1px solid rgba(74,222,128,.2);
  font-size: 10px; font-weight: 700; color: var(--green); letter-spacing: .5px;
}

/* Summary info row */
.rp-info {
  display: grid; grid-template-columns: repeat(4, 1fr);
  border-bottom: 1px solid var(--border);
}
.ri-cell {
  padding: 14px 18px; border-right: 1px solid var(--border);
}
.ri-cell:last-child { border-right: none; }
.ri-lbl { font-size: 10px; font-weight: 700; color: var(--dim2); text-transform: uppercase; letter-spacing: .7px; margin-bottom: 4px; }
.ri-val { font-size: 13px; font-weight: 600; }
.ri-val.mono { font-family: 'JetBrains Mono', monospace; color: var(--al); font-size: 14px; }

/* Breakdown table */
.rp-breakdown { padding: 20px 24px; }
.breakdown-title {
  font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
  color: var(--dim2); margin-bottom: 12px;
  display: flex; align-items: center; gap: 8px;
}
.breakdown-title::after { content: ''; flex: 1; height: 1px; background: var(--border); }

.bk-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 10px 0; border-bottom: 1px solid var(--border);
}
.bk-row:last-child { border-bottom: none; }
.bk-desc { font-size: 13px; color: var(--dim); }
.bk-desc strong { color: var(--text); }
.bk-val { font-family: 'JetBrains Mono', monospace; font-size: 13px; font-weight: 600; }
.bk-row.disc .bk-desc, .bk-row.disc .bk-val { color: var(--green); }
.bk-row.subtotal .bk-desc { font-weight: 600; color: var(--text); }
.bk-row.subtotal .bk-val { color: var(--text); font-size: 14px; }

/* Total bar */
.rp-total {
  margin: 0 24px 20px;
  padding: 16px 20px;
  background: linear-gradient(120deg, var(--ag1), var(--ag2));
  border: 1px solid var(--abr); border-radius: var(--rsm);
  display: flex; align-items: center; justify-content: space-between;
}
.rpt-label { font-size: 14px; font-weight: 800; color: var(--ac); }
.rpt-note  { font-size: 10px; color: var(--dim2); margin-top: 2px; }
.rpt-amount {
  font-family: 'JetBrains Mono', monospace;
  font-size: 36px; font-weight: 900; color: var(--al);
  letter-spacing: -1px;
}

/* Action buttons */
.rp-actions { padding: 0 24px 22px; display: flex; gap: 10px; }
.btn-act {
  flex: 1; padding: 11px;
  border-radius: var(--rsm); font-size: 12px; font-weight: 700;
  cursor: pointer; transition: all .15s;
  display: flex; align-items: center; justify-content: center; gap: 6px;
}
.btn-print { background: transparent; border: 1.5px solid var(--border2); color: var(--text); }
.btn-print:hover { background: var(--dim3); }
.btn-new { background: linear-gradient(135deg, var(--ac), var(--ad)); border: none; color: #000; }
.btn-new:hover { transform: translateY(-1px); box-shadow: 0 4px 14px var(--aglow); }

/* ═══════════════════════════════════════════════════════
   PRINT
═══════════════════════════════════════════════════════ */
@media print {
  .sidebar, .topbar, .page-hd, .rate-grid, .calc-card, .rp-actions { display: none !important; }
  .main { margin-left: 0; }
  .page { padding: 0; max-width: 100%; }
  .result-panel { display: block !important; border: none; border-radius: 0; }
  body, .result-panel, .rp-header { background: white !important; color: black !important; }
  .ri-val, .bk-desc strong, .bk-row.subtotal .bk-val { color: #111 !important; }
  .ri-val.mono, .bk-val, .rpt-amount { color: #7a5c14 !important; }
  .rp-top-stripe { background: #7a5c14; }
  .rp-total { background: #f9f0df; border-color: #c8a04a; }
  .rpt-label { color: #7a5c14 !important; }
  .rp-info, .ri-cell, .bk-row { border-color: #e0d0b0; }
}

@media (max-width: 900px) { .rate-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 700px) {
  .sidebar { transform: translateX(-100%); } .main { margin-left: 0; }
  .page { padding: 16px; }
  .fg-row, .fg-row3 { grid-template-columns: 1fr; }
  .rp-info { grid-template-columns: 1fr 1fr; }
  .ri-cell:nth-child(even) { border-right: none; }
  .ri-cell:nth-child(n+3) { border-top: 1px solid var(--border); }
}
</style>
</head>
<body>

<!-- ══ SIDEBAR ══════════════════════════════════════════ -->
<aside class="sidebar">
  <div class="s-logo">
    <span class="s-logo-wave">🌊</span>
    <div class="s-logo-name">Ocean View Resort</div>
    <div class="s-logo-sub"><%= isAdmin ? "Admin Portal" : "Staff Portal" %></div>
  </div>
  <nav class="s-nav">
    <div class="s-lbl">Main</div>
    <% if (isAdmin) { %>
      <a class="s-link" href="AdminDashboard"><span class="s-icon">📊</span> Dashboard</a>
      <a class="s-link" href="AdminViewReservation"><span class="s-icon">📋</span> Reservations</a>
      <a class="s-link" href="UserManagement"><span class="s-icon">👥</span> Users &amp; Staff</a>
    <% } else { %>
      <a class="s-link" href="Staff"><span class="s-icon">📋</span> Reservations</a>
    <% } %>
    <div class="s-lbl">Operations</div>
    <a class="s-link on" href="calculateBill.jsp"><span class="s-icon">🧮</span> Bill Calculator</a>
  </nav>
  <div class="s-foot">
    <div class="s-user">
      <div class="s-av"><%= String.valueOf(currentUser.charAt(0)).toUpperCase() %></div>
      <div>
        <div class="s-uname"><%= currentUser %></div>
        <div class="s-urole"><%= userRole %></div>
      </div>
    </div>
    <a class="s-logout" href="logout">↩ Sign Out</a>
  </div>
</aside>

<!-- ══ MAIN ══════════════════════════════════════════════ -->
<div class="main">

  <div class="topbar">
    <div class="tb-title">Bill <em>Calculator</em></div>
    <div class="tb-badge"><div class="tb-dot"></div> 🧮 Stay Cost</div>
  </div>

  <div class="page">

    <!-- Page header -->
    <div class="page-hd">
      <div class="page-hd-left">
        <div class="page-hd-icon">🧮</div>
        <div>
          <h1>Bill <em>Calculator</em></h1>
          <p>Compute the total stay cost based on nights and room rates.</p>
        </div>
      </div>
    </div>

    <!-- Room rate reference cards -->
    <div class="rate-grid" id="rateGrid">
      <div class="rate-card" data-type="Standard">
        <span class="rc-icon">🛏️</span>
        <div class="rc-type">Standard</div>
        <div class="rc-price">$80</div>
        <div class="rc-unit">per night</div>
      </div>
      <div class="rate-card" data-type="Deluxe">
        <span class="rc-icon">🏩</span>
        <div class="rc-type">Deluxe</div>
        <div class="rc-price">$150</div>
        <div class="rc-unit">per night</div>
      </div>
      <div class="rate-card" data-type="Family">
        <span class="rc-icon">👨‍👩‍👧</span>
        <div class="rc-type">Family</div>
        <div class="rc-price">$180</div>
        <div class="rc-unit">per night</div>
      </div>
      <div class="rate-card" data-type="Ocean View">
        <span class="rc-icon">🌊</span>
        <div class="rc-type">Ocean View</div>
        <div class="rc-price">$220</div>
        <div class="rc-unit">per night</div>
      </div>
      <div class="rate-card" data-type="Suite">
        <span class="rc-icon">👑</span>
        <div class="rc-type">Suite</div>
        <div class="rc-price">$250</div>
        <div class="rc-unit">per night</div>
      </div>
    </div>

    <!-- Calculator form -->
    <div class="calc-card">
      <div class="calc-head">
        <div class="calc-head-icon">📝</div>
        <div>
          <h2>Reservation <em>Details</em></h2>
          <p>Enter booking information to compute the bill</p>
        </div>
      </div>
      <div class="calc-body">

        <div class="section-lbl">👤 Guest Information</div>
        <div class="fg-row">
          <div class="fg">
            <label>Reservation No <span class="req">*</span></label>
            <input class="fc" type="text" id="f_rno" placeholder="e.g. RES-001" autocomplete="off"/>
          </div>
          <div class="fg">
            <label>Guest Name <span class="req">*</span></label>
            <input class="fc" type="text" id="f_gn" placeholder="Full guest name"/>
          </div>
        </div>

        <div class="section-lbl">🏨 Room &amp; Stay</div>
        <div class="fg">
          <label>Room Type <span class="req">*</span></label>
          <select class="fc" id="f_rt" onchange="onRoomChange()">
            <option value="">— Select Room Type —</option>
            <option value="Standard"   data-rate="80">Standard Room — $80 / night</option>
            <option value="Deluxe"     data-rate="150">Deluxe Room — $150 / night</option>
            <option value="Family"     data-rate="180">Family Room — $180 / night</option>
            <option value="Ocean View" data-rate="220">Ocean View Room — $220 / night</option>
            <option value="Suite"      data-rate="250">Suite — $250 / night</option>
          </select>
        </div>
        <div class="fg-row">
          <div class="fg">
            <label>Check-In Date <span class="req">*</span></label>
            <input class="fc" type="date" id="f_ci" onchange="onDateChange()"/>
          </div>
          <div class="fg">
            <label>Check-Out Date <span class="req">*</span></label>
            <input class="fc" type="date" id="f_co" onchange="onDateChange()"/>
          </div>
        </div>

        <!-- Night info bar -->
        <div class="night-bar" id="nightBar">
          <div class="nb-left">
            <span style="font-size:22px;">🌙</span>
            <div>
              <div class="nb-num" id="nb_count">0</div>
              <div class="nb-label">Night(s)</div>
            </div>
          </div>
          <div class="nb-right">
            Rate per night<br>
            <strong id="nb_rate">$0</strong>
          </div>
        </div>

       

        <button class="btn-calc" onclick="calculate()">⚡ Calculate Bill</button>
        <button class="btn-reset" onclick="resetAll()">🔄 Clear &amp; Reset</button>

      </div>
    </div>

    <!-- ── RESULT PANEL ─────────────────────────── -->
    <div class="result-panel" id="resultPanel">
      <div class="rp-top-stripe"></div>

      <div class="rp-header">
        <div class="rp-header-left">
          <span class="rp-check">✅</span>
          <div>
            <div class="rp-title">Bill <em>Summary</em></div>
            <div class="rp-sub">Ocean View Resort — Total Stay Cost</div>
          </div>
        </div>
        <div class="rp-badge">CALCULATED</div>
      </div>

      <div class="rp-info">
        <div class="ri-cell">
          <div class="ri-lbl">Reservation</div>
          <div class="ri-val mono" id="r_rno"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Guest</div>
          <div class="ri-val" id="r_gn"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Room Type</div>
          <div class="ri-val" id="r_rt"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Duration</div>
          <div class="ri-val mono" id="r_dur"></div>
        </div>
      </div>

      <div class="rp-info" style="border-top:1px solid var(--border);">
        <div class="ri-cell">
          <div class="ri-lbl">Check-In</div>
          <div class="ri-val mono" id="r_ci"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Check-Out</div>
          <div class="ri-val mono" id="r_co"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Rate / Night</div>
          <div class="ri-val mono" id="r_rate"></div>
        </div>
        <div class="ri-cell">
          <div class="ri-lbl">Calculated by</div>
          <div class="ri-val" style="color:var(--ac);"><%= currentUser %></div>
        </div>
      </div>

      <div class="rp-breakdown">
        <div class="breakdown-title">Cost Breakdown</div>

        <div class="bk-row">
          <div class="bk-desc"><strong id="r_nights_lbl">0 Nights</strong> × <span id="r_rate_lbl">$0/night</span></div>
          <div class="bk-val" id="r_room"></div>
        </div>
        <div class="bk-row">
          <div class="bk-desc">Service Charge <span style="font-size:11px;color:var(--dim2);">(10%)</span></div>
          <div class="bk-val" id="r_svc"></div>
        </div>
        <div class="bk-row">
          <div class="bk-desc">Government Tax <span style="font-size:11px;color:var(--dim2);">(8%)</span></div>
          <div class="bk-val" id="r_tax"></div>
        </div>
        <div class="bk-row subtotal">
          <div class="bk-desc">Subtotal (before discount)</div>
          <div class="bk-val" id="r_sub"></div>
        </div>
        <div class="bk-row disc" id="r_disc_row" style="display:none;">
          <div class="bk-desc">🎁 Discount <span id="r_disc_pct"></span></div>
          <div class="bk-val" id="r_disc_amt"></div>
        </div>
      </div>

      <div class="rp-total">
        <div>
          <div class="rpt-label">TOTAL AMOUNT DUE</div>
          <div class="rpt-note">Inclusive of service charge &amp; government tax</div>
        </div>
        <div class="rpt-amount" id="r_total"></div>
      </div>

      <div class="rp-actions">
        <button class="btn-act btn-print" onclick="window.print()">🖨️ Print Bill</button>
        <button class="btn-act btn-new" onclick="resetAll()">🔄 New Calculation</button>
      </div>
    </div>

  </div><!-- /page -->
</div><!-- /main -->

<script>
var RATES = { Standard:80, Deluxe:150, Family:180, 'Ocean View':220, Suite:250 };
function $(id){ return document.getElementById(id); }
function fmt(n){ return '$' + n.toFixed(2); }

function onRoomChange(){
  var sel = $('f_rt');
  var opt = sel.options[sel.selectedIndex];
  var rt  = opt ? opt.value : '';
  // Highlight rate card
  document.querySelectorAll('.rate-card').forEach(function(c){
    c.classList.toggle('active', c.dataset.type === rt);
  });
  updateNightBar();
}

function onDateChange(){
  var ci = $('f_ci').value, co = $('f_co').value;
  if(ci) $('f_co').min = ci;
  updateNightBar();
}

function updateNightBar(){
  var ci = $('f_ci').value, co = $('f_co').value;
  var sel = $('f_rt');
  var opt = sel.options[sel.selectedIndex];
  var rate = opt ? parseFloat(opt.getAttribute('data-rate')) : 0;
  var n = 0;
  if(ci && co) n = Math.max(0, Math.round((new Date(co)-new Date(ci))/86400000));
  if(n > 0){
    $('nb_count').textContent = n;
    $('nb_rate').textContent  = rate ? fmt(rate) : '—';
    $('nightBar').style.display = 'flex';
  } else {
    $('nightBar').style.display = 'none';
  }
}

function syncDisc(src){
  if(src==='r'){
    $('f_disc').value = $('f_disc_r').value;
  } else {
    var v = Math.min(100, Math.max(0, parseFloat($('f_disc').value)||0));
    $('f_disc').value = v;
    $('f_disc_r').value = Math.min(50, v);
  }
}

function calculate(){
  var rno  = $('f_rno').value.trim();
  var gn   = $('f_gn').value.trim();
  var sel  = $('f_rt');
  var rt   = sel.value;
  var ci   = $('f_ci').value;
  var co   = $('f_co').value;
  var disc = parseFloat($('f_disc').value) || 0;

  if(!rno){ alert('Please enter a Reservation No.'); $('f_rno').focus(); return; }
  if(!gn) { alert('Please enter the Guest Name.');   $('f_gn').focus();  return; }
  if(!rt) { alert('Please select a Room Type.');     $('f_rt').focus();  return; }
  if(!ci) { alert('Please select a Check-In date.'); $('f_ci').focus();  return; }
  if(!co) { alert('Please select a Check-Out date.');$('f_co').focus();  return; }

  var nights = Math.round((new Date(co) - new Date(ci)) / 86400000);
  if(nights <= 0){ alert('Check-out must be after Check-in.'); return; }
  if(disc < 0 || disc > 100){ alert('Discount must be 0–100%.'); return; }

  var rate    = RATES[rt] || 80;
  var room    = rate * nights;
  var svc     = room * 0.10;
  var tax     = room * 0.08;
  var sub     = room + svc + tax;
  var discAmt = sub * (disc / 100);
  var total   = sub - discAmt;

  // Fill result panel
  $('r_rno').textContent        = rno;
  $('r_gn').textContent         = gn;
  $('r_rt').textContent         = rt;
  $('r_dur').textContent        = nights + (nights===1?' night':' nights');
  $('r_ci').textContent         = ci;
  $('r_co').textContent         = co;
  $('r_rate').textContent       = fmt(rate);
  $('r_nights_lbl').textContent = nights + (nights===1?' Night':' Nights');
  $('r_rate_lbl').textContent   = fmt(rate) + '/night';
  $('r_room').textContent       = fmt(room);
  $('r_svc').textContent        = fmt(svc);
  $('r_tax').textContent        = fmt(tax);
  $('r_sub').textContent        = fmt(sub);
  $('r_total').textContent      = fmt(total);

  if(disc > 0){
    $('r_disc_pct').textContent = '(' + disc + '%)';
    $('r_disc_amt').textContent = '− ' + fmt(discAmt);
    $('r_disc_row').style.display = 'flex';
  } else {
    $('r_disc_row').style.display = 'none';
  }

  // Show result
  var rp = $('resultPanel');
  rp.classList.remove('show');
  rp.style.display = 'block';
  setTimeout(function(){ rp.classList.add('show'); }, 10);
  rp.scrollIntoView({ behavior:'smooth', block:'nearest' });
}

function resetAll(){
  ['f_rno','f_gn','f_ci','f_co'].forEach(function(id){ $(id).value=''; });
  $('f_rt').selectedIndex = 0;
  $('f_disc').value = '0';
  $('f_disc_r').value = '0';
  $('nightBar').style.display = 'none';
  document.querySelectorAll('.rate-card').forEach(function(c){ c.classList.remove('active'); });
  $('resultPanel').style.display = 'none';
  $('resultPanel').classList.remove('show');
  $('f_rno').focus();
}
</script>
</body>
</html>
