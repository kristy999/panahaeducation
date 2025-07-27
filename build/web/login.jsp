<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Pahana Edu - Login</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
            }
            .login-container {
                width: 350px;
                margin: 100px auto;
                padding: 30px;
                background: white;
                box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #1976D2;
            }
            input[type="text"], input[type="password"], input[type="email"] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ddd;
            }
            input[type="submit"] {
                background-color: #1976D2;
                color: white;
                border: none;
                padding: 10px;
                width: 100%;
                cursor: pointer;
            }
            .error {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Login</h2>
            <% if (request.getParameter("error") != null) { %>
            <div class="error">Invalid email or password</div>
            <% }%>
            <form action="LoginServlet" method="post">
                <input type="email" name="email" placeholder="Email Address" required />
                <input type="password" name="password" placeholder="Password" required />
                <input type="submit" value="Login" />
            </form>
        </div>
    </body>
</html>
