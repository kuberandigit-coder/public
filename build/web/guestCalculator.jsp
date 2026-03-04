<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Stay Cost Estimator — Ocean View Resort</title>
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;1,400;1,600&family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
/* ══════════════════════════════════════════════
   VARIABLES — LIGHT THEME
══════════════════════════════════════════════ */
:root {
  --gold:    #a07830;
  --gold-lt: #c8962a;
  --gold-dk: #7a5c1e;
  --navy:    #f0f4f8;
  --navy2:   #e4eaf2;
  --teal:    #0c6e80;
  --sand:    #fdf6ec;
  --glass:   rgba(255,255,255,0.85);
  --gb:      rgba(0,0,0,0.08);
  --dim:     rgba(30,40,60,0.65);
  --dim2:    rgba(30,40,60,0.38);
  --text:    #1a2336;
}

*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
html { scroll-behavior:smooth; }
body {
  font-family:'Outfit',sans-serif;
  background: #eef2f7;
  color: var(--text);
  min-height:100vh;
  overflow-x:hidden; -webkit-font-smoothing:antialiased;
}

/* ══════════════════════════════════════════════
   BACKGROUND
══════════════════════════════════════════════ */
.bg {
  position:fixed; inset:0; z-index:0;
  background: url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80') center/cover no-repeat;
  will-change:transform; transform:translateZ(0); contain:strict;
}
.bg::before {
  content:''; position:absolute; inset:0;
  background: linear-gradient(160deg, rgba(240,244,248,0.94) 0%, rgba(240,244,248,0.80) 40%, rgba(240,244,248,0.97) 100%);
}
.bg::after {
  content:''; position:absolute; inset:0;
  background: radial-gradient(ellipse 70% 50% at 70% 30%, rgba(200,150,42,0.10) 0%, transparent 70%);
  animation: glow 9s ease-in-out infinite alternate;
}
@keyframes glow { from{opacity:.5;} to{opacity:1;} }

/* ══════════════════════════════════════════════
   WAVES
══════════════════════════════════════════════ */
.waves {
  position:fixed; bottom:0; left:0; width:100%; height:90px; z-index:1;
  pointer-events:none; overflow:hidden;
}
.waves svg { width:100%; height:100%; }
.wv1 { animation: ww 11s ease-in-out infinite alternate; }
.wv2 { animation: ww2 15s ease-in-out infinite alternate; opacity:.4; }
@keyframes ww  { from{transform:translateX(0);} to{transform:translateX(2%);} }
@keyframes ww2 { from{transform:translateX(-1%);} to{transform:translateX(1.5%);} }

/* ══════════════════════════════════════════════
   PARTICLES
══════════════════════════════════════════════ */
.pts { position:fixed; inset:0; z-index:2; pointer-events:none; overflow:hidden; contain:strict; }
.pt {
  position:absolute; width:2px; height:2px; border-radius:50%;
  background:var(--gold-lt); opacity:0;
  animation:pf var(--d,14s) linear var(--dl,0s) infinite;
  left:var(--x,50%); bottom:-4px;
}
@keyframes pf { 0%{opacity:0;transform:translateY(0);} 10%{opacity:.25;} 90%{opacity:.08;} 100%{opacity:0;transform:translateY(-100vh) translateX(12px);} }

/* ══════════════════════════════════════════════
   HEADER BAR
══════════════════════════════════════════════ */
.hdr {
  position:fixed; top:0; width:100%; z-index:200; height:60px;
  background:rgba(255,255,255,0.90); backdrop-filter:blur(18px);
  border-bottom:1px solid rgba(160,120,48,0.18);
  display:flex; align-items:center; padding:0 40px; gap:14px;
  will-change:transform; transform:translateZ(0);
  box-shadow: 0 1px 12px rgba(0,0,0,0.07);
}
.hdr-brand {
  display:flex; align-items:center; gap:8px; flex:1;
  font-family:'Playfair Display',serif; font-size:18px; font-weight:600;
  letter-spacing:.04em; color: var(--text);
}
.hdr-brand em { font-style:italic; color:var(--gold); }
.hdr-wave { font-size:17px; animation:sway 3s ease-in-out infinite; display:inline-block; }
@keyframes sway { 0%,100%{transform:rotate(-5deg);} 50%{transform:rotate(5deg);} }
.hdr-badge {
  display:flex; align-items:center; gap:6px;
  padding:5px 14px; border-radius:100px;
  background:rgba(160,120,48,0.10); border:1px solid rgba(160,120,48,0.28);
  font-size:11px; font-weight:600; color:var(--gold); letter-spacing:.05em;
}
.hdr-dot { width:5px; height:5px; border-radius:50%; background:var(--gold); animation:pulse 2s infinite; }
@keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:.2;} }

