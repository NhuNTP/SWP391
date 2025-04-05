<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Model.OrderDetail"%>
<%@page import="DAO.CustomerDAO"%>
<%@page import="DAO.AccountDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Account"%>
<%@page import="DAO.MenuDAO"%>
<%@page import="Model.Dish"%>
<%@page import="java.util.List"%>
<%@page import="Model.Order"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

    AccountDAO accountDAO = new AccountDAO();
    CustomerDAO customerDAO = new CustomerDAO();
    SimpleDateFormat timeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm"); // Định dạng giờ:phút
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
        .sidebar { background: linear-gradient(to bottom, #2C3E50, #34495E); color: white; height: 100vh; }
        .sidebar a { color: white; text-decoration: none; }
        .sidebar a:hover { background-color: #1A252F; }
        .main-content-area { padding: 20px; }
        .content-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .content-header h2 { margin-top: 0; font-size: 24px; }
        .search-bar input { padding: 8px 12px; border: 1px solid #ccc; border-radius: 3px; width: 250px; }
        .table-responsive { overflow-x: auto; }
        .btn-edit, .btn-delete { padding: 5px 10px; border-radius: 5px; color: white; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-edit { background-color: #007bff; }
        .btn-edit:hover { background-color: #0056b3; }
        .btn-delete { background-color: #dc3545; margin-left: 5px; }
        .btn-delete:hover { background-color: #c82333; }
        .btn-edit i, .btn-delete i { margin-right: 5px; }
        .header-buttons .btn-info { background-color: #007bff; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; }
        .header-buttons .btn-info:hover { background-color: #0056b3; }
        .no-data { padding: 20px; text-align: center; color: #777; }
        .sidebar .nav-link { font-size: 0.9rem; }
        .sidebar h4 { font-size: 1.5rem; }
        .modal-header { background-color: #f7f7f0; }
        .table { width: 100%; margin-bottom: 1rem; background-color: #fff; }
        .table th, .table td { padding: 12px; vertical-align: middle; text-align: left; }
        .table thead th { background-color: #343a40; color: white; border-color: #454d55; }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
        .table-bordered { border: 1px solid #dee2e6; }
        .table-bordered th, .table-bordered td { border: 1px solid #dee2e6; }
        .text-left.mb-4 { background: linear-gradient(to right, #2C3E50, #42A5F5); padding: 1rem; color: white; margin-left: -24px !important; margin-top: -25px !important; margin-right: -25px !important; }
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
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link active"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
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

        <div class="col-md-10 p-4 main-content-area">
            <section class="main-content">
                <div class="text-left mb-4">
                    <h4>Order Management</h4>
                </div>
                <div class="container-fluid">
                    <main>
                        <div class="content-header">
                            <div class="search-filter">
                                <div class="search-bar">
                                    <input type="text" id="searchInput" placeholder="Search">
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>Order ID</th>
                                        <th>Username</th>
                                        <th>Customer Name</th>
                                        <th>Order Time</th>
                                        <th>Order Status</th>
                                        <th>Dishes</th>
                                    </tr>
                                    <tr id="noResultsRow" style="display: none;">
                                        <td colspan="7" style="text-align: center; color: gray">Order Not Found.</td>
                                    </tr>
                                </thead>
                                <tbody id="orderTableBody">
                                    <%
                                        List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                        if (orderList != null && !orderList.isEmpty()) {
                                            int displayIndex = 1;
                                            for (Order order : orderList) {
                                                String userName = order.getUserId() != null ? accountDAO.getAccountById(order.getUserId()).getUserName() : "N/A";
                                                String customerName = order.getCustomerId() != null ? customerDAO.getCustomerById(order.getCustomerId()).getCustomerName() : "N/A";
                                    %>
                                    <tr id="orderRow<%=order.getOrderId()%>">
                                        <td><%= displayIndex++%></td>
                                        <td><%= order.getOrderId()%></td>
                                        <td><%= userName%></td>
                                        <td><%= customerName%></td>
                                        <td><%= timeFormat.format(order.getOrderDate())%></td>
                                        <td><%= order.getOrderStatus()%></td>
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
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="7"><div class="no-data">No Orders Found.</div></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </main>
                </div>
            </section>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            // Gắn sự kiện tìm kiếm
            $('#searchInput').on('keyup', function () {
                var searchText = $(this).val().trim().toLowerCase();
                var $rows = $('#orderTableBody tr:not(#noResultsRow)');
                var foundMatch = false;

                $rows.each(function () {
                    var orderId = $(this).find('td:nth-child(2)').text().toLowerCase();
                    var userName = $(this).find('td:nth-child(3)').text().toLowerCase();
                    var customerName = $(this).find('td:nth-child(4)').text().toLowerCase();
                    var orderStatus = $(this).find('td:nth-child(6)').text().toLowerCase();

                    if (orderId.includes(searchText) || userName.includes(searchText) || 
                        customerName.includes(searchText) || orderStatus.includes(searchText)) {
                        $(this).show();
                        foundMatch = true;
                    } else {
                        $(this).hide();
                    }
                });

                $('#noResultsRow').toggle(!foundMatch && searchText !== '');
            });
        });
    </script>
</body>
</html>