package Register;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ViewReservation", urlPatterns = {"/ViewReservation"})
public class ViewReservation extends HttpServlet {

    private final String URL      = "jdbc:mysql://localhost:3306/mydb";
    private final String USER     = "root";
    private final String PASSWORD = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        String searchType  = request.getParameter("searchType");   // "resNo" or "contact"
        String searchValue = request.getParameter("searchValue");

        // Nothing searched yet — just show the form
        if (searchValue == null || searchValue.trim().isEmpty()) {
            request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
            return;
        }

        searchValue = searchValue.trim();

        Connection con   = null;
        PreparedStatement stmt = null;
        ResultSet rs     = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);

            String query;
            if ("contact".equals(searchType)) {
                // Search by contact number — may return multiple reservations
                query = "SELECT * FROM reservations WHERE contact = ? ORDER BY checkin_date DESC";
            } else {
                // Default: search by reservation number — single result
                query = "SELECT * FROM reservations WHERE reservation_no = ?";
            }

            stmt = con.prepareStatement(query);
            stmt.setString(1, searchValue);
            rs = stmt.executeQuery();

            List<Reservation> results = new ArrayList<>();
            while (rs.next()) {
                results.add(new Reservation(
                    rs.getString("reservation_no"),
                    rs.getString("guest_name"),
                    rs.getString("address"),
                    rs.getString("contact"),
                    rs.getString("room_type"),
                    rs.getDate("checkin_date"),
                    rs.getDate("checkout_date")
                ));
            }

            if (results.isEmpty()) {
                if ("contact".equals(searchType)) {
                    request.setAttribute("error", "No reservations found for contact number: " + searchValue);
                } else {
                    request.setAttribute("error", "No reservation found for number: " + searchValue);
                }
            } else {
                request.setAttribute("results", results);
            }

            request.setAttribute("searchType",  searchType);
            request.setAttribute("searchValue", searchValue);
            request.getRequestDispatcher("viewReservation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (con  != null) con.close();  } catch (Exception ignored) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}
