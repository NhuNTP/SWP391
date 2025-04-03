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
        .button.back { background-color: #9E9E9E; } /* Thêm màu xám cho nút Quay lại */
        .button:hover { opacity: 0.9; }
        .customer-section { margin-top: 20px; padding: 15px; background-color: #f9f9f9; border-radius: 5px; }
        .customer-section select, .customer-section input[type="text"] { padding: 8px; margin: 5px 0; width: 200px; }
        .message { color: #888; font-style: italic; }
        .edit-form input[type="number"] { width: 50px; padding: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <%
            Table table = (Table) request.getAttribute("table");
            Order order = (Order) request.getAttribute("order");
            Boolean hasDishes = (Boolean) request.getAttribute("hasDishes");
            if (table == null) {
        %>
        <p>Không tìm thấy bàn. Vui lòng chọn lại.</p>
        <a href="order?action=listTables"><button class="button complete">Quay lại</button></a>
        <%
            } else {
                String tableId = table.getTableId();
                Order tempOrder = (Order) session.getAttribute("tempOrder");
                order = order != null ? order : tempOrder;
        %>
        <h1>Bàn <%=tableId%> - <%=order != null && order.getOrderStatus() != null ? order.getOrderStatus() : "Chưa có đơn"%></h1>

        <%
            List<OrderDetail> details = order != null && order.getOrderDetails() != null ? order.getOrderDetails() : null;
            if (details != null && !details.isEmpty()) {
        %>
        <table class="order-table">
            <tr><th>Tên món</th><th>Số lượng</th><th>Thành tiền</th><th>Hành động</th></tr>
            <%
                for (OrderDetail detail : details) {
            %>
            <tr>
                <td><%=detail.getDishName()%></td>
                <td><%=detail.getQuantity()%></td>
                <td><%=String.format("%.2f", detail.getSubtotal())%> VND</td>
                <td>
                    <form action="order" method="post" class="edit-form" style="display:inline;">
                        <input type="hidden" name="action" value="editDishQuantity">
                        <input type="hidden" name="orderDetailId" value="<%=detail.getOrderDetailId()%>">
                        <input type="hidden" name="tableId" value="<%=tableId%>">
                        <input type="number" name="newQuantity" value="<%=detail.getQuantity()%>" min="1" required>
                        <button type="submit" class="button edit">Sửa</button>
                    </form>
                    <form action="order" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deleteDish">
                        <input type="hidden" name="orderDetailId" value="<%=detail.getOrderDetailId()%>">
                        <input type="hidden" name="tableId" value="<%=tableId%>">
                        <button type="submit" class="button delete" onclick="return confirm('Xóa món này?');">Xóa</button>
                    </form>
                </td>
            </tr>
            <%
                }
            %>
            <tr><td colspan="3"><strong>Tổng cộng</strong></td><td><strong><%=String.format("%.2f", details.stream().mapToDouble(OrderDetail::getSubtotal).sum())%> VND</strong></td></tr>
        </table>
        <%
            } else {
        %>
        <p class="message">Chưa có món nào. Vui lòng thêm món để tiếp tục.</p>
        <%
            }
        %>

        <%
            if (hasDishes != null && hasDishes) {
        %>
        <div class="customer-section">
            <h2>Khách hàng</h2>
            <form action="order" method="post">
                <input type="hidden" name="action" value="updateCustomer">
                <input type="hidden" name="tableId" value="<%=tableId%>">
                <label><input type="radio" name="customerOption" value="existing" checked> Chọn khách hàng</label><br>
                <select name="customerId">
                    <option value="">-- Chọn khách hàng --</option>
                    <%
                        List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                        if (customers != null) {
                            for (Customer customer : customers) {
                    %>
                    <option value="<%=customer.getCustomerId()%>" <%=order != null && customer.getCustomerId().equals(order.getCustomerId()) ? "selected" : ""%>>
                        <%=customer.getCustomerName()%> (<%=customer.getCustomerPhone()%>)
                    </option>
                    <%
                            }
                        }
                    %>
                </select><br>
                <label><input type="radio" name="customerOption" value="new"> Thêm khách mới</label><br>
                <input type="text" name="customerName" placeholder="Tên khách hàng"><br>
                <input type="text" name="customerPhone" placeholder="Số điện thoại" maxlength="10"><br>
                <button type="submit" class="button complete">Cập nhật khách hàng</button>
            </form>
        </div>
        <%
            }
        %>

        <div>
            <a href="order?action=selectDishes&tableId=<%=tableId%>"><button class="button add-dish">Thêm món</button></a>
            <%
                if (hasDishes != null && hasDishes) {
            %>
            <form action="order" method="post" style="display:inline;">
                <input type="hidden" name="action" value="completeOrder">
                <input type="hidden" name="tableId" value="<%=tableId%>">
                <button type="submit" class="button complete">Hoàn tất đơn</button>
            </form>
            <%
                }
            %>
            <a href="order?action=cancelOrder"><button class="button back">Quay lại</button></a>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>