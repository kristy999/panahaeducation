<%@ include file="nav.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Admin - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .container {
            width: 400px;
            margin: 50px auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #1976D2;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #1976D2;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .message {
            text-align: center;
            color: green;
        }
        .error {
            text-align: center;
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register Admin</h2>

        <% if (request.getParameter("status") != null && request.getParameter("status").equals("success")) { %>
            <div class="message">Admin registered successfully!</div>
        <% } else if (request.getParameter("status") != null && request.getParameter("status").equals("error")) { %>
            <div class="error">Registration failed. Try again.</div>
        <% } %>

        <form action="RegisterAdminServlet" method="post">
            <input type="text" name="username" placeholder="Admin Username" required />
            <input type="password" name="password" placeholder="Admin Password" required />
            <input type="submit" value="Register Admin" />
        </form>
    </div>
</body>
</html>
