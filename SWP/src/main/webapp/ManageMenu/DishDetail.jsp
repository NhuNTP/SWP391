<%@page import="Model.InventoryItem"%>
<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.InventoryItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="update-container">
    <%
        Dish dish = (Dish) request.getAttribute("dish");
        List<DishInventory> dishIngredients = (List<DishInventory>) request.getAttribute("dishIngredients");
        List<InventoryItem> ingredients = (List<InventoryItem>) request.getAttribute("ingredients");

        if (dish != null) {
    %>
    <div class="left-section">
        <h2><%= dish.getDishName() %></h2>
        <div class="form-group">
            <label>Type:</label>
            <span><%= dish.getDishType() %></span>
        </div>
        <div class="form-group">
            <label>Price:</label>
            <span><%= dish.getDishPrice() %> VNĐ</span>
        </div>
        <div class="form-group">
            <label>Description:</label>
            <span><%= dish.getDishDescription() != null ? dish.getDishDescription() : "N/A" %></span>
        </div>
        <div class="form-group">
            <label>Image:</label>
            <img src="<%= dish.getDishImage() != null ? dish.getDishImage() : "" %>" alt="Dish Image" width="200">
        </div>
    </div>

    <div class="right-section">
        <h2>Ingredients</h2>
        <div class="ingredient-list">
        <%
            if (ingredients != null && !ingredients.isEmpty() && dishIngredients != null && !dishIngredients.isEmpty()) {
                for (int i = 0; i < ingredients.size(); i++) {
                    InventoryItem ingredient = ingredients.get(i);
                    DishInventory dishInventory = dishIngredients.get(i);
        %>
            <div class="ingredient-item">
                <label><%= ingredient.getItemName() %> (<%= ingredient.getItemUnit() %>):</label>
                <span><%= dishInventory.getQuantityUsed() %></span>
            </div>
        <%
                }
            } else {
        %>
            <p>No ingredients found for this dish.</p>
        <%
            }
        %>
        </div>
    </div>
    <%
        } else {
    %>
    <p class="alert alert-danger">Dish not found.</p>
    <%
        }
    %>
</div>