package Register;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staffDashboard")
public class Staff extends HttpServlet {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    // ── Rate per night by room type ──────────────────────────────
    private int getRateByType(String roomType) {
        if (roomType == null) return 80;
        String rt = roomType.toLowerCase().trim();
        if (rt.contains("suite"))    return 250;
        if (rt.contains("deluxe"))   return 150;
        if (rt.contains("family"))   return 180;
        if (rt.contains("ocean"))    return 220;
        return 80; // standard / default
    }

    // ── GET: load dashboard (with optional search) ───────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String searchNo = request.getParameter("search");
        if (searchNo == null) searchNo = "";

        List<Map<String, String>> reservations = new ArrayList<>();
        int totalBookings = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // ── Total count ──────────────────────────────────────
            PreparedStatement stTotal = conn.prepareStatement(
                "SELECT COUNT(*) FROM reservations"
            );
            ResultSet rsTotal = stTotal.executeQuery();
            if (rsTotal.next()) totalBookings = rsTotal.getInt(1);
            rsTotal.close();
            stTotal.close();

            // ── Fetch rows ───────────────────────────────────────
            PreparedStatement ps;
            String baseSql =
                "SELECT reservation_no, guest_name, address, contact, room_type, " +
                "       checkin_date, checkout_date " +
                "FROM reservations ";

            if (!searchNo.trim().isEmpty()) {
                // Search by reservation_no (supports partial match)
                ps = conn.prepareStatement(
                    baseSql + "WHERE reservation_no LIKE ? ORDER BY checkin_date DESC"
                );
                ps.setString(1, "%" + searchNo.trim() + "%");
            } else {
                ps = conn.prepareStatement(
                    baseSql + "ORDER BY checkin_date DESC"
                );
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("reservation_no", rs.getString("reservation_no"));
                row.put("guest_name",     rs.getString("guest_name"));
                row.put("address",        rs.getString("address"));
                row.put("contact",        rs.getString("contact"));
                row.put("room_type",      rs.getString("room_type"));
                row.put("checkin_date",   rs.getString("checkin_date"));
                row.put("checkout_date",  rs.getString("checkout_date"));

                // Calculate rate and attach to row
                int rate = getRateByType(rs.getString("room_type"));
                row.put("rate", String.valueOf(rate));

                reservations.add(row);
            }
            rs.close();
            ps.close();
            conn.close();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database driver not found.");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        // ── Pass data to JSP ─────────────────────────────────────
        request.setAttribute("reservations",  reservations);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("searchNo",      searchNo);

        request.getRequestDispatcher("staffDashboard.jsp")
               .forward(request, response);
    }

    // ── POST: not used — search is GET-based ─────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
