<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Help & Guide — Ocean View Resort</title>
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;1,400;1,600&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
:root {
  --gold:#a07830;--gold-lt:#c8962a;--gold-dk:#7a5c1e;
  --text:#1a2336;
  --glass:rgba(255,255,255,0.85);--gb:rgba(0,0,0,0.08);
  --dim:rgba(30,40,60,0.65);--dim2:rgba(30,40,60,0.38);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{font-family:'Outfit',sans-serif;background:#eef2f7;color:var(--text);min-height:100vh;overflow-x:hidden;-webkit-font-smoothing:antialiased;}
a{text-decoration:none;color:inherit;}
.bg{position:fixed;inset:0;z-index:0;background:url('https://images.unsplash.com/photo-1540541338287-41700207dee6?w=1920&q=80') center/cover no-repeat;will-change:transform;transform:translateZ(0);contain:strict;}
.bg::before{content:'';position:absolute;inset:0;background:linear-gradient(160deg,rgba(238,242,247,0.94) 0%,rgba(238,242,247,0.80) 40%,rgba(238,242,247,0.97) 100%);}
.bg::after{content:'';position:absolute;inset:0;background:radial-gradient(ellipse 60% 50% at 30% 30%,rgba(160,120,48,0.08) 0%,transparent 70%);animation:gl 9s ease-in-out infinite alternate;}
@keyframes gl{from{opacity:.4;}to{opacity:1;}}
.waves{position:fixed;bottom:0;left:0;width:100%;height:90px;z-index:1;pointer-events:none;overflow:hidden;}
.waves svg{width:100%;height:100%;}
.wv1{animation:ww 11s ease-in-out infinite alternate;}
.wv2{animation:ww2 15s ease-in-out infinite alternate;opacity:.4;}
@keyframes ww{from{transform:translateX(0);}to{transform:translateX(2%);}}
@keyframes ww2{from{transform:translateX(-1%);}to{transform:translateX(1.5%);}}
.pts{position:fixed;inset:0;z-index:2;pointer-events:none;overflow:hidden;contain:strict;}
.pt{position:absolute;width:2px;height:2px;border-radius:50%;background:var(--gold-lt);opacity:0;animation:pf var(--d,14s) linear var(--dl,0s) infinite;left:var(--x,50%);bottom:-4px;}
@keyframes pf{0%{opacity:0;transform:translateY(0);}10%{opacity:.22;}90%{opacity:.07;}100%{opacity:0;transform:translateY(-100vh);}}
.navbar{position:fixed;top:0;width:100%;z-index:200;height:60px;background:rgba(255,255,255,0.90);backdrop-filter:blur(18px);border-bottom:1px solid rgba(160,120,48,0.18);display:flex;align-items:center;padding:0 48px;gap:14px;box-shadow:0 1px 12px rgba(0,0,0,0.07);}
.nav-brand{display:flex;align-items:center;gap:8px;flex:1;font-family:'Playfair Display',serif;font-size:18px;font-weight:600;color:var(--text);}
.nav-brand em{font-style:italic;color:var(--gold);}
.nav-wave{font-size:17px;animation:sway 3s ease-in-out infinite;display:inline-block;}
@keyframes sway{0%,100%{transform:rotate(-5deg);}50%{transform:rotate(5deg);}}
.nav-back{display:flex;align-items:center;gap:6px;padding:7px 16px;border-radius:100px;background:rgba(160,120,48,0.10);border:1px solid rgba(160,120,48,0.25);font-size:12px;font-weight:600;color:var(--gold);transition:all .2s;}
.nav-back:hover{background:rgba(160,120,48,0.18);}
.page{position:relative;z-index:10;min-height:100vh;padding:86px 48px 80px;max-width:1000px;margin:0 auto;display:flex;flex-direction:column;gap:36px;animation:fadeUp .6s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px);}to{opacity:1;transform:none;}}
.hero{text-align:center;padding:32px 20px 0;}
.hero-eye{font-size:10px;font-weight:600;letter-spacing:.3em;text-transform:uppercase;color:var(--gold);margin-bottom:14px;display:flex;align-items:center;justify-content:center;gap:12px;}
.hero-eye::before,.hero-eye::after{content:'';width:32px;height:1px;background:var(--gold);}
.hero h1{font-family:'Playfair Display',serif;font-size:clamp(30px,4vw,48px);font-weight:400;line-height:1.1;margin-bottom:12px;color:var(--text);}
.hero h1 em{font-style:italic;color:var(--gold);}
.hero p{font-size:15px;color:var(--dim);max-width:500px;margin:0 auto;line-height:1.7;}
.divider{font-size:10px;letter-spacing:.28em;text-transform:uppercase;color:var(--dim2);display:flex;align-items:center;gap:12px;}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:rgba(0,0,0,0.10);}
.quick-nav{display:flex;flex-wrap:wrap;gap:10px;justify-content:center;}
.qn-pill{display:flex;align-items:center;gap:7px;padding:8px 18px;border-radius:100px;background:rgba(255,255,255,0.82);border:1px solid rgba(0,0,0,0.09);font-size:12px;font-weight:500;color:var(--dim);transition:all .2s;box-shadow:0 1px 4px rgba(0,0,0,0.05);}
.qn-pill:hover{background:rgba(160,120,48,0.10);border-color:rgba(160,120,48,0.28);color:var(--gold);}
.sections{display:flex;flex-direction:column;gap:20px;}
.help-card{background:rgba(255,255,255,0.92);border:1px solid rgba(0,0,0,0.09);border-radius:20px;overflow:hidden;backdrop-filter:blur(14px);border-left:3px solid transparent;transition:border-color .3s;animation:cardIn .5s ease both;box-shadow:0 3px 16px rgba(0,0,0,0.06);}
.help-card:nth-child(1){animation-delay:.04s;}.help-card:nth-child(2){animation-delay:.10s;}.help-card:nth-child(3){animation-delay:.16s;}.help-card:nth-child(4){animation-delay:.22s;}.help-card:nth-child(5){animation-delay:.28s;}.help-card:nth-child(6){animation-delay:.34s;}
@keyframes cardIn{from{opacity:0;transform:translateY(16px);}to{opacity:1;transform:none;}}
.help-card:hover{border-left-color:var(--gold);}
.hc-head{padding:18px 24px;display:flex;align-items:center;gap:14px;cursor:pointer;background:linear-gradient(90deg,rgba(160,120,48,0.06),transparent);border-bottom:1px solid rgba(0,0,0,0.06);user-select:none;}
.hc-num{width:34px;height:34px;border-radius:10px;flex-shrink:0;background:linear-gradient(135deg,rgba(160,120,48,0.20),rgba(160,120,48,0.07));border:1px solid rgba(160,120,48,0.28);display:flex;align-items:center;justify-content:center;font-family:'Playfair Display',serif;font-size:16px;font-weight:700;color:var(--gold);}
.hc-icon{font-size:20px;flex-shrink:0;}
.hc-title-wrap{flex:1;}
.hc-title{font-family:'Playfair Display',serif;font-size:17px;font-weight:600;color:var(--text);}
.hc-subtitle{font-size:12px;color:var(--dim2);margin-top:2px;}
.hc-toggle{font-size:18px;color:var(--dim2);transition:transform .3s;}
.hc-head[aria-expanded=true] .hc-toggle{transform:rotate(180deg);}
.hc-body{padding:22px 26px 24px;display:none;}
.hc-body.open{display:block;animation:bdIn .3s ease;}
@keyframes bdIn{from{opacity:0;transform:translateY(-6px);}to{opacity:1;transform:none;}}
.steps{display:flex;flex-direction:column;gap:14px;}
.step{display:flex;gap:16px;align-items:flex-start;padding:14px 18px;border-radius:12px;background:rgba(0,0,0,0.02);border:1px solid rgba(0,0,0,0.06);transition:background .2s;}
.step:hover{background:rgba(160,120,48,0.05);border-color:rgba(160,120,48,0.15);}
.step-num{width:28px;height:28px;border-radius:50%;flex-shrink:0;margin-top:1px;background:linear-gradient(135deg,var(--gold-lt),var(--gold-dk));display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;color:#fff;}
.step-title{font-size:13px;font-weight:700;margin-bottom:4px;color:var(--text);}
.step-desc{font-size:13px;color:var(--dim);line-height:1.65;}
.info-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:12px;}
.info-tile{padding:14px 16px;border-radius:12px;text-align:center;background:rgba(255,255,255,0.88);border:1px solid rgba(0,0,0,0.08);transition:all .2s;box-shadow:0 1px 6px rgba(0,0,0,0.04);}
.info-tile:hover{border-color:rgba(160,120,48,0.28);background:rgba(160,120,48,0.06);}
.it-ico{font-size:22px;margin-bottom:8px;}
.it-name{font-size:12px;font-weight:600;margin-bottom:4px;color:var(--text);}
.it-price{font-family:'Playfair Display',serif;font-size:20px;font-weight:600;color:var(--gold);}
.it-note{font-size:10px;color:var(--dim2);margin-top:3px;}
.tips{display:flex;flex-direction:column;gap:10px;}
.tip{display:flex;gap:12px;align-items:flex-start;padding:12px 16px;border-radius:10px;background:rgba(0,0,0,0.02);border-left:2px solid var(--gold);}
.tip-ico{font-size:18px;flex-shrink:0;margin-top:1px;}
.tip-text{font-size:13px;color:var(--dim);line-height:1.65;}
.tip-text strong{color:var(--text);}
.note-box{display:flex;gap:12px;align-items:flex-start;padding:14px 18px;border-radius:12px;background:rgba(160,120,48,0.08);border:1px solid rgba(160,120,48,0.22);margin-top:16px;}
.note-ico{font-size:18px;flex-shrink:0;}
.note-text{font-size:13px;color:var(--gold-dk);line-height:1.65;}
.contact-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:12px;}
.contact-tile{padding:16px 20px;border-radius:14px;background:rgba(255,255,255,0.88);border:1px solid rgba(0,0,0,0.08);box-shadow:0 1px 6px rgba(0,0,0,0.04);}
.ct-ico{font-size:22px;margin-bottom:8px;}
.ct-lbl{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--dim2);margin-bottom:5px;}
.ct-val{font-size:14px;font-weight:600;color:var(--text);}
.footer{text-align:center;font-size:11px;color:var(--dim2);letter-spacing:.09em;padding-bottom:16px;}
.footer::before{content:'';display:block;width:36px;height:1px;background:var(--gold);margin:0 auto 12px;}
@media(max-width:640px){.page{padding:76px 16px 60px;}.navbar{padding:0 20px;}.quick-nav{display:none;}}
</style>
</head>
<body>
<div class="bg"></div>
<div class="waves">
  <svg viewBox="0 0 1440 90" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
    <path class="wv1" d="M0,55 C240,90 480,18 720,55 C960,92 1200,18 1440,55 L1440,90 L0,90Z" fill="rgba(12,110,128,0.10)"/>
    <path class="wv2" d="M0,65 C300,38 600,88 900,58 C1100,38 1300,78 1440,62 L1440,90 L0,90Z" fill="rgba(160,120,48,0.07)"/>
  </svg>
