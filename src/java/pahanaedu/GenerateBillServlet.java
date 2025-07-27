package pahanaedu;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import java.util.*;

public class GenerateBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        Integer userId = (Integer) session.getAttribute("user_id");

        // Validate session data
        if (cart == null || cart.isEmpty()) {
            out.println("Error: Cart is empty or not found in session.");
            return;
        }
        if (userId == null) {
            out.println("Error: User not logged in or session expired.");
            return;
        }

        // Calculate total with quantity
        double total = 0;
        for (Map<String, Object> item : cart) {
            try {
                double price = Double.parseDouble(item.get("item_price").toString());
                int quantity = Integer.parseInt(item.get("quantity").toString());
                total += price * quantity;
            } catch (Exception e) {
                out.println("Error parsing item data: " + e.getMessage());
                return;
            }
        }

        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 8+ driver
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");

            // Insert into bill table
            PreparedStatement billStmt = con.prepareStatement(
                "INSERT INTO bill (bill_date, total_amount, account_number, calculated_by) VALUES (CURDATE(), ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            billStmt.setDouble(1, total);
            billStmt.setInt(2, 2); // TODO: Replace with actual account_number if dynamic
            billStmt.setInt(3, userId);
            billStmt.executeUpdate();

            // Retrieve generated bill_id
            ResultSet rs = billStmt.getGeneratedKeys();
            int billId = 0;
            if (rs.next()) {
                billId = rs.getInt(1);
            } else {
                out.println("Failed to retrieve generated bill ID.");
                return;
            }

            // Insert each item with quantity and unit price into bill_item table
            // (Assuming your bill_item table has columns: bill_id, item_id, quantity, item_price)
            PreparedStatement itemStmt = con.prepareStatement(
                "INSERT INTO bill_item (bill_id, item_id, quantity, item_price) VALUES (?, ?, ?, ?)"
            );

            for (Map<String, Object> item : cart) {
                int itemId = Integer.parseInt(item.get("item_id").toString());
                int quantity = Integer.parseInt(item.get("quantity").toString());
                double price = Double.parseDouble(item.get("item_price").toString());

                itemStmt.setInt(1, billId);
                itemStmt.setInt(2, itemId);
                itemStmt.setInt(3, quantity);
                itemStmt.setDouble(4, price);
                itemStmt.executeUpdate();
            }

            // Cleanup
            con.close();

            // Save bill ID to session for viewBill.jsp
            session.setAttribute("bill_id", billId);
            session.removeAttribute("cart"); // clear cart after billing
            response.sendRedirect("viewBill.jsp");

        } catch (ClassNotFoundException e) {
            out.println("MySQL Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            out.println("Database error: " + e.getMessage());
        } catch (Exception e) {
            out.println("Unexpected error: " + e.getMessage());
        } finally {
            try {
                if (con != null && !con.isClosed()) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
