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
                            <div class="header-buttons">
                                <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addOrderModal"><i class="fas fa-plus"></i> Add New</button>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
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
                                        <th>Actions</th>
                                    </tr>
                                    <tr id="noResultsRow" style="display: none;">
                                        <td colspan="9" style="text-align: center; color: gray">Order Not Found.</td>
                                    </tr>
                                </thead>
                                <tbody id="orderTableBody">
                                    <%
                                        List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                        if (orderList != null && !orderList.isEmpty()) {
                                            int displayIndex = 1;
                                            for (Order order : orderList) {
                                                String orderDetailsJson = new Gson().toJson(order.getOrderDetails() != null ? order.getOrderDetails() : new ArrayList<>());
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
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-edit btn-update-order" data-bs-toggle="modal" data-bs-target="#updateOrderModal" 
                                                    data-order-id="<%= order.getOrderId()%>" data-order-details='<%= orderDetailsJson%>'>
                                                <i class="fas fa-edit"></i> Update
                                            </button>
                                            <button type="button" class="btn btn-delete btn-delete-order" data-bs-toggle="modal" data-bs-target="#deleteOrderModal" 
                                                    data-order-id="<%= order.getOrderId()%>">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="9"><div class="no-data">No Orders Found.</div></td>
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

    <!-- Add Order Modal -->
    <div class="modal fade" id="addOrderModal" tabindex="-1" aria-labelledby="addOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addOrderModalLabel">Add New Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addOrderForm">
                        <div class="mb-3 row">
                            <label for="userId" class="col-sm-4 col-form-label">User ID:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="userId" name="userId" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="customerId" class="col-sm-4 col-form-label">Customer ID:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="customerId" name="customerId" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="orderStatus" class="col-sm-4 col-form-label">Order Status:</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="orderStatus" name="orderStatus" required>
                                    <option value="Pending">Pending</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="orderType" class="col-sm-4 col-form-label">Order Type:</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="orderType" name="orderType" required>
                                    <option value="Dine-in">Dine-in</option>
                                    <option value="Takeaway">Takeaway</option>
                                    <option value="Delivery">Delivery</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="btnAddOrder">Add Order</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Order Modal -->
    <div class="modal fade" id="updateOrderModal" tabindex="-1" aria-labelledby="updateOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateOrderModalLabel">Update Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="updateOrderForm">
                        <div class="mb-3 row">
                            <label for="orderIdUpdateDisplay" class="col-sm-4 col-form-label">Order ID:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="orderIdUpdateDisplay" readonly>
                                <input type="hidden" id="orderIdUpdate" name="orderId">
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="userIdUpdate" class="col-sm-4 col-form-label">User ID:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="userIdUpdate" name="userId" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="customerIdUpdate" class="col-sm-4 col-form-label">Customer ID:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="customerIdUpdate" name="customerId" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="orderStatusUpdate" class="col-sm-4 col-form-label">Order Status:</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="orderStatusUpdate" name="orderStatus" required>
                                    <option value="Pending">Pending</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="orderTypeUpdate" class="col-sm-4 col-form-label">Order Type:</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="orderTypeUpdate" name="orderType" required>
                                    <option value="Dine-in">Dine-in</option>
                                    <option value="Takeaway">Takeaway</option>
                                    <option value="Delivery">Delivery</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="btnUpdateOrder">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Order Modal -->
    <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteOrderModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this order?</p>
                    <input type="hidden" id="orderIdDelete">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="btnDeleteOrderConfirm">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    <script>
    $(document).ready(function () {
        // Gắn sự kiện ban đầu
        bindEventHandlers();
        reloadViewOrders();

        // Xử lý thêm đơn hàng
        $('#btnAddOrder').click(function () {
            var userId = $('#userId').val().trim();
            var customerId = $('#customerId').val().trim();
            var orderStatus = $('#orderStatus').val();
            var orderType = $('#orderType').val();

            var isValid = true;
            $('.error-message').remove();
            $('.is-invalid').removeClass('is-invalid');

            if (!userId) {
                isValid = false;
                displayError('userId', 'Please enter user ID');
            }
            if (!customerId) {
                isValid = false;
                displayError('customerId', 'Please enter customer ID');
            }

            if (isValid) {
                $.ajax({
                    url: 'AddOrder', // Thay bằng URL endpoint thực tế
                    type: 'POST',
                    data: { userId: userId, customerId: customerId, orderStatus: orderStatus, orderType: orderType },
                    success: function () {
                        $('#addOrderModal').modal('hide');
                        reloadViewOrders();
                        Swal.fire('Success', 'Order added successfully', 'success');
                        $('#addOrderForm')[0].reset();
                    },
                    error: function (xhr) {
                        Swal.fire('Error', xhr.responseText || 'Failed to add order', 'error');
                    }
                });
            }
        });

        // Xử lý cập nhật đơn hàng
        $('#btnUpdateOrder').click(function () {
            var orderId = $('#orderIdUpdate').val();
            var userId = $('#userIdUpdate').val().trim();
            var customerId = $('#customerIdUpdate').val().trim();
            var orderStatus = $('#orderStatusUpdate').val();
            var orderType = $('#orderTypeUpdate').val();

            var isValid = true;
            $('.error-message').remove();
            $('.is-invalid').removeClass('is-invalid');

            if (!userId) {
                isValid = false;
                displayError('userIdUpdate', 'Please enter user ID');
            }
            if (!customerId) {
                isValid = false;
                displayError('customerIdUpdate', 'Please enter customer ID');
            }

            if (isValid) {
                $.ajax({
                    url: 'UpdateOrder', // Thay bằng URL endpoint thực tế
                    type: 'POST',
                    data: { orderId: orderId, userId: userId, customerId: customerId, orderStatus: orderStatus, orderType: orderType },
                    success: function () {
                        $('#updateOrderModal').modal('hide');
                        reloadViewOrders();
                        Swal.fire('Success', 'Order updated successfully', 'success');
                    },
                    error: function (xhr) {
                        Swal.fire('Error', xhr.responseText || 'Failed to update order', 'error');
                    }
                });
            }
        });

        // Xử lý xóa đơn hàng
        $('#btnDeleteOrderConfirm').click(function () {
            var orderId = $('#orderIdDelete').val();
            $.ajax({
                url: 'DeleteOrder', // Thay bằng URL endpoint thực tế
                type: 'GET',
                data: { orderId: orderId },
                success: function () {
                    $('#deleteOrderModal').modal('hide');
                    $('#orderRow' + orderId).remove();
                    if ($('#orderTableBody tr').length === 0) {
                        $('#orderTableBody').html('<tr><td colspan="9"><div class="no-data">No Orders Found.</div></td></tr>');
                    }
                    reloadViewOrders();
                    Swal.fire('Success', 'Order deleted successfully', 'success');
                },
                error: function (xhr) {
                    $('#deleteOrderModal').modal('hide');
                    Swal.fire('Error', xhr.responseText || 'Failed to delete order', 'error');
                }
            });
        });

        // Hàm hiển thị lỗi
        function displayError(fieldId, message) {
            $('#' + fieldId).addClass('is-invalid');
            $('#' + fieldId).after('<div class="error-message" style="color: red;">' + message + '</div>');
        }

        // Gắn sự kiện cho nút Update và Delete
        function bindEventHandlers() {
            $('.btn-update-order').off('click').on('click', function () {
                var orderId = $(this).data('order-id');
                var orderDetails = $(this).data('order-details'); // JSON của order details
                $('#orderIdUpdate').val(orderId);
                $('#orderIdUpdateDisplay').val(orderId);
                $('#userIdUpdate').val($(this).closest('tr').find('td:nth-child(3)').text());
                $('#customerIdUpdate').val($(this).closest('tr').find('td:nth-child(4)').text());
                $('#orderStatusUpdate').val($(this).closest('tr').find('td:nth-child(6)').text());
                $('#orderTypeUpdate').val($(this).closest('tr').find('td:nth-child(7)').text());
            });

            $('.btn-delete-order').off('click').on('click', function () {
                var orderId = $(this).data('order-id');
                $('#orderIdDelete').val(orderId);
            });
        }

        // Tải lại danh sách đơn hàng
        function reloadViewOrders() {
            $.ajax({
                url: 'ViewOrderList', // Thay bằng URL endpoint thực tế
                type: 'GET',
                cache: false,
                success: function (data) {
                    var newBody = $(data).find('#orderTableBody').html();
                    $('#orderTableBody').html(newBody);
                    bindEventHandlers(); // Gắn lại sự kiện sau khi tải lại
                },
                error: function (xhr) {
                    console.error('Error reloading order list:', xhr.responseText);
                }
            });
        }

        // Tìm kiếm đơn hàng
        $('#searchInput').on('keyup', function () {
            var searchText = $(this).val().trim().toLowerCase();
            var $rows = $('#orderTableBody tr:not(#noResultsRow)');
            var foundMatch = false;

            $rows.each(function () {
                var orderId = $(this).find('td:nth-child(2)').text().toLowerCase();
                var userId = $(this).find('td:nth-child(3)').text().toLowerCase();
                var customerId = $(this).find('td:nth-child(4)').text().toLowerCase();
                var orderStatus = $(this).find('td:nth-child(6)').text().toLowerCase();
                var orderType = $(this).find('td:nth-child(7)').text().toLowerCase();

                if (orderId.includes(searchText) || userId.includes(searchText) || customerId.includes(searchText) || 
                    orderStatus.includes(searchText) || orderType.includes(searchText)) {
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