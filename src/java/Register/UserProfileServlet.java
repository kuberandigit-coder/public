package Register;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserProfile")
public class UserProfileServlet extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    // ── GET — load profile page ───────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String username = (String) session.getAttribute("user");
        String role     = "";
        int    totalRes = 0;
        String dbErr    = "";

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Get user role
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT role FROM users WHERE username = ?");
            ps1.setString(1, username);
            ResultSet r1 = ps1.executeQuery();
            if (r1.next()) role = r1.getString("role");
            r1.close(); ps1.close();

            // Count reservations for this user (by guest_name matching username)
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT COUNT(*) FROM reservations WHERE guest_name = ?");
            ps2.setString(1, username);
            ResultSet r2 = ps2.executeQuery();
            if (r2.next()) totalRes = r2.getInt(1);
            r2.close(); ps2.close();

        } catch (Exception e) {
            e.printStackTrace();
            dbErr = e.getMessage();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("profileUsername", username);
        request.setAttribute("profileRole",     role);
        request.setAttribute("profileTotalRes", totalRes);
        request.setAttribute("dbErr",           dbErr);

        request.getRequestDispatcher("userProfile.jsp").forward(request, response);
    }

    // ── POST — handle actions ─────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String username = (String) session.getAttribute("user");
        String action   = request.getParameter("action");

        if ("deleteAccount".equals(action)) {
            handleDeleteAccount(request, response, username);
        } else {
            // Default: change password (original behaviour)
            handleChangePassword(request, response, username);
        }
    }

    // ── Change Password ───────────────────────
    private void handleChangePassword(HttpServletRequest request,
            HttpServletResponse response, String username)
            throws ServletException, IOException {

        String currentPw = request.getParameter("currentPassword");
        String newPw     = request.getParameter("newPassword");
        String confirmPw = request.getParameter("confirmPassword");

        if (currentPw == null || newPw == null || confirmPw == null ||
            currentPw.isEmpty() || newPw.isEmpty() || confirmPw.isEmpty()) {
            request.setAttribute("pwErr", "All password fields are required.");
            doGet(request, response); return;
        }
        if (!newPw.equals(confirmPw)) {
            request.setAttribute("pwErr", "New password and confirmation do not match.");
            doGet(request, response); return;
        }
        if (newPw.length() < 4) {
            request.setAttribute("pwErr", "New password must be at least 4 characters.");
            doGet(request, response); return;
        }

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Verify current password
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT password FROM users WHERE username = ?");
            ps1.setString(1, username);
            ResultSet r1 = ps1.executeQuery();
            boolean verified = false;
            if (r1.next()) {
                String storedPw = r1.getString("password");
                verified = storedPw.equals(currentPw);
            }
            r1.close(); ps1.close();

            if (!verified) {
                conn.close();
                request.setAttribute("pwErr", "Current password is incorrect.");
                doGet(request, response); return;
            }

            // Update password
            PreparedStatement ps2 = conn.prepareStatement(
                "UPDATE users SET password = ? WHERE username = ?");
            ps2.setString(1, newPw);
            ps2.setString(2, username);
            int rows = ps2.executeUpdate();
            ps2.close();
            conn.close();

            if (rows > 0) {
                request.setAttribute("pwOk", "Password changed successfully!");
            } else {
                request.setAttribute("pwErr", "Password update failed. Try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("pwErr", "Database error: " + e.getMessage());
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }

        doGet(request, response);
    }

    // ── Delete Account ────────────────────────
    private void handleDeleteAccount(HttpServletRequest request,
            HttpServletResponse response, String username)
            throws ServletException, IOException {

        String confirmDelete = request.getParameter("confirmDelete");
        if (!"DELETE".equals(confirmDelete)) {
            request.setAttribute("delErr", "Please type DELETE to confirm.");
            doGet(request, response); return;
        }

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Delete reservations first (FK safety)
            PreparedStatement ps1 = conn.prepareStatement(
                "DELETE FROM reservations WHERE guest_name = ?");
            ps1.setString(1, username);
            ps1.executeUpdate();
            ps1.close();

            // Delete user
            PreparedStatement ps2 = conn.prepareStatement(
                "DELETE FROM users WHERE username = ?");
            ps2.setString(1, username);
            ps2.executeUpdate();
            ps2.close();

            // Invalidate session and redirect
            request.getSession().invalidate();
            response.sendRedirect("login.jsp?deleted=1");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("delErr", "Database error: " + e.getMessage());
            doGet(request, response);
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
