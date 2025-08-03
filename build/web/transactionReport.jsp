<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="adminHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Transaction Report</title>
    <style>
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .export-btn { padding: 10px 20px; margin: 10px; background-color: #008CBA; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .export-btn:hover { background-color: #007B9A; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Transaction Report</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p style="color:red;"><%= request.getAttribute("error") %></p>
        <% } else { %>
            <table>
                <tr>
                    <th>Bill ID</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Account Number</th>
                    <th>Calculated By</th>
                    <th>Item ID</th>
                    <th>Quantity</th>
                    <th>Item Price</th>
                </tr>
                <% ResultSet rs = (ResultSet) request.getAttribute("transactions");
                   while (rs != null && rs.next()) { %>
                    <tr>
                        <td><%= rs.getInt("bill_id") %></td>
                        <td><%= rs.getDate("bill_date") %></td>
                        <td><%= rs.getDouble("total_amount") %></td>
                        <td><%= rs.getInt("account_number") %></td>
                        <td><%= rs.getInt("calculated_by") %></td>
                        <td><%= rs.getInt("item_id") %></td>
                        <td><%= rs.getInt("quantity") %></td>
                        <td><%= rs.getDouble("item_price") %></td>
                    </tr>
                <% } %>
            </table>
            <form action="ExportServlet" method="get">
                <input type="hidden" name="type" value="csv">
                <input type="submit" class="export-btn" value="Export to CSV">
            </form>
            <form action="ExportServlet" method="get">
                <input type="hidden" name="type" value="pdf">
                <input type="submit" class="export-btn" value="Export to PDF">
            </form>
        <% } %>
    </div>
</body>
</html>