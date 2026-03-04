package Register;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDashboard")
public class AdminDashboard extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard — only admin allowed
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String adminName = (String) session.getAttribute("admin");

        int totalRes   = 0;
        int totalUsers = 0;
        int totalStaff = 0;
        List<String[]> recentRes = new ArrayList<>();
        String dbErr = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Count total reservations
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM reservations");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) totalRes = rs1.getInt(1);
            rs1.close(); ps1.close();

            // Count guest users
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role='user'");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) totalUsers = rs2.getInt(1);
            rs2.close(); ps2.close();

            // Count staff
            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role='staff'");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) totalStaff = rs3.getInt(1);
            rs3.close(); ps3.close();

            // Recent 6 reservations
            PreparedStatement ps4 = conn.prepareStatement(
                "SELECT reservation_no, guest_name, room_type, checkin_date, checkout_date " +
                "FROM reservations ORDER BY checkin_date DESC LIMIT 6");
            ResultSet rs4 = ps4.executeQuery();
            while (rs4.next()) {
                recentRes.add(new String[]{
                    rs4.getString("reservation_no"),
                    rs4.getString("guest_name"),
                    rs4.getString("room_type"),
                    String.valueOf(rs4.getDate("checkin_date")),
                    String.valueOf(rs4.getDate("checkout_date"))
                });
            }
            rs4.close(); ps4.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            dbErr = e.getMessage();
        }

        // Set all data as request attributes for JSP to display
        request.setAttribute("adminName",  adminName);
        request.setAttribute("totalRes",   totalRes);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("recentRes",  recentRes);
        request.setAttribute("dbErr",      dbErr);
        request.setAttribute("today",      LocalDate.now().toString());

        // Forward to JSP (display only)
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
