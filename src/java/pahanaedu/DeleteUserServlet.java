package pahanaedu;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pahanaedu.DBConnection;

public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Log servlet invocation
        System.out.println("DeleteUserServlet: Servlet invoked for POST /deleteUser");

        // Get userId from request parameter
        String userIdStr = request.getParameter("userId");
        String status = "success";
        String errorMessage = "";

        // Validate userId
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            status = "error";
            errorMessage = "Invalid user ID.";
            System.out.println("DeleteUserServlet: Invalid userId parameter");
        } else {
            Connection conn = null;
            PreparedStatement psCustomer = null;
            PreparedStatement psUser = null;

            try {
                // Get database connection
                conn = DBConnection.getConnection();
                System.out.println("DeleteUserServlet: Database connection established");

                // Delete from customer table
                String sqlCustomer = "DELETE FROM customer WHERE user_id = ?";
                psCustomer = conn.prepareStatement(sqlCustomer);
                psCustomer.setInt(1, Integer.parseInt(userIdStr));
                int customerRowsAffected = psCustomer.executeUpdate();
                System.out.println("DeleteUserServlet: Deleted " + customerRowsAffected + " rows from customer table for user_id=" + userIdStr);

                // Delete from user table
                String sqlUser = "DELETE FROM user WHERE user_id = ?";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setInt(1, Integer.parseInt(userIdStr));
                int userRowsAffected = psUser.executeUpdate();
                System.out.println("DeleteUserServlet: Deleted " + userRowsAffected + " rows from user table for user_id=" + userIdStr);

                if (userRowsAffected == 0) {
                    status = "error";
                    errorMessage = "No user found with ID " + userIdStr;
                }

            } catch (Exception e) {
                status = "error";
                errorMessage = e.getMessage();
                System.out.println("DeleteUserServlet: Error during deletion - " + errorMessage);
                e.printStackTrace();
            } finally {
                // Close resources
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

        // Redirect back to manageUsers.jsp with status
        System.out.println("DeleteUserServlet: Redirecting to manageUsers.jsp with status=" + status + ", errorMessage=" + errorMessage);
        response.sendRedirect("manageUsers.jsp?status=" + status + (errorMessage.isEmpty() ? "" : "&errorMessage=" + java.net.URLEncoder.encode(errorMessage, "UTF-8")));
    }
}