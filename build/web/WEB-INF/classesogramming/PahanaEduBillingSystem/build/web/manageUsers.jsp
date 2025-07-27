<%@ page import="java.sql.*" %>
<%@ page import="pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Manage Users</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
            }
            th {
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>

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
                </tr>
                <%
                    }
                } catch (Exception e) {
                %>
                <tr>
                    <td colspan="6" style="color:red;">Error: <%= e.getMessage()%></td>
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

    </body>
</html>
