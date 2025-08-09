<%@ include file="nav.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Manage Help Entries</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            h2 {
                text-align: center;
                color: #1976D2;
            }
            table {
                margin: 0 auto;
                border-collapse: collapse;
                width: 90%;
                background: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px 12px;
                text-align: left;
                vertical-align: top;
            }
            th {
                background-color: #1976D2;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }

            .btn {
                padding: 5px 10px;
                margin: 0 2px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                color: white;
                font-size: 14px;
                text-decoration: none;
                display: inline-block;
            }
            .btn-edit {
                background-color: #4CAF50;
            }
            .btn-edit:hover {
                background-color: #45a049;
            }
            .btn-delete {
                background-color: #f44336;
            }
            .btn-delete:hover {
                background-color: #da190b;
            }

            .success {
                text-align: center;
                color: green;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #e6ffe6;
                border-radius: 4px;
                width: 90%;
                margin-left: auto;
                margin-right: auto;
            }
            .error {
                text-align: center;
                color: red;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #ffe6e6;
                border-radius: 4px;
                width: 90%;
                margin-left: auto;
                margin-right: auto;
            }
        </style>
    </head>
    <body>
  <h2>Manage Help Entries</h2>
  <div class="table-containe">
           

            <%-- Display success or error messages --%>
            <%
                String status = request.getParameter("status");
                String action = request.getParameter("action");
                if ("success".equals(status)) {
                    if ("edit".equals(action)) {
            %>
            <div class="success">Help entry updated successfully!</div>
            <%  } else if ("delete".equals(action)) { %>
            <div class="success">Help entry deleted successfully!</div>
            <%  } else { %>
            <div class="success">Operation completed successfully!</div>
            <%  }
            } else if ("error".equals(status)) {
            %>
            <div class="error">Error <%= "edit".equals(action) ? "updating" : "deleting"%> help entry: 
                <%= request.getParameter("errorMessage") != null ? request.getParameter("errorMessage") : "Unknown error occurred."%>
            </div>
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Clue</th>
                        <th>Answer</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DBConnection.getConnection();

                            String sql = "SELECT id, question, answer, clue FROM help ORDER BY id";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String question = rs.getString("question");
                                String answer = rs.getString("answer");
                                String clue = rs.getString("clue");
                    %>
                    <tr>
                        <td><%= id%></td>
                        <td><%= question%></td>
                        <td><%= clue != null ? clue : ""%></td>
                        <td><pre style="white-space: pre-wrap; margin: 0;"><%= answer%></pre></td>
                        <td>
                            <a class="btn btn-edit" href="editHelp.jsp?id=<%= id%>">Edit</a>

                            <form action="<%= request.getContextPath()%>/adminHelp" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="<%= id%>"/>
                                <input type="hidden" name="action" value="delete"/>
                                <input type="submit" class="btn btn-delete" value="Delete" onclick="return confirm('Are you sure you want to delete this help entry?');" />
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="5" class="error">Error: <%= e.getMessage()%></td>
                    </tr>
                    <%
                            e.printStackTrace();
                        } finally {
                            try {
                                if (rs != null) {
                                    rs.close();
                                }
                            } catch (Exception ignored) {
                            }
                            try {
                                if (ps != null) {
                                    ps.close();
                                }
                            } catch (Exception ignored) {
                            }
                            try {
                                if (conn != null) {
                                    conn.close();
                                }
                            } catch (Exception ignored) {
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

    </body>
</html>