/* ══════════════════════════════════════════════
   LAYOUT
══════════════════════════════════════════════ */
.page {
  position:relative; z-index:10;
  min-height:100vh; padding:86px 32px 80px;
  max-width:1060px; margin:0 auto;
  display:flex; flex-direction:column; gap:32px;
  animation:fadeUp .55s ease both;
}
@keyframes fadeUp { from{opacity:0;transform:translateY(14px);} to{opacity:1;transform:none;} }

/* ══════════════════════════════════════════════
   HERO TEXT
══════════════════════════════════════════════ */
.hero {
  text-align:center; padding:40px 20px 10px;
}
.hero-eye {
  font-size:10px; font-weight:600; letter-spacing:.3em; text-transform:uppercase;
  color:var(--gold); margin-bottom:14px;
  display:flex; align-items:center; justify-content:center; gap:12px;
}
.hero-eye::before,.hero-eye::after { content:''; width:32px; height:1px; background:var(--gold); }
.hero h1 {
  font-family:'Playfair Display',serif;
  font-size:clamp(32px,5vw,52px); font-weight:400; line-height:1.1; margin-bottom:14px;
  color: var(--text);
}
.hero h1 em { font-style:italic; color:var(--gold); }
.hero p { font-size:15px; color:var(--dim); max-width:500px; margin:0 auto; line-height:1.7; }

/* ══════════════════════════════════════════════
   ROOM RATE CARDS
══════════════════════════════════════════════ */
.rate-section { }
.sec-lbl {
  font-size:10px; letter-spacing:.28em; text-transform:uppercase; color:var(--dim2);
  display:flex; align-items:center; gap:12px; margin-bottom:16px;
}
.sec-lbl::before,.sec-lbl::after { content:''; flex:1; height:1px; background:rgba(0,0,0,0.10); }

