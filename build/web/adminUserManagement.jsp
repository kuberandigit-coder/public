<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    /* ═══════════════════════════════════════════════════════════
       DB CONFIG
    ═══════════════════════════════════════════════════════════ */
    final String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    final String DB_USER = "root";
    final String DB_PASS = "";

    String adminName = (String) session.getAttribute("admin");
    if (adminName == null) adminName = "Admin";

    String action   = request.getParameter("action");
    String filter   = request.getParameter("filter");   // all / user / staff
    String search   = request.getParameter("search");
    if (action  == null) action  = "";
    if (filter  == null) filter  = "all";
    if (search  == null) search  = "";

    String flashSuccess = "";
    String flashError   = "";

    /* ═══════════════════════════════════════════════════════════
       HANDLE DELETE  GET ?action=delete&username=xxx
    ═══════════════════════════════════════════════════════════ */
    if ("delete".equals(action)) {
        String delUser = request.getParameter("username");
        if (delUser != null && !delUser.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement p = c.prepareStatement("DELETE FROM users WHERE username = ?");
                p.setString(1, delUser);
                int rows = p.executeUpdate();
                p.close(); c.close();
                flashSuccess = rows > 0 ? "User \"" + delUser + "\" deleted successfully." : "User not found.";
            } catch (Exception ex) { flashError = "Delete failed: " + ex.getMessage(); }
        }
        action = "";
    }

    /* ═══════════════════════════════════════════════════════════
       HANDLE ADD / EDIT  POST
    ═══════════════════════════════════════════════════════════ */
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String postAction  = request.getParameter("action");
        String uname       = request.getParameter("username");
        String pwd         = request.getParameter("password");
        String role        = request.getParameter("role");
        String origUname   = request.getParameter("orig_username"); // for edit

        if (uname != null) uname = uname.trim();
        if (pwd   != null) pwd   = pwd.trim();
        if (role  != null) role  = role.trim();

        if ("add".equals(postAction)) {
            if (uname == null || uname.isEmpty() || pwd == null || pwd.isEmpty()) {
                flashError = "Username and password are required.";
            } else {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    // check duplicate
                    PreparedStatement chk = c.prepareStatement("SELECT COUNT(*) FROM users WHERE username=?");
                    chk.setString(1, uname);
                    ResultSet cr = chk.executeQuery();
                    int exists = cr.next() ? cr.getInt(1) : 0;
                    cr.close(); chk.close();
                    if (exists > 0) {
                        flashError = "Username \"" + uname + "\" already exists.";
                    } else {
                        PreparedStatement p = c.prepareStatement("INSERT INTO users(username,password,role) VALUES(?,?,?)");
                        p.setString(1, uname); p.setString(2, pwd); p.setString(3, role != null ? role : "user");
                        p.executeUpdate(); p.close();
                        flashSuccess = "Account \"" + uname + "\" (" + role + ") created successfully.";
                    }
                    c.close();
                } catch (Exception ex) { flashError = "Add failed: " + ex.getMessage(); }
            }
        } else if ("edit".equals(postAction)) {
            if (origUname != null && !origUname.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    String sql;
                    PreparedStatement p;
                    if (pwd != null && !pwd.isEmpty()) {
                        sql = "UPDATE users SET username=?, password=?, role=? WHERE username=?";
                        p = c.prepareStatement(sql);
                        p.setString(1, uname); p.setString(2, pwd);
                        p.setString(3, role); p.setString(4, origUname);
                    } else {
                        sql = "UPDATE users SET username=?, role=? WHERE username=?";
                        p = c.prepareStatement(sql);
                        p.setString(1, uname); p.setString(2, role); p.setString(3, origUname);
                    }
                    int rows = p.executeUpdate(); p.close(); c.close();
                    flashSuccess = rows > 0 ? "Account \"" + uname + "\" updated successfully." : "Update failed.";
                } catch (Exception ex) { flashError = "Edit failed: " + ex.getMessage(); }
            }
        }
        filter = request.getParameter("filter");
        if (filter == null) filter = "all";
        search = request.getParameter("search");
        if (search == null) search = "";
    }

    /* ═══════════════════════════════════════════════════════════
       FETCH USERS
    ═══════════════════════════════════════════════════════════ */
    List<Map<String,String>> users = new ArrayList<>();
    int totalAll = 0, totalUsers = 0, totalStaff = 0;
    String dbError = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        ResultSet rc;
        rc = con.prepareStatement("SELECT COUNT(*) FROM users").executeQuery();
        if (rc.next()) totalAll = rc.getInt(1); rc.close();
        rc = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='user'").executeQuery();
        if (rc.next()) totalUsers = rc.getInt(1); rc.close();
        rc = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='staff'").executeQuery();
        if (rc.next()) totalStaff = rc.getInt(1); rc.close();

        StringBuilder sql = new StringBuilder("SELECT username, password, role FROM users WHERE 1=1 ");
        if ("user".equals(filter))  sql.append("AND role='user' ");
        if ("staff".equals(filter)) sql.append("AND role='staff' ");
        if (!search.trim().isEmpty()) sql.append("AND username LIKE ? ");
        sql.append("ORDER BY role, username");

        PreparedStatement ps = con.prepareStatement(sql.toString());
        if (!search.trim().isEmpty()) ps.setString(1, "%" + search.trim() + "%");

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            row.put("username", nvl(rs.getString("username")));
            row.put("password", nvl(rs.getString("password")));
            row.put("role",     nvl(rs.getString("role")));
            users.add(row);
        }
        rs.close(); ps.close(); con.close();
    } catch (Exception e) {
        dbError = "DB Error: " + e.getMessage();
    }
