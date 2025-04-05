<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Table, Model.Order, java.util.List" %>
<html>
    <head>
        <title>Thanh toán - Danh sách bàn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f8f9fa;
                padding: 20px;
            }
            .table-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 15px;
            }
            .table-card {
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 5px;
                background-color: white;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                transition: transform 0.2s ease-in-out;
            }
            .table-card:hover {
                transform: translateY(-3px);
            }
            .table-card.pending {
                border-left: 5px solid #ff9800; /* Cam cho Pending */
                background-color: #fff3e0;
            }
            .table-card.processing {
                border-left: 5px solid #4CAF50; /* Xanh cho Processing */
                background-color: #e8f5e9;
            }
            .table-card.no-order {
                border-left: 5px solid #cccccc; /* Xám cho không có đơn */
                background-color: #f5f5f5;
            }
            .table-info {
                font-size: 0.9rem;
            }
            .table-info div {
                margin-bottom: 5px;
            }
            .table-status span {
                font-weight: bold;
                padding: 3px 8px;
                border-radius: 3px;
                color: white;
            }
            .table-card.pending .table-status span {
                background-color: #ff9800;
            }
            .table-card.processing .table-status span {
                background-color: #4CAF50;
            }
            .table-card.no-order .table-status span {
                background-color: #cccccc;
                color: #666;
            }
            .table-buttons a {
                padding: 8px 15px;
                border-radius: 5px;
                text-decoration: none;
                color: white;
                background-color: #4CAF50;
            }
            .table-buttons a:hover {
                opacity: 0.9;
            }
            .table-buttons .disabled {
                background-color: #cccccc;
                cursor: not-allowed;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="mb-4">Danh sách bàn</h1>
            <%
                List<Table> tables = (List<Table>) request.getAttribute("tables");
                if (tables != null && !tables.isEmpty()) {
            %>
            <div class="table-grid">
                <%
                    for (Table table : tables) {
                        Order order = table.getOrder();
                        String tableClass = "table-card ";
                        String statusText = "Không có đơn";
                        if (order != null) {
                            tableClass += order.getOrderStatus().equals("Pending") ? "pending" : "processing";
                            statusText = order.getOrderStatus();
                        } else {
                            tableClass += "no-order";
                        }
                %>
                <div class="<%= tableClass%>">
                    <div class="table-info">
                        <div><strong>ID Bàn:</strong> <%= table.getTableId()%></div>
                        <div><strong>Tầng:</strong> <%= table.getFloorNumber()%></div>
                        <div><strong>Số ghế:</strong> <%= table.getNumberOfSeats()%></div>
                        <% if (order != null) {%>
                        <div><strong>Mã đơn hàng:</strong> <%= order.getOrderId()%></div>
                        <div><strong>Tổng tiền:</strong> <%= String.format("%.2f", order.getTotal())%> VND</div>
                        <% }%>
                        <div class="table-status"><strong>Trạng thái:</strong> <span><%= statusText%></span></div>
                    </div>
                    <div class="table-buttons">
                        <% if (order != null) { %>
                            <a href="payment?action=viewOrder&orderId=<%= order.getOrderId()%>">Xem & Thanh toán</a>
                        <% } else { %>
                            <a class="disabled">Xem & Thanh toán</a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="no-tables">
                <p>Không có bàn nào trong hệ thống.</p>
            </div>
            <% }%>
        </div>
    </body>
</html>