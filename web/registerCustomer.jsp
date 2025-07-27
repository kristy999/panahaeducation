<%@ include file="nav.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Register Customer - Pahana Edu</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .form-container {
                width: 450px;
                margin: 50px auto;
                background: white;
                padding: 25px;
                box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
                border-radius: 8px;
            }
            h2 {
                text-align: center;
                color: #1976D2;
            }
            input[type="text"], input[type="tel"], input[type="password"], input[type="email"] {
                width: 100%;
                padding: 10px;
                margin: 12px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            input[type="submit"] {
                width: 100%;
                background-color: #1976D2;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .success {
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
        <div class="form-container">
            <h2>Register New Customer</h2>

            <% if (request.getParameter("status") != null && request.getParameter("status").equals("success")) { %>
            <div class="success">Customer registered successfully!</div>
            <% } else if (request.getParameter("status") != null && request.getParameter("status").equals("error")) { %>
            <div class="error">Something went wrong. Try again.</div>
            <% }%>

            <form action="RegisterCustomerServlet" method="post">
                <input type="email" name="email" placeholder="Email Address" required />
                <input type="password" name="password" placeholder="Password" required />
                <input type="text" name="name" placeholder="Full Name" required />
                <input type="text" name="address" placeholder="Address" required />
                <input type="tel" name="phone" placeholder="Telephone Number" required />
                <input type="submit" value="Register Customer" />
            </form>
        </div>
    </body>
</html>
