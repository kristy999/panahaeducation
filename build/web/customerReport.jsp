<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Report</title>
    <style>
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Customer Report</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p style="color:red;"><%= request.getAttribute("error") %></p>
        <% } else { %>
            <table>
                <tr>
                    <th>User ID</th>
                    <th>Email</th>
                </tr>
                <% ResultSet rs = (ResultSet) request.getAttribute("customers");
                   while (rs != null && rs.next()) { %>
                    <tr>
                        <td><%= rs.getInt("user_id") %></td>
                        <td><%= rs.getString("email") %></td>
                    </tr>
                <% } %>
            </table>
        <% } %>
    </div>
</body>
</html>