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
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        int units = 0;
        try {
            units = Integer.parseInt(request.getParameter("units"));
        } catch (NumberFormatException e) {
            response.sendRedirect("registerCustomer.jsp?status=error");
            return;
        }
        
        // Hash the password before saving
        String hashedPassword = hashPassword(password);
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);  // Begin transaction
            
            // Insert into user table
            String userSQL = "INSERT INTO user (username, password, role) VALUES (?, ?, ?)";
            try (PreparedStatement userStmt = conn.prepareStatement(userSQL, Statement.RETURN_GENERATED_KEYS)) {
                userStmt.setString(1, username);
                userStmt.setString(2, hashedPassword);
                userStmt.setInt(3, 2);  // role = 2 for customers
                userStmt.executeUpdate();
                
                ResultSet rs = userStmt.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    
                    // Insert into customer table using generated user_id
                    String customerSQL = "INSERT INTO customer (name, address, telephone, units_consumed, user_id) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement custStmt = conn.prepareStatement(customerSQL)) {
                        custStmt.setString(1, name);
                        custStmt.setString(2, address);
                        custStmt.setString(3, phone);
                        custStmt.setInt(4, units);
                        custStmt.setInt(5, userId);
                        custStmt.executeUpdate();
                    }
                    
                    conn.commit();  // Commit transaction
                    response.sendRedirect("registerCustomer.jsp?status=success");
                    return;
                } else {
                    conn.rollback();
                    response.sendRedirect("registerCustomer.jsp?status=error");
                    return;
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
