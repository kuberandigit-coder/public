<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Register.Reservation, java.util.*" %>
<%
    String userName = (String) session.getAttribute("user");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    char initial = Character.toUpperCase(userName.charAt(0));

    String errorMessage = (String) request.getAttribute("error");
    String searchType   = (String) request.getAttribute("searchType");
    String searchValue  = (String) request.getAttribute("searchValue");
    List<Reservation> results = (List<Reservation>) request.getAttribute("results");
    if (searchType  == null) searchType  = "resNo";
    if (searchValue == null) searchValue = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>View Reservation — Ocean View Resort</title>
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

/* NAVBAR */
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

/* PAGE */
.page{max-width:660px;margin:0 auto;padding:96px 24px 60px;
  display:flex;flex-direction:column;gap:24px;
  animation:fadeUp .45s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px);}to{opacity:1;}}

/* PAGE HEADER */
.page-hd{text-align:center;}
.page-eyebrow{display:inline-flex;align-items:center;gap:8px;padding:5px 16px;
  border-radius:100px;background:var(--gold-lt);border:1px solid rgba(184,146,58,.3);
  font-size:10px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;
  color:var(--gold);margin-bottom:14px;}
.page-hd h1{font-family:'Cormorant Garamond',serif;font-size:38px;font-weight:400;
  color:var(--navy);margin-bottom:8px;}
.page-hd h1 em{font-style:italic;color:var(--teal);}
.page-hd p{font-size:14px;color:var(--text3);line-height:1.7;}

/* SEARCH CARD */
.search-card{background:var(--white);border:1px solid var(--border);
  border-radius:20px;padding:28px 32px;box-shadow:0 2px 12px var(--shadow);}

/* Toggle tabs */
.search-tabs{display:flex;gap:0;background:var(--cream2);border:1px solid var(--border2);
  border-radius:var(--rs);padding:3px;margin-bottom:18px;}
.stab{flex:1;padding:9px 14px;border-radius:8px;border:none;background:transparent;
  font-family:inherit;font-size:12px;font-weight:600;color:var(--text3);
  cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:6px;}
.stab.active{background:var(--white);color:var(--navy);
  box-shadow:0 1px 4px var(--shadow);border:1px solid var(--border);}
.stab:hover:not(.active){color:var(--text2);}

.sc-label{font-size:11px;font-weight:700;letter-spacing:.14em;
  text-transform:uppercase;color:var(--text3);margin-bottom:10px;}
.search-row{display:flex;gap:12px;}
.s-input{flex:1;background:var(--cream);border:1.5px solid var(--border2);
  border-radius:var(--rs);color:var(--text);font-size:15px;
  padding:13px 18px;outline:none;font-family:inherit;
  transition:border-color .2s,box-shadow .2s;}
.s-input:focus{border-color:var(--teal);box-shadow:0 0 0 3px rgba(11,92,107,.1);}
.s-input::placeholder{color:var(--text4);}
.btn-search{padding:13px 26px;border-radius:var(--rs);
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:14px;font-weight:600;border:none;cursor:pointer;
  font-family:inherit;transition:all .2s;white-space:nowrap;}
.btn-search:hover{transform:translateY(-1px);box-shadow:0 6px 20px var(--shadow2);}
.search-hint{font-size:11px;color:var(--text4);margin-top:10px;
  display:flex;align-items:center;gap:5px;}

/* ERROR */
.err-box{padding:13px 18px;border-radius:var(--rs);font-size:14px;font-weight:500;
  background:#fef2f2;border:1px solid #fecaca;color:#991b1b;
  display:flex;align-items:center;gap:10px;}

/* EMPTY */
.empty{text-align:center;padding:40px 24px;background:var(--white);
  border:1px solid var(--border);border-radius:20px;box-shadow:0 2px 8px var(--shadow);}
.empty-ico{font-size:44px;margin-bottom:14px;}
.empty h3{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;
  color:var(--navy);margin-bottom:8px;}
.empty p{font-size:14px;color:var(--text3);line-height:1.7;}

/* RESULTS COUNT */
.results-label{font-size:12px;font-weight:600;color:var(--text3);
  display:flex;align-items:center;gap:8px;}
.results-label span{background:var(--navy);color:#fff;font-size:11px;
  padding:2px 10px;border-radius:100px;}

/* RESERVATION CARD */
.res-card{background:var(--white);border:1px solid var(--border);
  border-radius:20px;overflow:hidden;
  box-shadow:0 4px 24px var(--shadow2);
  animation:slideUp .4s ease both;}
