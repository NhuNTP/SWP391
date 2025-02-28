<%-- 
    Document   : UpdateOrder
    Created on : Feb 27, 2025, 4:52:33 AM
    Author     : HuynhPhuBinh
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Order" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Order order = (Order) request.getAttribute("order");
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Order</title>
</head>
<body>
    <h2>Update Order</h2>
    <form action="UpdateOrderController" method="POST">
        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
        
        <label>User ID:</label>
        <input type="text" name="userId" value="<%= order.getUserId() %>" required><br>

        <label>Customer ID:</label>
        <input type="text" name="customerId" value="<%= order.getCustomerId() %>"><br>

        <label>Order Date:</label>
        <input type="date" name="orderDate" value="<%= formatter.format(order.getOrderDate()) %>" required><br>

        <label>Order Status:</label>
        <input type="text" name="orderStatus" value="<%= order.getOrderStatus() %>" required><br>

        <label>Order Type:</label>
        <input type="text" name="orderType" value="<%= order.getOrderType() %>" required><br>

        <label>Order Description:</label>
        <input type="text" name="orderDescription" value="<%= order.getOrderDescription() %>"><br>

        <label>Coupon ID:</label>
        <input type="text" name="couponId" value="<%= order.getCouponId() %>"><br>

        <label>Table ID:</label>
        <input type="text" name="tableId" value="<%= order.getTableId() %>"><br>

        <button type="submit">Update Order</button>
    </form>

    <a href="ViewOrderListController">Back to Order List</a>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
    <% } %>
</body>
</html>