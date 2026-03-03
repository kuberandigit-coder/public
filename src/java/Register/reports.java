package Register;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class reports extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/mydb",
                    "root",
                    "yourpassword");

            Statement stmt = con.createStatement();

            // 1️⃣ Total Reservations
            ResultSet rs1 = stmt.executeQuery(
                    "SELECT COUNT(*) FROM reservations");

            int totalReservations = 0;
            if (rs1.next()) {
                totalReservations = rs1.getInt(1);
            }

            // 2️⃣ Total Revenue
            ResultSet rs2 = stmt.executeQuery(
                    "SELECT IFNULL(SUM(total_amount),0) FROM reservations");

            double totalRevenue = 0;
            if (rs2.next()) {
                totalRevenue = rs2.getDouble(1);
            }

            // 3️⃣ Room Type Report
            ResultSet rs3 = stmt.executeQuery(
                    "SELECT room_type, COUNT(*) FROM reservations GROUP BY room_type");

            String roomTypeData = "[";
            while (rs3.next()) {
                roomTypeData += "{";
                roomTypeData += "\"room\":\"" + rs3.getString(1) + "\",";
                roomTypeData += "\"count\":" + rs3.getInt(2);
                roomTypeData += "},";
            }
            if (roomTypeData.endsWith(",")) {
                roomTypeData = roomTypeData.substring(0, roomTypeData.length() - 1);
            }
            roomTypeData += "]";

            // 4️⃣ Monthly Revenue (using checkin_date)
            ResultSet rs4 = stmt.executeQuery(
                    "SELECT MONTH(checkin_date), IFNULL(SUM(total_amount),0) " +
                    "FROM reservations GROUP BY MONTH(checkin_date) ORDER BY MONTH(checkin_date)");

            String monthlyData = "[";
            while (rs4.next()) {
                monthlyData += "{";
                monthlyData += "\"month\":" + rs4.getInt(1) + ",";
                monthlyData += "\"revenue\":" + rs4.getDouble(2);
                monthlyData += "},";
            }
            if (monthlyData.endsWith(",")) {
                monthlyData = monthlyData.substring(0, monthlyData.length() - 1);
            }
            monthlyData += "]";

            // Final JSON Output
            String json = "{";
            json += "\"totalReservations\":" + totalReservations + ",";
            json += "\"totalRevenue\":" + totalRevenue + ",";
            json += "\"roomTypeData\":" + roomTypeData + ",";
            json += "\"monthlyData\":" + monthlyData;
            json += "}";

            out.print(json);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
