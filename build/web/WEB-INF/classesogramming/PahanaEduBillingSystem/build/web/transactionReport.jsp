<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="nav.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="pahanaedu.TransactionReportServlet.Transaction" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Transaction Report</title>
    </head>
    <body>
        <div class="container">
            <h2>Transaction Report</h2>

            <%
                if (request.getAttribute("error") != null) {
            %>
            <p style="color:red;"><%= request.getAttribute("error")%></p>
            <%
            } else {
                List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                if (transactions != null && !transactions.isEmpty()) {
            %>
            <table>
                <tr>
                    <th>Bill ID</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Account Number</th>
                    <th>Calculated By</th>
                    <th>Item ID</th>
                    <th>Quantity</th>
                    <th>Item Price</th>
                </tr>
                <% for (Transaction t : transactions) {%>
                <tr>
                    <td><%= t.getBillId()%></td>
                    <td><%= t.getBillDate()%></td>
                    <td><%= t.getTotalAmount()%></td>
                    <td><%= t.getAccountNumber()%></td>
                    <td><%= t.getCalculatedBy()%></td>
                    <td><%= t.getItemId()%></td>
                    <td><%= t.getQuantity()%></td>
                    <td><%= t.getItemPrice()%></td>
                </tr>
                <% } %>
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
            <p>No transactions found.</p>
            <%  }
                }
            %>
        </div>
    </body>
</html>
