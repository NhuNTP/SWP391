<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, Model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (session == null || account == null || !"Kitchen staff".equals(account.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
        return;
    }
%>
<html>
<head>
    <title>Chi tiết đơn hàng - <%= order.getOrderId() %></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .order-details { width: 100%; border-collapse: collapse; }
        .order-details th, .order-details td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .order-details th { background-color: #4CAF50; color: white; }
        .button { padding: 8px 15px; border: none; border-radius: 5px; color: white; cursor: pointer; }
        .btn-success { background-color: #4CAF50; }
        .btn-primary { background-color: #2196F3; }
        .btn:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Chi tiết đơn hàng: <%= order.getOrderId() %></h1>
        <p><strong>Bàn:</strong> <%= order.getTableId() %></p>
        <p><strong>Ngày đặt:</strong> <%= order.getOrderDate() %></p>
        <p><strong>Mô tả:</strong> <%= order.getOrderDescription() != null ? order.getOrderDescription() : "Không có mô tả" %></p>
        <p><strong>Trạng thái:</strong> <%= order.getOrderStatus() %></p>
        <table class="order-details">
            <tr>
                <th>Tên món</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Tổng phụ</th>
            </tr>
            <% if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) { %>
                <% for (OrderDetail detail : order.getOrderDetails()) { %>
                    <tr>
                        <td><%= detail.getDishName() %></td>
                        <td><%= detail.getQuantity() %></td>
                        <td><%= detail.getSubtotal() / detail.getQuantity() %></td>
                        <td><%= detail.getSubtotal() %></td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr><td colspan="4">Chưa có món ăn nào.</td></tr>
            <% } %>
        </table>
        <div style="margin-top: 20px;">
            <% if ("Pending".equals(order.getOrderStatus())) { %>
                <form action="${pageContext.request.contextPath}/kitchen" method="post" style="display: inline;">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <input type="hidden" name="newStatus" value="Processing">
                    <button type="submit" class="button btn-success">Chuyển sang Processing</button>
                </form>
            <% } else if ("Processing".equals(order.getOrderStatus())) { %>
                <form action="${pageContext.request.contextPath}/kitchen" method="post" style="display: inline;">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <input type="hidden" name="newStatus" value="Completed">
                    <button type="submit" class="button btn-success">Chuyển sang Completed</button>
                </form>
            <% } %>
            <a href="${pageContext.request.contextPath}/kitchen" class="button btn-primary" style="margin-left: 10px;">Quay lại</a>
        </div>
    </div>
</body>
</html>