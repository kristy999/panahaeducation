package pahanaedu;

import java.io.IOException;
import java.sql.Connection;
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

@WebServlet("/customerReport")
public class CustomerReportServlet extends HttpServlet {

    // DTO class to hold customer info
    public static class Customer {
        private int accountNumber;
        private String name;
        private String email;
        private String address;
        private String telephone;

        public Customer(int accountNumber, String name, String email, String address, String telephone) {
            this.accountNumber = accountNumber;
            this.name = name;
            this.email = email;
            this.address = address;
            this.telephone = telephone;
        }

        public int getAccountNumber() { return accountNumber; }
        public String getName() { return name; }
        public String getEmail() { return email; }
        public String getAddress() { return address; }
        public String getTelephone() { return telephone; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure driver available (optional but explicit)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new ServletException("MySQL JDBC Driver not found", ex);
        }

        response.setContentType("text/html;charset=UTF-8");
        List<Customer> customers = new ArrayList<>();

        String url = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "";

        String sql = "SELECT account_number, name, email, address, telephone FROM customer";

        try (Connection con = DriverManager.getConnection(url, dbUser, dbPass);
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("account_number"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("telephone")
                ));
            }

            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/customerReport.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
