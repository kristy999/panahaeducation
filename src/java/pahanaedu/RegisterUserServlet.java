package pahanaedu;

import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

//@WebServlet("/RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        int role = Integer.parseInt(request.getParameter("role"));

        try {
            // Hash the password
            String hashedPassword = hashPassword(password);

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("INSERT INTO user(username, password, role) VALUES (?, ?, ?)");
            ps.setString(1, username);
            ps.setString(2, hashedPassword); // store hashed password
            ps.setInt(3, role);

            ps.executeUpdate();
            conn.close();

            response.sendRedirect("manageUsers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error registering user.");
        }
    }

    // 🔐 Password hashing method
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(password.getBytes());

        // Convert byte array into hex string
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
