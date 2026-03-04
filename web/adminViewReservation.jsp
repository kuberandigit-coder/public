<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    // ── All data set by AdminViewReservation.java servlet ─────
    List<String[]> reservations = (List<String[]>) request.getAttribute("reservations");
    int    totalCount = request.getAttribute("totalCount") != null ? (int) request.getAttribute("totalCount") : 0;
    String search     = (String) request.getAttribute("search");
    String adminName  = (String) request.getAttribute("adminName");
    String flashOk    = (String) request.getAttribute("flashOk");
    String flashErr   = (String) request.getAttribute("flashErr");

    if (adminName    == null) { response.sendRedirect("login.jsp"); return; }
    if (search       == null) search = "";
    if (reservations == null) reservations = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Reservations — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root{
  --bg:#080c14;--sidebar:#050810;--card:#0e1521;--card2:#111926;
  --border:rgba(255,255,255,0.07);--border2:rgba(255,255,255,0.12);
  --gold:#c9a96e;--gl:#e8c98a;--gold-d:#a07840;
  --teal:#38bdf8;--green:#22c55e;--red:#ef4444;--amber:#f59e0b;
  --text:#eef2f7;--dim:rgba(238,242,247,.55);--dim2:rgba(238,242,247,.28);
  --sw:240px;--r:14px;--rs:8px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
a{text-decoration:none;color:inherit;}
input,select,textarea,button{font-family:inherit;}
table{border-collapse:collapse;width:100%;}

/* SIDEBAR */
.sidebar{position:fixed;left:0;top:0;width:var(--sw);height:100vh;background:var(--sidebar);border-right:1px solid var(--border);display:flex;flex-direction:column;z-index:100;}
.s-logo{padding:24px 20px 20px;border-bottom:1px solid var(--border);}
.s-logo .icon{font-size:26px;display:block;margin-bottom:6px;}
.s-logo .title{font-size:13px;font-weight:600;color:var(--gold);}
.s-logo .sub{font-size:10px;color:var(--dim2);letter-spacing:1.5px;text-transform:uppercase;margin-top:2px;}
.s-nav{flex:1;padding:16px 12px;overflow-y:auto;}
.s-sec{font-size:9px;font-weight:700;letter-spacing:1.8px;text-transform:uppercase;color:var(--dim2);padding:14px 8px 6px;}
.s-item{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:var(--rs);font-size:13.5px;font-weight:500;color:var(--dim);transition:all .18s;margin-bottom:2px;}
.s-item:hover{background:rgba(255,255,255,.05);color:var(--text);}
.s-item.active{background:rgba(201,169,110,.12);color:var(--gold);}
.s-icon{font-size:16px;width:20px;text-align:center;}
.s-badge{margin-left:auto;background:var(--gold);color:#000;font-size:10px;font-weight:700;padding:1px 6px;border-radius:20px;font-family:'JetBrains Mono',monospace;}
.s-foot{border-top:1px solid var(--border);padding:16px;}
.u-card{display:flex;align-items:center;gap:10px;background:rgba(201,169,110,.08);border:1px solid rgba(201,169,110,.18);border-radius:var(--rs);padding:10px 12px;margin-bottom:10px;}
.u-av{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--gold),var(--gold-d));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#000;flex-shrink:0;}
.u-name{font-size:12.5px;font-weight:600;}
.u-role{font-size:10px;color:var(--gold);font-weight:500;}
.logout{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:var(--rs);background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.18);color:var(--red);font-size:12.5px;font-weight:500;transition:all .18s;}
.logout:hover{background:rgba(239,68,68,.16);}

/* MAIN */
.main{margin-left:var(--sw);flex:1;display:flex;flex-direction:column;animation:pageIn .35s ease both;}
@keyframes pageIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
.topbar{position:sticky;top:0;height:60px;background:rgba(8,12,20,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px;z-index:90;}
.t-title{font-size:16px;font-weight:700;flex:1;}
.t-title span{color:var(--gold);}
.t-pill{display:flex;align-items:center;gap:6px;padding:5px 12px;border-radius:20px;font-size:11.5px;font-weight:600;background:rgba(201,169,110,.1);border:1px solid rgba(201,169,110,.2);color:var(--gl);}
.dot{width:7px;height:7px;border-radius:50%;background:var(--gold);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:.3;}}
.content{padding:28px 32px;flex:1;}

