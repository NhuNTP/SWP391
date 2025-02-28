<%-- 
    Document   : CreateOrder
    Created on : Feb 27, 2025, 4:19:25 AM
    Author     : HuynhPhuBinh
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Order</title>
</head>
<body>
    <h2>Create Order</h2>

    <% String errorMessage = (String) request.getAttribute("errorMessage");
       if (errorMessage != null) { %>
        <p style="color: red;"><%= errorMessage %></p>
    <% } %>

    <form action="CreateOrder" method="POST">
        <label>User ID:</label>
        <input type="number" name="userId" required><br>

        <label>Customer ID (Optional):</label>
        <input type="number" name="customerId"><br>

        <label>Order Status:</label>
        <input type="text" name="orderStatus" required><br>

        <label>Order Type:</label>
        <input type="text" name="orderType" required><br>

        <label>Order Description:</label>
        <textarea name="orderDescription"></textarea><br>

        <label>Coupon ID (Optional):</label>
        <input type="number" name="couponId"><br>

        <label>Table ID (Optional):</label>
        <input type="number" name="tableId"><br>

        <button type="submit">Create Order</button>
    </form>

    <br>
    <button onclick="window.location.href='ViewOrderList'">Back to Order List</button>
</body>
</html>

