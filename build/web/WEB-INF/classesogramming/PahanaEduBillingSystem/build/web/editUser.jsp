<%@ include file="nav.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Edit User - Pahana Edu</title>
        <style>
            /* Page styles */
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .form-container {
                width: 450px;
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
            input[type="text"], input[type="tel"], input[type="password"], input[type="email"], select {
                width: 100%;
                padding: 10px;
                margin: 12px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            input[type="submit"] {
                width: 100%;
                background-color: #4CAF50;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #45a049;
            }
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
        <div class="form-container">
            <h2>Edit User</h2>

            <%
                String userIdStr = request.getParameter("userId");
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                String email = "", roleText = "", name = "", custEmail = "", address = "", telephone = "";
                int userRole = 0, accountNumber = 0;

                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT u.user_id, u.email, u.role, c.account_number, c.name, c.email AS cust_email, c.address, c.telephone "
                            + "FROM user u LEFT JOIN customer c ON u.user_id = c.user_id WHERE u.user_id = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(userIdStr));
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        email = rs.getString("email") != null ? rs.getString("email") : "";
                        userRole = rs.getInt("role");
                        roleText = (userRole == 1) ? "Admin" : "User";
                        accountNumber = rs.getInt("account_number");
                        name = rs.getString("name") != null ? rs.getString("name") : "";
                        custEmail = rs.getString("cust_email") != null ? rs.getString("cust_email") : "";
                        address = rs.getString("address") != null ? rs.getString("address") : "";
                        telephone = rs.getString("telephone") != null ? rs.getString("telephone") : "";
                    } else {
            %>
            <div class="error">User not found.</div>
            <%
                    return;
                }
            } catch (Exception e) {
            %>
            <div class="error">Error: <%= e.getMessage()%></div>
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

            <% if (request.getParameter("status") != null && request.getParameter("status").equals("success")) { %>
            <div class="success">User updated successfully!</div>
            <% } else if (request.getParameter("status") != null && request.getParameter("status").equals("error")) {%>
            <div class="error">Error updating user: <%= request.getParameter("errorMessage") != null ? request.getParameter("errorMessage") : "Unknown error occurred."%></div>
            <% }%>

            <form action="<%=request.getContextPath()%>/editUser" method="post">
                <input type="hidden" name="userId" value="<%=userIdStr%>">
                <input type="email" name="email" placeholder="User Email" value="<%=email%>" required />
                <input type="password" name="password" placeholder="New Password (leave blank to keep unchanged)" />
                <select name="role" required>
                    <option value="1" <%= userRole == 1 ? "selected" : ""%>>Admin</option>
                    <option value="2" <%= userRole == 2 ? "selected" : ""%>>User</option>
                </select>
                <input type="text" name="name" placeholder="Customer Name" value="<%=name%>" />
                <input type="email" name="custEmail" placeholder="Customer Email" value="<%=custEmail%>" />
                <input type="text" name="address" placeholder="Address" value="<%=address%>" />
                <input type="tel" name="telephone" placeholder="Telephone Number" value="<%=telephone%>" />
                <input type="submit" value="Update User" />
            </form>
        </div>
    </body>
</html>