/* PAGE HEADER */
.ph{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;}
.ph h1{font-size:22px;font-weight:700;}
.ph h1 span{color:var(--gold);}
.ph p{font-size:13px;color:var(--dim);margin-top:3px;}
.btn-add{display:flex;align-items:center;gap:7px;padding:10px 20px;border-radius:var(--rs);background:linear-gradient(135deg,var(--gold),var(--gold-d));color:#000;font-size:13px;font-weight:700;border:none;cursor:pointer;transition:all .18s;}
.btn-add:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(201,169,110,.35);}

/* FLASH */
.flash{display:flex;align-items:center;gap:10px;padding:13px 18px;border-radius:var(--rs);font-size:13.5px;font-weight:500;margin-bottom:20px;}
.f-ok {background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.25);color:#4ade80;}
.f-err{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.25);color:#f87171;}

/* KPI */
.kpis{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:24px;}
.kpi{background:var(--card);border:1px solid var(--border);border-radius:var(--r);padding:20px 22px;transition:all .2s;}
.kpi:hover{transform:translateY(-3px);border-color:var(--border2);}
.kpi-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;}
.kpi-icon{font-size:24px;}
.kpi-badge{font-size:10px;font-weight:700;padding:3px 9px;border-radius:20px;letter-spacing:.4px;text-transform:uppercase;}
.kb1{background:rgba(201,169,110,.15);color:var(--gold);}
.kb2{background:rgba(56,189,248,.15);color:var(--teal);}
.kb3{background:rgba(34,197,94,.15);color:var(--green);}
.kpi-num{font-size:32px;font-weight:700;font-family:'JetBrains Mono',monospace;line-height:1;margin-bottom:4px;}
.kpi-label{font-size:12px;color:var(--dim);}
.kn1{color:var(--gl);}
.kn2{color:var(--teal);}
.kn3{color:var(--green);}

/* TABLE */
.tbl-card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;}
.tbl-head{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);flex-wrap:wrap;gap:12px;}
.tbl-head h2{font-size:15px;font-weight:700;}
.tbl-head h2 span{color:var(--gold);}
.tbl-head p{font-size:12px;color:var(--dim);margin-top:2px;}
.srch{display:flex;align-items:center;background:var(--card2);border:1px solid var(--border2);border-radius:var(--rs);overflow:hidden;}
.srch input{background:transparent;border:none;outline:none;color:var(--text);font-size:13px;padding:9px 14px;width:220px;}
.srch input::placeholder{color:var(--dim2);}
.srch button{background:linear-gradient(135deg,var(--gold),var(--gold-d));border:none;cursor:pointer;padding:9px 14px;font-size:14px;color:#000;}
.srch a{display:flex;align-items:center;padding:9px 12px;color:var(--dim);font-size:12px;}
.srch a:hover{color:var(--red);}
table thead tr{background:rgba(201,169,110,.06);border-bottom:1px solid var(--border);}
table thead th{padding:12px 14px;font-size:11px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--dim);text-align:left;}
table tbody tr{border-bottom:1px solid var(--border);transition:background .15s;}
table tbody tr:last-child{border-bottom:none;}
table tbody tr:hover{background:rgba(255,255,255,.03);}
table tbody td{padding:13px 14px;font-size:13px;color:var(--text);}
.td-rno{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--gl);font-weight:600;}
.room-chip{display:inline-flex;align-items:center;padding:3px 9px;border-radius:6px;font-size:11px;font-weight:600;background:rgba(56,189,248,.1);color:var(--teal);border:1px solid rgba(56,189,248,.2);}
.act-btns{display:flex;gap:6px;flex-wrap:wrap;}
.ab{padding:5px 11px;border-radius:6px;font-size:11.5px;font-weight:600;border:none;cursor:pointer;transition:all .16s;}
.ab:hover{transform:translateY(-1px);}
.ab-edit{background:rgba(56,189,248,.12);color:var(--teal);border:1px solid rgba(56,189,248,.2);}
.ab-edit:hover{background:rgba(56,189,248,.22);}
.ab-bill{background:rgba(201,169,110,.12);color:var(--gold);border:1px solid rgba(201,169,110,.2);}
.ab-bill:hover{background:rgba(201,169,110,.22);}
.ab-del{background:rgba(239,68,68,.1);color:var(--red);border:1px solid rgba(239,68,68,.2);}
.ab-del:hover{background:rgba(239,68,68,.22);}
.empty{text-align:center;padding:56px 24px;}
.empty .ei{font-size:48px;margin-bottom:14px;opacity:.4;}
.empty h3{font-size:16px;color:var(--dim);}
.empty p{font-size:13px;color:var(--dim2);margin-top:6px;}