@keyframes slideUp{from{opacity:0;transform:translateY(14px);}to{opacity:1;}}
.res-head{background:linear-gradient(135deg,var(--navy) 0%,var(--navy2) 55%,var(--teal) 100%);
  padding:24px 32px;display:flex;align-items:center;justify-content:space-between;
  position:relative;overflow:hidden;}
.res-head::before{content:'';position:absolute;top:-40px;right:-40px;
  width:160px;height:160px;border-radius:50%;border:1px solid rgba(255,255,255,.06);}
.res-head::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),transparent);}
.rh-left{display:flex;align-items:center;gap:14px;position:relative;z-index:2;}
.rh-ico{width:46px;height:46px;border-radius:12px;
  background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);
  display:flex;align-items:center;justify-content:center;font-size:20px;}
.rh-title{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;color:#fff;}
.rh-sub{font-size:12px;color:rgba(255,255,255,.5);margin-top:2px;}
.rh-badge{position:relative;z-index:2;display:flex;align-items:center;gap:6px;
  padding:7px 16px;border-radius:100px;
  background:rgba(34,197,94,.2);border:1px solid rgba(34,197,94,.35);
  font-size:11px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;color:#86efac;}
.rh-badge-dot{width:6px;height:6px;border-radius:50%;background:#86efac;animation:blink 2s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:.3;}}
.res-no-bar{background:var(--gold-lt);border-bottom:1px solid rgba(184,146,58,.2);
  padding:12px 32px;display:flex;align-items:center;gap:10px;}
.rnb-label{font-size:10px;font-weight:700;letter-spacing:.18em;text-transform:uppercase;color:var(--gold);}
.rnb-value{font-family:'DM Mono',monospace;font-size:16px;font-weight:500;color:var(--navy);letter-spacing:.04em;}
.res-body{padding:8px 0;}
.detail-row{display:flex;align-items:center;gap:16px;
  padding:15px 32px;border-bottom:1px solid var(--border);transition:background .15s;}
.detail-row:last-child{border-bottom:none;}
.detail-row:hover{background:var(--cream);}
.dr-ico{width:38px;height:38px;border-radius:10px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;font-size:17px;
  background:var(--cream2);border:1px solid var(--border);}
.dr-label{font-size:10px;font-weight:700;letter-spacing:.14em;text-transform:uppercase;
  color:var(--text4);margin-bottom:3px;}
.dr-value{font-size:15px;font-weight:600;color:var(--text);}
.dr-value.teal{color:var(--teal);font-family:'Cormorant Garamond',serif;font-size:17px;}
.date-pair{display:grid;grid-template-columns:1fr 1fr;gap:0;border-top:1px solid var(--border);}
.date-box{padding:20px 28px;text-align:center;}
.date-box:first-child{border-right:1px solid var(--border);}
.date-box:hover{background:var(--cream);}
.db-type{font-size:10px;font-weight:700;letter-spacing:.18em;text-transform:uppercase;margin-bottom:8px;}
.db-type.ci{color:var(--teal);}
.db-type.co{color:var(--gold);}
.db-value{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;color:var(--navy);}
.db-sub{font-size:11px;color:var(--text4);margin-top:4px;}

/* BACK BUTTON */
.btn-portal{display:flex;align-items:center;justify-content:center;gap:8px;
  padding:14px;border-radius:var(--rs);font-size:14px;font-weight:600;
  background:transparent;border:1.5px solid var(--border2);color:var(--text2);
  cursor:pointer;font-family:inherit;transition:all .2s;width:100%;}
.btn-portal:hover{background:var(--navy);color:#fff;border-color:var(--navy);}

@media(max-width:600px){
  .navbar{padding:0 18px;}
  .page{padding:84px 16px 40px;}
  .search-row{flex-direction:column;}
  .search-card{padding:20px;}
  .res-head{padding:20px;}
  .detail-row{padding:14px 20px;}
  .date-pair{grid-template-columns:1fr;}
  .date-box:first-child{border-right:none;border-bottom:1px solid var(--border);}
  .res-no-bar{padding:12px 20px;}
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

<div class="page">

  <!-- Header -->
  <div class="page-hd">
    <div class="page-eyebrow">✦ Booking Lookup</div>
    <h1>View <em>Reservation</em></h1>
    <p>Search by reservation number or contact number to find your booking.</p>
  </div>

  <!-- Search Card -->
  <div class="search-card">

    <!-- Toggle Tabs -->
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

    <form action="ViewReservation" method="get" id="searchForm">
      <input type="hidden" name="searchType" id="searchTypeInput"
             value="<%= searchType %>"/>

      <!-- Label changes based on tab -->
      <div class="sc-label" id="scLabel">
        <%= "contact".equals(searchType) ? "Your Contact Number" : "Reservation Number" %>
      </div>

      <div class="search-row">
        <input class="s-input" type="text" name="searchValue" id="searchInput"
               placeholder="<%= "contact".equals(searchType) ? "e.g. 0761856976" : "e.g. RES-001" %>"
               value="<%= searchValue %>"
               required autocomplete="off"/>
        <button type="submit" class="btn-search">🔍 Search</button>
      </div>

      <div class="search-hint" id="searchHint">
        <%= "contact".equals(searchType)
            ? "ℹ️ Enter the contact number you used when booking"
            : "ℹ️ Enter your reservation number e.g. RES-001" %>
      </div>
    </form>

    <!-- Error -->
    <% if (errorMessage != null) { %>
    <div class="err-box" style="margin-top:16px;">⚠️ <%= errorMessage %></div>
    <% } %>

  </div>

  <!-- Empty / intro state -->
  <% if (results == null && errorMessage == null) { %>
  <div class="empty">
    <div class="empty-ico">🔍</div>
    <h3>Find Your Booking</h3>
    <p>Use your <strong>reservation number</strong> for a direct lookup, or use your <strong>contact number</strong> if you forgot your reservation number.</p>
  </div>
  <% } %>

  <!-- Results -->
  <% if (results != null && !results.isEmpty()) { %>

  <% if (results.size() > 1) { %>
  <div class="results-label">
    Reservations found <span><%= results.size() %></span>
  </div>
  <% } %>

  <% for (Reservation reservation : results) { %>
  <div class="res-card">

    <div class="res-head">
      <div class="rh-left">
        <div class="rh-ico">📋</div>
        <div>
          <div class="rh-title">Reservation Found</div>
          <div class="rh-sub">All booking details are shown below</div>
        </div>
      </div>
      <div class="rh-badge">
        <span class="rh-badge-dot"></span> Confirmed
      </div>
    </div>

    <div class="res-no-bar">
      <span class="rnb-label">Reservation No.</span>
      <span class="rnb-value"><%= reservation.getReservationNumber() %></span>
    </div>

    <div class="res-body">
      <div class="detail-row">
        <div class="dr-ico">👤</div>
        <div>
          <div class="dr-label">Guest Name</div>
          <div class="dr-value"><%= reservation.getGuestName() %></div>
        </div>
      </div>
      <div class="detail-row">
        <div class="dr-ico">📍</div>
        <div>
          <div class="dr-label">Address</div>
          <div class="dr-value"><%= reservation.getAddress() %></div>
        </div>
      </div>
      <div class="detail-row">
        <div class="dr-ico">📞</div>
        <div>
          <div class="dr-label">Contact Number</div>
          <div class="dr-value"><%= reservation.getContactNumber() %></div>
        </div>
      </div>
      <div class="detail-row">
        <div class="dr-ico">🛏️</div>
        <div>
          <div class="dr-label">Room Type</div>
          <div class="dr-value teal"><%= reservation.getRoomType() %></div>
        </div>
      </div>
    </div>

    <div class="date-pair">
      <div class="date-box">
        <div class="db-type ci">✈ Check-In</div>
        <div class="db-value"><%= reservation.getCheckInDate() %></div>
        <div class="db-sub">Arrival Date</div>
      </div>
      <div class="date-box">
        <div class="db-type co">🏖 Check-Out</div>
        <div class="db-value"><%= reservation.getCheckOutDate() %></div>
        <div class="db-sub">Departure Date</div>
      </div>
    </div>

  </div>
  <% } %>
  <% } %>

  <a href="home.jsp" class="btn-portal">← Return to Guest Portal</a>

</div>

<script>
function switchTab(type) {
  document.getElementById('searchTypeInput').value = type;

  var tabResNo   = document.getElementById('tabResNo');
  var tabContact = document.getElementById('tabContact');
  var label      = document.getElementById('scLabel');
  var input      = document.getElementById('searchInput');
  var hint       = document.getElementById('searchHint');

  if (type === 'contact') {
    tabContact.classList.add('active');
    tabResNo.classList.remove('active');
    label.textContent = 'Your Contact Number';
    input.placeholder = 'e.g. 0761856976';
    hint.textContent  = 'ℹ️ Enter the contact number you used when booking';
  } else {
    tabResNo.classList.add('active');
    tabContact.classList.remove('active');
    label.textContent = 'Reservation Number';
    input.placeholder = 'e.g. RES-001';
    hint.textContent  = 'ℹ️ Enter your reservation number e.g. RES-001';
  }
  document.getElementById('searchInput').value = '';
  document.getElementById('searchInput').focus();
}
</script>
</body>
</html>
