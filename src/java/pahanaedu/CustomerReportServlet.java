package pahanaedu;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/customerReport.jsp")
public class CustomerReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");

            // Fetch all customers (assuming a users table with user_id and email)
            String sql = "SELECT user_id, email FROM users WHERE role = 'customer'";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            request.setAttribute("customers", rs);
            request.getRequestDispatcher("/customerReport.jsp").forward(request, response);

        } catch (ClassNotFoundException | SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (con != null && !con.isClosed()) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}