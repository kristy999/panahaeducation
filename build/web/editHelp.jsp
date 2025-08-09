<%@ include file="nav.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    public String escapeHtml(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    String username = (String) session.getAttribute("email");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("adminHelp?status=error&action=edit&errorMessage=Missing ID");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("adminHelp?status=error&action=edit&errorMessage=Invalid ID");
        return;
    }

    String question = "";
    String answer = "";
    String clue = "";

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT question, answer, clue FROM help WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    question = rs.getString("question");
                    answer = rs.getString("answer");
                    clue = rs.getString("clue");
                } else {
                    response.sendRedirect("adminHelp?status=error&action=edit&errorMessage=Help entry not found");
                    return;
                }
            }
        }
    } catch (Exception e) {
        response.sendRedirect("adminHelp?status=error&action=edit&errorMessage=" + e.getMessage());
        return;
    }
%>

<html>
    <head>
        <title>Edit Help Entry</title>
        <style>
            /* Match the Manage Users page style */
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .table-container {
                max-width: 700px;
                margin: 40px auto;
                background: white;
                padding: 20px 30px;
                border-radius: 6px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            h2 {
                color: #1976D2;
                text-align: center;
                margin-bottom: 20px;
            }
            label {
                display: block;
                margin-top: 15px;
                font-weight: 600;
                font-size: 15px;
            }
            input[type=text], textarea {
                width: 100%;
                padding: 8px 10px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 15px;
                font-family: Arial, sans-serif;
                resize: vertical;
                box-sizing: border-box;
            }
            textarea {
                height: 120px;
            }
            .btn-submit {
                margin-top: 25px;
                background-color: #4CAF50;
                border: none;
                color: white;
                padding: 12px 20px;
                cursor: pointer;
                font-size: 16px;
                border-radius: 4px;
                width: 100%;
                font-weight: 600;
                transition: background-color 0.3s ease;
            }
            .btn-submit:hover {
                background-color: #45a049;
            }
            .success-message, .error-message {
                text-align: center;
                margin-bottom: 15px;
                padding: 10px;
                border-radius: 4px;
                font-weight: 600;
                display: none;
            }
            .success-message {
                color: green;
                background-color: #e6ffe6;
            }
            .error-message {
                color: red;
                background-color: #ffe6e6;
            }
        </style>

        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('status') === 'success' && urlParams.get('action') === 'edit') {
                    const successDiv = document.getElementById('successMessage');
                    successDiv.style.display = 'block';
                    setTimeout(() => {
                        successDiv.style.display = 'none';
                        window.location.href = 'adminHelp';
                    }, 3000);
                }
                // Could add error display similarly if needed
            };
        </script>
    </head>
    <body>
        <div class="table-container">
            <h2>Edit Help Entry</h2>

            <div id="successMessage" class="success-message">Help entry updated successfully! Redirecting...</div>

            <form method="post" action="adminHelp">
                <input type="hidden" name="id" value="<%= id%>" />
                <input type="hidden" name="action" value="update" />

                <label for="question">Question:</label>
                <input type="text" id="question" name="question" value="<%= escapeHtml(question)%>" required />

                <label for="clue">Clue:</label>
                <input type="text" id="clue" name="clue" value="<%= escapeHtml(clue)%>" />

                <label for="answer">Answer:</label>
                <textarea id="answer" name="answer" required><%= escapeHtml(answer)%></textarea>

                <button type="submit" class="btn-submit">Update</button>
            </form>

        </div>
    </body>
</html>
