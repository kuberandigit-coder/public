<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName   = (String) session.getAttribute("user");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    char   initial    = Character.toUpperCase(userName.charAt(0));

    String profUser   = (String)  request.getAttribute("profileUsername");
    String profRole   = (String)  request.getAttribute("profileRole");
    Object totalResObj= request.getAttribute("profileTotalRes");
    int    totalRes   = totalResObj != null ? (int) totalResObj : 0;
    String dbErr      = (String)  request.getAttribute("dbErr");
    String pwOk       = (String)  request.getAttribute("pwOk");
    String pwErr      = (String)  request.getAttribute("pwErr");
    String delErr     = (String)  request.getAttribute("delErr");

    if (profUser == null) profUser = userName;
    if (profRole == null) profRole = "user";

    // Joined date: session creation time
    java.time.LocalDate today = java.time.LocalDate.now();
    String todayStr = today.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>My Profile — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;0,700;1,400;1,600&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root{
  --cream:#faf7f2;--cream2:#f4f0e8;--cream3:#ede7d9;
  --white:#ffffff;
  --navy:#0f1f3d;--navy2:#162847;
  --gold:#b8923a;--gold2:#d4a853;--gold3:#e8c878;--gold-lt:#f5e9cc;
  --teal:#0b5c6b;--teal2:#0e7a8a;
  --text:#1a1a2e;--text2:#3d3d52;--text3:#6b6b80;--text4:#9b9bae;
  --border:#e8e0d0;--border2:#d0c8b8;
  --green:#0d7a5c;--red:#c0392b;
  --shadow:rgba(15,31,61,0.08);--shadow2:rgba(15,31,61,0.16);
  --r:16px;--rs:10px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{font-family:'DM Sans',sans-serif;background:var(--cream);color:var(--text);
  min-height:100vh;-webkit-font-smoothing:antialiased;}
a{text-decoration:none;color:inherit;}

/* ── NAVBAR ────────────────────────────────── */
.navbar{position:fixed;top:0;width:100%;z-index:300;height:68px;
  background:rgba(250,247,242,.94);backdrop-filter:blur(16px);
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;padding:0 52px;
  box-shadow:0 2px 12px var(--shadow);}
.nav-brand{display:flex;align-items:center;gap:12px;flex:1;}
.nav-logo{width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,var(--navy),var(--teal));
  display:flex;align-items:center;justify-content:center;font-size:18px;}
.nav-name{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;
  color:var(--navy);letter-spacing:.04em;}
.nav-name em{color:var(--gold);font-style:italic;}
.nav-loc{font-size:10px;color:var(--text3);letter-spacing:.18em;text-transform:uppercase;}
.nav-right{display:flex;align-items:center;gap:12px;}
.btn-back{display:flex;align-items:center;gap:7px;padding:8px 20px;
  border-radius:100px;background:var(--cream2);
  border:1.5px solid var(--border2);color:var(--text2);
  font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;font-family:inherit;}
.btn-back:hover{background:var(--navy);color:#fff;border-color:var(--navy);}
.u-pill{display:flex;align-items:center;gap:8px;padding:5px 14px 5px 5px;
  background:var(--cream2);border:1px solid var(--border2);border-radius:100px;}
.u-av{width:30px;height:30px;border-radius:50%;
  background:linear-gradient(135deg,var(--teal),var(--gold2));
  display:flex;align-items:center;justify-content:center;
  font-size:12px;font-weight:700;color:#fff;}
.u-name{font-size:13px;font-weight:500;color:var(--text2);}

/* ── HERO BANNER ───────────────────────────── */
.hero{position:relative;margin-top:68px;overflow:hidden;
  background:linear-gradient(135deg,var(--navy) 0%,var(--navy2) 55%,var(--teal) 100%);
  padding:52px 52px 64px;}
.hero::before{content:'';position:absolute;inset:0;
  background:radial-gradient(ellipse 60% 80% at 80% 50%,rgba(184,146,58,.15),transparent 70%);}
.hero::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),transparent);}
.hero-deco{position:absolute;border-radius:50%;border:1px solid rgba(255,255,255,.05);}
.hd1{width:300px;height:300px;top:-80px;right:-60px;}
.hd2{width:160px;height:160px;bottom:-40px;right:260px;border-color:rgba(184,146,58,.12);}
.hero-inner{position:relative;z-index:2;max-width:1100px;margin:0 auto;
  display:flex;align-items:center;gap:32px;}
