<%@ include file="nav.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Manage Users</title>
        <style>
            /* Page styles */
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
          
        
            /* Buttons */
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
            /* Status messages */
            .success {
                text-align: center;
                color: green;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #e6ffe6;
                border-radius: 4px;
            }
            .error {
                text-align: center;
                color: red;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #ffe6e6;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="table-container">
            <h2>User Management</h2>

            <%
                String status = request.getParameter("status");
                String action = request.getParameter("action");
                if (status != null && status.equals("success")) {
                    if ("edit".equals(action)) {
            %>
            <div class="success">User updated successfully!</div>
            <%      } else if ("delete".equals(action)) { %>
            <div class="success">User deleted successfully!</div>
            <%      } else { %>
            <div class="success">Operation completed successfully!</div>
            <%      }
            } else if (status != null && status.equals("error")) {%>
            <div class="error">Error <%= "edit".equals(action) ? "updating" : "deleting"%> user: <%= request.getParameter("errorMessage") != null ? request.getParameter("errorMessage") : "Unknown error occurred."%></div>
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Account Number</th>
                        <th>Customer Name</th>
                        <th>Customer Email</th>
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

                            String sql = "SELECT u.user_id, u.email, u.role, c.account_number, c.name, c.email AS cust_email "
                                    + "FROM user u LEFT JOIN customer c ON u.user_id = c.user_id";

                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int userId = rs.getInt("user_id");
                                String email = rs.getString("email");
                                int userRole = rs.getInt("role");
                                String roleText = (userRole == 1) ? "Admin" : "User";

                                int accountNumber = rs.getInt("account_number");
                                String custName = rs.getString("name");
                                String custEmail = rs.getString("cust_email");
                    %>
                    <tr>
                        <td><%= userId%></td>
                        <td><%= email%></td>
                        <td><%= roleText%></td>
                        <td><%= accountNumber%></td>
                        <td><%= (custName != null) ? custName : ""%></td>
                        <td><%= (custEmail != null) ? custEmail : ""%></td>
                        <td>
                            <a class="btn btn-edit" href="editUser.jsp?userId=<%=userId%>">Edit</a>
                            <form action="<%=request.getContextPath()%>/deleteUser" method="post" style="display:inline;">
                                <input type="hidden" name="userId" value="<%=userId%>">
                                <input type="submit" class="btn btn-delete" value="Delete" 
                                       onclick="return confirm('Are you sure you want to delete this user?');">
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="7" class="error">Error: <%= e.getMessage()%></td>
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