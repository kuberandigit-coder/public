<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) errorMessage = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Create Account — Ocean View Resort</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400;1,600&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
:root{
  --cream:#faf7f2;--cream2:#f4f0e8;
  --white:#ffffff;
  --navy:#0f1f3d;--navy2:#162847;
  --gold:#b8923a;--gold2:#d4a853;--gold-lt:#f5e9cc;
  --teal:#0b5c6b;--teal2:#0e7a8a;
  --text:#1a1a2e;--text2:#3d3d52;--text3:#6b6b80;--text4:#9b9bae;
  --border:#e8e0d0;--border2:#d4c8b0;
  --red:#b91c1c;--red-bg:#fef2f2;--red-br:#fecaca;
  --shadow:rgba(15,31,61,0.08);--shadow2:rgba(15,31,61,0.18);
  --r:16px;--rs:10px;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html,body{height:100%;}
body{font-family:'DM Sans',sans-serif;background:var(--cream);color:var(--text);min-height:100vh;display:flex;-webkit-font-smoothing:antialiased;}

/* LAYOUT */
.layout{display:grid;grid-template-columns:1fr 1fr;min-height:100vh;width:100%;}

/* LEFT */
.left{background:linear-gradient(145deg,var(--navy) 0%,var(--navy2) 55%,var(--teal) 100%);
  position:relative;overflow:hidden;display:flex;flex-direction:column;
  justify-content:space-between;padding:52px 56px;}
.left::before{content:'';position:absolute;width:480px;height:480px;border-radius:50%;
  border:1px solid rgba(255,255,255,.05);top:-160px;right:-160px;pointer-events:none;}
.left::after{content:'';position:absolute;width:260px;height:260px;border-radius:50%;
  border:1px solid rgba(184,146,58,.12);bottom:-80px;left:-80px;pointer-events:none;}
.left-gold-bar{position:absolute;bottom:0;left:0;right:0;height:3px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),transparent);}

.brand{display:flex;align-items:center;gap:12px;margin-bottom:60px;position:relative;z-index:2;}
.brand-ico{width:44px;height:44px;border-radius:12px;
  background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);
  display:flex;align-items:center;justify-content:center;font-size:20px;}
