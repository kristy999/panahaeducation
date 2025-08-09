package pahanaedu;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/transactionReport")
public class TransactionReportServlet extends HttpServlet {

    public static class Transaction {

        private int billId;
        private Date billDate;
        private double totalAmount;
        private int accountNumber;
        private int calculatedBy;
        private int itemId;
        private int quantity;
        private double itemPrice;
        private String customerName;  // new
        private String customerEmail; // new

        public Transaction(int billId, Date billDate, double totalAmount, int accountNumber,
                int calculatedBy, int itemId, int quantity, double itemPrice,
                String customerName, String customerEmail) {
            this.billId = billId;
            this.billDate = billDate;
            this.totalAmount = totalAmount;
            this.accountNumber = accountNumber;
            this.calculatedBy = calculatedBy;
            this.itemId = itemId;
            this.quantity = quantity;
            this.itemPrice = itemPrice;
            this.customerName = customerName;
            this.customerEmail = customerEmail;
        }

        // Getters
        public int getBillId() {
            return billId;
        }

        public Date getBillDate() {
            return billDate;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public int getAccountNumber() {
            return accountNumber;
        }

        public int getCalculatedBy() {
            return calculatedBy;
        }

        public int getItemId() {
            return itemId;
        }

        public int getQuantity() {
            return quantity;
        }

        public double getItemPrice() {
            return itemPrice;
        }

        public String getCustomerName() {
            return customerName;
        }

        public String getCustomerEmail() {
            return customerEmail;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Transaction> transactions = new ArrayList<>();

        String url = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String pass = "";

        String sql = "SELECT b.bill_id, b.bill_date, b.total_amount, b.account_number, b.calculated_by, "
                + "bi.item_id, bi.quantity, bi.item_price, "
                + "c.name AS customer_name, c.email AS customer_email "
                + "FROM bill b "
                + "LEFT JOIN bill_item bi ON b.bill_id = bi.bill_id "
                + "LEFT JOIN customer c ON b.calculated_by = c.user_id";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found", e);
        }

        try (Connection con = DriverManager.getConnection(url, user, pass); PreparedStatement pstmt = con.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                transactions.add(new Transaction(
                        rs.getInt("bill_id"),
                        rs.getDate("bill_date"),
                        rs.getDouble("total_amount"),
                        rs.getInt("account_number"),
                        rs.getInt("calculated_by"),
                        rs.getInt("item_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("item_price"),
                        rs.getString("customer_name"),
                        rs.getString("customer_email")
                ));
            }

            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/transactionReport.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
