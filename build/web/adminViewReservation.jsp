<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    final String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    final String DB_USER = "root";
    final String DB_PASS = "";

    String adminName = (String) session.getAttribute("admin");
    if (adminName == null) adminName = "Admin";

    String action = request.getParameter("action");
    String search = request.getParameter("search");
    if (action == null) action = "";
    if (search == null) search = "";

    String flashSuccess = "";
    String flashError   = "";

    /* ═══════ DELETE ═══════ */
    if ("delete".equals(action)) {
        String delRes = request.getParameter("reservation_no");
        if (delRes != null && !delRes.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement p = c.prepareStatement("DELETE FROM reservations WHERE reservation_no=?");
                p.setString(1, delRes.trim());
                int rows = p.executeUpdate(); p.close(); c.close();
                if (rows > 0) flashSuccess = "Reservation " + delRes + " deleted successfully.";
                else          flashError   = "Reservation " + delRes + " not found.";
            } catch (Exception ex) { flashError = "Delete error: " + ex.getMessage(); }
        }
        action = "";
    }

    /* ═══════ POST: EDIT or ADD ═══════ */
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String postAction = request.getParameter("action");
        search = request.getParameter("search");
        if (search == null) search = "";

        if ("edit".equals(postAction)) {
            String resNo    = request.getParameter("reservation_no");
            String guest    = request.getParameter("guest_name");
            String addr     = request.getParameter("address");
            String contact  = request.getParameter("contact");
            String roomType = request.getParameter("room_type");
            String checkIn  = request.getParameter("checkin_date");
            String checkOut = request.getParameter("checkout_date");
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement p = c.prepareStatement(
                    "UPDATE reservations SET guest_name=?,address=?,contact=?,room_type=?,checkin_date=?,checkout_date=? WHERE reservation_no=?");
                p.setString(1,guest); p.setString(2,addr); p.setString(3,contact);
                p.setString(4,roomType); p.setString(5,checkIn); p.setString(6,checkOut); p.setString(7,resNo);
                int rows = p.executeUpdate(); p.close(); c.close();
                if (rows > 0) flashSuccess = "Reservation " + resNo + " updated successfully.";
                else          flashError   = "Update failed — reservation not found.";
            } catch (Exception ex) { flashError = "Edit error: " + ex.getMessage(); }

        } else if ("add".equals(postAction)) {
            String resNo    = request.getParameter("reservation_no");
            String guest    = request.getParameter("guest_name");
            String addr     = request.getParameter("address");
            String contact  = request.getParameter("contact");
            String roomType = request.getParameter("room_type");
            String checkIn  = request.getParameter("checkin_date");
            String checkOut = request.getParameter("checkout_date");
            if (resNo == null || resNo.trim().isEmpty()) {
                flashError = "Reservation number is required.";
            } else {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    // check duplicate
                    PreparedStatement chk = c.prepareStatement("SELECT COUNT(*) FROM reservations WHERE reservation_no=?");
                    chk.setString(1, resNo.trim());
                    ResultSet cr = chk.executeQuery();
                    int ex2 = cr.next() ? cr.getInt(1) : 0; cr.close(); chk.close();
                    if (ex2 > 0) {
                        flashError = "Reservation No \"" + resNo + "\" already exists.";
                    } else {
                        PreparedStatement p = c.prepareStatement(
                            "INSERT INTO reservations(reservation_no,guest_name,address,contact,room_type,checkin_date,checkout_date) VALUES(?,?,?,?,?,?,?)");
                        p.setString(1,resNo.trim()); p.setString(2,guest); p.setString(3,addr);
                        p.setString(4,contact); p.setString(5,roomType); p.setString(6,checkIn); p.setString(7,checkOut);
                        p.executeUpdate(); p.close();
                        flashSuccess = "Reservation " + resNo + " added successfully.";
                    }
                    c.close();
                } catch (Exception ex) { flashError = "Add error: " + ex.getMessage(); }
            }
        }
    }

    /* ═══════ FETCH ALL ═══════ */
    List<Map<String,String>> reservations = new ArrayList<>();
    int totalCount = 0;
    String dbError = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        PreparedStatement sc = con.prepareStatement("SELECT COUNT(*) FROM reservations");
        ResultSet rc = sc.executeQuery(); if (rc.next()) totalCount = rc.getInt(1); rc.close(); sc.close();

        PreparedStatement ps;
        String sql = "SELECT reservation_no,guest_name,address,contact,room_type,checkin_date,checkout_date FROM reservations ";
        if (!search.trim().isEmpty()) {
            ps = con.prepareStatement(sql + "WHERE reservation_no LIKE ? OR guest_name LIKE ? ORDER BY checkin_date DESC");
            ps.setString(1,"%" + search.trim() + "%"); ps.setString(2,"%" + search.trim() + "%");
        } else {
            ps = con.prepareStatement(sql + "ORDER BY checkin_date DESC");
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            row.put("reservation_no", sv(rs.getString("reservation_no")));
            row.put("guest_name",     sv(rs.getString("guest_name")));
            row.put("address",        sv(rs.getString("address")));
            row.put("contact",        sv(rs.getString("contact")));
            row.put("room_type",      sv(rs.getString("room_type")));
            java.sql.Date ci = rs.getDate("checkin_date");
            java.sql.Date co = rs.getDate("checkout_date");
            row.put("checkin_date",  ci != null ? ci.toString() : "");
            row.put("checkout_date", co != null ? co.toString() : "");
            reservations.add(row);
        }
        rs.close(); ps.close(); con.close();
    } catch (Exception e) { dbError = "Database error: " + e.getMessage(); }
