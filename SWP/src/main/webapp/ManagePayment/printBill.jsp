<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Order" %>
<%@ page import="Model.OrderDetail" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>In hóa đơn</title>
    <style>
        .invoice-box {
            max-width: 800px;
            margin: auto;
            padding: 30px;
            border: 1px solid #eee;
            font-size: 16px;
            line-height: 24px;
            font-family: 'Helvetica', sans-serif;
        }
        .hidden-print {
            display: block;
        }
        @media print {
            .hidden-print {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="invoice-box">
        <h1>Hóa đơn nhà hàng</h1>
        <%
            Order order = (Order) request.getAttribute("order");
            String formattedDate = (String) request.getAttribute("formattedDate");
            if (order != null) {
        %>
        <p>Mã hóa đơn: <%= order.getOrderId() %></p>
        <p>Ngày: <%= formattedDate %></p>
        <p>Số điện thoại khách hàng: <%= order.getCustomerPhone() %></p>
        <%
            if (order.getCustomerId() != null) {
        %>
        <p>Tên khách hàng: <%= order.getCustomerId() %></p>
        <%
            }
        %>

        <table border="1">
            <thead>
                <tr>
                    <th>Tên món</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<OrderDetail> orderDetails = order.getOrderDetails();
                    if (orderDetails != null) {
                        for (OrderDetail detail : orderDetails) {
                            double unitPrice = detail.getSubtotal() / detail.getQuantity();
                %>
                <tr>
                    <td><%= detail.getDishName() %></td>
                    <td><%= detail.getQuantity() %></td>
                    <td><%= String.format("%.2f", unitPrice) %></td>
                    <td><%= String.format("%.2f", detail.getSubtotal()) %></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>

        <p>Tổng tiền trước giảm giá: <%= String.format("%.2f", order.getTotal()) %> VNĐ</p>
        <%
            if (order.getCouponId() != null) {
        %>
        <p>Mã giảm giá: <%= order.getCouponId() %></p>
        <%
            }
        %>
        <p><strong>Tổng tiền sau giảm giá: <%= String.format("%.2f", order.getFinalPrice()) %> VNĐ</strong></p>

        <%
            } else {
        %>
        <p>Không tìm thấy hóa đơn.</p>
        <%
            }
        %>

        <button class="hidden-print" onclick="window.print()">In hóa đơn</button>
        <a href="/payment?action=listOrders" class="hidden-print">Quay lại</a>
    </div>
</body>
</html>