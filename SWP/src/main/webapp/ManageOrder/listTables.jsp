<%@page import="Model.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Table, java.util.List" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
    if (!"Waiter".equals(UserRole)) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>
<html>
    <head>
        <title>Danh sách bàn</title>
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
            .table-list {
                width: 100%;
                border-collapse: collapse;
            }
            .table-list th, .table-list td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            .table-list th {
                background-color: #4CAF50;
                color: white;
            }
            .button {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                color: white;
                cursor: pointer;
                background-color: #2196F3;
            }
            .button:hover {
                opacity: 0.9;
            }
            .error {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }
        </style>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link">Logout</a></div>
        <div class="container">
            <h1>Danh sách bàn</h1>
            <% if (request.getAttribute("error") != null) {%>
            <p class="error"><%= request.getAttribute("error")%></p>
            <% } %>
            <%
                List<Table> tables = (List<Table>) request.getAttribute("tables");
                if (tables != null && !tables.isEmpty()) {
            %>
            <table class="table-list">
                <tr>
                    <th>Mã bàn</th>
                    <th>Trạng thái</th>
                    <th>Số ghế</th>
                    <th>Tầng</th>
                    <th>Đơn hàng</th>
                    <th>Hành động</th>
                </tr>
                <%
                    for (Table table : tables) {
                %>
                <tr>
                    <td><%= table.getTableId()%></td>
                    <td><%= table.getTableStatus()%></td>
                    <td><%= table.getNumberOfSeats()%></td>
                    <td><%= table.getFloorNumber()%></td>
                    <td><%= table.isHasOrder() ? "Có (Pending)" : "Không"%></td>
                    <td>
                        <% if ("Available".equals(table.getTableStatus())) {%>
                        <a href="#" onclick="handleTableClick('<%= table.getTableId()%>'); return false;">
                            <button class="button">Chọn bàn</button>
                        </a>
                        <% } else {%>
                        <a href="#" onclick="handleTableClick('<%= table.getTableId()%>'); return false;">
                            <button class="button">Xem</button>
                        </a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>Không có bàn nào khả dụng.</p>
            <% }%>
        </div>

        <script>
            function handleTableClick(tableId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/order',
                    type: 'GET',
                    data: {action: 'checkOrderByTable', tableId: tableId},
                    success: function (response) {
                        if (response.orderId) {
                            window.location.href = '${pageContext.request.contextPath}/order?action=tableOverview&tableId=' + tableId;
                        } else {
                            window.location.href = '${pageContext.request.contextPath}/order?action=selectDish&tableId=' + tableId + '&returnTo=listTables';
                        }
                    },
                    error: function (xhr, status, error) {
                        alert('Error checking table: ' + error);
                    }
                });
            }
        </script>
    </body>
</html>
