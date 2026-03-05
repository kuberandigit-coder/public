<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Register.GuestInvoiceServlet.InvoiceData, java.util.*" %>
<%
    String userName = (String) session.getAttribute("user");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    char initial = Character.toUpperCase(userName.charAt(0));

    String  invoiceErr  = (String)  request.getAttribute("invoiceErr");
    Boolean showInvoice = (Boolean) request.getAttribute("showInvoice");
    Boolean showList    = (Boolean) request.getAttribute("showList");
    if (showInvoice == null) showInvoice = false;
    if (showList    == null) showList    = false;

    String searchType  = (String) request.getAttribute("searchType");
    String searchValue = (String) request.getAttribute("searchValue");
    if (searchType  == null) searchType  = "resNo";
    if (searchValue == null) searchValue = "";

    // Single invoice data
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

    // Contact search list
    List<InvoiceData> invoiceList = (List<InvoiceData>) request.getAttribute("invoiceList");

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

/* NAVBAR */
.navbar{position:fixed;top:0;width:100%;z-index:300;height:68px;
  background:rgba(250,247,242,.92);backdrop-filter:blur(16px);
  border-bottom:1px solid var(--border);
  display:flex;align-items:center;padding:0 52px;box-shadow:0 2px 12px var(--shadow);}
.nav-brand{display:flex;align-items:center;gap:12px;flex:1;}
.nav-logo{width:38px;height:38px;border-radius:50%;
  background:linear-gradient(135deg,var(--navy),var(--teal));
  display:flex;align-items:center;justify-content:center;font-size:18px;}
.nav-name{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;color:var(--navy);letter-spacing:.04em;}
.nav-name em{color:var(--gold);font-style:italic;}
.nav-loc{font-size:10px;color:var(--text3);letter-spacing:.18em;text-transform:uppercase;}
.nav-right{display:flex;align-items:center;gap:12px;}
.btn-back{display:flex;align-items:center;gap:7px;padding:8px 18px;border-radius:100px;
  background:var(--cream2);border:1.5px solid var(--border2);
  color:var(--text2);font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;font-family:inherit;}
.btn-back:hover{background:var(--navy);color:#fff;border-color:var(--navy);}
.u-pill{display:flex;align-items:center;gap:8px;padding:5px 14px 5px 5px;
  background:var(--cream2);border:1px solid var(--border2);border-radius:100px;}
.u-av{width:30px;height:30px;border-radius:50%;
  background:linear-gradient(135deg,var(--teal),var(--gold2));
  display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#fff;}
.u-name{font-size:13px;font-weight:500;color:var(--text2);}

/* PAGE */
.page{max-width:900px;margin:0 auto;padding:92px 40px 60px;
  display:flex;flex-direction:column;gap:24px;animation:fadeUp .45s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px);}to{opacity:1;}}
.page-hd-l h1{font-family:'Cormorant Garamond',serif;font-size:32px;font-weight:400;color:var(--navy);}
.page-hd-l h1 em{color:var(--teal);font-style:italic;}
.page-hd-l p{font-size:14px;color:var(--text3);margin-top:4px;}

/* SEARCH CARD */
.search-card{background:var(--white);border:1px solid var(--border);border-radius:var(--r);padding:28px 32px;box-shadow:0 2px 8px var(--shadow);}

/* Toggle tabs */
.search-tabs{display:flex;gap:0;background:var(--cream2);border:1px solid var(--border2);
  border-radius:var(--rs);padding:3px;margin-bottom:18px;}
.stab{flex:1;padding:9px 14px;border-radius:8px;border:none;background:transparent;
  font-family:inherit;font-size:12px;font-weight:600;color:var(--text3);
  cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:6px;}
.stab.active{background:var(--white);color:var(--navy);box-shadow:0 1px 4px var(--shadow);border:1px solid var(--border);}
.stab:hover:not(.active){color:var(--text2);}

.sc-label{font-size:11px;font-weight:700;letter-spacing:.14em;text-transform:uppercase;color:var(--text3);margin-bottom:10px;}
.search-row{display:flex;gap:12px;align-items:stretch;}
.s-input{flex:1;background:var(--cream);border:1.5px solid var(--border2);border-radius:var(--rs);
  color:var(--text);font-size:15px;padding:13px 18px;outline:none;font-family:inherit;transition:border-color .2s;}
