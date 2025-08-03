<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .error-container {
            width: 80%;
            margin: 50px auto;
            background: white;
            padding: 25px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            text-align: center;
        }
        .error-message {
            color: red;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h2>Oops! Something Went Wrong</h2>
        <div class="error-message">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "An unexpected error occurred." %>
        </div>
        <a href="javascript:history.back()">Go Back</a>
    </div>
</body>
</html>