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
%>
<html>
<head>
    <title>Chi tiết bàn - <%= request.getAttribute("tableId") %></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1, h3 { color: #333; text-align: center; }
        .container { max-width: 1000px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .order-info, .dish-list, .customer-section { margin-bottom: 20px; }
        .table-list { width: 100%; border-collapse: collapse; }
        .table-list th, .table-list td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .table-list th { background-color: #4CAF50; color: white; }
        .button { padding: 8px 15px; border: none; border-radius: 5px; color: white; cursor: pointer; }
        .button:hover { opacity: 0.9; }
        .btn-primary { background-color: #2196F3; }
        .btn-success { background-color: #4CAF50; }
        .btn-danger { background-color: #f44336; }
        .btn-secondary { background-color: #757575; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        select, input[type="text"], input[type="number"] { padding: 5px; width: 100%; max-width: 300px; }
        #addCustomerForm { display: none; }
        .quantity-input { width: 60px; text-align: center; }
        .quantity-btn { padding: 5px 10px; font-size: 14px; }
    </style>
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
    </script>
</head>
<body>
    <div class="container">
        <h1>Chi tiết bàn: <%= request.getAttribute("tableId") %></h1>

        <!-- Thông báo lỗi -->
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <!-- Thông tin đơn hàng -->
        <div class="order-info">
            <h3>Thông tin đơn hàng</h3>
            <% if (order != null) { %>
                <p><strong>Mã đơn hàng:</strong> <%= order.getOrderId() %></p>
                <p><strong>Trạng thái:</strong> <%= order.getOrderStatus() %></p>
                <p><strong>Loại đơn:</strong> <%= order.getOrderType() %></p>
                <p><strong>Ngày đặt:</strong> <%= order.getOrderDate() %></p>
                <p><strong>Tổng tiền:</strong> <%= order.getTotal() %> VNĐ</p>
                <p><strong>Khách hàng:</strong> 
                    <% if (currentCustomer != null) { %>
                        <%= currentCustomer.getCustomerName() %> (<%= currentCustomer.getCustomerPhone() %>)
                    <% } else { %>
                        Chưa chọn
                    <% } %>
                </p>
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
                    <% for (OrderDetail detail : order.getOrderDetails()) { %>
                        <tr>
                            <td><%= detail.getDishName() %></td>
                            <td>
                                <button class="quantity-btn btn-secondary" onclick="updateQuantity('<%= detail.getOrderDetailId() %>', '<%= detail.getDishId() %>', '<%= request.getAttribute("tableId") %>', -1)">-</button>
                                <input type="number" class="quantity-input" id="quantity_<%= detail.getDishId() %>" 
                                       value="<%= detail.getQuantity() %>" min="0" readonly>
                                <button class="quantity-btn btn-secondary" onclick="updateQuantity('<%= detail.getOrderDetailId() %>', '<%= detail.getDishId() %>', '<%= request.getAttribute("tableId") %>', 1)">+</button>
                            </td>
                            <td><%= detail.getSubtotal() / detail.getQuantity() %></td>
                            <td><%= detail.getSubtotal() %></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/order" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteDish">
                                    <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId() %>">
                                    <input type="hidden" name="dishId" value="<%= detail.getDishId() %>">
                                    <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
                                    <button type="submit" class="button btn-danger">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Chưa có món ăn nào trong đơn hàng.</td>
                    </tr>
                <% } %>
            </table>
            <a href="${pageContext.request.contextPath}/order?action=selectDish&tableId=<%= request.getAttribute("tableId") %>&returnTo=tableOverview" class="button btn-primary" style="margin-top: 10px;">Thêm món ăn</a>
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
                    <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
                    <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : "" %>">
                    <select name="customerId" onchange="this.form.submit()">
                        <option value="">-- Chọn khách hàng --</option>
                        <% for (Customer customer : customers) { %>
                            <option value="<%= customer.getCustomerId() %>" <%= order != null && customer.getCustomerId().equals(order.getCustomerId()) ? "selected" : "" %>>
                                <%= customer.getCustomerName() %> (<%= customer.getCustomerPhone() %>)
                            </option>
                        <% } %>
                    </select>
                </form>
            </div>

            <!-- Thêm khách hàng mới -->
            <div id="addCustomerForm">
                <form action="${pageContext.request.contextPath}/order" method="post">
                    <input type="hidden" name="action" value="addCustomer">
                    <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
                    <input type="hidden" name="orderId" value="<%= order != null ? order.getOrderId() : "" %>">
                    <label>Tên khách hàng:</label><br>
                    <input type="text" name="customerName" required><br><br>
                    <label>Số điện thoại:</label><br>
                    <input type="text" name="customerPhone" required><br><br>
                    <button type="submit" class="button btn-success">Thêm</button>
                </form>
            </div>
        </div>

        <!-- Nút hành động -->
        <div style="text-align: center;">
            <form action="${pageContext.request.contextPath}/order" method="post" style="display: inline;">
                <input type="hidden" name="action" value="completeOrder">
                <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
                <button type="submit" class="button btn-success">Hoàn tất đơn hàng</button>
            </form>
            <a href="${pageContext.request.contextPath}/order?action=cancelOrder" class="button btn-danger" style="margin-left: 10px;">Hủy đơn hàng</a>
        </div>
    </div>
</body>
</html>