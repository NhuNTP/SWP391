<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Dish, java.util.List" %>
<html>
<head>
    <title>Chọn món</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .dish-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .dish-table th, .dish-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .dish-table th { background-color: #4CAF50; color: white; }
        .button { padding: 12px 20px; margin: 5px; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 16px; }
        .button.submit { background-color: #2196F3; }
        .button.back { background-color: #9E9E9E; }
        .button:hover { opacity: 0.9; }
        input[type="number"] { width: 60px; padding: 5px; }
        .error { color: red; text-align: center; }
    </style>
    <script>
        function validateForm() {
            let inputs = document.querySelectorAll('input[type="number"]');
            for (let input of inputs) {
                if (input.value < 0) {
                    alert("Số lượng không thể âm!");
                    return false;
                }
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Chọn món cho bàn <%= request.getParameter("tableId") %></h1>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="order" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="submitOrder">
            <input type="hidden" name="tableId" value="<%= request.getParameter("tableId") %>">
            <table class="dish-table">
                <tr><th>Tên món</th><th>Giá</th><th>Số lượng</th></tr>
                <%
                    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
                    if (dishes != null && !dishes.isEmpty()) {
                        for (Dish dish : dishes) {
                            if ("Available".equals(dish.getDishStatus())) {
                %>
                <tr>
                    <td><%= dish.getDishName() %></td>
                    <td><%= String.format("%.2f", dish.getDishPrice()) %> VND</td>
                    <td>
                        <input type="number" name="quantity_<%= dish.getDishId() %>" min="0" value="0">
                        <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
                    </td>
                </tr>
                <%      }
                        }
                    } else {
                %>
                <tr><td colspan="3">Không có món nào khả dụng.</td></tr>
                <% } %>
            </table>
            <button type="submit" class="button submit">Thêm vào đơn</button>
            <a href="order?action=tableOverview&tableId=<%= request.getParameter("tableId") %>"><button type="button" class="button back">Quay lại</button></a>
        </form>
    </div>
</body>
</html>