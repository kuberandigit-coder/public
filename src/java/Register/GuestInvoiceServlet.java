package Register;

import java.io.IOException;
import java.sql.*;
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

    // ── GET — show form ───────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
    }

    // ── POST — lookup reservation ─────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String resNo = request.getParameter("reservationNo");
        if (resNo == null || resNo.trim().isEmpty()) {
            request.setAttribute("invoiceErr", "Please enter a reservation number.");
            request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
            return;
        }
        resNo = resNo.trim();

        String   guestName   = "";
        String   address     = "";
        String   contact     = "";
        String   roomType    = "";
        String   checkin     = "";
        String   checkout    = "";
        long     nights      = 0;
        double   roomRate    = 0;
        double   roomCharge  = 0;
        double   serviceAmt  = 0;
        double   taxAmt      = 0;
        double   total       = 0;
        boolean  found       = false;
        String   dbErr       = "";

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps = conn.prepareStatement(
                "SELECT guest_name, address, contact, room_type, checkin_date, checkout_date " +
                "FROM reservations WHERE reservation_no = ?");
            ps.setString(1, resNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                found     = true;
                guestName = rs.getString("guest_name");
                address   = rs.getString("address");
                contact   = rs.getString("contact");
                roomType  = rs.getString("room_type");
                checkin   = rs.getString("checkin_date");
                checkout  = rs.getString("checkout_date");

                // Nights calculation
                java.sql.Date ci = rs.getDate("checkin_date");
                java.sql.Date co = rs.getDate("checkout_date");
                nights = (co.getTime() - ci.getTime()) / (1000L * 60 * 60 * 24);
                if (nights < 1) nights = 1;

                // Rate lookup
                roomRate = 80;
                for (int i = 0; i < ROOM_TYPES.length; i++) {
                    if (ROOM_TYPES[i].equalsIgnoreCase(roomType)) {
                        roomRate = ROOM_RATES[i]; break;
                    }
                }
                roomCharge = nights * roomRate;
                serviceAmt = roomCharge * SERVICE_CHARGE;
                taxAmt     = roomCharge * TAX_RATE;
                total      = roomCharge + serviceAmt + taxAmt;
            }
            rs.close(); ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            dbErr = e.getMessage();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }

        if (!found && dbErr.isEmpty()) {
            request.setAttribute("invoiceErr", "No reservation found for number: " + resNo);
            request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
            return;
        }

        // Set all attributes for JSP
        request.setAttribute("resNo",       resNo);
        request.setAttribute("guestName",   guestName);
        request.setAttribute("address",     address);
        request.setAttribute("contact",     contact);
        request.setAttribute("roomType",    roomType);
        request.setAttribute("checkin",     checkin);
        request.setAttribute("checkout",    checkout);
        request.setAttribute("nights",      nights);
        request.setAttribute("roomRate",    String.format("%.2f", roomRate));
        request.setAttribute("roomCharge",  String.format("%.2f", roomCharge));
        request.setAttribute("serviceAmt",  String.format("%.2f", serviceAmt));
        request.setAttribute("taxAmt",      String.format("%.2f", taxAmt));
        request.setAttribute("total",       String.format("%.2f", total));
        request.setAttribute("showInvoice", true);
        if (!dbErr.isEmpty()) request.setAttribute("invoiceErr", "DB Error: " + dbErr);

        request.getRequestDispatcher("guestInvoice.jsp").forward(request, response);
    }
}
