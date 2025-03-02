<%-- 
    Document   : ViewOrderList
    Created on : Feb 27, 2025, 4:24:31 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="DAO.OrderDAO"%>
<%@page import="Model.Order"%>
<%@page import="Model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Order List</title>
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

            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }

            .card-stats i {
                font-size: 2rem;
            }

            .chart-container {
                position: relative;
                height: 300px;
            }
        </style>
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-utensils me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Inventory Management</a></li>
                </ul>
            </div>
            <h2>Order List</h2>
            <button onclick="window.location.href = 'CreateOrder'">Add Order</button>

            <table border="1">
                <tr>
                    <th>Order ID</th>
                    <th>User ID</th>
                    <th>Customer ID</th>
                    <th>Order Date</th>
                    <th>Order Status</th>
                    <th>Order Type</th>
                    <th>Order Description</th>
                    <th>Coupon ID</th>
                    <th>Table ID</th>
                    <th>Actions</th>
                </tr>
                <%
                    List<Order> orders = (List<Order>) request.getAttribute("orderList");
                    if (orders != null) {
                        for (Order order : orders) {
                %>
                <tr>
                    <td><%= order.getOrderId()%></td>
                    <td><%= order.getUserId()%></td>
                    <td><%= order.getCustomerId()%></td>
                    <td><%= order.getOrderDate()%></td>
                    <td><%= order.getOrderStatus()%></td>
                    <td><%= order.getOrderType()%></td>
                    <td><%= order.getOrderDescription()%></td>
                    <td><%= order.getCouponId()%></td>
                    <td><%= order.getTableId()%></td>
                    <td>
                        <a href="UpdateOrder?orderId=<%= order.getOrderId()%>" class="btn btn-profile">Update</a>
                        <a href="ViewOrderDetail?orderId=<%= order.getOrderId()%>" class="btn btn-profile">Detail</a>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="10">No orders found.</td>
                </tr>
                <% }%>
            </table>

    </body>
</html>