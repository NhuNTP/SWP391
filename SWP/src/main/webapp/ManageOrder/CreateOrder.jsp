<%--
    Document   : AddOrder
    Created on : Feb 28, 2025
    Author     : HuynhPhuBinh
--%>

<%-- CreateOrder.jsp --%>
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

        <h3>Order Details:</h3>
        <div id="orderDetails">
            <div class="orderDetail">
                <label for="dishId_1">Dish ID:</label>
                <input type="number" id="dishId_1" name="dishId_1"><br>
                <label for="quantity_1">Quantity:</label>
                <input type="number" id="quantity_1" name="quantity_1"><br>
                <hr>
            </div>
        </div>
        <button type="button" onclick="addOrderDetail()">Add More</button><br><br>

        <input type="submit" value="Create Order">
    </form>

    <button onclick="window.location.href = 'ViewOrderList'">Back to Order List</button>

    <script>
        let orderDetailCount = 1;

        function addOrderDetail() {
            orderDetailCount++;
            let orderDetailsDiv = document.getElementById("orderDetails");
            let newOrderDetailDiv = document.createElement("div");
            newOrderDetailDiv.className = "orderDetail";
            newOrderDetailDiv.innerHTML = `
                <label for="dishId_${orderDetailCount}">Dish ID:</label>
                <input type="number" id="dishId_${orderDetailCount}" name="dishId_${orderDetailCount}"><br>
                <label for="quantity_${orderDetailCount}">Quantity:</label>
                <input type="number" id="quantity_${orderDetailCount}" name="quantity_${orderDetailCount}"><br>
                <hr>
            `;
            orderDetailsDiv.appendChild(newOrderDetailDiv);
        }
    </script>
</body>
</html>