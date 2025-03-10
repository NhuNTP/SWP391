<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="Model.Account" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String userRole = account.getUserRole();
    if (!"Admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    DecimalFormat currencyFormat = new DecimalFormat("#,### VNĐ");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Revenue - Restaurant Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
        .sidebar { background: linear-gradient(to bottom, #2C3E50, #34495E); color: white; height: 100vh; }
        .sidebar a { color: white; text-decoration: none; }
        .sidebar a:hover { background-color: #1A252F; }
        .card-stats { background: linear-gradient(to right, #4CAF50, #81C784); color: white; }
        .card-stats i { font-size: 3rem; }
        .chart-container { position: relative; height: 400px; }
        .sidebar .nav-link { font-size: 0.9rem; }
        .sidebar h4 { font-size: 1.5rem; }
    </style>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar col-md-2 p-3">
            <h4 class="text-center mb-4">Admin</h4>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/view-revenue" class="nav-link"><i class="fas fa-chart-line me-2"></i>View Revenue</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>View Notifications</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
            </ul>
        </div>

        <div class="col-md-10 p-4">
            <h3>View Revenue</h3>

            <!-- Bộ lọc thời gian -->
            <div class="mb-4">
                <form action="${pageContext.request.contextPath}/view-revenue" method="get" class="d-flex align-items-center">
                    <label for="period" class="me-2">Select Period:</label>
                    <select name="period" id="period" class="form-select w-auto me-2" onchange="this.form.submit()">
                        <option value="day" <%= "day".equals(request.getAttribute("period")) ? "selected" : "" %>>Day</option>
                        <option value="week" <%= "week".equals(request.getAttribute("period")) ? "selected" : "" %>>Week</option>
                        <option value="month" <%= "month".equals(request.getAttribute("period")) ? "selected" : "" %>>Month</option>
                        <option value="year" <%= "year".equals(request.getAttribute("period")) ? "selected" : "" %>>Year</option>
                    </select>
                </form>
            </div>

            <!-- Tổng doanh thu -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card card-stats p-4 text-center">
                        <i class="fas fa-dollar-sign"></i>
                        <h5 class="mt-2">Total Revenue (<%= request.getAttribute("period") %>)</h5>
                        <p class="mb-0 fs-3"><%= currencyFormat.format(request.getAttribute("totalRevenue")) %></p>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ doanh thu -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card p-4">
                        <h5>Revenue by <%= request.getAttribute("period") %></h5>
                        <canvas id="revenueChart" class="chart-container"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js Script -->
    <script>
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueData = {
            labels: [<% Map<String, Double> revenueByPeriod = (Map<String, Double>) request.getAttribute("revenueByPeriod");
                        if (revenueByPeriod != null && !revenueByPeriod.isEmpty()) {
                            for (String key : revenueByPeriod.keySet()) { %>
                                '<%= key %>',
                        <% } } %>],
            datasets: [{
                label: 'Revenue (VNĐ)',
                data: [<% if (revenueByPeriod != null && !revenueByPeriod.isEmpty()) {
                            for (Double revenue : revenueByPeriod.values()) { %>
                                <%= revenue %>,
                        <% } } %>],
                backgroundColor: 'rgba(76, 175, 80, 0.2)',
                borderColor: '#4CAF50',
                borderWidth: 2,
                fill: true
            }]
        };
        const revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: revenueData,
            options: {
                responsive: true,
                plugins: {
                    legend: { display: true }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Revenue (VNĐ)' }
                    },
                    x: {
                        title: { display: true, text: '<%= request.getAttribute("period") %>' }
                    }
                }
            }
        });
    </script>
</body>
</html>