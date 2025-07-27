<%@ include file="nav.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Search Item</title>
</head>
<body>
    <h2>Search for Items</h2>
    <form action="SearchItemServlet" method="get">
        Item Name: <input type="text" name="query" />
        <input type="submit" value="Search" />
    </form>

    <%
        List<Item> results = (List<Item>) request.getAttribute("results");
        if (results != null && !results.isEmpty()) {
    %>
        <form action="AddToCartServlet" method="post">
            <table border="1">
                <tr><th>Select</th><th>Name</th><th>Price</th></tr>
                <% for (Item item : results) { %>
                    <tr>
                        <td><input type="checkbox" name="item_ids" value="<%= item.getId() %>"></td>
                        <td><%= item.getName() %></td>
                        <td><%= item.getPrice() %></td>
                    </tr>
                <% } %>
            </table>
            <input type="submit" value="Add to Bill">
        </form>
    <%
        } else if (request.getAttribute("noResult") != null) {
            out.println("<p>No items found.</p>");
        }
    %>
</body>
</html>
