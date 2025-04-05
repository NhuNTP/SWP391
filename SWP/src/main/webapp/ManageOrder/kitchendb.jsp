<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, Model.Account, java.util.List" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (session == null || account == null || !"Kitchen staff".equals(account.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }
    List<Order> pendingOrders = (List<Order>) request.getAttribute("pendingOrders");
%>
<html>
<head>
    <title>Kitchen Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; }
        .order-list { width: 100%; border-collapse: collapse; }
        .order-list th, .order-list td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .order-list th { background-color: #4CAF50; color: white; }
        .pending { background-color: #ffeb3b; }
        .processing { background-color: #ff9800; }
        .button { padding: 8px 15px; border: none; border-radius: 5px; color: white; cursor: pointer; text-decoration: none; }
        .btn-primary { background-color: #2196F3; }
        .btn-primary:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/LoginPage.jsp">Log out</a>
        <h1>Kitchen Dashboard</h1>
        <h3>Danh sách đơn hàng chờ xử lý</h3>
        <table class="order-list">
            <tr>
                <th>Mã đơn hàng</th>
                <% if ("Kitchen staff".equals(account.getUserRole())) { %>
                    <th>Ngày đặt</th>
                    <th>Danh sách món</th>
                    <th>Mô tả</th>
                <% } %>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            <% if (pendingOrders != null && !pendingOrders.isEmpty()) { %>
                <% for (Order order : pendingOrders) { %>
                    <tr class="<%= "Pending".equals(order.getOrderStatus()) ? "pending" : "processing" %>">
                        <td><%= order.getOrderId() %></td>
                        <% if ("Kitchen staff".equals(account.getUserRole())) { %>
                            <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(order.getOrderDate()) %></td>
                            <td>
                                <% if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) { %>
                                    <% for (OrderDetail detail : order.getOrderDetails()) { %>
                                        <%= detail.getDishName() %> (<%= detail.getQuantity() %>), 
                                    <% } %>
                                <% } else { %>
                                    Chưa có món
                                <% } %>
                            </td>
                            <td><%= order.getOrderDescription() != null ? order.getOrderDescription() : "Không có mô tả" %></td>
                        <% } %>
                        <td><%= order.getOrderStatus() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/kitchen?action=viewOrder&orderId=<%= order.getOrderId() %>" class="button btn-primary">Xem chi tiết</a>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr><td colspan="<%= "Kitchen staff".equals(account.getUserRole()) ? "6" : "3" %>" style="text-align: center;">Không có đơn hàng nào đang chờ xử lý.</td></tr>
            <% } %>
        </table>
    </div>
</body>
</html>