package pahanaedu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/adminDashboardData")
public class AdminDashboardServlet extends HttpServlet {

    private final String DB_URL = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL Driver not found", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, Object> dashboardData = new HashMap<>();

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            // 1. User Count
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS user_count FROM user")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dashboardData.put("userCount", rs.getInt("user_count"));
                    }
                }
            }

            // 2. Item Count
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS item_count FROM item")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dashboardData.put("itemCount", rs.getInt("item_count"));
                    }
                }
            }

            // 3. Transaction Counts by Day (Last 7 days)
            String transactionQuery = 
                "SELECT bill_date, COUNT(*) AS txn_count, SUM(total_amount) AS total_amount " +
                "FROM bill " +
                "WHERE bill_date >= CURDATE() - INTERVAL 6 DAY " +
                "GROUP BY bill_date " +
                "ORDER BY bill_date ASC";

            List<Map<String, Object>> transactions = new ArrayList<>();

            try (PreparedStatement ps = con.prepareStatement(transactionQuery)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> txn = new HashMap<>();
                        txn.put("date", rs.getDate("bill_date").toString());
                        txn.put("count", rs.getInt("txn_count"));
                        txn.put("totalAmount", rs.getDouble("total_amount"));
                        transactions.add(txn);
                    }
                }
            }

            dashboardData.put("transactions", transactions);

            // 4. User Role Counts
            String roleQuery = 
                "SELECT role, COUNT(*) as count FROM user GROUP BY role";

            Map<Integer, Integer> userRoles = new HashMap<>();

            try (PreparedStatement ps = con.prepareStatement(roleQuery)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        userRoles.put(rs.getInt("role"), rs.getInt("count"));
                    }
                }
            }

            dashboardData.put("userRoles", userRoles);

            // Convert map to JSON and write response
            String json = new Gson().toJson(dashboardData);
            resp.getWriter().write(json);

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
