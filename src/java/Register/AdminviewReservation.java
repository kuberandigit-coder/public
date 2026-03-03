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

@WebServlet(name = "AdminViewReservation", urlPatterns = {"/AdminViewReservation"})
public class AdminviewReservation extends HttpServlet {

    private final String DB_URL  = "jdbc:mysql://localhost:3306/mydb";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    // ── GET: show all / search ───────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if (search == null) search = "";

        List<Map<String, String>> reservations = new ArrayList<>();
        int totalCount = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Total count
            PreparedStatement stCount = con.prepareStatement(
                "SELECT COUNT(*) FROM reservations"
            );
            ResultSet rsCount = stCount.executeQuery();
            if (rsCount.next()) totalCount = rsCount.getInt(1);
            rsCount.close();
            stCount.close();

            // Fetch rows — search or all
            PreparedStatement ps;
            String baseSql =
                "SELECT reservation_no, guest_name, address, contact, room_type, " +
                "checkin_date, checkout_date FROM reservations ";

            if (!search.trim().isEmpty()) {
                ps = con.prepareStatement(
                    baseSql + "WHERE reservation_no LIKE ? ORDER BY checkin_date DESC"
                );
                ps.setString(1, "%" + search.trim() + "%");
            } else {
                ps = con.prepareStatement(
                    baseSql + "ORDER BY checkin_date DESC"
                );
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("reservation_no", safe(rs.getString("reservation_no")));
                row.put("guest_name",     safe(rs.getString("guest_name")));
                row.put("address",        safe(rs.getString("address")));
                row.put("contact",        safe(rs.getString("contact")));
                row.put("room_type",      safe(rs.getString("room_type")));
                row.put("checkin_date",   safe(String.valueOf(rs.getDate("checkin_date"))));
                row.put("checkout_date",  safe(String.valueOf(rs.getDate("checkout_date"))));
                reservations.add(row);
            }
            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("dbError", "Database error: " + e.getMessage());
        }

        request.setAttribute("reservations", reservations);
        request.setAttribute("totalCount",   totalCount);
        request.setAttribute("search",       search);
        request.getRequestDispatcher("adminViewReservation.jsp")
               .forward(request, response);
    }

    // ── POST: delete or edit ─────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String action = request.getParameter("action");
        String search = safe(request.getParameter("search"));

        // ── DELETE ──────────────────────────────────────────────
        if ("delete".equals(action)) {
            String resNo = request.getParameter("reservation_no");
            if (resNo != null && !resNo.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM reservations WHERE reservation_no = ?"
                    );
                    ps.setString(1, resNo);
                    int rows = ps.executeUpdate();
                    ps.close();
                    con.close();

                    if (session != null) {
                        session.setAttribute(
                            rows > 0 ? "successMsg" : "errorMsg",
                            rows > 0
                                ? "Reservation " + resNo + " deleted successfully."
                                : "Reservation " + resNo + " not found."
                        );
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    if (session != null)
                        session.setAttribute("errorMsg", "Delete failed: " + e.getMessage());
                }
            }

        // ── EDIT / UPDATE ────────────────────────────────────────
        } else if ("edit".equals(action)) {
            String resNo    = request.getParameter("reservation_no");
            String guest    = request.getParameter("guest_name");
            String address  = request.getParameter("address");
            String contact  = request.getParameter("contact");
            String roomType = request.getParameter("room_type");
            String checkIn  = request.getParameter("checkin_date");
            String checkOut = request.getParameter("checkout_date");

            if (resNo != null && !resNo.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    PreparedStatement ps = con.prepareStatement(
                        "UPDATE reservations SET guest_name=?, address=?, contact=?, " +
                        "room_type=?, checkin_date=?, checkout_date=? " +
                        "WHERE reservation_no=?"
                    );
                    ps.setString(1, guest);
                    ps.setString(2, address);
                    ps.setString(3, contact);
                    ps.setString(4, roomType);
                    ps.setString(5, checkIn);
                    ps.setString(6, checkOut);
                    ps.setString(7, resNo);
                    int rows = ps.executeUpdate();
                    ps.close();
                    con.close();

                    if (session != null) {
                        session.setAttribute(
                            rows > 0 ? "successMsg" : "errorMsg",
                            rows > 0
                                ? "Reservation " + resNo + " updated successfully."
                                : "Update failed — reservation not found."
                        );
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    if (session != null)
                        session.setAttribute("errorMsg", "Update failed: " + e.getMessage());
                }
            }
        }

        // PRG — redirect prevents double-submit on refresh
        String redirect = "AdminViewReservation";
        if (!search.isEmpty()) redirect += "?search=" + search;
        response.sendRedirect(redirect);
    }

    private String safe(String s) {
        return s != null ? s : "";
    }
}
