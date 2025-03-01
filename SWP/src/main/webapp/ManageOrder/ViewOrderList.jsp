<%-- 
    Document   : ViewOrderList
    Created on : Feb 27, 2025, 4:24:31 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="DAO.OrderDAO"%>
<%@page import="Model.Order"%>
<%@page import="Model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Order List</title>
    </head>
    <body>

        <h2>Order List</h2>

        <button onclick="window.location.href = 'CreateOrder'">Add Order</button>

        <table border="1">
            <tr>
                <th>Order ID</th>
                <th>User ID</th>
                <th>Customer ID</th>
                <th>Order Date</th>
                <th>Order Status</th>
                <th>Order Type</th>
                <th>Order Description</th>
                <th>Coupon ID</th>
                <th>Table ID</th>
                <th>Actions</th>
            </tr>
            <%
                List<Order> orders = (List<Order>) request.getAttribute("orderList");
                if (orders != null) {
                    for (Order order : orders) {
            %>
            <tr>
                <td><%= order.getOrderId()%></td>
                <td><%= order.getUserId()%></td>
                <td><%= order.getCustomerId()%></td>
                <td><%= order.getOrderDate()%></td>
                <td><%= order.getOrderStatus()%></td>
                <td><%= order.getOrderType()%></td>
                <td><%= order.getOrderDescription()%></td>
                <td><%= order.getCouponId()%></td>
                <td><%= order.getTableId()%></td>
                <td>
                    <a href="UpdateOrder?orderId=<%= order.getOrderId()%>" class="btn btn-profile">Update</a>
                    <a href="ViewOrderDetail?orderId=<%= order.getOrderId()%>" class="btn btn-profile">Detail</a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="10">No orders found.</td>
            </tr>
            <% }%>
        </table>

    </body>
</html>