.s-input:focus{border-color:var(--teal);box-shadow:0 0 0 3px rgba(11,92,107,.1);}
.s-input::placeholder{color:var(--text4);}
.btn-search{padding:13px 30px;border-radius:var(--rs);
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;cursor:pointer;
  transition:all .2s;font-family:inherit;white-space:nowrap;}
.btn-search:hover{transform:translateY(-1px);box-shadow:0 6px 20px var(--shadow2);}
.search-hint{font-size:11px;color:var(--text4);margin-top:10px;display:flex;align-items:center;gap:5px;}

/* ERROR / INFO */
.err-box{padding:13px 18px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#fef2f2;border:1px solid #fecaca;color:#991b1b;display:flex;align-items:center;gap:10px;}
.info-box{padding:13px 18px;border-radius:var(--rs);font-size:14px;
  background:#f0f9ff;border:1px solid #bae6fd;color:#0c4a6e;}

/* RESERVATION PICKER LIST (contact search results) */
.picker-label{font-size:12px;font-weight:600;color:var(--text3);
  display:flex;align-items:center;gap:8px;margin-bottom:4px;}
.picker-label span{background:var(--navy);color:#fff;font-size:11px;padding:2px 10px;border-radius:100px;}
.picker-list{display:flex;flex-direction:column;gap:10px;}
.picker-card{background:var(--white);border:1.5px solid var(--border);border-radius:var(--r);
  padding:18px 24px;display:flex;align-items:center;justify-content:space-between;
  cursor:pointer;transition:all .22s;box-shadow:0 2px 8px var(--shadow);}
.picker-card:hover{border-color:var(--teal);box-shadow:0 4px 20px rgba(11,92,107,.12);transform:translateY(-1px);}
.pc-left{display:flex;align-items:center;gap:16px;}
.pc-ico{width:42px;height:42px;border-radius:10px;
  background:linear-gradient(135deg,var(--teal),var(--navy));
  display:flex;align-items:center;justify-content:center;font-size:18px;color:#fff;}
.pc-resno{font-family:'DM Mono',monospace;font-size:15px;font-weight:600;color:var(--navy);}
.pc-meta{font-size:12px;color:var(--text3);margin-top:3px;}
.pc-right{display:flex;align-items:center;gap:14px;}
.pc-room{font-size:12px;font-weight:600;padding:4px 12px;border-radius:100px;
  background:rgba(11,92,107,.08);color:var(--teal);border:1px solid rgba(11,92,107,.15);}
.pc-arrow{color:var(--text4);font-size:18px;transition:transform .2s;}
.picker-card:hover .pc-arrow{transform:translateX(4px);color:var(--teal);}

/* INVOICE */
.invoice{background:var(--white);border:1px solid var(--border);border-radius:20px;overflow:hidden;
  box-shadow:0 4px 24px var(--shadow2);animation:invoiceIn .4s ease both;}
@keyframes invoiceIn{from{opacity:0;transform:translateY(14px);}to{opacity:1;}}
.inv-head{background:linear-gradient(135deg,var(--navy) 0%,var(--navy2) 55%,var(--teal) 100%);
  padding:40px 48px;position:relative;overflow:hidden;}
.inv-head::before{content:'';position:absolute;top:-40px;right:-40px;width:200px;height:200px;
  border-radius:50%;border:1px solid rgba(255,255,255,.07);}
.inv-head::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),transparent);}
.inv-head-row{display:flex;justify-content:space-between;align-items:flex-start;position:relative;z-index:2;}
.inv-hotel{display:flex;align-items:center;gap:14px;}
.inv-hotel-logo{width:50px;height:50px;border-radius:12px;background:rgba(255,255,255,.1);
  border:1px solid rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:22px;}
.inv-hotel-name{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;color:#fff;letter-spacing:.03em;}
.inv-hotel-loc{font-size:11px;color:rgba(255,255,255,.5);letter-spacing:.14em;text-transform:uppercase;margin-top:2px;}
.inv-badge{text-align:right;}
.inv-badge-title{font-size:10px;font-weight:600;letter-spacing:.25em;text-transform:uppercase;color:rgba(255,255,255,.5);margin-bottom:6px;}
.inv-badge-no{font-family:'DM Mono',monospace;font-size:20px;font-weight:500;color:var(--gold3);letter-spacing:.04em;}
.inv-meta{display:flex;gap:32px;margin-top:28px;position:relative;z-index:2;}
.inv-meta-label{font-size:10px;color:rgba(255,255,255,.4);text-transform:uppercase;letter-spacing:.14em;margin-bottom:4px;}
.inv-meta-value{font-size:13px;color:rgba(255,255,255,.85);font-weight:500;}
.inv-status{display:inline-flex;align-items:center;gap:7px;padding:6px 16px;border-radius:100px;
  background:rgba(34,197,94,.2);border:1px solid rgba(34,197,94,.35);
  color:#86efac;font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;
  margin-left:auto;align-self:flex-end;}
.inv-status-dot{width:6px;height:6px;border-radius:50%;background:#86efac;animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.3;}}
.inv-body{padding:40px 48px;}
.inv-section{margin-bottom:32px;}
.inv-section:last-child{margin-bottom:0;}
.inv-sec-title{font-size:10px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;
  color:var(--text4);margin-bottom:14px;display:flex;align-items:center;gap:10px;}
.inv-sec-title::after{content:'';flex:1;height:1px;background:var(--border);}
.guest-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
.g-item{background:var(--cream);border-radius:var(--rs);padding:14px 18px;}
.g-item-label{font-size:11px;color:var(--text4);margin-bottom:4px;}
.g-item-value{font-size:14px;font-weight:600;color:var(--text);}
.room-info{background:linear-gradient(135deg,rgba(11,92,107,.06),rgba(15,31,61,.04));
  border:1px solid rgba(11,92,107,.15);border-radius:var(--r);
  padding:20px 24px;display:flex;align-items:center;justify-content:space-between;}
.ri-left{display:flex;align-items:center;gap:16px;}
.ri-ico{width:50px;height:50px;border-radius:12px;
  background:linear-gradient(135deg,var(--teal),var(--navy));
  display:flex;align-items:center;justify-content:center;font-size:22px;}
.ri-room{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;color:var(--navy);}
.ri-nights{font-size:13px;color:var(--text3);margin-top:3px;}
.ri-rate-val{font-family:'DM Mono',monospace;font-size:22px;font-weight:500;color:var(--teal);text-align:right;}
.ri-rate-label{font-size:11px;color:var(--text4);margin-top:2px;text-align:right;}
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
.total-bar{background:linear-gradient(135deg,var(--navy),var(--navy2));border-radius:var(--r);
  padding:22px 28px;display:flex;align-items:center;justify-content:space-between;margin-top:8px;}
.tb-label{font-size:13px;font-weight:600;color:rgba(255,255,255,.7);}
.tb-label-main{font-family:'Cormorant Garamond',serif;font-size:18px;color:#fff;font-weight:600;}
.tb-amount{font-family:'DM Mono',monospace;font-size:32px;font-weight:500;color:var(--gold3);}
.tb-currency{font-size:13px;color:rgba(255,255,255,.5);margin-top:3px;}
.inv-actions{display:flex;gap:14px;padding:28px 48px;border-top:1px solid var(--border);flex-wrap:wrap;}
.btn-print{display:flex;align-items:center;gap:9px;padding:13px 28px;
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;border-radius:var(--rs);
  cursor:pointer;font-family:inherit;transition:all .2s;}
.btn-print:hover{transform:translateY(-2px);box-shadow:0 8px 24px var(--shadow2);}
.btn-download{display:flex;align-items:center;gap:9px;padding:13px 28px;
  background:linear-gradient(135deg,var(--green),#10a37f);
  color:#fff;font-size:14px;font-weight:600;border:none;border-radius:var(--rs);
  cursor:pointer;font-family:inherit;transition:all .2s;}
.btn-download:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(13,122,92,.35);}
.btn-download:disabled{opacity:.65;cursor:not-allowed;transform:none;}
.btn-new{display:flex;align-items:center;gap:9px;padding:13px 24px;
  background:transparent;border:1.5px solid var(--border2);color:var(--text2);
  font-size:14px;font-weight:600;border-radius:var(--rs);cursor:pointer;font-family:inherit;transition:all .2s;}
.btn-new:hover{background:var(--cream2);}
.dl-spinner{display:none;width:16px;height:16px;border:2px solid rgba(255,255,255,.35);
  border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite;}
.btn-download.loading .dl-spinner{display:block;}
.btn-download.loading .dl-label{display:none;}
@keyframes spin{to{transform:rotate(360deg);}}
.dl-toast{position:fixed;bottom:28px;right:28px;z-index:999;padding:14px 22px;
  border-radius:var(--rs);font-size:14px;font-weight:600;
  display:flex;align-items:center;gap:10px;box-shadow:0 8px 32px rgba(0,0,0,.18);
  animation:toastIn .3s ease both;}
.dl-toast.ok{background:#f0fdf4;border:1px solid #bbf7d0;color:#166534;}
.dl-toast.err{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;}
@keyframes toastIn{from{opacity:0;transform:translateY(12px);}to{opacity:1;}}

/* PRINT */
@media print{
  .navbar,.page-hd,.search-card,.inv-actions,.err-box,.info-box,.picker-list,.picker-label{display:none!important;}
  body{background:#fff!important;padding:0!important;}
  .page{padding:0!important;max-width:100%!important;gap:0!important;}
  .invoice{box-shadow:none!important;border:none!important;border-radius:0!important;}
  .inv-head,.total-bar,.room-info{print-color-adjust:exact;-webkit-print-color-adjust:exact;}
}
@media(max-width:700px){
  .page{padding:82px 16px 40px;}
  .navbar{padding:0 16px;}
  .inv-head{padding:28px 24px;}
  .inv-body{padding:24px;}
  .inv-actions{padding:20px 24px;flex-wrap:wrap;}
  .inv-head-row{flex-direction:column;gap:20px;}
  .guest-grid{grid-template-columns:1fr;}
  .room-info{flex-direction:column;gap:14px;text-align:center;}
  .search-row{flex-direction:column;}
  .picker-card{flex-direction:column;align-items:flex-start;gap:12px;}
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
    <button class="btn-back" onclick="location.href='home.jsp'">← Back to Portal</button>
    <div class="u-pill">
      <div class="u-av"><%= initial %></div>
      <span class="u-name"><%= userName %></span>
    </div>
  </div>
</nav>

<div class="page">

  <div class="page-hd">
    <div class="page-hd-l">
      <h1>Guest <em>Invoice</em></h1>
      <p>Search by reservation number or contact number to generate your invoice.</p>
    </div>
  </div>

  <!-- SEARCH CARD -->
  <div class="search-card">
    <div class="search-tabs">
      <button class="stab <%= "contact".equals(searchType) ? "" : "active" %>"
              id="tabResNo" onclick="switchTab('resNo')">
        🔖 Reservation Number
      </button>
      <button class="stab <%= "contact".equals(searchType) ? "active" : "" %>"
              id="tabContact" onclick="switchTab('contact')">
        📞 Contact Number
      </button>
    </div>

    <form method="POST" action="GuestInvoice" id="searchForm">
      <input type="hidden" name="searchType" id="searchTypeInput" value="<%= searchType %>"/>

      <div class="sc-label" id="scLabel">
        <%= "contact".equals(searchType) ? "Your Contact Number" : "Reservation Number" %>
      </div>
      <div class="search-row">
        <input class="s-input" type="text" name="searchValue" id="searchInput"
               placeholder="<%= "contact".equals(searchType) ? "e.g. 0761856976" : "e.g. RES-001" %>"
               value="<%= searchValue %>"
               required autocomplete="off"/>
        <button type="submit" class="btn-search">🔍 Generate Invoice</button>
      </div>
      <div class="search-hint" id="searchHint">
        <%= "contact".equals(searchType)
            ? "ℹ️ Enter the contact number you used when booking"
            : "ℹ️ Enter your reservation number e.g. RES-001" %>
      </div>
    </form>
  </div>

  <!-- ERROR -->
  <% if (invoiceErr != null) { %>
  <div class="err-box">⚠️ <%= invoiceErr %></div>
  <% } %>

  <!-- EMPTY STATE -->
  <% if (!showInvoice && !showList && invoiceErr == null) { %>
  <div class="info-box">ℹ️ Use <strong>Reservation Number</strong> for a direct invoice, or <strong>Contact Number</strong> if you forgot your reservation number.</div>
  <% } %>

  <!-- CONTACT SEARCH — RESERVATION PICKER -->
  <% if (showList && invoiceList != null && !invoiceList.isEmpty()) { %>
  <div class="picker-label">
    Select your reservation <span><%= invoiceList.size() %></span>
  </div>
  <div class="picker-list">
    <% for (InvoiceData inv : invoiceList) { %>
    <div class="picker-card" onclick="selectReservation('<%= inv.resNo %>')">
      <div class="pc-left">
        <div class="pc-ico">📋</div>
        <div>
          <div class="pc-resno"><%= inv.resNo %></div>
          <div class="pc-meta">
            <%= inv.checkin %> → <%= inv.checkout %>
            &nbsp;·&nbsp; <%= inv.nights %> night<%= inv.nights != 1 ? "s" : "" %>
            &nbsp;·&nbsp; <%= inv.guestName %>
          </div>
        </div>
      </div>
      <div class="pc-right">
        <span class="pc-room"><%= inv.roomType %></span>
        <span class="pc-arrow">›</span>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>

  <!-- INVOICE (single result) -->
  <% if (showInvoice) { %>
  <div class="invoice" id="invoiceBlock">

    <div class="inv-head">
      <div class="inv-head-row">
        <div class="inv-hotel">
          <div class="inv-hotel-logo">🌊</div>
          <div>
            <div class="inv-hotel-name">Ocean View Resort</div>
            <div class="inv-hotel-loc">Galle, Sri Lanka · oceanviewresort.com</div>
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

    <div class="inv-body">
      <div class="inv-section">
        <div class="inv-sec-title">Guest Information</div>
        <div class="guest-grid">
          <div class="g-item"><div class="g-item-label">Full Name</div><div class="g-item-value"><%= guestName %></div></div>
          <div class="g-item"><div class="g-item-label">Contact</div><div class="g-item-value"><%= contact.isEmpty() ? "—" : contact %></div></div>
          <div class="g-item"><div class="g-item-label">Check-In</div><div class="g-item-value"><%= checkin %></div></div>
          <div class="g-item"><div class="g-item-label">Check-Out</div><div class="g-item-value"><%= checkout %></div></div>
          <% if (!address.isEmpty()) { %>
          <div class="g-item" style="grid-column:span 2;"><div class="g-item-label">Address</div><div class="g-item-value"><%= address %></div></div>
          <% } %>
        </div>
      </div>

      <div class="inv-section">
        <div class="inv-sec-title">Room Details</div>
        <div class="room-info">
          <div class="ri-left">
            <div class="ri-ico">
              <% String roomIco="🛏️";
                 if("Deluxe".equalsIgnoreCase(roomType))          roomIco="✨";
                 else if("Family".equalsIgnoreCase(roomType))     roomIco="👨‍👩‍👧";
                 else if("Ocean View".equalsIgnoreCase(roomType)) roomIco="🌊";
                 else if("Suite".equalsIgnoreCase(roomType))      roomIco="👑";
              %><%= roomIco %>
            </div>
            <div>
              <div class="ri-room"><%= roomType %> Room</div>
              <div class="ri-nights"><%= nights %> night<%= nights!=1?"s":"" %> &nbsp;·&nbsp; <%= checkin %> → <%= checkout %></div>
            </div>
          </div>
          <div>
            <div class="ri-rate-val">$<%= roomRate %></div>
            <div class="ri-rate-label">per night</div>
          </div>
        </div>
      </div>

      <div class="inv-section">
        <div class="inv-sec-title">Billing Breakdown</div>
        <table class="bill-table">
          <thead><tr><th>Description</th><th>Rate</th><th>Amount</th></tr></thead>
          <tbody>
            <tr>
              <td><div class="bt-label"><%= roomType %> Room — <%= nights %> Night<%= nights!=1?"s":"" %></div><div class="bt-sub">$<%= roomRate %> × <%= nights %></div></td>
              <td style="font-family:'DM Mono',monospace;color:var(--text3);">$<%= roomRate %>/night</td>
              <td>$<%= roomCharge %></td>
            </tr>
            <tr>
              <td><div class="bt-label bt-teal">Service Charge</div><div class="bt-sub">10% of room charge</div></td>
              <td style="color:var(--text4);">10%</td>
              <td class="bt-teal">+$<%= serviceAmt %></td>
            </tr>
            <tr>
              <td><div class="bt-label bt-amber">Government Tax</div><div class="bt-sub">8% of room charge</div></td>
              <td style="color:var(--text4);">8%</td>
              <td class="bt-amber">+$<%= taxAmt %></td>
            </tr>
          </tbody>
        </table>
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
    </div>

    <div class="inv-actions">
      <button class="btn-print" onclick="window.print()">🖨️ Print Invoice</button>
      <button class="btn-download" id="btnDownload" onclick="downloadPDF()">
        <span class="dl-label">⬇️ Download PDF</span>
        <span class="dl-spinner"></span>
      </button>
      <button class="btn-new" onclick="location.href='GuestInvoice'">↩ New Lookup</button>
      <button class="btn-new" onclick="location.href='home.jsp'">🏠 Back to Portal</button>
    </div>

  </div>
  <% } %>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script>
// Switch tabs
function switchTab(type) {
  document.getElementById('searchTypeInput').value = type;
  var tabResNo   = document.getElementById('tabResNo');
  var tabContact = document.getElementById('tabContact');
  var label      = document.getElementById('scLabel');
  var input      = document.getElementById('searchInput');
  var hint       = document.getElementById('searchHint');
  if (type === 'contact') {
    tabContact.classList.add('active'); tabResNo.classList.remove('active');
    label.textContent = 'Your Contact Number';
    input.placeholder = 'e.g. 0761856976';
    hint.textContent  = 'ℹ️ Enter the contact number you used when booking';
  } else {
    tabResNo.classList.add('active'); tabContact.classList.remove('active');
    label.textContent = 'Reservation Number';
    input.placeholder = 'e.g. RES-001';
    hint.textContent  = 'ℹ️ Enter your reservation number e.g. RES-001';
  }
  document.getElementById('searchInput').value = '';
  document.getElementById('searchInput').focus();
}

// When user picks a reservation from contact search list — submit as resNo search
function selectReservation(resNo) {
  document.getElementById('searchTypeInput').value = 'resNo';
  document.getElementById('searchInput').value     = resNo;
  document.getElementById('searchForm').submit();
}

// ── PDF Generation ────────────────────────────────────────────────────────
var INV = {
  invoiceNo   : "<%= invoiceNo %>",
  invoiceDate : "<%= invoiceDate %>",
  resNo       : "<%= resNo %>",
  guestName   : "<%= guestName %>",
  address     : "<%= address %>",
  contact     : "<%= contact %>",
  roomType    : "<%= roomType %>",
  checkin     : "<%= checkin %>",
  checkout    : "<%= checkout %>",
  nights      : "<%= nights %>",
  roomRate    : "<%= roomRate %>",
  roomCharge  : "<%= roomCharge %>",
  serviceAmt  : "<%= serviceAmt %>",
  taxAmt      : "<%= taxAmt %>",
  total       : "<%= total %>"
};

function downloadPDF() {
  var btn = document.getElementById('btnDownload');
  btn.classList.add('loading'); btn.disabled = true;
  try {
    var { jsPDF } = window.jspdf;
    var doc = new jsPDF({ orientation:'portrait', unit:'mm', format:'a4' });
    var W=210, m=14, cw=W-m*2, y=0;

    function hex(h){ h=h.replace('#',''); return[parseInt(h.substring(0,2),16),parseInt(h.substring(2,4),16),parseInt(h.substring(4,6),16)]; }
    function setFill(h){ var c=hex(h); doc.setFillColor(c[0],c[1],c[2]); }
    function setDraw(h){ var c=hex(h); doc.setDrawColor(c[0],c[1],c[2]); }
    function setTxt(h) { var c=hex(h); doc.setTextColor(c[0],c[1],c[2]); }
    function bold(s)   { doc.setFont('helvetica','bold');   doc.setFontSize(s); }
    function normal(s) { doc.setFont('helvetica','normal'); doc.setFontSize(s); }

    // Header
    setFill('#0f1f3d'); doc.rect(0,0,W,52,'F');
    setFill('#b8923a'); doc.rect(0,51,W,1.2,'F');
    bold(18); setTxt('#ffffff'); doc.text('Ocean View Resort',m,18);
    normal(8); setTxt('#b8c8d8'); doc.text('Galle, Sri Lanka  ·  oceanviewresort.com',m,24);
    bold(9); setTxt('#9b9bae'); doc.text('INVOICE NUMBER',W-m,14,{align:'right'});
    bold(14); setTxt('#e8c878'); doc.text(INV.invoiceNo,W-m,22,{align:'right'});

    var metaY=36, cols=[m,m+52,m+104,m+155];
    var mLabels=['ISSUE DATE','RESERVATION NO.','DURATION','STATUS'];
    var mVals=[INV.invoiceDate,INV.resNo,INV.nights+' Night'+(INV.nights!='1'?'s':''),'Confirmed'];
    for(var i=0;i<4;i++){
      normal(7); setTxt('#7a8fa8'); doc.text(mLabels[i],cols[i],metaY);
      bold(9); setTxt('#e8eef5'); doc.text(mVals[i],cols[i],metaY+5.5);
    }
    y=62;

    // Guest Info
    bold(8); setTxt('#9b9bae'); doc.text('GUEST INFORMATION',m,y);
    setDraw('#e8e0d0'); doc.setLineWidth(0.3); doc.line(m+38,y-1,W-m,y-1);
    y+=5;
    var boxH=16, boxW=(cw-6)/2;
    function infoBox(label,value,bx,by){
      setFill('#faf7f2'); setDraw('#e8e0d0'); doc.setLineWidth(0.3);
      doc.roundedRect(bx,by,boxW,boxH,2,2,'FD');
      normal(7); setTxt('#9b9bae'); doc.text(label,bx+4,by+5.5);
      bold(9.5); setTxt('#1a1a2e'); doc.text(value||'—',bx+4,by+11.5);
    }
    infoBox('Full Name',INV.guestName,m,y);
    infoBox('Contact',INV.contact||'—',m+boxW+6,y); y+=boxH+3;
    infoBox('Check-In',INV.checkin,m,y);
    infoBox('Check-Out',INV.checkout,m+boxW+6,y); y+=boxH+3;
    if(INV.address){
      setFill('#faf7f2'); setDraw('#e8e0d0'); doc.setLineWidth(0.3);
      doc.roundedRect(m,y,cw,boxH,2,2,'FD');
      normal(7); setTxt('#9b9bae'); doc.text('Address',m+4,y+5.5);
      bold(9.5); setTxt('#1a1a2e'); doc.text(INV.address,m+4,y+11.5);
      y+=boxH+3;
    }
    y+=4;

    // Room Details
    bold(8); setTxt('#9b9bae'); doc.text('ROOM DETAILS',m,y);
    setDraw('#e8e0d0'); doc.setLineWidth(0.3); doc.line(m+29,y-1,W-m,y-1); y+=5;
    setFill('#eaf4f6'); setDraw('#b8dce2'); doc.setLineWidth(0.4);
    doc.roundedRect(m,y,cw,20,3,3,'FD');
    bold(12); setTxt('#0f1f3d'); doc.text(INV.roomType+' Room',m+5,y+8);
    normal(8.5); setTxt('#6b6b80'); doc.text(INV.nights+' night'+(INV.nights!='1'?'s':'')+' · '+INV.checkin+' → '+INV.checkout,m+5,y+14);
    bold(14); setTxt('#0b5c6b'); doc.text('$'+INV.roomRate,W-m-4,y+9,{align:'right'});
    normal(8); setTxt('#9b9bae'); doc.text('per night',W-m-4,y+15,{align:'right'});
    y+=28;

    // Billing
    bold(8); setTxt('#9b9bae'); doc.text('BILLING BREAKDOWN',m,y);
    setDraw('#e8e0d0'); doc.setLineWidth(0.3); doc.line(m+36,y-1,W-m,y-1); y+=5;
    setFill('#f4f0e8'); doc.rect(m,y,cw,8,'F');
    bold(7.5); setTxt('#6b6b80');
    doc.text('DESCRIPTION',m+3,y+5.2);
    doc.text('RATE',m+108,y+5.2);
    doc.text('AMOUNT',W-m-3,y+5.2,{align:'right'});
    y+=8;
    var rows=[
      {desc:INV.roomType+' Room — '+INV.nights+' Night'+(INV.nights!='1'?'s':''),sub:'$'+INV.roomRate+' × '+INV.nights+' nights',rate:'$'+INV.roomRate+'/night',amt:'$'+INV.roomCharge,color:'#1a1a2e'},
      {desc:'Service Charge',sub:'10% of room charge',rate:'10%',amt:'+$'+INV.serviceAmt,color:'#0b5c6b'},
      {desc:'Government Tax',sub:'8% of room charge',rate:'8%',amt:'+$'+INV.taxAmt,color:'#b45309'}
    ];
    for(var r=0;r<rows.length;r++){
      var row=rows[r], rowH=14;
      r%2===0?(setFill('#ffffff')):(setFill('#faf7f2'));
      doc.rect(m,y,cw,rowH,'F');
      setDraw('#e8e0d0'); doc.setLineWidth(0.2); doc.line(m,y+rowH,m+cw,y+rowH);
      bold(9); setTxt(row.color); doc.text(row.desc,m+3,y+5.5);
      normal(7.5); setTxt('#9b9bae'); doc.text(row.sub,m+3,y+10.5);
      normal(9); setTxt('#6b6b80'); doc.text(row.rate,m+108,y+5.5);
      bold(10); setTxt(row.color); doc.text(row.amt,W-m-3,y+5.5,{align:'right'});
      y+=rowH;
    }
    y+=5;

    // Total
    setFill('#0f1f3d'); doc.roundedRect(m,y,cw,22,3,3,'F');
    setFill('#b8923a'); doc.rect(m,y,3,22,'F');
    normal(9); setTxt('#aab8cc'); doc.text('Total Amount Due',m+8,y+8);
    normal(8); setTxt('#7a8fa8'); doc.text('Including all charges & taxes',m+8,y+14);
    bold(20); setTxt('#e8c878'); doc.text('$'+INV.total,W-m-4,y+13,{align:'right'});
    normal(8); setTxt('#6a7a8a'); doc.text('USD',W-m-4,y+19,{align:'right'});
    y+=30;

    // Footer
    setDraw('#e8e0d0'); doc.setLineWidth(0.3); doc.line(m,y,W-m,y); y+=5;
    normal(7.5); setTxt('#9b9bae');
    doc.text('Ocean View Resort  ·  Galle, Sri Lanka  ·  Thank you for your stay!',W/2,y,{align:'center'});
    normal(7); doc.text('Generated on '+INV.invoiceDate+'  ·  '+INV.invoiceNo,W/2,y+4.5,{align:'center'});

    doc.save('Invoice-'+INV.invoiceNo+'.pdf');
    showToast('✅ PDF downloaded: Invoice-'+INV.invoiceNo+'.pdf','ok');
  } catch(err) {
    console.error('PDF error:',err);
    showToast('❌ Download failed. Please use Print instead.','err');
  } finally {
    btn.classList.remove('loading'); btn.disabled=false;
  }
}

function showToast(msg,type){
  var old=document.querySelector('.dl-toast'); if(old) old.remove();
  var t=document.createElement('div'); t.className='dl-toast '+type; t.textContent=msg;
  document.body.appendChild(t);
  setTimeout(function(){ t.style.transition='opacity .5s'; t.style.opacity='0';
    setTimeout(function(){ t.remove(); },500); },4500);
}
</script>
</body>
</html>
