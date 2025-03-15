<%@page import="java.util.ArrayList"%>
<%@page import="Model.Table"%>
<%@page import="DAO.TableDAO"%>
<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }
    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();

    List<Table> tableList = (List<Table>) request.getAttribute("tables");
    if (tableList == null) {
        TableDAO tableDAO = new TableDAO();
        try {
            tableList = tableDAO.getAllTables();
        } catch (Exception e) {
            e.printStackTrace();
            tableList = new ArrayList<>();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn bàn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Roboto', sans-serif; }
        .table-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; padding: 20px; }
        .table-item { border: 1px solid #ccc; padding: 15px; text-align: center; border-radius: 5px; }
        .table-item.available { background-color: #d4edda; }
        .table-item.occupied { background-color: #f8d7da; }
        .table-item a { text-decoration: none; color: #007bff; }
        .table-item a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center my-4">Chọn bàn</h1>
        <div class="table-grid">
            <%
                if (tableList != null && !tableList.isEmpty()) {
                    DAO.OrderDAO orderDAO = new DAO.OrderDAO(); // Tạo instance OrderDAO để lấy orderId
                    for (Table table : tableList) {
                        String statusClass = "table-item " + ("Available".equals(table.getTableStatus()) ? "available" : "occupied");
                        String orderId = "Occupied".equals(table.getTableStatus()) ? orderDAO.getOrderIdByTableId(table.getTableId()) : null;
            %>
            <div class="<%= statusClass %>">
                <p><strong>Bàn: <%= table.getTableId() %></strong></p>
                <p>Số ghế: <%= table.getNumberOfSeats() %></p>
                <p>Tầng: <%= table.getFloorNumber() %></p>
                <p>Trạng thái: <%= table.getTableStatus() %></p>
                <%
                    if ("Available".equals(table.getTableStatus())) {
                %>
                <a href="order?action=selectDish&tableId=<%= table.getTableId() %>">Chọn bàn</a>
                <%
                    } else if ("Occupied".equals(table.getTableStatus()) && orderId != null) {
                %>
                <a href="order?action=viewOrder&orderId=<%= orderId %>">Xem/Cập nhật Order</a>
                <%
                    } else {
                %>
                <span>Đã sử dụng (Chưa có Order)</span>
                <%
                    }
                %>
            </div>
            <%
                    }
                } else {
            %>
            <p class="text-center">Không có bàn nào.</p>
            <%
                }
            %>
        </div>
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/ViewOrderList" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</body>
</html>