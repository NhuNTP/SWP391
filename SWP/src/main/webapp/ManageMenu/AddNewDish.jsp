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
            margin: 0;
            padding: 0;
        }
        .sidebar {
            background: linear-gradient(to bottom, #2C3E50, #34495E);
            color: white;
            height: 100vh;
            position: fixed;
            width: 16.67%;
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
            padding: 10px 15px;
        }
        .sidebar h4 {
            font-size: 1.5rem;
            padding: 15px 0;
        }
        .top-navbar {
            position: fixed;
            top: 0;
            left: 16.67%;
            width: 83.33%;
            background-color: #2C3E50;
            color: white;
            padding: 15px 25px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .top-navbar h3 {
            margin: 0;
            font-size: 1.5rem;
        }
        .top-navbar input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s;
        }
        .top-navbar input[type="submit"]:hover {
            background-color: #45a049;
        }
        .content-area {
            margin-left: 16.67%;
            padding: 80px 30px 30px 30px;
        }
        .form-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }
        input[type="text"],
        input[type="number"],
        select,
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus,
        textarea:focus {
            border-color: #4CAF50;
            outline: none;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        input[type="number"].quantity-input {
            width: 90px;
            padding: 8px;
            margin-left: 15px;
            display: none;
        }
        .ingredient-list {
            max-height: 400px;
            overflow-y: auto;
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }
        .ingredient-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            padding: 10px;
            background: white;
            border-radius: 6px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            transition: background-color 0.3s;
        }
        .ingredient-item label {
            flex: 1;
            font-size: 0.95rem;
            margin: 0;
        }
        .ingredient-item:has(input[type="checkbox"]:checked) {
            background-color: #e6ffe6;
        }
        #imagePreview {
            max-width: 200px;
            max-height: 200px;
            margin-top: 15px;
            border-radius: 6px;
            display: none;
            border: 1px solid #ddd;
        }
        .error {
            color: #dc3545;
            font-size: 0.9rem;
            margin-top: 5px;
            display: block;
        }
        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #4CAF50;
            color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            z-index: 1000;
            font-size: 1.2rem;
        }
        .ingredient-controls {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        #ingredientSearch {
            flex: 1;
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        #ingredientFilter {
            width: 160px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
        }
        .no-ingredient-message {
            text-align: center;
            color: #dc3545;
            margin-top: 20px;
            font-size: 1rem;
        }
        .add-ingredient-btn {
            display: block;
            margin: 15px auto;
            background-color: #4CAF50;
            color: white;
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            text-align: center;
            width: fit-content;
            transition: background-color 0.3s;
        }
        .add-ingredient-btn:hover {
            background-color: #45a049;
            color: white;
            text-decoration: none;
        }
    </style>
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

        <!-- Top Navbar -->
        <nav class="top-navbar">
            <h3>Add New Dish</h3>
            <div class="nav-buttons">
                <input type="submit" form="addDishForm" value="Add Dish">
            </div>
        </nav>

        <!-- Main Content -->
        <div class="col-md-10 content-area">
            <div id="successPopup" class="popup"></div>

            <form id="addDishForm" action="${pageContext.request.contextPath}/addnewdish" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <div class="row">
                    <!-- Left Column: Dish Details -->
                    <div class="col-md-6">
                        <div class="form-section">
                            <div class="form-group">
                                <label for="dishName">Dish Name</label>
                                <input type="text" id="dishName" name="dishName" value="<%= request.getParameter("dishName") != null ? request.getParameter("dishName") : "" %>">
                                <span id="dishNameError" class="error">
                                    <% if (request.getAttribute("errors") != null) {
                                        List<String> errors = (List<String>) request.getAttribute("errors");
                                        if (errors.contains("Dish name is required.")) {
                                            out.print("Dish name is required.");
                                        } else if (errors.contains("Dish name already exists.")) {
                                            out.print("Dish name already exists.");
                                        }
                                    } %>
                                </span>
                            </div>
                            <div class="form-group">
                                <label for="dishType">Dish Type</label>
                                <select id="dishType" name="dishType">
                                    <option value="Food" <%= "Food".equals(request.getParameter("dishType")) ? "selected" : "" %>>Food</option>
                                    <option value="Drink" <%= "Drink".equals(request.getParameter("dishType")) ? "selected" : "" %>>Drink</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="dishPrice">Price</label>
                                <input type="number" id="dishPrice" name="dishPrice" step="0.01" value="<%= request.getParameter("dishPrice") != null ? request.getParameter("dishPrice") : "" %>">
                                <span id="dishPriceError" class="error">
                                    <% if (request.getAttribute("errors") != null) {
                                        List<String> errors = (List<String>) request.getAttribute("errors");
                                        if (errors.contains("Price must be greater than 0.")) {
                                            out.print("Price must be greater than 0.");
                                        } else if (errors.contains("Invalid dish price format.")) {
                                            out.print("Invalid dish price format.");
                                        }
                                    } %>
                                </span>
                            </div>
                            <div class="form-group">
                                <label for="dishDescription">Description</label>
                                <textarea id="dishDescription" name="dishDescription"><%= request.getParameter("dishDescription") != null ? request.getParameter("dishDescription") : "" %></textarea>
                            </div>
                            <div class="form-group">
                                <label for="dishImage">Image</label>
                                <input type="file" id="dishImage" name="dishImage" onchange="previewImage(event)">
                                <img id="imagePreview" alt="Image Preview">
                                <span class="error">
                                    <% if (request.getAttribute("errors") != null) {
                                        List<String> errors = (List<String>) request.getAttribute("errors");
                                        for (String error : errors) {
                                            if (error.startsWith("Error uploading image")) {
                                                out.print(error);
                                            }
                                        }
                                    } %>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Ingredients -->
                    <div class="col-md-6">
                        <div class="form-section">
                            <h4 class="mb-4">Ingredients</h4>
                            <div class="ingredient-controls">
                                <select id="ingredientFilter">
                                    <option value="all">All</option>
                                    <option value="available">Available</option>
                                    <option value="unavailable">Unavailable</option>
                                </select>
                                <input type="text" id="ingredientSearch" placeholder="Search ingredients...">
                            </div>
                            <div class="ingredient-list" id="ingredientList">
                                <%
                                    List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");
                                    if (inventoryList != null && !inventoryList.isEmpty()) {
                                        for (InventoryItem inventory : inventoryList) {
                                %>
                                <div class="ingredient-item" data-quantity="<%= inventory.getItemQuantity() %>">
                                    <label for="itemId<%= inventory.getItemId() %>"><%= inventory.getItemName() %> (<%= inventory.getItemUnit() %>) - Quantity: <%= inventory.getItemQuantity() %></label>
                                    <input type="checkbox" id="itemId<%= inventory.getItemId() %>" name="itemId" value="<%= inventory.getItemId() %>"
                                           onclick="showQuantityInput('<%= inventory.getItemId() %>'); updateIngredientState('<%= inventory.getItemId() %>')">
                                    <input type="number" class="quantity-input" id="quantityUsed<%= inventory.getItemId() %>" name="quantityUsed<%= inventory.getItemId() %>"
                                           placeholder="Qty" step="0.01" oninput="updateQuantityState('<%= inventory.getItemId() %>')" onblur="renderIngredients()">
                                </div>
                                <%
                                        }
                                    } else {
                                %>
                                <p class="no-ingredient-message">No ingredients found. Do you want to go to the page to add ingredients to the system?</p>
                                <a href="${pageContext.request.contextPath}/ViewInventoryController" class="add-ingredient-btn">Add Ingredients</a>
                                <%
                                    }
                                %>
                            </div>
                            <span id="ingredientsError" class="error">
                                <% if (request.getAttribute("errors") != null) {
                                    List<String> errors = (List<String>) request.getAttribute("errors");
                                    if (errors.contains("Dish added but some ingredients failed.")) {
                                        out.print("Some ingredients failed to add.");
                                    }
                                } %>
                            </span>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let allIngredients = [];
        let ingredientStates = {};

        function showQuantityInput(itemId) {
            var quantityInput = document.getElementById("quantityUsed" + itemId);
            if (document.getElementById("itemId" + itemId).checked) {
                quantityInput.style.display = "inline";
            } else {
                quantityInput.style.display = "none";
                quantityInput.value = "";
            }
        }

        function updateIngredientState(itemId) {
            const checkbox = document.getElementById("itemId" + itemId);
            const quantityInput = document.getElementById("quantityUsed" + itemId);
            ingredientStates[itemId] = {
                checked: checkbox.checked,
                quantity: quantityInput.value
            };
            renderIngredients(); // Sắp xếp lại danh sách ngay khi checkbox thay đổi
        }

        function updateQuantityState(itemId) {
            const checkbox = document.getElementById("itemId" + itemId);
            const quantityInput = document.getElementById("quantityUsed" + itemId);
            if (checkbox.checked) {
                ingredientStates[itemId] = {
                    checked: true,
                    quantity: quantityInput.value
                };
            }
        }

        function validateForm() {
            var dishName = document.getElementById("dishName").value.trim();
            var dishPrice = document.getElementById("dishPrice").value;
            var checkboxes = document.getElementsByName("itemId");
            var isValid = true;

            document.querySelectorAll('.error').forEach(e => e.innerHTML = '');

            if (!dishName) {
                document.getElementById("dishNameError").innerHTML = "Dish name is required.";
                isValid = false;
            }

            if (!dishPrice || isNaN(dishPrice) || parseFloat(dishPrice) <= 0) {
                document.getElementById("dishPriceError").innerHTML = "Price must be a number greater than 0.";
                isValid = false;
            }

            var isChecked = false;
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    isChecked = true;
                    var itemId = checkboxes[i].value;
                    var quantityInput = document.getElementById("quantityUsed" + itemId);
                    if (!quantityInput.value.trim() || quantityInput.value <= 0) {
                        document.getElementById("ingredientsError").innerHTML = "Please enter a valid quantity for all selected ingredients.";
                        isValid = false;
                        break;
                    }
                }
            }
            if (!isChecked) {
                document.getElementById("ingredientsError").innerHTML = "Please select at least one ingredient.";
                isValid = false;
            }

            return isValid;
        }

        function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function() {
                var output = document.getElementById('imagePreview');
                output.src = reader.result;
                output.style.display = 'block';
            };
            reader.readAsDataURL(event.target.files[0]);
        }

        function showPopupAndRedirect(message) {
            var popup = document.getElementById("successPopup");
            popup.innerText = message;
            popup.style.display = "block";
            setTimeout(function() {
                popup.style.display = "none";
                window.location.href = "${pageContext.request.contextPath}/viewalldish";
            }, 3000);
        }

        function renderIngredients() {
            var searchValue = document.getElementById("ingredientSearch").value.toLowerCase();
            var filterValue = document.getElementById("ingredientFilter").value;

            var filteredItems = allIngredients.filter(item => {
                var matchesSearch = item.querySelector('label').textContent.toLowerCase().includes(searchValue);
                var matchesFilter = filterValue === "all" || 
                                   (filterValue === "available" && parseInt(item.dataset.quantity) > 0) ||
                                   (filterValue === "unavailable" && parseInt(item.dataset.quantity) <= 0);
                return matchesSearch && matchesFilter;
            });

            // Sắp xếp: Đưa các mục đã chọn lên đầu
            filteredItems.sort((a, b) => {
                const aChecked = ingredientStates[a.querySelector('input[type="checkbox"]').value]?.checked || false;
                const bChecked = ingredientStates[b.querySelector('input[type="checkbox"]').value]?.checked || false;
                return bChecked - aChecked; // true (1) lên đầu, false (0) xuống dưới
            });

            var container = document.getElementById("ingredientList");
            container.innerHTML = "";

            if (filteredItems.length === 0) {
                container.innerHTML = `
                    <p class="no-ingredient-message">No ingredients found. Do you want to go to the page to add ingredients to the system?</p>
                    <a href="${pageContext.request.contextPath}/ViewInventoryController" class="add-ingredient-btn">Add Ingredients</a>
                `;
            } else {
                filteredItems.forEach(item => {
                    const clonedItem = item.cloneNode(true);
                    const itemId = clonedItem.querySelector('input[type="checkbox"]').value;
                    const checkbox = clonedItem.querySelector('input[type="checkbox"]');
                    const quantityInput = clonedItem.querySelector('input[type="number"]');

                    // Áp dụng trạng thái đã lưu
                    if (ingredientStates[itemId]) {
                        checkbox.checked = ingredientStates[itemId].checked;
                        quantityInput.value = ingredientStates[itemId].quantity || "";
                        quantityInput.style.display = checkbox.checked ? "inline" : "none";
                    }

                    // Gắn lại sự kiện
                    checkbox.onclick = function() {
                        showQuantityInput(itemId);
                        updateIngredientState(itemId);
                    };
                    quantityInput.oninput = function() {
                        updateQuantityState(itemId);
                    };
                    quantityInput.onblur = function() {
                        renderIngredients(); // Sắp xếp lại khi click ra ngoài
                    };

                    container.appendChild(clonedItem);
                });
            }
        }

        window.onload = function() {
            allIngredients = Array.from(document.querySelectorAll(".ingredient-item"));
            allIngredients.forEach(item => {
                item.dataset.quantity = item.querySelector('label').textContent.match(/Quantity: (\d+)/)?.[1] || 0;
            });

            // Khởi tạo trạng thái ban đầu
            allIngredients.forEach(item => {
                const itemId = item.querySelector('input[type="checkbox"]').value;
                if (item.querySelector('input[type="checkbox"]').checked) {
                    ingredientStates[itemId] = {
                        checked: true,
                        quantity: document.getElementById("quantityUsed" + itemId).value
                    };
                    document.getElementById("quantityUsed" + itemId).style.display = "inline";
                }
            });

            renderIngredients();

            document.getElementById("ingredientSearch").addEventListener("input", renderIngredients);
            document.getElementById("ingredientFilter").addEventListener("change", renderIngredients);

            <% if (request.getAttribute("message") != null) { %>
                showPopupAndRedirect("<%= request.getAttribute("message") %>");
            <% } %>
        };
    </script>
</body>
</html>