<%@ page import="java.sql.*, java.util.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="nav.jsp" %>

<html>
<head>
    <title>Manage Users - Pahana Edu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 80%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        h2 { color: #1976D2; }
        input, select { padding: 8px; margin: 5px; }
    </style>
</head>
<body>

<h2>👥 Manage Users</h2>

<%
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT user_id, username, role FROM users");

%>
    <table>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Role</th>
        </tr>
<%
        while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getInt("role") == 1 ? "Admin" : "User" %></td>
        </tr>
<%
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }
%>
    </table>

    <h3>➕ Register New User</h3>
    <form method="post" action="RegisterUserServlet">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <select name="role">
            <option value="0">User</option>
            <option value="1">Admin</option>
        </select>
        <button type="submit">Register</button>
    </form>

</body>
</html>
