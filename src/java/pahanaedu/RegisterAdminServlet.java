/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pahanaedu;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class RegisterAdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO user (username, password, role) VALUES (?, ?, 1)");
            stmt.setString(1, username);
            stmt.setString(2, password);

            int rows = stmt.executeUpdate();
            conn.close();

            if (rows > 0) {
                response.sendRedirect("registerAdmin.jsp?status=success");
            } else {
                response.sendRedirect("registerAdmin.jsp?status=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registerAdmin.jsp?status=error");
        }
    }
}
