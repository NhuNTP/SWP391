<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, Model.Customer, Model.Table, java.util.List" %>
<html>
<head>
    <title>Phục vụ - Tổng quan bàn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .order-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .order-table th, .order-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .order-table th { background-color: #4CAF50; color: white; }
        .button { padding: 12px 20px; margin: 5px; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 16px; }
        .button.add-dish { background-color: #2196F3; }
        .button.complete { background-color: #4CAF50; }
        .button.edit { background-color: #FFC107; padding: 5px 10px; }
        .button.delete { background-color: #F44336; padding: 5px 10px; }
        .button.back { background-color: #9E9E9E; }
        .button:disabled { background-color: #ccc; cursor: not-allowed; }
        .button:hover:not(:disabled) { opacity: 0.9; }
        .customer-section { margin-top: 20px; padding: 15px; background-color: #f9f9f9; border-radius: 5px; }
        .message { color: #888; font-style: italic; }
        .error { color: red; text-align: center; }
        .success { color: green; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <%
            String tableId = request.getParameter("tableId");
            Order order = (Order) request.getAttribute("order");
            Boolean hasDishes = (Boolean) request.getAttribute("hasDishes");
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            boolean isEditable = order != null && "Pending".equals(order.getOrderStatus());

            if (tableId == null) {
        %>
        <p class="error">Không tìm thấy bàn. Vui lòng chọn lại.</p>
        <a href="order?action=listTables"><button class="button back">Quay lại</button></a>
        <% } else { %>
        <h1>Bàn <%= tableId %> - <%= order != null && order.getOrderStatus() != null ? order.getOrderStatus() : "Chưa có đơn" %></h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        <% if (success != null) { %>
            <p class="success"><%= success %></p>
        <% } %>

        <% if (order != null && hasDishes != null && hasDishes) { %>
        <table class="order-table">
            <tr><th>Tên món</th><th>Số lượng</th><th>Thành tiền</th><th>Hành động</th></tr>
            <% for (OrderDetail detail : order.getOrderDetails()) { %>
            <tr>
                <td><%= detail.getDishName() %></td>
                <td><%= detail.getQuantity() %></td>
                <td><%= String.format("%.2f", detail.getSubtotal()) %> VND</td>
                <td>
                    <% if (isEditable) { %>
                    <form action="order" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="editDishQuantity">
                        <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId() %>">
                        <input type="hidden" name="tableId" value="<%= tableId %>">
                        <input type="number" name="newQuantity" value="<%= detail.getQuantity() %>" min="1" required>
                        <button type="submit" class="button edit">Sửa</button>
                    </form>
                    <form action="order" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deleteDish">
                        <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId() %>">
                        <input type="hidden" name="tableId" value="<%= tableId %>">
                        <button type="submit" class="button delete" onclick="return confirm('Xóa món này?');">Xóa</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
            <tr><td colspan="3"><strong>Tổng cộng</strong></td><td><strong><%= String.format("%.2f", order.getTotal()) %> VND</strong></td></tr>
        </table>
        <% } else { %>
        <p class="message">Chưa có món nào. Vui lòng thêm món để tiếp tục.</p>
        <% } %>

        <% if (hasDishes != null && hasDishes && isEditable) { %>
        <div class="customer-section">
            <h2>Quản lý khách hàng</h2>
            <% Customer currentCustomer = (Customer) request.getAttribute("currentCustomer"); %>
            <% if (currentCustomer != null) { %>
            <p><strong>Khách hàng:</strong> <%= currentCustomer.getCustomerName() %> (SĐT: <%= currentCustomer.getCustomerPhone() %>)</p>
            <% } %>
            <h3>Chọn khách hàng</h3>
            <form action="order" method="get">
                <input type="hidden" name="action" value="selectCustomer">
                <input type="hidden" name="tableId" value="<%= tableId %>">
                <select name="customerId" required>
                    <option value="">-- Chọn khách hàng --</option>
                    <% List<Customer> customers = (List<Customer>) request.getAttribute("customers"); %>
                    <% for (Customer customer : customers) { %>
                    <option value="<%= customer.getCustomerId() %>">
                        <%= customer.getCustomerName() %> (SĐT: <%= customer.getCustomerPhone() %>)
                    </option>
                    <% } %>
                </select>
                <button type="submit" class="button complete">Chọn</button>
            </form>
            <h3>Thêm khách hàng mới</h3>
            <form action="order" method="get">
                <input type="hidden" name="action" value="addCustomer">
                <input type="hidden" name="tableId" value="<%= tableId %>">
                <input type="text" name="customerName" placeholder="Tên khách hàng" required>
                <input type="text" name="customerPhone" placeholder="Số điện thoại" maxlength="10" pattern="[0-9]{10}" required>
                <button type="submit" class="button complete">Thêm</button>
            </form>
        </div>
        <% } %>

        <div>
            <a href="order?action=selectDish&tableId=<%= tableId %>"><button class="button add-dish" <%= !isEditable ? "disabled" : "" %>>Thêm món</button></a>
            <% if (hasDishes != null && hasDishes && isEditable) { %>
            <form action="order" method="get" style="display:inline;">
                <input type="hidden" name="action" value="completeOrder">
                <input type="hidden" name="tableId" value="<%= tableId %>">
                <button type="submit" class="button complete">Hoàn tất đơn</button>
            </form>
            <% } %>
            <a href="order?action=cancelOrder"><button class="button back">Quay lại</button></a>
        </div>
        <% } %>
    </div>
</body>
</html>