<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("user");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    char initial = Character.toUpperCase(userName.charAt(0));

    Boolean showInvoice = (Boolean) request.getAttribute("showInvoice");
    String  invoiceErr  = (String)  request.getAttribute("invoiceErr");
    if (showInvoice == null) showInvoice = false;

    // Invoice data
    String resNo      = showInvoice ? (String)request.getAttribute("resNo")      : "";
    String guestName  = showInvoice ? (String)request.getAttribute("guestName")  : "";
    String address    = showInvoice ? (String)request.getAttribute("address")    : "";
    String contact    = showInvoice ? (String)request.getAttribute("contact")    : "";
    String roomType   = showInvoice ? (String)request.getAttribute("roomType")   : "";
    String checkin    = showInvoice ? (String)request.getAttribute("checkin")    : "";
    String checkout   = showInvoice ? (String)request.getAttribute("checkout")   : "";
    Object nightsObj  = request.getAttribute("nights");
    long   nights     = nightsObj != null ? (long) nightsObj : 0;
    String roomRate   = showInvoice ? (String)request.getAttribute("roomRate")   : "0.00";
    String roomCharge = showInvoice ? (String)request.getAttribute("roomCharge") : "0.00";
    String serviceAmt = showInvoice ? (String)request.getAttribute("serviceAmt") : "0.00";
    String taxAmt     = showInvoice ? (String)request.getAttribute("taxAmt")     : "0.00";
    String total      = showInvoice ? (String)request.getAttribute("total")      : "0.00";

    // Today's date for invoice
    java.time.LocalDate now = java.time.LocalDate.now();
    String invoiceDate = now.format(java.time.format.DateTimeFormatter.ofPattern("dd MMMM yyyy"));
    String invoiceNo   = "INV-" + resNo + "-" + now.getYear();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Guest Invoice — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400;1,600&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
:root{
  --cream:#faf7f2;--cream2:#f4f0e8;--cream3:#ede7d9;
  --white:#ffffff;
  --navy:#0f1f3d;--navy2:#162847;
  --gold:#b8923a;--gold2:#d4a853;--gold3:#e8c878;--gold-lt:#f5e9cc;
  --teal:#0b5c6b;--teal2:#0e7a8a;
  --text:#1a1a2e;--text2:#3d3d52;--text3:#6b6b80;--text4:#9b9bae;
  --border:#e8e0d0;--border2:#d8cdb8;
  --green:#0d7a5c;--red:#c0392b;
  --shadow:rgba(15,31,61,0.08);--shadow2:rgba(15,31,61,0.15);
  --r:16px;--rs:10px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{font-family:'DM Sans',sans-serif;background:var(--cream);color:var(--text);min-height:100vh;-webkit-font-smoothing:antialiased;}
a{text-decoration:none;color:inherit;}

/* ── NAVBAR ────────────────────────────────── */
.navbar{position:fixed;top:0;width:100%;z-index:300;height:68px;
  background:rgba(250,247,242,.92);backdrop-filter:blur(16px);
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;padding:0 52px;box-shadow:0 2px 12px var(--shadow);}
.nav-brand{display:flex;align-items:center;gap:12px;flex:1;}
.nav-logo{width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,var(--navy),var(--teal));
  display:flex;align-items:center;justify-content:center;font-size:18px;}
.nav-name{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;
  color:var(--navy);letter-spacing:.04em;}
.nav-name em{color:var(--gold);font-style:italic;}
.nav-loc{font-size:10px;color:var(--text3);letter-spacing:.18em;text-transform:uppercase;}
.nav-right{display:flex;align-items:center;gap:12px;}
.btn-back{display:flex;align-items:center;gap:7px;padding:8px 18px;border-radius:100px;
  background:var(--cream2);border:1.5px solid var(--border2);
  color:var(--text2);font-size:12px;font-weight:600;cursor:pointer;
  transition:all .2s;font-family:inherit;}
.btn-back:hover{background:var(--navy);color:#fff;border-color:var(--navy);}
.u-pill{display:flex;align-items:center;gap:8px;padding:5px 14px 5px 5px;
  background:var(--cream2);border:1px solid var(--border2);border-radius:100px;}
.u-av{width:30px;height:30px;border-radius:50%;
  background:linear-gradient(135deg,var(--teal),var(--gold2));
  display:flex;align-items:center;justify-content:center;
  font-size:12px;font-weight:700;color:#fff;}
.u-name{font-size:13px;font-weight:500;color:var(--text2);}

/* ── PAGE ──────────────────────────────────── */
.page{max-width:900px;margin:0 auto;padding:92px 40px 60px;
  display:flex;flex-direction:column;gap:28px;
  animation:fadeUp .45s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px);}to{opacity:1;}}

