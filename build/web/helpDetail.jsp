<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the help entry ID from the request parameter
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        out.println("<h3>Error: No help entry ID provided.</h3>");
        return;
    }

    int helpId = 0;
    try {
        helpId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        out.println("<h3>Error: Invalid help entry ID.</h3>");
        return;
    }

    // DB connection details
    String url = "jdbc:mysql://localhost:3306/pahana_education?useSSL=false&serverTimezone=UTC";
    String user = "root";
    String pass = "";

    String question = null;
    String answer = null;
    String clue = null;
    String description = null; // Optional extended help description column

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(url, user, pass); PreparedStatement pstmt = con.prepareStatement("SELECT question, answer, clue, description FROM help WHERE id = ?")) {

            pstmt.setInt(1, helpId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    question = rs.getString("question");
                    answer = rs.getString("answer");
                    clue = rs.getString("clue");
                    description = rs.getString("description"); // can be null if you don't have this column
                } else {
                    out.println("<h3>Error: Help entry not found.</h3>");
                    return;
                }
            }
        }
    } catch (Exception e) {
        out.println("<h3>Database error: " + escapeHtml(e.getMessage()) + "</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Help Detail - <%= escapeHtml(question)%></title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h2 {
                color: #2c3e50;
            }
            .clue {
                font-style: italic;
                color: #555;
                margin-top: 5px;
            }
            .description {
                margin-top: 15px;
                white-space: pre-wrap;
                background: #f9f9f9;
                padding: 10px;
                border-radius: 5px;
            }
            a.back-link {
                display: inline-block;
                margin-top: 20px;
                text-decoration: none;
                color: #3498db;
            }
            a.back-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <h2><%= escapeHtml(question)%></h2>
        <p><strong>Answer:</strong></p>
        <p><%= escapeHtml(answer)%></p>

        <% if (clue != null && !clue.trim().isEmpty()) {%>
        <p class="clue">Clue: <%= escapeHtml(clue)%></p>
        <% } %>

        <% if (description != null && !description.trim().isEmpty()) {%>
        <div class="description">
            <strong>More details:</strong><br/>
            <%= escapeHtml(description)%>
        </div>
        <% }%>

        <a href="help.jsp" class="back-link" target="_self">← Back to Help</a>

        <%!
            // Method declaration: Use JSP declaration tag to allow method outside _jspService()
            public String escapeHtml(String s) {
                if (s == null) {
                    return "";
                }
                return s.replaceAll("&", "&amp;")
                        .replaceAll("<", "&lt;")
                        .replaceAll(">", "&gt;")
                        .replaceAll("\"", "&quot;")
                        .replaceAll("'", "&#39;");
            }
        %>

    </body>
</html>