.hero-avatar{width:80px;height:80px;border-radius:50%;flex-shrink:0;
  background:linear-gradient(135deg,var(--teal2),var(--gold));
  display:flex;align-items:center;justify-content:center;
  font-size:30px;font-weight:700;color:#fff;
  border:3px solid rgba(255,255,255,.2);
  box-shadow:0 4px 24px rgba(0,0,0,.3);}
.hero-text{}
.hero-eyebrow{font-size:10px;font-weight:600;letter-spacing:.24em;
  text-transform:uppercase;color:var(--gold3);margin-bottom:8px;
  display:flex;align-items:center;gap:8px;}
.hero-eyebrow::before{content:'';width:20px;height:1px;background:var(--gold2);}
.hero-name{font-family:'Cormorant Garamond',serif;font-size:clamp(28px,3vw,42px);
  font-weight:400;color:#fff;letter-spacing:-.01em;margin-bottom:6px;}
.hero-name em{font-style:italic;color:var(--gold3);}
.hero-meta{display:flex;align-items:center;gap:14px;flex-wrap:wrap;}
.hero-tag{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;
  border-radius:100px;font-size:11px;font-weight:700;
  letter-spacing:.1em;text-transform:uppercase;}
.tag-guest{background:rgba(184,146,58,.2);border:1px solid rgba(184,146,58,.35);color:var(--gold3);}
.tag-active{background:rgba(34,197,94,.18);border:1px solid rgba(34,197,94,.3);color:#86efac;}
.tag-dot{width:6px;height:6px;border-radius:50%;background:#86efac;animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.3;}}
.hero-stats{margin-left:auto;display:flex;gap:20px;flex-shrink:0;}
.hs{background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.1);
  border-radius:var(--rs);padding:14px 22px;text-align:center;}
.hs-n{font-family:'DM Mono',monospace;font-size:22px;font-weight:500;color:var(--gold3);}
.hs-l{font-size:10px;color:rgba(255,255,255,.4);text-transform:uppercase;
  letter-spacing:.12em;margin-top:3px;}

/* ── PAGE CONTENT ──────────────────────────── */
.content{max-width:900px;margin:0 auto;padding:40px 52px 60px;
  display:flex;flex-direction:column;gap:24px;
  animation:fadeUp .45s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px);}to{opacity:1;}}

/* ── TOAST ─────────────────────────────────── */
.toast-ok{padding:14px 20px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;
  display:flex;align-items:center;gap:10px;}
.toast-err{padding:14px 20px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#fef2f2;border:1px solid #fecaca;color:#991b1b;
  display:flex;align-items:center;gap:10px;}

/* ── PANEL ─────────────────────────────────── */
.panel{background:var(--white);border:1px solid var(--border);
  border-radius:20px;overflow:hidden;box-shadow:0 2px 12px var(--shadow);}
.panel-head{padding:20px 28px;border-bottom:1px solid var(--border);
  background:linear-gradient(90deg,var(--cream2),var(--white));
  display:flex;align-items:center;gap:14px;}
.ph-ico{width:40px;height:40px;border-radius:10px;
  display:flex;align-items:center;justify-content:center;font-size:18px;
  background:var(--cream3);border:1px solid var(--border2);}
