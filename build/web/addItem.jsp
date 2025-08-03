<%@ include file="nav.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Item</title>
    <style>
        /* Page styles */
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .form-container {
            width: 50%;
            margin: 50px auto;
            background: white;
            padding: 25px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #1976D2;
            margin-bottom: 20px;
        }
        /* Form styles */
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        input[type="text"],
        input[type="number"] {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="number"]:focus {
            border-color: #1976D2;
            outline: none;
            box-shadow: 0 0 5px rgba(25, 118, 210, 0.3);
        }
        /* Buttons */
        input[type="submit"] {
            padding: 10px;
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
    <div class="form-container">
        <h2>Add New Item</h2>

        <form action="AddItemServlet" method="post">
            <label for="item_name">Item Name:</label>
            <input type="text" id="item_name" name="item_name" required>

            <label for="item_price">Item Price:</label>
            <input type="number" id="item_price" name="item_price" step="0.01" required>

            <input type="submit" value="Add Item">
        </form>

        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="success">Item added successfully!</div>
        <%
            } else if ("error".equals(status)) {
        %>
            <div class="error">Failed to add item. Please try again.</div>
        <%
            }
        %>
    </div>
</body>
</html>