package pahanaedu;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        String hashedPassword = hashPassword(password);

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // start transaction

            // Insert into user table
            String userSQL = "INSERT INTO user (email, password, role) VALUES (?, ?, ?)";
            try (PreparedStatement userStmt = conn.prepareStatement(userSQL, Statement.RETURN_GENERATED_KEYS)) {
                userStmt.setString(1, email);
                userStmt.setString(2, hashedPassword);
                userStmt.setInt(3, 2); // 2 = customer role
                userStmt.executeUpdate();

                ResultSet generatedKeys = userStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);

                    // Insert into customer table
                    String customerSQL = "INSERT INTO customer (name, email, address, telephone, user_id) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement custStmt = conn.prepareStatement(customerSQL)) {
                        custStmt.setString(1, name);
                        custStmt.setString(2, email);      // NEW: set email for customer
                        custStmt.setString(3, address);
                        custStmt.setString(4, phone);
                        custStmt.setInt(5, userId);
                        custStmt.executeUpdate();
                    }

                    conn.commit();
                    response.sendRedirect("registerCustomer.jsp?status=success");
                    return;
                } else {
                    conn.rollback();
                    response.sendRedirect("registerCustomer.jsp?status=error");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registerCustomer.jsp?status=error");
        }
    }

    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