.ph-ico.danger{background:#fff0f0;border-color:#fecaca;}
.ph-title{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:600;
  color:var(--navy);letter-spacing:.01em;}
.ph-title em{font-style:italic;color:var(--teal);}
.ph-title.red em{color:var(--red);}
.ph-sub{font-size:12px;color:var(--text3);margin-top:2px;}
.panel-body{padding:24px 28px;}

/* ── INFO GRID ─────────────────────────────── */
.info-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
.info-item{background:var(--cream);border:1px solid var(--border);
  border-radius:var(--rs);padding:16px 20px;transition:border-color .2s;}
.info-item:hover{border-color:var(--border2);}
.info-item.full{grid-column:span 2;}
.ii-label{font-size:10px;font-weight:700;letter-spacing:.16em;
  text-transform:uppercase;color:var(--text4);margin-bottom:6px;
  display:flex;align-items:center;gap:6px;}
.ii-value{font-size:15px;font-weight:600;color:var(--text);}
.ii-value.mono{font-family:'DM Mono',monospace;font-size:14px;}
.ii-value.gold{color:var(--gold);font-family:'Cormorant Garamond',serif;font-size:17px;}
.ii-value.teal{color:var(--teal);}
.ii-badge{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;
  border-radius:100px;font-size:11px;font-weight:700;
  background:rgba(184,146,58,.12);border:1px solid rgba(184,146,58,.25);color:var(--gold);}

/* ── FORM ──────────────────────────────────── */
.fg{margin-bottom:18px;}
.fg:last-of-type{margin-bottom:0;}
.fg label{display:block;font-size:11px;font-weight:700;letter-spacing:.12em;
  text-transform:uppercase;color:var(--text3);margin-bottom:8px;}
.fc-wrap{position:relative;}
.fc-ico{position:absolute;left:14px;top:50%;transform:translateY(-50%);
  font-size:16px;pointer-events:none;}
.fc{width:100%;background:var(--cream);border:1.5px solid var(--border2);
  border-radius:var(--rs);color:var(--text);font-size:14.5px;
  padding:12px 14px 12px 44px;outline:none;
  transition:border-color .2s,box-shadow .2s;font-family:inherit;}
.fc:hover{border-color:var(--border2);}
.fc:focus{border-color:var(--teal);box-shadow:0 0 0 3px rgba(11,92,107,.1);}
.fc.red:focus{border-color:var(--red);box-shadow:0 0 0 3px rgba(192,57,43,.1);}
.fc::placeholder{color:var(--text4);}
.fc.valid{border-color:var(--green);}
.fc.bad{border-color:var(--red);}

/* Strength bar */
.pw-bar-wrap{height:3px;border-radius:2px;background:var(--border);overflow:hidden;margin-top:8px;}
.pw-bar{height:100%;border-radius:2px;width:0%;transition:width .3s,background .3s;}
.pw-hint{font-size:11px;color:var(--text4);margin-top:5px;}
.match-hint{font-size:11px;margin-top:5px;}

/* Divider */
.form-div-label{font-size:10px;font-weight:700;letter-spacing:.2em;
  text-transform:uppercase;color:var(--text4);
  display:flex;align-items:center;gap:10px;margin:20px 0 16px;}
.form-div-label::after{content:'';flex:1;height:1px;background:var(--border);}

/* Buttons */
.btn-save{display:flex;align-items:center;justify-content:center;gap:10px;
  padding:13px 28px;border-radius:var(--rs);
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;cursor:pointer;
  font-family:inherit;transition:all .22s;box-shadow:0 3px 14px var(--shadow);
  margin-top:20px;width:100%;}
.btn-save:hover{transform:translateY(-2px);box-shadow:0 8px 24px var(--shadow2);}
.btn-delete{background:linear-gradient(135deg,#c0392b,#96281b);}
.btn-delete:hover{box-shadow:0 8px 24px rgba(192,57,43,.35);}

/* Delete warning box */
.del-warning{background:#fff5f5;border:1.5px solid #fecaca;
  border-radius:var(--rs);padding:16px 20px;margin-bottom:22px;}
.dw-title{font-size:13px;font-weight:700;color:var(--red);margin-bottom:6px;}
.dw-body{font-size:12.5px;color:#7f1d1d;line-height:1.7;}
.dw-body ul{margin:6px 0 0 18px;}
.dw-body li{margin-bottom:2px;}

/* ── QUICK LINKS ─────────────────────────── */
.quick-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;}
.ql{background:var(--white);border:1px solid var(--border);border-radius:var(--rs);
  padding:16px 20px;display:flex;align-items:center;gap:12px;
  transition:all .2s;box-shadow:0 2px 8px var(--shadow);}
.ql:hover{border-color:var(--border2);transform:translateY(-2px);}
.ql-ico{font-size:20px;}
.ql-title{font-size:13px;font-weight:600;color:var(--navy);}
.ql-sub{font-size:11px;color:var(--text4);}
.ql-red{border-color:#fecaca;}
.ql-red:hover{background:#fef2f2;}
.ql-red .ql-title{color:var(--red);}

/* ── RESPONSIVE ────────────────────────────── */
@media(max-width:800px){
  .content{padding:32px 20px 40px;}
  .navbar{padding:0 18px;}
  .hero{padding:40px 20px 50px;}
  .hero-inner{flex-wrap:wrap;gap:20px;}
  .hero-stats{display:none;}
  .info-grid{grid-template-columns:1fr;}
  .info-item.full{grid-column:auto;}
  .quick-grid{grid-template-columns:1fr;}
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="nav-brand">
    <div class="nav-logo">🌊</div>
    <div>
      <div class="nav-name">Ocean <em>View</em> Resort</div>
      <div class="nav-loc">Galle, Sri Lanka</div>
    </div>
  </div>
  <div class="nav-right">
    <a href="home.jsp" class="btn-back">← Back to Portal</a>
    <div class="u-pill">
      <div class="u-av"><%= initial %></div>
      <span class="u-name"><%= userName %></span>
    </div>
  </div>
</nav>

<!-- HERO BANNER -->
<div class="hero">
  <div class="hero-deco hd1"></div>
  <div class="hero-deco hd2"></div>
  <div class="hero-inner">
    <div class="hero-avatar"><%= initial %></div>
    <div class="hero-text">
      <div class="hero-eyebrow">Guest Profile</div>
      <div class="hero-name"><em><%= profUser %></em></div>
      <div class="hero-meta">
        <span class="hero-tag tag-guest">✦ Guest Account</span>
        <span class="hero-tag tag-active"><span class="tag-dot"></span> Active</span>
      </div>
    </div>
    <div class="hero-stats">
      <div class="hs">
        <div class="hs-n"><%= totalRes %></div>
        <div class="hs-l">Reservations</div>
      </div>
      <div class="hs">
        <div class="hs-n"><%= todayStr.split(" ")[2] %></div>
        <div class="hs-l">Since Year</div>
      </div>
    </div>
  </div>
</div>

<!-- CONTENT -->
<div class="content">

  <!-- DB error -->
  <% if (dbErr != null && !dbErr.isEmpty()) { %>
  <div class="toast-err">🔌 Database error: <%= dbErr %></div>
  <% } %>

  <!-- Password messages -->
  <% if (pwOk != null) { %>
  <div class="toast-ok" id="flashMsg">✅ <%= pwOk %></div>
  <script>setTimeout(function(){var e=document.getElementById('flashMsg');if(e){e.style.transition='opacity .5s';e.style.opacity='0';setTimeout(function(){e.remove();},500);}},4500);</script>
  <% } %>
  <% if (pwErr != null) { %>
  <div class="toast-err">⚠️ <%= pwErr %></div>
  <% } %>

  <!-- Delete error -->
  <% if (delErr != null) { %>
  <div class="toast-err">⚠️ <%= delErr %></div>
  <% } %>

  <!-- ── ACCOUNT DETAILS PANEL ──────────────── -->
  <div class="panel">
    <div class="panel-head">
      <div class="ph-ico">👤</div>
      <div>
        <div class="ph-title">Account <em>Details</em></div>
        <div class="ph-sub">Your registered guest profile information</div>
      </div>
    </div>
    <div class="panel-body">
      <div class="info-grid">

        <div class="info-item">
          <div class="ii-label">👤 Username</div>
          <div class="ii-value mono"><%= profUser %></div>
        </div>

        <div class="info-item">
          <div class="ii-label">🛡️ Account Role</div>
          <div class="ii-value">
            <span class="ii-badge">✦ <%= profRole.toUpperCase() %></span>
          </div>
        </div>

        <div class="info-item">
          <div class="ii-label">📋 Total Reservations</div>
          <div class="ii-value gold"><%= totalRes %></div>
        </div>

        <div class="info-item">
          <div class="ii-label">📅 Today's Date</div>
          <div class="ii-value teal"><%= todayStr %></div>
        </div>

        <div class="info-item">
          <div class="ii-label">🔒 Password</div>
          <div class="ii-value mono" style="letter-spacing:.12em;color:var(--text4);">
            ● ● ● ● ● ● ● ●
          </div>
        </div>

        <div class="info-item">
          <div class="ii-label">✅ Account Status</div>
          <div class="ii-value" style="color:var(--green);font-weight:700;">Active</div>
        </div>

      </div>
    </div>
  </div>

  <!-- ── CHANGE PASSWORD PANEL ──────────────── -->
  <div class="panel">
    <div class="panel-head">
      <div class="ph-ico">🔐</div>
      <div>
        <div class="ph-title">Change <em>Password</em></div>
        <div class="ph-sub">Update your login password securely</div>
      </div>
    </div>
    <div class="panel-body">
      <form method="POST" action="UserProfile" onsubmit="return validatePw()">
        <input type="hidden" name="action" value="changePassword"/>

        <div class="fg">
          <label>Current Password</label>
          <div class="fc-wrap">
            <span class="fc-ico">🔑</span>
            <input class="fc" type="password" name="currentPassword"
                   placeholder="Enter your current password" required/>
          </div>
        </div>

        <div class="form-div-label">New Password</div>

        <div class="fg">
          <label>New Password</label>
          <div class="fc-wrap">
            <span class="fc-ico">🔒</span>
            <input class="fc" type="password" name="newPassword" id="pw_new"
                   placeholder="Min. 4 characters" required oninput="chkStr()"/>
          </div>
          <div class="pw-bar-wrap"><div class="pw-bar" id="pwBar"></div></div>
          <div class="pw-hint" id="pwHint">Enter a new password</div>
        </div>

        <div class="fg">
          <label>Confirm New Password</label>
          <div class="fc-wrap">
            <span class="fc-ico">✅</span>
            <input class="fc" type="password" name="confirmPassword" id="pw_conf"
                   placeholder="Repeat new password" required oninput="chkMatch()"/>
          </div>
          <div class="match-hint" id="matchHint"></div>
        </div>

        <button type="submit" class="btn-save">🔐 Update Password</button>
      </form>
    </div>
  </div>

  <!-- ── DELETE ACCOUNT PANEL ──────────────── -->
  <div class="panel">
    <div class="panel-head">
      <div class="ph-ico danger">🗑️</div>
      <div>
        <div class="ph-title red">Delete <em>Account</em></div>
        <div class="ph-sub">Permanently remove your account and all associated data</div>
      </div>
    </div>
    <div class="panel-body">
      <div class="del-warning">
        <div class="dw-title">⚠️ This action cannot be undone</div>
        <div class="dw-body">
          Deleting your account will permanently remove:
          <ul>
            <li>Your login credentials</li>
            <li>All your reservations (<strong><%= totalRes %></strong> booking<%= totalRes != 1 ? "s" : "" %>)</li>
            <li>All your profile information</li>
          </ul>
        </div>
      </div>
      <form method="POST" action="UserProfile" onsubmit="return confirmDel()">
        <input type="hidden" name="action" value="deleteAccount"/>
        <div class="fg">
          <label>Type DELETE to confirm</label>
          <div class="fc-wrap">
            <span class="fc-ico">⌨️</span>
            <input class="fc red" type="text" name="confirmDelete" id="delInput"
                   placeholder='Type "DELETE" in capitals' autocomplete="off"/>
          </div>
        </div>
        <button type="submit" class="btn-save btn-delete">🗑️ Permanently Delete My Account</button>
      </form>
    </div>
  </div>

  <!-- ── QUICK LINKS ────────────────────────── -->
  <div class="quick-grid">
    <a href="viewReservation.jsp" class="ql">
      <span class="ql-ico">📋</span>
      <div>
        <div class="ql-title">View Reservation</div>
        <div class="ql-sub">Check your booking</div>
      </div>
    </a>
    <a href="GuestInvoice" class="ql">
      <span class="ql-ico">🖨️</span>
      <div>
        <div class="ql-title">Print Invoice</div>
        <div class="ql-sub">Get your bill</div>
      </div>
    </a>
    <a href="logout" class="ql ql-red">
      <span class="ql-ico">↩️</span>
      <div>
        <div class="ql-title">Sign Out</div>
        <div class="ql-sub">End your session</div>
      </div>
    </a>
  </div>

</div><!-- /content -->

<script>
function chkStr(){
  var pw=document.getElementById('pw_new').value;
  var bar=document.getElementById('pwBar');
  var hint=document.getElementById('pwHint');
  var s=0;
  if(pw.length>=4)s++;if(pw.length>=8)s++;
  if(/[A-Z]/.test(pw))s++;if(/[0-9]/.test(pw))s++;if(/[^A-Za-z0-9]/.test(pw))s++;
  var c=['#ef4444','#f59e0b','#f59e0b','#0d7a5c','#0d7a5c'];
  var l=['Too short','Weak','Fair','Strong','Very Strong'];
  bar.style.width=(s/5*100)+'%';
  bar.style.background=c[s-1]||'#ef4444';
  hint.textContent=l[s-1]||'Enter a password';
  hint.style.color=c[s-1]||'var(--text4)';
  chkMatch();
}
function chkMatch(){
  var pw=document.getElementById('pw_new').value;
  var cf=document.getElementById('pw_conf').value;
  var h=document.getElementById('matchHint');
  var el=document.getElementById('pw_conf');
  if(!cf.length){h.textContent='';el.className='fc';return;}
  if(pw===cf){h.textContent='✓ Passwords match';h.style.color='#0d7a5c';el.className='fc valid';}
  else{h.textContent='✗ Passwords do not match';h.style.color='#c0392b';el.className='fc bad';}
}
function validatePw(){
  var pw=document.getElementById('pw_new').value;
  var cf=document.getElementById('pw_conf').value;
  if(pw.length<4){alert('New password must be at least 4 characters.');return false;}
  if(pw!==cf){alert('Passwords do not match.');return false;}
  return true;
}
function confirmDel(){
  var v=document.getElementById('delInput').value;
  if(v!=='DELETE'){alert('Please type DELETE (in capitals) to confirm.');return false;}
  return confirm('Are you absolutely sure? This action cannot be undone.');
}
</script>
</body>
</html>
