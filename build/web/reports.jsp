<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Reports</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 50px auto;
            background: white;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            text-align: center;
        }
        .button {
            padding: 10px 20px;
            margin: 10px;
            font-size: 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Admin Reports Section</h2>
        <p>Select a report to view or generate:</p>
        <form action="transactionReport" method="get">
            <input type="submit" class="button" value="View Transaction Report">
        </form>
        <form action="customerReport" method="get">
            <input type="submit" class="button" value="View Customer Report">
        </form>
    </div>
</body>
</html>