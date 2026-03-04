<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    String adminName = sess != null ? (String) sess.getAttribute("admin") : null;
    String staffName = sess != null ? (String) sess.getAttribute("staff") : null;

    if (adminName == null && staffName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String currentUser = adminName != null ? adminName : staffName;
    String userRole    = adminName != null ? "Administrator" : "Staff Member";
    String themeColor  = adminName != null ? "gold" : "teal";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Bill Calculator — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet"/>
<style>
:root{
  --bg:#080c14;--sidebar:#050810;--card:#0e1521;--card2:#111926;--card3:#0a1018;
  --border:rgba(255,255,255,0.07);--border2:rgba(255,255,255,0.12);
  --gold:#c9a96e;--gl:#e8c98a;--gd:#a07840;
  --teal:#38bdf8;--green:#22c55e;--red:#ef4444;--amber:#f59e0b;--purple:#a78bfa;
  --text:#eef2f7;--dim:rgba(238,242,247,.55);--dim2:rgba(238,242,247,.28);
  --sw:240px;--r:16px;--rs:10px;
  --ac: <%= "gold".equals(themeColor) ? "#c9a96e" : "#38bdf8" %>;
  --al: <%= "gold".equals(themeColor) ? "#e8c98a" : "#7dd3fc" %>;
  --ad: <%= "gold".equals(themeColor) ? "#a07840" : "#0284c7" %>;
  --ab: <%= "gold".equals(themeColor) ? "rgba(201,169,110,.1)" : "rgba(56,189,248,.1)" %>;
  --abr:<%= "gold".equals(themeColor) ? "rgba(201,169,110,.2)" : "rgba(56,189,248,.2)" %>;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
a{text-decoration:none;color:inherit;}
input,select,button{font-family:inherit;}
table{border-collapse:collapse;width:100%;}

/* SIDEBAR */
.sidebar{position:fixed;left:0;top:0;width:var(--sw);height:100vh;background:var(--sidebar);border-right:1px solid var(--border);display:flex;flex-direction:column;z-index:100;}
.s-logo{padding:24px 20px 20px;border-bottom:1px solid var(--border);}
.s-logo .icon{font-size:26px;display:block;margin-bottom:6px;}
.s-logo .title{font-size:13px;font-weight:600;color:var(--ac);}
.s-logo .sub{font-size:10px;color:var(--dim2);letter-spacing:1.5px;text-transform:uppercase;margin-top:2px;}
.s-nav{flex:1;padding:16px 12px;overflow-y:auto;}
.s-sec{font-size:9px;font-weight:700;letter-spacing:1.8px;text-transform:uppercase;color:var(--dim2);padding:14px 8px 6px;}
.s-item{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:8px;font-size:13.5px;font-weight:500;color:var(--dim);transition:all .18s;margin-bottom:2px;}
.s-item:hover{background:rgba(255,255,255,.05);color:var(--text);}
.s-item.active{background:var(--ab);color:var(--ac);border:1px solid var(--abr);}
.s-icon{font-size:16px;width:20px;text-align:center;}
.s-foot{border-top:1px solid var(--border);padding:16px;}
.u-card{display:flex;align-items:center;gap:10px;background:var(--ab);border:1px solid var(--abr);border-radius:8px;padding:10px 12px;margin-bottom:10px;}
.u-av{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--ac),var(--ad));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#000;flex-shrink:0;}
.u-name{font-size:12.5px;font-weight:600;}
.u-role{font-size:10px;color:var(--ac);font-weight:500;}
.logout{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.18);color:var(--red);font-size:12.5px;font-weight:500;transition:all .18s;}
.logout:hover{background:rgba(239,68,68,.16);}

