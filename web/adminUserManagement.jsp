<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    // ── All data set by UserManagementServlet.java ────────────
    // users array: [0]=username  [1]=password  [2]=role
    List<String[]> users = (List<String[]>) request.getAttribute("users");
    int    totalAll   = request.getAttribute("totalAll")   != null ? (int) request.getAttribute("totalAll")   : 0;
    int    totalUsers = request.getAttribute("totalUsers") != null ? (int) request.getAttribute("totalUsers") : 0;
    int    totalStaff = request.getAttribute("totalStaff") != null ? (int) request.getAttribute("totalStaff") : 0;
    String search     = (String) request.getAttribute("search");
    String adminName  = (String) request.getAttribute("adminName");
    String flashOk    = (String) request.getAttribute("flashOk");
    String flashErr   = (String) request.getAttribute("flashErr");

    if (adminName == null) { response.sendRedirect("login.jsp"); return; }
    if (search    == null) search = "";
    if (users     == null) users  = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>User Management — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root{
  --bg:#080c14;--sidebar:#050810;--card:#0e1521;--card2:#111926;
  --border:rgba(255,255,255,0.07);--border2:rgba(255,255,255,0.12);
  --gold:#c9a96e;--gl:#e8c98a;--gold-d:#a07840;
  --teal:#38bdf8;--green:#22c55e;--red:#ef4444;
  --text:#eef2f7;--dim:rgba(238,242,247,.55);--dim2:rgba(238,242,247,.28);
  --sw:240px;--r:14px;--rs:8px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
a{text-decoration:none;color:inherit;}
input,select,button{font-family:inherit;}
table{border-collapse:collapse;width:100%;}
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
.main{margin-left:var(--sw);flex:1;display:flex;flex-direction:column;animation:pageIn .35s ease both;}
@keyframes pageIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
.topbar{position:sticky;top:0;height:60px;background:rgba(8,12,20,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px;z-index:90;}
.t-title{font-size:16px;font-weight:700;flex:1;}
.t-title span{color:var(--gold);}
.t-pill{display:flex;align-items:center;gap:6px;padding:5px 12px;border-radius:20px;font-size:11.5px;font-weight:600;background:rgba(201,169,110,.1);border:1px solid rgba(201,169,110,.2);color:var(--gl);}
.dot{width:7px;height:7px;border-radius:50%;background:var(--gold);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:.3;}}
.content{padding:28px 32px;flex:1;}
.ph{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;}
.ph h1{font-size:22px;font-weight:700;}
.ph h1 span{color:var(--gold);}
.ph p{font-size:13px;color:var(--dim);margin-top:3px;}
.btn-add{display:flex;align-items:center;gap:7px;padding:10px 20px;border-radius:var(--rs);background:linear-gradient(135deg,var(--gold),var(--gold-d));color:#000;font-size:13px;font-weight:700;border:none;cursor:pointer;transition:all .18s;}
.btn-add:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(201,169,110,.35);}
.flash{display:flex;align-items:center;gap:10px;padding:13px 18px;border-radius:var(--rs);font-size:13.5px;font-weight:500;margin-bottom:20px;}
.f-ok {background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.25);color:#4ade80;}
.f-err{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.25);color:#f87171;}
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
.tbl-card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;}
.tbl-head{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);flex-wrap:wrap;gap:12px;}
.tbl-head h2{font-size:15px;font-weight:700;}
.tbl-head h2 span{color:var(--gold);}
.tbl-head p{font-size:12px;color:var(--dim);margin-top:2px;}
.srch{display:flex;align-items:center;background:var(--card2);border:1px solid var(--border2);border-radius:var(--rs);overflow:hidden;}
.srch input{background:transparent;border:none;outline:none;color:var(--text);font-size:13px;padding:9px 14px;width:210px;}
.srch input::placeholder{color:var(--dim2);}
.srch button{background:linear-gradient(135deg,var(--gold),var(--gold-d));border:none;cursor:pointer;padding:9px 14px;font-size:14px;color:#000;}
.srch a{display:flex;align-items:center;padding:9px 12px;color:var(--dim);font-size:12px;}
.srch a:hover{color:var(--red);}
table thead tr{background:rgba(201,169,110,.06);border-bottom:1px solid var(--border);}
table thead th{padding:12px 18px;font-size:11px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--dim);text-align:left;}
table tbody tr{border-bottom:1px solid var(--border);transition:background .15s;}
table tbody tr:last-child{border-bottom:none;}
table tbody tr:hover{background:rgba(255,255,255,.03);}
table tbody td{padding:14px 18px;font-size:13.5px;}
.td-num{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--dim);}
.rb{display:inline-flex;align-items:center;gap:5px;padding:4px 11px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;}
.rb-admin{background:rgba(201,169,110,.15);color:var(--gold);border:1px solid rgba(201,169,110,.25);}
.rb-staff{background:rgba(56,189,248,.15);color:var(--teal);border:1px solid rgba(56,189,248,.25);}
.rb-user {background:rgba(34,197,94,.15);color:var(--green);border:1px solid rgba(34,197,94,.25);}
.act-btns{display:flex;gap:6px;}
.ab{padding:5px 12px;border-radius:6px;font-size:11.5px;font-weight:600;border:none;cursor:pointer;transition:all .16s;}
.ab:hover{transform:translateY(-1px);}
.ab-edit{background:rgba(56,189,248,.12);color:var(--teal);border:1px solid rgba(56,189,248,.2);}
.ab-edit:hover{background:rgba(56,189,248,.22);}
.ab-del{background:rgba(239,68,68,.1);color:var(--red);border:1px solid rgba(239,68,68,.2);}
.ab-del:hover{background:rgba(239,68,68,.22);}
.empty{text-align:center;padding:56px 24px;}
.empty .ei{font-size:48px;margin-bottom:14px;opacity:.4;}
.empty h3{font-size:16px;color:var(--dim);}
.empty p{font-size:13px;color:var(--dim2);margin-top:6px;}
.overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.72);z-index:200;align-items:center;justify-content:center;padding:20px;backdrop-filter:blur(4px);}
.overlay.open{display:flex;}
.modal{background:var(--card);border:1px solid var(--border2);border-radius:var(--r);padding:28px 32px;width:100%;max-width:460px;position:relative;animation:mu .25s cubic-bezier(.34,1.56,.64,1) both;}
@keyframes mu{from{opacity:0;transform:translateY(20px) scale(.96);}to{opacity:1;transform:none;}}
.mc{position:absolute;top:16px;right:16px;background:rgba(255,255,255,.07);border:none;color:var(--dim);width:28px;height:28px;border-radius:50%;cursor:pointer;font-size:14px;display:flex;align-items:center;justify-content:center;}
.mc:hover{background:rgba(239,68,68,.2);color:var(--red);}
.m-title{font-size:18px;font-weight:700;margin-bottom:4px;}
.m-title span{color:var(--gold);}
.m-sub{font-size:12.5px;color:var(--dim);margin-bottom:20px;}
.m-div{height:1px;background:var(--border);margin-bottom:20px;}
.fg{margin-bottom:16px;}
.fg label{display:block;font-size:12px;font-weight:600;color:var(--dim);text-transform:uppercase;letter-spacing:.7px;margin-bottom:7px;}
.fg label .req{color:var(--red);margin-left:2px;}
.fc{width:100%;background:var(--card2);border:1px solid var(--border2);border-radius:var(--rs);color:var(--text);font-size:13.5px;padding:10px 14px;outline:none;transition:border-color .18s;}
.fc:focus{border-color:var(--gold);}
.fc::placeholder{color:var(--dim2);}
select.fc option{background:#0e1521;}
.hint{font-size:11px;color:var(--dim2);margin-top:4px;}
.role-cards{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:4px;}
.rc{border:2px solid var(--border2);border-radius:var(--rs);padding:10px 14px;cursor:pointer;transition:all .18s;display:flex;align-items:center;gap:8px;}
.rc input{display:none;}
.rc-icon{font-size:18px;}
.rc-label{font-size:13px;font-weight:600;}
.rc.rc-user:has(input:checked){border-color:var(--green);background:rgba(34,197,94,.08);}
.rc.rc-staff:has(input:checked){border-color:var(--teal);background:rgba(56,189,248,.08);}
.m-actions{display:flex;justify-content:flex-end;gap:10px;margin-top:24px;padding-top:18px;border-top:1px solid var(--border);}
.btn-save{padding:9px 22px;background:linear-gradient(135deg,var(--gold),var(--gold-d));color:#000;border:none;border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;transition:all .18s;}
.btn-save:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(201,169,110,.3);}
.btn-cancel{padding:9px 18px;background:rgba(255,255,255,.06);border:1px solid var(--border2);border-radius:var(--rs);color:var(--dim);font-size:13px;font-weight:600;cursor:pointer;}
.btn-cancel:hover{background:rgba(255,255,255,.1);color:var(--text);}
.del-info{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);border-radius:var(--rs);padding:12px 16px;font-size:13px;color:#f87171;margin-bottom:6px;}
.btn-del{padding:9px 22px;background:linear-gradient(135deg,var(--red),#b91c1c);color:#fff;border:none;border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;}
.btn-del:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(239,68,68,.3);}
@media(max-width:900px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}.kpis{grid-template-columns:1fr 1fr;}}
@media(max-width:600px){.content{padding:16px;}.kpis{grid-template-columns:1fr;}}
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
    <a class="s-item" href="AdminViewReservation"><div class="s-icon">📋</div> Reservations</a>
    <a class="s-item active" href="UserManagement">
      <div class="s-icon">👥</div> Users &amp; Staff
      <span class="s-badge"><%= totalAll %></span>
    </a>
    <div class="s-sec">Operations</div>
    <a class="s-item" href="calculateBill.jsp"><div class="s-icon">🧾</div> Bill Calculator</a>
    <div class="s-sec">System</div>
    <a class="s-item" href="adminSettings.jsp"><div class="s-icon">⚙️</div> Settings</a>
  </nav>
  <div class="s-foot">
    <div class="u-card">
      <div class="u-av"><%= String.valueOf(adminName.charAt(0)).toUpperCase() %></div>
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
    <div class="t-title">User <span>Management</span></div>
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

    <!-- Header -->
    <div class="ph">
      <div>
        <h1>Users &amp; <span>Staff</span></h1>
        <p>Manage all accounts — create, edit, or remove users and staff.</p>
      </div>
      <button class="btn-add" onclick="openAdd()">➕ Add Account</button>
    </div>

    <!-- KPI Cards -->
    <div class="kpis">
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">🗂️</div><span class="kpi-badge kb1">All Accounts</span></div>
        <div class="kpi-num kn1"><%= totalAll %></div>
        <div class="kpi-label">Total accounts in system</div>
      </div>
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">👤</div><span class="kpi-badge kb2">Guests</span></div>
        <div class="kpi-num kn2"><%= totalUsers %></div>
        <div class="kpi-label">Registered guest users</div>
      </div>
      <div class="kpi">
        <div class="kpi-top"><div class="kpi-icon">🪪</div><span class="kpi-badge kb3">Staff</span></div>
        <div class="kpi-num kn3"><%= totalStaff %></div>
        <div class="kpi-label">Active staff members</div>
      </div>
    </div>

    <!-- Table -->
    <div class="tbl-card">
      <div class="tbl-head">
        <div>
          <h2>Account <span>List</span></h2>
          <p>Showing <%= users.size() %> account(s)
            <% if (!search.isEmpty()) { %> — matching "<strong><%= search %></strong>"<% } %>
          </p>
        </div>
        <form method="GET" action="UserManagement">
          <div class="srch">
            <input type="text" name="search" placeholder="Search by username…"
                   value="<%= search %>" autocomplete="off"/>
            <button type="submit">🔍</button>
            <% if (!search.isEmpty()) { %>
              <a href="UserManagement">✕</a>
            <% } %>
          </div>
        </form>
      </div>

      <% if (users.isEmpty()) { %>
        <div class="empty">
          <div class="ei">👥</div>
          <h3>No accounts found</h3>
          <p><% if (!search.isEmpty()) { %>No match for "<%= search %>".<% } else { %>No accounts yet. Click "Add Account".<% } %></p>
        </div>
      <% } else { %>
        <table>
          <thead>
            <tr>
              <th>#</th><th>Username</th><th>Password</th><th>Role</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% int rowNum = 1;
               for (String[] u : users) {
                 // ✅ u[0]=username  u[1]=password  u[2]=role
                 String unameJs = u[0].replace("'", "\\'");
                 String uroleJs = u[2].replace("'", "\\'");
            %>
            <tr>
              <td class="td-num"><%= rowNum++ %></td>
              <td><strong><%= u[0] %></strong></td>
              <td style="font-family:'JetBrains Mono',monospace;letter-spacing:3px;color:var(--dim2);">••••••••</td>
              <td>
                <% if ("admin".equals(u[2])) { %>
                  <span class="rb rb-admin">⚙️ Admin</span>
                <% } else if ("staff".equals(u[2])) { %>
                  <span class="rb rb-staff">🪪 Staff</span>
                <% } else { %>
                  <span class="rb rb-user">👤 User</span>
                <% } %>
              </td>
              <td>
                <div class="act-btns">
                  <button class="ab ab-edit"
                    onclick="openEdit('<%= unameJs %>','<%= uroleJs %>')">✏️ Edit</button>
                  <% if (!"admin".equals(u[2])) { %>
                  <button class="ab ab-del"
                    onclick="openDel('<%= unameJs %>')">🗑️ Delete</button>
                  <% } %>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      <% } %>
    </div>

  </div>
</div>


<!-- MODAL — ADD -->
<div class="overlay" id="addModal">
  <div class="modal">
    <button class="mc" onclick="closeAdd()">✕</button>
    <div class="m-title">Add <span>Account</span></div>
    <div class="m-sub">Create a new guest user or staff member.</div>
    <div class="m-div"></div>
    <form method="POST" action="UserManagement" onsubmit="return validateAdd()">
      <input type="hidden" name="action" value="add"/>
      <input type="hidden" name="search" value="<%= search %>"/>
      <div class="fg">
        <label>Username <span class="req">*</span></label>
        <input class="fc" type="text" name="username" id="add_u" placeholder="e.g. john_doe" required autocomplete="off"/>
      </div>
      <div class="fg">
        <label>Password <span class="req">*</span></label>
        <input class="fc" type="password" name="password" id="add_p" placeholder="Set a password" required/>
      </div>
      <div class="fg">
        <label>Role <span class="req">*</span></label>
        <div class="role-cards">
          <label class="rc rc-user">
            <input type="radio" name="role" value="user" checked/>
            <span class="rc-icon">👤</span><span class="rc-label">Guest User</span>
          </label>
          <label class="rc rc-staff">
            <input type="radio" name="role" value="staff"/>
            <span class="rc-icon">🪪</span><span class="rc-label">Staff</span>
          </label>
        </div>
      </div>
      <div class="m-actions">
        <button type="button" class="btn-cancel" onclick="closeAdd()">Cancel</button>
        <button type="submit" class="btn-save">✅ Create Account</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL — EDIT -->
<div class="overlay" id="editModal">
  <div class="modal">
    <button class="mc" onclick="closeEdit()">✕</button>
    <div class="m-title">Edit <span>Account</span></div>
    <div class="m-sub">Leave password blank to keep current.</div>
    <div class="m-div"></div>
    <form method="POST" action="UserManagement" onsubmit="return validateEdit()">
      <input type="hidden" name="action"           value="edit"/>
      <input type="hidden" name="search"           value="<%= search %>"/>
      <input type="hidden" name="originalUsername" id="edit_orig"/>
      <div class="fg">
        <label>Username <span class="req">*</span></label>
        <input class="fc" type="text" name="username" id="edit_u" required autocomplete="off"/>
      </div>
      <div class="fg">
        <label>New Password</label>
        <input class="fc" type="password" name="password" id="edit_p" placeholder="Leave blank to keep current"/>
        <div class="hint">🔒 Only fill this to change the password.</div>
      </div>
      <div class="fg">
        <label>Role <span class="req">*</span></label>
        <select class="fc" name="role" id="edit_r">
          <option value="user">👤 Guest User</option>
          <option value="staff">🪪 Staff</option>
          <option value="admin">⚙️ Admin</option>
        </select>
      </div>
      <div class="m-actions">
        <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
        <button type="submit" class="btn-save">💾 Save Changes</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL — DELETE -->
<div class="overlay" id="delModal">
  <div class="modal" style="max-width:400px;">
    <button class="mc" onclick="closeDel()">✕</button>
    <div class="m-title" style="color:var(--red);">🗑️ Delete <span>Account</span></div>
    <div class="m-sub">This action is permanent and cannot be undone.</div>
    <div class="m-div"></div>
    <div class="del-info" id="del_label"></div>
    <p style="font-size:13px;color:var(--dim);margin-top:10px;">Are you sure you want to permanently delete this account?</p>
    <div class="m-actions">
      <button type="button" class="btn-cancel" onclick="closeDel()">Cancel</button>
      <button type="button" class="btn-del" id="del_confirm">🗑️ Yes, Delete</button>
    </div>
  </div>
</div>


<script>
(function(){
  var fm = document.getElementById('flashMsg');
  if(!fm) return;
  setTimeout(function(){ fm.style.transition='opacity .5s'; fm.style.opacity='0'; setTimeout(function(){fm.remove();},500); },4500);
})();

function lock()  { document.body.style.overflow='hidden'; }
function unlock(){ document.body.style.overflow=''; }
function ov(id)  { return document.getElementById(id); }

function openAdd(){ ov('add_u').value=''; ov('add_p').value=''; ov('addModal').classList.add('open'); lock(); setTimeout(function(){ov('add_u').focus();},80); }
function closeAdd(){ ov('addModal').classList.remove('open'); unlock(); }
function validateAdd(){
  if(!ov('add_u').value.trim()){ alert('Username is required.'); return false; }
  if(!ov('add_p').value.trim()){ alert('Password is required.'); return false; }
  return true;
}

function openEdit(username, role){
  ov('edit_orig').value = username;
  ov('edit_u').value    = username;
  ov('edit_p').value    = '';
  var sel = ov('edit_r');
  for(var i=0;i<sel.options.length;i++){ if(sel.options[i].value===role){ sel.selectedIndex=i; break; } }
  ov('editModal').classList.add('open'); lock();
  setTimeout(function(){ov('edit_u').focus();},80);
}
function closeEdit(){ ov('editModal').classList.remove('open'); unlock(); }
function validateEdit(){ if(!ov('edit_u').value.trim()){ alert('Username cannot be empty.'); return false; } return true; }

var _du='';
function openDel(username){
  _du = username;
  ov('del_label').textContent = 'Account: ' + username;
  ov('del_confirm').onclick = function(){
    window.location.href = 'UserManagement?action=delete&username=' + encodeURIComponent(_du)
      + '<%= !search.isEmpty() ? "&search=" + search : "" %>';
  };
  ov('delModal').classList.add('open'); lock();
}
function closeDel(){ ov('delModal').classList.remove('open'); unlock(); }

['addModal','editModal','delModal'].forEach(function(id){
  ov(id).addEventListener('click',function(e){ if(e.target===this){ this.classList.remove('open'); unlock(); } });
});
document.addEventListener('keydown',function(e){
  if(e.key==='Escape'){ ['addModal','editModal','delModal'].forEach(function(id){ ov(id).classList.remove('open'); }); unlock(); }
});
</script>
</body>
</html>
