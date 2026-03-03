<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
    // ── Admin name from session (no redirect) ──────────────────
    String adminName = (String) session.getAttribute("admin");
    if (adminName == null) adminName = "Admin";

    // ── DB config ──────────────────────────────────────────────
    String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    String DB_USER = "root";
    String DB_PASS = "";

    // ── Search & action params ─────────────────────────────────
    String search  = request.getParameter("search");
    String action  = request.getParameter("action");
    String deleted = request.getParameter("deleted");
    String updated = request.getParameter("updated");
    if (search == null) search = "";

    // ── Handle DELETE (GET with action=delete) ─────────────────
    String flashSuccess = "";
    String flashError   = "";

    if ("delete".equals(action)) {
        String resNo = request.getParameter("reservation_no");
        if (resNo != null && !resNo.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection delCon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement delPs = delCon.prepareStatement(
                    "DELETE FROM reservations WHERE reservation_no = ?"
                );
                delPs.setString(1, resNo);
                int rows = delPs.executeUpdate();
                delPs.close(); delCon.close();
                flashSuccess = rows > 0
                    ? "Reservation " + resNo + " deleted successfully."
                    : "Reservation " + resNo + " not found.";
            } catch (Exception ex) {
                flashError = "Delete failed: " + ex.getMessage();
            }
        }
    }

    // ── Handle EDIT / UPDATE (POST) ────────────────────────────
    if ("POST".equals(request.getMethod())) {
        String editAction = request.getParameter("action");
        if ("edit".equals(editAction)) {
            String resNo    = request.getParameter("reservation_no");
            String guest    = request.getParameter("guest_name");
            String addr     = request.getParameter("address");
            String contact  = request.getParameter("contact");
            String roomType = request.getParameter("room_type");
            String checkIn  = request.getParameter("checkin_date");
            String checkOut = request.getParameter("checkout_date");
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection updCon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement updPs = updCon.prepareStatement(
                    "UPDATE reservations SET guest_name=?, address=?, contact=?, " +
                    "room_type=?, checkin_date=?, checkout_date=? WHERE reservation_no=?"
                );
                updPs.setString(1, guest);
                updPs.setString(2, addr);
                updPs.setString(3, contact);
                updPs.setString(4, roomType);
                updPs.setString(5, checkIn);
                updPs.setString(6, checkOut);
                updPs.setString(7, resNo);
                int rows = updPs.executeUpdate();
                updPs.close(); updCon.close();
                flashSuccess = rows > 0
                    ? "Reservation " + resNo + " updated successfully."
                    : "Update failed — reservation not found.";
            } catch (Exception ex) {
                flashError = "Update failed: " + ex.getMessage();
            }
            // reset method to GET for display
            search = request.getParameter("search");
            if (search == null) search = "";
        }
    }

    // ── Fetch all reservations from DB ─────────────────────────
    List<Map<String,String>> reservations = new ArrayList<>();
    int totalCount = 0;
    String dbError = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        PreparedStatement stCount = con.prepareStatement("SELECT COUNT(*) FROM reservations");
        ResultSet rsCount = stCount.executeQuery();
        if (rsCount.next()) totalCount = rsCount.getInt(1);
        rsCount.close(); stCount.close();

        PreparedStatement ps;
        String baseSql =
            "SELECT reservation_no, guest_name, address, contact, room_type, " +
            "checkin_date, checkout_date FROM reservations ";

        if (!search.trim().isEmpty()) {
            ps = con.prepareStatement(baseSql +
                "WHERE reservation_no LIKE ? ORDER BY checkin_date DESC");
            ps.setString(1, "%" + search.trim() + "%");
        } else {
            ps = con.prepareStatement(baseSql + "ORDER BY checkin_date DESC");
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            row.put("reservation_no", nvl(rs.getString("reservation_no")));
            row.put("guest_name",     nvl(rs.getString("guest_name")));
            row.put("address",        nvl(rs.getString("address")));
            row.put("contact",        nvl(rs.getString("contact")));
            row.put("room_type",      nvl(rs.getString("room_type")));
            row.put("checkin_date",   nvl(rs.getDate("checkin_date") != null
                                         ? rs.getDate("checkin_date").toString() : ""));
            row.put("checkout_date",  nvl(rs.getDate("checkout_date") != null
                                         ? rs.getDate("checkout_date").toString() : ""));
            reservations.add(row);
        }
        rs.close(); ps.close(); con.close();

    } catch (Exception e) {
        dbError = "Database error: " + e.getMessage();
        e.printStackTrace();
    }

    // ── Rate map by room type ──────────────────────────────────
    Map<String,Integer> rateMap = new LinkedHashMap<>();
    rateMap.put("standard", 80);
    rateMap.put("deluxe",  150);
    rateMap.put("suite",   250);
    rateMap.put("family",  180);
    rateMap.put("ocean",   220);