/* MODALS */
.overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.72);z-index:200;align-items:center;justify-content:center;padding:20px;backdrop-filter:blur(4px);}
.overlay.open{display:flex;}
.modal{background:var(--card);border:1px solid var(--border2);border-radius:var(--r);padding:28px 32px;width:100%;max-width:520px;position:relative;animation:mu .25s cubic-bezier(.34,1.56,.64,1) both;max-height:90vh;overflow-y:auto;}
@keyframes mu{from{opacity:0;transform:translateY(20px) scale(.96);}to{opacity:1;transform:none;}}
.mc{position:absolute;top:16px;right:16px;background:rgba(255,255,255,.07);border:none;color:var(--dim);width:28px;height:28px;border-radius:50%;cursor:pointer;font-size:14px;display:flex;align-items:center;justify-content:center;transition:all .16s;}
.mc:hover{background:rgba(239,68,68,.2);color:var(--red);}
.m-title{font-size:18px;font-weight:700;margin-bottom:4px;}
.m-title span{color:var(--gold);}
.m-sub{font-size:12.5px;color:var(--dim);margin-bottom:20px;}
.m-div{height:1px;background:var(--border);margin-bottom:20px;}
.fg{margin-bottom:14px;}
.fg label{display:block;font-size:12px;font-weight:600;color:var(--dim);text-transform:uppercase;letter-spacing:.7px;margin-bottom:6px;}
.fg label .req{color:var(--red);margin-left:2px;}
.fc{width:100%;background:var(--card2);border:1px solid var(--border2);border-radius:var(--rs);color:var(--text);font-size:13.5px;padding:9px 13px;outline:none;transition:border-color .18s;}
.fc:focus{border-color:var(--gold);}
.fc::placeholder{color:var(--dim2);}
select.fc option{background:#0e1521;}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.m-actions{display:flex;justify-content:flex-end;gap:10px;margin-top:22px;padding-top:16px;border-top:1px solid var(--border);}
.btn-save{padding:9px 22px;background:linear-gradient(135deg,var(--gold),var(--gold-d));color:#000;border:none;border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;transition:all .18s;}
.btn-save:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(201,169,110,.3);}
.btn-cancel{padding:9px 18px;background:rgba(255,255,255,.06);border:1px solid var(--border2);border-radius:var(--rs);color:var(--dim);font-size:13px;font-weight:600;cursor:pointer;transition:all .18s;}
.btn-cancel:hover{background:rgba(255,255,255,.1);color:var(--text);}
.del-info{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);border-radius:var(--rs);padding:12px 16px;font-size:13px;color:#f87171;margin-bottom:10px;}
.btn-del{padding:9px 22px;background:linear-gradient(135deg,var(--red),#b91c1c);color:#fff;border:none;border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;transition:all .18s;}
.btn-del:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(239,68,68,.3);}

/* BILL MODAL */
.bill-header{text-align:center;margin-bottom:20px;}
.bill-header h3{font-size:20px;font-weight:700;color:var(--gold);}
.bill-header p{font-size:12px;color:var(--dim);margin-top:3px;}
.bill-info{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:16px;}
.bi-row{background:rgba(255,255,255,.04);border-radius:var(--rs);padding:10px 12px;}
.bi-lbl{font-size:10px;color:var(--dim2);text-transform:uppercase;letter-spacing:.7px;margin-bottom:3px;}
.bi-val{font-size:13px;font-weight:600;}
.bill-table{width:100%;border-collapse:collapse;margin-bottom:4px;}
.bill-table td{padding:9px 12px;font-size:13px;border-bottom:1px solid var(--border);}
.bill-table tr:last-child td{border-bottom:none;}
.bill-table .bl{color:var(--dim);}
.bill-table .br{text-align:right;font-family:'JetBrains Mono',monospace;}
.bill-total{background:rgba(201,169,110,.08);border:1px solid rgba(201,169,110,.2);border-radius:var(--rs);padding:12px 16px;display:flex;justify-content:space-between;align-items:center;margin-top:10px;}
.bill-total .tl{font-size:14px;font-weight:700;color:var(--gold);}
.bill-total .tv{font-family:'JetBrains Mono',monospace;font-size:22px;font-weight:700;color:var(--gl);}
.btn-print{padding:9px 22px;background:rgba(201,169,110,.15);border:1px solid rgba(201,169,110,.3);color:var(--gold);border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;transition:all .18s;}
.btn-print:hover{background:rgba(201,169,110,.25);}

/* PRINT */
@media print{
  body *{visibility:hidden;}
  #billModal,#billModal *{visibility:visible;}
  #billModal{position:fixed;inset:0;display:flex!important;background:white;padding:0;align-items:center;justify-content:center;}
  #billModal .modal{background:white;color:black;border:none;box-shadow:none;padding:40px;max-width:100%;border-radius:0;max-height:none;}
  #billModal .mc,#billModal .m-actions{display:none!important;}
  #billModal .bill-header h3{color:#8B6914;}
  #billModal .bi-row{background:#f5f0e8;border:1px solid #d4b483;}
  #billModal .bi-lbl{color:#666;}
  #billModal .bi-val{color:#111;}
  #billModal .bill-total{background:#f5f0e8;border-color:#d4b483;}
  #billModal .bill-total .tl{color:#8B6914;}
  #billModal .bill-total .tv{color:#111;}
}

@media(max-width:900px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}.kpis{grid-template-columns:1fr 1fr;}}
@media(max-width:600px){.content{padding:16px;}.kpis{grid-template-columns:1fr;}.form-row{grid-template-columns:1fr;}}
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="s-logo">
    <span class="icon">🌊</span>
    <div class="title">Ocean View Resort</div>
    <div class="sub">Admin Portal</div>
  </div>
  <nav class="s-nav">
    <div class="s-sec">Main</div>
    <a class="s-item" href="AdminDashboard"><div class="s-icon">📊</div> Dashboard</a>
    <a class="s-item active" href="AdminViewReservation">
      <div class="s-icon">📋</div> Reservations
      <span class="s-badge"><%= totalCount %></span>
    </a>
    <a class="s-item" href="UserManagement"><div class="s-icon">👥</div> Users &amp; Staff</a>
    <div class="s-sec">Operations</div>
    <a class="s-item" href="calculateBill.jsp"><div class="s-icon">🧾</div> Bill Calculator</a>
    <a class="s-item" href="adminReports.jsp"><div class="s-icon">📈</div> Reports</a>
    <div class="s-sec">System</div>
    <a class="s-item" href="adminSettings.jsp"><div class="s-icon">⚙️</div> Settings</a>
  </nav>
  <div class="s-foot">
    <div class="u-card">
      <div class="u-av"><%= adminName.length() > 0 ? String.valueOf(adminName.charAt(0)).toUpperCase() : "A" %></div>
      <div>
        <div class="u-name"><%= adminName %></div>
        <div class="u-role">Administrator</div>
      </div>
    </div>
    <a class="logout" href="logout">↩ Sign Out</a>
  </div>
</aside>

<!-- MAIN -->
<div class="main">
  <div class="topbar">
    <div class="t-title">Reservation <span>Management</span></div>
    <div class="t-pill"><div class="dot"></div> ⚙️ Admin Access</div>
  </div>

  <div class="content">

    <!-- Flash -->
    <% if (flashOk != null) { %>
      <div class="flash f-ok" id="flashMsg">✅ <%= flashOk %></div>
    <% } %>
    <% if (flashErr != null) { %>
      <div class="flash f-err" id="flashMsg">⚠ <%= flashErr %></div>
    <% } %>

    <!-- Page Header -->
    <div class="ph">
      <div>
        <h1>Manage <span>Reservations</span></h1>
        <p>Add, edit, delete and generate bills for all reservations.</p>
      </div>
      <button class="btn-add" onclick="openAdd()">➕ Add Reservation</button>
    </div>

    <!-- KPI Cards -->
    <div class="kpis">
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">📋</div><span class="kpi-badge kb1">Total</span></div>
        <div class="kpi-num kn1"><%= totalCount %></div>
        <div class="kpi-label">Total reservations</div>
      </div>
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">🔍</div><span class="kpi-badge kb2">Showing</span></div>
        <div class="kpi-num kn2"><%= reservations.size() %></div>
        <div class="kpi-label">Results displayed</div>
      </div>
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">⚙️</div><span class="kpi-badge kb3">Access</span></div>
        <div class="kpi-num kn3" style="font-size:18px;padding-top:6px;">Admin</div>
        <div class="kpi-label">Full CRUD access</div>
      </div>
    </div>

    <!-- Table Card -->
    <div class="tbl-card">
      <div class="tbl-head">
        <div>
          <h2>Reservation <span>List</span></h2>
          <p>Showing <%= reservations.size() %> record(s)
            <% if (!search.isEmpty()) { %> — matching "<strong><%= search %></strong>"<% } %>
          </p>
        </div>
        <form method="GET" action="AdminViewReservation">
          <div class="srch">
            <input type="text" name="search" placeholder="Search by no, name, contact…"
                   value="<%= search %>" autocomplete="off"/>
            <button type="submit">🔍</button>
            <% if (!search.isEmpty()) { %>
              <a href="AdminViewReservation">✕</a>
            <% } %>
          </div>
        </form>
      </div>

      <!-- Table -->
      <% if (reservations.isEmpty()) { %>
        <div class="empty">
          <div class="ei">📋</div>
          <h3>No reservations found</h3>
          <p><% if (!search.isEmpty()) { %>No records match "<%= search %>". Try a different search.<% } else { %>No reservations yet. Click "Add Reservation" to get started.<% } %></p>
        </div>
      <% } else { %>
        <table>
          <thead>
            <tr>
              <th>#</th><th>Res. No</th><th>Guest Name</th><th>Contact</th>
              <th>Room Type</th><th>Check-In</th><th>Check-Out</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% int row = 1;
               for (String[] r : reservations) {
                 // r[0]=res_no, r[1]=guest_name, r[2]=address, r[3]=contact
                 // r[4]=room_type, r[5]=checkin, r[6]=checkout
                 String rnJs  = r[0].replace("'", "\\'");
                 String gnJs  = r[1].replace("'", "\\'");
                 String adJs  = r[2].replace("'", "\\'");
                 String ctJs  = r[3].replace("'", "\\'");
                 String rtJs  = r[4].replace("'", "\\'");
            %>
            <tr>
              <td style="color:var(--dim);font-size:12px;font-family:'JetBrains Mono',monospace;"><%= row++ %></td>
              <td><span class="td-rno"><%= r[0] %></span></td>
              <td><strong><%= r[1] %></strong><br/><span style="font-size:11px;color:var(--dim2);"><%= r[2] %></span></td>
              <td style="font-size:12px;"><%= r[3] %></td>
              <td><span class="room-chip">🏨 <%= r[4] %></span></td>
              <td style="font-size:12px;color:var(--dim);font-family:'JetBrains Mono',monospace;"><%= r[5] %></td>
              <td style="font-size:12px;color:var(--dim);font-family:'JetBrains Mono',monospace;"><%= r[6] %></td>
              <td>
                <div class="act-btns">
                  <button class="ab ab-edit"
                    onclick="openEdit('<%= rnJs %>','<%= gnJs %>','<%= adJs %>','<%= ctJs %>','<%= rtJs %>','<%= r[5] %>','<%= r[6] %>')">
                    ✏️ Edit
                  </button>
                  <button class="ab ab-bill"
                    onclick="openBill('<%= rnJs %>','<%= gnJs %>','<%= adJs %>','<%= ctJs %>','<%= rtJs %>','<%= r[5] %>','<%= r[6] %>')">
                    🧾 Bill
                  </button>
                  <button class="ab ab-del"
                    onclick="openDel('<%= rnJs %>','<%= gnJs %>')">
                    🗑️ Delete
                  </button>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      <% } %>
    </div><!-- /tbl-card -->

  </div><!-- /content -->
</div><!-- /main -->


<!-- MODAL — ADD RESERVATION -->
<div class="overlay" id="addModal">
  <div class="modal">
    <button class="mc" onclick="closeAdd()">✕</button>
    <div class="m-title">Add <span>Reservation</span></div>
    <div class="m-sub">Enter guest and booking details below.</div>
    <div class="m-div"></div>
    <form method="POST" action="AdminViewReservation" onsubmit="return validateDates('add_ci','add_co')">
      <input type="hidden" name="action" value="add"/>
      <input type="hidden" name="search" value="<%= search %>"/>
      <div class="fg">
        <label>Reservation No <span class="req">*</span></label>
        <input class="fc" type="text" name="reservationNo" id="add_rno"
               placeholder="e.g. RES-001" required autocomplete="off"/>
      </div>
      <div class="fg">
        <label>Guest Name <span class="req">*</span></label>
        <input class="fc" type="text" name="guestName" placeholder="Full name" required/>
      </div>
      <div class="fg">
        <label>Address</label>
        <input class="fc" type="text" name="address" placeholder="Guest address"/>
      </div>
      <div class="fg">
        <label>Contact <span class="req">*</span></label>
        <input class="fc" type="text" name="contact" placeholder="Phone number" required/>
      </div>
      <div class="fg">
        <label>Room Type <span class="req">*</span></label>
        <select class="fc" name="roomType" required>
          <option value="">-- Select Room --</option>
          <option value="Standard">Standard ($80/night)</option>
          <option value="Deluxe">Deluxe ($150/night)</option>
          <option value="Family">Family ($180/night)</option>
          <option value="Ocean View">Ocean View ($220/night)</option>
          <option value="Suite">Suite ($250/night)</option>
        </select>
      </div>
      <div class="form-row">
        <div class="fg">
          <label>Check-In <span class="req">*</span></label>
          <input class="fc" type="date" name="checkin" id="add_ci" required/>
        </div>
        <div class="fg">
          <label>Check-Out <span class="req">*</span></label>
          <input class="fc" type="date" name="checkout" id="add_co" required/>
        </div>
      </div>
      <div class="m-actions">
        <button type="button" class="btn-cancel" onclick="closeAdd()">Cancel</button>
        <button type="submit" class="btn-save">✅ Add Reservation</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL — EDIT RESERVATION -->
<div class="overlay" id="editModal">
  <div class="modal">
    <button class="mc" onclick="closeEdit()">✕</button>
    <div class="m-title">Edit <span>Reservation</span></div>
    <div class="m-sub">Update the reservation details below.</div>
    <div class="m-div"></div>
    <form method="POST" action="AdminViewReservation" onsubmit="return validateDates('edit_ci','edit_co')">
      <input type="hidden" name="action"        value="edit"/>
      <input type="hidden" name="search"        value="<%= search %>"/>
      <input type="hidden" name="reservationNo" id="edit_rno"/>
      <div class="fg">
        <label>Reservation No</label>
        <input class="fc" type="text" id="edit_rno_display" disabled style="opacity:.5;"/>
      </div>
      <div class="fg">
        <label>Guest Name <span class="req">*</span></label>
        <input class="fc" type="text" name="guestName" id="edit_gn" required/>
      </div>
      <div class="fg">
        <label>Address</label>
        <input class="fc" type="text" name="address" id="edit_ad"/>
      </div>
      <div class="fg">
        <label>Contact <span class="req">*</span></label>
        <input class="fc" type="text" name="contact" id="edit_ct" required/>
      </div>
      <div class="fg">
        <label>Room Type <span class="req">*</span></label>
        <select class="fc" name="roomType" id="edit_rt" required>
          <option value="Standard">Standard ($80/night)</option>
          <option value="Deluxe">Deluxe ($150/night)</option>
          <option value="Family">Family ($180/night)</option>
          <option value="Ocean View">Ocean View ($220/night)</option>
          <option value="Suite">Suite ($250/night)</option>
        </select>
      </div>
      <div class="form-row">
        <div class="fg">
          <label>Check-In <span class="req">*</span></label>
          <input class="fc" type="date" name="checkin" id="edit_ci" required/>
        </div>
        <div class="fg">
          <label>Check-Out <span class="req">*</span></label>
          <input class="fc" type="date" name="checkout" id="edit_co" required/>
        </div>
      </div>
      <div class="m-actions">
        <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
        <button type="submit" class="btn-save">💾 Save Changes</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL — DELETE CONFIRM -->
<div class="overlay" id="delModal">
  <div class="modal" style="max-width:400px;">
    <button class="mc" onclick="closeDel()">✕</button>
    <div class="m-title" style="color:var(--red);">🗑️ Delete <span>Reservation</span></div>
    <div class="m-sub">This action is permanent and cannot be undone.</div>
    <div class="m-div"></div>
    <div class="del-info" id="del_label"></div>
    <p style="font-size:13px;color:var(--dim);margin-top:8px;">Are you sure you want to delete this reservation?</p>
    <div class="m-actions">
      <button type="button" class="btn-cancel" onclick="closeDel()">Cancel</button>
      <button type="button" class="btn-del" id="del_confirm">🗑️ Yes, Delete</button>
    </div>
  </div>
</div>


<!-- MODAL — BILL -->
<div class="overlay" id="billModal">
  <div class="modal" style="max-width:480px;">
    <button class="mc" onclick="closeBill()">✕</button>
    <div class="bill-header">
      <h3>🌊 Ocean View Resort</h3>
      <p>Guest Invoice &nbsp;|&nbsp; <span id="b_rno" style="font-family:'JetBrains Mono',monospace;color:var(--gold);"></span></p>
    </div>
    <div class="m-div"></div>
    <div class="bill-info">
      <div class="bi-row"><div class="bi-lbl">Guest Name</div><div class="bi-val" id="b_gn"></div></div>
      <div class="bi-row"><div class="bi-lbl">Contact</div><div class="bi-val" id="b_ct"></div></div>
      <div class="bi-row"><div class="bi-lbl">Address</div><div class="bi-val" id="b_ad"></div></div>
      <div class="bi-row"><div class="bi-lbl">Room Type</div><div class="bi-val" id="b_rt"></div></div>
      <div class="bi-row"><div class="bi-lbl">Check-In</div><div class="bi-val" id="b_ci"></div></div>
      <div class="bi-row"><div class="bi-lbl">Check-Out</div><div class="bi-val" id="b_co"></div></div>
    </div>
    <table class="bill-table">
      <tr><td class="bl">Room Charges (<span id="b_nights"></span> × <span id="b_rate"></span>)</td><td class="br" id="b_rc"></td></tr>
      <tr><td class="bl">Service Charge (10%)</td><td class="br" id="b_svc"></td></tr>
      <tr><td class="bl">Tax (8%)</td><td class="br" id="b_tax"></td></tr>
    </table>
    <div class="bill-total">
      <span class="tl">Total Amount</span>
      <span class="tv" id="b_total"></span>
    </div>
    <div class="m-actions">
      <button type="button" class="btn-cancel" onclick="closeBill()">Close</button>
      <button type="button" class="btn-print" onclick="window.print()">🖨️ Print Invoice</button>
    </div>
  </div>
</div>


<script>
/* Flash auto-dismiss */
(function(){
  var fm = document.getElementById('flashMsg');
  if(!fm) return;
  setTimeout(function(){
    fm.style.transition='opacity .5s';
    fm.style.opacity='0';
    setTimeout(function(){fm.remove();},500);
  },4500);
})();

function lock()  { document.body.style.overflow='hidden'; }
function unlock(){ document.body.style.overflow=''; }
function ov(id)  { return document.getElementById(id); }

/* Date validation */
function validateDates(ciId, coId){
  var ci = new Date(document.getElementById(ciId).value);
  var co = new Date(document.getElementById(coId).value);
  if(co <= ci){ alert('Check-out date must be after check-in date.'); return false; }
  return true;
}

/* ADD */
function openAdd(){
  ov('addModal').classList.add('open'); lock();
  setTimeout(function(){ document.getElementById('add_rno').focus(); },80);
}
function closeAdd(){ ov('addModal').classList.remove('open'); unlock(); }

/* EDIT */
function openEdit(rno,gn,ad,ct,rt,ci,co){
  document.getElementById('edit_rno').value         = rno;
  document.getElementById('edit_rno_display').value = rno;
  document.getElementById('edit_gn').value          = gn;
  document.getElementById('edit_ad').value          = ad;
  document.getElementById('edit_ct').value          = ct;
  document.getElementById('edit_ci').value          = ci;
  document.getElementById('edit_co').value          = co;
  var sel = document.getElementById('edit_rt');
  for(var i=0;i<sel.options.length;i++){
    if(sel.options[i].value === rt){ sel.selectedIndex=i; break; }
  }
  ov('editModal').classList.add('open'); lock();
}
function closeEdit(){ ov('editModal').classList.remove('open'); unlock(); }

/* DELETE */
var _dr='';
function openDel(rno,gn){
  _dr = rno;
  document.getElementById('del_label').textContent = rno + ' — ' + gn;
  document.getElementById('del_confirm').onclick = function(){
    window.location.href = 'AdminViewReservation?action=delete&reservation_no='
      + encodeURIComponent(_dr)
      + '<%= !search.isEmpty() ? "&search=" + search : "" %>';
  };
  ov('delModal').classList.add('open'); lock();
}
function closeDel(){ ov('delModal').classList.remove('open'); unlock(); }

/* BILL */
var rates = {standard:80, deluxe:150, family:180, 'ocean view':220, suite:250};
function getRate(rt){
  var k = rt.toLowerCase();
  for(var r in rates){ if(k.indexOf(r) >= 0) return rates[r]; }
  return 80;
}
function fmt(n){ return '$' + n.toFixed(2); }

function openBill(rno,gn,ad,ct,rt,ci,co){
  document.getElementById('b_rno').textContent = rno;
  document.getElementById('b_gn').textContent  = gn;
  document.getElementById('b_ct').textContent  = ct;
  document.getElementById('b_ad').textContent  = ad;
  document.getElementById('b_rt').textContent  = rt;
  document.getElementById('b_ci').textContent  = ci;
  document.getElementById('b_co').textContent  = co;

  var nights = 0;
  if(ci && co){
    var d = new Date(co) - new Date(ci);
    if(d > 0) nights = Math.round(d / 86400000);
  }
  var rate = getRate(rt);
  var rc   = rate * nights;
  var svc  = rc * 0.10;
  var tax  = rc * 0.08;
  var tot  = rc + svc + tax;

  document.getElementById('b_nights').textContent = nights + (nights===1?' night':' nights');
  document.getElementById('b_rate').textContent   = fmt(rate) + '/night';
  document.getElementById('b_rc').textContent     = fmt(rc);
  document.getElementById('b_svc').textContent    = fmt(svc);
  document.getElementById('b_tax').textContent    = fmt(tax);
  document.getElementById('b_total').textContent  = fmt(tot);

  ov('billModal').classList.add('open'); lock();
}
function closeBill(){ ov('billModal').classList.remove('open'); unlock(); }

/* Backdrop click to close */
['addModal','editModal','delModal','billModal'].forEach(function(id){
  ov(id).addEventListener('click',function(e){
    if(e.target===this){ this.classList.remove('open'); unlock(); }
  });
});

/* Escape key */
document.addEventListener('keydown',function(e){
  if(e.key==='Escape'){
    ['addModal','editModal','delModal','billModal'].forEach(function(id){
      ov(id).classList.remove('open');
    });
    unlock();
  }
});
</script>
</body>
</html>
