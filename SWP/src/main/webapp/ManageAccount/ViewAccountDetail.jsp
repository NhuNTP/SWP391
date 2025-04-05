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
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }
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
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #343a40;
            padding-top: 20px;
            transition: 0.3s;
            z-index: 1000;
            color: white;
        }
        .sidebar .nav-link {
            color: #fff;
            padding: 15px 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: 0.3s;
            font-size: 16px;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        .sidebar .nav-link:hover {
            background-color: #495057;
            color: #fff;
        }
        .sidebar .nav-link.active {
            background-color: #007bff;
            color: #fff;
        }
        .sidebar h4 {
            color: #fff;
            text-align: center;
            padding: 20px 0;
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .content {
            padding: 20px;
            margin-left: 250px; /* Default margin for sidebar */
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }
            .content {
                margin-left: 200px;
            }
        }
        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .content {
                margin-left: 0;
            }
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
        <!-- Sidebar -->
        <% if ("Waiter".equals(userRole)) { %>
        <div class="sidebar">
            <h4>Waiter Dashboard</h4>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/order?action=listTables" class="nav-link">
                        <i class="fas fa-building"></i> Table List
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/view-notifications" class="nav-link">
                        <i class="fas fa-bell"></i> View Notifications
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/viewAccountDetail" class="nav-link active">
                        <i class="fas fa-user"></i> View Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
        <% } else if ("Kitchen staff".equals(userRole)) { %>
        <div class="sidebar">
            <h4>Kitchen Dashboard</h4>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/kitchen" class="nav-link">
                        <i class="fas fa-list"></i> Order List
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/view-notifications" class="nav-link">
                        <i class="fas fa-bell"></i> View Notifications
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/viewAccountDetail" class="nav-link active">
                        <i class="fas fa-user"></i> View Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/LoginPage.jsp" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
        <% } else if ("Cashier".equals(userRole)) { %>
        <div class="sidebar">
            <h4>Cashier Dashboard</h4>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/payment?action=listOrders" class="nav-link">
                        <i class="fas fa-money-bill"></i> Payment
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/view-notifications" class="nav-link">
                        <i class="fas fa-bell"></i> View Notifications
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/viewAccountDetail" class="nav-link active">
                        <i class="fas fa-user"></i> View Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
        <% } else if ("Admin".equals(userRole)) { %>
        <div class="sidebar">
            <h4 class="text-center mb-4"><%= userRole %> Dashboard</h4>
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
        <% } %>

        <!-- Main Content -->
        <div class="content <%= "Waiter".equals(userRole) || "Admin".equals(userRole) || "Kitchen staff".equals(userRole) || "Cashier".equals(userRole) ? "col-md-10" : "col-md-12" %>">
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
                    <td><%= account.getUserPhone() != null ? account.getUserPhone() : "N/A" %></td>
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
                            if (userImage != null && !userImage.isEmpty()) {
                                String imagePath = request.getContextPath() + "/ManageAccount/account_img/" + userImage;
                                out.println("<img src='" + imagePath + "' alt='User Image' class='profile-img'>");
                            } else {
                                out.println("N/A");
                            }
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