/* ── PAGE HEADER ───────────────────────────── */
.page-hd{display:flex;align-items:center;justify-content:space-between;}
.page-hd-l h1{font-family:'Cormorant Garamond',serif;font-size:32px;font-weight:400;
  color:var(--navy);letter-spacing:-.01em;}
.page-hd-l h1 em{color:var(--teal);font-style:italic;}
.page-hd-l p{font-size:14px;color:var(--text3);margin-top:4px;}

/* ── SEARCH FORM ───────────────────────────── */
.search-card{background:var(--white);border:1px solid var(--border);
  border-radius:var(--r);padding:28px 32px;
  box-shadow:0 2px 8px var(--shadow);}
.sc-label{font-size:11px;font-weight:600;letter-spacing:.14em;text-transform:uppercase;
  color:var(--text3);margin-bottom:10px;}
.search-row{display:flex;gap:12px;align-items:stretch;}
.s-input{flex:1;background:var(--cream);border:1.5px solid var(--border2);
  border-radius:var(--rs);color:var(--text);font-size:15px;
  padding:13px 18px;outline:none;font-family:inherit;transition:border-color .2s;}
.s-input:focus{border-color:var(--teal);box-shadow:0 0 0 3px rgba(11,92,107,.1);}
.s-input::placeholder{color:var(--text4);}
.btn-search{padding:13px 30px;border-radius:var(--rs);
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;cursor:pointer;
  transition:all .2s;font-family:inherit;white-space:nowrap;}
.btn-search:hover{transform:translateY(-1px);box-shadow:0 6px 20px var(--shadow2);}

/* Error / info */
.err-box{padding:13px 18px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#fef2f2;border:1px solid #fecaca;color:#991b1b;
  display:flex;align-items:center;gap:10px;}
.info-box{padding:13px 18px;border-radius:var(--rs);font-size:14px;
  background:#f0f9ff;border:1px solid #bae6fd;color:#0c4a6e;}

/* ── INVOICE ───────────────────────────────── */
.invoice{background:var(--white);border:1px solid var(--border);
  border-radius:20px;overflow:hidden;
  box-shadow:0 4px 24px var(--shadow2);
  animation:invoiceIn .4s ease both;}
@keyframes invoiceIn{from{opacity:0;transform:translateY(14px);}to{opacity:1;}}

/* Invoice Header */
.inv-head{background:linear-gradient(135deg,var(--navy) 0%,var(--navy2) 55%,var(--teal) 100%);
  padding:40px 48px;position:relative;overflow:hidden;}
.inv-head::before{content:'';position:absolute;top:-40px;right:-40px;
  width:200px;height:200px;border-radius:50%;
  border:1px solid rgba(255,255,255,.07);}
.inv-head::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),transparent);}
.inv-head-row{display:flex;justify-content:space-between;align-items:flex-start;position:relative;z-index:2;}
.inv-hotel{display:flex;align-items:center;gap:14px;}
.inv-hotel-logo{width:50px;height:50px;border-radius:12px;
  background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.2);
  display:flex;align-items:center;justify-content:center;font-size:22px;}
