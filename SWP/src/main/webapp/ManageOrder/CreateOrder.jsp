<%--
    Document   : AddOrder
    Created on : Feb 28, 2025
    Author     : HuynhPhuBinh
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Order</title>
</head>
<body>
    <h2>Create New Order</h2>

    <form action="CreateOrder" method="POST">
        <label for="userId">User ID:</label><br>
        <input type="number" id="userId" name="userId"><br><br>

        <label for="customerId">Customer ID:</label><br>
        <input type="number" id="customerId" name="customerId"><br><br>

        <label for="orderDate">Order Date:</label><br>
        <input type="datetime-local" id="orderDate" name="orderDate"><br><br>

        <label for="orderStatus">Order Status:</label><br>
        <select id="orderStatus" name="orderStatus">
            <%
                List<String> orderStatuses = (List<String>) request.getAttribute("orderStatuses");
                if (orderStatuses != null) {
                    for (String status : orderStatuses) {
            %>
                        <option value="<%= status %>"><%= status %></option>
            <%
                    }
                }
            %>
        </select><br><br>

        <label for="orderType">Order Type:</label><br>
        <select id="orderType" name="orderType">
            <%
                List<String> orderTypes = (List<String>) request.getAttribute("orderTypes");
                if (orderTypes != null) {
                    for (String type : orderTypes) {
            %>
                        <option value="<%= type %>"><%= type %></option>
            <%
                    }
                }
            %>
        </select><br><br>

        <label for="orderDescription">Order Description:</label><br>
        <textarea id="orderDescription" name="orderDescription"></textarea><br><br>

        <label for="couponId">Coupon ID:</label><br>
        <input type="number" id="couponId" name="couponId"><br><br>

        <label for="tableId">Table ID:</label><br>
        <input type="number" id="tableId" name="tableId"><br><br>

        <input type="submit" value="Create Order">
    </form>

    <button onclick="window.location.href = 'ViewOrderList'">Back to Order List</button>
</body>
</html>