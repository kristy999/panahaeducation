<%@ page import="java.sql.*,pahanaedu.DBConnection, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    String username = (String) session.getAttribute("username");
    int role = 0; // default to standard user

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT role FROM users WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            role = rs.getInt("role");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div style="background-color:#1976D2; padding:10px; color:white;">
    <h3>Welcome <%= username %> | <a href="logout.jsp" style="color:yellow;">Logout</a></h3>
</div>

<nav style="background-color:#f0f0f0; padding:10px;">
    <a href="dashboard.jsp">Dashboard</a> |
    <a href="createBill.jsp">Create Bill</a> |
    <a href="viewItems.jsp">View Items</a>

    <% if (role == 1) { %>
        <!-- Admin-only links -->
        | <a href="manageUsers.jsp">Manage Users</a>
        | <a href="addItem.jsp">Add Item</a>
        | <a href="reports.jsp">Reports</a>
    <% } %>
</nav>
