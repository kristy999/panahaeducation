<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Use the implicit session object directly (no redeclaration)
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (username == null) {
        response.sendRedirect("login.jsp");
        return; // stop further processing
    }
%>
<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }
        .navbar {
            background-color: #1976D2;
            padding: 15px;
            color: white;
            text-align: right;
        }
        .content {
            padding: 30px;
        }
        .logout {
            color: white;
            text-decoration: none;
            font-weight: bold;
            margin-left: 20px;
        }
        .welcome {
            float: left;
            color: white;
            font-weight: bold;
        }
        canvas {
            max-width: 600px;
            margin-bottom: 40px;
            background: white;
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="content">
        <h2>Dashboard</h2>
        <p>This is the secure area after login. Here you can add your billing system modules like:</p>
        <ul>
            <li>Customer Management</li>
            <li>Item Management</li>
            <li>Billing</li>
            <li>Help Section</li>
        </ul>

        <h3>Transactions in last 7 days</h3>
        <canvas id="transactionCountChart"></canvas>
        <canvas id="transactionAmountChart"></canvas>

        <h3>User Count</h3>
        <p><strong>Total Users:</strong> <span id="totalUsers"></span></p>

        <h3>Total Items</h3>
        <p><strong>Items in Inventory:</strong> <span id="totalItems"></span></p>

        <h3>User Roles Distribution</h3>
        <canvas id="userRolesChart"></canvas>
    </div>

    <script>
    fetch('adminDashboardData')
        .then(res => res.json())
        .then(data => {
            // Transaction count line chart
            const dates = data.transactions.map(t => t.date);
            const txnCounts = data.transactions.map(t => t.count);
            const txnAmounts = data.transactions.map(t => t.totalAmount);

            const ctxCount = document.getElementById('transactionCountChart').getContext('2d');
            new Chart(ctxCount, {
                type: 'line',
                data: {
                    labels: dates,
                    datasets: [{
                        label: 'Number of Transactions',
                        data: txnCounts,
                        borderColor: 'rgba(75, 192, 192, 1)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    scales: { y: { beginAtZero: true } }
                }
            });

            // Transaction amount line chart
            const ctxAmount = document.getElementById('transactionAmountChart').getContext('2d');
            new Chart(ctxAmount, {
                type: 'line',
                data: {
                    labels: dates,
                    datasets: [{
                        label: 'Total Amount (LKR)',
                        data: txnAmounts,
                        borderColor: 'rgba(255, 159, 64, 1)',
                        backgroundColor: 'rgba(255, 159, 64, 0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    scales: { y: { beginAtZero: true } }
                }
            });

            // User count text
            document.getElementById('totalUsers').textContent = data.userCount;

            // Item count text
            document.getElementById('totalItems').textContent = data.itemCount;

            // User roles pie chart
            const roles = Object.keys(data.userRoles).map(r => {
                switch(r) {
                    case "0": return "Normal User";
                    case "1": return "Admin";
                    case "2": return "Other Role";
                    default: return "Role " + r;
                }
            });
            const roleCounts = Object.values(data.userRoles);

            const ctxRoles = document.getElementById('userRolesChart').getContext('2d');
            new Chart(ctxRoles, {
                type: 'doughnut',
                data: {
                    labels: roles,
                    datasets: [{
                        label: 'User Roles',
                        data: roleCounts,
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.6)',
                            'rgba(255, 99, 132, 0.6)',
                            'rgba(255, 206, 86, 0.6)'
                        ],
                        borderColor: 'white',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true
                }
            });
        })
        .catch(err => {
            console.error('Error loading dashboard data:', err);
        });
    </script>
</body>
</html>
