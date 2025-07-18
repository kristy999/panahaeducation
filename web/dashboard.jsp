<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession session = request.getSession(false);
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #1976D2;
            padding: 15px;
            color: white;
            text-align: right;
        }

        .content {
            padding: 30px;
        }

        .logout {
            color: white;
            text-decoration: none;
            font-weight: bold;
            margin-left: 20px;
        }

        .welcome {
            float: left;
            color: white;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="welcome">Welcome, <%= username %></div>
        <a class="logout" href="logout.jsp">Logout</a>
    </div>
    <div class="content">
        <h2>Dashboard</h2>
        <p>This is the secure area after login. Here you can add your billing system modules like:</p>
        <ul>
            <li>Customer Management</li>
            <li>Item Management</li>
            <li>Billing</li>
            <li>Help Section</li>
        </ul>
    </div>
</body>
</html>
