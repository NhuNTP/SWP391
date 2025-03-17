<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, java.util.List" %>
<html>
<head>
    <title>Thanh toán - Danh sách đơn hàng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .button { padding: 8px 15px; border: none; border-radius: 5px; color: white; cursor: pointer; }
        .button.pay { background-color: #4CAF50; }
        .button:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Danh sách đơn hàng cần thanh toán</h1>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders != null && !orders.isEmpty()) {
        %>
        <table>
            <tr><th>Mã đơn</th><th>Bàn</th><th>Tổng tiền</th><th>Hành động</th></tr>
            <%
                for (Order order : orders) {
            %>
            <tr>
                <td><%=order.getOrderId()%></td>
                <td><%=order.getTableId() != null ? order.getTableId() : "Takeaway"%></td>
                <td><%=String.format("%.2f", order.getTotal())%> VND</td>
                <td>
                    <a href="payment?action=viewOrder&orderId=<%=order.getOrderId()%>"><button class="button pay">Xem & Thanh toán</button></a>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        <%
            } else {
        %>
        <p>Không có đơn hàng nào cần thanh toán.</p>
        <%
            }
        %>
    </div>
</body>
</html>