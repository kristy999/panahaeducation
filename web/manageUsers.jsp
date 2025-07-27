<%@ page import="java.sql.*,pahanaedu.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="nav.jsp" %>

<%
    String updateStatus = request.getParameter("update");
    if ("success".equals(updateStatus)) {
%>
<div style="color: green; font-weight: bold; margin-bottom: 15px;">
    Update successful!
</div>
<%
} else if ("error".equals(updateStatus)) {
%>
<div style="color: red; font-weight: bold; margin-bottom: 15px;">
    Update failed. Please try again.
</div>
<%
    }
%>

<html>
    <head>
        <title>Manage Users - Pahana Edu</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            table {
                width: 90%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ccc;
                text-align: left;
            }
            h2 {
                color: #1976D2;
            }
            button.edit-btn {
                background-color: #1976D2;
                color: white;
                border: none;
                padding: 6px 12px;
                cursor: pointer;
                border-radius: 4px;
            }
            /* Modal styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.5);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 20px;
                border-radius: 8px;
                width: 450px;
                position: relative;
            }
            .close-btn {
                color: #aaa;
                float: right;
                font-size: 24px;
                font-weight: bold;
                cursor: pointer;
            }
            .close-btn:hover {
                color: black;
            }
            input, select {
                width: 100%;
                padding: 8px;
                margin: 8px 0;
                box-sizing: border-box;
            }
            input[type="submit"] {
                background-color: #1976D2;
                color: white;
                border: none;
                cursor: pointer;
                font-weight: 600;
            }
        </style>
    </head>
    <body>

        <h2>👥 Manage Users & Customers</h2>

        <%
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT u.user_id, u.username, u.role, c.account_number, c.name, c.email, c.address, c.telephone "
                        + "FROM user u LEFT JOIN customer c ON u.user_id = c.user_id";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
        %>

        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Account Number</th>
                    <th>Customer Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Telephone</th>
                    <th>Edit</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        int userId = rs.getInt("user_id");
                        String username = rs.getString("username");
                        int role = rs.getInt("role");
                        String roleText = (role == 1) ? "Admin" : "User";

                        int accountNumber = rs.getInt("account_number");
                        if (rs.wasNull()) {
                            accountNumber = 0; // handle null customer
                        }
                        String custName = rs.getString("name");
                        String custEmail = rs.getString("email");
                        String custAddress = rs.getString("address");
                        String custTel = rs.getString("telephone");
                %>
                <tr>
                    <td><%= userId%></td>
                    <td><%= username%></td>
                    <td><%= roleText%></td>
                    <td><%= (accountNumber == 0 ? "-" : accountNumber)%></td>
                    <td><%= (custName != null ? custName : "-")%></td>
                    <td><%= (custEmail != null ? custEmail : "-")%></td>
                    <td><%= (custAddress != null ? custAddress : "-")%></td>
                    <td><%= (custTel != null ? custTel : "-")%></td>
                    <td>
                        <button class="edit-btn" 
                                data-userid="<%= userId%>"
                                data-username="<%= username%>"
                                data-role="<%= role%>"
                                data-accountnumber="<%= (accountNumber == 0 ? "" : accountNumber)%>"
                                data-custname="<%= (custName != null ? custName : "")%>"
                                data-custemail="<%= (custEmail != null ? custEmail : "")%>"
                                data-custaddress="<%= (custAddress != null ? custAddress : "")%>"
                                data-custtel="<%= (custTel != null ? custTel : "")%>"
                                >Edit</button>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        ps.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (conn != null) {
                            conn.close();
                        }
                    }
                %>
            </tbody>
        </table>

        <!-- Edit Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <span id="closeModal" class="close-btn">&times;</span>
                <h3>Edit User & Customer</h3>
                <form id="editForm" method="post" action="UpdateUserCustomerServlet">
                    <input type="hidden" name="user_id" id="user_id" />
                    <input type="hidden" name="account_number" id="account_number" />

                    <label>Username:</label>
                    <input type="text" name="username" id="username" required />

                    <label>Role:</label>
                    <select name="role" id="role" required>
                        <option value="0">User</option>
                        <option value="1">Admin</option>
                    </select>

                    <label>Customer Name:</label>
                    <input type="text" name="cust_name" id="cust_name" />

                    <label>Email:</label>
                    <input type="email" name="cust_email" id="cust_email" />

                    <label>Address:</label>
                    <textarea name="cust_address" id="cust_address" rows="3"></textarea>

                    <label>Telephone:</label>
                    <input type="text" name="cust_tel" id="cust_tel" />

                    <input type="submit" value="Update" />
                </form>
            </div>
        </div>

        <script>
            // Modal and edit button logic
            const modal = document.getElementById("editModal");
            const closeModalBtn = document.getElementById("closeModal");

            document.querySelectorAll(".edit-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    // Fill form with data attributes from the button
                    document.getElementById("user_id").value = btn.getAttribute("data-userid");
                    document.getElementById("username").value = btn.getAttribute("data-username");
                    document.getElementById("role").value = btn.getAttribute("data-role");
                    document.getElementById("account_number").value = btn.getAttribute("data-accountnumber");
                    document.getElementById("cust_name").value = btn.getAttribute("data-custname");
                    document.getElementById("cust_email").value = btn.getAttribute("data-custemail");
                    document.getElementById("cust_address").value = btn.getAttribute("data-custaddress");
                    document.getElementById("cust_tel").value = btn.getAttribute("data-custtel");

                    modal.style.display = "block";
                });
            });

            closeModalBtn.onclick = function () {
                modal.style.display = "none";
            }
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>

    </body>
</html>
