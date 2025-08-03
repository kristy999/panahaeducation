<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="nav.jsp" %>
<html>
<head>
    <title>Bill Summary</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            max-width: 800px;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }

        h2 {
            text-align: center;
            color: #1976D2;
        }

        p {
            font-size: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }

        th {
            background-color: #1976D2;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .print-btn {
            display: block;
            margin: 30px auto 0;
            padding: 10px 25px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .print-btn:hover {
            background-color: #45a049;
        }

    </style>
</head>
<body>
    <div class="container">
        <h2>Bill Summary</h2>
<%
    int billId = (Integer) session.getAttribute("bill_id");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_education", "root", "");

    PreparedStatement billStmt = con.prepareStatement("SELECT * FROM bill WHERE bill_id = ?");
    billStmt.setInt(1, billId);
    ResultSet billRs = billStmt.executeQuery();

    if (billRs.next()) {
%>
        <p><strong>Bill ID:</strong> <%= billId %></p>
        <p><strong>Date:</strong> <%= billRs.getDate("bill_date") %></p>
        <p><strong>Total:</strong> Rs. <%= String.format("%.2f", billRs.getDouble("total_amount")) %></p>

        <table>
            <tr>
                <th>Item Name</th>
                <th>Price (LKR)</th>
            </tr>
<%
        PreparedStatement itemStmt = con.prepareStatement(
            "SELECT i.item_name, i.item_price FROM bill_item bi JOIN item i ON bi.item_id = i.item_id WHERE bi.bill_id = ?"
        );
        itemStmt.setInt(1, billId);
        ResultSet itemRs = itemStmt.executeQuery();
        while (itemRs.next()) {
%>
            <tr>
                <td><%= itemRs.getString("item_name") %></td>
                <td><%= String.format("%.2f", itemRs.getDouble("item_price")) %></td>
            </tr>
<%
        }
%>
        </table>
<%
    } else {
%>
        <p style="text-align: center; color: red;">Bill not found.</p>
<%
    }
    con.close();
%>
        <button class="print-btn" onclick="window.print()">Print Bill</button>
    </div>
</body>
</html>
