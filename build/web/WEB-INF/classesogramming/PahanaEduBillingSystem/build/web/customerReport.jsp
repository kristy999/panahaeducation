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
            table {
                width: 90%;
                margin: 20px auto;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #4CAF50;
                color: white;
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
            <form action="ExportServlet" method="get" style="margin-top:20px;">
                <input type="hidden" name="type" value="csv">
                <input type="hidden" name="report" value="customer">
                <input type="submit" class="export-btn" value="Export Customers as CSV">
            </form>

        </div>
    </body>
</html>
