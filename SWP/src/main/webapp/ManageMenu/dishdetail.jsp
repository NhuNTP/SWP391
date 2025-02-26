<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.Inventory" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dish Details</title>
</head>
<body>
    <h1>Dish Details</h1>

    <%
        Dish dish = (Dish) request.getAttribute("dish");
        List<DishInventory> dishIngredients = (List<DishInventory>) request.getAttribute("dishIngredients");
        List<Inventory> ingredients = (List<Inventory>) request.getAttribute("ingredients");

        if (dish != null) {
    %>
    <h2><%= dish.getDishName() %></h2>
    <p>Type: <%= dish.getDishType() %></p>
    <p>Price: <%= dish.getDishPrice() %></p>
    <p>Description: <%= dish.getDishDescription() %></p>
    <img src="<%= dish.getDishImage() %>" alt="Dish Image" width="200">

    <h3>Ingredients:</h3>
    <% if (ingredients != null && !ingredients.isEmpty()) { %>
        <ul>
            <% for (int i = 0; i < ingredients.size(); i++) {
                Inventory ingredient = ingredients.get(i);
                DishInventory dishInventory = dishIngredients.get(i);
            %>
                <li><%= ingredient.getItemName() %> - Quantity Used: <%= dishInventory.getQuantityUsed() %></li>
            <% } %>
        </ul>
    <% } else { %>
        <p>No ingredients found for this dish.</p>
    <% } %>

    <% } else { %>
        <p>Dish not found.</p>
    <% } %>

    <a href="viewalldishes">Back to All Dishes</a>
</body>
</html>