<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="nav.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="pahanaedu.TransactionReportServlet.Transaction" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Transaction Report</title>
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
            <h2>Transaction Report</h2>

            <%
                if (request.getAttribute("error") != null) {
            %>
            <p class="error-message"><%= request.getAttribute("error")%></p>
            <%
            } else {
                List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                if (transactions != null && !transactions.isEmpty()) {
            %>
            <table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Date</th>
                        <th>Total Amount</th>
                        <th>Account Number</th>
                        <th>Customer Name</th>
                        <th>Customer Email</th>
                        <th>Calculated By</th>
                        <th>Item ID</th>
                        <th>Quantity</th>
                        <th>Item Price</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Transaction t : transactions) {%>
                    <tr>
                        <td><%= t.getBillId()%></td>
                        <td><%= t.getBillDate()%></td>
                        <td><%= t.getTotalAmount()%></td>
                        <td><%= t.getAccountNumber()%></td>
                        <td><%= t.getCustomerName() != null ? t.getCustomerName() : ""%></td>
                        <td><%= t.getCustomerEmail() != null ? t.getCustomerEmail() : ""%></td>
                        <td><%= t.getCalculatedBy()%></td>
                        <td><%= t.getItemId()%></td>
                        <td><%= t.getQuantity()%></td>
                        <td><%= t.getItemPrice()%></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="form-container">
                <form action="ExportServlet" method="get">
                    <input type="hidden" name="type" value="csv">
                    <input type="hidden" name="report" value="transaction">
                    <input type="submit" class="export-btn" value="Export to CSV">
                </form>

                <form action="ExportServlet" method="get">
                    <input type="hidden" name="type" value="pdf">
                    <input type="hidden" name="report" value="transaction">
                    <input type="submit" class="export-btn" value="Export to PDF">
                </form>
            </div>

            <%  } else { %>
            <p class="no-data">No transactions found.</p>
            <%  }
                }
            %>
        </div>
    </body>
</html>
