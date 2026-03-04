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

@WebServlet("/AdminViewReservation")
public class AdminViewReservation extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    // ── GET ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // ── DELETE ───────────────────────────────────────────
        if ("delete".equals(action)) {
            String reservationNo = request.getParameter("reservation_no");
            String search        = request.getParameter("search");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM reservations WHERE reservation_no = ?");
                ps.setString(1, reservationNo);
                int rows = ps.executeUpdate();
                ps.close();
                conn.close();

                if (rows > 0) {
                    session.setAttribute("flashOk", "Reservation '" + reservationNo + "' deleted successfully.");
                } else {
                    session.setAttribute("flashErr", "Reservation not found.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashErr", "Delete failed: " + e.getMessage());
            }

            String redirect = "AdminViewReservation";
            if (search != null && !search.isEmpty()) redirect += "?search=" + search;
            response.sendRedirect(redirect);
            return;
        }

        // ── LOAD PAGE ────────────────────────────────────────
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
        String reservationNo = request.getParameter("reservationNo");
        String guestName     = request.getParameter("guestName");
        String address       = request.getParameter("address");
        String contact       = request.getParameter("contact");
        String roomType      = request.getParameter("roomType");
        String checkin       = request.getParameter("checkin");
        String checkout      = request.getParameter("checkout");
        String search        = request.getParameter("search");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Duplicate check
            PreparedStatement chk = conn.prepareStatement(
                "SELECT COUNT(*) FROM reservations WHERE reservation_no = ?");
            chk.setString(1, reservationNo);
            ResultSet rs = chk.executeQuery();
            rs.next();
            int exists = rs.getInt(1);
            rs.close(); chk.close();

            if (exists > 0) {
                session.setAttribute("flashErr", "Reservation No '" + reservationNo + "' already exists.");
                conn.close();
                response.sendRedirect("AdminViewReservation" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
                return;
            }

            // Insert
            String sql = "INSERT INTO reservations (reservation_no, guest_name, address, contact, room_type, checkin_date, checkout_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, reservationNo);
            ps.setString(2, guestName);
            ps.setString(3, address);
            ps.setString(4, contact);
            ps.setString(5, roomType);
            ps.setString(6, checkin);
            ps.setString(7, checkout);
            int rowsInserted = ps.executeUpdate();
            ps.close(); conn.close();

            if (rowsInserted > 0) {
                session.setAttribute("flashOk", "Reservation '" + reservationNo + "' added successfully.");
            } else {
                session.setAttribute("flashErr", "Failed to add reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }

        response.sendRedirect("AdminViewReservation" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
    }

    // ── EDIT ──────────────────────────────────────────────────
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String reservationNo = request.getParameter("reservationNo");
        String guestName     = request.getParameter("guestName");
        String address       = request.getParameter("address");
        String contact       = request.getParameter("contact");
        String roomType      = request.getParameter("roomType");
        String checkin       = request.getParameter("checkin");
        String checkout      = request.getParameter("checkout");
        String search        = request.getParameter("search");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "UPDATE reservations SET guest_name=?, address=?, contact=?, room_type=?, checkin_date=?, checkout_date=? WHERE reservation_no=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, guestName);
            ps.setString(2, address);
            ps.setString(3, contact);
            ps.setString(4, roomType);
            ps.setString(5, checkin);
            ps.setString(6, checkout);
            ps.setString(7, reservationNo);
            int rowsUpdated = ps.executeUpdate();
            ps.close(); conn.close();

            if (rowsUpdated > 0) {
                session.setAttribute("flashOk", "Reservation '" + reservationNo + "' updated successfully.");
            } else {
                session.setAttribute("flashErr", "Failed to update reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashErr", "Database Error: " + e.getMessage());
        }

        response.sendRedirect("AdminViewReservation" + (search != null && !search.isEmpty() ? "?search=" + search : ""));
    }

    // ── LOAD PAGE ─────────────────────────────────────────────
    private void loadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String search = request.getParameter("search");
        List<String[]> reservations = new ArrayList<>();
        int totalCount = 0;
        String dbErr = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Total count
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM reservations");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) totalCount = rs1.getInt(1);
            rs1.close(); ps1.close();

            // Fetch list — all or filtered
            PreparedStatement ps2;
            if (search != null && !search.trim().isEmpty()) {
                ps2 = conn.prepareStatement(
                    "SELECT * FROM reservations WHERE reservation_no LIKE ? OR guest_name LIKE ? OR contact LIKE ? ORDER BY checkin_date DESC");
                String k = "%" + search.trim() + "%";
                ps2.setString(1, k);
                ps2.setString(2, k);
                ps2.setString(3, k);
            } else {
                ps2 = conn.prepareStatement(
                    "SELECT * FROM reservations ORDER BY checkin_date DESC");
            }

            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                reservations.add(new String[]{
                    rs2.getString("reservation_no"),   // [0]
                    rs2.getString("guest_name"),        // [1]
                    rs2.getString("address"),           // [2]
                    rs2.getString("contact"),           // [3]
                    rs2.getString("room_type"),         // [4]
                    String.valueOf(rs2.getDate("checkin_date")),   // [5]
                    String.valueOf(rs2.getDate("checkout_date"))   // [6]
                });
            }
            rs2.close(); ps2.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            dbErr = e.getMessage();
        }

        // Flash messages from session
        request.setAttribute("flashOk",  session.getAttribute("flashOk"));
        request.setAttribute("flashErr", dbErr.isEmpty()
            ? session.getAttribute("flashErr")
            : "Database Error: " + dbErr);
        session.removeAttribute("flashOk");
        session.removeAttribute("flashErr");

        // Pass data to JSP
        request.setAttribute("reservations", reservations);
        request.setAttribute("totalCount",   totalCount);
        request.setAttribute("search",       search != null ? search : "");
        request.setAttribute("adminName",    session.getAttribute("admin"));

        request.getRequestDispatcher("adminViewReservation.jsp").forward(request, response);
    }
}
