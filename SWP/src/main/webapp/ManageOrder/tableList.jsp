<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Table, java.util.List" %>
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
    </style>
</head>
<body>
    <div class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></div>
    <div class="container">
        <h1>Danh sách bàn</h1>
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
                <th>Hành động</th>
            </tr>
            <%
                for (Table table : tables) {
            %>
            <tr>
                <td><%=table.getTableId()%></td>
                <td><%=table.getTableStatus()%></td>
                <td><%=table.getNumberOfSeats()%></td>
                <td><%=table.getFloorNumber()%></td>
                <td>
                    <a href="order?action=tableOverview&tableId=<%=table.getTableId()%>">
                        <button class="button">Chọn bàn</button>
                    </a>
                </td>
            </tr>
            
            <%
                }
            %>
        </table>
        <%
            } else {
        %>
        <p>Không có bàn nào khả dụng.</p>
        <%
            }
        %>
    </div>
</body>
</html>