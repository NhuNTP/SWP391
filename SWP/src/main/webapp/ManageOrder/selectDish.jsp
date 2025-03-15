<%@page import="java.util.ArrayList"%>
<%@page import="Model.Dish"%>
<%@page import="DAO.MenuDAO"%>
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

    List<Dish> dishList = (List<Dish>) request.getAttribute("dishes");
    String tableId = (String) request.getAttribute("tableId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn món cho bàn <%= tableId %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { background-color: #f8f9fa; font-family: 'Roboto', sans-serif; }
        .dish-table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        .dish-table th, .dish-table td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        .dish-table th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center my-4">Chọn món cho bàn <%= tableId %></h1>
        <form id="createOrderForm" action="order" method="post">
            <input type="hidden" name="action" value="createOrder">
            <input type="hidden" name="tableId" value="<%= tableId %>">
            <table class="dish-table">
                <thead>
                    <tr>
                        <th>Tên món</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng phụ</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (dishList != null && !dishList.isEmpty()) {
                            boolean hasAvailableDishes = false;
                            for (Dish dish : dishList) {
                                if ("Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                                    hasAvailableDishes = true;
                    %>
                    <tr>
                        <td><%= dish.getDishName() %></td>
                        <td>
                            <input type="hidden" id="price_<%= dish.getDishId() %>" value="<%= dish.getDishPrice() %>">
                            <%= dish.getDishPrice() %>
                        </td>
                        <td>
                            <button type="button" onclick="decreaseQuantity('<%= dish.getDishId() %>')">-</button>
                            <input type="number" id="quantity_<%= dish.getDishId() %>" name="quantity_<%= dish.getDishId() %>" value="0" min="0" onchange="updateSubtotal('<%= dish.getDishId() %>')">
                            <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
                            <button type="button" onclick="increaseQuantity('<%= dish.getDishId() %>')">+</button>
                        </td>
                        <td><span id="subtotal_<%= dish.getDishId() %>">0.00</span></td>
                    </tr>
                    <%
                                }
                            }
                            if (!hasAvailableDishes) {
                    %>
                    <tr><td colspan="4">Không có món nào khả dụng.</td></tr>
                    <%
                            }
                        } else {
                    %>
                    <tr><td colspan="4">Không có món nào khả dụng.</td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <div class="text-center my-3">
                <button type="button" class="btn btn-primary" onclick="submitOrder()">Xác nhận</button>
                <a href="order?action=selectTable" class="btn btn-secondary">Quay lại</a>
            </div>
        </form>
    </div>

    <script>
        function increaseQuantity(dishId) {
            var input = document.getElementById("quantity_" + dishId);
            input.value = parseInt(input.value) + 1;
            updateSubtotal(dishId);
        }

        function decreaseQuantity(dishId) {
            var input = document.getElementById("quantity_" + dishId);
            if (parseInt(input.value) > 0) {
                input.value = parseInt(input.value) - 1;
                updateSubtotal(dishId);
            }
        }

        function updateSubtotal(dishId) {
            var quantity = parseInt(document.getElementById("quantity_" + dishId).value);
            var price = parseFloat(document.getElementById("price_" + dishId).value);
            var subtotal = quantity * price;
            document.getElementById("subtotal_" + dishId).innerText = isNaN(subtotal) ? "0.00" : subtotal.toFixed(2);
        }

        function submitOrder() {
            $('#createOrderForm').submit();
        }
    </script>
</body>
</html>