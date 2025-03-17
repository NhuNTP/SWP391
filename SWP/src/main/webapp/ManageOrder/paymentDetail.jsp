<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, java.util.List" %>
<html>
<head>
    <title>Thanh toán - Chi tiết đơn hàng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .order-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .order-table th, .order-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .order-table th { background-color: #4CAF50; color: white; }
        .button { padding: 12px 20px; margin: 5px; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 16px; }
        .button.pay { background-color: #4CAF50; }
        .button:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <%
            Order order = (Order) request.getAttribute("order");
            if (order != null) {
        %>
        <h1>Thanh toán đơn hàng - <%=order.getOrderId()%> (Bàn <%=order.getTableId() != null ? order.getTableId() : "Takeaway"%>)</h1>

        <%
            List<OrderDetail> details = order.getOrderDetails();
            if (details != null && !details.isEmpty()) {
        %>
        <table class="order-table">
            <tr><th>Tên món</th><th>Số lượng</th><th>Thành tiền</th></tr>
            <%
                for (OrderDetail detail : details) {
            %>
            <tr>
                <td><%=detail.getDishName()%></td>
                <td><%=detail.getQuantity()%></td>
                <td><%=String.format("%.2f", detail.getSubtotal())%> VND</td>
            </tr>
            <%
                }
            %>
            <tr><td colspan="2"><strong>Tổng cộng</strong></td><td><strong><%=String.format("%.2f", order.getTotal())%> VND</strong></td></tr>
        </table>
        <%
            }
        %>

        <form action="payment" method="post">
            <input type="hidden" name="action" value="payOrder">
            <input type="hidden" name="orderId" value="<%=order.getOrderId()%>">
            <input type="hidden" name="tableId" value="<%=order.getTableId() != null ? order.getTableId() : ""%>">
            <button type="submit" class="button pay">Thanh toán</button>
        </form>
        <%
            } else {
        %>
        <p>Không tìm thấy đơn hàng.</p>
        <%
            }
        %>
    </div>
</body>
</html>