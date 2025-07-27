/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pahanaedu;


import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

import java.util.*;

public class GenerateBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        int userId = (Integer) session.getAttribute("user_id"); // make sure this is set at login

        double total = 0;
        for (Map<String, Object> item : cart) {
            total += (Double) item.get("item_price");
        }

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education", "root", "");

            PreparedStatement billStmt = con.prepareStatement(
                    "INSERT INTO bill (bill_date, total_amount, account_number, calculated_by) VALUES (CURDATE(), ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            billStmt.setDouble(1, total);
            billStmt.setInt(2, 2); // assuming customer account_number is 2, adjust dynamically later
            billStmt.setInt(3, userId);
            billStmt.executeUpdate();

            ResultSet rs = billStmt.getGeneratedKeys();
            int billId = 0;
            if (rs.next()) {
                billId = rs.getInt(1);
            }

            PreparedStatement itemStmt = con.prepareStatement(
                    "INSERT INTO bill_item (bill_id, item_id) VALUES (?, ?)"
            );
            for (Map<String, Object> item : cart) {
                itemStmt.setInt(1, billId);
                itemStmt.setInt(2, (Integer) item.get("item_id"));
                itemStmt.executeUpdate();
            }

            con.close();
            session.setAttribute("bill_id", billId);
            session.removeAttribute("cart");
            response.sendRedirect("viewBill.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}
