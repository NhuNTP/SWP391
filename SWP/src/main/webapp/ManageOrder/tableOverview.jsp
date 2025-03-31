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
            body {
                background-color: #f8f9fa;
                font-family: 'Roboto', sans-serif;
            }
            .order-table {
                width: 80%;
                margin: 20px auto;
                border-collapse: collapse;
            }
            .order-table th, .order-table td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: center;
            }
            .order-table th {
                background-color: #f2f2f2;
            }
            .tab-content {
                padding: 20px;
            }
            .total-row {
                font-weight: bold;
                background-color: #e9ecef;
            }
        </style>
        <script>
            function addDishToTable(dishId, dishName, price) {
                var quantityInput = document.getElementById("quantity_" + dishId);
                var quantity = parseInt(quantityInput.value) || 0;
                if (quantity <= 0) {
                    alert("Vui lòng nhập số lượng lớn hơn 0.");
                    return;
                }

                var orderId = document.querySelector("input[name='orderId']") ? document.querySelector("input[name='orderId']").value : "";
                var tableId = "<%= request.getParameter("tableId")%>";
                if (!tableId || tableId.trim() === "") {
                    alert("Không tìm thấy TableId. Vui lòng chọn lại bàn.");
                    return;
                }

                console.log("Sending request: action=addDish, orderId=" + orderId + ", dishId=" + dishId + ", quantity=" + quantity + ", tableId=" + tableId);

                var xhr = new XMLHttpRequest();
                xhr.open("POST", "${pageContext.request.contextPath}/order", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        console.log("Updated database successfully: " + xhr.responseText);
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
                        var newSubtotal;
                        if (existingRow) {
                            var currentQuantity = parseInt(existingRow.cells[1].innerText);
                            newQuantity = currentQuantity + quantity;
                            newSubtotal = price * newQuantity;
                            existingRow.cells[1].innerText = newQuantity;
                            existingRow.cells[2].innerText = newSubtotal.toFixed(2);
                        } else {
                            newQuantity = quantity;
                            newSubtotal = price * quantity;
                            var row = table.insertRow();
                            row.setAttribute("data-dish-id", dishId);
                            row.innerHTML = "<td>" + dishName + "</td><td>" + newQuantity + "</td><td>" + newSubtotal.toFixed(2) + "</td>";
                        }

                        updateTotal();
                        quantityInput.value = 1; // Reset input
                    } else if (xhr.readyState === 4) {
                        console.error("Error: " + xhr.status + " - " + xhr.responseText);
                        alert("Có lỗi khi thêm món: " + xhr.responseText);
                    }
                };
                var data = "action=addDish&orderId=" + encodeURIComponent(orderId) + "&dishId=" + encodeURIComponent(dishId) + "&quantity=" + encodeURIComponent(quantity) + "&tableId=" + encodeURIComponent(tableId);
                xhr.send(data);
            }

            function updateTotal() {
                var table = document.getElementById("overviewTable").getElementsByTagName('tbody')[0];
                var rows = table.getElementsByTagName("tr");
                var total = 0;
                for (var i = 0; i < rows.length; i++) {
                    var subtotal = parseFloat(rows[i].cells[2].innerText) || 0;
                    total += subtotal;
                }
                var totalRow = document.getElementById("totalRow");
                if (!totalRow) {
                    totalRow = table.insertRow();
                    totalRow.id = "totalRow";
                    totalRow.className = "total-row";
                    totalRow.innerHTML = "<td colspan='2'>Tổng cộng</td><td id='totalAmount'>" + total.toFixed(2) + "</td>";
                } else {
                    document.getElementById("totalAmount").innerText = total.toFixed(2);
                }
            }

            window.onload = function () {
                updateTotal();
            };
        </script>
    </head>
    <body>
        <div class="container">
            <%
                String tableIdParam = request.getParameter("tableId");
                if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
                    out.println("<p style='color: red; text-align: center;'>Lỗi: Thiếu TableId trong URL. Vui lòng chọn lại bàn từ danh sách.</p>");
                    return;
                }
            %>
            <%
                Order order = (Order) request.getAttribute("order");
                List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
                String tableId = (String) request.getAttribute("tableId");
            %>
            <h1 class="text-center my-4">
                <%= order != null ? "Order " + order.getOrderId() + " - Bàn " + order.getTableId() : "Xác nhận Order - Bàn " + tableId%>
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
                            <tr data-dish-id="<%= detail.getDishId()%>">
                                <td><%= detail.getDishName()%></td>
                                <td><%= detail.getQuantity()%></td>
                                <td><%= String.format("%.2f", detail.getSubtotal())%></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>

                    <h2 class="my-3">Thông tin khách hàng</h2>
                    <form action="${pageContext.request.contextPath}/order" method="post" class="mb-3" id="confirmForm">
                        <input type="hidden" name="action" value="addCustomer">
                        <input type="hidden" name="tableId" value="<%= tableId != null ? tableId : (order != null ? order.getTableId() : "")%>">
                        <% if (order != null) {%>
                        <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">
                        <% for (OrderDetail detail : detailsToShow) {%>
                        <input type="hidden" name="existingDishId" value="<%= detail.getDishId()%>">
                        <input type="hidden" name="existingQuantity_<%= detail.getDishId()%>" id="existingQuantity_<%= detail.getDishId()%>" value="<%= detail.getQuantity()%>">
                        <% } %>
                        <% }%>
                        <div class="row g-3 align-items-center">
                            <div class="col-auto">
                                <label for="customerPhone" class="col-form-label">Số điện thoại:</label>
                            </div>
                            <div class="col-auto">
                                <input type="text" id="customerPhone" name="customerPhone" class="form-control" value="<%= order != null && order.getCustomerPhone() != null ? order.getCustomerPhone() : ""%>" placeholder="Nhập số điện thoại" pattern="\d{10}" required>
                            </div>
                            <div class="col-auto">
                                <label for="customerName" class="col-form-label">Tên khách hàng:</label>
                            </div>
                            <div class="col-auto">
                                <input type="text" id="customerName" name="customerName" class="form-control" value="<%= order != null && order.getCustomerName() != null ? order.getCustomerName() : ""%>" placeholder="Nhập tên khách hàng" required>
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary">Cập nhật thông tin</button>
                            </div>
                        </div>
                    </form>

                    <form action="${pageContext.request.contextPath}/order" method="post" class="mb-3">
                        <input type="hidden" name="action" value="completeOrder">
                        <input type="hidden" name="tableId" value="<%= tableId != null ? tableId : (order != null ? order.getTableId() : "")%>">
                        <div class="text-center">
                            <button type="submit" class="btn btn-success">Hoàn tất Order</button>
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
                                <td><%= dish.getDishName()%></td>
                                <td><%= String.format("%.2f", dish.getDishPrice())%></td>
                                <td><input type="number" id="quantity_<%= dish.getDishId()%>" class="form-control" min="1" value="1"></td>
                                <td>
                                    <button type="button" class="btn btn-primary" onclick="addDishToTable('<%= dish.getDishId()%>', '<%= dish.getDishName()%>', <%= dish.getDishPrice()%>)">Thêm</button>
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
                <a href="${pageContext.request.contextPath}/order?action=listTables" class="btn btn-secondary">Quay lại</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>