/* MAIN */
.main{margin-left:var(--sw);flex:1;display:flex;flex-direction:column;animation:pageIn .4s ease both;}
@keyframes pageIn{from{opacity:0;transform:translateY(10px);}to{opacity:1;}}
.topbar{position:sticky;top:0;height:60px;background:rgba(8,12,20,.9);backdrop-filter:blur(24px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px;z-index:90;}
.t-title{font-size:16px;font-weight:700;flex:1;}
.t-title span{color:var(--ac);}
.t-pill{display:flex;align-items:center;gap:6px;padding:5px 14px;border-radius:20px;font-size:11.5px;font-weight:600;background:var(--ab);border:1px solid var(--abr);color:var(--al);}
.dot{width:7px;height:7px;border-radius:50%;background:var(--ac);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:.3;}}
.content{padding:32px;flex:1;}

/* PAGE HEADER */
.ph{display:flex;align-items:center;gap:14px;margin-bottom:30px;}
.ph-icon{width:50px;height:50px;border-radius:var(--rs);background:linear-gradient(135deg,var(--ac),var(--ad));display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0;}
.ph h1{font-size:24px;font-weight:800;}
.ph h1 span{color:var(--ac);}
.ph p{font-size:13.5px;color:var(--dim);margin-top:3px;}

/* GRID */
.calc-grid{display:grid;grid-template-columns:1fr 1fr;gap:24px;align-items:start;}

/* CARDS */
.card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;}
.card-head{padding:20px 24px 16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px;}
.ch-icon{font-size:20px;}
.ch-text h2{font-size:15px;font-weight:700;}
.ch-text h2 span{color:var(--ac);}
.ch-text p{font-size:12px;color:var(--dim);margin-top:2px;}
.card-body{padding:24px;}
.divider{height:1px;background:var(--border);margin:16px 0 20px;}

/* FORM */
.fg{margin-bottom:18px;}
.fg label{display:block;font-size:11.5px;font-weight:700;color:var(--dim);text-transform:uppercase;letter-spacing:.8px;margin-bottom:8px;}
.req{color:var(--red);margin-left:2px;}
.fc{width:100%;background:var(--card2);border:1px solid var(--border2);border-radius:var(--rs);color:var(--text);font-size:14px;padding:11px 14px;outline:none;transition:border-color .2s,box-shadow .2s;}
.fc:focus{border-color:var(--ac);box-shadow:0 0 0 3px var(--ab);}
.fc::placeholder{color:var(--dim2);}
select.fc option{background:#0e1521;}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:14px;}

/* Rate preview */
.rate-prev{display:flex;align-items:center;justify-content:space-between;background:var(--card3);border:1px solid var(--abr);border-radius:var(--rs);padding:10px 14px;margin-top:8px;}
.rp-lbl{font-size:12px;color:var(--dim);}
.rp-val{font-family:'JetBrains Mono',monospace;font-size:15px;font-weight:600;color:var(--al);}

/* Night box */
.night-box{display:flex;align-items:center;gap:12px;background:var(--card3);border:1px solid var(--border2);border-radius:var(--rs);padding:12px 16px;margin-top:8px;}
.nb-n{font-family:'JetBrains Mono',monospace;font-size:26px;font-weight:700;color:var(--al);}
.nb-l{font-size:12px;color:var(--dim);}

/* Buttons */
.btn-calc{width:100%;padding:14px;background:linear-gradient(135deg,var(--ac),var(--ad));color:#000;font-size:14px;font-weight:800;border:none;border-radius:var(--rs);cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:6px;}
.btn-calc:hover{transform:translateY(-2px);box-shadow:0 8px 24px var(--ab);}
.btn-reset{width:100%;padding:10px;background:rgba(255,255,255,.05);border:1px solid var(--border2);color:var(--dim);font-size:13px;font-weight:600;border-radius:var(--rs);cursor:pointer;transition:all .2s;margin-top:8px;}
.btn-reset:hover{background:rgba(255,255,255,.1);color:var(--text);}

/* RATES TABLE */
.rates-card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;margin-top:24px;}
.rt-table{width:100%;border-collapse:collapse;}
.rt-table thead tr{background:var(--ab);border-bottom:1px solid var(--border);}
.rt-table thead th{padding:11px 16px;font-size:11px;font-weight:700;letter-spacing:.8px;text-transform:uppercase;color:var(--ac);text-align:left;}
.rt-table tbody tr{border-bottom:1px solid var(--border);transition:background .15s;}
.rt-table tbody tr:last-child{border-bottom:none;}
.rt-table tbody tr:hover{background:rgba(255,255,255,.03);}
.rt-table tbody td{padding:12px 16px;font-size:13px;}
.r-dot{width:9px;height:9px;border-radius:50%;display:inline-block;margin-right:8px;vertical-align:middle;}
.r-rate{font-family:'JetBrains Mono',monospace;font-weight:600;color:var(--al);}

/* RESULT CARD */
.result-card{background:var(--card);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;display:none;}
.result-card.show{display:block;animation:slideIn .4s cubic-bezier(.34,1.56,.64,1) both;}
@keyframes slideIn{from{opacity:0;transform:translateY(16px) scale(.97);}to{opacity:1;transform:none;}}

/* Invoice header */
.inv-top{padding:28px 24px 20px;background:linear-gradient(160deg,rgba(201,169,110,.07) 0%,rgba(0,0,0,0) 100%);border-bottom:1px solid var(--border);text-align:center;position:relative;}
.inv-resort{font-size:11px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;color:var(--dim2);margin-bottom:6px;}
.inv-title{font-size:22px;font-weight:800;color:var(--gl);letter-spacing:-.3px;}
.inv-no{font-family:'JetBrains Mono',monospace;font-size:12px;color:var(--ac);margin-top:6px;padding:3px 12px;display:inline-block;background:var(--ab);border-radius:20px;border:1px solid var(--abr);}
.inv-date{position:absolute;top:16px;right:18px;font-size:10px;color:var(--dim2);font-family:'JetBrains Mono',monospace;}
.inv-badge{display:inline-flex;align-items:center;gap:5px;padding:3px 11px;border-radius:20px;font-size:10.5px;font-weight:700;background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.2);color:var(--green);margin-top:10px;}

