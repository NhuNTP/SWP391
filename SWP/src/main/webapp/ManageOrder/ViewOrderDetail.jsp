<%-- 
    Document   : OrderDetail
    Created on : Mar 1, 2025, 2:12:23 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="Model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Detail</title>
</head>
<body>
    <h2>Order Detail</h2>

    <%
        List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
        if (orderDetails != null && !orderDetails.isEmpty()) {
            for (OrderDetail orderDetail : orderDetails) {
    %>
    <p><strong>Order Detail ID:</strong> <%= orderDetail.getOrderDetailId() %></p>
    <p><strong>Order ID:</strong> <%= orderDetail.getOrderId() %></p>
    <p><strong>Dish ID:</strong> <%= orderDetail.getDishId() %></p>
    <p><strong>Quantity:</strong> <%= orderDetail.getQuantity() %></p>
    <p><strong>Subtotal:</strong> <%= orderDetail.getSubtotal() %></p>
    <hr>
    <%
            }
        } else {
    %>
        <p>No order details found.</p>
    <% } %>

    <button onclick="window.location.href = 'ViewOrderList'">Back to Order List</button>
</body>
</html>