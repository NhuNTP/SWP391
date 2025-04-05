<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        table {
            width: 50%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .profile-img {
            max-width: 100px;
            height: auto;
            border-radius: 50%;
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
        .sidebar .nav-link {
            font-size: 0.9rem;
        }
        .sidebar h4 {
            font-size: 1.5rem;
        }
        .content {
            padding: 20px;
        }
    </style>
</head>
<body>
    <%
        Account account = (Account) request.getAttribute("account");
        if (account == null) {
            out.println("<p style='text-align: center; color: red;'>No account information available.</p>");
        } else {
            String userRole = account.getUserRole();
    %>
    <div class="d-flex">
        <% if ("Admin".equals(userRole)) { %>
        <div class="sidebar col-md-2 p-3">
            <h4 class="text-center mb-4"><%= userRole %></h4>
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
                <% if ("Admin".equals(userRole) || "Manager".equals(userRole)) { %>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>
                <% } %>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
            </ul>
        </div>
        <div class="col-md-10 content">
        <% } else { %>
        <div class="col-md-12 content">
        <% } %>
            <h1 style="text-align: center;">Account Profile</h1>
            <table>
                <tr>
                    <th>Attribute</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>User ID</td>
                    <td><%= account.getUserId() %></td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td><%= account.getUserEmail() %></td>
                </tr>
                <tr>
                    <td>Phone</td>
                    <td><%= account.getUserPhone() %></td>
                </tr>
                <tr>
                    <td>Name</td>
                    <td><%= account.getUserName() %></td>
                </tr>
                <tr>
                    <td>Role</td>
                    <td><%= account.getUserRole() %></td>
                </tr>
                <tr>
                    <td>Identity Card</td>
                    <td><%= account.getIdentityCard() != null ? account.getIdentityCard() : "N/A" %></td>
                </tr>
                <tr>
                    <td>Address</td>
                    <td><%= account.getUserAddress() != null ? account.getUserAddress() : "N/A" %></td>
                </tr>
                <tr>
                    <td>Image</td>
                    <td>
                        <%
                            String userImage = account.getUserImage();
                       
                                String imagePath = request.getContextPath() + "/ManageAccount/account_img/" + userImage;
                                out.println("<img src='" + imagePath + "' alt='User Image' class='profile-img'>");
                           
                        %>
                    </td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td><%= account.isIsDeleted() ? "Deleted" : "Active" %></td>
                </tr>
            </table>
            <div style="text-align: center;">
                <a href="javascript:history.back()" class="btn btn-secondary">Back</a>
            </div>
        </div>
    </div>
    <%
        }
    %>
</body>
</html>