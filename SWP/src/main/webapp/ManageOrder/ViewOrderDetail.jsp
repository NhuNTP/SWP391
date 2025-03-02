<%-- 
    Document   : OrderDetail
    Created on : Mar 1, 2025, 2:12:23 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="Model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@page import="Model.Order"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Detail</title>
</head>
<body>
    <h2>Order Detail</h2>

    <%
        Order order = (Order) request.getAttribute("order");
        if (order != null) {
    %>
    <p><strong>Order ID:</strong> <%= order.getOrderId() %></p>
    <p><strong>User ID:</strong> <%= order.getUserId() %></p>

    <h3>Order Items:</h3>
    <%
        List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
        if (orderDetails != null) {
            // In ra số lượng OrderDetail trong danh sách để debug
            System.out.println("Number of OrderDetails: " + orderDetails.size());

            if (!orderDetails.isEmpty()) {
                for (OrderDetail orderDetail : orderDetails) {
%>
                    <p><strong>Dish Name:</strong> <%= orderDetail.getDishName() %></p>
                    <p><strong>Quantity:</strong> <%= orderDetail.getQuantity() %></p>
                    <p><strong>Subtotal:</strong> <%= orderDetail.getSubtotal() %></p>
                    <p><strong>Quantity Used:</strong> <%= (orderDetail.getQuantityUsed() != null) ? orderDetail.getQuantityUsed() : "N/A" %></p>
                    <hr>
<%
                }
            } else {
%>
                <p>No order details found (list is empty).</p>
<%
            }
        } else {
%>
            <p>No order details found (list is null).</p>
<%
        }
    %>
    <% } else { %>
        <p>Order not found.</p>
    <% } %>

    <button onclick="window.location.href = 'ViewOrderList'">Back to Order List</button>
</body>
</html>