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
            .table-container {
                width: 80%;
                margin: 50px auto;
                background: white;
                padding: 25px;
                box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
                border-radius: 8px;
            }
            h2 {
                text-align: center;
                color: #1976D2;
            }
            /* Table styles */
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
                font-family: Arial, sans-serif;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
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
            /* Error message */
            .error {
                text-align: center;
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="table-container">
            <h2>User Management</h2>

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
                            <a class="btn btn-delete" href="deleteUser?userId=<%=userId%>" 
                               onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
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
</html>F