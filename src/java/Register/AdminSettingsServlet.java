package Register;

import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminSettings")
public class AdminSettingsServlet extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    // ── GET ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        loadPage(request, response);
    }

    // ── POST ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        String action = request.getParameter("action");
        if      ("updateProfile".equals(action))  handleUpdateProfile(request, response);
        else if ("changePassword".equals(action)) handleChangePassword(request, response);
        else if ("updateHotel".equals(action))    handleUpdateHotel(request, response);
        else loadPage(request, response);
    }

    // ── UPDATE PROFILE ────────────────────────────────────────
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String currentAdmin = (String) session.getAttribute("admin");
        String newUsername  = request.getParameter("newUsername");
        if (newUsername == null || newUsername.trim().isEmpty()) {
            session.setAttribute("flashErr", "Username cannot be empty.");
            response.sendRedirect("AdminSettings"); return;
        }
        newUsername = newUsername.trim();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement chk = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE username=? AND username!=?");
            chk.setString(1, newUsername); chk.setString(2, currentAdmin);
            ResultSet rs = chk.executeQuery(); rs.next();
            if (rs.getInt(1) > 0) {
                rs.close(); chk.close(); conn.close();
                session.setAttribute("flashErr", "Username '" + newUsername + "' is already taken.");
                response.sendRedirect("AdminSettings"); return;
            }
            rs.close(); chk.close();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET username=? WHERE username=? AND role='admin'");
            ps.setString(1, newUsername); ps.setString(2, currentAdmin);
            int rows = ps.executeUpdate(); ps.close(); conn.close();
            if (rows > 0) {
                session.setAttribute("admin", newUsername);
                session.setAttribute("flashOk", "Profile updated. Welcome, " + newUsername + "!");
            } else {
                session.setAttribute("flashErr", "Failed to update profile.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }
        response.sendRedirect("AdminSettings");
    }

    // ── CHANGE PASSWORD ───────────────────────────────────────
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminName  = (String) session.getAttribute("admin");
        String currentPwd = request.getParameter("currentPassword");
        String newPwd     = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");
        if (currentPwd==null||newPwd==null||confirmPwd==null||
            currentPwd.trim().isEmpty()||newPwd.trim().isEmpty()) {
            session.setAttribute("flashErr", "All password fields are required.");
            response.sendRedirect("AdminSettings"); return;
        }
        if (!newPwd.equals(confirmPwd)) {
            session.setAttribute("flashErr", "New password and confirmation do not match.");
            response.sendRedirect("AdminSettings"); return;
        }
        if (newPwd.length() < 6) {
            session.setAttribute("flashErr", "Password must be at least 6 characters.");
            response.sendRedirect("AdminSettings"); return;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement chk = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE username=? AND password=?");
            chk.setString(1, adminName); chk.setString(2, currentPwd.trim());
            ResultSet rs = chk.executeQuery(); rs.next();
            if (rs.getInt(1) == 0) {
                rs.close(); chk.close(); conn.close();
                session.setAttribute("flashErr", "Current password is incorrect.");
                response.sendRedirect("AdminSettings"); return;
            }
            rs.close(); chk.close();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET password=? WHERE username=? AND role='admin'");
            ps.setString(1, newPwd.trim()); ps.setString(2, adminName);
            int rows = ps.executeUpdate(); ps.close(); conn.close();
            if (rows > 0) session.setAttribute("flashOk", "Password changed successfully.");
            else           session.setAttribute("flashErr", "Failed to change password.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }
        response.sendRedirect("AdminSettings");
    }

    // ── UPDATE HOTEL INFO ─────────────────────────────────────
    private void handleUpdateHotel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String[][] pairs = {
            {"hotel_name",    request.getParameter("hotelName")},
            {"hotel_email",   request.getParameter("hotelEmail")},
            {"hotel_phone",   request.getParameter("hotelPhone")},
            {"hotel_address", request.getParameter("hotelAddress")},
            {"hotel_city",    request.getParameter("hotelCity")},
            {"checkin_time",  request.getParameter("checkInTime")},
            {"checkout_time", request.getParameter("checkOutTime")},
            {"currency",      request.getParameter("currency")},
            {"tax_rate",      request.getParameter("taxRate")},
            {"service_rate",  request.getParameter("serviceRate")}
        };
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.createStatement().execute(
                "CREATE TABLE IF NOT EXISTS settings(" +
                "setting_key VARCHAR(100) PRIMARY KEY, setting_value TEXT)");
            for (String[] kv : pairs) {
                if (kv[1] == null) kv[1] = "";
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO settings(setting_key,setting_value) VALUES(?,?) " +
                    "ON DUPLICATE KEY UPDATE setting_value=?");
                ps.setString(1, kv[0]); ps.setString(2, kv[1]); ps.setString(3, kv[1]);
                ps.executeUpdate(); ps.close();
            }
            conn.close();
            session.setAttribute("flashOk", "Hotel settings saved successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }
        response.sendRedirect("AdminSettings");
    }

    // ── LOAD PAGE ─────────────────────────────────────────────
    private void loadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String adminName = (String) session.getAttribute("admin");

        // Default settings
        Map<String,String> settings = new HashMap<>();
        settings.put("hotel_name",    "Ocean View Resort");
        settings.put("hotel_email",   "admin@oceanview.com");
        settings.put("hotel_phone",   "+1-555-0100");
        settings.put("hotel_address", "123 Beach Road");
        settings.put("hotel_city",    "Miami, FL");
        settings.put("checkin_time",  "14:00");
        settings.put("checkout_time", "12:00");
        settings.put("currency",      "USD");
        settings.put("tax_rate",      "8");
        settings.put("service_rate",  "10");

        int totalUsers = 0, totalStaff = 0, totalRes = 0;
        String dbErr = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            // Load saved settings
            try {
                ResultSet rs = conn.createStatement()
                    .executeQuery("SELECT setting_key,setting_value FROM settings");
                while (rs.next()) settings.put(rs.getString(1), rs.getString(2));
                rs.close();
            } catch (Exception ignored) {}
            // Stats
            ResultSet r1 = conn.createStatement()
                .executeQuery("SELECT COUNT(*) FROM users WHERE role='user'");
            if (r1.next()) totalUsers = r1.getInt(1); r1.close();
            ResultSet r2 = conn.createStatement()
                .executeQuery("SELECT COUNT(*) FROM users WHERE role='staff'");
            if (r2.next()) totalStaff = r2.getInt(1); r2.close();
            ResultSet r3 = conn.createStatement()
                .executeQuery("SELECT COUNT(*) FROM reservations");
            if (r3.next()) totalRes = r3.getInt(1); r3.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace(); dbErr = e.getMessage();
        }

        request.setAttribute("flashOk",  session.getAttribute("flashOk"));
        request.setAttribute("flashErr", dbErr.isEmpty()
            ? session.getAttribute("flashErr")
            : "Database Error: " + dbErr);
        session.removeAttribute("flashOk");
        session.removeAttribute("flashErr");
        request.setAttribute("adminName",        adminName);
        request.setAttribute("settings",         settings);
        request.setAttribute("totalUsers",        totalUsers);
        request.setAttribute("totalStaff",        totalStaff);
        request.setAttribute("totalReservations", totalRes);
        request.getRequestDispatcher("adminSettings.jsp").forward(request, response);
    }
}
