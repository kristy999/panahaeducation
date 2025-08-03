package pahanaedu;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletResponseWrapper;

import pahanaedu.util.MailUtil;

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
            request.setAttribute("error", "Cart is empty or not found in session.");
            RequestDispatcher rd = request.getRequestDispatcher("error.jsp"); // or back to cart page
            rd.forward(request, response);
            return;
        }
        if (userId == null) {
            request.setAttribute("error", "User not logged in or session expired.");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
            return;
        }

        // Calculate total with quantity
        double total = 0;
        for (Map<String, Object> item : cart) {
            try {
                double price = Double.parseDouble(item.get("item_price").toString());
                int quantity = Integer.parseInt(item.get("quantity").toString());
                total += price * quantity;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Error parsing item data: " + e.getMessage());
                RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
                rd.forward(request, response);
                return;
            }
        }

        Connection con = null;
        PreparedStatement billStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;
        int billId = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 8+ driver
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");

            // Insert into bill table
            billStmt = con.prepareStatement(
                    "INSERT INTO bill (bill_date, total_amount, account_number, calculated_by) VALUES (CURDATE(), ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            billStmt.setDouble(1, total);
            // TODO: Replace with dynamic account_number (e.g., from user table)
            billStmt.setInt(2, 2); 
            billStmt.setInt(3, userId);
            billStmt.executeUpdate();

            // Retrieve generated bill_id
            rs = billStmt.getGeneratedKeys();
            if (rs.next()) {
                billId = rs.getInt(1);
            } else {
                throw new SQLException("Failed to retrieve generated bill ID.");
            }

            // Insert each item into bill_item table
            itemStmt = con.prepareStatement(
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

            // Prepare email
            String to = (String) session.getAttribute("email");
            if (to == null || to.trim().isEmpty()) {
                throw new IllegalStateException("Email address not found in session.");
            }
            String subject = "Your Bill from Pahana Education";

            // Set attributes for email template
            request.setAttribute("cart", cart);
            request.setAttribute("total", total);
            request.setAttribute("billId", billId);
            request.setAttribute("billDate", LocalDate.now().toString());

            // Render email body using JSP
            RequestDispatcher rd = request.getRequestDispatcher("emailTemplate.jsp");
            StringWriter sw = new StringWriter();
            HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
                private final PrintWriter writer = new PrintWriter(sw);

                @Override
                public PrintWriter getWriter() {
                    return writer;
                }
            };
            rd.include(request, responseWrapper);
            String htmlBody = sw.toString();

            // Send email
            MailUtil.sendHtmlEmail(to, subject, htmlBody);

            // Save bill ID to session and clear cart
            session.setAttribute("bill_id", billId);
            session.removeAttribute("cart");
            response.sendRedirect("viewBill.jsp");

        } catch (ClassNotFoundException e) {
            request.setAttribute("error", "MySQL Driver not found: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
            rd.forward(request, response);
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (itemStmt != null) itemStmt.close();
                if (billStmt != null) billStmt.close();
                if (con != null && !con.isClosed()) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}