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

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");

            String sql = "SELECT b.bill_id, b.bill_date, b.total_amount, b.account_number, b.calculated_by, " +
                         "bi.item_id, bi.quantity, bi.item_price " +
                         "FROM bill b LEFT JOIN bill_item bi ON b.bill_id = bi.bill_id";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if ("csv".equals(type)) {
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");
                StringBuilder csv = new StringBuilder("Bill ID,Date,Total Amount,Account Number,Calculated By,Item ID,Quantity,Item Price\n");
                while (rs.next()) {
                    csv.append(rs.getInt("bill_id")).append(",")
                       .append(rs.getDate("bill_date")).append(",")
                       .append(rs.getDouble("total_amount")).append(",")
                       .append(rs.getInt("account_number")).append(",")
                       .append(rs.getInt("calculated_by")).append(",")
                       .append(rs.getInt("item_id")).append(",")
                       .append(rs.getInt("quantity")).append(",")
                       .append(rs.getDouble("item_price")).append("\n");
                }
                response.getWriter().write(csv.toString());
            } else if ("pdf".equals(type)) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"transactions.pdf\"");
                // Placeholder for PDF generation (requires a library like iText)
                response.getWriter().write("PDF export not implemented yet. Please use a library like iText.");
            }

        } catch (ClassNotFoundException | SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating export: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (con != null && !con.isClosed()) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}