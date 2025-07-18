package pahanaedu;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

//@WebServlet("/AddItemServlet")
public class AddItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemName = request.getParameter("item_name");
        double itemPrice = 0;

        try {
            itemPrice = Double.parseDouble(request.getParameter("item_price"));
        } catch (NumberFormatException e) {
            response.sendRedirect("addItem.jsp?status=error");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO item (item_name, item_price) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, itemName);
                stmt.setDouble(2, itemPrice);
                stmt.executeUpdate();
                response.sendRedirect("addItem.jsp?status=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addItem.jsp?status=error");
        }
    }
}
