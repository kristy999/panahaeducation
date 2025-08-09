<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="nav.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="pahanaedu.CustomerReportServlet.Customer" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer Report</title>
        <style>
            .container {
                width: 90%;
                margin: 40px auto;
                font-family: Arial, sans-serif;
                background: white;
                padding: 20px 30px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 8px;
            }

            h2 {
                color: #1976D2;
                text-align: center;
            }

            p.error-message {
                color: red;
                font-weight: 600;
                text-align: center;
                margin-top: 20px;
            }

            p.no-data {
                text-align: center;
                font-style: italic;
                margin-top: 20px;
                color: #555;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Customer Report</h2>

            <%
                List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                if (request.getAttribute("error") != null) {
            %>
            <p style="color:red;"><%= request.getAttribute("error")%></p>
            <%  } else if (customers != null && !customers.isEmpty()) { %>

            <table>
                <tr>
                    <th>Account No</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Telephone</th>
                </tr>
                <% for (Customer c : customers) {%>
                <tr>
                    <td><%= c.getAccountNumber()%></td>
                    <td><%= c.getName()%></td>
                    <td><%= c.getEmail()%></td>
                    <td><%= c.getAddress()%></td>
                    <td><%= c.getTelephone()%></td>
                </tr>
                <% } %>
            </table>

            <% } else { %>
            <p>No customers found.</p>
            <% }%>
            <div class="form-container">
                <form action="ExportServlet" method="get">
                    <input type="hidden" name="type" value="csv">
                    <input type="hidden" name="report" value="customer">
                    <input type="submit" class="export-btn" value="Export Customers as CSV">
                </form>
            </div>

        </div>
    </body>
</html>