%>
<%! private String nvl(String s){ return s != null ? s : ""; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | User Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preload" as="image" href="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80" fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root{--gold:#c9a96e;--gold-light:#e8c98a;--deep-navy:#050d1a;--teal:#0e7490;--glass:rgba(255,255,255,0.055);--glass-border:rgba(255,255,255,0.10);--text-dim:rgba(255,255,255,0.52);}
        *{margin:0;padding:0;box-sizing:border-box;}html{scroll-behavior:smooth;}
        body{font-family:'DM Sans',sans-serif;background:var(--deep-navy);color:white;min-height:100vh;overflow-x:hidden;-webkit-font-smoothing:antialiased;}
        .hero-bg{position:fixed;inset:0;z-index:0;background:url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80') center/cover no-repeat;}
        .hero-bg::before{content:'';position:absolute;inset:0;background:linear-gradient(180deg,rgba(5,13,26,0.95) 0%,rgba(5,13,26,0.78) 40%,rgba(5,13,26,0.97) 100%);}
        .wave-container{position:fixed;bottom:0;left:0;width:100%;height:110px;z-index:1;overflow:hidden;opacity:0.13;}
        .wave{position:absolute;bottom:0;left:-50%;width:200%;height:75px;background:linear-gradient(to right,transparent,var(--teal),transparent);border-radius:50%;animation:wave 9s ease-in-out infinite;}
        .wave:nth-child(2){height:55px;opacity:0.6;animation:wave 13s ease-in-out infinite reverse;background:linear-gradient(to right,transparent,var(--gold),transparent);}
        @keyframes wave{0%,100%{transform:translateX(0) translateY(0);}50%{transform:translateX(8%) translateY(-12px);}}
        .particles{position:fixed;inset:0;z-index:2;pointer-events:none;overflow:hidden;}
        .particle{position:absolute;width:2px;height:2px;border-radius:50%;background:var(--gold-light);opacity:0;animation:floatUp var(--dur,15s) linear var(--delay,0s) infinite;left:var(--x,50%);bottom:-10px;}
        @keyframes floatUp{0%{opacity:0;transform:translateY(0);}10%{opacity:0.4;}90%{opacity:0.18;}100%{opacity:0;transform:translateY(-100vh);}}
        /* NAVBAR */
        .navbar{position:fixed;top:0;width:100%;z-index:100;background:rgba(5,13,26,0.92);backdrop-filter:blur(16px);border-bottom:1px solid var(--glass-border);padding:14px 40px;display:flex;justify-content:space-between;align-items:center;}
        .navbar-brand{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;letter-spacing:0.04em;display:flex;align-items:center;gap:10px;}
        .wave-icon{display:inline-block;animation:sway 3s ease-in-out infinite;}
        @keyframes sway{0%,100%{transform:rotate(-5deg);}50%{transform:rotate(5deg);}}
        .nav-gold{color:var(--gold);}
        .admin-badge{background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.45);color:var(--gold-light);font-size:10px;font-weight:600;letter-spacing:0.2em;text-transform:uppercase;padding:4px 10px;border-radius:100px;margin-left:4px;}
        .navbar-right{display:flex;align-items:center;gap:12px;}
        .nav-back{display:flex;align-items:center;gap:8px;background:var(--glass);border:1px solid var(--glass-border);color:var(--text-dim);padding:8px 16px;border-radius:100px;font-size:13px;text-decoration:none;transition:all 0.3s;}
        .nav-back:hover{border-color:rgba(201,169,110,0.4);color:var(--gold-light);}
        .user-badge{display:flex;align-items:center;gap:9px;background:var(--glass);border:1px solid var(--glass-border);padding:6px 14px 6px 8px;border-radius:100px;font-size:13px;}
        .user-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:var(--deep-navy);}
        .logout-btn{background:rgba(255,59,48,0.17);border:1px solid rgba(255,59,48,0.38);color:white;padding:8px 16px;border-radius:100px;font-size:13px;text-decoration:none;transition:all 0.3s;}
        .logout-btn:hover{background:rgba(255,59,48,0.36);color:#ff6b6b;}
        /* MAIN */
        .container{position:relative;z-index:10;padding:110px 40px 80px;max-width:1200px;margin:0 auto;animation:pageIn 0.5s ease both;}
        @keyframes pageIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
        .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.25em;text-transform:uppercase;color:var(--gold);margin-bottom:10px;display:flex;align-items:center;gap:10px;}
        .page-eyebrow::before{content:'';width:28px;height:1px;background:var(--gold);}
        .page-header h2{font-family:'Cormorant Garamond',serif;font-size:40px;font-weight:300;line-height:1.1;margin-bottom:28px;}
        .page-header h2 em{font-style:italic;color:var(--gold-light);}
        /* FLASH */
        .flash{padding:13px 18px;border-radius:12px;font-size:13px;margin-bottom:20px;display:flex;align-items:center;gap:10px;animation:slideDown 0.4s ease;}
        @keyframes slideDown{from{opacity:0;transform:translateY(-8px);}to{opacity:1;transform:translateY(0);}}
        .flash-s{background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.38);color:#6ee7b7;}
        .flash-e{background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.38);color:#fca5a5;}
        /* KPI */
        .kpi-strip{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:28px;}
        .kpi-card{background:var(--glass);border:1px solid var(--glass-border);border-radius:16px;padding:18px 22px;position:relative;overflow:hidden;transition:transform 0.3s,border-color 0.3s;}
        .kpi-card:hover{border-color:rgba(201,169,110,0.28);transform:translateY(-3px);}
        .kpi-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.5;}
        .kpi-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;}
        .kpi-icon{font-size:20px;}
        .kpi-badge{font-size:10px;font-weight:600;letter-spacing:0.08em;padding:3px 8px;border-radius:100px;}
        .ba{background:rgba(201,169,110,0.2);border:1px solid rgba(201,169,110,0.4);color:var(--gold-light);}
        .bt{background:rgba(14,116,144,0.2);border:1px solid rgba(14,116,144,0.35);color:#67e8f9;}
        .bg{background:rgba(16,185,129,0.2);border:1px solid rgba(16,185,129,0.3);color:#6ee7b7;}
        .kpi-num{font-family:'Cormorant Garamond',serif;font-size:36px;font-weight:700;color:var(--gold-light);line-height:1;margin-bottom:3px;}
        .kpi-label{font-size:11px;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-dim);}
        /* TOOLBAR */
        .toolbar{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:16px;}
        .toolbar-left{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
        .search-wrap{position:relative;}
        .search-icon{position:absolute;left:13px;top:50%;transform:translateY(-50%);font-size:14px;color:var(--text-dim);pointer-events:none;}
        .search-input{padding:10px 14px 10px 40px;background:rgba(3,9,20,0.80);border:1px solid var(--glass-border);border-radius:12px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;width:260px;transition:border-color 0.25s;}
        .search-input:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .search-input::placeholder{color:var(--text-dim);}
        .filter-tabs{display:flex;gap:6px;}
        .ftab{padding:8px 16px;border-radius:10px;border:1px solid var(--glass-border);background:rgba(255,255,255,0.04);color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:12px;cursor:pointer;text-decoration:none;transition:all 0.2s;}
        .ftab:hover,.ftab.active{background:rgba(201,169,110,0.15);border-color:rgba(201,169,110,0.4);color:var(--gold-light);}
        .btn-add{display:flex;align-items:center;gap:8px;padding:10px 20px;border-radius:12px;border:none;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;transition:all 0.3s;white-space:nowrap;}
        .btn-add:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(201,169,110,0.4);}
        /* TABLE */
        .section-label{font-size:10px;letter-spacing:0.3em;text-transform:uppercase;color:var(--text-dim);margin-bottom:14px;display:flex;align-items:center;gap:14px;}
        .section-label::after{content:'';flex:1;height:1px;background:var(--glass-border);}
        .table-wrap{background:var(--glass);border:1px solid var(--glass-border);border-radius:20px;overflow:hidden;overflow-x:auto;margin-bottom:24px;}
        table{width:100%;border-collapse:collapse;min-width:600px;}
        thead tr{background:rgba(255,255,255,0.04);border-bottom:1px solid var(--glass-border);}
        th{padding:13px 16px;text-align:left;font-size:10px;font-weight:600;letter-spacing:0.18em;text-transform:uppercase;color:var(--text-dim);white-space:nowrap;}
        tbody tr{border-bottom:1px solid rgba(255,255,255,0.05);transition:background 0.2s;}
        tbody tr:last-child{border-bottom:none;}
        tbody tr:hover{background:rgba(201,169,110,0.055);}
        td{padding:13px 16px;font-size:13px;vertical-align:middle;}
        .uname{font-weight:600;color:white;font-size:14px;}
        .pwd-cell{color:var(--text-dim);font-family:monospace;letter-spacing:0.1em;font-size:13px;}
        .role-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:100px;font-size:11px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;}
        .role-admin{background:rgba(201,169,110,0.2);border:1px solid rgba(201,169,110,0.45);color:var(--gold-light);}
        .role-staff{background:rgba(14,116,144,0.2);border:1px solid rgba(14,116,144,0.38);color:#67e8f9;}
        .role-user{background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.32);color:#6ee7b7;}
        .action-btns{display:flex;gap:6px;}
        .btn-act{padding:5px 12px;border-radius:8px;font-family:'DM Sans',sans-serif;font-size:11px;font-weight:600;cursor:pointer;border:none;transition:all 0.2s;white-space:nowrap;letter-spacing:0.04em;}
        .btn-edit{background:linear-gradient(135deg,rgba(14,116,144,0.3),rgba(14,116,144,0.1));border:1px solid rgba(14,116,144,0.4);color:#67e8f9;}
        .btn-edit:hover{background:linear-gradient(135deg,rgba(14,116,144,0.5),rgba(14,116,144,0.2));transform:translateY(-1px);}
        .btn-del{background:linear-gradient(135deg,rgba(239,68,68,0.25),rgba(239,68,68,0.1));border:1px solid rgba(239,68,68,0.35);color:#fca5a5;}
        .btn-del:hover{background:linear-gradient(135deg,rgba(239,68,68,0.45),rgba(239,68,68,0.2));transform:translateY(-1px);}
        .empty-state{text-align:center;padding:55px 20px;color:var(--text-dim);}
        .empty-icon{font-size:40px;margin-bottom:12px;opacity:0.5;}
        /* MODALS */
        .modal-overlay{position:fixed;inset:0;z-index:200;background:rgba(5,13,26,0.88);backdrop-filter:blur(10px);display:none;align-items:center;justify-content:center;padding:20px;}
        .modal-overlay.open{display:flex;}
        .modal{background:linear-gradient(145deg,rgba(10,22,40,0.99),rgba(5,13,26,0.99));border:1px solid rgba(201,169,110,0.25);border-radius:24px;padding:38px;width:100%;max-width:480px;box-shadow:0 40px 100px rgba(0,0,0,0.8);position:relative;animation:slideUp 0.3s cubic-bezier(0.25,0.46,0.45,0.94);}
        @keyframes slideUp{from{opacity:0;transform:translateY(22px);}to{opacity:1;transform:translateY(0);}}
        .modal-close{position:absolute;top:16px;right:18px;background:rgba(255,255,255,0.06);border:1px solid var(--glass-border);color:var(--text-dim);width:32px;height:32px;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all 0.2s;}
        .modal-close:hover{background:rgba(255,59,48,0.25);border-color:rgba(255,59,48,0.4);color:#ff6b6b;}
        .modal-title{font-family:'Cormorant Garamond',serif;font-size:26px;font-weight:600;margin-bottom:6px;}
        .modal-title span{color:var(--gold);}
        .modal-sub{font-size:13px;color:var(--text-dim);margin-bottom:22px;}
        .modal-divider{height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.3;margin:0 0 22px;}
        .form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:15px;}
        .form-label{font-size:10px;font-weight:600;letter-spacing:0.14em;text-transform:uppercase;color:var(--text-dim);}
        .form-input,.form-select{padding:11px 13px;background:rgba(3,9,20,0.80);border:1px solid var(--glass-border);border-radius:10px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;transition:border-color 0.25s,box-shadow 0.25s;}
        .form-input:focus,.form-select:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .form-input::placeholder{color:var(--text-dim);}
        .form-select{appearance:none;cursor:pointer;}
        .form-select option{background:#0a1628;}
        /* Role visual selector */
        .role-cards{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:18px;}
        .role-card{position:relative;cursor:pointer;}
        .role-card input[type="radio"]{position:absolute;opacity:0;width:0;height:0;}
        .role-card-inner{border:1px solid rgba(255,255,255,0.12);border-radius:12px;padding:13px 14px;background:rgba(3,9,20,0.70);transition:all 0.25s;display:flex;align-items:center;gap:11px;}
        .role-card:hover .role-card-inner{border-color:rgba(201,169,110,0.35);background:rgba(201,169,110,0.06);}
        .role-card input:checked + .role-card-inner{border-color:var(--gold);background:rgba(201,169,110,0.12);box-shadow:0 0 0 1px rgba(201,169,110,0.3);}
        .role-card-icon{font-size:20px;}
        .role-card-text .rtitle{font-size:13px;font-weight:600;}
        .role-card-text .rsub{font-size:11px;color:var(--text-dim);}
        .modal-actions{display:flex;gap:10px;margin-top:4px;}
        .btn-save{flex:1;padding:13px;border:none;border-radius:12px;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;transition:all 0.3s;}
        .btn-save:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(201,169,110,0.4);}
        .btn-cancel{padding:13px 20px;border-radius:12px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:13px;cursor:pointer;transition:all 0.2s;}
        .btn-cancel:hover{background:rgba(255,255,255,0.1);color:white;}
        /* DELETE MODAL */
        .del-icon-wrap{width:56px;height:56px;border-radius:16px;background:rgba(239,68,68,0.18);border:1px solid rgba(239,68,68,0.35);display:flex;align-items:center;justify-content:center;font-size:26px;margin:0 auto 18px;}
        .del-text{text-align:center;margin-bottom:24px;}
        .del-text h3{font-family:'Cormorant Garamond',serif;font-size:24px;margin-bottom:8px;}
        .del-text p{font-size:13px;color:var(--text-dim);line-height:1.7;}
        .del-text strong{color:#fca5a5;}
        .btn-del-confirm{flex:1;padding:13px;border-radius:12px;background:linear-gradient(135deg,rgba(239,68,68,0.6),rgba(220,38,38,0.4));border:1px solid rgba(239,68,68,0.5);color:white;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;transition:all 0.3s;}
        .btn-del-confirm:hover{background:linear-gradient(135deg,rgba(239,68,68,0.8),rgba(220,38,38,0.6));transform:translateY(-2px);}
        .hint{font-size:11px;color:var(--text-dim);margin-top:6px;}
        .footer{text-align:center;margin-top:50px;font-size:12px;color:var(--text-dim);letter-spacing:0.08em;}
        .footer::before{content:'';display:block;width:50px;height:1px;background:var(--gold);margin:0 auto 14px;}
        @media(max-width:768px){.container{padding:100px 18px 60px;}.navbar{padding:12px 18px;}.kpi-strip{grid-template-columns:1fr 1fr 1fr;}}
    </style>
</head>
<body>
<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

<!-- NAVBAR -->
<div class="navbar">
    <div class="navbar-brand">
        <span class="wave-icon">🌊</span>Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        <span class="admin-badge">Admin</span>
    </div>
    <div class="navbar-right">
        <a href="admin.jsp" class="nav-back">← Dashboard</a>
        <div class="user-badge">
            <div class="user-avatar" id="avatarInit">A</div>
            <span><%= adminName %></span>
        </div>
        <a href="logout" class="logout-btn">↩ Logout</a>
    </div>
</div>

<div class="container">

    <div class="page-header">
        <div class="page-eyebrow">Admin Control Panel</div>
        <h2>Users & <em>Staff</em> Management</h2>
    </div>

    <!-- FLASH -->
    <% if (!flashSuccess.isEmpty()) { %>
    <div class="flash flash-s" id="flashMsg">✅ &nbsp;<%= flashSuccess %></div>
    <% } %>
    <% if (!flashError.isEmpty()) { %>
    <div class="flash flash-e" id="flashMsg">⚠ &nbsp;<%= flashError %></div>
    <% } %>
    <% if (!dbError.isEmpty()) { %>
    <div class="flash flash-e">🔌 &nbsp;<%= dbError %></div>
    <% } %>

    <!-- KPI -->
    <div class="kpi-strip">
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">👤</span><span class="kpi-badge ba">TOTAL</span></div>
            <div class="kpi-num"><%= totalAll %></div>
            <div class="kpi-label">All Accounts</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🌊</span><span class="kpi-badge bg">GUESTS</span></div>
            <div class="kpi-num"><%= totalUsers %></div>
            <div class="kpi-label">Guest Accounts</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🪪</span><span class="kpi-badge bt">STAFF</span></div>
            <div class="kpi-num"><%= totalStaff %></div>
            <div class="kpi-label">Staff Accounts</div>
        </div>
    </div>

    <!-- TOOLBAR -->
    <div class="section-label">All Accounts</div>
    <div class="toolbar">
        <div class="toolbar-left">
            <form method="GET" action="adminUserManagement.jsp" style="display:flex;gap:8px;align-items:center;">
                <input type="hidden" name="filter" value="<%= filter %>">
                <div class="search-wrap">
                    <span class="search-icon">🔍</span>
                    <input class="search-input" type="text" name="search"
                           placeholder="Search username..." value="<%= search %>">
                </div>
                <button type="submit" style="padding:10px 18px;border-radius:12px;border:none;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="adminUserManagement.jsp?filter=<%= filter %>" style="padding:10px 14px;border-radius:12px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);color:var(--text-dim);font-size:13px;text-decoration:none;">✕</a>
                <% } %>
            </form>
            <div class="filter-tabs">
                <a href="adminUserManagement.jsp?filter=all&search=<%= search %>" class="ftab <%= "all".equals(filter) ? "active" : "" %>">All</a>
                <a href="adminUserManagement.jsp?filter=user&search=<%= search %>" class="ftab <%= "user".equals(filter) ? "active" : "" %>">👥 Users</a>
                <a href="adminUserManagement.jsp?filter=staff&search=<%= search %>" class="ftab <%= "staff".equals(filter) ? "active" : "" %>">🪪 Staff</a>
            </div>
        </div>
        <button class="btn-add" onclick="openAdd()">➕ Add New Account</button>
    </div>

    <!-- TABLE -->
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
            if (users.isEmpty()) {
            %>
                <tr><td colspan="5">
                    <div class="empty-state">
                        <div class="empty-icon">👤</div>
                        <p>No accounts found<%= !search.isEmpty() ? " matching \"" + search + "\"" : "" %>.</p>
                    </div>
                </td></tr>
            <%
            } else {
                int idx = 1;
                for (Map<String,String> u : users) {
                    String uname = u.get("username");
                    String pwd   = u.get("password");
                    String role  = u.get("role");
                    String unameJ = uname.replace("\\","\\\\").replace("'","\\'");
                    String pwdJ   = pwd.replace("\\","\\\\").replace("'","\\'");
                    String roleJ  = role.replace("\\","\\\\").replace("'","\\'");
                    String roleCls = "role-user";
                    String roleEmoji = "👥";
                    if ("staff".equals(role)) { roleCls = "role-staff"; roleEmoji = "🪪"; }
                    if ("admin".equals(role)) { roleCls = "role-admin"; roleEmoji = "⚙️"; }
            %>
                <tr>
                    <td style="color:var(--text-dim);font-size:12px;"><%= idx++ %></td>
                    <td><span class="uname">👤 <%= uname %></span></td>
                    <td><span class="pwd-cell">••••••••</span> <span style="font-size:11px;color:rgba(255,255,255,0.2);">(hidden)</span></td>
                    <td><span class="role-badge <%= roleCls %>"><%= roleEmoji %> <%= role %></span></td>
                    <td>
                        <div class="action-btns">
                            <button class="btn-act btn-edit"
                                onclick="openEdit('<%= unameJ %>','<%= pwdJ %>','<%= roleJ %>')">
                                ✏️ Edit
                            </button>
                            <% if (!"admin".equals(role)) { %>
                            <button class="btn-act btn-del"
                                onclick="openDelete('<%= unameJ %>')">
                                🗑️ Delete
                            </button>
                            <% } %>
                        </div>
                    </td>
                </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>

    <div class="footer">© 2026 Ocean View Resort &nbsp;·&nbsp; Admin Portal &nbsp;·&nbsp; All rights reserved</div>
</div>

<!-- ════════ ADD MODAL ════════ -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <button class="modal-close" onclick="closeAdd()">✕</button>
        <div class="modal-title">Add <span>New Account</span></div>
        <div class="modal-sub">Create a new user or staff account</div>
        <div class="modal-divider"></div>

        <form method="POST" action="adminUserManagement.jsp" id="addForm">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="filter" value="<%= filter %>">
            <input type="hidden" name="search" value="<%= search %>">

            <div class="form-group">
                <label class="form-label">Username</label>
                <input class="form-input" type="text" name="username" id="add_uname"
                       placeholder="Enter username" required>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input class="form-input" type="text" name="password" id="add_pwd"
                       placeholder="Enter password" required>
            </div>
            <div class="form-group">
                <label class="form-label">Select Role</label>
                <div class="role-cards">
                    <label class="role-card">
                        <input type="radio" name="role" value="user" checked>
                        <div class="role-card-inner">
                            <span class="role-card-icon">👥</span>
                            <div class="role-card-text">
                                <div class="rtitle">Guest / User</div>
                                <div class="rsub">Can make reservations</div>
                            </div>
                        </div>
                    </label>
                    <label class="role-card">
                        <input type="radio" name="role" value="staff">
                        <div class="role-card-inner">
                            <span class="role-card-icon">🪪</span>
                            <div class="role-card-text">
                                <div class="rtitle">Staff</div>
                                <div class="rsub">Resort staff access</div>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            <div class="modal-actions">
                <button type="submit" class="btn-save">✅ Create Account</button>
                <button type="button" class="btn-cancel" onclick="closeAdd()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ════════ EDIT MODAL ════════ -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <button class="modal-close" onclick="closeEdit()">✕</button>
        <div class="modal-title">Edit <span>Account</span></div>
        <div class="modal-sub" id="editSub">Update account details</div>
        <div class="modal-divider"></div>

        <form method="POST" action="adminUserManagement.jsp" id="editForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="filter" value="<%= filter %>">
            <input type="hidden" name="search" value="<%= search %>">
            <input type="hidden" name="orig_username" id="edit_orig">

            <div class="form-group">
                <label class="form-label">Username</label>
                <input class="form-input" type="text" name="username" id="edit_uname" required>
            </div>
            <div class="form-group">
                <label class="form-label">New Password <span style="color:rgba(255,255,255,0.3);font-size:10px;">(leave blank to keep current)</span></label>
                <input class="form-input" type="text" name="password" id="edit_pwd"
                       placeholder="Leave blank to keep current password">
                <span class="hint">⚠ Only fill this if you want to change the password</span>
            </div>
            <div class="form-group">
                <label class="form-label">Role</label>
                <select class="form-select" name="role" id="edit_role" required>
                    <option value="user">👥 User (Guest)</option>
                    <option value="staff">🪪 Staff</option>
                    <option value="admin">⚙️ Admin</option>
                </select>
            </div>
            <div class="modal-actions">
                <button type="submit" class="btn-save">💾 Save Changes</button>
                <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ════════ DELETE MODAL ════════ -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal" style="max-width:420px;">
        <button class="modal-close" onclick="closeDelete()">✕</button>
        <div class="del-icon-wrap">🗑️</div>
        <div class="del-text">
            <h3>Delete Account?</h3>
            <p>You are about to permanently delete<br>
               <strong id="delLabel">—</strong><br>
               This action <strong>cannot be undone.</strong></p>
        </div>
        <div class="modal-actions">
            <button class="btn-del-confirm" onclick="doDelete()">🗑️ Yes, Delete</button>
            <button type="button" class="btn-cancel" onclick="closeDelete()">Cancel</button>
        </div>
    </div>
</div>

<script>
    // Particles
    var pc = document.getElementById("particles");
    for (var i = 0; i < 14; i++) {
        var p = document.createElement("div"); p.className = "particle";
        p.style.cssText = "--x:"+Math.random()*100+"%;--dur:"+(12+Math.random()*14)+"s;--delay:"+(Math.random()*12)+"s";
        pc.appendChild(p);
    }
    document.getElementById("avatarInit").textContent = "<%= adminName %>".charAt(0).toUpperCase();

    // Flash auto dismiss
    var fm = document.getElementById("flashMsg");
    if (fm) setTimeout(function(){ fm.style.transition="opacity 0.5s"; fm.style.opacity="0"; setTimeout(function(){ fm.remove(); },500); }, 4500);

    // Navbar scroll
    window.addEventListener("scroll", function(){
        document.querySelector(".navbar").style.background = window.scrollY>40?"rgba(5,13,26,0.99)":"rgba(5,13,26,0.92)";
    },{passive:true});

    // ── ADD MODAL ──
    function openAdd() {
        document.getElementById("addModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeAdd() {
        document.getElementById("addModal").classList.remove("open");
        document.body.style.overflow = "";
    }

    // ── EDIT MODAL ──
    function openEdit(uname, pwd, role) {
        document.getElementById("edit_orig").value  = uname;
        document.getElementById("edit_uname").value = uname;
        document.getElementById("edit_pwd").value   = "";   // blank for safety
        document.getElementById("editSub").textContent = "Editing: " + uname;
        var sel = document.getElementById("edit_role");
        for (var i = 0; i < sel.options.length; i++) {
            if (sel.options[i].value === role) { sel.selectedIndex = i; break; }
        }
        document.getElementById("editModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeEdit() {
        document.getElementById("editModal").classList.remove("open");
        document.body.style.overflow = "";
    }

    // ── DELETE MODAL ──
    var _delUname = "";
    function openDelete(uname) {
        _delUname = uname;
        document.getElementById("delLabel").textContent = '"' + uname + '"';
        document.getElementById("deleteModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeDelete() {
        document.getElementById("deleteModal").classList.remove("open");
        document.body.style.overflow = "";
    }
    function doDelete() {
        window.location.href = "adminUserManagement.jsp?action=delete&username="
            + encodeURIComponent(_delUname)
            + "&filter=<%= filter %>&search=<%= search %>";
    }

    // Overlay click to close
    ["addModal","editModal","deleteModal"].forEach(function(id){
        document.getElementById(id).addEventListener("click", function(e){
            if (e.target === this){ closeAdd(); closeEdit(); closeDelete(); }
        });
    });
    document.addEventListener("keydown", function(e){
        if (e.key==="Escape"){ closeAdd(); closeEdit(); closeDelete(); }
    });

    // Auto-open Add modal if coming from dashboard quick action
    <% if ("showAdd".equals(request.getParameter("action"))) { %>
    window.addEventListener("load", function(){ openAdd(); });
    <% } %>
</script>
</body>
</html>
