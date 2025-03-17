<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Dish, java.util.List" %>
<html>
<head>
    <title>Chọn món ăn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; text-align: center; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .dish-table { width: 100%; border-collapse: collapse; }
        .dish-table th, .dish-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .dish-table th { background-color: #4CAF50; color: white; }
        .button { padding: 12px 20px; border: none; border-radius: 5px; color: white; cursor: pointer; background-color: #4CAF50; }
        .button:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Chọn món ăn</h1>
        <form action="order" method="post">
            <input type="hidden" name="action" value="submitOrder">
            <input type="hidden" name="orderId" value="<%=request.getAttribute("orderId") != null ? request.getAttribute("orderId") : ""%>">
            <input type="hidden" name="tableId" value="<%=request.getAttribute("tableId")%>">
            <table class="dish-table">
                <tr><th>Tên món</th><th>Loại</th><th>Giá</th><th>Số lượng</th></tr>
                <%
                    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
                    if (dishes != null) {
                        for (Dish dish : dishes) {
                %>
                <tr>
                    <td><%=dish.getDishName()%></td>
                    <td><%=dish.getDishType()%></td>
                    <td><%=String.format("%.2f", dish.getDishPrice())%> VND</td>
                    <td>
                        <input type="number" name="quantity" min="0" value="0">
                        <input type="hidden" name="dishId" value="<%=dish.getDishId()%>">
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </table>
            <button type="submit" class="button">Thêm món</button>
        </form>
    </div>
</body>
</html>