%>
<%! private String sv(String v){ return v != null ? v : ""; }
    private int getRate(String rt) {
        if (rt==null) return 80; rt=rt.toLowerCase();
        if (rt.contains("suite")) return 250; if (rt.contains("deluxe")) return 150;
        if (rt.contains("family")) return 180; if (rt.contains("ocean")) return 220; return 80;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Manage Reservations</title>
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
        .container{position:relative;z-index:10;padding:110px 40px 80px;max-width:1400px;margin:0 auto;animation:pageIn 0.5s ease both;}
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
        .section-label{font-size:10px;letter-spacing:0.3em;text-transform:uppercase;color:var(--text-dim);margin-bottom:14px;display:flex;align-items:center;gap:14px;}
        .section-label::after{content:'';flex:1;height:1px;background:var(--glass-border);}
        .toolbar{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:16px;}
        .search-form{display:flex;gap:10px;align-items:center;flex:1;max-width:520px;}
        .search-wrap{position:relative;flex:1;}
        .search-icon{position:absolute;left:13px;top:50%;transform:translateY(-50%);font-size:14px;color:var(--text-dim);pointer-events:none;}
        .search-input{width:100%;padding:10px 14px 10px 40px;background:rgba(3,9,20,0.80);border:1px solid var(--glass-border);border-radius:12px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;transition:border-color 0.25s;}
        .search-input:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .search-input::placeholder{color:var(--text-dim);}
        .btn-search{padding:10px 22px;border-radius:12px;border:none;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;transition:all 0.3s;white-space:nowrap;}
        .btn-search:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(201,169,110,0.4);}
        .btn-clear{padding:10px 14px;border-radius:12px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:13px;text-decoration:none;display:inline-flex;align-items:center;transition:all 0.2s;}
        .btn-clear:hover{background:rgba(255,255,255,0.1);color:white;}
        .btn-add-res{display:flex;align-items:center;gap:8px;padding:10px 20px;border-radius:12px;border:none;background:linear-gradient(135deg,rgba(14,116,144,0.6),rgba(14,116,144,0.3));border:1px solid rgba(14,116,144,0.5);color:#67e8f9;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;transition:all 0.3s;white-space:nowrap;}
        .btn-add-res:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(14,116,144,0.35);}
        .search-banner{background:linear-gradient(135deg,rgba(201,169,110,0.14),rgba(201,169,110,0.05));border:1px solid rgba(201,169,110,0.28);border-radius:12px;padding:10px 16px;font-size:13px;color:var(--gold-light);margin-bottom:14px;display:flex;align-items:center;gap:8px;}
        /* TABLE */
        .table-wrap{background:var(--glass);border:1px solid var(--glass-border);border-radius:20px;overflow:hidden;overflow-x:auto;margin-bottom:24px;}
        table{width:100%;border-collapse:collapse;min-width:1000px;}
        thead tr{background:rgba(255,255,255,0.04);border-bottom:1px solid var(--glass-border);}
        th{padding:13px 14px;text-align:left;font-size:10px;font-weight:600;letter-spacing:0.18em;text-transform:uppercase;color:var(--text-dim);white-space:nowrap;}
        tbody tr{border-bottom:1px solid rgba(255,255,255,0.05);transition:background 0.2s;}
        tbody tr:last-child{border-bottom:none;}
        tbody tr:hover{background:rgba(201,169,110,0.055);}
        td{padding:12px 14px;font-size:13px;vertical-align:middle;}
        .res-no{font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:700;color:var(--gold-light);letter-spacing:0.05em;}
        .guest-name{font-weight:500;color:white;}
        .address-cell{font-size:12px;color:var(--text-dim);max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .contact-cell{font-size:12px;color:#67e8f9;white-space:nowrap;}
        .room-badge{display:inline-flex;align-items:center;background:rgba(14,116,144,0.17);border:1px solid rgba(14,116,144,0.3);color:#67e8f9;padding:3px 9px;border-radius:100px;font-size:11px;font-weight:600;white-space:nowrap;}
        .date-cell{font-size:12px;color:var(--text-dim);white-space:nowrap;}
        .action-btns{display:flex;gap:5px;flex-wrap:wrap;}
        .btn-act{padding:5px 10px;border-radius:8px;font-family:'DM Sans',sans-serif;font-size:11px;font-weight:600;cursor:pointer;border:none;transition:all 0.2s;white-space:nowrap;}
        .btn-edit{background:linear-gradient(135deg,rgba(14,116,144,0.3),rgba(14,116,144,0.1));border:1px solid rgba(14,116,144,0.4);color:#67e8f9;}
        .btn-edit:hover{background:linear-gradient(135deg,rgba(14,116,144,0.5),rgba(14,116,144,0.2));transform:translateY(-1px);}
        .btn-del{background:linear-gradient(135deg,rgba(239,68,68,0.25),rgba(239,68,68,0.1));border:1px solid rgba(239,68,68,0.35);color:#fca5a5;}
        .btn-del:hover{background:linear-gradient(135deg,rgba(239,68,68,0.45),rgba(239,68,68,0.2));transform:translateY(-1px);}
        .btn-bill{background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.45);color:var(--gold-light);}
        .btn-bill:hover{background:linear-gradient(135deg,rgba(201,169,110,0.5),rgba(201,169,110,0.25));transform:translateY(-1px);}
        .empty-state{text-align:center;padding:60px 20px;color:var(--text-dim);}
        .empty-icon{font-size:42px;margin-bottom:12px;opacity:0.5;}
        /* MODALS */
        .modal-overlay{position:fixed;inset:0;z-index:200;background:rgba(5,13,26,0.88);backdrop-filter:blur(10px);display:none;align-items:center;justify-content:center;padding:20px;overflow-y:auto;}
        .modal-overlay.open{display:flex;}
        .modal{background:linear-gradient(145deg,rgba(10,22,40,0.99),rgba(5,13,26,0.99));border:1px solid rgba(201,169,110,0.25);border-radius:24px;padding:38px;width:100%;max-width:560px;box-shadow:0 40px 100px rgba(0,0,0,0.8);position:relative;animation:slideUp 0.3s cubic-bezier(0.25,0.46,0.45,0.94);margin:auto;}
        @keyframes slideUp{from{opacity:0;transform:translateY(22px);}to{opacity:1;transform:translateY(0);}}
        .modal-close{position:absolute;top:16px;right:18px;background:rgba(255,255,255,0.06);border:1px solid var(--glass-border);color:var(--text-dim);width:32px;height:32px;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all 0.2s;}
        .modal-close:hover{background:rgba(255,59,48,0.25);border-color:rgba(255,59,48,0.4);color:#ff6b6b;}
        .modal-title{font-family:'Cormorant Garamond',serif;font-size:26px;font-weight:600;margin-bottom:6px;}
        .modal-title span{color:var(--gold);}
        .modal-sub{font-size:13px;color:var(--text-dim);margin-bottom:22px;}
        .modal-divider{height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.3;margin:0 0 22px;}
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:13px;margin-bottom:20px;}
        .form-group{display:flex;flex-direction:column;gap:5px;}
        .form-group.full{grid-column:1/-1;}
        .form-label{font-size:10px;font-weight:600;letter-spacing:0.14em;text-transform:uppercase;color:var(--text-dim);}
        .form-input,.form-select{padding:10px 13px;background:rgba(3,9,20,0.80);border:1px solid var(--glass-border);border-radius:10px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;transition:border-color 0.25s;}
        .form-input:focus,.form-select:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .form-input::placeholder{color:var(--text-dim);}
        .form-input[readonly]{opacity:0.45;cursor:not-allowed;}
        .form-select{appearance:none;cursor:pointer;}
        .form-select option{background:#0a1628;}
        .modal-actions{display:flex;gap:10px;}
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
        /* BILL MODAL */
        .bill-header{text-align:center;margin-bottom:18px;}
        .bill-resort{font-family:'Cormorant Garamond',serif;font-size:24px;font-weight:600;letter-spacing:0.04em;margin-bottom:3px;}
        .bill-resort span{color:var(--gold);}
        .bill-tagline{font-size:11px;letter-spacing:0.18em;text-transform:uppercase;color:var(--text-dim);}
        .bill-ref{font-size:12px;letter-spacing:0.1em;color:var(--gold-light);margin-top:6px;font-weight:600;}
        .bill-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:14px;}
        .bill-info-item{background:rgba(255,255,255,0.04);border:1px solid var(--glass-border);border-radius:10px;padding:10px 13px;}
        .bill-info-label{font-size:10px;letter-spacing:0.12em;text-transform:uppercase;color:var(--text-dim);margin-bottom:3px;}
        .bill-info-value{font-size:13px;font-weight:500;color:white;}
        .bill-item{display:flex;justify-content:space-between;align-items:center;padding:9px 0;border-bottom:1px solid rgba(255,255,255,0.06);font-size:13px;}
        .bill-item:last-child{border-bottom:none;}
        .bill-item-label{color:var(--text-dim);}
        .bill-item-value{font-weight:500;color:white;}
        .bill-total-row{display:flex;justify-content:space-between;align-items:center;padding:14px 18px;border-radius:13px;background:linear-gradient(135deg,rgba(201,169,110,0.2),rgba(201,169,110,0.08));border:1px solid rgba(201,169,110,0.35);margin-top:12px;}
        .bill-total-label{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;}
        .bill-total-value{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:700;color:var(--gold-light);}
        .bill-actions{display:flex;gap:10px;margin-top:16px;}
        .btn-print{flex:1;padding:12px;border:none;border-radius:12px;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;transition:all 0.3s;}
        .btn-print:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(201,169,110,0.4);}
        @media print{body *{visibility:hidden;}#billModal,#billModal *{visibility:visible;}#billModal{position:fixed;inset:0;display:flex !important;align-items:center;justify-content:center;background:white;padding:0;}#billModal .modal{border:none;box-shadow:none;background:white;color:black;padding:36px;max-width:100%;border-radius:0;}#billModal .modal-close,#billModal .bill-actions{display:none !important;}#billModal .bill-resort{color:black !important;}#billModal .bill-resort span,#billModal .bill-total-value,#billModal .bill-ref{color:#8B6914 !important;}#billModal .bill-info-item,#billModal .bill-total-row{background:#f9f5ef !important;border-color:#d4b483 !important;}#billModal .bill-info-label,#billModal .bill-item-label,#billModal .bill-tagline{color:#666 !important;}#billModal .bill-info-value,#billModal .bill-item-value,#billModal .bill-total-label{color:#111 !important;}}
        .footer{text-align:center;margin-top:50px;font-size:12px;color:var(--text-dim);letter-spacing:0.08em;}
        .footer::before{content:'';display:block;width:50px;height:1px;background:var(--gold);margin:0 auto 14px;}
        @media(max-width:768px){.container{padding:100px 18px 60px;}.navbar{padding:12px 18px;}.form-grid{grid-template-columns:1fr;}.kpi-strip{grid-template-columns:1fr 1fr 1fr;}}
    </style>
</head>
<body>
<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

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
        <h2>Manage <em>Reservations</em></h2>
    </div>

    <% if (!flashSuccess.isEmpty()) { %><div class="flash flash-s" id="flashMsg">✅ &nbsp;<%= flashSuccess %></div><% } %>
    <% if (!flashError.isEmpty())   { %><div class="flash flash-e" id="flashMsg">⚠ &nbsp;<%= flashError %></div><% } %>
    <% if (!dbError.isEmpty())      { %><div class="flash flash-e">🔌 &nbsp;<%= dbError %></div><% } %>

    <div class="kpi-strip">
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">📋</span><span class="kpi-badge ba">TOTAL</span></div>
            <div class="kpi-num"><%= totalCount %></div>
            <div class="kpi-label">Total Reservations</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🔍</span><span class="kpi-badge bt">SHOWING</span></div>
            <div class="kpi-num"><%= reservations.size() %></div>
            <div class="kpi-label"><%= search.isEmpty() ? "All Records" : "Search Results" %></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">⚙️</span><span class="kpi-badge bg">ACCESS</span></div>
            <div class="kpi-num">Full</div>
            <div class="kpi-label">Admin Privileges</div>
        </div>
    </div>

    <div class="section-label">All Reservations</div>
    <div class="toolbar">
        <form class="search-form" method="GET" action="adminViewReservation.jsp">
            <div class="search-wrap">
                <span class="search-icon">🔍</span>
                <input class="search-input" type="text" name="search"
                       placeholder="Search reservation no or guest name..."
                       value="<%= search %>">
            </div>
            <button type="submit" class="btn-search">Search</button>
            <% if (!search.isEmpty()) { %>
            <a href="adminViewReservation.jsp" class="btn-clear">✕</a>
            <% } %>
        </form>
        <button class="btn-add-res" onclick="openAdd()">➕ Add Reservation</button>
    </div>

    <% if (!search.isEmpty()) { %>
    <div class="search-banner">🔎 Results for <strong>"<%= search %>"</strong> &nbsp;— &nbsp;<%= reservations.size() %> record(s)</div>
    <% } %>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Reservation No</th>
                    <th>Guest Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>Room Type</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
            if (reservations.isEmpty()) {
            %><tr><td colspan="8"><div class="empty-state"><div class="empty-icon"><%= search.isEmpty()?"🏖️":"🔍" %></div><p><%= search.isEmpty()?"No reservations found. Click ➕ Add Reservation to create one.":"No match for \""+search+"\"."%></p></div></td></tr><%
            } else {
                for (Map<String,String> r : reservations) {
                    String resNo    = r.get("reservation_no");
                    String guest    = r.get("guest_name");
                    String address  = r.get("address");
                    String contact  = r.get("contact");
                    String roomType = r.get("room_type");
                    String checkIn  = r.get("checkin_date");
                    String checkOut = r.get("checkout_date");
                    int    rate     = getRate(roomType);
                    String gJ  = guest.replace("\\","\\\\").replace("'","\\'");
                    String aJ  = address.replace("\\","\\\\").replace("'","\\'");
                    String rtJ = roomType.replace("\\","\\\\").replace("'","\\'");
            %>
                <tr>
                    <td><span class="res-no"><%= resNo %></span></td>
                    <td><span class="guest-name"><%= guest %></span></td>
                    <td><span class="address-cell" title="<%= address %>"><%= address %></span></td>
                    <td><span class="contact-cell">📞 <%= contact %></span></td>
                    <td><span class="room-badge">🏨 <%= roomType %></span></td>
                    <td class="date-cell">📅 <%= checkIn %></td>
                    <td class="date-cell">📅 <%= checkOut %></td>
                    <td>
                        <div class="action-btns">
                            <button class="btn-act btn-edit" onclick="openEdit('<%= resNo %>','<%= gJ %>','<%= aJ %>','<%= contact %>','<%= rtJ %>','<%= checkIn %>','<%= checkOut %>')">✏️ Edit</button>
                            <button class="btn-act btn-bill" onclick="openBill('<%= resNo %>','<%= gJ %>','<%= aJ %>','<%= contact %>','<%= rtJ %>','<%= checkIn %>','<%= checkOut %>',<%= rate %>)">🧾 Bill</button>
                            <button class="btn-act btn-del" onclick="openDelete('<%= resNo %>','<%= gJ %>')">🗑️ Delete</button>
                        </div>
                    </td>
                </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>

    <div class="footer">© 2026 Ocean View Resort &nbsp;·&nbsp; Admin Portal &nbsp;·&nbsp; All rights reserved</div>
</div>

<!-- ════ ADD MODAL ════ -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <button class="modal-close" onclick="closeAdd()">✕</button>
        <div class="modal-title">Add <span>Reservation</span></div>
        <div class="modal-sub">Create a new guest reservation</div>
        <div class="modal-divider"></div>
        <form method="POST" action="adminViewReservation.jsp" id="addForm">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="search" value="<%= search %>">
            <div class="form-grid">
                <div class="form-group full">
                    <label class="form-label">Reservation No</label>
                    <input class="form-input" type="text" name="reservation_no" placeholder="e.g. RES-010" required>
                </div>
                <div class="form-group full">
                    <label class="form-label">Guest Name</label>
                    <input class="form-input" type="text" name="guest_name" placeholder="Full name" required>
                </div>
                <div class="form-group full">
                    <label class="form-label">Address</label>
                    <input class="form-input" type="text" name="address" placeholder="Guest address">
                </div>
                <div class="form-group">
                    <label class="form-label">Contact No</label>
                    <input class="form-input" type="text" name="contact" placeholder="07XXXXXXXX">
                </div>
                <div class="form-group">
                    <label class="form-label">Room Type</label>
                    <select class="form-select" name="room_type" required>
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Suite">Suite</option>
                        <option value="Family">Family</option>
                        <option value="Ocean">Ocean View</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-In Date</label>
                    <input class="form-input" type="date" name="checkin_date" id="add_ci" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-Out Date</label>
                    <input class="form-input" type="date" name="checkout_date" id="add_co" required>
                </div>
            </div>
            <div class="modal-actions">
                <button type="submit" class="btn-save">✅ Add Reservation</button>
                <button type="button" class="btn-cancel" onclick="closeAdd()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ════ EDIT MODAL ════ -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <button class="modal-close" onclick="closeEdit()">✕</button>
        <div class="modal-title">Edit <span>Reservation</span></div>
        <div class="modal-sub" id="editSub">Update booking details</div>
        <div class="modal-divider"></div>
        <form method="POST" action="adminViewReservation.jsp" id="editForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="search" value="<%= search %>">
            <input type="hidden" name="reservation_no" id="edit_resNo">
            <div class="form-grid">
                <div class="form-group full">
                    <label class="form-label">Reservation No (read-only)</label>
                    <input class="form-input" id="edit_resNo_disp" readonly>
                </div>
                <div class="form-group full">
                    <label class="form-label">Guest Name</label>
                    <input class="form-input" type="text" name="guest_name" id="edit_guest" required>
                </div>
                <div class="form-group full">
                    <label class="form-label">Address</label>
                    <input class="form-input" type="text" name="address" id="edit_addr">
                </div>
                <div class="form-group">
                    <label class="form-label">Contact No</label>
                    <input class="form-input" type="text" name="contact" id="edit_contact">
                </div>
                <div class="form-group">
                    <label class="form-label">Room Type</label>
                    <select class="form-select" name="room_type" id="edit_room" required>
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Suite">Suite</option>
                        <option value="Family">Family</option>
                        <option value="Ocean">Ocean View</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-In Date</label>
                    <input class="form-input" type="date" name="checkin_date" id="edit_ci" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-Out Date</label>
                    <input class="form-input" type="date" name="checkout_date" id="edit_co" required>
                </div>
            </div>
            <div class="modal-actions">
                <button type="submit" class="btn-save">💾 Save Changes</button>
                <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ════ DELETE MODAL ════ -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal" style="max-width:440px;">
        <button class="modal-close" onclick="closeDelete()">✕</button>
        <div class="del-icon-wrap">🗑️</div>
        <div class="del-text">
            <h3>Delete Reservation?</h3>
            <p>Permanently deleting<br><strong id="delLabel">—</strong><br>This action <strong>cannot be undone.</strong></p>
        </div>
        <div class="modal-actions">
            <button class="btn-del-confirm" onclick="doDelete()">🗑️ Yes, Delete</button>
            <button type="button" class="btn-cancel" onclick="closeDelete()">Cancel</button>
        </div>
    </div>
</div>

<!-- ════ BILL MODAL ════ -->
<div class="modal-overlay" id="billModal">
    <div class="modal">
        <button class="modal-close" onclick="closeBill()">✕</button>
        <div class="bill-header">
            <div class="bill-resort">🌊 Ocean <span>View</span> Resort</div>
            <div class="bill-tagline">Official Guest Invoice</div>
            <div class="bill-ref" id="bRef">—</div>
        </div>
        <div class="modal-divider"></div>
        <div class="bill-info-grid">
            <div class="bill-info-item"><div class="bill-info-label">Guest</div><div class="bill-info-value" id="bGuest">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Contact</div><div class="bill-info-value" id="bContact">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Address</div><div class="bill-info-value" id="bAddr">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Room</div><div class="bill-info-value" id="bRoom">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-In</div><div class="bill-info-value" id="bCI">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-Out</div><div class="bill-info-value" id="bCO">—</div></div>
        </div>
        <div class="modal-divider"></div>
        <div class="bill-item"><span class="bill-item-label">🌙 Nights</span><span class="bill-item-value" id="bNights">—</span></div>
        <div class="bill-item"><span class="bill-item-label">🛏️ Rate / Night</span><span class="bill-item-value" id="bRate">—</span></div>
        <div class="bill-item"><span class="bill-item-label">🏨 Room Charges</span><span class="bill-item-value" id="bRoom2">—</span></div>
        <div class="bill-item"><span class="bill-item-label">🧹 Service (10%)</span><span class="bill-item-value" id="bService">—</span></div>
        <div class="bill-item"><span class="bill-item-label">🏛️ Tax (8%)</span><span class="bill-item-value" id="bTax">—</span></div>
        <div class="bill-total-row">
            <span class="bill-total-label">Total Amount Due</span>
            <span class="bill-total-value" id="bTotal">$0.00</span>
        </div>
        <div class="bill-actions">
            <button class="btn-print" onclick="window.print()">🖨️ Print Invoice</button>
            <button type="button" class="btn-cancel" onclick="closeBill()">Close</button>
        </div>
    </div>
</div>

<script>
    var pc = document.getElementById("particles");
    for (var i=0;i<16;i++){var p=document.createElement("div");p.className="particle";p.style.cssText="--x:"+Math.random()*100+"%;--dur:"+(12+Math.random()*14)+"s;--delay:"+(Math.random()*12)+"s";pc.appendChild(p);}
    document.getElementById("avatarInit").textContent = "<%= adminName %>".charAt(0).toUpperCase();
    var fm=document.getElementById("flashMsg");
    if(fm)setTimeout(function(){fm.style.transition="opacity 0.5s";fm.style.opacity="0";setTimeout(function(){fm.remove();},500);},4500);
    window.addEventListener("scroll",function(){document.querySelector(".navbar").style.background=window.scrollY>40?"rgba(5,13,26,0.99)":"rgba(5,13,26,0.92)";},{passive:true});

    // ── ADD ──
    function openAdd(){document.getElementById("addModal").classList.add("open");document.body.style.overflow="hidden";}
    function closeAdd(){document.getElementById("addModal").classList.remove("open");document.body.style.overflow="";}
    document.getElementById("addForm").addEventListener("submit",function(e){
        var ci=new Date(document.getElementById("add_ci").value);
        var co=new Date(document.getElementById("add_co").value);
        if(co<=ci){e.preventDefault();alert("Check-out must be after check-in.");}
    });

    // ── EDIT ──
    function openEdit(resNo,guest,address,contact,roomType,checkIn,checkOut){
        document.getElementById("edit_resNo").value=resNo;
        document.getElementById("edit_resNo_disp").value=resNo;
        document.getElementById("edit_guest").value=guest;
        document.getElementById("edit_addr").value=address;
        document.getElementById("edit_contact").value=contact;
        document.getElementById("edit_ci").value=checkIn;
        document.getElementById("edit_co").value=checkOut;
        document.getElementById("editSub").textContent="Editing: "+resNo;
        var sel=document.getElementById("edit_room");
        for(var i=0;i<sel.options.length;i++){if(sel.options[i].value.toLowerCase()===roomType.toLowerCase()){sel.selectedIndex=i;break;}}
        document.getElementById("editModal").classList.add("open");document.body.style.overflow="hidden";
    }
    function closeEdit(){document.getElementById("editModal").classList.remove("open");document.body.style.overflow="";}
    document.getElementById("editForm").addEventListener("submit",function(e){
        var ci=new Date(document.getElementById("edit_ci").value);
        var co=new Date(document.getElementById("edit_co").value);
        if(isNaN(ci)||isNaN(co)||co<=ci){e.preventDefault();alert("Check-out must be after check-in.");}
    });

    // ── DELETE ──
    var _delRes="";
    function openDelete(resNo,guest){_delRes=resNo;document.getElementById("delLabel").textContent=resNo+" — "+guest;document.getElementById("deleteModal").classList.add("open");document.body.style.overflow="hidden";}
    function closeDelete(){document.getElementById("deleteModal").classList.remove("open");document.body.style.overflow="";}
    function doDelete(){
        var s="<%= search %>";
        var url="adminViewReservation.jsp?action=delete&reservation_no="+encodeURIComponent(_delRes);
        if(s)url+="&search="+encodeURIComponent(s);
        window.location.href=url;
    }

    // ── BILL ──
    function openBill(resNo,guest,address,contact,roomType,checkIn,checkOut,rate){
        document.getElementById("bRef").textContent="Reservation: "+resNo;
        document.getElementById("bGuest").textContent=guest;
        document.getElementById("bContact").textContent=contact;
        document.getElementById("bAddr").textContent=address;
        document.getElementById("bRoom").textContent=roomType;
        document.getElementById("bCI").textContent=checkIn;
        document.getElementById("bCO").textContent=checkOut;
        var nights=0;
        if(checkIn&&checkOut){var d=new Date(checkOut)-new Date(checkIn);if(d>0)nights=Math.round(d/86400000);}
        var rc=rate*nights,svc=rc*0.10,tax=rc*0.08,tot=rc+svc+tax;
        function usd(n){return"$"+n.toFixed(2);}
        document.getElementById("bNights").textContent=nights+(nights===1?" night":" nights");
        document.getElementById("bRate").textContent=usd(rate)+" / night";
        document.getElementById("bRoom2").textContent=usd(rc);
        document.getElementById("bService").textContent=usd(svc);
        document.getElementById("bTax").textContent=usd(tax);
        document.getElementById("bTotal").textContent=usd(tot);
        document.getElementById("billModal").classList.add("open");document.body.style.overflow="hidden";
    }
    function closeBill(){document.getElementById("billModal").classList.remove("open");document.body.style.overflow="";}

    // Overlay click + Escape
    ["addModal","editModal","deleteModal","billModal"].forEach(function(id){
        document.getElementById(id).addEventListener("click",function(e){if(e.target===this){closeAdd();closeEdit();closeDelete();closeBill();}});
    });
    document.addEventListener("keydown",function(e){if(e.key==="Escape"){closeAdd();closeEdit();closeDelete();closeBill();}});

    // Auto-open add if from dashboard
    <% if ("showAdd".equals(request.getParameter("action"))) { %>
    window.addEventListener("load",function(){openAdd();});
    <% } %>
</script>
</body>
</html>
