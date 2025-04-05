<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, Model.Customer, Model.Account, java.util.List" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
    Order order = (Order) request.getAttribute("order");
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    Customer currentCustomer = (Customer) request.getAttribute("currentCustomer");
    List<Model.Dish> dishes = (List<Model.Dish>) request.getAttribute("dishes");
    Boolean hasOrder = (Boolean) request.getAttribute("hasOrder"); // Lấy thuộc tính hasOrder từ controller
%>
<html>
    <head>
        <title>Chi tiết bàn - <%= request.getAttribute("tableId")%></title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f5f5f5;
            }
            h1, h3 {
                color: #333;
                text-align: center;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .order-info, .dish-list, .customer-section {
                margin-bottom: 20px;
            }
            .table-list {
                width: 100%;
                border-collapse: collapse;
            }
            .table-list th, .table-list td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            .table-list th {
                background-color: #4CAF50;
                color: white;
            }
            .button {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                color: white;
                cursor: pointer;
            }
            .button:hover {
                opacity: 0.9;
            }
            .btn-primary {
                background-color: #2196F3;
            }
            .btn-success {
                background-color: #4CAF50;
            }
            .btn-danger {
                background-color: #f44336;
            }
            .btn-secondary {
                background-color: #757575;
            }
            .btn-disabled {
                background-color: #cccccc;
                cursor: not-allowed;
            }
            .error {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }
            select, input[type="text"], input[type="number"] {
                padding: 5px;
                width: 100%;
                max-width: 300px;
            }
            #addCustomerForm {
                display: none;
            }
            .quantity-input {
                width: 60px;
                text-align: center;
            }
            .quantity-btn {
                padding: 5px 10px;
                font-size: 14px;
            }
            .error-message {
                color: red;
                font-size: 0.9em;
                margin-top: 5px;
            }
            .description-section {
    margin-top: 10px;
}
.description-section label {
    font-weight: bold;
}
.description-section input {
    padding: 5px;
    font-size: 0.9rem;
}
        </style>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function toggleAddCustomerForm() {
                var checkbox = document.getElementById("addCustomerCheckbox");
                var form = document.getElementById("addCustomerForm");
                var selectForm = document.getElementById("selectCustomerForm");
                if (checkbox.checked) {
                    form.style.display = "block";
                    selectForm.style.display = "none";
                } else {
                    form.style.display = "none";
                    selectForm.style.display = "block";
                }
            }

            function updateQuantity(orderDetailId, dishId, tableId, delta) {
                var input = document.getElementById("quantity_" + dishId);
                var newQuantity = parseInt(input.value) + delta;
                if (newQuantity < 0) {
                    alert("Số lượng không thể nhỏ hơn 0!");
                    return;
                }
                input.value = newQuantity;

                var form = document.createElement("form");
                form.method = "POST";
                form.action = "${pageContext.request.contextPath}/order";

                var actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "editDishQuantity";
                form.appendChild(actionInput);

                var orderDetailInput = document.createElement("input");
                orderDetailInput.type = "hidden";
                orderDetailInput.name = "orderDetailId";
                orderDetailInput.value = orderDetailId || "";
                form.appendChild(orderDetailInput);

                var dishInput = document.createElement("input");
                dishInput.type = "hidden";
                dishInput.name = "dishId";
                dishInput.value = dishId;
                form.appendChild(dishInput);

                var quantityInput = document.createElement("input");
                quantityInput.type = "hidden";
                quantityInput.name = "newQuantity";
                quantityInput.value = newQuantity;
                form.appendChild(quantityInput);

                var tableInput = document.createElement("input");
                tableInput.type = "hidden";
                tableInput.name = "tableId";
                tableInput.value = tableId;
                form.appendChild(tableInput);

                document.body.appendChild(form);
                form.submit();
            }

            $(document).ready(function () {
                // Xử lý thêm khách hàng mới
                $('#btnAddCustomerTable').click(function (e) {
                    e.preventDefault();
                    $('.error-message').remove();

                    var customerName = $('#customerNameTable').val().trim();
                    var customerPhone = $('#customerPhoneTable').val().trim();

                    var isValid = true;

                    if (customerName === '') {
                        isValid = false;
                        $('#customerNameTable').after('<div class="error-message">Please input this field</div>');
                    }

                    if (customerPhone === '') {
                        isValid = false;
                        $('#customerPhoneTable').after('<div class="error-message">Please input this field</div>');
                    } else if (!customerPhone.startsWith('0')) {
                        isValid = false;
                        $('#customerPhoneTable').after('<div class="error-message">Phone number must start with 0</div>');
                    } else if (!/^\d{10}$/.test(customerPhone)) {
                        isValid = false;
                        $('#customerPhoneTable').after('<div class="error-message">Phone number must be exactly 10 digits, no special characters</div>');
                    }

                    if (isValid) {
                        $.ajax({
                            url: '${pageContext.request.contextPath}/AddCustomer',
                            type: 'POST',
                            data: {
                                CustomerName: customerName,
                                CustomerPhone: customerPhone,
                                NumberOfPayment: 0
                            },
                            success: function (response) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success!',
                                    text: 'Customer added successfully.',
                                    timer: 2000,
                                    showConfirmButton: false
                                }).then(() => {
                                    window.location.reload();
                                });
                                $('#addCustomerForm').hide();
                                $('#selectCustomerForm').show();
                                $('#addCustomerCheckbox').prop('checked', false);
                                $('#customerNameTable').val('');
                                $('#customerPhoneTable').val('');
                            },
                            error: function (xhr) {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error!',
                                    text: xhr.responseText || 'Error adding customer.',
                                    confirmButtonColor: '#dc3545'
                                });
                            }
                        });
                    }
                });

                // Xử lý hủy đơn hàng
                $('#btnCancelOrder').click(function (e) {
                    e.preventDefault();
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You want to cancel this order?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Yes, cancel it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            var orderId = $(this).data('order-id');
                            var tableId = $(this).data('table-id');
                            $.post('${pageContext.request.contextPath}/order', {
                                action: 'cancelOrder',
                                orderId: orderId,
                                tableId: tableId
                            }, function () {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Cancelled!',
                                    text: 'Order has been cancelled.',
                                    timer: 2000,
                                    showConfirmButton: false
                                }).then(() => {
                                    window.location.href = '${pageContext.request.contextPath}/order?action=listTables';
                                });
                            }).fail(function (xhr) {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error!',
                                    text: xhr.responseText || 'Error cancelling order.',
                                    confirmButtonColor: '#dc3545'
                                });
                            });
                        }
                    });
                });
            });
            $(document).ready(function () {
                // Xử lý lưu mô tả đơn hàng
                $('#btnSaveDescription').click(function (e) {
                    e.preventDefault();
                    var orderId = $(this).data('order-id');
                    var tableId = $(this).data('table-id');
                    var orderDescription = $('#orderDescription').val().trim();

                    if (!orderDescription) {
                        Swal.fire('Error!', 'Vui lòng nhập mô tả đơn hàng.', 'error');
                        return;
                    }

                    $.post('${pageContext.request.contextPath}/order', {
                        action: 'updateOrderDescription',
                        orderId: orderId,
                        tableId: tableId,
                        orderDescription: orderDescription
                    }, function (response) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Thành công!',
                            text: 'Mô tả đơn hàng đã được lưu.',
                            timer: 2000,
                            showConfirmButton: false
                        });
                    }).fail(function (xhr) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi!',
                            text: xhr.responseText || 'Lỗi khi lưu mô tả đơn hàng.',
                            confirmButtonColor: '#dc3545'
                        });
                    });
                });
            });
            function updateHiddenDescription() {
    var orderDesc = $('#orderDescription').val().trim();
    $('#hiddenOrderDescription').val(orderDesc);
}
        </script>
    </head>
    <body>
        <div class="container">
            <h1>Chi tiết bàn: <%= request.getAttribute("tableId")%></h1>

            <!-- Thông báo lỗi -->
            <% if (request.getAttribute("error") != null) {%>
            <p class="error"><%= request.getAttribute("error")%></p>
            <% } %>

            <!-- Thông tin đơn hàng -->
            <div class="order-info">
                <h3>Thông tin đơn hàng</h3>
                <% if (order != null) {%>
                <p><strong>Mã đơn hàng:</strong> <%= order.getOrderId()%></p>
                <p><strong>Trạng thái:</strong> <%= order.getOrderStatus()%></p>
                <p><strong>Loại đơn:</strong> <%= order.getOrderType()%></p>
                <p><strong>Ngày đặt:</strong> <%= order.getOrderDate()%></p>
                <p><strong>Tổng tiền:</strong> <%= order.getTotal()%> VNĐ</p>
                <p><strong>Khách hàng:</strong> 
                    <% if (currentCustomer != null) {%>
                    <%= currentCustomer.getCustomerName()%> (<%= currentCustomer.getCustomerPhone()%>)
                    <% } else { %>
                    Chưa chọn
                    <% }%>
                </p>
                <!-- Thêm trường nhập orderDescription -->
                <div class="description-section">
                    <label for="orderDescription"><strong>Mô tả đơn hàng:</strong></label><br>
                    <input type="text" id="orderDescription" name="orderDescription" 
                           value="<%= order.getOrderDescription() != null ? order.getOrderDescription() : ""%>" 
                           style="width: 100%; max-width: 400px; padding: 5px;">
                </div>
                <% } else { %>
                <p>Chưa có đơn hàng nào được tạo.</p>
                <% } %>
            </div>
            <!-- Danh sách món ăn -->
            <div class="dish-list">
                <h3>Danh sách món ăn</h3>
                <table class="table-list">
                    <tr>
                        <th>Tên món</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Tổng phụ</th>
                        <th>Hành động</th>
                    </tr>
                    <% if (order != null && order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) { %>
                    <% for (OrderDetail detail : order.getOrderDetails()) {%>
                    <tr>
                        <td><%= detail.getDishName()%></td>
                        <td>
                            <button class="quantity-btn btn-secondary" onclick="updateQuantity('<%= detail.getOrderDetailId()%>', '<%= detail.getDishId()%>', '<%= request.getAttribute("tableId")%>', -1)">-</button>
                            <input type="number" class="quantity-input" id="quantity_<%= detail.getDishId()%>" 
                                   value="<%= detail.getQuantity()%>" min="0" readonly>
                            <button class="quantity-btn btn-secondary" onclick="updateQuantity('<%= detail.getOrderDetailId()%>', '<%= detail.getDishId()%>', '<%= request.getAttribute("tableId")%>', 1)">+</button>
                        </td>
                        <td><%= detail.getSubtotal() / detail.getQuantity()%></td>
                        <td><%= detail.getSubtotal()%></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/order" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="deleteDish">
                                <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId()%>">
                                <input type="hidden" name="dishId" value="<%= detail.getDishId()%>">
                                <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId")%>">
                                <button type="submit" class="button btn-danger">Xóa</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    <% } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Chưa có món ăn nào trong đơn hàng.</td>
                    </tr>
                    <% }%>
                </table>
                <a href="${pageContext.request.contextPath}/order?action=selectDish&tableId=<%= request.getAttribute("tableId")%>&returnTo=tableOverview" class="button btn-primary" style="margin-top: 10px;">Thêm món ăn</a>
            </div>

            <!-- Quản lý khách hàng -->
            <div class="customer-section">
                <h3>Quản lý khách hàng</h3>
                <div>
                    <input type="checkbox" id="addCustomerCheckbox" onclick="toggleAddCustomerForm()">
                    <label for="addCustomerCheckbox">Thêm khách hàng mới</label>
                </div>

                <!-- Chọn khách hàng (default) -->
                <div id="selectCustomerForm">
                    <form action="${pageContext.request.contextPath}/order" method="post">
                        <input type="hidden" name="action" value="selectCustomer">
                        <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId")%>">
                        <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : ""%>">
                        <select name="customerId" onchange="this.form.submit()">
                            <option value="">-- Chọn khách hàng --</option>
                            <% for (Customer customer : customers) {%>
                            <option value="<%= customer.getCustomerId()%>" <%= order != null && customer.getCustomerId().equals(order.getCustomerId()) ? "selected" : ""%>>
                                <%= customer.getCustomerName()%> (<%= customer.getCustomerPhone()%>)
                            </option>
                            <% }%>
                        </select>
                    </form>
                </div>

                <!-- Thêm khách hàng mới -->
                <div id="addCustomerForm">
                    <form id="addCustomerFormTable">
                        <label>Tên khách hàng:</label><br>
                        <input type="text" id="customerNameTable" name="customerName" required><br><br>
                        <label>Số điện thoại:</label><br>
                        <input type="text" id="customerPhoneTable" name="customerPhone" required><br><br>
                        <button type="button" id="btnAddCustomerTable" class="button btn-success">Thêm</button>
                    </form>
                </div>
            </div>

            <!-- Nút hành động -->
            <div style="text-align: center;">
                <form action="${pageContext.request.contextPath}/order" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="completeOrder">
                    <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId")%>">
                    <!-- Thêm orderDescription vào form -->
                    <input type="hidden" id="hiddenOrderDescription" name="orderDescription" value="">
                    <button type="submit" class="button btn-success" onclick="updateHiddenDescription()">Hoàn tất đơn hàng</button>
                </form>
                <% if (hasOrder != null && hasOrder && order != null && "Pending".equals(order.getOrderStatus())) {%>
                <!-- Hiển thị nút Hủy đơn hàng nếu đã có đơn hàng trong DB và trạng thái là Pending -->
                <button id="btnCancelOrder" class="button btn-danger" style="margin-left: 10px;" 
                        data-order-id="<%= order.getOrderId()%>" data-table-id="<%= request.getAttribute("tableId")%>">
                    Hủy đơn hàng
                </button>
                <% } else { %>
                <!-- Hiển thị nút Quay lại nếu chưa có đơn hàng trong DB -->
                <form action="${pageContext.request.contextPath}/order" method="get" style="display: inline;">
                    <input type="hidden" name="action" value="listTables">
                    <button type="submit" class="button btn-secondary" style="margin-left: 10px;">Quay lại</button>
                </form>
                <% }%>
            </div>
        </div>
    </body>
</html>