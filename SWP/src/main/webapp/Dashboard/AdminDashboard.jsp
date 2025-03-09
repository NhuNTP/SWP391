<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="Model.Account" %>
<%
    // Kiểm tra session
   
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    // Lấy đối tượng Account từ session
    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
    String UserName = account.getUserName();

    // Kiểm tra vai trò: chỉ Admin và Manager được truy cập
    if (!"Admin".equals(UserRole) && !"Manager".equals(UserRole)) {
        response.sendRedirect(request.getContextPath() + "/LoginPaage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard <%= UserRole %> - Quản Lý Quán Ăn</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Custom Styles */
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }

        /* Sidebar Styles */
        .sidebar {
            background: linear-gradient(to bottom, #2C3E50, #34495E);
            color: white;
            height: 100vh;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
        }

        .sidebar a:hover {
            background-color: #1A252F;
        }

        /* Card Stats Styles */
        .card-stats {
            background: linear-gradient(to right, #4CAF50, #81C784);
            color: white;
        }

        .card-stats i {
            font-size: 2rem;
        }

        /* Chart Container Styles */
        .chart-container {
            position: relative;
            height: 300px;
        }

        .sidebar .nav-link {
            font-size: 0.9rem;
        }

        .sidebar h4 {
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar col-md-2 p-3">
            <h4 class="text-center mb-4"><%= UserRole %></h4> <!-- Hiển thị vai trò -->
            <ul class="nav flex-column">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>View Notifications</a></li>
                        <% if ("Admin".equals(UserRole) || "Manager".equals(UserRole)) { %>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>
                        <% } %>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Dashboard</h3>
                <div class="d-flex align-items-center">
                    <span class="me-2">Hello, <%= UserName %></span> <!-- Hiển thị tên người dùng -->
                    <img src="https://via.placeholder.com/40" alt="Avatar" class="rounded-circle">
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card card-stats p-3 text-center">
                        <i class="fas fa-dollar-sign"></i>
                        <h5 class="mt-2">Today's Revenue</h5>
                        <p class="mb-0">5,000,000 VNĐ</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stats p-3 text-center" style="background: linear-gradient(to right, #FF9800, #FFB74D);">
                        <i class="fas fa-shopping-cart"></i>
                        <h5 class="mt-2">Number of new orders</h5>
                        <p class="mb-0">25 orders</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stats p-3 text-center" style="background: linear-gradient(to right, #03A9F4, #4FC3F7);">
                        <i class="fas fa-utensils"></i>
                        <h5 class="mt-2">Number of dishes for sale</h5>
                        <p class="mb-0">50 dishes</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stats p-3 text-center" style="background: linear-gradient(to right, #E91E63, #F06292);">
                        <i class="fas fa-users"></i>
                        <h5 class="mt-2">Number of employees working</h5>
                        <p class="mb-0">10 employees</p>
                    </div>
                </div>
            </div>

            <!-- Revenue Chart -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="card p-4">
                        <h5>Revenue chart</h5>
                        <canvas id="revenueChart" class="chart-container"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-4">
                        <h5>Top selling dishes</h5>
                        <canvas id="topItemsChart" class="chart-container"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Orders Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card p-4">
                        <h5>Recent Orders</h5>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Customer name</th>
                                    <th>Total amount</th>
                                    <th>Status</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>#12345</td>
                                    <td>Nguyễn Văn A</td>
                                    <td>500,000 VNĐ</td>
                                    <td><span class="badge bg-warning">Pending processing</span></td>
                                    <td>2023-10-01 14:30</td>
                                </tr>
                                <tr>
                                    <td>#12346</td>
                                    <td>Lê Thị B</td>
                                    <td>300,000 VNĐ</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                    <td>2023-10-01 15:00</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js Scripts -->
    <script>
        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                datasets: [{
                    label: 'Revenue (VNĐ)',
                    data: [1000000, 1500000, 2000000, 1800000, 2500000, 3000000, 2800000],
                    borderColor: '#4CAF50',
                    backgroundColor: 'rgba(76, 175, 80, 0.2)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    }
                }
            }
        });

        // Top Items Chart
        const topItemsCtx = document.getElementById('topItemsChart').getContext('2d');
        const topItemsChart = new Chart(topItemsCtx, {
            type: 'pie',
            data: {
                labels: ['Phở', 'Bún bò', 'Cơm tấm', 'Gà rán', 'Bánh mì'],
                datasets: [{
                    data: [30, 25, 20, 15, 10],
                    backgroundColor: ['#4CAF50', '#FF9800', '#03A9F4', '#E91E63', '#9C27B0']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    }
                }
            }
        });
    </script>
</body>
</html>