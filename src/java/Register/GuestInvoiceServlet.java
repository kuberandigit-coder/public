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

@WebServlet("/GuestInvoice")
public class GuestInvoiceServlet extends HttpServlet {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    private static final String[] ROOM_TYPES = {"Standard","Deluxe","Family","Ocean View","Suite"};
    private static final double[] ROOM_RATES = {80, 150, 180, 220, 250};
    private static final double   SERVICE_CHARGE = 0.10;
    private static final double   TAX_RATE       = 0.08;

    // ── GET — show empty form ─────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
    }

    // ── POST — lookup by resNo OR contact ────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String searchType  = request.getParameter("searchType");  // "resNo" or "contact"
        String searchValue = request.getParameter("searchValue");

        if (searchValue == null || searchValue.trim().isEmpty()) {
            request.setAttribute("invoiceErr", "Please enter a value to search.");
            request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
            return;
        }

        searchValue = searchValue.trim();
        request.setAttribute("searchType",  searchType);
        request.setAttribute("searchValue", searchValue);

        if ("contact".equals(searchType)) {
            // ── Search by contact — may return multiple ──
            handleContactSearch(request, response, searchValue);
        } else {
            // ── Search by reservation number — single result ──
            handleResNoSearch(request, response, searchValue);
        }
    }

    // ── Single reservation by resNo ───────────
    private void handleResNoSearch(HttpServletRequest request, HttpServletResponse response,
                                   String resNo) throws ServletException, IOException {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps = conn.prepareStatement(
                "SELECT reservation_no, guest_name, address, contact, room_type, checkin_date, checkout_date " +
                "FROM reservations WHERE reservation_no = ?");
            ps.setString(1, resNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InvoiceData inv = buildInvoiceData(rs);
                request.setAttribute("invoice",     inv);
                request.setAttribute("showInvoice", true);
                // also set flat attrs for PDF script
                setInvoiceAttributes(request, inv);
            } else {
                request.setAttribute("invoiceErr", "No reservation found for number: " + resNo);
            }
            rs.close(); ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("invoiceErr", "Database error: " + e.getMessage());
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
        request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
    }

    // ── Multiple reservations by contact ─────
    private void handleContactSearch(HttpServletRequest request, HttpServletResponse response,
                                     String contact) throws ServletException, IOException {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps = conn.prepareStatement(
                "SELECT reservation_no, guest_name, address, contact, room_type, checkin_date, checkout_date " +
                "FROM reservations WHERE contact = ? ORDER BY checkin_date DESC");
            ps.setString(1, contact);
            ResultSet rs = ps.executeQuery();

            List<InvoiceData> list = new ArrayList<>();
            while (rs.next()) {
                list.add(buildInvoiceData(rs));
            }
            rs.close(); ps.close();

            if (list.isEmpty()) {
                request.setAttribute("invoiceErr", "No reservations found for contact: " + contact);
            } else {
                request.setAttribute("invoiceList", list);
                request.setAttribute("showList",    true);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("invoiceErr", "Database error: " + e.getMessage());
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
        request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
    }

    // ── Build InvoiceData from ResultSet row ──
    private InvoiceData buildInvoiceData(ResultSet rs) throws SQLException {
        InvoiceData inv = new InvoiceData();
        inv.resNo     = rs.getString("reservation_no");
        inv.guestName = rs.getString("guest_name");
        inv.address   = rs.getString("address");
        inv.contact   = rs.getString("contact");
        inv.roomType  = rs.getString("room_type");
        inv.checkin   = rs.getString("checkin_date");
        inv.checkout  = rs.getString("checkout_date");

        java.sql.Date ci = rs.getDate("checkin_date");
        java.sql.Date co = rs.getDate("checkout_date");
        inv.nights = (co.getTime() - ci.getTime()) / (1000L * 60 * 60 * 24);
        if (inv.nights < 1) inv.nights = 1;

        inv.roomRate = 80;
        for (int i = 0; i < ROOM_TYPES.length; i++) {
            if (ROOM_TYPES[i].equalsIgnoreCase(inv.roomType)) {
                inv.roomRate = ROOM_RATES[i]; break;
            }
        }
        inv.roomCharge = inv.nights * inv.roomRate;
        inv.serviceAmt = inv.roomCharge * SERVICE_CHARGE;
        inv.taxAmt     = inv.roomCharge * TAX_RATE;
        inv.total      = inv.roomCharge + inv.serviceAmt + inv.taxAmt;
        return inv;
    }

    // ── Set flat request attributes for PDF JS ─
    private void setInvoiceAttributes(HttpServletRequest request, InvoiceData inv) {
        request.setAttribute("resNo",      inv.resNo);
        request.setAttribute("guestName",  inv.guestName);
        request.setAttribute("address",    inv.address);
        request.setAttribute("contact",    inv.contact);
        request.setAttribute("roomType",   inv.roomType);
        request.setAttribute("checkin",    inv.checkin);
        request.setAttribute("checkout",   inv.checkout);
        request.setAttribute("nights",     inv.nights);
        request.setAttribute("roomRate",   String.format("%.2f", inv.roomRate));
        request.setAttribute("roomCharge", String.format("%.2f", inv.roomCharge));
        request.setAttribute("serviceAmt", String.format("%.2f", inv.serviceAmt));
        request.setAttribute("taxAmt",     String.format("%.2f", inv.taxAmt));
        request.setAttribute("total",      String.format("%.2f", inv.total));
    }

    // ── Inner data class ──────────────────────
    public static class InvoiceData {
        public String resNo, guestName, address, contact, roomType, checkin, checkout;
        public long   nights;
        public double roomRate, roomCharge, serviceAmt, taxAmt, total;
    }
}
