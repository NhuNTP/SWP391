<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order" %>
<%@ page import="Model.OrderDetail" %>
<%@ page import="Model.Dish" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Roboto', sans-serif; }
        .order-table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        .order-table th, .order-table td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        .order-table th { background-color: #f2f2f2; }
        .tab-content { padding: 20px; }
    </style>
    <script>
        function addDishToTable(dishId, dishName, price) {
            var quantityInput = document.getElementById("quantity_" + dishId);
            var quantity = parseInt(quantityInput.value) || 0;
            console.log("Adding dish: " + dishId + ", Quantity from input: " + quantity);
            if (quantity > 0) {
                var table = document.getElementById("overviewTable").getElementsByTagName('tbody')[0];
                var existingRow = null;
                var rows = table.getElementsByTagName("tr");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].getAttribute("data-dish-id") === dishId) {
                        existingRow = rows[i];
                        break;
                    }
                }

                var newQuantity;
                if (existingRow) {
                    var currentQuantity = parseInt(existingRow.cells[1].innerText);
                    newQuantity = currentQuantity + quantity;
                    var newSubtotal = price * newQuantity;
                    existingRow.cells[1].innerText = newQuantity;
                    existingRow.cells[2].innerText = newSubtotal;
                    console.log("Updated existing dish: " + dishId + ", New Quantity: " + newQuantity);
                } else {
                    newQuantity = quantity;
                    var subtotal = price * quantity;
                    var row = table.insertRow();
                    row.setAttribute("data-dish-id", dishId);
                    row.innerHTML = "<td>" + dishName + "</td><td>" + quantity + "</td><td>" + subtotal + "</td>";
                    console.log("Added new dish: " + dishId + ", Quantity: " + quantity);
                }

                // Gửi số lượng mới nhập qua tempQuantity
                var hiddenQuantity = document.getElementById("tempQuantity_" + dishId);
                if (!hiddenQuantity) {
                    hiddenQuantity = document.createElement("input");
                    hiddenQuantity.type = "hidden";
                    hiddenQuantity.id = "tempQuantity_" + dishId;
                    hiddenQuantity.name = "tempQuantity_" + dishId;
                    document.getElementById("confirmForm").appendChild(hiddenQuantity);
                }
                hiddenQuantity.value = quantity;
                console.log("Set tempQuantity for " + dishId + " to: " + quantity);

                // Thêm tempDishId nếu chưa tồn tại
                var existingTempDish = document.querySelector("input[name='tempDishId'][value='" + dishId + "']");
                if (!existingTempDish) {
                    var hiddenInput = document.createElement("input");
                    hiddenInput.type = "hidden";
                    hiddenInput.name = "tempDishId";
                    hiddenInput.value = dishId;
                    document.getElementById("confirmForm").appendChild(hiddenInput);
                }

                // Cập nhật existingQuantity_<dishId> trong form
                var existingQuantityInput = document.getElementById("existingQuantity_" + dishId);
                if (existingQuantityInput) {
                    existingQuantityInput.value = newQuantity;
                } else {
                    // Nếu chưa có existingQuantity, tạo mới
                    var newExistingQuantity = document.createElement("input");
                    newExistingQuantity.type = "hidden";
                    newExistingQuantity.id = "existingQuantity_" + dishId;
                    newExistingQuantity.name = "existingQuantity_" + dishId;
                    newExistingQuantity.value = newQuantity;
                    document.getElementById("confirmForm").appendChild(newExistingQuantity);
                    // Thêm existingDishId nếu chưa có
                    var existingDishInput = document.querySelector("input[name='existingDishId'][value='" + dishId + "']");
                    if (!existingDishInput) {
                        var newExistingDish = document.createElement("input");
                        newExistingDish.type = "hidden";
                        newExistingDish.name = "existingDishId";
                        newExistingDish.value = dishId;
                        document.getElementById("confirmForm").appendChild(newExistingDish);
                    }
                }
                console.log("Updated existingQuantity_" + dishId + " to: " + newQuantity);

                // Reset input về 1
                quantityInput.value = 1;
                console.log("Reset quantity input for " + dishId + " to 1");

                // Gửi AJAX để cập nhật database ngay lập tức
                var orderId = document.querySelector("input[name='orderId']").value;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "order", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        console.log("Updated database successfully: " + xhr.responseText);
                    } else if (xhr.readyState === 4) {
                        console.error("Error updating database: " + xhr.status);
                    }
                };
                var data = "action=addDish&orderId=" + encodeURIComponent(orderId) + "&dishId=" + encodeURIComponent(dishId) + "&quantity=" + encodeURIComponent(quantity);
                xhr.send(data);
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <%
            Order order = (Order) request.getAttribute("order");
            List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
            String tableId = (String) request.getAttribute("tableId");
        %>
        <h1 class="text-center my-4">
            <%= order != null ? "Order " + order.getOrderId() + " - Bàn " + order.getTableId() : "Xác nhận Order - Bàn " + tableId %>
        </h1>

        <ul class="nav nav-tabs" id="orderTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab" aria-controls="overview" aria-selected="true">Overview</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="add-dish-tab" data-bs-toggle="tab" data-bs-target="#add-dish" type="button" role="tab" aria-controls="add-dish" aria-selected="false">Thêm món</button>
            </li>
        </ul>

        <div class="tab-content" id="orderTabContent">
            <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview-tab">
                <table class="order-table" id="overviewTable">
                    <thead>
                        <tr>
                            <th>Tên món</th>
                            <th>Số lượng</th>
                            <th>Tổng phụ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<OrderDetail> detailsToShow = (order != null && order.getOrderDetails() != null) ? order.getOrderDetails() : (orderDetails != null ? orderDetails : new ArrayList<>());
                            for (OrderDetail detail : detailsToShow) {
                        %>
                        <tr data-dish-id="<%= detail.getDishId() %>">
                            <td><%= detail.getDishName() %></td>
                            <td><%= detail.getQuantity() %></td>
                            <td><%= detail.getSubtotal() %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <h2 class="my-3">Thông tin khách hàng</h2>
                <form action="order" method="post" class="mb-3" id="confirmForm">
                    <input type="hidden" name="action" value="<%= order != null ? "updateOrder" : "confirmOrder" %>">
                    <input type="hidden" name="tableId" value="<%= tableId != null ? tableId : (order != null ? order.getTableId() : "") %>">
                    <% if (order != null) { %>
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <% for (OrderDetail detail : detailsToShow) { %>
                    <input type="hidden" name="existingDishId" value="<%= detail.getDishId() %>">
                    <input type="hidden" name="existingQuantity_<%= detail.getDishId() %>" id="existingQuantity_<%= detail.getDishId() %>" value="<%= detail.getQuantity() %>">
                    <% } %>
                    <% } else {
                        for (OrderDetail detail : detailsToShow) {
                    %>
                    <input type="hidden" name="dishId" value="<%= detail.getDishId() %>">
                    <input type="hidden" name="quantity_<%= detail.getDishId() %>" value="<%= detail.getQuantity() %>">
                    <%
                        }
                    } %>
                    <div class="row g-3 align-items-center">
                        <div class="col-auto">
                            <label for="customerPhone" class="col-form-label">Số điện thoại:</label>
                        </div>
                        <div class="col-auto">
                            <input type="text" id="customerPhone" name="customerPhone" class="form-control" value="<%= order != null && order.getCustomerPhone() != null ? order.getCustomerPhone() : "" %>" placeholder="Nhập số điện thoại" <%= order != null && order.getCustomerPhone() != null ? "" : "required" %>>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary"><%= order != null ? "Cập nhật Order" : "Xác nhận Order" %></button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="tab-pane fade" id="add-dish" role="tabpanel" aria-labelledby="add-dish-tab">
                <h2 class="my-3">Danh sách món ăn</h2>
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Tên món</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
                            if (dishes != null) {
                                for (Dish dish : dishes) {
                                    if ("Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                        %>
                        <tr>
                            <td><%= dish.getDishName() %></td>
                            <td><%= dish.getDishPrice() %></td>
                            <td><input type="number" id="quantity_<%= dish.getDishId() %>" class="form-control" min="1" value="1"></td>
                            <td>
                                <button type="button" class="btn btn-primary" onclick="addDishToTable('<%= dish.getDishId() %>', '<%= dish.getDishName() %>', <%= dish.getDishPrice() %>)">Thêm</button>
                            </td>
                        </tr>
                        <%
                                    }
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/order?action=selectTable" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>