/* Guest info grid */
.inv-info{display:grid;grid-template-columns:1fr 1fr;border-bottom:1px solid var(--border);}
.ii{padding:13px 20px;border-bottom:1px solid var(--border);}
.ii:nth-child(odd){border-right:1px solid var(--border);}
.ii:nth-last-child(-n+2){border-bottom:none;}
.ii-lbl{font-size:10px;font-weight:700;color:var(--dim2);text-transform:uppercase;letter-spacing:.7px;margin-bottom:4px;}
.ii-val{font-size:13.5px;font-weight:600;}

/* Breakdown */
.bk{padding:20px 24px 0;}
.bk-head{font-size:11px;font-weight:700;color:var(--dim2);text-transform:uppercase;letter-spacing:1px;margin-bottom:14px;}
.bk-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);}
.bk-row:last-child{border-bottom:none;padding-bottom:0;}
.bk-l{font-size:13.5px;color:var(--dim);}
.bk-l strong{color:var(--text);}
.bk-v{font-family:'JetBrains Mono',monospace;font-size:14px;font-weight:600;}
.bk-disc .bk-l,.bk-disc .bk-v{color:var(--green);}

/* Total */
.total-bar{margin:20px 24px 0;background:linear-gradient(135deg,var(--ab),rgba(0,0,0,.1));border:1px solid var(--abr);border-radius:var(--rs);padding:16px 20px;display:flex;justify-content:space-between;align-items:center;}
.tb-l{font-size:13px;font-weight:700;color:var(--ac);}
.tb-sub{font-size:11px;color:var(--dim2);margin-top:2px;}
.tb-amt{font-family:'JetBrains Mono',monospace;font-size:30px;font-weight:800;color:var(--al);}