%>
<%!
    private String nvl(String s) { return s != null ? s : ""; }
    private int getRate(String roomType) {
        if (roomType == null) return 80;
        String rt = roomType.toLowerCase().trim();
        if (rt.contains("suite"))  return 250;
        if (rt.contains("deluxe")) return 150;
        if (rt.contains("family")) return 180;
        if (rt.contains("ocean"))  return 220;
        return 80;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Manage Reservations</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preload" as="image"
          href="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80"
          fetchpriority="high">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --gold:#c9a96e; --gold-light:#e8c98a;
            --deep-navy:#050d1a; --navy:#0a1628;
            --teal:#0e7490; --emerald:#10b981;
            --glass:rgba(255,255,255,0.055);
            --glass-border:rgba(255,255,255,0.10);
            --text-dim:rgba(255,255,255,0.52);
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        html{scroll-behavior:smooth;}
        body{font-family:'DM Sans',sans-serif;background:var(--deep-navy);color:white;min-height:100vh;overflow-x:hidden;-webkit-font-smoothing:antialiased;}

        .hero-bg{position:fixed;inset:0;z-index:0;background:url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1920&q=80') center/cover no-repeat;will-change:transform;transform:translateZ(0);contain:strict;}
        .hero-bg::before{content:'';position:absolute;inset:0;background:linear-gradient(180deg,rgba(5,13,26,0.94) 0%,rgba(5,13,26,0.78) 40%,rgba(5,13,26,0.97) 100%);}

        .wave-container{position:fixed;bottom:0;left:0;width:100%;height:110px;z-index:1;overflow:hidden;opacity:0.13;}
        .wave{position:absolute;bottom:0;left:-50%;width:200%;height:75px;background:linear-gradient(to right,transparent,var(--teal),transparent);border-radius:50%;animation:wave 9s ease-in-out infinite;}
        .wave:nth-child(2){height:55px;opacity:0.6;animation:wave 13s ease-in-out infinite reverse;background:linear-gradient(to right,transparent,var(--gold),transparent);}
        @keyframes wave{0%,100%{transform:translateX(0) translateY(0);}50%{transform:translateX(8%) translateY(-12px);}}

        .particles{position:fixed;inset:0;z-index:2;pointer-events:none;overflow:hidden;}
        .particle{position:absolute;width:2px;height:2px;border-radius:50%;background:var(--gold-light);opacity:0;animation:floatUp var(--dur,15s) linear var(--delay,0s) infinite;left:var(--x,50%);bottom:-10px;}
        @keyframes floatUp{0%{opacity:0;transform:translateY(0);}10%{opacity:0.4;}90%{opacity:0.18;}100%{opacity:0;transform:translateY(-100vh);}}

        /* NAVBAR */
        .navbar{position:fixed;top:0;width:100%;z-index:100;background:rgba(5,13,26,0.92);backdrop-filter:blur(16px);border-bottom:1px solid var(--glass-border);padding:14px 40px;display:flex;justify-content:space-between;align-items:center;animation:pageIn 0.4s ease both;}
        .navbar-brand{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;letter-spacing:0.04em;display:flex;align-items:center;gap:10px;}
        .wave-icon{display:inline-block;animation:sway 3s ease-in-out infinite;}
        @keyframes sway{0%,100%{transform:rotate(-5deg);}50%{transform:rotate(5deg);}}
        .nav-gold{color:var(--gold);}
        .admin-badge{background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.45);color:var(--gold-light);font-size:10px;font-weight:600;letter-spacing:0.2em;text-transform:uppercase;padding:4px 10px;border-radius:100px;margin-left:4px;}
        .navbar-right{display:flex;align-items:center;gap:12px;}
        .nav-back{display:flex;align-items:center;gap:8px;background:var(--glass);border:1px solid var(--glass-border);color:var(--text-dim);padding:8px 16px;border-radius:100px;font-size:13px;text-decoration:none;transition:all 0.3s;}
        .nav-back:hover{border-color:rgba(201,169,110,0.4);color:var(--gold-light);}
        .user-badge{display:flex;align-items:center;gap:9px;background:var(--glass);border:1px solid var(--glass-border);padding:6px 14px 6px 8px;border-radius:100px;font-size:13px;}
        .user-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--gold),var(--gold-light));display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:var(--deep-navy);text-transform:uppercase;}
        .logout-btn{background:rgba(255,59,48,0.17);border:1px solid rgba(255,59,48,0.38);color:white;padding:8px 16px;border-radius:100px;font-size:13px;text-decoration:none;transition:all 0.3s;}
        .logout-btn:hover{background:rgba(255,59,48,0.36);color:#ff6b6b;}

        /* CONTAINER */
        .container{position:relative;z-index:10;padding:110px 40px 80px;max-width:1400px;margin:0 auto;animation:pageIn 0.5s ease both;}
        @keyframes pageIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}

        .page-header{margin-bottom:28px;}
        .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.25em;text-transform:uppercase;color:var(--gold);margin-bottom:10px;display:flex;align-items:center;gap:10px;}
        .page-eyebrow::before{content:'';width:28px;height:1px;background:var(--gold);}
        .page-header h2{font-family:'Cormorant Garamond',serif;font-size:42px;font-weight:300;line-height:1.1;}
        .page-header h2 em{font-style:italic;color:var(--gold-light);}

        /* FLASH */
        .flash{padding:13px 18px;border-radius:12px;font-size:13px;margin-bottom:20px;display:flex;align-items:center;gap:10px;animation:slideDown 0.4s ease;}
        @keyframes slideDown{from{opacity:0;transform:translateY(-8px);}to{opacity:1;transform:translateY(0);}}
        .flash-success{background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.35);color:#6ee7b7;}
        .flash-error{background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.35);color:#fca5a5;}

        /* KPI */
        .kpi-strip{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:28px;}
        .kpi-card{background:var(--glass);border:1px solid var(--glass-border);border-radius:16px;padding:18px 22px;position:relative;overflow:hidden;transition:transform 0.3s,border-color 0.3s;}
        .kpi-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.5;}
        .kpi-card:hover{transform:translateY(-3px);border-color:rgba(201,169,110,0.28);}
        .kpi-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;}
        .kpi-icon{font-size:20px;}
        .kpi-badge{font-size:10px;font-weight:600;letter-spacing:0.08em;padding:3px 8px;border-radius:100px;}
        .badge-gold{background:rgba(201,169,110,0.2);border:1px solid rgba(201,169,110,0.4);color:var(--gold-light);}
        .badge-teal{background:rgba(14,116,144,0.2);border:1px solid rgba(14,116,144,0.35);color:#67e8f9;}
        .badge-green{background:rgba(16,185,129,0.2);border:1px solid rgba(16,185,129,0.3);color:#6ee7b7;}
        .kpi-num{font-family:'Cormorant Garamond',serif;font-size:36px;font-weight:700;color:var(--gold-light);line-height:1;margin-bottom:3px;}
        .kpi-label{font-size:11px;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-dim);}

        /* TOOLBAR */
        .section-label{font-size:10px;letter-spacing:0.3em;text-transform:uppercase;color:var(--text-dim);margin-bottom:14px;display:flex;align-items:center;gap:14px;}
        .section-label::after{content:'';flex:1;height:1px;background:var(--glass-border);}
        .toolbar{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:16px;}
        .search-form{display:flex;gap:10px;align-items:center;flex:1;max-width:500px;}
        .search-wrap{position:relative;flex:1;}
        .search-icon-pos{position:absolute;left:13px;top:50%;transform:translateY(-50%);font-size:14px;color:var(--text-dim);pointer-events:none;}
        .search-input{width:100%;padding:10px 14px 10px 40px;background:rgba(3,9,20,0.78);border:1px solid var(--glass-border);border-radius:12px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;transition:border-color 0.25s,box-shadow 0.25s;}
        .search-input:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .search-input::placeholder{color:var(--text-dim);}
        .btn-search{padding:10px 22px;border-radius:12px;border:none;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;cursor:pointer;transition:all 0.3s;white-space:nowrap;}
        .btn-search:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(201,169,110,0.4);}
        .btn-clear{padding:10px 16px;border-radius:12px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:13px;cursor:pointer;transition:all 0.2s;text-decoration:none;display:inline-flex;align-items:center;}
        .btn-clear:hover{background:rgba(255,255,255,0.1);color:white;}

        .search-banner{background:linear-gradient(135deg,rgba(201,169,110,0.14),rgba(201,169,110,0.05));border:1px solid rgba(201,169,110,0.28);border-radius:12px;padding:10px 16px;font-size:13px;color:var(--gold-light);margin-bottom:14px;display:flex;align-items:center;gap:8px;}

        /* TABLE */
        .table-wrap{background:var(--glass);border:1px solid var(--glass-border);border-radius:20px;overflow:hidden;overflow-x:auto;margin-bottom:24px;}
        table{width:100%;border-collapse:collapse;min-width:980px;}
        thead tr{background:rgba(255,255,255,0.04);border-bottom:1px solid var(--glass-border);}
        th{padding:13px 14px;text-align:left;font-size:10px;font-weight:600;letter-spacing:0.18em;text-transform:uppercase;color:var(--text-dim);white-space:nowrap;}
        tbody tr{border-bottom:1px solid rgba(255,255,255,0.05);transition:background 0.2s;}
        tbody tr:last-child{border-bottom:none;}
        tbody tr:hover{background:rgba(201,169,110,0.055);}
        td{padding:12px 14px;font-size:13px;vertical-align:middle;}

        .res-no{font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:700;color:var(--gold-light);letter-spacing:0.05em;}
        .guest-name{font-weight:500;color:white;}
        .address-cell{font-size:12px;color:var(--text-dim);max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .contact-cell{font-size:12px;color:#67e8f9;white-space:nowrap;}
        .room-badge{display:inline-flex;align-items:center;background:rgba(14,116,144,0.17);border:1px solid rgba(14,116,144,0.3);color:#67e8f9;padding:3px 9px;border-radius:100px;font-size:11px;font-weight:600;white-space:nowrap;}
        .date-cell{font-size:12px;color:var(--text-dim);white-space:nowrap;}

        .action-btns{display:flex;gap:5px;flex-wrap:wrap;}
        .btn-action{padding:5px 11px;border-radius:8px;font-family:'DM Sans',sans-serif;font-size:11px;font-weight:600;cursor:pointer;border:none;transition:all 0.2s;white-space:nowrap;letter-spacing:0.04em;}
        .btn-edit{background:linear-gradient(135deg,rgba(14,116,144,0.3),rgba(14,116,144,0.1));border:1px solid rgba(14,116,144,0.4);color:#67e8f9;}
        .btn-edit:hover{background:linear-gradient(135deg,rgba(14,116,144,0.5),rgba(14,116,144,0.2));transform:translateY(-1px);}
        .btn-delete{background:linear-gradient(135deg,rgba(239,68,68,0.25),rgba(239,68,68,0.1));border:1px solid rgba(239,68,68,0.35);color:#fca5a5;}
        .btn-delete:hover{background:linear-gradient(135deg,rgba(239,68,68,0.45),rgba(239,68,68,0.2));transform:translateY(-1px);}
        .btn-bill{background:linear-gradient(135deg,rgba(201,169,110,0.3),rgba(201,169,110,0.1));border:1px solid rgba(201,169,110,0.45);color:var(--gold-light);}
        .btn-bill:hover{background:linear-gradient(135deg,rgba(201,169,110,0.5),rgba(201,169,110,0.25));transform:translateY(-1px);}

        .empty-state{text-align:center;padding:60px 20px;color:var(--text-dim);}
        .empty-icon{font-size:42px;margin-bottom:12px;opacity:0.5;}
        .empty-state p{font-size:14px;}

        /* MODALS */
        .modal-overlay{position:fixed;inset:0;z-index:200;background:rgba(5,13,26,0.88);backdrop-filter:blur(10px);display:none;align-items:center;justify-content:center;padding:20px;}
        .modal-overlay.open{display:flex;}
        .modal{background:linear-gradient(145deg,rgba(10,22,40,0.99),rgba(5,13,26,0.99));border:1px solid rgba(201,169,110,0.25);border-radius:24px;padding:38px;width:100%;max-width:560px;box-shadow:0 40px 100px rgba(0,0,0,0.8);position:relative;animation:slideUp 0.3s cubic-bezier(0.25,0.46,0.45,0.94);}
        @keyframes slideUp{from{opacity:0;transform:translateY(22px);}to{opacity:1;transform:translateY(0);}}
        .modal-close{position:absolute;top:16px;right:18px;background:rgba(255,255,255,0.06);border:1px solid var(--glass-border);color:var(--text-dim);width:32px;height:32px;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all 0.2s;}
        .modal-close:hover{background:rgba(255,59,48,0.25);border-color:rgba(255,59,48,0.4);color:#ff6b6b;}
        .modal-title{font-family:'Cormorant Garamond',serif;font-size:26px;font-weight:600;margin-bottom:6px;}
        .modal-title span{color:var(--gold);}
        .modal-subtitle{font-size:13px;color:var(--text-dim);margin-bottom:22px;}
        .modal-divider{height:1px;background:linear-gradient(90deg,transparent,var(--gold),transparent);opacity:0.3;margin:0 0 22px;}

        /* EDIT FORM */
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:13px;margin-bottom:20px;}
        .form-group{display:flex;flex-direction:column;gap:5px;}
        .form-group.full{grid-column:1/-1;}
        .form-label{font-size:10px;font-weight:600;letter-spacing:0.14em;text-transform:uppercase;color:var(--text-dim);}
        .form-input{padding:10px 13px;background:rgba(3,9,20,0.78);border:1px solid var(--glass-border);border-radius:10px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;transition:border-color 0.25s,box-shadow 0.25s;}
        .form-input:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,169,110,0.12);}
        .form-input::placeholder{color:var(--text-dim);}
        .form-input[readonly]{opacity:0.45;cursor:not-allowed;}
        .form-select{padding:10px 13px;background:rgba(3,9,20,0.78);border:1px solid var(--glass-border);border-radius:10px;color:white;font-family:'DM Sans',sans-serif;font-size:13px;outline:none;appearance:none;cursor:pointer;transition:border-color 0.25s;}
        .form-select:focus{border-color:var(--gold);}
        .form-select option{background:#0a1628;}

        .modal-actions{display:flex;gap:10px;}
        .btn-save{flex:1;padding:13px;border:none;border-radius:12px;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;transition:all 0.3s;}
        .btn-save:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(201,169,110,0.4);}
        .btn-cancel{padding:13px 20px;border-radius:12px;background:rgba(255,255,255,0.05);border:1px solid var(--glass-border);color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:13px;cursor:pointer;transition:all 0.2s;}
        .btn-cancel:hover{background:rgba(255,255,255,0.1);color:white;}

        /* DELETE MODAL */
        .delete-icon-wrap{width:58px;height:58px;border-radius:16px;background:rgba(239,68,68,0.18);border:1px solid rgba(239,68,68,0.35);display:flex;align-items:center;justify-content:center;font-size:26px;margin:0 auto 18px;}
        .delete-confirm-text{text-align:center;margin-bottom:24px;}
        .delete-confirm-text h3{font-family:'Cormorant Garamond',serif;font-size:24px;margin-bottom:8px;}
        .delete-confirm-text p{font-size:13px;color:var(--text-dim);line-height:1.6;}
        .delete-confirm-text strong{color:#fca5a5;}
        .btn-confirm-delete{flex:1;padding:13px;border-radius:12px;background:linear-gradient(135deg,rgba(239,68,68,0.6),rgba(220,38,38,0.4));border:1px solid rgba(239,68,68,0.5);color:white;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;transition:all 0.3s;}
        .btn-confirm-delete:hover{background:linear-gradient(135deg,rgba(239,68,68,0.8),rgba(220,38,38,0.6));transform:translateY(-2px);box-shadow:0 8px 24px rgba(239,68,68,0.35);}

        /* BILL MODAL */
        .bill-header{text-align:center;margin-bottom:20px;}
        .bill-resort-name{font-family:'Cormorant Garamond',serif;font-size:25px;font-weight:600;letter-spacing:0.04em;margin-bottom:3px;}
        .bill-resort-name span{color:var(--gold);}
        .bill-subtitle{font-size:11px;letter-spacing:0.2em;text-transform:uppercase;color:var(--text-dim);}
        .bill-ref{font-size:12px;letter-spacing:0.12em;color:var(--gold-light);margin-top:7px;font-weight:600;}

        .bill-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-bottom:18px;}
        .bill-info-item{background:rgba(255,255,255,0.04);border:1px solid var(--glass-border);border-radius:10px;padding:10px 13px;}
        .bill-info-label{font-size:10px;letter-spacing:0.12em;text-transform:uppercase;color:var(--text-dim);margin-bottom:3px;}
        .bill-info-value{font-size:13px;font-weight:500;color:white;}

        .bill-items{margin-bottom:14px;}
        .bill-item{display:flex;justify-content:space-between;align-items:center;padding:9px 0;border-bottom:1px solid rgba(255,255,255,0.06);font-size:13px;}
        .bill-item:last-child{border-bottom:none;}
        .bill-item-label{color:var(--text-dim);}
        .bill-item-value{font-weight:500;color:white;}

        .bill-total{display:flex;justify-content:space-between;align-items:center;padding:15px 18px;border-radius:13px;background:linear-gradient(135deg,rgba(201,169,110,0.2),rgba(201,169,110,0.08));border:1px solid rgba(201,169,110,0.35);margin-top:12px;}
        .bill-total-label{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;}
        .bill-total-value{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:700;color:var(--gold-light);}

        .bill-actions{display:flex;gap:10px;margin-top:18px;}
        .btn-print{flex:1;padding:12px;border:none;border-radius:12px;background:linear-gradient(135deg,#c9a96e,#e8c98a);color:var(--deep-navy);font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;transition:all 0.3s;}
        .btn-print:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(201,169,110,0.4);}

        /* PRINT */
        @media print {
            body * { visibility:hidden; }
            #billModal, #billModal * { visibility:visible; }
            #billModal {
                position:fixed; inset:0; display:flex !important;
                align-items:center; justify-content:center;
                background:white; padding:0;
            }
            #billModal .modal {
                border:none; box-shadow:none; background:white;
                color:black; padding:36px; max-width:100%;
                border-radius:0;
            }
            #billModal .modal-close, #billModal .bill-actions { display:none !important; }
            #billModal .bill-resort-name { color:black !important; }
            #billModal .bill-resort-name span,
            #billModal .bill-total-value,
            #billModal .bill-ref { color:#8B6914 !important; }
            #billModal .bill-info-item,
            #billModal .bill-total { background:#f9f5ef !important; border-color:#d4b483 !important; }
            #billModal .bill-info-label,
            #billModal .bill-item-label,
            #billModal .bill-subtitle { color:#666 !important; }
            #billModal .bill-info-value,
            #billModal .bill-item-value,
            #billModal .bill-total-label { color:#111 !important; }
        }

        .footer{text-align:center;margin-top:50px;font-size:12px;color:var(--text-dim);letter-spacing:0.08em;}
        .footer::before{content:'';display:block;width:50px;height:1px;background:var(--gold);margin:0 auto 14px;}

        @media(max-width:1024px){.kpi-strip{grid-template-columns:1fr 1fr 1fr;}}
        @media(max-width:768px){.container{padding:100px 18px 60px;}.navbar{padding:12px 18px;}.form-grid{grid-template-columns:1fr;}.page-header h2{font-size:30px;}.bill-info-grid{grid-template-columns:1fr;}}
    </style>
</head>
<body>

<div class="hero-bg"></div>
<div class="wave-container"><div class="wave"></div><div class="wave"></div></div>
<div class="particles" id="particles"></div>

<!-- NAVBAR -->
<div class="navbar">
    <div class="navbar-brand">
        <span class="wave-icon">🌊</span>
        Ocean<span class="nav-gold">&nbsp;View</span>&nbsp;Resort
        <span class="admin-badge">Admin</span>
    </div>
    <div class="navbar-right">
        <a href="admin.jsp" class="nav-back">← Dashboard</a>
        <div class="user-badge">
            <div class="user-avatar" id="avatarInitial">A</div>
            <span><%= adminName %></span>
        </div>
        <a href="logout" class="logout-btn">↩ Logout</a>
    </div>
</div>

<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div class="page-eyebrow">Admin Control Panel</div>
        <h2>Manage <em>Reservations</em></h2>
    </div>

    <!-- FLASH MESSAGES -->
    <% if (!flashSuccess.isEmpty()) { %>
    <div class="flash flash-success" id="flashMsg">✅ &nbsp;<%= flashSuccess %></div>
    <% } %>
    <% if (!flashError.isEmpty()) { %>
    <div class="flash flash-error" id="flashMsg">⚠ &nbsp;<%= flashError %></div>
    <% } %>
    <% if (!dbError.isEmpty()) { %>
    <div class="flash flash-error">🔌 &nbsp;<%= dbError %></div>
    <% } %>

    <!-- KPI STRIP -->
    <div class="kpi-strip">
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">📋</span><span class="kpi-badge badge-gold">TOTAL</span></div>
            <div class="kpi-num"><%= totalCount %></div>
            <div class="kpi-label">Total Reservations</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">🔍</span><span class="kpi-badge badge-teal">SHOWING</span></div>
            <div class="kpi-num"><%= reservations.size() %></div>
            <div class="kpi-label"><%= search.isEmpty() ? "All Records" : "Search Results" %></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-top"><span class="kpi-icon">⚙️</span><span class="kpi-badge badge-green">ACCESS</span></div>
            <div class="kpi-num">Full</div>
            <div class="kpi-label">Admin Privileges</div>
        </div>
    </div>

    <!-- SECTION + SEARCH -->
    <div class="section-label">All Reservations</div>

    <div class="toolbar">
        <form class="search-form" method="GET" action="adminViewReservation.jsp">
            <div class="search-wrap">
                <span class="search-icon-pos">🔍</span>
                <input class="search-input" type="text" name="search"
                       placeholder="Search by Reservation No  (e.g. RES-002)"
                       value="<%= search %>">
            </div>
            <button type="submit" class="btn-search">Search</button>
            <% if (!search.isEmpty()) { %>
            <a href="admin.jsp" class="btn-clear">✕ Clear</a>
            <% } %>
        </form>
    </div>

    <% if (!search.isEmpty()) { %>
    <div class="search-banner">
        🔎 &nbsp;Results for &nbsp;<strong>"<%= search %>"</strong>
        &nbsp;— &nbsp;<%= reservations.size() %> record(s) found
    </div>
    <% } %>

    <!-- TABLE -->
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
            %>
                <tr><td colspan="8">
                    <div class="empty-state">
                        <div class="empty-icon"><%= search.isEmpty() ? "🏖️" : "🔍" %></div>
                        <p><%= search.isEmpty()
                            ? "No reservations found in the system."
                            : "No reservation found matching \"" + search + "\"." %></p>
                    </div>
                </td></tr>
            <%
            } else {
                for (Map<String,String> r : reservations) {
                    String resNo    = r.get("reservation_no");
                    String guest    = r.get("guest_name");
                    String address  = r.get("address");
                    String contact  = r.get("contact");
                    String roomType = r.get("room_type");
                    String checkIn  = r.get("checkin_date");
                    String checkOut = r.get("checkout_date");
                    int rate = getRate(roomType);
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
                            <button class="btn-action btn-edit"
                                onclick="openEdit(
                                    '<%= resNo %>',
                                    '<%= guest.replace("'","\\'") %>',
                                    '<%= address.replace("'","\\'") %>',
                                    '<%= contact %>',
                                    '<%= roomType %>',
                                    '<%= checkIn %>',
                                    '<%= checkOut %>'
                                )">✏️ Edit</button>

                            <button class="btn-action btn-bill"
                                onclick="openBill(
                                    '<%= resNo %>',
                                    '<%= guest.replace("'","\\'") %>',
                                    '<%= address.replace("'","\\'") %>',
                                    '<%= contact %>',
                                    '<%= roomType %>',
                                    '<%= checkIn %>',
                                    '<%= checkOut %>',
                                    '<%= rate %>'
                                )">🧾 Bill</button>

                            <button class="btn-action btn-delete"
                                onclick="openDelete('<%= resNo %>','<%= guest.replace("'","\\'") %>')">
                                🗑️ Delete</button>
                        </div>
                    </td>
                </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>

    <div class="footer">
        © 2026 Ocean View Resort &nbsp;·&nbsp; Admin Portal &nbsp;·&nbsp; All rights reserved
    </div>
</div>

<!-- ══════════════════ EDIT MODAL ══════════════════ -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <button class="modal-close" onclick="closeEdit()">✕</button>
        <div class="modal-title">Edit <span>Reservation</span></div>
        <div class="modal-subtitle" id="editSubtitle">Update booking details below</div>
        <div class="modal-divider"></div>

        <form method="POST" action="adminViewReservation.jsp" id="editForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="search" value="<%= search %>">
            <input type="hidden" name="reservation_no" id="edit_resNo">

            <div class="form-grid">
                <div class="form-group full">
                    <label class="form-label">Reservation No (read-only)</label>
                    <input class="form-input" id="edit_resNo_display" readonly>
                </div>
                <div class="form-group full">
                    <label class="form-label">Guest Name</label>
                    <input class="form-input" type="text" name="guest_name" id="edit_guest" placeholder="Full name" required>
                </div>
                <div class="form-group full">
                    <label class="form-label">Address</label>
                    <input class="form-input" type="text" name="address" id="edit_address" placeholder="Address" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Contact No</label>
                    <input class="form-input" type="text" name="contact" id="edit_contact" placeholder="07XXXXXXXX" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Room Type</label>
                    <select class="form-select" name="room_type" id="edit_roomType" required>
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Suite">Suite</option>
                        <option value="Family">Family</option>
                        <option value="Ocean">Ocean View</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-In Date</label>
                    <input class="form-input" type="date" name="checkin_date" id="edit_checkIn" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Check-Out Date</label>
                    <input class="form-input" type="date" name="checkout_date" id="edit_checkOut" required>
                </div>
            </div>

            <div class="modal-actions">
                <button type="submit" class="btn-save">💾 Save Changes</button>
                <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ══════════════════ DELETE MODAL ══════════════════ -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal" style="max-width:440px;">
        <button class="modal-close" onclick="closeDelete()">✕</button>
        <div class="delete-icon-wrap">🗑️</div>
        <div class="delete-confirm-text">
            <h3>Delete Reservation?</h3>
            <p>You are about to permanently delete<br>
               <strong id="deleteResLabel">—</strong><br>
               This action <strong>cannot be undone.</strong></p>
        </div>
        <!-- GET-based delete — simple link redirect -->
        <div id="deleteActions" class="modal-actions">
            <button class="btn-confirm-delete" id="deleteConfirmBtn" onclick="confirmDelete()">
                🗑️ Yes, Delete
            </button>
            <button type="button" class="btn-cancel" onclick="closeDelete()">Cancel</button>
        </div>
    </div>
</div>

<!-- ══════════════════ BILL MODAL ══════════════════ -->
<div class="modal-overlay" id="billModal">
    <div class="modal">
        <button class="modal-close" onclick="closeBill()">✕</button>

        <div class="bill-header">
            <div class="bill-resort-name">🌊 Ocean <span>View</span> Resort</div>
            <div class="bill-subtitle">Official Guest Invoice</div>
            <div class="bill-ref" id="billRef">—</div>
        </div>

        <div class="modal-divider"></div>

        <div class="bill-info-grid">
            <div class="bill-info-item"><div class="bill-info-label">Guest Name</div><div class="bill-info-value" id="billGuest">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Contact No</div><div class="bill-info-value" id="billContact">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Address</div><div class="bill-info-value" id="billAddress">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Room Type</div><div class="bill-info-value" id="billRoomType">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-In Date</div><div class="bill-info-value" id="billCheckIn">—</div></div>
            <div class="bill-info-item"><div class="bill-info-label">Check-Out Date</div><div class="bill-info-value" id="billCheckOut">—</div></div>
        </div>

        <div class="modal-divider"></div>

        <div class="bill-items">
            <div class="bill-item"><span class="bill-item-label">🌙 Number of Nights</span><span class="bill-item-value" id="billNights">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🛏️ Rate Per Night</span><span class="bill-item-value" id="billRate">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🏨 Room Charges</span><span class="bill-item-value" id="billRoomCharge">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🧹 Service & Housekeeping (10%)</span><span class="bill-item-value" id="billService">—</span></div>
            <div class="bill-item"><span class="bill-item-label">🏛️ Tax (8%)</span><span class="bill-item-value" id="billTax">—</span></div>
        </div>

        <div class="bill-total">
            <span class="bill-total-label">Total Amount Due</span>
            <span class="bill-total-value" id="billTotal">$0.00</span>
        </div>

        <div class="bill-actions">
            <button class="btn-print" onclick="window.print()">🖨️ Print Invoice</button>
            <button type="button" class="btn-cancel" onclick="closeBill()">Close</button>
        </div>
    </div>
</div>

<script>
    // Avatar
    var an = "<%= adminName %>";
    document.getElementById("avatarInitial").textContent = an ? an.charAt(0).toUpperCase() : "A";

    // Particles
    var pc = document.getElementById("particles");
    for (var i = 0; i < 16; i++) {
        var p = document.createElement("div");
        p.className = "particle";
        p.style.cssText = "--x:"+Math.random()*100+"%;--dur:"+(12+Math.random()*14)+"s;--delay:"+(Math.random()*12)+"s";
        pc.appendChild(p);
    }

    // Auto-dismiss flash
    var fm = document.getElementById("flashMsg");
    if (fm) setTimeout(function(){
        fm.style.transition="opacity 0.5s"; fm.style.opacity="0";
        setTimeout(function(){ fm.remove(); }, 500);
    }, 4000);

    // Navbar scroll
    window.addEventListener("scroll", function(){
        document.querySelector(".navbar").style.background =
            window.scrollY > 40 ? "rgba(5,13,26,0.99)" : "rgba(5,13,26,0.92)";
    }, {passive:true});

    // ── EDIT MODAL ──────────────────────────────────────────────
    function openEdit(resNo, guest, address, contact, roomType, checkIn, checkOut) {
        document.getElementById("edit_resNo").value         = resNo;
        document.getElementById("edit_resNo_display").value = resNo;
        document.getElementById("edit_guest").value         = guest;
        document.getElementById("edit_address").value       = address;
        document.getElementById("edit_contact").value       = contact;
        document.getElementById("edit_checkIn").value       = checkIn;
        document.getElementById("edit_checkOut").value      = checkOut;
        document.getElementById("editSubtitle").textContent = "Editing: " + resNo;
        var sel = document.getElementById("edit_roomType");
        for (var i = 0; i < sel.options.length; i++) {
            if (sel.options[i].value.toLowerCase() === roomType.toLowerCase()) {
                sel.selectedIndex = i; break;
            }
        }
        document.getElementById("editModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeEdit() {
        document.getElementById("editModal").classList.remove("open");
        document.body.style.overflow = "";
    }

    // ── DELETE MODAL ─────────────────────────────────────────────
    var _deleteResNo = "";
    function openDelete(resNo, guest) {
        _deleteResNo = resNo;
        document.getElementById("deleteResLabel").textContent = resNo + "  —  " + guest;
        document.getElementById("deleteModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeDelete() {
        document.getElementById("deleteModal").classList.remove("open");
        document.body.style.overflow = "";
    }
    function confirmDelete() {
        var search = "<%= search %>";
        var url = "adminViewReservation.jsp?action=delete&reservation_no=" + encodeURIComponent(_deleteResNo);
        if (search) url += "&search=" + encodeURIComponent(search);
        window.location.href = url;
    }

    // ── BILL MODAL ───────────────────────────────────────────────
    function openBill(resNo, guest, address, contact, roomType, checkIn, checkOut, rate) {
        document.getElementById("billRef").textContent      = "Reservation No: " + resNo;
        document.getElementById("billGuest").textContent    = guest;
        document.getElementById("billContact").textContent  = contact;
        document.getElementById("billAddress").textContent  = address;
        document.getElementById("billRoomType").textContent = roomType;
        document.getElementById("billCheckIn").textContent  = checkIn;
        document.getElementById("billCheckOut").textContent = checkOut;

        var rateNum = parseFloat(rate) || 0;
        document.getElementById("billRate").textContent = "$" + rateNum.toFixed(2) + " / night";

        var nights = 0;
        if (checkIn && checkOut && checkIn !== "—" && checkOut !== "—") {
            var diff = new Date(checkOut) - new Date(checkIn);
            if (diff > 0) nights = Math.round(diff / 86400000);
        }
        var roomCharge = rateNum * nights;
        var service    = roomCharge * 0.10;
        var tax        = roomCharge * 0.08;
        var total      = roomCharge + service + tax;

        document.getElementById("billNights").textContent     = nights + (nights === 1 ? " night" : " nights");
        document.getElementById("billRoomCharge").textContent = "$" + roomCharge.toFixed(2);
        document.getElementById("billService").textContent    = "$" + service.toFixed(2);
        document.getElementById("billTax").textContent        = "$" + tax.toFixed(2);
        document.getElementById("billTotal").textContent      = "$" + total.toFixed(2);

        document.getElementById("billModal").classList.add("open");
        document.body.style.overflow = "hidden";
    }
    function closeBill() {
        document.getElementById("billModal").classList.remove("open");
        document.body.style.overflow = "";
    }

    // Close on overlay click
    ["editModal","deleteModal","billModal"].forEach(function(id){
        document.getElementById(id).addEventListener("click", function(e){
            if (e.target === this) {
                closeEdit(); closeDelete(); closeBill();
            }
        });
    });

    // Escape key
    document.addEventListener("keydown", function(e){
        if (e.key === "Escape") { closeEdit(); closeDelete(); closeBill(); }
    });

    // Date validation on edit submit
    document.getElementById("editForm").addEventListener("submit", function(e){
        var ci = new Date(document.getElementById("edit_checkIn").value);
        var co = new Date(document.getElementById("edit_checkOut").value);
        if (co <= ci) {
            e.preventDefault();
            alert("Check-out date must be after check-in date.");
        }
    });
</script>
</body>
</html>
