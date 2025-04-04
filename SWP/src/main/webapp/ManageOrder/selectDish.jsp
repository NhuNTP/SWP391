<%@page import="Model.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Dish, java.util.List" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
    String returnTo = (String) request.getAttribute("returnTo");
    if (returnTo == null) {
        returnTo = "listTables"; // Mặc định là listTables nếu không có returnTo
    }
%>
<html>
<head>
    <title>Chọn món ăn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .dish-list { width: 100%; border-collapse: collapse; }
        .dish-list th, .dish-list td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .dish-list th { background-color: #4CAF50; color: white; }
        .button { padding: 8px 15px; border: none; border-radius: 5px; color: white; cursor: pointer; }
        .button:hover { opacity: 0.9; }
        .btn-primary { background-color: #2196F3; }
        .btn-success { background-color: #4CAF50; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        input[type="number"] { width: 60px; padding: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Chọn món ăn cho bàn <%= request.getAttribute("tableId") %></h1>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="${pageContext.request.contextPath}/order" method="post">
            <input type="hidden" name="action" value="submitOrder">
            <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
            <table class="dish-list">
                <tr>
                    <th>Tên món</th>
                    <th>Loại</th>
                    <th>Giá</th>
                    <th>Mô tả</th>
                    <th>Số lượng</th>
                </tr>
                <% if (dishes != null && !dishes.isEmpty()) { %>
                    <% for (Dish dish : dishes) { %>
                        <tr>
                            <td><%= dish.getDishName() %></td>
                            <td><%= dish.getDishType() %></td>
                            <td><%= dish.getDishPrice() %> VNĐ</td>
                            <td><%= dish.getDishDescription() %></td>
                            <td>
                                <input type="number" name="quantity_<%= dish.getDishId() %>" min="0" value="0">
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Không có món ăn nào khả dụng.</td>
                    </tr>
                <% } %>
            </table>
            <div style="text-align: center; margin-top: 20px;">
                <button type="submit" class="button btn-success">Thêm vào đơn hàng</button>
                <%
                    String returnUrl;
                    if ("tableOverview".equals(returnTo)) {
                        returnUrl = request.getContextPath() + "/order?action=tableOverview&tableId=" + request.getAttribute("tableId");
                    } else {
                        returnUrl = request.getContextPath() + "/order?action=listTables";
                    }
                %>
                <a href="<%= returnUrl %>" class="button btn-primary" style="margin-left: 10px;">Quay lại</a>
            </div>
        </form>
    </div>
</body>
</html>