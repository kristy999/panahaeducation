<%-- 
    Document   : createBill
    Created on : Jul 18, 2025, 10:09:15?PM
    Author     : krish
--%>

<%@ page import="java.util.*, jakarta.servlet.http.*" %>
<%@ include file="nav.jsp" %>
<html>
<head><title>Create Bill</title></head>
<body>
    <h2>Items in Cart</h2>
    <%
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        double total = 0;
        if (cart != null && !cart.isEmpty()) {
    %>
        <form action="GenerateBillServlet" method="post">
        <table border="1">
            <tr><th>Item Name</th><th>Price</th></tr>
            <% for (Map<String, Object> item : cart) {
                total += (Double)item.get("item_price");
            %>
            <tr>
                <td><%= item.get("item_name") %></td>
                <td><%= item.get("item_price") %></td>
            </tr>
            <% } %>
        </table>
        <p><strong>Total: Rs. <%= total %></strong></p>
        <input type="submit" value="Generate Bill">
        </form>
    <% } else { %>
        <p>No items in cart.</p>
    <% } %>
</body>
</html>

