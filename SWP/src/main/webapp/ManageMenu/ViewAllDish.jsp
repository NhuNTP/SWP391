<%@page import="Model.InventoryItem"%>
<%@page import="Model.Account"%>
<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.InventoryItem" %>
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
        <title>Menu Management</title>
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
            .dish-list {
                list-style: none;
                padding: 0;
            }
            .dish-list li {
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 10px;
                padding: 10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .dish-info {
                flex-grow: 1;
            }
            .dish-actions {
                flex-shrink: 0;
            }
            .tab-content {
                padding: 20px;
            }
            .error {
                color: red;
            }
            .success {
                color: green;
            }
            /* Modal styles */
            .modal-fullscreen {
                width: 100vw;
                height: 100vh;
                max-width: none;
                margin: 0;
            }
            .modal-content {
                height: 100%;
                border: none;
                border-radius: 0;
            }
            .modal-body {
                padding: 0;
                height: calc(100% - 112px); /* Trừ chiều cao header và footer */
                display: flex !important; /* Đảm bảo luôn áp dụng flex */
                flex-direction: row !important;
            }
            .update-container {
                width: 100%;
                height: 100%;
                display: flex !important; /* Đảm bảo luôn áp dụng flex */
                flex-direction: row !important;
                padding: 20px;
                box-sizing: border-box;
            }
            .left-section {
                flex: 1;
                display: flex;
                flex-direction: column;
                padding-right: 20px;
            }
            .right-section {
                flex: 1;
                display: flex;
                flex-direction: column;
                padding-left: 20px;
            }
            .form-group {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }
            label {
                width: 120px;
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
            input[type="number"].quantity-input {
                width: 80px;
                margin-left: 5px;
            }
            .ingredient-list {
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .ingredient-item {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            .ingredient-item label {
                width: 200px;
                font-size: 0.9em;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            img {
                max-width: 150px;
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <div class="d-flex">
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
            <div class="col-md-10 p-4">
                <h3>Menu Management</h3>
                <% if (request.getSession().getAttribute("message") != null) {%>
                <div class="alert alert-success">
                    <%= request.getSession().getAttribute("message")%>
                </div>
                <% request.getSession().removeAttribute("message"); %>
                <% } %>
                <% if (request.getSession().getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger">
                    <%= request.getSession().getAttribute("errorMessage")%>
                </div>
                <% request.getSession().removeAttribute("errorMessage"); %>
                <% } %>
                <ul class="nav nav-tabs" id="menuTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="list-tab" data-bs-toggle="tab" href="#list" role="tab">Dish List</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="add-tab" data-bs-toggle="tab" href="#add" role="tab">Add New Dish</a>
                    </li>
                </ul>
                <div class="tab-content" id="menuTabContent">
                    <div class="tab-pane fade show active" id="list" role="tabpanel">
                        <div class="mb-3 mt-3">
                            <form id="searchForm" class="row g-3">
                                <div class="col-auto">
                                    <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="Enter dish name">
                                </div>
                                <div class="col-auto">
                                    <select class="form-select" id="filterStatus" name="filterStatus">
                                        <option value="">All Status</option>
                                        <option value="Available">Available</option>
                                        <option value="Unavailable">Unavailable</option>
                                    </select>
                                </div>
                                <div class="col-auto">
                                    <select class="form-select" id="filterIngredientStatus" name="filterIngredientStatus">
                                        <option value="">All Ingredients</option>
                                        <option value="Sufficient">Sufficient</option>
                                        <option value="Insufficient">Insufficient</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <div id="dishListContainer">
                            <%
                                List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
                                if (dishList != null && !dishList.isEmpty()) {
                            %>
                            <ul class="dish-list">
                                <% for (Dish dish : dishList) {%>
                                <li>
                                    <div class="dish-info">
                                        <h5><%= dish.getDishName()%></h5>
                                        <p class="price"><%= dish.getDishPrice()%> VNĐ</p>
                                        <p>Status: <%= dish.getDishStatus()%></p>
                                        <p>Ingredients: <%= dish.getIngredientStatus()%></p>
                                    </div>
                                    <div class="dish-actions">
                                        <a href="#" class="btn btn-warning btn-sm edit-dish-btn" data-bs-toggle="modal" data-bs-target="#editDishModal" data-dish-id="<%= dish.getDishId()%>">Modify</a>
                                        <form action="deletedish" method="post" style="display:inline;">
                                            <input type="hidden" name="dishId" value="<%= dish.getDishId()%>">
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
                                        <a href="#" class="btn btn-info btn-sm view-dish-btn" data-bs-toggle="modal" data-bs-target="#dishDetailModal" data-dish-id="<%= dish.getDishId()%>">Detail</a>
                                    </div>
                                </li>
                                <% } %>
                            </ul>
                            <% } else { %>
                            <p class="text-muted">No food available.</p>
                            <% }%>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="add" role="tabpanel">
                        <h2>Add New Dish</h2>
                        <form action="${pageContext.request.contextPath}/addnewdish" method="post" enctype="multipart/form-data" onsubmit="return validateAddForm()">
                            <label for="addDishName">Dish Name:</label>
                            <input type="text" id="addDishName" name="dishName" required><br><br>
                            <label for="addDishType">Dish Type:</label>
                            <select id="addDishType" name="dishType">
                                <option value="Food">Food</option>
                                <option value="Drink">Drink</option>
                            </select><br><br>
                            <label for="addDishPrice">Price:</label>
                            <input type="number" id="addDishPrice" name="dishPrice" step="0.01" required><br><br>
                            <label for="addDishDescription">Description:</label>
                            <textarea id="addDishDescription" name="dishDescription"></textarea><br><br>
                            <label for="addDishImage">Image:</label>
                            <input type="file" id="addDishImage" name="dishImage"><br><br>
                            <h3>Ingredients</h3>
                            <%
                                List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");
                                if (inventoryList != null && !inventoryList.isEmpty()) {
                                    for (InventoryItem inventory : inventoryList) {
                                        String itemId = inventory.getItemId();
                            %>
                            <div>
                                <label for="addItemId<%= itemId%>"><%= inventory.getItemName()%> (<%= inventory.getItemUnit()%>) - Quantity: <%= inventory.getItemQuantity()%></label>
                                <input type="checkbox" id="addItemId<%= itemId%>" name="itemId" value="<%= itemId%>" onclick="showAddQuantityInput('<%= itemId%>')">
                                <input type="number" id="addQuantityUsed<%= itemId%>" name="quantityUsed<%= itemId%>" placeholder="Quantity Used" step="0.01" style="display:none;">
                            </div>
                            <%      }
                            } else {
                            %>
                            <p class="error">No ingredients available. Please add some ingredients in Inventory Management.</p>
                            <% }%>
                            <br>
                            <input type="submit" class="btn btn-primary" value="Add Dish">
                        </form>
                    </div>
                </div>
                <div class="modal fade" id="editDishModal" tabindex="-1" aria-labelledby="editDishModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editDishModalLabel">Modify Dish</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Content will be loaded here via AJAX -->
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" id="saveChangesBtn">Save Change</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="dishDetailModal" tabindex="-1" aria-labelledby="dishDetailModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-fullscreen">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="dishDetailModalLabel">Dish Detail</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Content will be loaded here via AJAX -->
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function showAddQuantityInput(itemId) {
                var quantityInput = document.getElementById("addQuantityUsed" + itemId);
                var checkbox = document.getElementById("addItemId" + itemId);
                if (checkbox && quantityInput) {
                    if (checkbox.checked) {
                        quantityInput.style.display = "inline-block";
                    } else {
                        quantityInput.style.display = "none";
                        quantityInput.value = "";
                    }
                } else {
                    console.error("Element not found for itemId:", itemId);
                }
            }

            function validateAddForm() {
                var checkboxes = document.getElementsByName("itemId");
                var isChecked = false;
                var errorMessage = "";
                for (var i = 0; i < checkboxes.length; i++) {
                    var checkbox = checkboxes[i];
                    if (checkbox.checked) {
                        isChecked = true;
                        var itemId = checkbox.value;
                        var quantityInput = document.getElementById("addQuantityUsed" + itemId);
                        var quantityValue = quantityInput.value.trim();
                        if (!quantityValue) {
                            errorMessage = "Please enter a quantity for " + document.querySelector('label[for="addItemId' + itemId + '"]').textContent;
                            quantityInput.focus();
                            break;
                        } else if (isNaN(quantityValue) || Number(quantityValue) <= 0) {
                            errorMessage = "Quantity for " + document.querySelector('label[for="addItemId' + itemId + '"]').textContent + " must be greater than 0.";
                            quantityInput.focus();
                            break;
                        }
                    }
                }
                if (!isChecked) {
                    errorMessage = "Please select at least one ingredient.";
                }
                if (errorMessage) {
                    alert(errorMessage);
                    return false;
                }
                return true;
            }

            $(document).ready(function () {
                $('.edit-dish-btn').click(function () {
                    var dishId = $(this).data('dish-id');
                    var modalBody = $('#editDishModal .modal-body');
                    $.ajax({
                        url: 'updatedish',
                        type: 'GET',
                        data: {dishId: dishId},
                        success: function (data) {
                            modalBody.html(data);
                            $('#editDishModal').modal('show');
                        },
                        error: function (xhr, status, error) {
                            modalBody.html('<p class="text-danger">Error loading content.</p>');
                            console.error(error);
                        }
                    });
                });

                $('#editDishModal').on('click', '#saveChangesBtn', function (event) {
                    event.preventDefault();
                    var form = $('#editDishModal form');
                    $.ajax({
                        url: form.attr('action'),
                        type: 'POST',
                        data: new FormData(form[0]),
                        processData: false,
                        contentType: false,
                        success: function (response) {
                            $('#editDishModal .modal-body').html(response);
                            setTimeout(function () {
                                $('#editDishModal').modal('hide');
                                window.location.reload();
                            }, 1000);
                        },
                        error: function (xhr, status, error) {
                            console.error(error);
                            alert('Error updating dish.');
                        }
                    });
                });

                $('.view-dish-btn').click(function () {
                    var dishId = $(this).data('dish-id');
                    var modalBody = $('#dishDetailModal .modal-body');
                    $.ajax({
                        url: 'dishdetail',
                        type: 'GET',
                        data: {dishId: dishId},
                        success: function (data) {
                            modalBody.html(data);
                            $('#dishDetailModal').modal('show');
                        },
                        error: function (xhr, status, error) {
                            modalBody.html('<p class="text-danger">Error loading content.</p>');
                            console.error(error);
                        }
                    });
                });

                const searchKeyword = document.getElementById('searchKeyword');
                const filterStatus = document.getElementById('filterStatus');
                const filterIngredientStatus = document.getElementById('filterIngredientStatus');
                const dishListContainer = document.getElementById('dishListContainer');
                const rows = dishListContainer.querySelectorAll('.dish-list li');
                function filterTable() {
                    const searchText = searchKeyword.value.toLowerCase();
                    const selectedStatus = filterStatus.value;
                    const selectedIngredientStatus = filterIngredientStatus.value;
                    rows.forEach(row => {
                        const dishName = row.querySelector('.dish-info h5').textContent.toLowerCase();
                        const status = row.querySelector('.dish-info p:nth-child(3)').textContent;
                        const ingredientStatus = row.querySelector('.dish-info p:nth-child(4)').textContent;
                        let matchesSearch = dishName.includes(searchText);
                        let matchesStatus = selectedStatus === '' || status.includes(selectedStatus);
                        let matchesIngredientStatus = selectedIngredientStatus === '' || ingredientStatus.includes(selectedIngredientStatus);
                        if (matchesSearch && matchesStatus && matchesIngredientStatus) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                }
                searchKeyword.addEventListener('keyup', filterTable);
                filterStatus.addEventListener('change', filterTable);
                filterIngredientStatus.addEventListener('change', filterTable);
            });
        </script>
    </body>
</html>