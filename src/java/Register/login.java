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
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class login extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read username and password only — no role from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Validate not empty
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 3. Check DB — match username + password, read role from DB
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, username.trim());
                    ps.setString(2, password);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {
                            // ── LOGIN SUCCESS ──
                            String dbRole = rs.getString("role"); // get role from database

                            HttpSession session = request.getSession(true);
                            session.setMaxInactiveInterval(30 * 60); // 30 min

                            // Common session values
                            session.setAttribute("username", username.trim());
                            session.setAttribute("role",     dbRole);
                            session.setAttribute("successMessage", "Welcome back, " + username.trim() + "!");

                            // Redirect based on role stored in DB
                            if (dbRole.equals("admin")) {
                                session.setAttribute("admin", username.trim());
                                response.sendRedirect("AdminDashboard");

                            } else if (dbRole.equals("staff")) {
                                session.setAttribute("staff", username.trim());
                                response.sendRedirect("Staff");

                            } else {
                                // role = "user" → guest
                                session.setAttribute("user", username.trim());
                                response.sendRedirect("home.jsp");
                            }

                        } else {
                            // ── LOGIN FAILED ──
                            request.setAttribute("errorMessage", "Invalid username or password.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    }
                }
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database driver not found.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Redirect any GET request back to login page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
