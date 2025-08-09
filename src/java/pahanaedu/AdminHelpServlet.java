package pahanaedu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminHelp")
public class AdminHelpServlet extends HttpServlet {

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

        public int getId() { return id; }
        public String getQuestion() { return question; }
        public String getAnswer() { return answer; }
        public String getClue() { return clue; }
    }

    private final String url = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
    private final String user = "root";
    private final String pass = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<HelpEntry> helpEntries = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = con.prepareStatement("SELECT id, question, answer, clue FROM help");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    helpEntries.add(new HelpEntry(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getString("answer"),
                            rs.getString("clue")
                    ));
                }
            }
        } catch (Exception e) {
            throw new ServletException("Database error", e);
        }

        request.setAttribute("helpEntries", helpEntries);
        request.getRequestDispatcher("/adminHelp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action == null || idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action or ID");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, user, pass)) {

                if ("update".equals(action)) {
                    // Update operation
                    String question = request.getParameter("question");
                    String answer = request.getParameter("answer");
                    String clue = request.getParameter("clue");

                    if (question == null || answer == null) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters for update.");
                        return;
                    }

                    String sqlUpdate = "UPDATE help SET question = ?, answer = ?, clue = ? WHERE id = ?";
                    try (PreparedStatement stmt = con.prepareStatement(sqlUpdate)) {
                        stmt.setString(1, question);
                        stmt.setString(2, answer);
                        stmt.setString(3, clue);
                        stmt.setInt(4, id);

                        int updated = stmt.executeUpdate();
                        if (updated == 0) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Help entry not found.");
                            return;
                        }
                    }
                    // Redirect with success status for update
                    response.sendRedirect("adminHelp?status=success&action=edit");
                }
                else if ("delete".equals(action)) {
                    // Delete operation
                    String sqlDelete = "DELETE FROM help WHERE id = ?";
                    try (PreparedStatement stmt = con.prepareStatement(sqlDelete)) {
                        stmt.setInt(1, id);

                        int deleted = stmt.executeUpdate();
                        if (deleted == 0) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Help entry not found.");
                            return;
                        }
                    }
                    // Redirect with success status for delete
                    response.sendRedirect("adminHelp?status=success&action=delete");
                }
                else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
                }

            }
        } catch (Exception e) {
            throw new ServletException("Database error during " + action, e);
        }
    }
}
