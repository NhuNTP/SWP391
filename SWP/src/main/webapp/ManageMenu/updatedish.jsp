<%@ page import="Model.Dish" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Dish</title>
</head>
<body>
    <h1>Update Dish</h1>

    <%
        Dish dish = (Dish) request.getAttribute("dish");
        if (dish != null) {
    %>

    <form action="updatedish" method="post" enctype="multipart/form-data">
        <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">

        <label for="dishName">Name:</label><br>
        <input type="text" id="dishName" name="dishName" value="<%= dish.getDishName() %>"><br><br>

        <label for="dishType">Type:</label><br>
        <input type="text" id="dishType" name="dishType" value="<%= dish.getDishType() %>"><br><br>

        <label for="dishPrice">Price:</label><br>
        <input type="number" id="dishPrice" name="dishPrice" step="0.01" value="<%= dish.getDishPrice() %>"><br><br>

        <label for="dishDescription">Description:</label><br>
        <textarea id="dishDescription" name="dishDescription"><%= dish.getDishDescription() %></textarea><br><br>

        <label for="dishImage">Image:</label><br>
        <img src="<%= dish.getDishImage() %>" alt="Current Image" width="100"><br>
        <input type="hidden" name="oldDishImage" value="<%= dish.getDishImage() %>">
        <input type="file" id="dishImage" name="dishImage"><br><br>

        <label for="dishStatus">Dish Status:</label><br>
        <select id="dishStatus" name="dishStatus">
            <option value="Available" <%= "Available".equals(dish.getDishStatus()) ? "selected" : "" %>>Available</option>
            <option value="Unavailable" <%= "Unavailable".equals(dish.getDishStatus()) ? "selected" : "" %>>Unavailable</option>
        </select><br><br>

        <label for="ingredientStatus">Ingredient Status:</label><br>
        <select id="ingredientStatus" name="ingredientStatus">
            <option value="Sufficient" <%= "Sufficient".equals(dish.getIngredientStatus()) ? "selected" : "" %>>Sufficient</option>
            <option value="Insufficient" <%= "Insufficient".equals(dish.getIngredientStatus()) ? "selected" : "" %>>Insufficient</option>
        </select><br><br>

        <input type="submit" value="Update">
    </form>

    <% } else { %>
        <p>Dish not found.</p>
    <% } %>
    <a href="viewalldish">Back to All Dishes</a>
</body>
</html>