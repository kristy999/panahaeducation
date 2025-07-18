<%@ include file="nav.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Item</title>
</head>
<body>
    <h2>Add New Item</h2>

    <form action="AddItemServlet" method="post">
        <label>Item Name:</label><br>
        <input type="text" name="item_name" required><br><br>

        <label>Item Price:</label><br>
        <input type="number" name="item_price" step="0.01" required><br><br>

        <input type="submit" value="Add Item">
    </form>

    <%
        String status = request.getParameter("status");
        if ("success".equals(status)) {
    %>
        <p style="color:green;">Item added successfully!</p>
    <%
        } else if ("error".equals(status)) {
    %>
        <p style="color:red;">Failed to add item. Please try again.</p>
    <%
        }
    %>
</body>
</html>
