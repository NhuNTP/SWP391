<%@page import="Model.Account"%>
<%@page import="java.util.List"%>
<%@page import="Model.Order"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Admin Dashboard</title>
    <!-- Bootstrap 5.3.0 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
          crossorigin="anonymous">
    <!-- Font Awesome Icons (nếu bạn dùng icon) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- jQuery (nếu bạn dùng AJAX) -->
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
            padding: 10px;
            display: block;
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

        /* Main Content Area */
        .main-content-area {
            padding: 20px;
        }

        /* Content Header */
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .content-header h2 {
            margin-top: 0;
            font-size: 24px;
        }

        /* Search Bar */
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 250px;
        }

        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
        }

        /* Nút trong bảng */
        .btn-edit,
        .btn-detail {
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
            /* Màu xanh lá cây */
        }

        .btn-detail:hover {
            background-color: #218838;
        }

        .btn-edit i,
        .btn-detail i {
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

        /* No Data Message */
        .no-data {
            padding: 20px;
            text-align: center;
            color: #777;
        }

        .sidebar .nav-link {
            font-size: 0.9rem;
            /* Hoặc 16px, tùy vào AdminDashboard.jsp */
        }

        .sidebar h4 {
            font-size: 1.5rem;
        }

        /* The Modal (background) */
        .modal {
            display: none;
            /* Hidden by default */
            position: fixed;
            /* Stay in place */
            z-index: 1;
            /* Sit on top */
            left: 0;
            top: 0;
            width: 100%;
            /* Full width */
            height: 100%;
            /* Full height */
            overflow: auto;
            /* Enable scroll if needed */
            background-color: rgba(0, 0, 0, 0.4);
            /* Black w/ opacity */
        }

        /* Modal Content/Box */
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            /* Could be more or less, depending on screen size */
        }
    </style>
    <script>
        function openModal(modalId) {
            document.getElementById(modalId).style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        function openEditModal(button) {
            document.getElementById("updateOrderForm").action = "UpdateOrder";
            document.getElementById("orderIdUpdate").value = button.dataset.orderId;
            document.getElementById("userIdUpdate").value = button.dataset.userId;
            document.getElementById("customerIdUpdate").value = button.dataset.customerId;
            document.getElementById("orderDateUpdate").value = button.dataset.orderDate;
            document.getElementById("orderStatusUpdate").value = button.dataset.orderStatus;
            document.getElementById("orderTypeUpdate").value = button.dataset.orderType;
            document.getElementById("orderDescriptionUpdate").value = button.dataset.orderDescription;
            document.getElementById("couponIdUpdate").value = button.dataset.couponId;
            document.getElementById("tableIdUpdate").value = button.dataset.tableId;

            openModal("updateOrderModal");
        }

        function filterTable() {
            const searchText = searchInput.value.toLowerCase();
            const table = document.querySelector('.table-responsive table tbody');
            const rows = table.querySelectorAll('tr');
            let hasResults = false; // Flag to check if there are any matching rows

            rows.forEach(row => {
                const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const userId = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                const customerId = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const orderStatus = row.querySelector('td:nth-child(6)').textContent.toLowerCase();
                const orderType = row.querySelector('td:nth-child(7)').textContent.toLowerCase();

                let matchesSearch = (id.includes(searchText)) || (userId.includes(searchText)) || (customerId.includes(searchText)) || (orderStatus.includes(searchText)) || (orderType.includes(searchText));

                if (matchesSearch) {
                    row.style.display = ''; // Show the row
                    hasResults = true;
                } else {
                    row.style.display = 'none'; // Hide the row
                }
            });

            const noDataRow = document.querySelector('.table-responsive table tbody .no-data-row');
            if (noDataRow) {
                noDataRow.remove();
            }

            if (!hasResults && searchText !== "") { // Chỉ hiển thị "No matching..." khi có text search
                const newRow = document.createElement('tr');
                newRow.classList.add('no-data-row');
                newRow.innerHTML = '<td colspan="8" class="no-data"><i class="fas fa-exclamation-triangle"></i>  No matching orders found.</td>';
                table.appendChild(newRow);
            }
        }

        function addOrder() {
            $.ajax({
                url: 'CreateOrder',  // URL of your CreateOrder controller
                type: 'POST',
                data: $('#addOrderForm').serialize(),
                success: function (response) {
                    if (response.trim() === "success") {  // Trim whitespace and then compare
                        alert('Order created successfully!');
                        closeModal('addOrderModal');
                        location.reload();
                    }
                    else {
                        alert('Failed to create order: ' + response); // Display the server's error message
                    }
                },
                error: function (xhr, status, error) {
                    alert('Error adding order: ' + error + " " + xhr.responseText);
                }
            });
        }

        function updateOrder() {
            $.ajax({
                url: 'UpdateOrder?' + $('#updateOrderForm').serialize(),
                type: 'POST',
                data: $('#updateOrderForm').serialize(),
                success: function (response) {
                    if (response.trim() === "success") {
                        alert('Order updated successfully!');
                        closeModal('updateOrderModal');
                        location.reload();
                    } else {
                        alert('Failed to update order: ' + response); //Display error
                    }
                },
                error: function (xhr, status, error) {
                    alert('Error updating order: ' + error + " " + xhr.responseText);
                }
            });
        }

        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('keyup', filterTable);
    </script>
</head>

<body>
<div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar col-md-2 p-3">
        <h4 class="text-center mb-4">Admin</h4>
        <ul class="nav flex-column">
            <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i
                    class="fas fa-home me-2"></i>Dashboard</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i
                    class="fas fa-list-alt me-2"></i>Menu Management</a></li>
            <!-- Hoặc fas fa-utensils -->
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i
                    class="fas fa-users me-2"></i>Employee Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i
                    class="fas fa-building me-2"></i>Table Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i
                    class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
            <!-- Hoặc fas fa-users -->
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i
                    class="fas fa-user-friends me-2"></i>Customer Management</a></li>
            <!-- Hoặc fas fa-users -->
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController"
                                     class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
            <!-- Hoặc fas fa-ticket-alt -->
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController"
                                     class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="col-md-10 p-4 main-content-area">
        <section class="main-content">
            <div class="text-left mb-4">
                <h4>Order Management</h4>
            </div>
            <div class="container-fluid">
                <main>
                    <div class="content-header">
                        <div class="search-bar">
                            <input type="text" class="form-control" placeholder="Search" id="searchInput"
                                   onkeyup="filterTable()">
                        </div>
                        <div class="header-buttons">
                            <button type="button" class="btn btn-info" onclick="openModal('addOrderModal')">
                                <i class="fas fa-plus"></i> Add New
                            </button>
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
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="orderTableBody">
                            <%
                                List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                if (orderList != null && !orderList.isEmpty()) {
                                    int displayIndex = 1;
                                    for (Order order : orderList) {
                            %>
                            <tr id="orderRow<%=order.getOrderId()%>">
                                <td>
                                    <%= displayIndex++%>
                                </td>
                                <td>
                                    <%= order.getOrderId()%>
                                </td>
                                <td>
                                    <%= order.getUserId()%>
                                </td>
                                <td>
                                    <%= order.getCustomerId()%>
                                </td>
                                <td>
                                    <%= order.getOrderDate()%>
                                </td>
                                <td>
                                    <%= order.getOrderStatus()%>
                                </td>
                                <td>
                                    <%= order.getOrderType()%>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-edit"
                                            data-order-id="<%= order.getOrderId()%>"
                                            data-user-id="<%= order.getUserId()%>"
                                            data-customer-id="<%= order.getCustomerId()%>"
                                            data-order-date="<%= order.getOrderDate()%>"
                                            data-order-status="<%= order.getOrderStatus()%>"
                                            data-order-type="<%= order.getOrderType()%>"
                                            data-order-description="<%= order.getOrderDescription()%>"
                                            data-coupon-id="<%= order.getCouponId()%>"
                                            data-table-id="<%= order.getTableId()%>"
                                            onclick="openEditModal(this)">
                                        <i class="fas fa-edit"></i> Update
                                    </button>
                                    <a href="ViewOrderDetail?orderId=<%=order.getOrderId()%>"
                                       class="btn btn-detail">
                                        <i class="fas fa-info-circle"></i> Detail
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8">
                                    <div class="no-data">
                                        No Orders Found.
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </section>
    </div>
</div>

<!-- Add Order Modal -->
<div id="addOrderModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Order</h5>
                <button type="button" class="btn-close" onclick="closeModal('addOrderModal')"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addOrderForm" method="POST">
                    <div class="mb-3">
                        <label for="addUserId" class="form-label">User ID:</label>
                        <input type="text" class="form-control" id="addUserId" name="userId" required>
                    </div>
                    <div class="mb-3">
                        <label for="addCustomerId" class="form-label">Customer ID:</label>
                        <input type="text" class="form-control" id="addCustomerId" name="customerId">
                    </div>
                    <div class="mb-3">
                        <label for="addOrderDate" class="form-label">Order Date:</label>
                        <input type="datetime-local" class="form-control" id="addOrderDate" name="orderDate"
                               required>
                    </div>
                    <div class="mb-3">
                        <label for="addOrderStatus" class="form-label">Order Status:</label>
                        <select class="form-control" id="addOrderStatus" name="orderStatus" required>
                            <option value="Pending">Pending</option>
                            <option value="Processing">Processing</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="addOrderType" class="form-label">Order Type:</label>
                        <select class="form-control" id="addOrderType" name="orderType" required>
                            <option value="Dine-in">Dine-in</option>
                            <option value="Takeaway">Takeaway</option>
                            <option value="Delivery">Delivery</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="addOrderDescription" class="form-label">Order Description:</label>
                        <textarea class="form-control" id="addOrderDescription" name="orderDescription"
                                  rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="addCouponId" class="form-label">Coupon ID:</label>
                        <input type="text" class="form-control" id="addCouponId" name="couponId">
                    </div>
                    <div class="mb-3">
                        <label for="addTableId" class="form-label">Table ID:</label>
                        <input type="text" class="form-control" id="addTableId" name="tableId">
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                onclick="closeModal('addOrderModal')">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="addOrder()">Add Order</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<!-- Update Order Modal -->
<div id="updateOrderModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Order</h5>
                <button type="button" class="btn-close" onclick="closeModal('updateOrderModal')"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateOrderForm" method="POST">
                    <input type="hidden" id="orderIdUpdate" name="orderId">
                    <div class="mb-3">
                        <label for="userIdUpdate" class="form-label">User ID:</label>
                        <input type="text" class="form-control" id="userIdUpdate" name="userId" required>
                    </div>
                    <div class="mb-3">
                        <label for="customerIdUpdate" class="form-label">Customer ID:</label>
                        <input type="text" class="form-control" id="customerIdUpdate" name="customerId">
                    </div>
                    <div class="mb-3">
                        <label for="orderDateUpdate" class="form-label">Order Date:</label>
                        <input type="datetime-local" class="form-control" id="orderDateUpdate" name="orderDate"
                               required>
                    </div>
                    <div class="mb-3">
                        <label for="orderStatusUpdate" class="form-label">Order Status:</label>
                        <select class="form-control" id="orderStatusUpdate" name="orderStatus" required>
                            <option value="Pending">Pending</option>
                            <option value="Processing">Processing</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="orderTypeUpdate" class="form-label">Order Type:</label>
                        <select class="form-control" id="orderTypeUpdate" name="orderType" required>
                            <option value="Dine-in">Dine-in</option>
                            <option value="Takeaway">Takeaway</option>
                            <option value="Delivery">Delivery</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="orderDescriptionUpdate" class="form-label">Order Description:</label>
                        <textarea class="form-control" id="orderDescriptionUpdate" name="orderDescription"
                                  rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="couponIdUpdate" class="form-label">Coupon ID:</label>
                        <input type="text" class="form-control" id="couponIdUpdate" name="couponId">
                    </div>
                    <div class="mb-3">
                        <label for="tableIdUpdate" class="form-label">Table ID:</label>
                        <input type="text" class="form-control" id="tableIdUpdate" name="tableId">
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                onclick="closeModal('updateOrderModal')">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="updateOrder()">Save changes</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

</body>

</html>