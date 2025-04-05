<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Order, Model.OrderDetail, Model.Coupon, java.util.List" %>
<html>
<head>
    <title>Thanh toán - Chi tiết đơn hàng</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background-color: #f5f5f5; 
        }
        h1 { 
            color: #333; 
            text-align: center; 
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: #fff; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        .order-table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-bottom: 20px; 
        }
        .order-table th, .order-table td { 
            border: 1px solid #ddd; 
            padding: 10px; 
            text-align: left; 
        }
        .order-table th { 
            background-color: #4CAF50; 
            color: white; 
        }
        .button { 
            padding: 12px 20px; 
            margin: 5px; 
            border: none; 
            border-radius: 5px; 
            color: white; 
            cursor: pointer; 
            font-size: 16px; 
        }
        .button.pay { 
            background-color: #4CAF50; 
        }
        .button.back { 
            background-color: #f44336; 
        }
        .button:hover { 
            opacity: 0.9; 
        }
        .coupon-section { 
            margin-top: 20px; 
            padding: 15px; 
            background-color: #f9f9f9; 
            border-radius: 5px; 
        }
        .coupon-section select { 
            padding: 8px; 
            margin: 5px 0; 
            width: 200px; 
        }
        .debug { 
            color: red; 
            font-size: 12px; 
            margin-top: 10px; 
        }
        .message { 
            color: green; 
            font-size: 14px; 
            margin-bottom: 10px; 
        }
        .status-message {
            font-size: 14px;
            margin-bottom: 10px;
        }
        .status-pending {
            color: #ff9800;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            Order order = (Order) request.getAttribute("order");
            String message = (String) request.getAttribute("message");
            if (order != null) {
                boolean isProcessing = "Processing".equals(order.getOrderStatus());
                boolean isCompleted = "Completed".equals(order.getOrderStatus());
        %>
        <h1>Thanh toán đơn hàng - <%=order.getOrderId()%> (Bàn <%=order.getTableId() != null ? order.getTableId() : "Takeaway"%>)</h1>
        <%
            if (message != null) {
        %>
        <p class="message"><%=message%></p>
        <%
            }
            if ("Pending".equals(order.getOrderStatus())) {
        %>
        <p class="status-message status-pending">Đơn hàng đang ở trạng thái 'Pending'. Không thể thanh toán ngay bây giờ.</p>
        <%
            }
            List<OrderDetail> details = order.getOrderDetails();
            if (details != null && !details.isEmpty()) {
        %>
        <table class="order-table">
            <tr>
                <th>Tên món</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
            </tr>
            <%
                for (OrderDetail detail : details) {
            %>
            <tr>
                <td><%=detail.getDishName() != null ? detail.getDishName() : "Không có tên"%></td>
                <td><%=detail.getQuantity() != 0 ? detail.getQuantity() : "N/A"%></td>
                <td><%=String.format("%.2f", detail.getSubtotal())%> VND</td>
            </tr>
            <%
                }
            %>
            <tr>
                <td colspan="2"><strong>Tổng cộng (trước coupon)</strong></td>
                <td><strong><%=String.format("%.2f", details.stream().mapToDouble(OrderDetail::getSubtotal).sum())%> VND</strong></td>
            </tr>
            <%
                if (isCompleted) {
            %>
            <tr>
                <td colspan="2"><strong>Tổng cộng (sau coupon)</strong></td>
                <td><strong><%=String.format("%.2f", order.getTotal())%> VND</strong></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
            } else {
        %>
        <p class="debug">Không có chi tiết đơn hàng.</p>
        <%
            }
        %>

        <!-- Phần chọn coupon và nút thanh toán -->
        <div class="coupon-section">
            <h2>Áp dụng mã coupon</h2>
            <form action="payment" method="post">
                <input type="hidden" name="action" value="payOrder">
                <input type="hidden" name="orderId" value="<%=order.getOrderId()%>">
                <input type="hidden" name="tableId" value="<%=order.getTableId() != null ? order.getTableId() : ""%>">
                <%
                    List<Coupon> coupons = (List<Coupon>) request.getAttribute("coupons");
                    if (coupons != null) { // Chỉ hiển thị <select> nếu có danh sách coupon
                %>
                <select name="couponId" <%=isCompleted ? "disabled" : ""%>>
                    <option value="">-- Chọn coupon --</option>
                    <%
                        if (!coupons.isEmpty()) {
                            for (Coupon coupon : coupons) {
                    %>
                    <option value="<%=coupon.getCouponId()%>" <%=order.getCouponId() != null && order.getCouponId().equals(coupon.getCouponId()) ? "selected" : ""%>>
                        <%=coupon.getCouponId()%> - Giảm <%=coupon.getDiscountAmount() != null ? coupon.getDiscountAmount() : "N/A"%> VND 
                        (Hết hạn: <%=coupon.getExpirationDate() != null ? coupon.getExpirationDate() : "N/A"%>)
                    </option>
                    <%
                            }
                        } else {
                    %>
                    <option value="">Không có coupon nào (danh sách rỗng)</option>
                    <%
                        }
                    %>
                </select>
                <%
                    } else {
                %>
                <p>Chỉ hiển thị coupon khi trạng thái là 'Processing'.</p>
                <%
                    }
                %>
                <% if (isProcessing && coupons != null) { %>
                    <button type="submit" class="button pay">Thanh toán</button>
                <% } %>
                <button type="button" class="button back" onclick="window.location.href='payment?action=listOrders'">Trở về</button>
            </form>
            <%
                if (coupons == null) {
                    out.println("<p class='debug'>Debug: coupons is null</p>");
                } else if (coupons.isEmpty()) {
                    out.println("<p class='debug'>Debug: coupons is empty</p>");
                } else {
                    out.println("<p class='debug'>Debug: Found " + coupons.size() + " coupons</p>");
                }
            %>
        </div>
        <%
            } else {
        %>
        <p>Không tìm thấy đơn hàng.</p>
        <%
            }
        %>
    </div>
</body>
</html>