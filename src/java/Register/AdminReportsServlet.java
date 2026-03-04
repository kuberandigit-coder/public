package Register;

import java.io.IOException;
import java.sql.*;
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

@WebServlet("/AdminReports")
public class AdminReportsServlet extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String adminName = (String) session.getAttribute("admin");

        int    totalReservations = 0;
        int    totalGuests       = 0;
        double totalRevenue      = 0;
        int    checkedInToday    = 0;
        int    checkingOutToday  = 0;

        String[] roomTypes = {"Standard", "Deluxe", "Family", "Ocean View", "Suite"};
        double[] roomRates = {80, 150, 180, 220, 250};

        Map<String, Integer> roomCounts  = new LinkedHashMap<>();
        Map<String, Double>  roomRevenue = new LinkedHashMap<>();
        for (String rt : roomTypes) {
            roomCounts.put(rt, 0);
            roomRevenue.put(rt, 0.0);
        }

        List<Map<String, String>> recentList = new ArrayList<>();
        String dbErr = "";

        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // ── 1. Total reservations ─────────────────────────
            Statement st1 = conn.createStatement();
            ResultSet r1  = st1.executeQuery("SELECT COUNT(*) FROM reservations");
            if (r1.next()) totalReservations = r1.getInt(1);
            r1.close(); st1.close();

            // ── 2. Unique guests ──────────────────────────────
            Statement st2 = conn.createStatement();
            ResultSet r2  = st2.executeQuery("SELECT COUNT(DISTINCT guest_name) FROM reservations");
            if (r2.next()) totalGuests = r2.getInt(1);
            r2.close(); st2.close();

            // ── 3. Check-ins today ────────────────────────────
            Statement st3 = conn.createStatement();
            ResultSet r3  = st3.executeQuery(
                "SELECT COUNT(*) FROM reservations WHERE DATE(checkin_date) = CURDATE()");
            if (r3.next()) checkedInToday = r3.getInt(1);
            r3.close(); st3.close();

            // ── 4. Check-outs today ───────────────────────────
            Statement st4 = conn.createStatement();
            ResultSet r4  = st4.executeQuery(
                "SELECT COUNT(*) FROM reservations WHERE DATE(checkout_date) = CURDATE()");
            if (r4.next()) checkingOutToday = r4.getInt(1);
            r4.close(); st4.close();

            // ── 5. Room type breakdown + revenue ──────────────
            PreparedStatement ps5 = conn.prepareStatement(
                "SELECT room_type, COUNT(*) AS cnt, " +
                "SUM(DATEDIFF(checkout_date, checkin_date)) AS nights " +
                "FROM reservations GROUP BY room_type");
            ResultSet r5 = ps5.executeQuery();
            while (r5.next()) {
                String rt   = r5.getString("room_type");
                int    cnt  = r5.getInt("cnt");
                int    nts  = r5.getInt("nights");
                if (nts < 0) nts = 0;
                double rate = 80;
                for (int i = 0; i < roomTypes.length; i++) {
                    if (roomTypes[i].equalsIgnoreCase(rt)) { rate = roomRates[i]; break; }
                }
                double rev = nts * rate;
                roomCounts.put(rt, cnt);
                roomRevenue.put(rt, rev);
                totalRevenue += rev;
            }
            r5.close(); ps5.close();

            // ── 6. Recent 10 reservations ─────────────────────
            PreparedStatement ps6 = conn.prepareStatement(
                "SELECT reservation_no, guest_name, room_type, checkin_date, checkout_date " +
                "FROM reservations ORDER BY checkin_date DESC LIMIT 10");
            ResultSet r6 = ps6.executeQuery();
            while (r6.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("res_no",   r6.getString("reservation_no"));
                row.put("guest",    r6.getString("guest_name"));
                row.put("room",     r6.getString("room_type"));
                row.put("checkin",  r6.getString("checkin_date"));
                row.put("checkout", r6.getString("checkout_date"));

                // Estimate nights & revenue
                try {
                    java.sql.Date ci = r6.getDate("checkin_date");
                    java.sql.Date co = r6.getDate("checkout_date");
                    long nights = (co.getTime() - ci.getTime()) / (1000L * 60 * 60 * 24);
                    if (nights < 1) nights = 1;
                    double rate = 80;
                    String rm = r6.getString("room_type");
                    for (int i = 0; i < roomTypes.length; i++) {
                        if (roomTypes[i].equalsIgnoreCase(rm)) { rate = roomRates[i]; break; }
                    }
                    row.put("nights",  String.valueOf(nights));
                    row.put("revenue", String.format("%.2f", nights * rate));
                } catch (Exception ex) {
                    row.put("nights",  "1");
                    row.put("revenue", "0.00");
                }
                recentList.add(row);
            }
            r6.close(); ps6.close();

        } catch (Exception e) {
            e.printStackTrace();
            dbErr = e.getMessage();
        } finally {
            // ── Always close connection ───────────────────────
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }

        // ── Set request attributes ────────────────────────────
        request.setAttribute("adminName",         adminName);
        request.setAttribute("totalReservations", totalReservations);
        request.setAttribute("totalGuests",        totalGuests);
        request.setAttribute("totalRevenue",       String.format("%.2f", totalRevenue));
        request.setAttribute("checkedInToday",     checkedInToday);
        request.setAttribute("checkingOutToday",   checkingOutToday);
        request.setAttribute("roomCounts",         roomCounts);
        request.setAttribute("roomRevenue",        roomRevenue);
        request.setAttribute("recentList",         recentList);
        request.setAttribute("dbErr",              dbErr);

        request.getRequestDispatcher("AdminReports.jsp").forward(request, response);
    }
}