.rooms { display:grid; grid-template-columns:repeat(5,1fr); gap:12px; }
.room-card {
  background:rgba(255,255,255,0.88); border:1.5px solid rgba(0,0,0,0.09);
  border-radius:16px; padding:16px 12px; text-align:center;
  cursor:default; transition:all .3s; position:relative; overflow:hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.room-card::before {
  content:''; position:absolute; inset:0;
  background:linear-gradient(135deg,rgba(160,120,48,0) 0%,rgba(160,120,48,0) 100%);
  transition:background .3s;
}
.room-card.active {
  border-color:rgba(160,120,48,0.65);
  background:rgba(160,120,48,0.08);
  box-shadow:0 0 0 3px rgba(160,120,48,0.14), 0 4px 14px rgba(160,120,48,0.15);
}
.room-card.active::before {
  background:linear-gradient(135deg,rgba(160,120,48,0.10) 0%,rgba(160,120,48,0.03) 100%);
}
.rc-img {
  width:52px; height:40px; border-radius:8px; object-fit:cover;
  margin:0 auto 10px; display:block; overflow:hidden;
  background:rgba(0,0,0,0.05); font-size:22px; line-height:40px; text-align:center;
}
.rc-name { font-size:12px; font-weight:600; margin-bottom:4px; color:var(--text); }
.rc-price {
  font-family:'JetBrains Mono',monospace;
  font-size:18px; font-weight:700; color:var(--gold);
}
.rc-unit { font-size:9px; color:var(--dim2); margin-top:2px; }
.active-tick {
  position:absolute; top:8px; right:8px;
  width:18px; height:18px; border-radius:50%;
  background:var(--gold); display:none; align-items:center; justify-content:center;
  font-size:9px; color:#fff; font-weight:700;
}
.room-card.active .active-tick { display:flex; }

/* ══════════════════════════════════════════════
   CALCULATOR CARD
══════════════════════════════════════════════ */
.calc-wrap {
  display:grid; grid-template-columns:1fr 1fr; gap:22px; align-items:start;
}

.form-card, .result-card {
  background: rgba(255,255,255,0.92);
  border:1px solid rgba(0,0,0,0.09); border-radius:20px;
  overflow:hidden;
  backdrop-filter:blur(14px);
  box-shadow: 0 4px 24px rgba(0,0,0,0.08);
}

.card-hd {
  padding:18px 24px; border-bottom:1px solid rgba(0,0,0,0.07);
  background:linear-gradient(90deg,rgba(160,120,48,0.07),transparent);
  display:flex; align-items:center; gap:10px;
}
.card-hd-ico {
  width:36px; height:36px; border-radius:10px;
  background:rgba(160,120,48,0.12); border:1px solid rgba(160,120,48,0.25);
  display:flex; align-items:center; justify-content:center; font-size:17px;
}
.card-hd-title { font-family:'Playfair Display',serif; font-size:16px; font-weight:600; color:var(--text); }
.card-hd-title em { color:var(--gold); font-style:italic; }
.card-hd-sub { font-size:11px; color:var(--dim2); margin-top:2px; }

.card-body { padding:24px; display:flex; flex-direction:column; gap:16px; }

/* Form elements */
.fg { display:flex; flex-direction:column; gap:6px; }
.fg label {
  font-size:10px; font-weight:700; color:var(--dim); text-transform:uppercase; letter-spacing:.8px;
}
.req { color:#dc2626; margin-left:2px; }
.fc {
  width:100%; background:rgba(255,255,255,0.95);
  border:1.5px solid rgba(0,0,0,0.12); border-radius:10px;
  color: var(--text); font-size:13px; padding:11px 14px; outline:none;
  font-family:'Outfit',sans-serif;
  transition:border-color .2s, box-shadow .2s, background .2s;
}
.fc:hover { border-color:rgba(0,0,0,0.22); }
.fc:focus { border-color:var(--gold); box-shadow:0 0 0 3px rgba(160,120,48,0.12); background:#fffdf7; }
.fc::placeholder { color:rgba(30,40,60,0.30); }
select.fc option { background:#fff; color:var(--text); }
.row2 { display:grid; grid-template-columns:1fr 1fr; gap:12px; }

/* Night info */
.night-info {
  display:none; align-items:center; justify-content:space-between;
  padding:12px 16px; border-radius:10px;
  background:rgba(160,120,48,0.08); border:1px solid rgba(160,120,48,0.25);
}
.ni-l { display:flex; align-items:center; gap:10px; }
.ni-num { font-family:'JetBrains Mono',monospace; font-size:28px; font-weight:700; color:var(--gold); }
.ni-txt { font-size:12px; color:var(--dim); }
.ni-r { font-size:12px; color:var(--dim); text-align:right; }
.ni-r strong { font-family:'JetBrains Mono',monospace; font-size:14px; color:var(--gold); }

/* Discount row */
.disc-wrap { display:flex; align-items:center; gap:10px; }
.disc-wrap input[type=range] { flex:1; accent-color:var(--gold); }
.disc-num {
  width:58px; text-align:center;
  font-family:'JetBrains Mono',monospace; font-size:15px; font-weight:700;
  background:rgba(255,255,255,0.95); border:1.5px solid rgba(0,0,0,0.12);
  border-radius:8px; color:#16a34a; padding:8px 4px; outline:none;
  transition:border-color .2s;
}
.disc-num:focus { border-color:var(--gold); }

/* CTA button */
.btn-calc {
  width:100%; padding:14px;
  background:linear-gradient(135deg,var(--gold-lt),var(--gold-dk));
  color:#fff; font-size:14px; font-weight:800; letter-spacing:.3px;
  border:none; border-radius:10px; cursor:pointer;
  display:flex; align-items:center; justify-content:center; gap:8px;
  box-shadow:0 4px 20px rgba(160,120,48,0.30);
  transition:all .22s; font-family:'Outfit',sans-serif;
}
.btn-calc:hover { transform:translateY(-2px); box-shadow:0 8px 28px rgba(160,120,48,0.40); }
.btn-calc:active { transform:none; }
.btn-reset {
  width:100%; padding:10px; border:1px solid rgba(0,0,0,0.12);
  border-radius:10px; background:transparent; color:var(--dim);
  font-size:12px; font-weight:600; cursor:pointer; transition:all .15s; font-family:'Outfit',sans-serif;
}
.btn-reset:hover { background:rgba(0,0,0,0.05); color:var(--text); }

/* ══════════════════════════════════════════════
   RESULT CARD
══════════════════════════════════════════════ */
.result-card {
  display:none;
  animation:slideIn .45s cubic-bezier(.22,1,.36,1) both;
}
.result-card.show { display:block; }
@keyframes slideIn { from{opacity:0;transform:translateY(18px) scale(.98);} to{opacity:1;transform:none;} }

/* Top accent stripe */
.stripe { height:3px; background:linear-gradient(90deg,var(--gold-dk),var(--gold-lt),var(--gold),var(--gold-lt),var(--gold-dk)); }

/* Guest info grid */
.res-info {
  display:grid; grid-template-columns:1fr 1fr;
  border-bottom:1px solid rgba(0,0,0,0.07);
}
.ri {
  padding:12px 18px; border-right:1px solid rgba(0,0,0,0.07);
  border-bottom:1px solid rgba(0,0,0,0.07);
}
.ri:nth-child(even) { border-right:none; }
.ri:nth-last-child(-n+2) { border-bottom:none; }
.ri-lbl { font-size:9px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; color:var(--dim2); margin-bottom:4px; }
.ri-val { font-size:13px; font-weight:600; color:var(--text); }
.ri-val.mono { font-family:'JetBrains Mono',monospace; color:var(--gold); }

/* Breakdown */
.breakdown { padding:18px 20px 0; }
.bd-title {
  font-size:10px; font-weight:700; letter-spacing:.25em; text-transform:uppercase;
  color:var(--dim2); margin-bottom:12px;
  display:flex; align-items:center; gap:10px;
}
.bd-title::after { content:''; flex:1; height:1px; background:rgba(0,0,0,0.08); }
.brow {
  display:flex; justify-content:space-between; align-items:center;
  padding:9px 0; border-bottom:1px solid rgba(0,0,0,0.06);
}
.brow:last-child { border-bottom:none; }
.brow-d { font-size:13px; color:var(--dim); }
.brow-d strong { color:var(--text); }
.brow-v { font-family:'JetBrains Mono',monospace; font-size:13px; font-weight:600; color:var(--text); }
.brow.sub .brow-d { color:var(--text); font-weight:600; }
.brow.sub .brow-v { font-size:14px; }
.brow.disc .brow-d, .brow.disc .brow-v { color:#16a34a; }

/* Total */
.total-bar {
  margin:0 20px 18px;
  padding:16px 18px;
  background:linear-gradient(120deg,rgba(160,120,48,0.10),rgba(160,120,48,0.04));
  border:1px solid rgba(160,120,48,0.30); border-radius:12px;
  display:flex; align-items:center; justify-content:space-between;
}
.tot-lbl { font-size:13px; font-weight:700; color:var(--gold); }
.tot-note { font-size:10px; color:var(--dim2); margin-top:2px; }
.tot-amt {
  font-family:'JetBrains Mono',monospace;
  font-size:clamp(26px,3.5vw,38px); font-weight:900; color:var(--gold); letter-spacing:-1px;
}

/* Actions */
.res-actions { padding:0 20px 20px; display:flex; gap:10px; }
.btn-act {
  flex:1; padding:11px; border-radius:10px;
  font-size:12px; font-weight:700; cursor:pointer;
  display:flex; align-items:center; justify-content:center; gap:6px;
  font-family:'Outfit',sans-serif; transition:all .15s;
}
.btn-print { background:transparent; border:1.5px solid rgba(0,0,0,0.12); color:var(--text); }
.btn-print:hover { background:rgba(0,0,0,0.05); }
.btn-new { background:linear-gradient(135deg,var(--gold-lt),var(--gold-dk)); border:none; color:#fff; }
.btn-new:hover { transform:translateY(-1px); box-shadow:0 4px 16px rgba(160,120,48,0.35); }

/* Placeholder state */
.placeholder {
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  padding:56px 30px; text-align:center;
  border:2px dashed rgba(0,0,0,0.10); border-radius:20px;
  backdrop-filter:blur(10px);
  background: rgba(255,255,255,0.60);
}
.placeholder-ico { font-size:52px; margin-bottom:14px; opacity:.30; }
.placeholder h3 { font-family:'Playfair Display',serif; font-size:18px; font-weight:400; color:var(--dim); }
.placeholder p { font-size:13px; color:var(--dim2); margin-top:7px; max-width:220px; line-height:1.6; }
.placeholder-hint {
  margin-top:18px; padding:7px 18px; border-radius:100px;
  background:rgba(160,120,48,0.10); border:1px solid rgba(160,120,48,0.22);
  font-size:11px; color:var(--gold); font-weight:600;
}

/* ══════════════════════════════════════════════
   FOOTER
══════════════════════════════════════════════ */
.footer {
  text-align:center; font-size:11px; color:var(--dim2); letter-spacing:.09em; padding-bottom:16px;
}
.footer::before { content:''; display:block; width:36px; height:1px; background:var(--gold); margin:0 auto 12px; }

/* ══════════════════════════════════════════════
   PRINT
══════════════════════════════════════════════ */
@media print {
  .bg,.waves,.pts,.hdr,.hero,.rate-section,.form-card,.placeholder,.res-actions { display:none !important; }
  .page { padding:0; max-width:100%; }
  .calc-wrap { grid-template-columns:1fr; }
  .result-card { display:block !important; border:none; backdrop-filter:none; }
  body,.result-card,.card-hd { background:white !important; color:#111 !important; }
  .ri-val { color:#111 !important; }
  .ri-val.mono,.tot-amt,.brow-v { color:#7a5c14 !important; }
  .stripe { background:#7a5c14; }
  .total-bar { background:#f9f0df; border-color:#c8a04a; }
  .tot-lbl { color:#7a5c14 !important; }
  .res-info,.ri,.brow { border-color:#e0d0b0; }
}

/* ══════════════════════════════════════════════
   RESPONSIVE
══════════════════════════════════════════════ */
@media(max-width:860px){
  .rooms { grid-template-columns:repeat(3,1fr); }
  .calc-wrap { grid-template-columns:1fr; }
}
@media(max-width:560px){
  .rooms { grid-template-columns:repeat(2,1fr); }
  .page { padding:78px 16px 60px; gap:24px; }
  .hdr { padding:0 20px; }
  .row2 { grid-template-columns:1fr; }
  .res-info { grid-template-columns:1fr; }
  .ri { border-right:none !important; }
}
</style>
</head>
<body>

<div class="bg"></div>

<div class="waves">
  <svg viewBox="0 0 1440 90" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
    <path class="wv1" d="M0,55 C240,90 480,18 720,55 C960,92 1200,18 1440,55 L1440,90 L0,90Z" fill="rgba(12,110,128,0.10)"/>
    <path class="wv2" d="M0,65 C300,38 600,88 900,58 C1100,38 1300,78 1440,62 L1440,90 L0,90Z" fill="rgba(160,120,48,0.08)"/>
  </svg>
</div>

<div class="pts" id="pts"></div>

<!-- Header -->
<header class="hdr">
  <div class="hdr-brand">
    <span class="hdr-wave">🌊</span>
    Ocean <em>&nbsp;View&nbsp;</em> Resort
  </div>
  <div class="hdr-badge">
    <div class="hdr-dot"></div>
    🧮 Stay Estimator
  </div>
</header>

<!-- Page -->
<main class="page">

  <!-- Hero -->
  <div class="hero">
    <div class="hero-eye">Transparent Pricing</div>
    <h1>Know Your Stay<br><em>Cost Upfront</em></h1>
    <p>Select your room, choose your dates, and instantly see a full cost breakdown — no surprises at checkout.</p>
  </div>

  <!-- Room rate cards -->
  <div class="rate-section">
    <div class="sec-lbl">Room Rates</div>
    <div class="rooms" id="roomCards">
      <div class="room-card" data-type="Standard" data-rate="80">
        <div class="rc-img">🛏️</div>
        <div class="rc-name">Standard</div>
        <div class="rc-price">$80</div>
        <div class="rc-unit">per night</div>
        <div class="active-tick">✓</div>
      </div>
      <div class="room-card" data-type="Deluxe" data-rate="150">
        <div class="rc-img">🏩</div>
        <div class="rc-name">Deluxe</div>
        <div class="rc-price">$150</div>
        <div class="rc-unit">per night</div>
        <div class="active-tick">✓</div>
      </div>
      <div class="room-card" data-type="Family" data-rate="180">
        <div class="rc-img">👨‍👩‍👧</div>
        <div class="rc-name">Family</div>
        <div class="rc-price">$180</div>
        <div class="rc-unit">per night</div>
        <div class="active-tick">✓</div>
      </div>
      <div class="room-card" data-type="Ocean View" data-rate="220">
        <div class="rc-img">🌊</div>
        <div class="rc-name">Ocean View</div>
        <div class="rc-price">$220</div>
        <div class="rc-unit">per night</div>
        <div class="active-tick">✓</div>
      </div>
      <div class="room-card" data-type="Suite" data-rate="250">
        <div class="rc-img">👑</div>
        <div class="rc-name">Suite</div>
        <div class="rc-price">$250</div>
        <div class="rc-unit">per night</div>
        <div class="active-tick">✓</div>
      </div>
    </div>
  </div>

  <!-- Calculator row -->
  <div class="calc-wrap">

    <!-- Form -->
    <div class="form-card">
      <div class="card-hd">
        <div class="card-hd-ico">📋</div>
        <div>
          <div class="card-hd-title">Your <em>Booking Details</em></div>
          <div class="card-hd-sub">Fill in your stay details to estimate the total cost</div>
        </div>
      </div>
      <div class="card-body">

        <div class="fg">
          <label>Your Name <span class="req">*</span></label>
          <input class="fc" type="text" id="f_name" placeholder="e.g. John Silva" autocomplete="off"/>
        </div>

        <div class="fg">
          <label>Room Type <span class="req">*</span></label>
          <select class="fc" id="f_room" onchange="onRoom()">
            <option value="">— Choose your room —</option>
            <option value="Standard"   data-rate="80">🛏️ Standard Room — $80 / night</option>
            <option value="Deluxe"     data-rate="150">🏩 Deluxe Room — $150 / night</option>
            <option value="Family"     data-rate="180">👨‍👩‍👧 Family Room — $180 / night</option>
            <option value="Ocean View" data-rate="220">🌊 Ocean View Room — $220 / night</option>
            <option value="Suite"      data-rate="250">👑 Suite — $250 / night</option>
          </select>
        </div>

        <div class="row2">
          <div class="fg">
            <label>Check-In <span class="req">*</span></label>
            <input class="fc" type="date" id="f_ci" onchange="onDate()"/>
          </div>
          <div class="fg">
            <label>Check-Out <span class="req">*</span></label>
            <input class="fc" type="date" id="f_co" onchange="onDate()"/>
          </div>
        </div>

        <!-- Night info bar -->
        <div class="night-info" id="nightInfo">
          <div class="ni-l">
            <span style="font-size:22px;">🌙</span>
            <div>
              <div class="ni-num" id="niNum">0</div>
              <div class="ni-txt">Night(s)</div>
            </div>
          </div>
          <div class="ni-r">
            Rate per night<br>
            <strong id="niRate">$0</strong>
          </div>
        </div>

        <button class="btn-calc" onclick="calc()">⚡ Calculate My Bill</button>
        <button class="btn-reset" onclick="resetAll()">🔄 Start Over</button>

      </div>
    </div>

    <!-- Result / Placeholder -->
    <div class="result-card" id="resultCard">
      <div class="stripe"></div>
      <div class="card-hd">
        <div class="card-hd-ico">✅</div>
        <div>
          <div class="card-hd-title">Bill <em>Summary</em></div>
          <div class="card-hd-sub">Ocean View Resort — Total Stay Cost</div>
        </div>
      </div>

      <div class="res-info">
        <div class="ri"><div class="ri-lbl">Guest Name</div><div class="ri-val" id="r_name"></div></div>
        <div class="ri"><div class="ri-lbl">Room Type</div><div class="ri-val" id="r_room"></div></div>
        <div class="ri"><div class="ri-lbl">Check-In</div><div class="ri-val mono" id="r_ci"></div></div>
        <div class="ri"><div class="ri-lbl">Check-Out</div><div class="ri-val mono" id="r_co"></div></div>
        <div class="ri"><div class="ri-lbl">Duration</div><div class="ri-val mono" id="r_dur"></div></div>
        <div class="ri"><div class="ri-lbl">Rate / Night</div><div class="ri-val mono" id="r_rate"></div></div>
      </div>

      <div class="breakdown">
        <div class="bd-title">Cost Breakdown</div>
        <div class="brow">
          <div class="brow-d"><strong id="r_nl">0 Nights</strong> × <span id="r_rl">$0</span></div>
          <div class="brow-v" id="r_ramt"></div>
        </div>
        <div class="brow">
          <div class="brow-d">Service Charge <span style="font-size:11px;color:var(--dim2);">(10%)</span></div>
          <div class="brow-v" id="r_svc"></div>
        </div>
        <div class="brow">
          <div class="brow-d">Government Tax <span style="font-size:11px;color:var(--dim2);">(8%)</span></div>
          <div class="brow-v" id="r_tax"></div>
        </div>
        <div class="brow sub">
          <div class="brow-d">Subtotal</div>
          <div class="brow-v" id="r_sub"></div>
        </div>
        <div class="brow disc" id="r_drow" style="display:none;">
          <div class="brow-d">🎁 Discount <span id="r_dpct"></span></div>
          <div class="brow-v" id="r_damt"></div>
        </div>
      </div>

      <div class="total-bar">
        <div>
          <div class="tot-lbl">TOTAL AMOUNT DUE</div>
          <div class="tot-note">Incl. service charge &amp; government tax</div>
        </div>
        <div class="tot-amt" id="r_total"></div>
      </div>

      <div class="res-actions">
        <button class="btn-act btn-print" onclick="window.print()">🖨️ Print Estimate</button>
        <button class="btn-act btn-new"   onclick="resetAll()">🔄 Recalculate</button>
      </div>
    </div>

    <div class="placeholder" id="ph">
      <div class="placeholder-ico">🌊</div>
      <h3>Your bill will appear here</h3>
      <p>Fill in your room type and stay dates, then tap Calculate.</p>
      <div class="placeholder-hint">← Complete the form to begin</div>
    </div>

  </div>

  <div class="footer">
    © 2026 Ocean View Resort &nbsp;·&nbsp; Galle, Sri Lanka &nbsp;·&nbsp; Transparent Pricing, Always
  </div>
</main>

<script>
var RATES = {Standard:80,Deluxe:150,Family:180,'Ocean View':220,Suite:250};
function $(i){return document.getElementById(i);}
function fmt(n){return'$'+n.toFixed(2);}

// Particles
var pc=$('pts');
for(var i=0;i<18;i++){
  var p=document.createElement('div'); p.className='pt';
  p.style.cssText='--x:'+Math.random()*100+'%;--d:'+(12+Math.random()*14)+'s;--dl:'+(Math.random()*12)+'s';
  pc.appendChild(p);
}

function onRoom(){
  var sel=$('f_room'), opt=sel.options[sel.selectedIndex];
  var rt=opt?opt.value:'';
  document.querySelectorAll('.room-card').forEach(function(c){
    c.classList.toggle('active',c.dataset.type===rt);
  });
  updateBar();
}

function onDate(){
  var ci=$('f_ci').value, co=$('f_co').value;
  if(ci) $('f_co').min=ci;
  updateBar();
}

function updateBar(){
  var ci=$('f_ci').value, co=$('f_co').value;
  var sel=$('f_room'), opt=sel.options[sel.selectedIndex];
  var rate=opt?parseFloat(opt.getAttribute('data-rate')):0;
  var n=0;
  if(ci&&co) n=Math.max(0,Math.round((new Date(co)-new Date(ci))/86400000));
  if(n>0){
    $('niNum').textContent=n;
    $('niRate').textContent=rate?fmt(rate):'—';
    $('nightInfo').style.display='flex';
  } else {
    $('nightInfo').style.display='none';
  }
}

function syncD(src){
  if(src==='r') $('f_d').value=$('f_dr').value;
  else {
    var v=Math.min(100,Math.max(0,parseFloat($('f_d').value)||0));
    $('f_d').value=v; $('f_dr').value=Math.min(50,v);
  }
}

function calc(){
  var name=$('f_name').value.trim();
  var rt=$('f_room').value;
  var ci=$('f_ci').value, co=$('f_co').value;
  var disc=parseFloat($('f_d').value)||0;

  if(!name){alert('Please enter your name.');$('f_name').focus();return;}
  if(!rt){alert('Please select a room type.');$('f_room').focus();return;}
  if(!ci){alert('Please choose your check-in date.');$('f_ci').focus();return;}
  if(!co){alert('Please choose your check-out date.');$('f_co').focus();return;}
  var nights=Math.round((new Date(co)-new Date(ci))/86400000);
  if(nights<=0){alert('Check-out must be after check-in.');return;}

  var rate=RATES[rt]||80;
  var room=rate*nights, svc=room*.10, tax=room*.08;
  var sub=room+svc+tax;
  var damt=sub*(disc/100), total=sub-damt;

  $('r_name').textContent=name;
  $('r_room').textContent=rt;
  $('r_ci').textContent=ci;
  $('r_co').textContent=co;
  $('r_dur').textContent=nights+(nights===1?' night':' nights');
  $('r_rate').textContent=fmt(rate);
  $('r_nl').textContent=nights+(nights===1?' Night':' Nights');
  $('r_rl').textContent=fmt(rate)+'/night';
  $('r_ramt').textContent=fmt(room);
  $('r_svc').textContent=fmt(svc);
  $('r_tax').textContent=fmt(tax);
  $('r_sub').textContent=fmt(sub);
  $('r_total').textContent=fmt(total);

  if(disc>0){
    $('r_dpct').textContent='('+disc+'%)';
    $('r_damt').textContent='− '+fmt(damt);
    $('r_drow').style.display='flex';
  } else {
    $('r_drow').style.display='none';
  }

  $('ph').style.display='none';
  var rc=$('resultCard');
  rc.classList.remove('show'); rc.style.display='block';
  setTimeout(function(){rc.classList.add('show');},10);
  rc.scrollIntoView({behavior:'smooth',block:'nearest'});
}

function resetAll(){
  $('f_name').value=''; $('f_room').selectedIndex=0;
  $('f_ci').value=''; $('f_co').value='';
  $('f_d').value='0'; $('f_dr').value='0';
  $('nightInfo').style.display='none';
  document.querySelectorAll('.room-card').forEach(function(c){c.classList.remove('active');});
  $('resultCard').style.display='none';
  $('resultCard').classList.remove('show');
  $('ph').style.display='flex';
  $('f_name').focus();
}
</script>
</body>
</html>