</div>
<div class="pts" id="pts"></div>
<nav class="navbar">
  <div class="nav-brand"><span class="nav-wave">🌊</span> Ocean <em>&nbsp;View&nbsp;</em> Resort</div>
  <a class="nav-back" href="home.jsp">← Back to Dashboard</a>
</nav>
<main class="page">
  <div class="hero">
    <div class="hero-eye">User Guide</div>
    <h1>Help &amp; <em>Documentation</em></h1>
    <p>Everything you need to know to use the Ocean View Resort Reservation Management System.</p>
  </div>
  <div class="quick-nav">
    <a class="qn-pill" href="#sec1">🔐 Login</a>
    <a class="qn-pill" href="#sec2">🛎️ Add Reservation</a>
    <a class="qn-pill" href="#sec3">🔍 View Reservation</a>
    <a class="qn-pill" href="#sec4">🧮 Calculate Bill</a>
    <a class="qn-pill" href="#sec5">💡 Tips</a>
    <a class="qn-pill" href="#sec6">📞 Contact</a>
  </div>
  <div class="divider">Sections</div>
  <div class="sections">
    <div class="help-card" id="sec1">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="true">
        <div class="hc-num">1</div><span class="hc-icon">🔐</span>
        <div class="hc-title-wrap"><div class="hc-title">User Authentication &amp; Login</div><div class="hc-subtitle">How to securely access the system</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body open">
        <div class="steps">
          <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-title">Open the Login Page</div><div class="step-desc">Navigate to the system URL in your browser. You will be presented with a login form.</div></div></div>
          <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-title">Enter Your Credentials</div><div class="step-desc">Type your assigned username and password. Staff accounts are created by the Administrator. Passwords are case-sensitive.</div></div></div>
          <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-title">Click Login</div><div class="step-desc">If credentials are correct you will be redirected to the dashboard. If login fails, double-check your username and password.</div></div></div>
          <div class="step"><div class="step-num">4</div><div class="step-content"><div class="step-title">Logout When Done</div><div class="step-desc">Always click the Logout button when you finish your session, especially on shared computers, to protect guest data.</div></div></div>
        </div>
      </div>
    </div>
    <div class="help-card" id="sec2">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="false">
        <div class="hc-num">2</div><span class="hc-icon">🛎️</span>
        <div class="hc-title-wrap"><div class="hc-title">Adding a New Reservation</div><div class="hc-subtitle">Register a new guest booking into the system</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body">
        <div class="steps">
          <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-title">Go to Add New Reservation</div><div class="step-desc">From the dashboard, click the "Add New Reservation" card or navigate via the sidebar.</div></div></div>
          <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-title">Fill Guest Details</div><div class="step-desc">Enter the Reservation Number (unique, e.g. RES-001), Guest Name, Contact Number, and Address. All starred (*) fields are required.</div></div></div>
          <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-title">Select Room &amp; Dates</div><div class="step-desc">Choose the Room Type from the dropdown, then set the Check-In and Check-Out dates. The system will prevent invalid date ranges.</div></div></div>
          <div class="step"><div class="step-num">4</div><div class="step-content"><div class="step-title">Save the Reservation</div><div class="step-desc">Click "Save Reservation". A confirmation message will appear and the booking is stored in the database.</div></div></div>
        </div>
        <div class="note-box"><span class="note-ico">⚠️</span><div class="note-text">Reservation Numbers must be unique. If a duplicate number is entered the system will display an error — use a different number.</div></div>
      </div>
    </div>
    <div class="help-card" id="sec3">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="false">
        <div class="hc-num">3</div><span class="hc-icon">🔍</span>
        <div class="hc-title-wrap"><div class="hc-title">Viewing Reservation Details</div><div class="hc-subtitle">Search and retrieve complete booking information</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body">
        <div class="steps">
          <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-title">Open View Reservation</div><div class="step-desc">Click "View Reservation" from the dashboard or sidebar menu.</div></div></div>
          <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-title">Search by Reservation Number</div><div class="step-desc">Enter the guest's Reservation Number in the search field (e.g. RES-001) and press Search.</div></div></div>
          <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-title">Review the Details</div><div class="step-desc">The system will display all booking details: guest name, contact, room type, check-in and check-out dates. If no match is found, verify the reservation number.</div></div></div>
        </div>
      </div>
    </div>
    <div class="help-card" id="sec4">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="false">
        <div class="hc-num">4</div><span class="hc-icon">🧮</span>
        <div class="hc-title-wrap"><div class="hc-title">Calculating the Guest Bill</div><div class="hc-subtitle">Compute total stay cost based on nights and room rates</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body">
        <p style="font-size:13px;color:var(--dim);margin-bottom:18px;line-height:1.7;">The Bill Calculator computes the total amount due using the formula: Room Cost + Service Charge (10%) + Government Tax (8%) − Discount.</p>
        <div class="info-grid" style="margin-bottom:20px;">
          <div class="info-tile"><div class="it-ico">🛏️</div><div class="it-name">Standard</div><div class="it-price">$80</div><div class="it-note">per night</div></div>
          <div class="info-tile"><div class="it-ico">🏩</div><div class="it-name">Deluxe</div><div class="it-price">$150</div><div class="it-note">per night</div></div>
          <div class="info-tile"><div class="it-ico">👨‍👩‍👧</div><div class="it-name">Family</div><div class="it-price">$180</div><div class="it-note">per night</div></div>
          <div class="info-tile"><div class="it-ico">🌊</div><div class="it-name">Ocean View</div><div class="it-price">$220</div><div class="it-note">per night</div></div>
          <div class="info-tile"><div class="it-ico">👑</div><div class="it-name">Suite</div><div class="it-price">$250</div><div class="it-note">per night</div></div>
        </div>
        <div class="steps">
          <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-title">Room Cost = Rate × Nights</div><div class="step-desc">e.g. Deluxe for 3 nights = $150 × 3 = $450</div></div></div>
          <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-title">Add Service Charge (10%)</div><div class="step-desc">e.g. $450 × 10% = $45</div></div></div>
          <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-title">Add Government Tax (8%)</div><div class="step-desc">e.g. $450 × 8% = $36</div></div></div>
          <div class="step"><div class="step-num">4</div><div class="step-content"><div class="step-title">Apply Discount &amp; Click Calculate</div><div class="step-desc">Discount is applied to the subtotal. Then click Print Bill to produce a receipt for the guest.</div></div></div>
        </div>
      </div>
    </div>
    <div class="help-card" id="sec5">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="false">
        <div class="hc-num">5</div><span class="hc-icon">💡</span>
        <div class="hc-title-wrap"><div class="hc-title">Tips &amp; Best Practices</div><div class="hc-subtitle">Helpful guidance for daily system use</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body">
        <div class="tips">
          <div class="tip"><span class="tip-ico">🔒</span><div class="tip-text"><strong>Never share your login credentials.</strong> Each staff member has a personal account. Contact the Administrator if you forget your password.</div></div>
          <div class="tip"><span class="tip-ico">📋</span><div class="tip-text"><strong>Always verify the Reservation Number</strong> before editing or deleting. Numbers like RES-001 must be unique across all bookings.</div></div>
          <div class="tip"><span class="tip-ico">📅</span><div class="tip-text"><strong>Double-check check-in and check-out dates</strong> with the guest before saving. Date changes after saving may require admin approval.</div></div>
          <div class="tip"><span class="tip-ico">🖨️</span><div class="tip-text"><strong>Print the bill immediately after calculating.</strong> Navigate to Calculate Bill, compute the total, then click "Print Bill" to produce a guest receipt.</div></div>
          <div class="tip"><span class="tip-ico">🌐</span><div class="tip-text"><strong>Use a modern browser</strong> (Chrome, Edge, Firefox) for the best experience. Avoid Internet Explorer as some features may not work correctly.</div></div>
        </div>
      </div>
    </div>
    <div class="help-card" id="sec6">
      <div class="hc-head" onclick="toggle(this)" aria-expanded="false">
        <div class="hc-num">6</div><span class="hc-icon">📞</span>
        <div class="hc-title-wrap"><div class="hc-title">Support &amp; Contact</div><div class="hc-subtitle">Get help when you need it</div></div>
        <span class="hc-toggle">⌄</span>
      </div>
      <div class="hc-body">
        <p style="font-size:13px;color:var(--dim);margin-bottom:18px;line-height:1.7;">If you encounter any issues with the system that this guide does not address, contact the following:</p>
        <div class="contact-grid">
          <div class="contact-tile"><div class="ct-ico">🏨</div><div class="ct-lbl">Front Desk Manager</div><div class="ct-val">Ext. 100</div></div>
          <div class="contact-tile"><div class="ct-ico">💻</div><div class="ct-lbl">IT Support</div><div class="ct-val">Ext. 200</div></div>
          <div class="contact-tile"><div class="ct-ico">👤</div><div class="ct-lbl">System Admin</div><div class="ct-val">admin@oceanview.lk</div></div>
          <div class="contact-tile"><div class="ct-ico">🌐</div><div class="ct-lbl">Resort Website</div><div class="ct-val">oceanviewresort.lk</div></div>
        </div>
        <div class="note-box" style="margin-top:18px;"><span class="note-ico">ℹ️</span><div class="note-text">For urgent booking issues outside office hours, contact the on-duty Front Desk Manager directly via the hotel internal phone system.</div></div>
      </div>
    </div>
  </div>
  <div class="footer">© 2026 Ocean View Resort &nbsp;·&nbsp; Help &amp; Documentation &nbsp;·&nbsp; Galle, Sri Lanka</div>
</main>
<script>
var pc=document.getElementById('pts');
for(var i=0;i<16;i++){var p=document.createElement('div');p.className='pt';p.style.cssText='--x:'+Math.random()*100+'%;--d:'+(12+Math.random()*14)+'s;--dl:'+(Math.random()*12)+'s';pc.appendChild(p);}
function toggle(hd){
  var exp=hd.getAttribute('aria-expanded')==='true';
  hd.setAttribute('aria-expanded',!exp);
  var b=hd.nextElementSibling;
  if(!exp){b.classList.add('open');}else{b.classList.remove('open');}
}
</script>
</body>
</html>