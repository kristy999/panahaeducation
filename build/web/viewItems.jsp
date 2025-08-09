<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>
<%@ include file="nav.jsp" %>
<html>
    <head>
        <title>View Items</title>
        <style>
            /* Page styles */
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }

            h2 {
                text-align: center;
                color: #1976D2;
                margin-bottom: 20px;
            }

            /* Form and input styles */
            .cart-form {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            input[type="number"] {
                width: 60px;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            input[type="number"]:focus {
                border-color: #1976D2;
                outline: none;
                box-shadow: 0 0 5px rgba(25, 118, 210, 0.3);
            }
            /* Buttons */
            input[type="submit"] {
                padding: 8px 12px;
                border: none;
                border-radius: 4px;
                background-color: #4CAF50;
                color: white;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            input[type="submit"]:hover {
                background-color: #45a049;
            }
            /* Status messages */
            .success {
                text-align: center;
                color: green;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #e6ffe6;
                border-radius: 4px;
            }
            .error {
                text-align: center;
                color: red;
                margin-bottom: 15px;
                padding: 10px;
                background-color: #ffe6e6;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="table-container">
            <h2>Available Items</h2>

            <%
                String status = request.getParameter("status");
                if ("success".equals(status)) {
            %>
            <div class="success">Item added to cart successfully!</div>
            <%
            } else if ("error".equals(status)) {
            %>
            <div class="error">Failed to add item to cart. Please try again.</div>
            <%
                }
            %>

            <%
                String url = "jdbc:mysql://localhost:3306/pahana_education";
                String username = "root";
                String password = "";
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, username, password);
                    String sql = "SELECT item_id, item_name, item_price FROM item";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();
            %>
            <table>
                <thead>
                    <tr>
                        <th>Item ID</th>
                        <th>Item Name</th>
                        <th>Price (LKR)</th>
                        <th>Add to Cart</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            int itemId = rs.getInt("item_id");
                            String itemName = rs.getString("item_name");
                            double itemPrice = rs.getDouble("item_price");
                    %>
                    <tr>
                        <td><%= itemId%></td>
                        <td><%= itemName%></td>
                        <td><%= String.format("%.2f", itemPrice)%></td>
                        <td>
                            <form action="AddToCartServlet" method="post" class="cart-form">
                                <input type="hidden" name="item_id" value="<%= itemId%>" />
                                <input type="hidden" name="item_name" value="<%= itemName%>" />
                                <input type="hidden" name="item_price" value="<%= itemPrice%>" />
                                <input type="number" name="quantity" value="1" min="1" required />
                                <input type="submit" value="Add to Cart" />
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
            } catch (Exception e) {
            %>
            <div class="error">Error: <%= e.getMessage()%></div>
            <%
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
        </div>
    </body>
</html>