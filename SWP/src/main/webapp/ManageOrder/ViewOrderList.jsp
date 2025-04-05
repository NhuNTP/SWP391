<%@page import="Model.OrderDetail"%>
<%@page import="Model.Table"%>
<%@page import="DAO.TableDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Account"%>
<%@page import="DAO.MenuDAO"%>
<%@page import="Model.Dish"%>
<%@page import="java.util.List"%>
<%@page import="Model.Order"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    List<Dish> dishList = null;
%>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();

    MenuDAO menuDAO = new MenuDAO();
    try {
        dishList = menuDAO.getAllDishes();
    } catch (Exception e) {
        e.printStackTrace();
        dishList = new ArrayList<>();
    }
    request.setAttribute("dishList", dishList);

    System.out.println("Dish list size: " + (dishList != null ? dishList.size() : "null"));
    if (dishList != null) {
        for (Dish dish : dishList) {
            System.out.println("Dish ID: " + dish.getDishId() + ", Name: " + dish.getDishName());
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
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
            .sidebar .nav-link {
                font-size: 0.9rem;
            }
            .sidebar h4 {
                font-size: 1.5rem;
            }
            .main-content-area {
                padding: 20px;
            }
            .content-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .search-bar input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: 250px;
            }
            .table-responsive {
                overflow-x: auto;
            }
            .btn-edit, .btn-detail {
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            .btn-edit {
                background-color: #007bff;
            }
            .btn-edit:hover {
                background-color: #0056b3;
            }
            .btn-detail {
                background-color: #28a745;
            }
            .btn-detail:hover {
                background-color: #218838;
            }
            .btn-edit i, .btn-detail i {
                margin-right: 5px;
            }
            .header-buttons .btn-info {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
            }
            .header-buttons .btn-info:hover {
                background-color: #0056b3;
            }
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
            }
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

            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="text-left mb-4"><h4>Order Management</h4></div>
                    <div class="container-fluid">
                        <div class="content-header">
                            <div class="search-bar">
                                <input type="text" class="form-control" placeholder="Search" id="searchInput">
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>Order ID</th>
                                        <th>User ID</th>
                                        <th>Customer ID</th>
                                        <th>Order Date</th>
                                        <th>Order Status</th>
                                        <th>Order Type</th>
                                        <th>Dishes</th>
                                    </tr>
                                </thead>
                                <tbody id="orderTableBody">
                                    <%
                                        List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                        if (orderList != null && !orderList.isEmpty()) {
                                            int displayIndex = 1;
                                            for (Order order : orderList) {
                                                String orderDetailsJson = "[]";
                                                if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
                                                    try {
                                                        orderDetailsJson = new Gson().toJson(order.getOrderDetails());
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                        orderDetailsJson = "[]";
                                                    }
                                                }
                                    %>
                                    <tr id="orderRow<%=order.getOrderId()%>">
                                        <td><%= displayIndex++%></td>
                                        <td><%= order.getOrderId()%></td>
                                        <td><%= order.getUserId()%></td>
                                        <td><%= order.getCustomerId()%></td>
                                        <td><%= order.getOrderDate()%></td>
                                        <td><%= order.getOrderStatus()%></td>
                                        <td><%= order.getOrderType()%></td>
                                        <td>
                                            <%
                                                List<OrderDetail> details = order.getOrderDetails();
                                                if (details != null && !details.isEmpty()) {
                                                    StringBuilder dishSummary = new StringBuilder();
                                                    for (OrderDetail detail : details) {
                                                        dishSummary.append(detail.getDishName()).append(" (").append(detail.getQuantity()).append("), ");
                                                    }
                                                    out.print(dishSummary.substring(0, dishSummary.length() - 2));
                                                } else {
                                                    out.print("No dishes");
                                                }
                                            %>
                                            <%
                                                }
                                            } else {
                                            %>
                                    <tr><td colspan="9"><div class="no-data">No Orders Found.</div></td></tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </div>
        </div>
        <script>
            function filterTable() {
                const searchText = document.getElementById('searchInput').value.toLowerCase();
                const rows = document.querySelectorAll('#orderTableBody tr:not(.no-data-row)');
                let hasResults = false;

                rows.forEach(row => {
                    const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const userId = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                    const customerId = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                    const orderStatus = row.querySelector('td:nth-child(6)').textContent.toLowerCase();
                    const orderType = row.querySelector('td:nth-child(7)').textContent.toLowerCase();

                    let matchesSearch = (id.includes(searchText)) || (userId.includes(searchText)) ||
                            (customerId.includes(searchText)) || (orderStatus.includes(searchText)) ||
                            (orderType.includes(searchText));

                    if (matchesSearch) {
                        row.style.display = '';
                        hasResults = true;
                    } else {
                        row.style.display = 'none';
                    }
                });

                const noDataRow = document.querySelector('#orderTableBody .no-data-row');
                if (noDataRow)
                    noDataRow.remove();

                if (!hasResults && searchText !== "") {
                    const newRow = document.createElement('tr');
                    newRow.classList.add('no-data-row');
                    newRow.innerHTML = '<td colspan="9" class="no-data"><i class="fas fa-exclamation-triangle"></i> No matching orders found.</td>';
                    document.getElementById('orderTableBody').appendChild(newRow);
                }
            }


        </script>
    </body>
</html>