.brand-name{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;
  color:#fff;letter-spacing:.04em;}
.brand-name em{color:var(--gold2);font-style:italic;}
.brand-loc{font-size:10px;color:rgba(255,255,255,.38);letter-spacing:.18em;text-transform:uppercase;margin-top:1px;}

.left-headline{font-family:'Cormorant Garamond',serif;
  font-size:clamp(30px,2.8vw,46px);font-weight:400;line-height:1.1;
  color:#fff;letter-spacing:-.01em;margin-bottom:16px;position:relative;z-index:2;}
.left-headline em{font-style:italic;color:var(--gold2);}
.left-sub{font-size:14px;color:rgba(255,255,255,.5);line-height:1.75;max-width:340px;
  position:relative;z-index:2;}

.perks{display:flex;flex-direction:column;gap:12px;position:relative;z-index:2;}
.perk{display:flex;align-items:center;gap:13px;padding:13px 17px;
  background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.08);
  border-radius:var(--rs);}
.perk-ico{width:36px;height:36px;border-radius:9px;
  background:rgba(184,146,58,.18);border:1px solid rgba(184,146,58,.28);
  display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;}
.perk-title{font-size:13px;font-weight:600;color:#fff;margin-bottom:1px;}
.perk-desc{font-size:11px;color:rgba(255,255,255,.4);}
.left-login{margin-top:22px;font-size:13px;color:rgba(255,255,255,.4);text-align:center;position:relative;z-index:2;}
.left-login a{color:var(--gold2);font-weight:600;transition:color .2s;}
.left-login a:hover{color:var(--gold-lt);}

/* RIGHT */
.right{background:var(--white);display:flex;align-items:center;justify-content:center;padding:52px 64px;}
.form-box{width:100%;max-width:420px;animation:fadeUp .5s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(12px);}to{opacity:1;}}

.form-eyebrow{display:flex;align-items:center;gap:10px;margin-bottom:10px;}
.form-eyebrow-line{width:24px;height:1px;background:var(--gold);}
.form-eyebrow-text{font-size:10px;font-weight:600;letter-spacing:.25em;text-transform:uppercase;color:var(--gold);}

.form-title{font-family:'Cormorant Garamond',serif;font-size:38px;font-weight:400;
  color:var(--navy);letter-spacing:-.01em;margin-bottom:6px;}
.form-title em{font-style:italic;color:var(--teal);}
.form-sub{font-size:14px;color:var(--text3);margin-bottom:30px;line-height:1.6;}

/* Error */
.err-box{display:flex;align-items:center;gap:10px;padding:13px 16px;
  background:var(--red-bg);border:1px solid var(--red-br);border-radius:var(--rs);
  font-size:13px;color:var(--red);margin-bottom:22px;
  animation:shake .35s ease;}
@keyframes shake{0%,100%{transform:translateX(0);}25%{transform:translateX(-5px);}75%{transform:translateX(5px);}}

/* Form fields */
.fg{margin-bottom:20px;}
.fg label{display:block;font-size:11px;font-weight:600;letter-spacing:.1em;
  text-transform:uppercase;color:var(--text3);margin-bottom:8px;}
.fg-row{position:relative;display:flex;align-items:center;}
.fg-ico{position:absolute;left:15px;font-size:16px;color:var(--text4);pointer-events:none;z-index:1;}
.fc{width:100%;background:var(--cream);border:1.5px solid var(--border);
  border-radius:var(--rs);color:var(--text);font-size:14.5px;
  padding:13px 16px 13px 46px;outline:none;
  transition:border-color .2s,box-shadow .2s,background .2s;font-family:inherit;}
.fc:hover{border-color:var(--border2);background:var(--cream2);}
.fc:focus{border-color:var(--teal);box-shadow:0 0 0 3px rgba(11,92,107,.1);background:var(--white);}
.fc::placeholder{color:var(--text4);}

/* Strength */
.str-wrap{height:3px;background:var(--border);border-radius:2px;margin-top:7px;overflow:hidden;}
.str-bar{height:100%;border-radius:2px;width:0%;transition:width .3s,background .3s;}
.str-hint{font-size:11px;color:var(--text4);margin-top:5px;}

/* Guest badge */
.guest-badge{display:flex;align-items:center;gap:10px;padding:13px 16px;
  background:linear-gradient(135deg,rgba(11,92,107,.06),rgba(15,31,61,.04));
  border:1px solid rgba(11,92,107,.14);border-radius:var(--rs);margin-bottom:20px;}
.gb-ico{font-size:18px;}
.gb-text{font-size:13px;color:var(--text2);}
.gb-text strong{color:var(--teal);}

/* Submit */
.btn-submit{width:100%;padding:15px;border-radius:var(--rs);
  background:linear-gradient(135deg,var(--navy),var(--navy2));
  color:#fff;font-size:15px;font-weight:600;border:none;cursor:pointer;
  transition:all .25s;font-family:inherit;margin-top:4px;
  box-shadow:0 4px 16px var(--shadow);}
.btn-submit:hover{transform:translateY(-2px);box-shadow:0 8px 28px var(--shadow2);}
.btn-submit:active{transform:none;}

.login-link{text-align:center;margin-top:26px;padding-top:22px;
  border-top:1px solid var(--border);font-size:13.5px;color:var(--text3);}
.login-link a{color:var(--teal);font-weight:600;margin-left:4px;transition:color .2s;}
.login-link a:hover{color:var(--navy);}

@media(max-width:900px){.layout{grid-template-columns:1fr;}.left{display:none;}.right{padding:40px 24px;}}
</style>
</head>
<body>

<div class="layout">

  <!-- ── LEFT PANEL ─────────────────────────── -->
  <div class="left">
    <div class="left-gold-bar"></div>

    <div>
      <div class="brand">
        <div class="brand-ico">🌊</div>
        <div>
          <div class="brand-name">Ocean <em>View</em> Resort</div>
          <div class="brand-loc">Galle, Sri Lanka</div>
        </div>
      </div>
      <h1 class="left-headline">Begin Your<br><em>Journey</em><br>With Us</h1>
      <p class="left-sub">Create your guest account and enjoy seamless booking, billing, and resort services — all in one place.</p>
    </div>

    <div>
      <div class="perks">
        <div class="perk">
          <div class="perk-ico">🛎️</div>
          <div><div class="perk-title">Easy Reservations</div><div class="perk-desc">Book any room type in seconds</div></div>
        </div>
        <div class="perk">
          <div class="perk-ico">🧮</div>
          <div><div class="perk-title">Instant Bill Calculator</div><div class="perk-desc">Know your total before check-out</div></div>
        </div>
        <div class="perk">
          <div class="perk-ico">🖨️</div>
          <div><div class="perk-title">Print Your Invoice</div><div class="perk-desc">Professional receipt on demand</div></div>
        </div>
      </div>
      <div class="left-login">
        Already have an account? <a href="login.jsp">Sign in here</a>
      </div>
    </div>
  </div>

  <!-- ── RIGHT PANEL ────────────────────────── -->
  <div class="right">
    <div class="form-box">

      <div class="form-eyebrow">
        <div class="form-eyebrow-line"></div>
        <div class="form-eyebrow-text">Guest Registration</div>
      </div>
      <h2 class="form-title">Create <em>Account</em></h2>
      <p class="form-sub">Join Ocean View Resort and manage your stay with ease.</p>

      <!-- Error message -->
      <% if (!errorMessage.isEmpty()) { %>
      <div class="err-box">⚠️ &nbsp;<%= errorMessage %></div>
      <% } %>

      <!-- Guest access notice -->
      <div class="guest-badge">
        <span class="gb-ico">🏷️</span>
        <span class="gb-text">You will be registered as a <strong>Guest</strong> account.</span>
      </div>

      <!-- FORM — role is NOT shown, backend sets role='user' automatically -->
      <form method="POST" action="register" onsubmit="return validateForm()">

        <div class="fg">
          <label>Username</label>
          <div class="fg-row">
            <span class="fg-ico">👤</span>
            <input class="fc" type="text" name="username"
                   placeholder="Choose a username (min. 3 chars)"
                   minlength="3" required autocomplete="off"/>
          </div>
        </div>

        <div class="fg">
          <label>Password</label>
          <div class="fg-row">
            <span class="fg-ico">🔒</span>
            <input class="fc" type="password" name="password" id="pw"
                   placeholder="Create a password (min. 4 chars)"
                   minlength="4" required oninput="checkStr()"/>
          </div>
          <div class="str-wrap"><div class="str-bar" id="strBar"></div></div>
          <div class="str-hint" id="strHint">Enter a password</div>
        </div>

        <div class="fg">
          <label>Confirm Password</label>
          <div class="fg-row">
            <span class="fg-ico">🔑</span>
            <input class="fc" type="password" name="confirmPassword" id="cpw"
                   placeholder="Repeat your password"
                   required/>
          </div>
        </div>

        <button type="submit" class="btn-submit">Create My Account &nbsp;→</button>

      </form>

      <div class="login-link">
        Already have an account? <a href="login.jsp">Sign in</a>
      </div>

    </div>
  </div>

</div>

<script>
function checkStr(){
  var pw   = document.getElementById('pw').value;
  var bar  = document.getElementById('strBar');
  var hint = document.getElementById('strHint');
  var s = 0;
  if(pw.length >= 4) s++;
  if(pw.length >= 8) s++;
  if(/[A-Z]/.test(pw)) s++;
  if(/[0-9]/.test(pw)) s++;
  if(/[^A-Za-z0-9]/.test(pw)) s++;
  var cols = ['#dc2626','#f59e0b','#f59e0b','#16a34a','#16a34a'];
  var lbls = ['Too short','Weak','Fair','Strong','Very strong'];
  bar.style.width      = (s/5*100) + '%';
  bar.style.background = cols[s-1] || '#dc2626';
  hint.textContent     = lbls[s-1] || 'Enter a password';
  hint.style.color     = cols[s-1] || 'var(--text4)';
}

function validateForm(){
  var pw  = document.getElementById('pw').value;
  var cpw = document.getElementById('cpw').value;
  if(pw.length < 4){ alert('Password must be at least 4 characters.'); return false; }
  if(pw !== cpw)   { alert('Passwords do not match.'); return false; }
  return true;
}
</script>
</body>
</html>
