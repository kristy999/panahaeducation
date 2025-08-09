package pahanaedu;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");      // e.g. "csv" or "pdf"
        String report = request.getParameter("report");  // e.g. "transaction" or "customer"

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found");
            return;
        }

        if ("csv".equalsIgnoreCase(type)) {
            if ("transaction".equalsIgnoreCase(report)) {
                exportTransactionCsv(response);
            } else if ("customer".equalsIgnoreCase(report)) {
                exportCustomerCsv(response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type");
            }
        } else if ("pdf".equalsIgnoreCase(type)) {
            // PDF export placeholder (add later)
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + report + ".pdf\"");
            response.getWriter().write("PDF export not implemented yet.");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid export type");
        }
    }

    private void exportTransactionCsv(HttpServletResponse response) throws IOException {
        String sql = "SELECT b.bill_id, b.bill_date, b.total_amount, b.account_number, b.calculated_by, " +
                     "bi.item_id, bi.quantity, bi.item_price " +
                     "FROM bill b LEFT JOIN bill_item bi ON b.bill_id = bi.bill_id";

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

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

        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error exporting transactions: " + e.getMessage());
        }
    }

    private void exportCustomerCsv(HttpServletResponse response) throws IOException {
        String sql = "SELECT account_number, name, email, address, telephone FROM customer";

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"customers.csv\"");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC", "root", "");
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            StringBuilder csv = new StringBuilder("Account Number,Name,Email,Address,Telephone\n");

            while (rs.next()) {
                csv.append(rs.getInt("account_number")).append(",")
                   .append("\"").append(rs.getString("name")).append("\",")
                   .append("\"").append(rs.getString("email")).append("\",")
                   .append("\"").append(rs.getString("address")).append("\",")
                   .append("\"").append(rs.getString("telephone")).append("\"\n");
            }
            response.getWriter().write(csv.toString());

        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error exporting customers: " + e.getMessage());
        }
    }
}
