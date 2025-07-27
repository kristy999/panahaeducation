package pahanaedu;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;


public class UpdateUserCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters from the request
        int userId = Integer.parseInt(request.getParameter("user_id"));
        int accountNumber = 0;
        String accNumStr = request.getParameter("account_number");
        if (accNumStr != null && !accNumStr.trim().isEmpty()) {
            accountNumber = Integer.parseInt(accNumStr);
        }

        String username = request.getParameter("username");
        int role = Integer.parseInt(request.getParameter("role"));

        String custName = request.getParameter("cust_name");
        String custEmail = request.getParameter("cust_email");
        String custAddress = request.getParameter("cust_address");
        String custTel = request.getParameter("cust_tel");

        Connection conn = null;
        try {
            // Get DB connection
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update user table
            String updateUserSQL = "UPDATE user SET username = ?, role = ? WHERE user_id = ?";
            try (PreparedStatement psUser = conn.prepareStatement(updateUserSQL)) {
                psUser.setString(1, username);
                psUser.setInt(2, role);
                psUser.setInt(3, userId);
                psUser.executeUpdate();
            }

            // 2. If customer exists (accountNumber > 0), update customer record
            if (accountNumber > 0) {
                String updateCustomerSQL = "UPDATE customer SET name = ?, email = ?, address = ?, telephone = ? WHERE account_number = ?";
                try (PreparedStatement psCust = conn.prepareStatement(updateCustomerSQL)) {
                    psCust.setString(1, custName);
                    psCust.setString(2, custEmail);
                    psCust.setString(3, custAddress);
                    psCust.setString(4, custTel);
                    psCust.setInt(5, accountNumber);
                    psCust.executeUpdate();
                }
            } else {
                // 3. If no customer exists, insert a new customer linked to the user
                if (custName != null && !custName.trim().isEmpty()) {
                    String insertCustomerSQL = "INSERT INTO customer (name, email, address, telephone, user_id) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement psCustInsert = conn.prepareStatement(insertCustomerSQL)) {
                        psCustInsert.setString(1, custName);
                        psCustInsert.setString(2, custEmail);
                        psCustInsert.setString(3, custAddress);
                        psCustInsert.setString(4, custTel);
                        psCustInsert.setInt(5, userId);
                        psCustInsert.executeUpdate();
                    }
                }
            }

            conn.commit();  // Commit transaction

            // Redirect back with success message
            response.sendRedirect("manageUsers.jsp?update=success");

        } catch (Exception e) {
            // Rollback transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            e.printStackTrace();
            // Redirect back with error message
            response.sendRedirect("manageUsers.jsp?update=error");
        } finally {
            // Close connection
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }
}
