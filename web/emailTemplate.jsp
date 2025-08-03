<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> cart = (List<Map<String, Object>>) request.getAttribute("cart");
    double total = (Double) request.getAttribute("total");
    int billId = (Integer) request.getAttribute("billId");
    String billDate = (String) request.getAttribute("billDate");
%>
<html>
<body style="font-family: Arial; color: #333;">
    <h2 style="color: #1976D2;">Pahana Education - Bill Summary</h2>
    <p><strong>Bill ID:</strong> <%= billId %></p>
    <p><strong>Date:</strong> <%= billDate %></p>

    <table style="width:100%; border-collapse: collapse;" border="1">
        <tr style="background-color: #f2f2f2;">
            <th>Item</th>
            <th>Qty</th>
            <th>Unit Price (LKR)</th>
            <th>Subtotal (LKR)</th>
        </tr>
        <% for (Map<String, Object> item : cart) {
            String name = (String) item.get("item_name");
            int qty = (Integer) item.get("quantity");
            double price = (Double) item.get("item_price");
            double subtotal = qty * price;
        %>
        <tr>
            <td><%= name %></td>
            <td><%= qty %></td>
            <td><%= String.format("%.2f", price) %></td>
            <td><%= String.format("%.2f", subtotal) %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="3" style="text-align:right;"><strong>Total:</strong></td>
            <td><%= String.format("%.2f", total) %></td>
        </tr>
    </table>

    <p>Thank you for shopping with Pahana Education!</p>
</body>
</html>