/* Invoice actions */
.inv-actions{padding:20px 24px;display:flex;gap:10px;}
.btn-pr{flex:1;padding:11px;background:rgba(255,255,255,.06);border:1px solid var(--border2);border-radius:var(--rs);color:var(--text);font-size:13px;font-weight:600;cursor:pointer;transition:all .18s;display:flex;align-items:center;justify-content:center;gap:6px;}
.btn-pr:hover{background:rgba(255,255,255,.12);}
.btn-nw{flex:1;padding:11px;background:linear-gradient(135deg,var(--ac),var(--ad));color:#000;border:none;border-radius:var(--rs);font-size:13px;font-weight:700;cursor:pointer;transition:all .18s;display:flex;align-items:center;justify-content:center;gap:6px;}
.btn-nw:hover{transform:translateY(-1px);}

/* PRINT */
@media print{
  .sidebar,.topbar,.ph,.input-section,.rates-card,.inv-actions,
  .btn-calc,.btn-reset{display:none!important;}
  .main{margin-left:0;}
  .content{padding:0;}
  .calc-grid{grid-template-columns:1fr;}
  .result-card{display:block!important;border:none;border-radius:0;}
  body{background:#fff;color:#111;}
  .inv-top{background:linear-gradient(160deg,#f5edd8,#fff);}
  .inv-title,.inv-resort{color:#8B6914;}
  .inv-info,.ii,.bk-row{border-color:#e0d5c0;}
  .ii-lbl,.bk-l{color:#666;}
  .ii-val,.bk-v,.bk-l strong{color:#111;}
  .total-bar{background:#f5edd8;border-color:#d4b483;}
  .tb-l{color:#8B6914;}
  .tb-amt{color:#111;}
  .inv-no{background:#f5edd8;border-color:#d4b483;color:#8B6914;}
  .inv-badge{background:#e8f5e9;border-color:#a5d6a7;color:#2e7d32;}
}
@media(max-width:1100px){.calc-grid{grid-template-columns:1fr;}}
@media(max-width:900px){.sidebar{transform:translateX(-100%);}.main{margin-left:0;}}
@media(max-width:600px){.content{padding:16px;}.form-row{grid-template-columns:1fr;}.inv-info{grid-template-columns:1fr;}.ii:nth-child(odd){border-right:none;}}
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="s-logo">
    <span class="icon">🌊</span>
    <div class="title">Ocean View Resort</div>
    <div class="sub"><%= adminName != null ? "Admin Portal" : "Staff Portal" %></div>
  </div>
  <nav class="s-nav">
    <div class="s-sec">Main</div>
    <% if (adminName != null) { %>
      <a class="s-item" href="AdminDashboard"><div class="s-icon">📊</div> Dashboard</a>
      <a class="s-item" href="AdminViewReservation"><div class="s-icon">📋</div> Reservations</a>
      <a class="s-item" href="UserManagement"><div class="s-icon">👥</div> Users &amp; Staff</a>
    <% } else { %>
      <a class="s-item" href="Staff"><div class="s-icon">📋</div> Reservations</a>
    <% } %>
    <div class="s-sec">Operations</div>
    <a class="s-item active" href="calculateBill.jsp"><div class="s-icon">🧾</div> Bill Calculator</a>
  </nav>
  <div class="s-foot">
    <div class="u-card">
      <div class="u-av"><%= String.valueOf(currentUser.charAt(0)).toUpperCase() %></div>
      <div>
        <div class="u-name"><%= currentUser %></div>
        <div class="u-role"><%= userRole %></div>
      </div>
    </div>
    <a class="logout" href="logout">↩ Sign Out</a>
  </div>
</aside>

<!-- MAIN -->
<div class="main">
  <div class="topbar">
    <div class="t-title">Bill <span>Calculator</span></div>
    <div class="t-pill"><div class="dot"></div> 🧾 Invoice Generator</div>
  </div>

  <div class="content">

    <!-- Header -->
    <div class="ph">
      <div class="ph-icon">🧾</div>
      <div>
        <h1>Bill <span>Calculator</span></h1>
        <p>Generate a professional invoice for any guest reservation instantly.</p>
      </div>
    </div>

    <div class="calc-grid">

      <!-- ── INPUT SECTION ─────────────────────────── -->
      <div class="input-section">
        <div class="card">
          <div class="card-head">
            <div class="ch-icon">📝</div>
            <div class="ch-text">
              <h2>Reservation <span>Details</span></h2>
              <p>Fill in guest and booking information</p>
            </div>
          </div>
          <div class="card-body">

            <div class="fg">
              <label>Reservation No <span class="req">*</span></label>
              <input class="fc" type="text" id="f_rno" placeholder="e.g. RES-001" autocomplete="off"/>
            </div>
            <div class="fg">
              <label>Guest Name <span class="req">*</span></label>
              <input class="fc" type="text" id="f_gn" placeholder="Full name"/>
            </div>
            <div class="form-row">
              <div class="fg">
                <label>Contact</label>
                <input class="fc" type="text" id="f_ct" placeholder="Phone number"/>
              </div>
              <div class="fg">
                <label>Address</label>
                <input class="fc" type="text" id="f_ad" placeholder="City / Address"/>
              </div>
            </div>

            <div class="divider"></div>

            <div class="fg">
              <label>Room Type <span class="req">*</span></label>
              <select class="fc" id="f_rt" onchange="updateRatePreview()">
                <option value="">-- Select Room Type --</option>
                <option value="Standard">Standard Room</option>
                <option value="Deluxe">Deluxe Room</option>
                <option value="Family">Family Room</option>
                <option value="Ocean View">Ocean View Room</option>
                <option value="Suite">Suite</option>
              </select>
              <div class="rate-prev" id="ratePreview" style="display:none;">
                <span class="rp-lbl">🏨 Rate per night</span>
                <span class="rp-val" id="rateDisplay">$0.00</span>
              </div>
            </div>

            <div class="form-row">
              <div class="fg">
                <label>Check-In <span class="req">*</span></label>
                <input class="fc" type="date" id="f_ci" onchange="updateNights()"/>
              </div>
              <div class="fg">
                <label>Check-Out <span class="req">*</span></label>
                <input class="fc" type="date" id="f_co" onchange="updateNights()"/>
              </div>
            </div>

            <div class="night-box" id="nightBox" style="display:none;">
              <span style="font-size:24px;">🌙</span>
              <div>
                <div class="nb-n" id="nightCount">0</div>
                <div class="nb-l">Night(s) of stay</div>
              </div>
            </div>

            <div class="divider"></div>

            <div class="fg">
              <label>Discount (%)</label>
              <input class="fc" type="number" id="f_disc" placeholder="0" min="0" max="100" value="0"/>
            </div>

            <button class="btn-calc" onclick="calculate()">⚡ Generate Invoice</button>
            <button class="btn-reset" onclick="resetForm()">🔄 Clear Form</button>

          </div>
        </div>

        <!-- Rates Table -->
        <div class="rates-card">
          <div class="card-head" style="padding:16px 20px;">
            <div class="ch-icon">💰</div>
            <div class="ch-text">
              <h2>Room <span>Rates</span></h2>
              <p>Standard pricing reference</p>
            </div>
          </div>
          <table class="rt-table">
            <thead><tr><th>Room Type</th><th>Rate/Night</th><th>Tier</th></tr></thead>
            <tbody>
              <tr><td><span class="r-dot" style="background:#6b7280;"></span>Standard</td><td><span class="r-rate">$80.00</span></td><td><span style="font-size:11px;color:var(--dim);">Budget</span></td></tr>
              <tr><td><span class="r-dot" style="background:#38bdf8;"></span>Deluxe</td><td><span class="r-rate">$150.00</span></td><td><span style="font-size:11px;color:#38bdf8;">Popular</span></td></tr>
              <tr><td><span class="r-dot" style="background:#22c55e;"></span>Family</td><td><span class="r-rate">$180.00</span></td><td><span style="font-size:11px;color:#22c55e;">Family</span></td></tr>
              <tr><td><span class="r-dot" style="background:#c9a96e;"></span>Ocean View</td><td><span class="r-rate">$220.00</span></td><td><span style="font-size:11px;color:#c9a96e;">Premium</span></td></tr>
              <tr><td><span class="r-dot" style="background:#a78bfa;"></span>Suite</td><td><span class="r-rate">$250.00</span></td><td><span style="font-size:11px;color:#a78bfa;">Luxury</span></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- ── INVOICE RESULT ─────────────────────────── -->
      <div class="result-card" id="resultCard">

        <div class="inv-top">
          <div class="inv-resort">Ocean View Resort</div>
          <div class="inv-title">GUEST INVOICE</div>
          <div class="inv-no" id="r_rno_badge"></div>
          <div><span class="inv-badge">✅ Invoice Generated</span></div>
          <div class="inv-date" id="inv_date"></div>
        </div>

        <div class="inv-info">
          <div class="ii"><div class="ii-lbl">Guest Name</div><div class="ii-val" id="r_gn"></div></div>
          <div class="ii"><div class="ii-lbl">Room Type</div><div class="ii-val" id="r_rt"></div></div>
          <div class="ii"><div class="ii-lbl">Contact</div><div class="ii-val" id="r_ct"></div></div>
          <div class="ii"><div class="ii-lbl">Address</div><div class="ii-val" id="r_ad"></div></div>
          <div class="ii"><div class="ii-lbl">Check-In</div><div class="ii-val" id="r_ci" style="font-family:'JetBrains Mono',monospace;"></div></div>
          <div class="ii"><div class="ii-lbl">Check-Out</div><div class="ii-val" id="r_co" style="font-family:'JetBrains Mono',monospace;"></div></div>
        </div>

        <div class="bk">
          <div class="bk-head">💰 Billing Breakdown</div>
          <div class="bk-row">
            <div class="bk-l"><strong id="r_nights_lbl">0 nights</strong> × <span id="r_rate_lbl">$0/night</span></div>
            <div class="bk-v" id="r_room"></div>
          </div>
          <div class="bk-row">
            <div class="bk-l">Service Charge <span style="font-size:11px;color:var(--dim2);">(10%)</span></div>
            <div class="bk-v" id="r_svc"></div>
          </div>
          <div class="bk-row">
            <div class="bk-l">Tax <span style="font-size:11px;color:var(--dim2);">(8%)</span></div>
            <div class="bk-v" id="r_tax"></div>
          </div>
          <div class="bk-row bk-disc" id="r_disc_row" style="display:none;">
            <div class="bk-l">🎁 Discount Applied</div>
            <div class="bk-v" id="r_disc"></div>
          </div>
          <div class="bk-row">
            <div class="bk-l">Subtotal (before discount)</div>
            <div class="bk-v" id="r_sub"></div>
          </div>
        </div>

        <div class="total-bar">
          <div>
            <div class="tb-l">TOTAL AMOUNT DUE</div>
            <div class="tb-sub">Inclusive of all taxes &amp; charges</div>
          </div>
          <div class="tb-amt" id="r_total"></div>
        </div>

        <div class="inv-actions">
          <button class="btn-pr" onclick="window.print()">🖨️ Print Invoice</button>
          <button class="btn-nw" onclick="resetForm()">➕ New Calculation</button>
        </div>

      </div><!-- /result-card -->

    </div><!-- /calc-grid -->
  </div>
</div>

<script>
var RATES={'Standard':80,'Deluxe':150,'Family':180,'Ocean View':220,'Suite':250};
function fmt(n){ return '$'+n.toFixed(2); }
function ov(id){ return document.getElementById(id); }

function updateRatePreview(){
  var rt=ov('f_rt').value;
  if(rt&&RATES[rt]){ ov('rateDisplay').textContent=fmt(RATES[rt]); ov('ratePreview').style.display='flex'; }
  else { ov('ratePreview').style.display='none'; }
}

function updateNights(){
  var ci=ov('f_ci').value, co=ov('f_co').value;
  if(ci&&co){
    var n=Math.round((new Date(co)-new Date(ci))/86400000);
    if(n>0){ ov('nightCount').textContent=n; ov('nightBox').style.display='flex'; return; }
  }
  ov('nightBox').style.display='none';
}

function calculate(){
  var rno=ov('f_rno').value.trim(), gn=ov('f_gn').value.trim();
  var ct=ov('f_ct').value.trim(), ad=ov('f_ad').value.trim();
  var rt=ov('f_rt').value, ci=ov('f_ci').value, co=ov('f_co').value;
  var disc=parseFloat(ov('f_disc').value)||0;

  if(!rno){alert('Please enter a Reservation No.');ov('f_rno').focus();return;}
  if(!gn) {alert('Please enter the Guest Name.');ov('f_gn').focus();return;}
  if(!rt) {alert('Please select a Room Type.');ov('f_rt').focus();return;}
  if(!ci) {alert('Please select Check-In date.');ov('f_ci').focus();return;}
  if(!co) {alert('Please select Check-Out date.');ov('f_co').focus();return;}

  var nights=Math.round((new Date(co)-new Date(ci))/86400000);
  if(nights<=0){alert('Check-out must be after check-in.');return;}
  if(disc<0||disc>100){alert('Discount must be 0–100.');return;}

  var rate=RATES[rt]||80;
  var room=rate*nights;
  var svc=room*0.10;
  var tax=room*0.08;
  var sub=room+svc+tax;
  var discAmt=sub*(disc/100);
  var total=sub-discAmt;

  ov('inv_date').textContent=new Date().toLocaleDateString('en-US',{year:'numeric',month:'short',day:'numeric'});
  ov('r_rno_badge').textContent=rno;
  ov('r_gn').textContent=gn;
  ov('r_ct').textContent=ct||'—';
  ov('r_ad').textContent=ad||'—';
  ov('r_rt').textContent='🏨 '+rt;
  ov('r_ci').textContent=ci;
  ov('r_co').textContent=co;
  ov('r_nights_lbl').textContent=nights+(nights===1?' Night':' Nights');
  ov('r_rate_lbl').textContent=fmt(rate)+'/night';
  ov('r_room').textContent=fmt(room);
  ov('r_svc').textContent=fmt(svc);
  ov('r_tax').textContent=fmt(tax);
  ov('r_sub').textContent=fmt(sub);
  ov('r_total').textContent=fmt(total);

  if(disc>0){
    ov('r_disc').textContent='− '+fmt(discAmt)+' ('+disc+'%)';
    ov('r_disc_row').style.display='flex';
  } else {
    ov('r_disc_row').style.display='none';
  }

  var card=ov('resultCard');
  card.classList.remove('show');
  card.style.display='block';
  setTimeout(function(){card.classList.add('show');},10);
  card.scrollIntoView({behavior:'smooth',block:'start'});
}

function resetForm(){
  ['f_rno','f_gn','f_ct','f_ad','f_ci','f_co'].forEach(function(id){ov(id).value='';});
  ov('f_rt').selectedIndex=0;
  ov('f_disc').value='0';
  ov('ratePreview').style.display='none';
  ov('nightBox').style.display='none';
  ov('resultCard').style.display='none';
  ov('resultCard').classList.remove('show');
  ov('f_rno').focus();
}

ov('f_ci').addEventListener('change',function(){
  ov('f_co').min=this.value;
  if(ov('f_co').value&&ov('f_co').value<=this.value) ov('f_co').value='';
  updateNights();
});
</script>
</body>
</html>
