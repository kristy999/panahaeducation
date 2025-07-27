package pahanaedu;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pahanaedu.DBConnection;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class EditUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Log servlet invocation
        System.out.println("EditUserServlet: Servlet invoked for POST /editUser");

        // Get form parameters
        String userIdStr = request.getParameter("userId");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");
        String name = request.getParameter("name");
        String custEmail = request.getParameter("custEmail");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String status = "success";
        String errorMessage = "";

        // Validate inputs
        if (userIdStr == null || userIdStr.trim().isEmpty() || email == null || email.trim().isEmpty() || roleStr == null || roleStr.trim().isEmpty()) {
            status = "error";
            errorMessage = "User ID, email, and role are required.";
            System.out.println("EditUserServlet: Invalid input parameters");
        } else {
            Connection conn = null;
            PreparedStatement psUser = null;
            PreparedStatement psCustomer = null;
            PreparedStatement psCheckCustomer = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();
                System.out.println("EditUserServlet: Database connection established");

                // Update user table
                String sqlUser;
                if (password != null && !password.trim().isEmpty()) {
                    // Update password if provided
                    sqlUser = "UPDATE user SET email = ?, password = ?, role = ? WHERE user_id = ?";
                    psUser = conn.prepareStatement(sqlUser);
                    psUser.setString(1, email);
                    psUser.setString(2, hashPassword(password));
                    psUser.setInt(3, Integer.parseInt(roleStr));
                    psUser.setInt(4, Integer.parseInt(userIdStr));
                } else {
                    // Skip password update
                    sqlUser = "UPDATE user SET email = ?, role = ? WHERE user_id = ?";
                    psUser = conn.prepareStatement(sqlUser);
                    psUser.setString(1, email);
                    psUser.setInt(2, Integer.parseInt(roleStr));
                    psUser.setInt(3, Integer.parseInt(userIdStr));
                }
                int userRowsAffected = psUser.executeUpdate();
                System.out.println("EditUserServlet: Updated " + userRowsAffected + " rows in user table for user_id=" + userIdStr);

                if (userRowsAffected == 0) {
                    status = "error";
                    errorMessage = "No user found with ID " + userIdStr;
                } else {
                    // Check if customer record exists
                    String sqlCheckCustomer = "SELECT COUNT(*) FROM customer WHERE user_id = ?";
                    psCheckCustomer = conn.prepareStatement(sqlCheckCustomer);
                    psCheckCustomer.setInt(1, Integer.parseInt(userIdStr));
                    rs = psCheckCustomer.executeQuery();
                    rs.next();
                    boolean customerExists = rs.getInt(1) > 0;

                    // Update or insert customer record
                    if (customerExists) {
                        // Update existing customer
                        String sqlCustomer = "UPDATE customer SET name = ?, email = ?, address = ?, telephone = ? WHERE user_id = ?";
                        psCustomer = conn.prepareStatement(sqlCustomer);
                        psCustomer.setString(1, name != null ? name : "");
                        psCustomer.setString(2, custEmail != null ? custEmail : "");
                        psCustomer.setString(3, address != null ? address : "");
                        psCustomer.setString(4, telephone != null ? telephone : "");
                        psCustomer.setInt(5, Integer.parseInt(userIdStr));
                        int customerRowsAffected = psCustomer.executeUpdate();
                        System.out.println("EditUserServlet: Updated " + customerRowsAffected + " rows in customer table for user_id=" + userIdStr);
                    } else if (name != null && !name.trim().isEmpty()) {
                        // Insert new customer record if name is provided
                        String sqlCustomer = "INSERT INTO customer (name, email, address, telephone, user_id) VALUES (?, ?, ?, ?, ?)";
                        psCustomer = conn.prepareStatement(sqlCustomer);
                        psCustomer.setString(1, name);
                        psCustomer.setString(2, custEmail != null ? custEmail : "");
                        psCustomer.setString(3, address != null ? address : "");
                        psCustomer.setString(4, telephone != null ? telephone : "");
                        psCustomer.setInt(5, Integer.parseInt(userIdStr));
                        int customerRowsAffected = psCustomer.executeUpdate();
                        System.out.println("EditUserServlet: Inserted " + customerRowsAffected + " rows in customer table for user_id=" + userIdStr);
                    }
                }

            } catch (Exception e) {
                status = "error";
                errorMessage = e.getMessage();
                System.out.println("EditUserServlet: Error during update - " + errorMessage);
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                } catch (Exception ignored) {
                }
                try {
                    if (psCheckCustomer != null) {
                        psCheckCustomer.close();
                    }
                } catch (Exception ignored) {
                }
                try {
                    if (psCustomer != null) {
                        psCustomer.close();
                    }
                } catch (Exception ignored) {
                }
                try {
                    if (psUser != null) {
                        psUser.close();
                    }
                } catch (Exception ignored) {
                }
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (Exception ignored) {
                }
            }
        }

        // Redirect back to manageUsers.jsp with status and action
        System.out.println("EditUserServlet: Redirecting to manageUsers.jsp with status=" + status + ", errorMessage=" + errorMessage);
        response.sendRedirect("manageUsers.jsp?status=" + status + "&action=edit" + (errorMessage.isEmpty() ? "" : "&errorMessage=" + java.net.URLEncoder.encode(errorMessage, "UTF-8")));
    }

    // Hash password using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}
