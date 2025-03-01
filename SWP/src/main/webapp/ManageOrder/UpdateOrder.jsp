<%-- 
    Document   : UpdateOrder
    Created on : Mar 1, 2025, 1:56:27 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Order</title>
</head>
<body>
    <h2>Update Order</h2>

    <form action="UpdateOrder" method="POST">
        <%-- Hidden field to store the order ID --%>
        <input type="hidden" id="orderId" name="orderId" value="<%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getOrderId() : "" %>">

        <label for="userId">User ID:</label><br>
        <input type="number" id="userId" name="userId" value="<%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getUserId() : "" %>"><br><br>

        <label for="customerId">Customer ID:</label><br>
        <input type="number" id="customerId" name="customerId" value="<%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getCustomerId() : "" %>"><br><br>

        <label for="orderDate">Order Date:</label><br>
        <input type="datetime-local" id="orderDate" name="orderDate" value="<% if (request.getAttribute("order") != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                out.print(sdf.format(((Model.Order) request.getAttribute("order")).getOrderDate()));
            } %>"><br><br>

        <label for="orderStatus">Order Status:</label><br>
        <select id="orderStatus" name="orderStatus">
            <%
                List<String> orderStatuses = (List<String>) request.getAttribute("orderStatuses");
                Model.Order order = (Model.Order) request.getAttribute("order");
                if (orderStatuses != null) {
                    for (String status : orderStatuses) {
                        String selected = (order != null && status.equals(order.getOrderStatus())) ? "selected" : "";
            %>
                        <option value="<%= status %>" <%= selected %>><%= status %></option>
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
                        String selected = (order != null && type.equals(order.getOrderType())) ? "selected" : "";
            %>
                        <option value="<%= type %>" <%= selected %>><%= type %></option>
            <%
                    }
                }
            %>
        </select><br><br>

        <label for="orderDescription">Order Description:</label><br>
        <textarea id="orderDescription" name="orderDescription"><%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getOrderDescription() : "" %></textarea><br><br>

        <label for="couponId">Coupon ID:</label><br>
        <input type="number" id="couponId" name="couponId" value="<%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getCouponId() : "" %>"><br><br>

        <label for="tableId">Table ID:</label><br>
        <input type="number" id="tableId" name="tableId" value="<%= request.getAttribute("order") != null ? ((Model.Order) request.getAttribute("order")).getTableId() : "" %>"><br><br>

        <input type="submit" value="Update Order">
    </form>

    <button onclick="window.location.href = 'ViewOrderList'">Back to Order List</button>
</body>
</html>
