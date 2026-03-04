package Register;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserManagement")
public class UserManagementServlet extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    // ── GET ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // ── DELETE ───────────────────────────────────────────
        if ("delete".equals(action)) {
            String username = request.getParameter("username");
            String search   = request.getParameter("search");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM users WHERE username = ?");
                ps.setString(1, username);
                int rows = ps.executeUpdate();
                ps.close(); conn.close();

                if (rows > 0) {
                    session.setAttribute("flashOk", "Account '" + username + "' deleted successfully.");
                } else {
                    session.setAttribute("flashErr", "Account not found.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashErr", "Delete failed: " + e.getMessage());
            }

            String redirect = "UserManagement";
            if (search != null && !search.isEmpty()) redirect += "?search=" + search;
            response.sendRedirect(redirect);
            return;
        }

        loadPage(request, response);
    }

    // ── POST ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            handleAdd(request, response);
        } else if ("edit".equals(action)) {
            handleEdit(request, response);
        } else {
            loadPage(request, response);
        }
    }

    // ── ADD ───────────────────────────────────────────────────
    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");
        String search   = request.getParameter("search");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Duplicate check
            PreparedStatement chk = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE username = ?");
            chk.setString(1, username);
            ResultSet rs = chk.executeQuery();
            rs.next();
            int exists = rs.getInt(1);
            rs.close(); chk.close();

            if (exists > 0) {
                session.setAttribute("flashErr", "Username '" + username + "' already exists.");
                conn.close();
                response.sendRedirect("UserManagement" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
                return;
            }

            // Insert — only 3 columns: username, password, role
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (username, password, role) VALUES (?, ?, ?)");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            int rows = ps.executeUpdate();
            ps.close(); conn.close();

            if (rows > 0) {
                session.setAttribute("flashOk", "Account '" + username + "' created successfully.");
            } else {
                session.setAttribute("flashErr", "Failed to create account.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }

        response.sendRedirect("UserManagement" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
    }

    // ── EDIT ──────────────────────────────────────────────────
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String originalUsername = request.getParameter("originalUsername");
        String newUsername      = request.getParameter("username");
        String newPassword      = request.getParameter("password"); // blank = no change
        String newRole          = request.getParameter("role");
        String search           = request.getParameter("search");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                ps = conn.prepareStatement(
                    "UPDATE users SET username=?, password=?, role=? WHERE username=?");
                ps.setString(1, newUsername);
                ps.setString(2, newPassword);
                ps.setString(3, newRole);
                ps.setString(4, originalUsername);
            } else {
                ps = conn.prepareStatement(
                    "UPDATE users SET username=?, role=? WHERE username=?");
                ps.setString(1, newUsername);
                ps.setString(2, newRole);
                ps.setString(3, originalUsername);
            }

            int rows = ps.executeUpdate();
            ps.close(); conn.close();

            if (rows > 0) {
                session.setAttribute("flashOk", "Account updated successfully.");
            } else {
                session.setAttribute("flashErr", "Failed to update account.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }

        response.sendRedirect("UserManagement" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
    }

    // ── LOAD PAGE ─────────────────────────────────────────────
    private void loadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String search = request.getParameter("search");
        List<String[]> users = new ArrayList<>();
        int totalAll = 0, totalUsers = 0, totalStaff = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // KPI counts
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM users");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) totalAll = rs1.getInt(1);
            rs1.close(); ps1.close();

            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role='user'");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) totalUsers = rs2.getInt(1);
            rs2.close(); ps2.close();

            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role='staff'");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) totalStaff = rs3.getInt(1);
            rs3.close(); ps3.close();

            // Fetch users — ✅ ORDER BY username (no id column)
            PreparedStatement ps4;
            if (search != null && !search.trim().isEmpty()) {
                ps4 = conn.prepareStatement(
                    "SELECT username, password, role FROM users WHERE username LIKE ? ORDER BY username");
                ps4.setString(1, "%" + search.trim() + "%");
            } else {
                ps4 = conn.prepareStatement(
                    "SELECT username, password, role FROM users ORDER BY username");
            }

            ResultSet rs4 = ps4.executeQuery();
            while (rs4.next()) {
                // ✅ Only 3 columns — no id
                users.add(new String[]{
                    rs4.getString("username"),  // [0]
                    rs4.getString("password"),  // [1]
                    rs4.getString("role")       // [2]
                });
            }
            rs4.close(); ps4.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }

        // Flash messages
        request.setAttribute("flashOk",  session.getAttribute("flashOk"));
        if (request.getAttribute("flashErr") == null) {
            request.setAttribute("flashErr", session.getAttribute("flashErr"));
        }
        session.removeAttribute("flashOk");
        session.removeAttribute("flashErr");

        // Pass to JSP
        request.setAttribute("users",      users);
        request.setAttribute("totalAll",   totalAll);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("search",     search != null ? search : "");
        request.setAttribute("adminName",  session.getAttribute("admin"));

        request.getRequestDispatcher("adminUserManagement.jsp").forward(request, response);
    }
}
