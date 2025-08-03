<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%@ include file="nav.jsp" %>
<html>
<head>
    <title>Your Cart</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background: white;
            padding: 25px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }

        h2 {
            text-align: center;
            color: #1976D2;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #1976D2;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .total-row td {
            font-weight: bold;
            text-align: right;
            background-color: #f2f2f2;
        }

        .buttons {
            text-align: center;
            margin-top: 30px;
        }

        .buttons a, .buttons input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            margin: 10px;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .buttons a:hover, .buttons input[type="submit"]:hover {
            background-color: #45a049;
        }

    </style>
</head>
<body>
    <div class="container">
        <h2>Cart Contents</h2>
        <%
            List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
        %>
            <p style="text-align: center;">Your cart is empty.</p>
        <%
            } else {
        %>
        <table>
            <tr>
                <th>Item ID</th>
                <th>Name</th>
                <th>Quantity</th>
                <th>Unit Price (LKR)</th>
                <th>Subtotal (LKR)</th>
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
                <td><%= String.format("%.2f", price) %></td>
                <td><%= String.format("%.2f", subtotal) %></td>
            </tr>
            <% } %>
            <tr class="total-row">
                <td colspan="4">Total:</td>
                <td><%= String.format("%.2f", total) %></td>
            </tr>
        </table>

        <div class="buttons">
            <a href="viewItems.jsp">Back to Items</a>
            <form action="GenerateBillServlet" method="post" style="display:inline;">
                <input type="submit" value="Generate Bill" />
            </form>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>