.inv-hotel-name{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;
  color:#fff;letter-spacing:.03em;}
.inv-hotel-loc{font-size:11px;color:rgba(255,255,255,.5);letter-spacing:.14em;
  text-transform:uppercase;margin-top:2px;}
.inv-badge{text-align:right;}
.inv-badge-title{font-size:10px;font-weight:600;letter-spacing:.25em;text-transform:uppercase;
  color:rgba(255,255,255,.5);margin-bottom:6px;}
.inv-badge-no{font-family:'DM Mono',monospace;font-size:20px;font-weight:500;
  color:var(--gold3);letter-spacing:.04em;}
.inv-meta{display:flex;gap:32px;margin-top:28px;position:relative;z-index:2;}
.inv-meta-item{}
.inv-meta-label{font-size:10px;color:rgba(255,255,255,.4);text-transform:uppercase;
  letter-spacing:.14em;margin-bottom:4px;}
.inv-meta-value{font-size:13px;color:rgba(255,255,255,.85);font-weight:500;}
.inv-status{display:inline-flex;align-items:center;gap:7px;padding:6px 16px;
  border-radius:100px;background:rgba(34,197,94,.2);border:1px solid rgba(34,197,94,.35);
  color:#86efac;font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;margin-left:auto;align-self:flex-end;}
.inv-status-dot{width:6px;height:6px;border-radius:50%;background:#86efac;animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.3;}}

/* Invoice Body */
.inv-body{padding:40px 48px;}
.inv-section{margin-bottom:32px;}
.inv-section:last-child{margin-bottom:0;}
.inv-sec-title{font-size:10px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;
  color:var(--text4);margin-bottom:14px;display:flex;align-items:center;gap:10px;}
.inv-sec-title::after{content:'';flex:1;height:1px;background:var(--border);}

/* Guest Info Grid */
.guest-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
.g-item{background:var(--cream);border-radius:var(--rs);padding:14px 18px;}
.g-item-label{font-size:11px;color:var(--text4);margin-bottom:4px;}
.g-item-value{font-size:14px;font-weight:600;color:var(--text);}

/* Room Info */
.room-info{background:linear-gradient(135deg,rgba(11,92,107,.06),rgba(15,31,61,.04));
  border:1px solid rgba(11,92,107,.15);border-radius:var(--r);
  padding:20px 24px;display:flex;align-items:center;justify-content:space-between;}
.ri-left{display:flex;align-items:center;gap:16px;}
.ri-ico{width:50px;height:50px;border-radius:12px;
  background:linear-gradient(135deg,var(--teal),var(--navy));
  display:flex;align-items:center;justify-content:center;font-size:22px;}
.ri-room{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;
  color:var(--navy);}
.ri-nights{font-size:13px;color:var(--text3);margin-top:3px;}
.ri-rate{text-align:right;}
.ri-rate-val{font-family:'DM Mono',monospace;font-size:22px;font-weight:500;color:var(--teal);}
.ri-rate-label{font-size:11px;color:var(--text4);margin-top:2px;}

/* Bill Table */
.bill-table{width:100%;border-collapse:collapse;}
.bill-table th{font-size:10px;font-weight:700;letter-spacing:.18em;text-transform:uppercase;
  color:var(--text4);padding:10px 0;border-bottom:2px solid var(--border);text-align:left;}
.bill-table th:last-child{text-align:right;}
.bill-table td{padding:14px 0;border-bottom:1px solid var(--border);font-size:14px;}
.bill-table td:last-child{text-align:right;font-family:'DM Mono',monospace;font-weight:500;}
.bill-table tr:last-child td{border-bottom:none;}
.bt-label{color:var(--text2);}
.bt-sub{font-size:12px;color:var(--text4);margin-top:2px;}
.bt-teal{color:var(--teal2);}
.bt-amber{color:#b45309;}

/* Total bar */
.total-bar{background:linear-gradient(135deg,var(--navy),var(--navy2));
  border-radius:var(--r);padding:22px 28px;
  display:flex;align-items:center;justify-content:space-between;margin-top:8px;}
.tb-label{font-size:13px;font-weight:600;color:rgba(255,255,255,.7);}
.tb-label-main{font-family:'Cormorant Garamond',serif;font-size:18px;color:#fff;font-weight:600;}
.tb-amount{font-family:'DM Mono',monospace;font-size:32px;font-weight:500;color:var(--gold3);}
.tb-currency{font-size:13px;color:rgba(255,255,255,.5);margin-top:3px;}

/* Action buttons */
.inv-actions{display:flex;gap:14px;padding:28px 48px;border-top:1px solid var(--border);flex-wrap:wrap;}
.btn-print{display:flex;align-items:center;gap:9px;padding:13px 28px;
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;border-radius:var(--rs);
  cursor:pointer;font-family:inherit;transition:all .2s;}
.btn-print:hover{transform:translateY(-2px);box-shadow:0 8px 24px var(--shadow2);}
.btn-download{display:flex;align-items:center;gap:9px;padding:13px 28px;
  background:linear-gradient(135deg,var(--green),#10a37f);
  color:#fff;font-size:14px;font-weight:600;border:none;border-radius:var(--rs);
  cursor:pointer;font-family:inherit;transition:all .2s;position:relative;}
.btn-download:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(13,122,92,.35);}
.btn-download:disabled{opacity:.65;cursor:not-allowed;transform:none;}
.btn-download .dl-spinner{display:none;width:16px;height:16px;border:2px solid rgba(255,255,255,.35);
  border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite;}
.btn-download.loading .dl-spinner{display:block;}
.btn-download.loading .dl-label{display:none;}
@keyframes spin{to{transform:rotate(360deg);}}
.btn-new{display:flex;align-items:center;gap:9px;padding:13px 24px;
  background:transparent;border:1.5px solid var(--border2);
  color:var(--text2);font-size:14px;font-weight:600;border-radius:var(--rs);
  cursor:pointer;font-family:inherit;transition:all .2s;}
.btn-new:hover{background:var(--cream2);border-color:var(--border2);}

/* Download toast */
.dl-toast{position:fixed;bottom:28px;right:28px;z-index:999;
  padding:14px 22px;border-radius:var(--rs);font-size:14px;font-weight:600;
  display:flex;align-items:center;gap:10px;
  box-shadow:0 8px 32px rgba(0,0,0,.18);
  animation:toastIn .3s ease both;}
.dl-toast.ok{background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;}
.dl-toast.err{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;}
@keyframes toastIn{from{opacity:0;transform:translateY(12px);}to{opacity:1;transform:none;}}

/* ── PRINT STYLES ──────────────────────────── */
@media print{
  .navbar,.page-hd,.search-card,.inv-actions,.err-box,.info-box{display:none!important;}
  body{background:#fff!important;padding:0!important;}
  .page{padding:0!important;max-width:100%!important;gap:0!important;}
  .invoice{box-shadow:none!important;border:none!important;border-radius:0!important;}
  .inv-head{print-color-adjust:exact;-webkit-print-color-adjust:exact;}
  .total-bar{print-color-adjust:exact;-webkit-print-color-adjust:exact;}
  .room-info{print-color-adjust:exact;-webkit-print-color-adjust:exact;}
}

/* ── RESPONSIVE ────────────────────────────── */
@media(max-width:700px){
  .page{padding:82px 16px 40px;}
  .navbar{padding:0 16px;}
  .inv-head{padding:28px 24px;}
  .inv-body{padding:24px;}
  .inv-actions{padding:20px 24px;flex-wrap:wrap;}
  .inv-head-row{flex-direction:column;gap:20px;}
  .guest-grid{grid-template-columns:1fr;}
  .room-info{flex-direction:column;gap:14px;text-align:center;}
  .ri-rate{text-align:center;}
  .search-row{flex-direction:column;}
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
    <button class="btn-back" onclick="location.href='user.jsp'">← Back to Portal</button>
    <div class="u-pill">
      <div class="u-av"><%= initial %></div>
      <span class="u-name"><%= userName %></span>
    </div>
  </div>
</nav>

<!-- PAGE -->
<div class="page">

  <!-- Page Header -->
  <div class="page-hd">
    <div class="page-hd-l">
      <h1>Guest <em>Invoice</em></h1>
      <p>Enter your reservation number to generate and print your invoice.</p>
    </div>
  </div>

  <!-- Search Form -->
  <div class="search-card">
    <div class="sc-label">Reservation Number</div>
    <form method="POST" action="GuestInvoice">
      <div class="search-row">
        <input class="s-input" type="text" name="reservationNo"
               placeholder="e.g. RES-2024-001"
               value="<%= showInvoice ? resNo : "" %>"
               required autocomplete="off"/>
        <button type="submit" class="btn-search">🔍 Generate Invoice</button>
      </div>
    </form>
  </div>

  <!-- Error -->
  <% if (invoiceErr != null) { %>
  <div class="err-box">⚠️ <%= invoiceErr %></div>
  <% } %>

  <!-- Empty state -->
  <% if (!showInvoice && invoiceErr == null) { %>
  <div class="info-box">ℹ️ Enter your reservation number above to view and print your invoice.</div>
  <% } %>

  <!-- ══ INVOICE ══════════════════════════════ -->
  <% if (showInvoice) { %>
  <div class="invoice" id="invoiceBlock">

    <!-- Header -->
    <div class="inv-head">
      <div class="inv-head-row">
        <div class="inv-hotel">
          <div class="inv-hotel-logo">🌊</div>
          <div>
            <div class="inv-hotel-name">Ocean View Resort</div>
            <div class="inv-hotel-loc">Galle, Sri Lanka &nbsp;·&nbsp; oceanviewresort.com</div>
          </div>
        </div>
        <div class="inv-badge">
          <div class="inv-badge-title">Invoice Number</div>
          <div class="inv-badge-no"><%= invoiceNo %></div>
        </div>
      </div>
      <div class="inv-meta">
        <div class="inv-meta-item">
          <div class="inv-meta-label">Issue Date</div>
          <div class="inv-meta-value"><%= invoiceDate %></div>
        </div>
        <div class="inv-meta-item">
          <div class="inv-meta-label">Reservation No.</div>
          <div class="inv-meta-value"><%= resNo %></div>
        </div>
        <div class="inv-meta-item">
          <div class="inv-meta-label">Duration</div>
          <div class="inv-meta-value"><%= nights %> Night<%= nights != 1 ? "s" : "" %></div>
        </div>
        <div class="inv-status"><span class="inv-status-dot"></span> Confirmed</div>
      </div>
    </div>

    <!-- Body -->
    <div class="inv-body">

      <!-- Guest Info -->
      <div class="inv-section">
        <div class="inv-sec-title">Guest Information</div>
        <div class="guest-grid">
          <div class="g-item">
            <div class="g-item-label">Full Name</div>
            <div class="g-item-value"><%= guestName %></div>
          </div>
          <div class="g-item">
            <div class="g-item-label">Contact</div>
            <div class="g-item-value"><%= contact.isEmpty() ? "—" : contact %></div>
          </div>
          <div class="g-item">
            <div class="g-item-label">Check-In</div>
            <div class="g-item-value"><%= checkin %></div>
          </div>
          <div class="g-item">
            <div class="g-item-label">Check-Out</div>
            <div class="g-item-value"><%= checkout %></div>
          </div>
          <% if (!address.isEmpty()) { %>
          <div class="g-item" style="grid-column:span 2;">
            <div class="g-item-label">Address</div>
            <div class="g-item-value"><%= address %></div>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Room Details -->
      <div class="inv-section">
        <div class="inv-sec-title">Room Details</div>
        <div class="room-info">
          <div class="ri-left">
            <div class="ri-ico">
              <%  String roomIco = "🛏️";
                  if("Deluxe".equalsIgnoreCase(roomType))         roomIco="✨";
                  else if("Family".equalsIgnoreCase(roomType))    roomIco="👨‍👩‍👧";
                  else if("Ocean View".equalsIgnoreCase(roomType)) roomIco="🌊";
                  else if("Suite".equalsIgnoreCase(roomType))     roomIco="👑";
              %><%= roomIco %>
            </div>
            <div>
              <div class="ri-room"><%= roomType %> Room</div>
              <div class="ri-nights"><%= nights %> night<%= nights != 1 ? "s" : "" %> &nbsp;·&nbsp; <%= checkin %> → <%= checkout %></div>
            </div>
          </div>
          <div class="ri-rate">
            <div class="ri-rate-val">$<%= roomRate %></div>
            <div class="ri-rate-label">per night</div>
          </div>
        </div>
      </div>

      <!-- Bill Breakdown -->
      <div class="inv-section">
        <div class="inv-sec-title">Billing Breakdown</div>
        <table class="bill-table">
          <thead>
            <tr>
              <th>Description</th>
              <th>Rate</th>
              <th>Amount</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="bt-label"><%= roomType %> Room — <%= nights %> Night<%= nights != 1 ? "s" : "" %></div>
                <div class="bt-sub">$<%= roomRate %> × <%= nights %></div>
              </td>
              <td style="font-family:'DM Mono',monospace;color:var(--text3);">$<%= roomRate %> / night</td>
              <td>$<%= roomCharge %></td>
            </tr>
            <tr>
              <td>
                <div class="bt-label bt-teal">Service Charge</div>
                <div class="bt-sub">10% of room charge</div>
              </td>
              <td style="color:var(--text4);">10%</td>
              <td class="bt-teal">+$<%= serviceAmt %></td>
            </tr>
            <tr>
              <td>
                <div class="bt-label bt-amber">Government Tax</div>
                <div class="bt-sub">8% of room charge</div>
              </td>
              <td style="color:var(--text4);">8%</td>
              <td class="bt-amber">+$<%= taxAmt %></td>
            </tr>
          </tbody>
        </table>

        <!-- Total -->
        <div class="total-bar">
          <div>
            <div class="tb-label">Total Amount Due</div>
            <div class="tb-label-main">Including all charges &amp; taxes</div>
          </div>
          <div style="text-align:right;">
            <div class="tb-amount">$<%= total %></div>
            <div class="tb-currency">USD — US Dollar</div>
          </div>
        </div>
      </div>

    </div><!-- /inv-body -->

    <!-- Actions -->
    <div class="inv-actions no-print">
      <button class="btn-print"    onclick="window.print()">🖨️ Print Invoice</button>
      <button class="btn-download" id="btnDownload" onclick="downloadPDF()">
        <span class="dl-label">⬇️ Download PDF</span>
        <span class="dl-spinner"></span>
      </button>
      <button class="btn-new" onclick="location.href='GuestInvoice'">↩ New Lookup</button>
      <button class="btn-new" onclick="location.href='user.jsp'">🏠 Back to Portal</button>
    </div>

  </div><!-- /invoice -->
  <% } %>

</div><!-- /page -->
<!-- PDF Libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script>
async function downloadPDF() {
  var btn = document.getElementById('btnDownload');
  btn.classList.add('loading');
  btn.disabled = true;

  // Hide action buttons while capturing
  var actions = document.querySelector('.inv-actions');
  actions.style.display = 'none';

  try {
    var invoice = document.getElementById('invoiceBlock');

    var canvas = await html2canvas(invoice, {
      scale: 2,
      useCORS: true,
      logging: false,
      backgroundColor: '#ffffff',
      windowWidth: invoice.scrollWidth,
      windowHeight: invoice.scrollHeight
    });

    var imgData = canvas.toDataURL('image/png');

    // A4 dimensions in mm
    var { jsPDF } = window.jspdf;
    var pdf = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4'
    });

    var pageW  = pdf.internal.pageSize.getWidth();   // 210mm
    var pageH  = pdf.internal.pageSize.getHeight();  // 297mm
    var margin = 10;
    var imgW   = pageW - margin * 2;
    var imgH   = (canvas.height * imgW) / canvas.width;

    // If invoice taller than one page, split across pages
    if (imgH <= pageH - margin * 2) {
      pdf.addImage(imgData, 'PNG', margin, margin, imgW, imgH);
    } else {
      var pageImgH  = pageH - margin * 2;
      var pxPerMm   = canvas.width / imgW;
      var pagesPx   = pageImgH * pxPerMm;
      var totalPages= Math.ceil(canvas.height / pagesPx);

      for (var i = 0; i < totalPages; i++) {
        if (i > 0) pdf.addPage();
        var srcY   = i * pagesPx;
        var srcH   = Math.min(pagesPx, canvas.height - srcY);

        var pageCanvas  = document.createElement('canvas');
        pageCanvas.width  = canvas.width;
        pageCanvas.height = srcH;
        var ctx = pageCanvas.getContext('2d');
        ctx.drawImage(canvas, 0, srcY, canvas.width, srcH, 0, 0, canvas.width, srcH);

        var sliceData = pageCanvas.toDataURL('image/png');
        var sliceH    = (srcH * imgW) / canvas.width;
        pdf.addImage(sliceData, 'PNG', margin, margin, imgW, sliceH);
      }
    }

    // File name: Invoice-RES123-2026.pdf
    var fileName = 'Invoice-<%= invoiceNo %>.pdf';
    pdf.save(fileName);

    showToast('✅ Invoice downloaded as ' + fileName, 'ok');

  } catch (err) {
    console.error('PDF error:', err);
    showToast('❌ Download failed. Please use Print instead.', 'err');
  } finally {
    actions.style.display = 'flex';
    btn.classList.remove('loading');
    btn.disabled = false;
  }
}

function showToast(msg, type) {
  var old = document.querySelector('.dl-toast');
  if (old) old.remove();
  var t = document.createElement('div');
  t.className = 'dl-toast ' + type;
  t.textContent = msg;
  document.body.appendChild(t);
  setTimeout(function(){
    t.style.transition = 'opacity .5s';
    t.style.opacity = '0';
    setTimeout(function(){ t.remove(); }, 500);
  }, 4000);
}
</script>
</body>
</html>
