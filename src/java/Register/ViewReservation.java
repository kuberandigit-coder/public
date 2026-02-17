package Register;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewReservation", urlPatterns = {"/ViewReservation"})
public class ViewReservation extends HttpServlet {

    // Database connection details
    private final String URL = "jdbc:mysql://localhost:3306/mydb"; // Database URL
    private final String USER = "root"; // Database username
    private final String PASSWORD = ""; // Database password

    /**
     * Processes requests for both HTTP GET and POST methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Get the reservation number from the request
        String reservationNumber = request.getParameter("reservationNumber");

        if (reservationNumber != null && !reservationNumber.isEmpty()) {
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try (PrintWriter out = response.getWriter()) {
                // Step 1: Establish a database connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(URL, USER, PASSWORD);

                // Step 2: Query the reservation based on the reservation number
                String query = "SELECT * FROM reservations WHERE reservation_no = ?";
                stmt = con.prepareStatement(query);
                stmt.setString(1, reservationNumber);
                rs = stmt.executeQuery();

                // Step 3: If a reservation is found, set the data to request attributes
                if (rs.next()) {
                    // Create a Reservation object to hold the data
                    Reservation reservation = new Reservation(
                        rs.getString("reservation_no"),   // Column name for reservation number
                        rs.getString("guest_name"),       // Column name for guest name
                        rs.getString("address"),          // Column name for address
                        rs.getString("contact"),          // Column name for contact number
                        rs.getString("room_type"),        // Column name for room type
                        rs.getDate("checkin_date"),       // Column name for check-in date
                        rs.getDate("checkout_date")       // Column name for check-out date
                    );

                    // Set the reservation object as a request attribute
                    request.setAttribute("reservation", reservation);
                    request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
                } else {
                    // If no reservation found, set error message
                    request.setAttribute("error", "No reservation found for the entered number.");
                    request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
                }
            } catch (Exception e) {
                // Handle exceptions
                e.printStackTrace();
                request.setAttribute("error", "Error fetching reservation details: " + e.getMessage());
                request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
            } finally {
                try {
                    // Close resources
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else {
            // If reservation number is not provided, set an error
            request.setAttribute("error", "Please enter a valid reservation number.");
            request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ViewReservation Servlet";
    }
}
