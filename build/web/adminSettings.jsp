<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    String adminName = (String) request.getAttribute("adminName");
    String flashOk   = (String) request.getAttribute("flashOk");
    String flashErr  = (String) request.getAttribute("flashErr");
    int totalUsers   = request.getAttribute("totalUsers") != null ? (int) request.getAttribute("totalUsers") : 0;
    int totalRes     = request.getAttribute("totalRes")   != null ? (int) request.getAttribute("totalRes")   : 0;
    if (adminName == null) adminName = (String) sess.getAttribute("admin");

    java.util.function.BiFunction<String,String,String> cfg = (key, def) -> {
        Object v = request.getAttribute("s_" + key);
        return (v != null && !v.toString().isEmpty()) ? v.toString() : def;
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Settings — Ocean View Resort Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet"/>
<style>
:root{
  --bg:#06090f;--panel:#0b1120;--card:#0e1628;--card2:#0a1020;--input:#111827;
  --border:rgba(255,255,255,.06);--border2:rgba(255,255,255,.10);--border3:rgba(255,255,255,.16);
  --text:#f0f4ff;--dim:rgba(240,244,255,.50);--dim2:rgba(240,244,255,.25);--dim3:rgba(240,244,255,.10);
  --green:#22c55e;--red:#ef4444;--teal:#38bdf8;--amber:#f59e0b;--purple:#a78bfa;
  --ac:#d4a855;--al:#f0c878;--ad:#9a7030;--as:#7a5520;
  --ag1:rgba(212,168,85,.18);--ag2:rgba(212,168,85,.08);
  --abr:rgba(212,168,85,.25);--abr2:rgba(212,168,85,.12);--aglow:rgba(212,168,85,.35);
  --sw:220px;--r:14px;--rs:8px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html,body{height:100%;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;width:100%;overflow-x:hidden;}
a{text-decoration:none;color:inherit;}
input,select,button,textarea{font-family:inherit;}

/* SIDEBAR */
.sidebar{position:fixed;left:0;top:0;width:var(--sw);height:100vh;background:var(--panel);border-right:1px solid var(--border);display:flex;flex-direction:column;z-index:200;}
.s-logo{padding:22px 18px 18px;border-bottom:1px solid var(--border);}
.s-logo-wave{font-size:24px;display:block;margin-bottom:5px;}
.s-logo-name{font-size:13px;font-weight:700;color:var(--ac);}
.s-logo-sub{font-size:9px;color:var(--dim2);letter-spacing:2px;text-transform:uppercase;margin-top:2px;}
.s-nav{flex:1;padding:14px 10px;overflow-y:auto;}
.s-label{font-size:9px;font-weight:800;letter-spacing:2px;text-transform:uppercase;color:var(--dim2);padding:12px 8px 5px;}
.s-link{display:flex;align-items:center;gap:9px;padding:9px 10px;border-radius:var(--rs);font-size:13px;font-weight:500;color:var(--dim);transition:all .15s;margin-bottom:2px;border:1px solid transparent;}
.s-link:hover{background:var(--dim3);color:var(--text);}
.s-link.on{background:var(--ag2);color:var(--ac);border-color:var(--abr2);}
.s-link-icon{font-size:15px;width:18px;text-align:center;flex-shrink:0;}
.s-foot{padding:14px;border-top:1px solid var(--border);}
.s-user{display:flex;align-items:center;gap:9px;padding:9px 11px;background:var(--ag2);border:1px solid var(--abr2);border-radius:var(--rs);margin-bottom:8px;}
.s-av{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--ac),var(--ad));display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;color:#000;flex-shrink:0;}
.s-uname{font-size:12px;font-weight:700;}
.s-urole{font-size:10px;color:var(--ac);}
.s-logout{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:var(--rs);background:rgba(239,68,68,.07);border:1px solid rgba(239,68,68,.15);color:var(--red);font-size:12px;font-weight:600;transition:all .15s;}
.s-logout:hover{background:rgba(239,68,68,.15);}

/* MAIN */
.main{margin-left:var(--sw);flex:1;display:flex;flex-direction:column;min-width:0;min-height:100vh;}
.topbar{position:sticky;top:0;z-index:100;height:58px;background:rgba(6,9,15,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 28px;gap:14px;}
.tb-title{font-size:16px;font-weight:800;flex:1;letter-spacing:-.2px;}
.tb-title em{color:var(--ac);font-style:normal;}
.tb-badge{display:flex;align-items:center;gap:6px;padding:5px 14px;border-radius:20px;background:var(--ag2);border:1px solid var(--abr);font-size:11px;font-weight:700;color:var(--al);}
.tb-dot{width:6px;height:6px;border-radius:50%;background:var(--ac);animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.2;}}
.page{flex:1;padding:28px;display:flex;flex-direction:column;gap:22px;}

/* FLASH */
.flash{display:flex;align-items:center;gap:10px;padding:13px 18px;border-radius:var(--rs);font-size:13.5px;font-weight:500;}
.f-ok{background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.25);color:#4ade80;}
.f-err{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.25);color:#f87171;}

/* HERO */
.hero{display:flex;align-items:center;justify-content:space-between;padding:22px 28px;background:linear-gradient(135deg,var(--ag1),var(--ag2),transparent);border:1px solid var(--abr);border-radius:var(--r);position:relative;overflow:hidden;}
.hero::before{content:'';position:absolute;top:-50px;right:-50px;width:180px;height:180px;border-radius:50%;background:radial-gradient(circle,var(--aglow) 0%,transparent 70%);pointer-events:none;}
.hero-left{display:flex;align-items:center;gap:16px;}
.hero-icon{width:52px;height:52px;border-radius:var(--rs);background:linear-gradient(135deg,var(--ac),var(--ad));display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0;box-shadow:0 4px 20px var(--aglow);}
.hero h1{font-size:22px;font-weight:900;letter-spacing:-.3px;}
.hero h1 em{color:var(--ac);font-style:normal;}
.hero p{font-size:13px;color:var(--dim);margin-top:3px;}
.hero-stats{display:flex;gap:12px;flex-shrink:0;}
.hs{background:rgba(0,0,0,.3);border:1px solid var(--border2);border-radius:var(--rs);padding:10px 18px;text-align:center;}
.hs-num{font-family:'JetBrains Mono',monospace;font-size:20px;font-weight:800;color:var(--ac);}
.hs-lbl{font-size:10px;color:var(--dim2);text-transform:uppercase;letter-spacing:.8px;margin-top:2px;}

/* TABS */
.tabs{display:flex;gap:4px;background:var(--card2);border:1px solid var(--border);border-radius:var(--rs);padding:5px;width:fit-content;}
.tab{padding:9px 20px;border-radius:6px;font-size:13px;font-weight:600;cursor:pointer;border:none;background:transparent;color:var(--dim);transition:all .18s;display:flex;align-items:center;gap:7px;}
.tab:hover{color:var(--text);}
.tab.active{background:linear-gradient(135deg,var(--ac),var(--ad));color:#000;box-shadow:0 2px 12px var(--aglow);}

/* SETTINGS GRID */
.sg{display:grid;grid-template-columns:1fr 1fr;gap:22px;align-items:start;}

/* SETTING PANEL */
.sp{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;}
.sp-head{padding:18px 22px;border-bottom:1px solid var(--border);background:linear-gradient(90deg,var(--ag2),transparent);display:flex;align-items:center;gap:12px;}
.sp-head-icon{width:38px;height:38px;border-radius:var(--rs);background:var(--ag1);border:1px solid var(--abr);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;}
.sp-head h2{font-size:14px;font-weight:800;}
.sp-head h2 em{color:var(--ac);font-style:normal;}
.sp-head p{font-size:12px;color:var(--dim);margin-top:2px;}
.sp-body{padding:22px;}

/* FORM */
.fg{margin-bottom:16px;}
.fg:last-child{margin-bottom:0;}
label{display:block;font-size:11px;font-weight:700;color:var(--dim);text-transform:uppercase;letter-spacing:.8px;margin-bottom:7px;}
.req{color:var(--red);margin-left:2px;}
.fc{width:100%;background:var(--input);border:1.5px solid var(--border2);border-radius:var(--rs);color:var(--text);font-size:14px;padding:11px 14px;outline:none;transition:border-color .2s,box-shadow .2s;}
.fc:hover{border-color:var(--border3);}
.fc:focus{border-color:var(--ac);box-shadow:0 0 0 3px var(--ag2);}
.fc::placeholder{color:var(--dim2);}
.row2{display:grid;grid-template-columns:1fr 1fr;gap:14px;}

/* DIVIDER */
.div{height:1px;background:var(--border);margin:16px 0;}
.sec-label{font-size:10px;font-weight:800;letter-spacing:1.4px;text-transform:uppercase;color:var(--dim2);display:flex;align-items:center;gap:8px;margin:16px 0 12px;}
.sec-label::after{content:'';flex:1;height:1px;background:var(--border);}

/* BUTTONS */
.btn-save{display:flex;align-items:center;justify-content:center;gap:8px;padding:12px 24px;background:linear-gradient(135deg,var(--ac),var(--ad));color:#000;font-size:13px;font-weight:800;border:none;border-radius:var(--rs);cursor:pointer;transition:all .18s;box-shadow:0 3px 14px var(--aglow);width:100%;margin-top:20px;}
.btn-save:hover{transform:translateY(-2px);box-shadow:0 6px 20px var(--aglow);}

/* INFO CARD */
.ic{background:var(--card2);border:1px solid var(--border);border-radius:var(--rs);padding:13px 16px;display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;}
.ic:last-child{margin-bottom:0;}
.ic-lbl{font-size:12px;color:var(--dim);display:flex;align-items:center;gap:7px;}
.ic-val{font-size:13px;font-weight:700;color:var(--al);font-family:'JetBrains Mono',monospace;}

/* STATUS DOT */
.sdot{width:8px;height:8px;border-radius:50%;display:inline-block;}
.sdot.on{background:var(--green);box-shadow:0 0 6px var(--green);}
.sdot.off{background:var(--red);box-shadow:0 0 6px var(--red);}

/* PW STRENGTH */
.pw-bar-wrap{height:4px;border-radius:2px;background:var(--border2);overflow:hidden;margin-top:8px;}
.pw-bar{height:100%;border-radius:2px;width:0%;transition:width .3s,background .3s;}
.pw-hint{font-size:11px;color:var(--dim2);margin-top:5px;}

/* DANGER ZONE */
.dz{border:1px solid rgba(239,68,68,.2);border-radius:var(--r);overflow:hidden;}
.dz-top{padding:14px 22px;background:rgba(239,68,68,.06);border-bottom:1px solid rgba(239,68,68,.15);display:flex;align-items:center;gap:10px;}
.dz-top h3{font-size:14px;font-weight:800;color:var(--red);}
.dz-top p{font-size:12px;color:rgba(239,68,68,.6);margin-top:2px;}
.dz-body{padding:18px 22px;display:flex;flex-direction:column;gap:10px;}
.dz-row{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;background:var(--card2);border:1px solid rgba(239,68,68,.1);border-radius:var(--rs);}
.dz-row h4{font-size:13px;font-weight:700;}
.dz-row p{font-size:11px;color:var(--dim);margin-top:2px;}
.dz-btn{padding:7px 16px;background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.25);color:var(--red);font-size:12px;font-weight:700;border-radius:6px;cursor:pointer;transition:all .15s;white-space:nowrap;flex-shrink:0;margin-left:16px;text-decoration:none;display:inline-block;}
.dz-btn:hover{background:rgba(239,68,68,.2);}

/* PANES */
.pane{display:none;}
.pane.active{display:contents;}

@media(max-width:1000px){.sg{grid-template-columns:1fr;}}
@media(max-width:800px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}}
@media(max-width:600px){.page{padding:16px;}.row2{grid-template-columns:1fr;}.hero-stats{display:none;}.tabs{width:100%;flex-wrap:wrap;}}
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
    <div class="s-label">Main</div>
    <a class="s-link" href="AdminDashboard"><span class="s-link-icon">📊</span> Dashboard</a>
    <a class="s-link" href="AdminViewReservation"><span class="s-link-icon">📋</span> Reservations</a>
    <a class="s-link" href="UserManagement"><span class="s-link-icon">👥</span> Users &amp; Staff</a>
    <div class="s-label">Operations</div>
    <a class="s-link" href="calculateBill.jsp"><span class="s-link-icon">🧾</span> Bill Calculator</a>
    <a class="s-link" href="AdminReports"><span class="s-link-icon">📈</span> Reports</a>
    <div class="s-label">System</div>
    <a class="s-link on" href="AdminSettings"><span class="s-link-icon">⚙️</span> Settings</a>
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
    <div class="tb-title">Admin <em>Settings</em></div>
    <div class="tb-badge"><div class="tb-dot"></div> ⚙️ System Configuration</div>
  </div>

  <div class="page">

    <% if (flashOk  != null) { %><div class="flash f-ok"  id="flashMsg">✅ <%= flashOk  %></div><% } %>
    <% if (flashErr != null) { %><div class="flash f-err" id="flashMsg">⚠ <%= flashErr %></div><% } %>

    <!-- HERO -->
    <div class="hero">
      <div class="hero-left">
        <div class="hero-icon">⚙️</div>
        <div>
          <h1>System <em>Settings</em></h1>
          <p>Manage your profile, security and system configuration.</p>
        </div>
      </div>
      <div class="hero-stats">
        <div class="hs"><div class="hs-num"><%= totalUsers %></div><div class="hs-lbl">Users</div></div>
        <div class="hs"><div class="hs-num"><%= totalRes %></div><div class="hs-lbl">Reservations</div></div>
        <div class="hs"><div class="hs-num">v1.0</div><div class="hs-lbl">Version</div></div>
      </div>
    </div>

    <!-- TABS — 3 tabs only -->
    <div class="tabs">
      <button class="tab active" onclick="showTab('profile',this)">👤 Profile</button>
      <button class="tab" onclick="showTab('system',this)">🖥️ System Info</button>
      <button class="tab" onclick="showTab('danger',this)">⚠️ Danger Zone</button>
    </div>

    <!-- ═══════════════════════════════════════════════
         TAB 1 — PROFILE
    ════════════════════════════════════════════════ -->
    <div id="pane_profile" class="pane active">
      <div class="sg">

        <!-- Update Username -->
        <div class="sp">
          <div class="sp-head">
            <div class="sp-head-icon">👤</div>
            <div><h2>Admin <em>Profile</em></h2><p>Update your login username</p></div>
          </div>
          <div class="sp-body">
            <div class="ic" style="margin-bottom:18px;">
              <span class="ic-lbl">Currently logged in as</span>
              <span class="ic-val"><%= adminName %></span>
            </div>
            <form method="POST" action="AdminSettings">
              <input type="hidden" name="action" value="updateProfile"/>
              <div class="fg">
                <label>New Username <span class="req">*</span></label>
                <input class="fc" type="text" name="newUsername" value="<%= adminName %>" required autocomplete="off"/>
              </div>
              <div class="fg">
                <label>Role</label>
                <input class="fc" value="Administrator" disabled style="opacity:.45;cursor:not-allowed;"/>
              </div>
              <button type="submit" class="btn-save">💾 Save Profile</button>
            </form>
          </div>
        </div>

        <!-- Change Password -->
        <div class="sp">
          <div class="sp-head">
            <div class="sp-head-icon">🔐</div>
            <div><h2>Change <em>Password</em></h2><p>Update your admin account password</p></div>
          </div>
          <div class="sp-body">
            <form method="POST" action="AdminSettings" onsubmit="return validatePw()">
              <input type="hidden" name="action" value="changePassword"/>
              <div class="fg">
                <label>Current Password <span class="req">*</span></label>
                <input class="fc" type="password" name="currentPassword" placeholder="Current password" required/>
              </div>
              <div class="sec-label">New Password</div>
              <div class="fg">
                <label>New Password <span class="req">*</span></label>
                <input class="fc" type="password" name="newPassword" id="pw_new"
                       placeholder="Min. 4 characters" required oninput="checkPw()"/>
                <div class="pw-bar-wrap"><div class="pw-bar" id="pw_bar"></div></div>
                <div class="pw-hint" id="pw_hint">Enter a new password</div>
              </div>
              <div class="fg">
                <label>Confirm Password <span class="req">*</span></label>
                <input class="fc" type="password" name="confirmPassword" id="pw_conf"
                       placeholder="Repeat new password" required/>
              </div>
              <button type="submit" class="btn-save">🔑 Change Password</button>
            </form>
          </div>
        </div>

      </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         TAB 2 — SYSTEM INFO
    ════════════════════════════════════════════════ -->
    <div id="pane_system" class="pane">
      <div class="sg">

        <!-- Application Info -->
        <div class="sp">
          <div class="sp-head">
            <div class="sp-head-icon">🖥️</div>
            <div><h2>Application <em>Info</em></h2><p>Runtime and environment details</p></div>
          </div>
          <div class="sp-body">
            <div class="ic">
              <span class="ic-lbl">🏨 Application</span>
              <span class="ic-val">Ocean View Resort</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🔖 Version</span>
              <span class="ic-val">v1.0.0</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">☕ Java Version</span>
              <span class="ic-val"><%= System.getProperty("java.version") %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🌐 Java Vendor</span>
              <span class="ic-val" style="font-size:11px;"><%= System.getProperty("java.vendor").split(" ")[0] %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🖥️ Server</span>
              <span class="ic-val"><%= application.getServerInfo().split("/")[0].trim() %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">📦 Servlet API</span>
              <span class="ic-val"><%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🗄️ Database</span>
              <span class="ic-val">MySQL · mydb</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🏛️ Architecture</span>
              <span class="ic-val">MVC · Servlet/JSP</span>
            </div>
          </div>
        </div>

        <!-- Session & Stats -->
        <div class="sp">
          <div class="sp-head">
            <div class="sp-head-icon">📊</div>
            <div><h2>Session &amp; <em>Statistics</em></h2><p>Current session and live data summary</p></div>
          </div>
          <div class="sp-body">
            <div class="ic">
              <span class="ic-lbl"><span class="sdot on"></span> &nbsp;System Status</span>
              <span class="ic-val" style="color:var(--green);">Online</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">👤 Logged In As</span>
              <span class="ic-val"><%= adminName %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🛡️ Role</span>
              <span class="ic-val">ADMIN</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🔑 Session ID</span>
              <span class="ic-val" style="font-size:10px;letter-spacing:.5px;">
                <%= sess.getId().substring(0,16) %>…
              </span>
            </div>

            <div class="div"></div>
            <div class="sec-label">Live Database Stats</div>

            <div class="ic">
              <span class="ic-lbl">👥 Total Users</span>
              <span class="ic-val"><%= totalUsers %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">📋 Total Reservations</span>
              <span class="ic-val"><%= totalRes %></span>
            </div>
            <div class="ic">
              <span class="ic-lbl">🏨 Room Types</span>
              <span class="ic-val">5</span>
            </div>
            <div class="ic">
              <span class="ic-lbl">💱 Default Currency</span>
              <span class="ic-val">USD</span>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         TAB 3 — DANGER ZONE
    ════════════════════════════════════════════════ -->
    <div id="pane_danger" class="pane">
      <div class="dz">
        <div class="dz-top">
          <span style="font-size:22px;">⚠️</span>
          <div>
            <h3>Danger Zone</h3>
            <p>Irreversible actions — proceed with extreme caution.</p>
          </div>
        </div>
        <div class="dz-body">

          <div class="dz-row">
            <div>
              <h4>Sign Out of All Sessions</h4>
              <p>End your current admin session and return to the login page.</p>
            </div>
            <a class="dz-btn" href="logout">🚪 Sign Out</a>
          </div>

          <div class="dz-row">
            <div>
              <h4>Clear All Reservations</h4>
              <p>Permanently delete every reservation record. This cannot be undone.</p>
            </div>
            <button class="dz-btn"
              onclick="alert('Contact your DBA to execute this operation safely.')">
              🗑️ Clear Data
            </button>
          </div>

          <div class="dz-row">
            <div>
              <h4>Export Database</h4>
              <p>Download a full backup of reservation and user data.</p>
            </div>
            <button class="dz-btn" onclick="alert('Export feature coming soon.')">
              📤 Export
            </button>
          </div>

        </div>
      </div>
    </div>

  </div><!-- /page -->
</div><!-- /main -->

<script>
/* Auto-dismiss flash */
(function(){
  var fm = document.getElementById('flashMsg');
  if(!fm) return;
  setTimeout(function(){
    fm.style.transition='opacity .5s';
    fm.style.opacity='0';
    setTimeout(function(){ fm.remove(); }, 500);
  }, 4500);
})();

/* Tab switcher */
function showTab(name, btn){
  document.querySelectorAll('.pane').forEach(function(p){ p.classList.remove('active'); });
  document.querySelectorAll('.tab').forEach(function(t){ t.classList.remove('active'); });
  document.getElementById('pane_' + name).classList.add('active');
  btn.classList.add('active');
}

/* Password strength */
function checkPw(){
  var pw   = document.getElementById('pw_new').value;
  var bar  = document.getElementById('pw_bar');
  var hint = document.getElementById('pw_hint');
  var s = 0;
  if(pw.length >= 4) s++;
  if(pw.length >= 8) s++;
  if(/[A-Z]/.test(pw)) s++;
  if(/[0-9]/.test(pw)) s++;
  if(/[^A-Za-z0-9]/.test(pw)) s++;
  var cols = ['#ef4444','#f59e0b','#f59e0b','#22c55e','#22c55e'];
  var lbls = ['Too short','Weak','Fair','Strong','Very strong'];
  bar.style.width      = (s / 5 * 100) + '%';
  bar.style.background = cols[s-1] || '#ef4444';
  hint.textContent     = lbls[s-1] || 'Enter a password';
  hint.style.color     = cols[s-1] || 'var(--dim2)';
}

/* Password validation */
function validatePw(){
  var nw = document.getElementById('pw_new').value;
  var cf = document.getElementById('pw_conf').value;
  if(nw.length < 4){ alert('Password must be at least 4 characters.'); return false; }
  if(nw !== cf)    { alert('Passwords do not match.'); return false; }
  return true;
}
</script>
</body>
</html>
