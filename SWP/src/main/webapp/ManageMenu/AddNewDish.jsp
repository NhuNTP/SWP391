<%@page import="Model.InventoryItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.InventoryItem" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Dish</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        p {
            text-align: center;
        }

        form {
            width: 60%;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: inline-block;
            width: 150px;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="number"],
        select,
        textarea {
            width: 70%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        select {
            height: 34px;
        }

        input[type="file"] {
            margin-bottom: 15px;
        }

        input[type="checkbox"] {
            margin-right: 5px;
        }

        input[type="number"][style="display:none;"] {
            width: 30%;
            margin-left: 10px;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            float: right;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .error {
            color: red;
        }

        .success {
            color: green;
        }
    </style>
    <script>
       function showQuantityInput(itemId) {
    var quantityInput = document.getElementById("quantityUsed" + itemId);
    console.log("Item ID: " + itemId + ", Quantity Input: ", quantityInput); // Debug
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
                    if (quantityInput.value.trim() === "" || quantityInput.value <= 0) {
                        alert("Please enter a valid quantity for the selected ingredient: " + document.querySelector('label[for="itemId' + itemId + '"]').textContent);
                        quantityInput.focus();
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
    <h1>Add New Dish</h1>

    <% if (request.getAttribute("message") != null) { %>
        <p class="success"><%= request.getAttribute("message") %></p>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <!-- ... (Phần đầu giữ nguyên) -->
<form action="${pageContext.request.contextPath}/addnewdish" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
    <label for="dishName">Dish Name:</label>
    <input type="text" id="dishName" name="dishName" required><br><br>

    <label for="dishType">Dish Type:</label>
    <select id="dishType" name="dishType">
        <option value="Food">Food</option>
        <option value="Drink">Drink</option>
    </select><br><br>

    <label for="dishPrice">Price:</label>
    <input type="number" id="dishPrice" name="dishPrice" step="0.01" required><br><br>

    <label for="dishDescription">Description:</label>
    <textarea id="dishDescription" name="dishDescription"></textarea><br><br>

    <label for="dishImage">Image:</label>
    <input type="file" id="dishImage" name="dishImage"><br><br>

    <h2>Ingredients</h2>
    <%
        List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");
        if (inventoryList != null && !inventoryList.isEmpty()) {
            for (InventoryItem inventory : inventoryList) {
    %>
    <div>
        <label for="itemId<%= inventory.getItemId() %>"><%= inventory.getItemName() %> (<%= inventory.getItemUnit() %>) - Quantity: <%= inventory.getItemQuantity() %></label>
        <input type="checkbox" id="itemId<%= inventory.getItemId() %>" name="itemId" value="<%= inventory.getItemId() %>" onclick="showQuantityInput('<%= inventory.getItemId() %>')">
        <input type="number" id="quantityUsed<%= inventory.getItemId() %>" name="quantityUsed<%= inventory.getItemId() %>" placeholder="Quantity Used" step="0.01" style="display:none;">
    </div>
    <%
            }
        }
    %>
    <br>
    <input type="submit" value="Add Dish">
</form>
</body>
</html>
<!-- ok -->