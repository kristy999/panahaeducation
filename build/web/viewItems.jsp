<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>

<html>
    <head>
        <title>View Items</title>
    </head>
    <body>
        <h2>Available Items</h2>
        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>Item ID</th>
                <th>Item Name</th>
                <th>Price (LKR)</th>
                <th>Add to Cart</th>
            </tr>

            <%
                // Database connection parameters
                String url = "jdbc:mysql://localhost:3306/pahana_education";
                String username = "root";      // change as needed
                String password = "";          // change as needed

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, username, password);

                    String sql = "SELECT item_id, item_name, item_price FROM item";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int itemId = rs.getInt("item_id");
                        String itemName = rs.getString("item_name");
                        double itemPrice = rs.getDouble("item_price");
            %>
            <tr>
                <td><%= itemId%></td>
                <td><%= itemName%></td>
                <td><%= itemPrice%></td>
                <td>
                    <form action="AddToCartServlet" method="post">
                        <input type="hidden" name="item_id" value="<%= itemId%>" />
                        <input type="hidden" name="item_name" value="<%= itemName%>" />
                        <input type="hidden" name="item_price" value="<%= itemPrice%>" />
                        Quantity: <input type="number" name="quantity" value="1" min="1" />
                        <input type="submit" value="Add to Cart" />
                    </form>
                </td>
            </tr>

            <%
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                    } catch (Exception e) {
                    }
                    try {
                        if (ps != null) {
                            ps.close();
                        }
                    } catch (Exception e) {
                    }
                    try {
                        if (conn != null) {
                            conn.close();
                        }
                    } catch (Exception e) {
                    }
                }
            %>
        </table>
    </body>
</html>
