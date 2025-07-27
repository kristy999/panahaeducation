<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="nav.jsp" %>
<html>
<head><title>Bill</title></head>
<body>
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
    <p><strong>Total:</strong> Rs. <%= billRs.getDouble("total_amount") %></p>

    <table border="1">
        <tr><th>Item Name</th><th>Price</th></tr>
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
            <td><%= itemRs.getDouble("item_price") %></td>
        </tr>
<%
        }
%>
    </table>
<%
    } else {
%>
    <p>Bill not found.</p>
<%
    }
    con.close();
%>
    <button onclick="window.print()">?? Print Bill</button>
</body>
</html>
