<%@page import="Model.InventoryItem"%>
<%@page import="Model.Account"%>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Dish</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(to bottom, #2C3E50, #34495E);
            color: white;
            height: 100vh;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
        }
        .sidebar a:hover {
            background-color: #1A252F;
        }
        .sidebar .nav-link {
            font-size: 0.9rem;
        }
        .sidebar h4 {
            font-size: 1.5rem;
        }
        .content-area {
            padding: 20px;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        label {
            width: 150px;
            font-weight: bold;
            margin-right: 10px;
            flex-shrink: 0;
        }
        input[type="text"],
        input[type="number"],
        select,
        textarea {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        textarea {
            min-height: 80px;
        }
        input[type="number"].quantity-input {
            width: 80px;
            margin-left: 5px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .ingredient-list {
            max-height: 500px;
            overflow-y: auto;
            background-color: #fff;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .ingredient-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            max-width: 50%;
        }
        .ingredient-item label {
            width: 75%;
            font-size: 0.9em;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
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
    <div class="d-flex">
        <!-- Sidebar -->
        <div class="sidebar col-md-2 p-3">
            <h4 class="text-center mb-4">Admin</h4>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/view-revenue" class="nav-link"><i class="fas fa-chart-line me-2"></i>View Revenue</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
           
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>View Notifications</a></li>
                <% if ("Admin".equals(UserRole) || "Manager".equals(UserRole)) { %>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>
                <% } %>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4 content-area">
            <h3>Add New Dish</h3>
            <% if (request.getSession().getAttribute("message") != null) { %>
            <div class="alert alert-success" id="successMessage">
                <%= request.getSession().getAttribute("message") %>
            </div>
            <% request.getSession().removeAttribute("message"); %>
            <% } %>
            <% if (request.getSession().getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" id="errorMessage">
                <%= request.getSession().getAttribute("errorMessage") %>
            </div>
            <% request.getSession().removeAttribute("errorMessage"); %>
            <% } %>

            <form action="${pageContext.request.contextPath}/addnewdish" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <div class="row">
                    <!-- Left Column: Dish Details -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="dishName">Dish Name:</label>
                            <input type="text" id="dishName" name="dishName" required>
                        </div>
                        <div class="form-group">
                            <label for="dishType">Dish Type:</label>
                            <select id="dishType" name="dishType">
                                <option value="Food">Food</option>
                                <option value="Drink">Drink</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="dishPrice">Price:</label>
                            <input type="number" id="dishPrice" name="dishPrice" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="dishDescription">Description:</label>
                            <textarea id="dishDescription" name="dishDescription"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="dishImage">Image:</label>
                            <input type="file" id="dishImage" name="dishImage">
                        </div>
                        <input type="submit" value="Add Dish">
                    </div>

                    <!-- Right Column: Ingredients -->
                    <div class="col-md-6">
                        <h4>Ingredients</h4>
                        <div class="ingredient-list">
                            <%
                                List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");
                                if (inventoryList != null && !inventoryList.isEmpty()) {
                                    for (InventoryItem inventory : inventoryList) {
                            %>
                            <div class="ingredient-item">
                                <label for="itemId<%= inventory.getItemId() %>"><%= inventory.getItemName() %> (<%= inventory.getItemUnit() %>) - Quantity: <%= inventory.getItemQuantity() %></label>
                                <input type="checkbox" id="itemId<%= inventory.getItemId() %>" name="itemId" value="<%= inventory.getItemId() %>" onclick="showQuantityInput('<%= inventory.getItemId() %>')">
                                <input type="number" class="quantity-input" id="quantityUsed<%= inventory.getItemId() %>" name="quantityUsed<%= inventory.getItemId() %>" placeholder="Qty" step="0.01" style="display:none;">
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <p class="error">No ingredients available.</p>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            setTimeout(function() {
                $('#successMessage').fadeOut('slow');
                $('#errorMessage').fadeOut('slow');
            }, 10000);
        });
    </script>
</body>
</html>