<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("user");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String suc = (String) session.getAttribute("successMessage");
    session.removeAttribute("successMessage");
    char initial = Character.toUpperCase(userName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Ocean View Resort — Guest Portal</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,600&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root{
  --cream:#faf7f2;--cream2:#f4f0e8;--cream3:#ede7d9;
  --white:#ffffff;--offwhite:#fdfcfa;
  --navy:#0f1f3d;--navy2:#162847;--navy3:#1e3556;
  --gold:#b8923a;--gold2:#d4a853;--gold3:#e8c878;--gold-lt:#f5e9cc;
  --teal:#0b5c6b;--teal2:#0e7a8a;
  --text:#1a1a2e;--text2:#3d3d52;--text3:#6b6b80;--text4:#9b9bae;
  --border:#e8e0d0;--border2:#d8cdb8;
  --shadow:rgba(15,31,61,0.08);--shadow2:rgba(15,31,61,0.15);
  --r:16px;--rs:10px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{font-family:'DM Sans',sans-serif;background:var(--cream);color:var(--text);min-height:100vh;overflow-x:hidden;-webkit-font-smoothing:antialiased;}
a{text-decoration:none;color:inherit;}

/* ── TEXTURE OVERLAY ───────────────────────── */
body::before{content:'';position:fixed;inset:0;z-index:0;pointer-events:none;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='300' height='300' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
  opacity:.5;}

/* ── NAVBAR ────────────────────────────────── */
.navbar{position:fixed;top:0;width:100%;z-index:300;height:68px;
  background:rgba(250,247,242,.92);backdrop-filter:blur(16px);
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;padding:0 52px;
  transition:box-shadow .3s;}
.navbar.scrolled{box-shadow:0 2px 20px var(--shadow);}
.nav-brand{display:flex;align-items:center;gap:12px;flex:1;}
.nav-logo{width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,var(--navy),var(--teal));
  display:flex;align-items:center;justify-content:center;font-size:18px;}
.nav-name{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;
  color:var(--navy);letter-spacing:.04em;}
.nav-name em{color:var(--gold);font-style:italic;}
.nav-loc{font-size:10px;color:var(--text3);letter-spacing:.18em;text-transform:uppercase;margin-top:1px;}
.nav-right{display:flex;align-items:center;gap:12px;}
.user-pill{display:flex;align-items:center;gap:9px;padding:6px 16px 6px 6px;
  background:var(--cream2);border:1px solid var(--border2);border-radius:100px;}
.u-av{width:32px;height:32px;border-radius:50%;
  background:linear-gradient(135deg,var(--teal),var(--gold2));
  display:flex;align-items:center;justify-content:center;
  font-size:13px;font-weight:700;color:#fff;}
.u-name{font-size:13px;font-weight:500;color:var(--text2);}
.btn-profile{display:flex;align-items:center;gap:7px;padding:8px 18px;
  border-radius:100px;background:var(--gold-lt);
  border:1.5px solid rgba(184,146,58,.35);color:var(--gold);
  font-size:12px;font-weight:600;cursor:pointer;
  transition:all .2s;font-family:inherit;}
.btn-profile:hover{background:var(--gold);color:#fff;border-color:var(--gold);}
.btn-logout{padding:8px 20px;border-radius:100px;
  background:transparent;border:1.5px solid var(--border2);
  color:var(--text3);font-size:12px;font-weight:500;cursor:pointer;
  transition:all .2s;font-family:inherit;}
.btn-logout:hover{background:var(--navy);color:#fff;border-color:var(--navy);}

/* ── HERO BANNER ───────────────────────────── */
.hero-banner{position:relative;margin-top:68px;overflow:hidden;
  background:linear-gradient(135deg,var(--navy) 0%,var(--navy2) 45%,var(--teal) 100%);
  padding:80px 52px 70px;}
.hero-banner::before{content:'';position:absolute;inset:0;
  background:radial-gradient(ellipse 70% 80% at 80% 50%, rgba(184,146,58,.18) 0%,transparent 70%);}
.hero-banner::after{content:'';position:absolute;bottom:0;left:0;right:0;height:4px;
  background:linear-gradient(90deg,transparent 0%,var(--gold) 30%,var(--gold2) 70%,transparent 100%);}
/* Decorative circles */
.hero-deco{position:absolute;border-radius:50%;border:1px solid rgba(255,255,255,.06);}
.hd1{width:400px;height:400px;top:-120px;right:-80px;}
.hd2{width:240px;height:240px;bottom:-80px;right:200px;border-color:rgba(184,146,58,.15);}
.hd3{width:140px;height:140px;top:30px;right:160px;border-color:rgba(255,255,255,.09);}
.hero-content{position:relative;z-index:2;max-width:1100px;margin:0 auto;
  display:grid;grid-template-columns:1fr auto;align-items:center;gap:40px;}
.hero-eyebrow{display:flex;align-items:center;gap:10px;margin-bottom:14px;}
.hero-eyebrow-line{width:32px;height:1px;background:var(--gold2);}
.hero-eyebrow-text{font-size:10px;font-weight:500;letter-spacing:.28em;
  text-transform:uppercase;color:var(--gold3);}
.hero-h1{font-family:'Cormorant Garamond',serif;
  font-size:clamp(36px,4vw,58px);font-weight:400;line-height:1.1;
  color:#fff;letter-spacing:-.01em;margin-bottom:16px;}
.hero-h1 em{font-style:italic;color:var(--gold3);}
.hero-sub{font-size:15px;color:rgba(255,255,255,.65);line-height:1.75;max-width:440px;}
.hero-guest-card{background:rgba(255,255,255,.06);
  border:1px solid rgba(255,255,255,.12);border-radius:20px;
  padding:28px 32px;text-align:center;min-width:200px;
  backdrop-filter:blur(10px);}
.hgc-label{font-size:9px;font-weight:600;letter-spacing:.22em;text-transform:uppercase;
  color:var(--gold3);margin-bottom:14px;}
.hgc-av{width:60px;height:60px;border-radius:50%;margin:0 auto 12px;
  background:linear-gradient(135deg,var(--teal2),var(--gold));
  display:flex;align-items:center;justify-content:center;
  font-size:22px;font-weight:700;color:#fff;
  border:3px solid rgba(255,255,255,.15);}
.hgc-name{font-family:'Cormorant Garamond',serif;font-size:20px;
  font-weight:600;color:#fff;letter-spacing:.02em;}
.hgc-tag{display:inline-block;margin-top:8px;padding:4px 14px;border-radius:100px;
  background:rgba(184,146,58,.25);border:1px solid rgba(184,146,58,.4);
  font-size:10px;font-weight:600;letter-spacing:.12em;
  text-transform:uppercase;color:var(--gold3);}

/* ── PAGE CONTENT ──────────────────────────── */
.content{max-width:1200px;margin:0 auto;padding:52px 52px 60px;
  display:flex;flex-direction:column;gap:52px;
  animation:fadeUp .5s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(12px);}to{opacity:1;}}

/* ── TOAST ─────────────────────────────────── */
.toast{padding:14px 22px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;
  display:flex;align-items:center;gap:10px;
  box-shadow:0 2px 12px rgba(22,101,52,.1);}

/* ── SECTION HEADER ────────────────────────── */
.sec-hd{display:flex;align-items:baseline;gap:16px;margin-bottom:24px;}
.sec-hd h2{font-family:'Cormorant Garamond',serif;font-size:28px;font-weight:400;
  color:var(--navy);letter-spacing:-.01em;}
.sec-hd h2 em{font-style:italic;color:var(--teal);}
.sec-hd-line{flex:1;height:1px;background:var(--border);margin-bottom:4px;}
.sec-hd-note{font-size:12px;color:var(--text4);white-space:nowrap;}

/* ── RATE STRIP ────────────────────────────── */
.rate-strip{display:grid;grid-template-columns:repeat(5,1fr);gap:1px;
  background:var(--border);border:1px solid var(--border);
  border-radius:var(--rs);overflow:hidden;}
.rs-item{background:var(--white);padding:16px 18px;text-align:center;transition:background .2s;}
.rs-item:hover{background:var(--cream2);}
.rs-ico{font-size:20px;margin-bottom:6px;}
.rs-room{font-size:11px;font-weight:600;color:var(--text3);
  text-transform:uppercase;letter-spacing:.1em;margin-bottom:5px;}
.rs-price{font-family:'DM Mono',monospace;font-size:18px;font-weight:500;color:var(--navy);}
.rs-price span{font-size:11px;color:var(--text4);font-weight:400;}

/* ── ACTION CARDS ──────────────────────────── */
.cards-grid{display:grid;grid-template-columns:1.55fr 1fr 1fr;gap:20px;}
.card{background:var(--white);border:1px solid var(--border);border-radius:20px;
  overflow:hidden;cursor:pointer;transition:all .3s cubic-bezier(.25,.46,.45,.94);
  animation:cardIn .5s ease both;box-shadow:0 2px 8px var(--shadow);}
.card:nth-child(1){animation-delay:.05s;}
.card:nth-child(2){animation-delay:.10s;}
.card:nth-child(3){animation-delay:.15s;}
.card:nth-child(4){animation-delay:.20s;}
.card:nth-child(5){animation-delay:.25s;}
@keyframes cardIn{from{opacity:0;transform:translateY(16px);}to{opacity:1;transform:none;}}
.card:hover{transform:translateY(-5px);box-shadow:0 16px 48px var(--shadow2);border-color:var(--border2);}

/* top color bar */
.card-bar{height:4px;width:100%;}

.card-body{padding:28px 28px 20px;}
.card-ico{width:52px;height:52px;border-radius:14px;display:flex;align-items:center;
  justify-content:center;font-size:22px;margin-bottom:20px;transition:transform .3s;}
.card:hover .card-ico{transform:scale(1.08);}
.card h3{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;
  color:var(--navy);margin-bottom:9px;letter-spacing:.01em;line-height:1.2;}
.card p{font-size:13.5px;color:var(--text3);line-height:1.7;}
.card-foot{display:flex;align-items:center;justify-content:space-between;
  padding:16px 28px;border-top:1px solid var(--border);margin-top:8px;}
.card-tag{font-size:10px;font-weight:600;letter-spacing:.15em;text-transform:uppercase;color:var(--text4);}
.card-btn{display:flex;align-items:center;gap:7px;font-size:12px;font-weight:600;
  padding:8px 16px;border-radius:100px;transition:all .25s;border:1.5px solid var(--border2);
  color:var(--text2);}
.card:hover .card-btn{color:#fff;border-color:transparent;}

/* Featured */
.card-featured{grid-row:span 2;}
.card-featured h3{font-size:28px;}
.card-featured p{font-size:14.5px;}
.card-featured .card-body{padding:34px 32px 24px;}
.card-featured .card-ico{width:60px;height:60px;font-size:26px;margin-bottom:22px;}

/* Color themes */
.c-navy .card-bar{background:linear-gradient(90deg,var(--navy),var(--navy3));}
.c-navy .card-ico{background:#eef2f8;border:1.5px solid #d0d9ec;}
.c-navy .card:hover,.c-navy.card:hover .card-btn{background:var(--navy);}
.c-navy.card:hover .card-btn{background:var(--navy);}

.c-teal .card-bar{background:linear-gradient(90deg,var(--teal),var(--teal2));}
.c-teal .card-ico{background:#e8f5f7;border:1.5px solid #b8dce2;}

.c-gold .card-bar{background:linear-gradient(90deg,var(--gold),var(--gold2));}
.c-gold .card-ico{background:var(--gold-lt);border:1.5px solid #e8d0a0;}

.c-green .card-bar{background:linear-gradient(90deg,#0d7a5c,#10a37f);}
.c-green .card-ico{background:#e8f8f3;border:1.5px solid #a8e4d0;}

.c-rose .card-bar{background:linear-gradient(90deg,#9b2c2c,#c0392b);}
.c-rose .card-ico{background:#fef2f2;border:1.5px solid #fecaca;}

/* Hover button tint per card */
.c-teal.card:hover .card-btn{background:var(--teal);color:#fff;border-color:var(--teal);}
.c-gold.card:hover .card-btn{background:var(--gold);color:#fff;border-color:var(--gold);}
.c-green.card:hover .card-btn{background:#0d7a5c;color:#fff;border-color:#0d7a5c;}
.c-rose.card:hover .card-btn{background:#9b2c2c;color:#fff;border-color:#9b2c2c;}
.c-navy.card:hover .card-btn{background:var(--navy);color:#fff;border-color:var(--navy);}

/* ── BOTTOM INFO ROW ───────────────────────── */
.info-row{display:grid;grid-template-columns:1fr 1fr 1fr;gap:20px;}
.ir-card{background:var(--white);border:1px solid var(--border);
  border-radius:var(--r);padding:24px 28px;
  box-shadow:0 2px 8px var(--shadow);}
.ir-card-head{display:flex;align-items:center;gap:10px;margin-bottom:16px;}
.ir-card-ico{width:36px;height:36px;border-radius:9px;display:flex;align-items:center;
  justify-content:center;font-size:16px;}
.ir-card h4{font-family:'Cormorant Garamond',serif;font-size:17px;font-weight:600;
  color:var(--navy);letter-spacing:.01em;}
.ir-row{display:flex;justify-content:space-between;align-items:center;
  padding:9px 0;border-bottom:1px solid var(--border);font-size:13px;}
.ir-row:last-child{border-bottom:none;}
.ir-label{color:var(--text3);}
.ir-value{font-family:'DM Mono',monospace;font-weight:500;color:var(--navy);}

/* ── FOOTER ────────────────────────────────── */
.footer{text-align:center;padding:20px 0 32px;}
.footer-div{display:flex;align-items:center;gap:16px;margin-bottom:14px;}
.footer-div::before,.footer-div::after{content:'';flex:1;height:1px;background:var(--border);}
.footer-icon{color:var(--gold);font-size:16px;}
.footer-text{font-size:11px;color:var(--text4);letter-spacing:.12em;}

/* ── RESPONSIVE ────────────────────────────── */
@media(max-width:1000px){.cards-grid{grid-template-columns:1fr 1fr;}.card-featured{grid-row:auto;}.info-row{grid-template-columns:1fr;}}
@media(max-width:700px){.content{padding:32px 20px 40px;}.hero-content{grid-template-columns:1fr;}.hero-guest-card{display:none;}.navbar{padding:0 18px;}.hero-banner{padding:60px 20px 50px;}.cards-grid{grid-template-columns:1fr;}.rate-strip{grid-template-columns:1fr 1fr;}}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="nav">
  <div class="nav-brand">
    <div class="nav-logo">🌊</div>
    <div>
      <div class="nav-name">Ocean <em>View</em> Resort</div>
      <div class="nav-loc">Galle, Sri Lanka</div>
    </div>
  </div>
  <div class="nav-right">
    <div class="user-pill">
      <div class="u-av"><%= initial %></div>
      <span class="u-name"><strong><%= userName %></strong></span>
    </div>
    <button class="btn-profile" onclick="location.href='UserProfile'">👤 My Profile</button>
    <button class="btn-logout" onclick="location.href='logout'">↩ Sign Out</button>
  </div>
</nav>

<!-- HERO BANNER -->
<div class="hero-banner">
  <div class="hero-deco hd1"></div>
  <div class="hero-deco hd2"></div>
  <div class="hero-deco hd3"></div>
  <div class="hero-content">
    <div>
      <div class="hero-eyebrow">
        <div class="hero-eyebrow-line"></div>
        <div class="hero-eyebrow-text">Guest Portal &nbsp;·&nbsp; Ocean View Resort</div>
      </div>
      <h1 class="hero-h1">
        Your Perfect<br>Stay <em>Awaits</em>
      </h1>
      <p class="hero-sub">Manage your booking, review your bill, and enjoy every moment of your stay with our seamless guest portal.</p>
    </div>
    <div class="hero-guest-card">
      <div class="hgc-label">Welcome Back</div>
      <div class="hgc-av"><%= initial %></div>
      <div class="hgc-name"><%= userName %></div>
      <div class="hgc-tag">✦ Valued Guest</div>
    </div>
  </div>
</div>

<!-- CONTENT -->
<div class="content">

  <!-- Toast -->
  <% if (suc != null) { %>
  <div class="toast" id="toastMsg">✅ &nbsp;<%= suc %></div>
  <script>setTimeout(function(){var e=document.getElementById("toastMsg");if(e){e.style.transition='opacity .5s';e.style.opacity='0';setTimeout(function(){e.remove();},500);}},4500);</script>
  <% } %>

  <!-- Rate Strip -->
  <div class="rate-strip">
    <div class="rs-item"><div class="rs-ico">🛏️</div><div class="rs-room">Standard</div><div class="rs-price">$80 <span>/ night</span></div></div>
    <div class="rs-item"><div class="rs-ico">✨</div><div class="rs-room">Deluxe</div><div class="rs-price">$150 <span>/ night</span></div></div>
    <div class="rs-item"><div class="rs-ico">👨‍👩‍👧</div><div class="rs-room">Family</div><div class="rs-price">$180 <span>/ night</span></div></div>
    <div class="rs-item"><div class="rs-ico">🌊</div><div class="rs-room">Ocean View</div><div class="rs-price">$220 <span>/ night</span></div></div>
    <div class="rs-item"><div class="rs-ico">👑</div><div class="rs-room">Suite</div><div class="rs-price">$250 <span>/ night</span></div></div>
  </div>

  <!-- Section heading -->
  <div class="sec-hd">
    <h2>What would you like to <em>do today?</em></h2>
    <div class="sec-hd-line"></div>
    <div class="sec-hd-note">5 services available</div>
  </div>

  <!-- CARDS -->
  <div class="cards-grid">

    <!-- Featured: Add Reservation -->
    <div class="card card-featured c-navy" onclick="location.href='addReservation.jsp'">
      <div class="card-bar"></div>
      <div class="card-body">
        <div class="card-ico">🛎️</div>
        <h3>Make a New Reservation</h3>
        <p>Book your ideal room with full guest details, preferred room type, and custom check-in/check-out dates. Confirmation is instant.</p>
      </div>
      <div class="card-foot">
        <span class="card-tag">Booking</span>
        <div class="card-btn">Book Now →</div>
      </div>
    </div>

    <!-- View Reservation -->
    <div class="card c-teal" onclick="location.href='viewReservation.jsp'">
      <div class="card-bar"></div>
      <div class="card-body">
        <div class="card-ico">🔍</div>
        <h3>View Reservation</h3>
        <p>Look up your existing booking using your reservation number and review all details.</p>
      </div>
      <div class="card-foot">
        <span class="card-tag">My Booking</span>
        <div class="card-btn">View →</div>
      </div>
    </div>

    <!-- Calculate Bill -->
    <div class="card c-gold" onclick="location.href='guestCalculator.jsp'">
      <div class="card-bar"></div>
      <div class="card-body">
        <div class="card-ico">🧮</div>
        <h3>Calculate Bill</h3>
        <p>Estimate your total stay cost including service charges and taxes before check-out.</p>
      </div>
      <div class="card-foot">
        <span class="card-tag">Billing</span>
        <div class="card-btn">Calculate →</div>
      </div>
    </div>

    <!-- Print Invoice -->
    <div class="card c-green" onclick="location.href='GuestInvoice'">
      <div class="card-bar"></div>
      <div class="card-body">
        <div class="card-ico">🖨️</div>
        <h3>Print Invoice</h3>
        <p>Generate and print a professional invoice for your stay. Enter your reservation number to get started.</p>
      </div>
      <div class="card-foot">
        <span class="card-tag">Invoice</span>
        <div class="card-btn">Print →</div>
      </div>
    </div>

    <!-- Help -->
    <div class="card c-rose" onclick="location.href='help.jsp'">
      <div class="card-bar"></div>
      <div class="card-body">
        <div class="card-ico">💡</div>
        <h3>Help &amp; Guide</h3>
        <p>Step-by-step instructions for using every feature of the guest portal.</p>
      </div>
      <div class="card-foot">
        <span class="card-tag">Support</span>
        <div class="card-btn">Read →</div>
      </div>
    </div>

  </div>

  <!-- INFO ROW -->
  <div class="info-row">

    <div class="ir-card">
      <div class="ir-card-head">
        <div class="ir-card-ico" style="background:#eef2f8;">🏨</div>
        <h4>Check-In Policy</h4>
      </div>
      <div class="ir-row"><span class="ir-label">Check-In Time</span><span class="ir-value">2:00 PM</span></div>
      <div class="ir-row"><span class="ir-label">Check-Out Time</span><span class="ir-value">12:00 PM</span></div>
      <div class="ir-row"><span class="ir-label">Early Check-In</span><span class="ir-value">On Request</span></div>
      <div class="ir-row"><span class="ir-label">Late Check-Out</span><span class="ir-value">+$30 fee</span></div>
    </div>

    <div class="ir-card">
      <div class="ir-card-head">
        <div class="ir-card-ico" style="background:#e8f5f7;">💳</div>
        <h4>Billing Summary</h4>
      </div>
      <div class="ir-row"><span class="ir-label">Service Charge</span><span class="ir-value">10%</span></div>
      <div class="ir-row"><span class="ir-label">Government Tax</span><span class="ir-value">8%</span></div>
      <div class="ir-row"><span class="ir-label">Currency</span><span class="ir-value">USD</span></div>
      <div class="ir-row"><span class="ir-label">Discount</span><span class="ir-value">0 – 100%</span></div>
    </div>

    <div class="ir-card">
      <div class="ir-card-head">
        <div class="ir-card-ico" style="background:#fef9ee;">📞</div>
        <h4>Resort Contact</h4>
      </div>
      <div class="ir-row"><span class="ir-label">Front Desk</span><span class="ir-value">Ext. 100</span></div>
      <div class="ir-row"><span class="ir-label">Room Service</span><span class="ir-value">Ext. 200</span></div>
      <div class="ir-row"><span class="ir-label">Concierge</span><span class="ir-value">Ext. 300</span></div>
      <div class="ir-row"><span class="ir-label">Emergency</span><span class="ir-value">Ext. 911</span></div>
    </div>

  </div>

  <!-- FOOTER -->
  <div class="footer">
    <div class="footer-div"><span class="footer-icon">✦</span></div>
    <div class="footer-text">© 2026 Ocean View Resort &nbsp;·&nbsp; Advanced Programming Project &nbsp;·&nbsp; Galle, Sri Lanka</div>
  </div>

</div><!-- /content -->

<script>
window.addEventListener('scroll',function(){
  document.getElementById('nav').classList.toggle('scrolled',window.scrollY>20);
},{passive:true});
</script>
</body>
</html>
