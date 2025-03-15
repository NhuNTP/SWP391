<%@page import="Model.InventoryItem"%>
<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.InventoryItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="update-container" style="display: flex; flex-direction: row;">
    <%
        Dish dish = (Dish) request.getAttribute("dish");
        List<DishInventory> dishIngredients = (List<DishInventory>) request.getAttribute("dishIngredients");
        List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");

        if (dish != null) {
    %>
    <form action="updatedish" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
        
        <div class="left-section" style="flex: 1;">
            <div class="form-group">
                <label for="dishName">Name:</label>
                <input type="text" id="dishName" name="dishName" value="<%= dish.getDishName() %>">
            </div>
            <div class="form-group">
                <label for="dishType">Type:</label>
                <input type="text" id="dishType" name="dishType" value="<%= dish.getDishType() %>">
            </div>
            <div class="form-group">
                <label for="dishPrice">Price:</label>
                <input type="number" id="dishPrice" name="dishPrice" step="0.01" value="<%= dish.getDishPrice() %>">
            </div>
            <div class="form-group">
                <label for="dishDescription">Description:</label>
                <textarea id="dishDescription" name="dishDescription"><%= dish.getDishDescription() != null ? dish.getDishDescription() : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="dishImage">Image:</label>
                <div>
                    <img src="<%= dish.getDishImage() != null ? dish.getDishImage() : "" %>" alt="Current Image">
                    <input type="hidden" name="oldDishImage" value="<%= dish.getDishImage() != null ? dish.getDishImage() : "" %>">
                    <input type="file" id="dishImage" name="dishImage">
                </div>
            </div>
            <div class="form-group">
                <label for="dishStatus">Dish Status:</label>
                <select id="dishStatus" name="dishStatus">
                    <option value="Available" <%= "Available".equals(dish.getDishStatus()) ? "selected" : "" %>>Available</option>
                    <option value="Unavailable" <%= "Unavailable".equals(dish.getDishStatus()) ? "selected" : "" %>>Unavailable</option>
                </select>
            </div>
            <div class="form-group">
                <label for="ingredientStatus">Ingredient Status:</label>
                <input type="text" id="ingredientStatus" value="<%= dish.getIngredientStatus() %>" readonly>
            </div>
        </div>

        <div class="right-section" style="flex: 1;">
            <h2>Ingredients</h2>
            <div class="ingredient-list">
            <%
                if (inventoryList != null && !inventoryList.isEmpty()) {
                    for (InventoryItem inventory : inventoryList) {
                        String itemId = inventory.getItemId();
                        DishInventory existingIngredient = null;
                        if (dishIngredients != null) {
                            for (DishInventory di : dishIngredients) {
                                if (di.getItemId().equals(itemId)) {
                                    existingIngredient = di;
                                    break;
                                }
                            }
                        }
            %>
            <div class="ingredient-item">
                <label for="itemId<%= itemId %>"><%= inventory.getItemName() %> (<%= inventory.getItemUnit() %>) - <%= inventory.getItemQuantity() %></label>
                <input type="checkbox" id="itemId<%= itemId %>" name="itemId" value="<%= itemId %>"
                       onclick="showQuantityInput('<%= itemId %>')"
                       <%= existingIngredient != null ? "checked" : "" %>>
                <input type="number" class="quantity-input" id="quantityUsed<%= itemId %>" name="quantityUsed<%= itemId %>"
                       step="0.01" placeholder="Qty"
                       value="<%= existingIngredient != null ? existingIngredient.getQuantityUsed() : "" %>"
                       style="display:<%= existingIngredient != null ? "inline" : "none" %>;">
            </div>
            <%
                    }
                } else {
            %>
            <p>No ingredients available.</p>
            <%
                }
            %>
            </div>
        </div>
    </form>
    <%
        } else {
    %>
    <p class="alert alert-danger">Dish not found.</p>
    <%
        }
    %>
</div>
<script>
    function showQuantityInput(itemId) {
        var quantityInput = document.getElementById("quantityUsed" + itemId);
        if (document.getElementById("itemId" + itemId).checked) {
            quantityInput.style.display = "inline";
        } else {
            quantityInput.style.display = "none";
            quantityInput.value = "";
        }
    }

    function validateForm() {
        var checkboxes = document.getElementsByName("itemId");
        var isChecked = false;
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                isChecked = true;
                var itemId = checkboxes[i].value;
                var quantityInput = document.getElementById("quantityUsed" + itemId);
                if (!quantityInput.value || quantityInput.value <= 0) {
                    alert("Please enter a valid quantity for " + document.querySelector('label[for="itemId' + itemId + '"]').textContent);
                    return false;
                }
            }
        }
        if (!isChecked) {
            alert("Please select at least one ingredient.");
            return false;
        }
        return true;
    }
</script>