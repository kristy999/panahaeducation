<%@ page import="java.util.*" %>
<%@ page session="true" %>
<html>
<head><title>Your Cart</title></head>
<body>
    <h2>Cart Contents</h2>
    <%
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
        <p>Your cart is empty.</p>
    <%
        } else {
    %>
        <table border="1">
            <tr>
                <th>Item ID</th>
                <th>Name</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Subtotal</th>
            </tr>
            <%
                double total = 0;
                for (Map<String, Object> item : cart) {
                    int id = (Integer) item.get("item_id");
                    String name = (String) item.get("item_name");
                    int qty = (Integer) item.get("quantity");
                    double price = (Double) item.get("item_price");
                    double subtotal = qty * price;
                    total += subtotal;
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= qty %></td>
                <td><%= price %></td>
                <td><%= subtotal %></td>
            </tr>
            <% } %>
            <tr>
                <td colspan="4" align="right"><strong>Total:</strong></td>
                <td><%= total %></td>
            </tr>
        </table>
    <%
        }
    %>
</body>
</html>
