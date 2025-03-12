<%@page import="Model.InventoryItem"%>
<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.InventoryItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Dish</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        label { display: inline-block; width: 150px; font-weight: bold; }
        input[type="text"], input[type="number"], select, textarea {
            width: 70%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px;
        }
        input[type="number"][style="display:none;"] { width: 30%; margin-left: 10px; }
        input[type="submit"] { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .alert { padding: 10px; margin: 10px 0; }
        .alert-success { background-color: #dff0d8; color: #3c763d; }
        .alert-danger { background-color: #f2dede; color: #a94442; }
    </style>
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
</head>
<body>
    <h1>Update Dish</h1>
    <%
        Dish dish = (Dish) request.getAttribute("dish");
        List<DishInventory> dishIngredients = (List<DishInventory>) request.getAttribute("dishIngredients");
        List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");

        if (dish != null) {
    %>
    <!-- ... (Phần đầu giữ nguyên) -->
<form action="updatedish" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
    <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">

    <label for="dishName">Name:</label><br>
    <input type="text" id="dishName" name="dishName" value="<%= dish.getDishName() %>"><br><br>

    <label for="dishType">Type:</label><br>
    <input type="text" id="dishType" name="dishType" value="<%= dish.getDishType() %>"><br><br>

    <label for="dishPrice">Price:</label><br>
    <input type="number" id="dishPrice" name="dishPrice" step="0.01" value="<%= dish.getDishPrice() %>"><br><br>

    <label for="dishDescription">Description:</label><br>
    <textarea id="dishDescription" name="dishDescription"><%= dish.getDishDescription() != null ? dish.getDishDescription() : "" %></textarea><br><br>

    <label for="dishImage">Image:</label><br>
    <img src="<%= dish.getDishImage() != null ? dish.getDishImage() : "" %>" alt="Current Image" width="100"><br>
    <input type="hidden" name="oldDishImage" value="<%= dish.getDishImage() != null ? dish.getDishImage() : "" %>">
    <input type="file" id="dishImage" name="dishImage"><br><br>

    <label for="dishStatus">Dish Status:</label><br>
    <select id="dishStatus" name="dishStatus">
        <option value="Available" <%= "Available".equals(dish.getDishStatus()) ? "selected" : "" %>>Available</option>
        <option value="Unavailable" <%= "Unavailable".equals(dish.getDishStatus()) ? "selected" : "" %>>Unavailable</option>
    </select><br><br>

    <label for="ingredientStatus">Ingredient Status:</label><br>
    <input type="text" id="ingredientStatus" value="<%= dish.getIngredientStatus() %>" readonly><br><br>

    <h2>Ingredients</h2>
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
    <div>
        <label for="itemId<%= itemId %>"><%= inventory.getItemName() %> (<%= inventory.getItemUnit() %>) - Available: <%= inventory.getItemQuantity() %></label>
        <input type="checkbox" id="itemId<%= itemId %>" name="itemId" value="<%= itemId %>"
               onclick="showQuantityInput('<%= itemId %>')"
               <%= existingIngredient != null ? "checked" : "" %>>
        <input type="number" id="quantityUsed<%= itemId %>" name="quantityUsed<%= itemId %>"
               step="0.01" placeholder="Quantity Used"
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
    <br>
</form>
<!-- ... (Phần còn lại giữ nguyên) -->
    <%
        } else {
    %>
    <p>Dish not found.</p>
    <%
        }
    %>
</body>
</html>
<!-- ok -->