package Register;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class Register extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ── Validation ──────────────────────────────────────────────────
        if (username == null || password == null || confirmPassword == null ||
            username.trim().isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        username = username.trim();

        if (username.length() < 3) {
            request.setAttribute("errorMessage", "Username must be at least 3 characters.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 4) {
            request.setAttribute("errorMessage", "Password must be at least 4 characters.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // ── Duplicate username check ─────────────────────────────────
            PreparedStatement check = conn.prepareStatement(
                "SELECT username FROM users WHERE username = ?");
            check.setString(1, username);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                rs.close(); check.close();
                request.setAttribute("errorMessage", "Username already taken. Please choose another.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }
            rs.close(); check.close();

            // ── Insert — role is ALWAYS 'user', never exposed to frontend ──
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (username, password, role) VALUES (?, ?, 'user')");
            ps.setString(1, username);
            ps.setString(2, password);
            int row = ps.executeUpdate();
            ps.close();

            if (row > 0) {
                response.sendRedirect("login.jsp?registered=1");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
