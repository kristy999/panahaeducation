<link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
<%@ page import="java.sql.*,pahanaedu.DBConnection" %>
<%
    String uname = (String) session.getAttribute("email");
    int role = 0;

    if (uname == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT role FROM user WHERE email = ?");
        ps.setString(1, uname);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            role = rs.getInt("role");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Header -->
<div style="
     background: linear-gradient(90deg, #1976D2 0%, #1565C0 100%);
     padding: 15px 30px;
     color: white;
     font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
     font-weight: 600;
     text-shadow: 0 1px 2px rgba(0,0,0,0.3);
     display: flex;
     justify-content: space-between;
     align-items: center;
     ">
    <div>Welcome, <span style="font-weight: 700;"><%= uname %></span></div>
    <div><a href="logout.jsp" style="color: #FFEB3B; font-weight: 600; text-decoration: none; padding: 5px 10px; border-radius: 4px; transition: background-color 0.3s ease;">Logout</a></div>
</div>

<!-- Navigation Bar -->
<nav style="
     background-color: #ffffff;
     padding: 12px 30px;
     box-shadow: 0 2px 5px rgba(0,0,0,0.1);
     font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
     font-weight: 500;
     font-size: 16px;
     border-bottom: 2px solid #e0e0e0;
     ">
    <a href="dashboard.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">Dashboard</a>
    <a href="createBill.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">Create Bill</a>
    <a href="viewItems.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">View Items</a>

    <% if (role == 1) { %>
        <a href="manageUsers.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">Manage Users</a>
        <a href="addItem.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">Add Item</a>
        <a href="reports.jsp" style="color: #1976D2; margin-right: 25px; text-decoration: none; transition: color 0.3s ease;">Reports</a>
        <a href="registerCustomer.jsp" style="color: #1976D2; text-decoration: none; transition: color 0.3s ease;">Register Customer</a>
    <% } %>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }
    </style>
</nav>

<script>
    document.querySelectorAll('nav a').forEach(link => {
        link.addEventListener('mouseenter', () => {
            link.style.color = '#0D47A1';
        });
        link.addEventListener('mouseleave', () => {
            link.style.color = '#1976D2';
        });
    });
</script>
