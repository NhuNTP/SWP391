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
                            <div class="header-buttons">
                                <a href="${pageContext.request.contextPath}/order?action=listTables" class="btn btn-info"><i class="fas fa-plus"></i> Add New</a>
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
                                            <button type="button" class="btn btn-detail" onclick="viewOrderDetail('<%= order.getOrderId()%>')">
                                                <i class="fas fa-info-circle"></i> Detail
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr><td colspan="9"><div class="no-data">No Orders Found.</div></td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
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
                                <tr><td colspan="4">No dishes available.</td></tr>
                                <% }%>
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

        <!-- View Order Detail Modal -->
        <div id="viewOrderDetailModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Order Detail - <span id="viewOrderId"></span></h5>
                    <button type="button" class="btn-close" onclick="closeModal('viewOrderDetailModal')" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <tr><th>User ID</th><td id="viewUserId"></td></tr>
                        <tr><th>Customer ID</th><td id="viewCustomerId"></td></tr>
                        <tr><th>Order Date</th><td id="viewOrderDate"></td></tr>
                        <tr><th>Order Status</th><td id="viewOrderStatus"></td></tr>
                        <tr><th>Order Type</th><td id="viewOrderType"></td></tr>
                        <tr><th>Table ID</th><td id="viewTableId"></td></tr>
                        <tr><th>Order Description</th><td id="viewOrderDescription"></td></tr>
                        <tr><th>Coupon ID</th><td id="viewCouponId"></td></tr>
                    </table>
                    <h6>Ordered Dishes</h6>
                    <table class="table dish-table" id="viewOrderDetailsTable">
                        <thead>
                            <tr>
                                <th>Dish Name</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('viewOrderDetailModal')">Close</button>
                </div>
            </div>
        </div>

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

            function selectTable(tableId, tableName) {
                document.getElementById('addTableId').value = tableId;
                document.getElementById('selectedTableName').innerText = tableName;
                closeModal('selectTableModal');
                openModal('addOrderModal');
            }

            function openEditModal(button) {
                document.getElementById('orderIdUpdate').value = button.dataset.orderId;
                document.getElementById('userIdUpdate').value = button.dataset.userId;
                document.getElementById('customerIdUpdate').value = button.dataset.customerId;
                document.getElementById('orderDateUpdate').value = button.dataset.orderDate.replace(" ", "T").slice(0, 16);
                document.getElementById('orderStatusUpdate').value = button.dataset.orderStatus;
                document.getElementById('orderTypeUpdate').value = button.dataset.orderType;
                document.getElementById('orderDescriptionUpdate').value = button.dataset.orderDescription;
                document.getElementById('couponIdUpdate').value = button.dataset.couponId;
                document.getElementById('tableIdUpdate').value = button.dataset.tableId;

                document.querySelectorAll('.dish-table input[id^="quantity_"]').forEach(input => {
                    input.value = 0;
                    const dishId = input.id.replace("quantity_", "");
                    document.getElementById("subtotal_" + dishId).innerText = "0.00";
                });

                let orderDetails;
                try {
                    orderDetails = JSON.parse(button.dataset.orderDetails || '[]');
                } catch (e) {
                    console.error("Error parsing orderDetails:", e);
                    orderDetails = [];
                }

                orderDetails.forEach(detail => {
                    const quantityInput = document.getElementById("quantity_" + detail.dishId);
                    const subtotalSpan = document.getElementById("subtotal_" + detail.dishId);
                    if (quantityInput && subtotalSpan) {
                        quantityInput.value = detail.quantity || 0;
                        subtotalSpan.innerText = (detail.subtotal || 0).toFixed(2);
                    }
                });

                openModal("updateOrderModal");
            }

            function viewOrderDetail(orderId) {
                $.ajax({
                    url: 'ViewOrderDetail',
                    type: 'GET',
                    data: {orderId: orderId},
                    success: function (response) {
                        try {
                            let order = JSON.parse(response);
                            if (order.error) {
                                alert(order.error);
                                return;
                            }

                            document.getElementById('viewOrderId').innerText = order.orderId;
                            document.getElementById('viewUserId').innerText = order.userId || 'N/A';
                            document.getElementById('viewCustomerId').innerText = order.customerId || 'N/A';
                            document.getElementById('viewOrderDate').innerText = order.orderDate;
                            document.getElementById('viewOrderStatus').innerText = order.orderStatus;
                            document.getElementById('viewOrderType').innerText = order.orderType;
                            document.getElementById('viewTableId').innerText = order.tableId || 'N/A';
                            document.getElementById('viewOrderDescription').innerText = order.orderDescription || 'N/A';
                            document.getElementById('viewCouponId').innerText = order.couponId || 'N/A';

                            let tbody = document.querySelector('#viewOrderDetailsTable tbody');
                            tbody.innerHTML = '';
                            if (order.orderDetails && order.orderDetails.length > 0) {
                                order.orderDetails.forEach(detail => {
                                    let row = document.createElement('tr');
                                    row.innerHTML = `
                                        <td>${detail.dishName}</td>
                                        <td>${detail.quantity}</td>
                                        <td>${detail.subtotal.toFixed(2)}</td>
                                    `;
                                    tbody.appendChild(row);
                                });
                            } else {
                                let row = document.createElement('tr');
                                row.innerHTML = '<td colspan="3">No dishes ordered.</td>';
                                tbody.appendChild(row);
                            }

                            openModal('viewOrderDetailModal');
                        } catch (e) {
                            console.error("Error parsing response:", e);
                            alert("Failed to load order details.");
                        }
                    },
                    error: function (xhr, status, error) {
                        alert('Error fetching order details: ' + error);
                    }
                });
            }

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
    </body>
</html>