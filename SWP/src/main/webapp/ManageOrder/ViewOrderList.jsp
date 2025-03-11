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

    // Log để kiểm tra dishList
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
        <!-- Bootstrap 5.3.0 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- jQuery -->
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
            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }
            .card-stats i {
                font-size: 2rem;
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
            .content-header h2 {
                margin-top: 0;
                font-size: 24px;
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
            .modal {
                display: none;
                position: fixed;
                z-index: 1;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
            }
            .modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
                max-width: 700px;
            }
            .dish-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            .dish-table th, .dish-table td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: center;
            }
            .dish-table th {
                background-color: #f2f2f2;
            }
        </style>

        <script>
            function openModal(modalId) {
                document.getElementById(modalId).style.display = "block";
            }
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = "none";
            }

            function increaseQuantity(dishId) {
                var input = document.getElementById("quantity_" + dishId);
                input.value = parseInt(input.value) + 1;
                updateSubtotal(dishId);
            }

            function decreaseQuantity(dishId) {
                var input = document.getElementById("quantity_" + dishId);
                if (parseInt(input.value) > 0) {
                    input.value = parseInt(input.value) - 1;
                    updateSubtotal(dishId);
                }
            }

            function updateSubtotal(dishId) {
                var quantity = parseInt(document.getElementById("quantity_" + dishId).value);
                var price = parseFloat(document.getElementById("price_" + dishId).value);
                var subtotal = quantity * price;
                document.getElementById("subtotal_" + dishId).innerText = isNaN(subtotal) ? "0.00" : subtotal.toFixed(2);
            }

            function openEditModal(button) {
                // ... (các dòng gán dữ liệu khác)
                // Reset tất cả số lượng về 0
                document.querySelectorAll('.dish-table input[id^="quantity_"]').forEach(input => {
                    input.value = 0;
                    const dishId = input.id.replace("quantity_", "");
                    document.getElementById("subtotal_" + dishId).innerText = "0.00";
                });

                // Lấy và hiển thị số lượng từ OrderDetail
                console.log("Raw data-order-details:", button.dataset.orderDetails);
                let orderDetails;
                try {
                    orderDetails = JSON.parse(button.dataset.orderDetails || '[]');
                    console.log("Parsed orderDetails:", orderDetails);
                } catch (e) {
                    console.error("Error parsing orderDetails:", e);
                    orderDetails = [];
                }

                if (orderDetails.length === 0) {
                    console.warn("No order details found for this order.");
                } else {
                    orderDetails.forEach(detail => {
                        console.log("Processing detail:", detail);
                        const quantityInput = document.getElementById("quantity_" + detail.dishId);
                        const subtotalSpan = document.getElementById("subtotal_" + detail.dishId);
                        if (quantityInput && subtotalSpan) {
                            console.log("Setting quantity for dishId:", detail.dishId, "to:", detail.quantity, "with subtotal:", detail.subtotal);
                            quantityInput.value = detail.quantity || 0;
                            subtotalSpan.innerText = (detail.subtotal || 0).toFixed(2);
                        } else {
                            console.warn("No matching dish found in table for dishId:", detail.dishId);
                        }
                    });
                }

                openModal("updateOrderModal");
            }

            function filterTable() {
                const searchText = document.getElementById('searchInput').value.toLowerCase();
                const table = document.querySelector('.table-responsive table tbody');
                const rows = table.querySelectorAll('tr:not(.no-data-row)');
                let hasResults = false;

                rows.forEach(row => {
                    const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const userId = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                    const customerId = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                    const orderStatus = row.querySelector('td:nth-child(6)').textContent.toLowerCase();
                    const orderType = row.querySelector('td:nth-child(7)').textContent.toLowerCase();

                    let matchesSearch = (id.includes(searchText)) || (userId.includes(searchText)) || (customerId.includes(searchText)) || (orderStatus.includes(searchText)) || (orderType.includes(searchText));

                    if (matchesSearch) {
                        row.style.display = '';
                        hasResults = true;
                    } else {
                        row.style.display = 'none';
                    }
                });

                const noDataRow = document.querySelector('.table-responsive table tbody .no-data-row');
                if (noDataRow)
                    noDataRow.remove();

                if (!hasResults && searchText !== "") {
                    const newRow = document.createElement('tr');
                    newRow.classList.add('no-data-row');
                    newRow.innerHTML = '<td colspan="8" class="no-data"><i class="fas fa-exclamation-triangle"></i> No matching orders found.</td>';
                    table.appendChild(newRow);
                }
            }

            function addOrder() {
                $.ajax({
                    url: 'CreateOrder',
                    type: 'POST',
                    data: $('#addOrderForm').serialize(),
                    success: function (response) {
                        if (response.trim() === "success") {
                            alert('Order created successfully!');
                            closeModal('addOrderModal');
                            location.reload();
                        } else {
                            alert('Failed to create order: ' + response);
                        }
                    },
                    error: function (xhr, status, error) {
                        alert('Error adding order: ' + error + " " + xhr.responseText);
                    }
                });
            }

            function updateOrder() {
                $.ajax({
                    url: 'UpdateOrder',
                    type: 'POST',
                    data: $('#updateOrderForm').serialize(),
                    success: function (response) {
                        if (response.trim() === "success") {
                            alert('Order updated successfully!');
                            closeModal('updateOrderModal');
                            location.reload();
                        } else {
                            alert('Failed to update order: ' + response);
                        }
                    },
                    error: function (xhr, status, error) {
                        alert('Error updating order: ' + error + " " + xhr.responseText);
                    }
                });
            }

            $(document).ready(function () {
                $('#searchInput').on('keyup', filterTable);
            });
        </script>
    </head>
    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="text-left mb-4"><h4>Order Management</h4></div>
                    <div class="container-fluid">
                        <main>
                            <div class="content-header">
                                <div class="search-bar">
                                    <input type="text" class="form-control" placeholder="Search" id="searchInput">
                                </div>
                                <div class="header-buttons">
                                    <button type="button" class="btn btn-info" onclick="openModal('addOrderModal')"><i class="fas fa-plus"></i> Add New</button>
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
                                                        data-order-details='<%= orderDetailsJson%>'
                                                        onclick="openEditModal(this)">
                                                    <i class="fas fa-edit"></i> Update
                                                </button>
                                                <a href="ViewOrderDetail?orderId=<%=order.getOrderId()%>" class="btn btn-detail">
                                                    <i class="fas fa-info-circle"></i> Detail
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="8"><div class="no-data">No Orders Found.</div></td>
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
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Order</h5>
                    <button type="button" class="btn-close" onclick="closeModal('addOrderModal')" aria-label="Close"></button>
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
                            <input type="datetime-local" class="form-control" id="addOrderDate" name="orderDate" required>
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
                            <textarea class="form-control" id="addOrderDescription" name="orderDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="addCouponId" class="form-label">Coupon ID:</label>
                            <input type="text" class="form-control" id="addCouponId" name="couponId">
                        </div>
                        <div class="mb-3">
                            <label for="addTableId" class="form-label">Table ID:</label>
                            <input type="text" class="form-control" id="addTableId" name="tableId">
                        </div>

                        <h6>Select Dishes</h6>
                        <table class="table dish-table">
                            <thead>
                                <tr>
                                    <th>Dish Name</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (dishList != null && !dishList.isEmpty()) {
                                        for (Dish dish : dishList) {
                                %>
                                <tr>
                                    <td><%= dish.getDishName()%></td>
                                    <td>
                                        <input type="hidden" id="price_<%= dish.getDishId()%>" value="<%= dish.getDishPrice()%>">
                                        <%= dish.getDishPrice()%>
                                    </td>
                                    <td>
                                        <button type="button" onclick="decreaseQuantity('<%= dish.getDishId()%>')">-</button>
                                        <input type="number" id="quantity_<%= dish.getDishId()%>" name="quantity_<%= dish.getDishId()%>" value="0" min="0" onchange="updateSubtotal('<%= dish.getDishId()%>')">
                                        <button type="button" onclick="increaseQuantity('<%= dish.getDishId()%>')">+</button>
                                    </td>
                                    <td><span id="subtotal_<%= dish.getDishId()%>">0.00</span></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="4">No dishes available.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addOrderModal')">Cancel</button>
                            <button type="button" class="btn btn-primary" onclick="addOrder()">Add Order</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Update Order Modal -->
        <div id="updateOrderModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Order</h5>
                    <button type="button" class="btn-close" onclick="closeModal('updateOrderModal')" aria-label="Close"></button>
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
                            <input type="datetime-local" class="form-control" id="orderDateUpdate" name="orderDate" required>
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
                            <textarea class="form-control" id="orderDescriptionUpdate" name="orderDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="couponIdUpdate" class="form-label">Coupon ID:</label>
                            <input type="text" class="form-control" id="couponIdUpdate" name="couponId">
                        </div>
                        <div class="mb-3">
                            <label for="tableIdUpdate" class="form-label">Table ID:</label>
                            <input type="text" class="form-control" id="tableIdUpdate" name="tableId">
                        </div>

                        <h6>Update Dishes</h6>
                        <table class="table dish-table">
                            <tbody>
                                <%
                                    if (dishList != null && !dishList.isEmpty()) {
                                        for (Dish dish : dishList) {
                                %>
                                <tr>
                                    <td><%= dish.getDishName()%></td>
                                    <td>
                                        <input type="hidden" id="price_<%= dish.getDishId()%>" value="<%= dish.getDishPrice()%>">
                                        <%= dish.getDishPrice()%>
                                    </td>
                                    <td>
                                        <button type="button" onclick="decreaseQuantity('<%= dish.getDishId()%>')">-</button>
                                        <input type="number" id="quantity_<%= dish.getDishId()%>" name="quantity_<%= dish.getDishId()%>" value="0" min="0" onchange="updateSubtotal('<%= dish.getDishId()%>')">
                                        <button type="button" onclick="increaseQuantity('<%= dish.getDishId()%>')">+</button>
                                    </td>
                                    <td><span id="subtotal_<%= dish.getDishId()%>">0.00</span></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="4">No dishes available.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('updateOrderModal')">Cancel</button>
                            <button type="button" class="btn btn-primary" onclick="updateOrder()">Save changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>