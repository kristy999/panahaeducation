package pahanaedu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/help")
public class HelpServlet extends HttpServlet {

    public static class HelpEntry {
        private int id;
        private String question;
        private String answer;
        private String clue;

        public HelpEntry(int id, String question, String answer, String clue) {
            this.id = id;
            this.question = question;
            this.answer = answer;
            this.clue = clue;
        }

        // Getters (optional, Gson can access fields directly)
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");

        List<HelpEntry> results = new ArrayList<>();

        String url = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String pass = "";

        String sql = "SELECT id, question, answer, clue FROM help WHERE question LIKE ? OR clue LIKE ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found");
            return;
        }

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            String likeQuery = "%" + (query != null ? query : "") + "%";
            pstmt.setString(1, likeQuery);
            pstmt.setString(2, likeQuery);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    results.add(new HelpEntry(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getString("answer"),
                            rs.getString("clue")
                    ));
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(results));
        out.flush();
    }
}
