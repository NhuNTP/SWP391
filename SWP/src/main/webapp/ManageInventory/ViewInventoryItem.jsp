<%--
    Document   : ViewIntentoryItem
    Created on : Feb 23, 2025, 9:43:14 PM
    Author     : DELL-Laptop
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Inventory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inventory Management - Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- SweetAlert2 for enhanced alerts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <style>
            /* CSS Reset and Font */
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #fcfcf7
            }

            /* Sidebar Styles */
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

            /* Card Stats Styles */
            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }

            .card-stats i {
                font-size: 2rem;
            }

            /* Chart Container Styles */
            .chart-container {
                position: relative;
                height: 300px;
            }

            /* Main Content */
            .main-content-area {
                padding: 20px;
            }

            .content-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .content-header h2 {
                margin-top: 0;
                font-size: 24px;
            }

            .header-buttons .btn-info {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
            }

            .header-buttons .btn-info:hover {
                background-color: #0056b3;
            }

            /* Search Bar (THÊM MỚI) - Added Search Bar Styles from ViewCoupon */
            .search-bar {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .search-bar input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: 250px; /* Điều chỉnh độ rộng nếu cần */
            }
            .search-bar select {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: auto; /* Điều chỉnh độ rộng nếu cần */
            }


            /* Inventory Table */
            .employee-grid .table { /* Reusing employee-grid class for table container */
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            .employee-grid .table th, .employee-grid .table td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            .employee-grid .table th {
                background-color: #f4f4f4;
                font-weight: bold;
            }

            .employee-grid .table tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .employee-grid .table tbody tr:hover {
                background-color: #f0f0f0;
            }

            /* Table Buttons */
            .employee-grid .btn-warning, .employee-grid .btn-danger {
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
                text-decoration: none;
                cursor: pointer;
                margin: 2px;
            }
            .btn-edit, .btn-delete {
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-edit {
                background-color: #007bff;
                border: none;
            }

            .btn-edit:hover {
                background-color: #0056b3;
            }

            .btn-delete {
                background-color: #dc3545;
                border: none;
                margin-left: 5px;
            }

            .btn-delete:hover {
                background-color: #c82333;
            }

            /* No Data Message */
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
            }

            /* Image Style in Table */
            .employee-grid .table img {
                max-width: 100px;
                max-height: 100px;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }

            /* Highlight CSS - Added Highlight CSS from ViewCoupon */
            .highlight {
                background-color: yellow;
            }
            .sidebar .nav-link {
                font-size: 0.9rem; /* Hoặc 16px, tùy vào AdminDashboard.jsp */
            }

            .sidebar h4{
                font-size: 1.5rem;
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>  <!-- Hoặc fas fa-utensils -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li> <!-- Hoặc fas fa-users -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li> <!-- Hoặc fas fa-ticket-alt -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                </ul>
            </div>
            <!-- Main Content -->
            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="container-fluid">
                        <div class="text-left mb-4">
                            <h3>Inventory Management</h3>
                        </div>
                        <main class="content-area">
                            <div class="content-header">
                                <div class="search-bar"> <%-- Search bar and filter added here --%>
                                    <input type="text" id="searchInput" placeholder="Search Inventory Item"> <%-- Updated placeholder --%>
                                    <select id="columnFilter" class="form-control">
                                        <option value="">All Columns</option>
                                        <option value="itemId">ID</option>
                                        <option value="itemName">Name</option>
                                        <option value="itemType">Type</option>
                                        <option value="itemPrice">Price</option>
                                        <option value="itemQuantity">Quantity</option>
                                        <option value="itemUnit">Unit</option>
                                        <option value="itemDescription">Description</option>
                                    </select>
                                </div>

                                <div class="header-buttons">
                                    <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addInventoryModal">Add New</button>
                                </div>
                            </div>
                            <div class="employee-grid"> <%-- Reusing employee-grid class for layout consistency --%>
                                <table class="table table-bordered"  method="post">
                                    <thead>
                                        <tr>
                                            <th>No.</th>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Type</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Unit</th>
                                            <th>Description</th>
                                            <th>Actions</th> <%-- Action column title --%>
                                        </tr>
                                    </thead>
                                    <tbody id="inventoryTableBody"> <%-- Added ID for table body --%>
                                        <%
                                            List<Inventory> inventoryItemList = (List<Inventory>) request.getAttribute("InventoryItemList");
                                            if (inventoryItemList != null && !inventoryItemList.isEmpty()) {
                                                int displayIndex = 1;
                                                for (Inventory listItem : inventoryItemList) {
                                        %>
                                        <tr id="inventoryRow<%=listItem.getItemId()%>">
                                            <Td valign="middle"><% out.print(displayIndex++); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemId()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemName()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemType()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemPrice()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemQuantity()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemUnit()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemDescription());%></td>
                                            <Td valign="middle">
                                                <button type="button" class="btn btn-edit btn-update-inventory"
                                                        data-bs-toggle="modal" data-bs-target="#updateInventoryModal"
                                                        data-item-id="<%= listItem.getItemId()%>"
                                                        data-item-name="<%= listItem.getItemName()%>"
                                                        data-item-type="<%= listItem.getItemType()%>"
                                                        data-item-price="<%= listItem.getItemPrice()%>"
                                                        data-item-quantity="<%= listItem.getItemQuantity()%>"
                                                        data-item-unit="<%= listItem.getItemUnit()%>"
                                                        data-item-description="<%= listItem.getItemDescription()%>">
                                                    <i class="fas fa-edit"></i> Update
                                                </button>
                                                <button type="button" class="btn btn-delete btn-delete-inventory"
                                                        data-bs-toggle="modal" data-bs-target="#deleteInventoryModal"
                                                        data-item-id="<%= listItem.getItemId()%>">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr id="noDataRow" > <%-- Added ID and style for no data row --%>
                                            <td colspan="9">
                                                <div class="no-data">
                                                    No inventory items found.
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </main>
                    </div>
                </section>
            </div>
        </div>

        <!-- Add Inventory Modal -->
        <div class="modal fade" id="addInventoryModal" tabindex="-1" aria-labelledby="addInventoryModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addInventoryModalLabel">Add New Inventory Item</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addInventoryForm">
                            <div class="mb-3">
                                <label for="itemName" class="form-label">Name:</label>
                                <input type="text" class="form-control" id="itemName" name="itemName" required>
                            </div>
                            <div class="mb-3">
                                <label for="itemType" class="form-label">Type:</label>
                                <input type="text" class="form-control" id="itemType" name="itemType" required>
                            </div>
                            <div class="mb-3">
                                <label for="itemPrice" class="form-label">Price:</label>
                                <input type="number" class="form-control" id="itemPrice" name="itemPrice" required min="0" step="0.01">
                            </div>
                            <div class="mb-3">
                                <label for="itemQuantity" class="form-label">Quantity:</label>
                                <input type="number" class="form-control" id="itemQuantity" name="itemQuantity" required min="0">
                            </div>
                            <div class="mb-3">
                                <label for="itemUnit" class="form-label">Unit:</label>
                                <input type="text" class="form-control" id="itemUnit" name="itemUnit" required>
                            </div>
                            <div class="mb-3">
                                <label for="itemDescription" class="form-label">Description:</label>
                                <textarea class="form-control" id="itemDescription" name="itemDescription" rows="2"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnAddInventory">Add Item</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Inventory Modal -->
        <div class="modal fade" id="updateInventoryModal" tabindex="-1" aria-labelledby="updateInventoryModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateInventoryModalLabel">Update Inventory Item</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateInventoryForm">
                            <div class="mb-3">
                                <label for="itemIdUpdate" class="form-label">Item ID (View Only):</label>
                                <input type="text" class="form-control" id="itemIdUpdateDisplay" readonly>
                                <input type="hidden" class="form-control" id="itemIdUpdate" name="itemId">
                            </div>
                            <div class="mb-3">
                                <label for="itemNameUpdate" class="form-label">Name:</label>
                                <input type="text" class="form-control" id="itemNameUpdate" name="itemName">
                            </div>
                            <div class="mb-3">
                                <label for="itemTypeUpdate" class="form-label">Type:</label>
                                <input type="text" class="form-control" id="itemTypeUpdate" name="itemType">
                            </div>
                            <div class="mb-3">
                                <label for="itemPriceUpdate" class="form-label">Price:</label>
                                <input type="number" class="form-control" id="itemPriceUpdate" name="itemPrice" min="0" step="0.01">
                            </div>
                            <div class="mb-3">
                                <label for="itemQuantityUpdate" class="form-label">Quantity:</label>
                                <input type="number" class="form-control" id="itemQuantityUpdate" name="itemQuantity" min="0">
                            </div>
                            <div class="mb-3">
                                <label for="itemUnitUpdate" class="form-label">Unit:</label>
                                <input type="text" class="form-control" id="itemUnitUpdate" name="itemUnit">
                            </div>
                            <div class="mb-3">
                                <label for="itemDescriptionUpdate" class="form-label">Description:</label>
                                <textarea class="form-control" id="itemDescriptionUpdate" name="itemDescription" rows="2"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnUpdateInventory">Save Changes</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Inventory Modal -->
        <div class="modal fade" id="deleteInventoryModal" tabindex="-1" aria-labelledby="deleteInventoryModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteInventoryModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to DELETE this inventory item?</p>
                        <input type="hidden" id="inventoryItemIdDelete">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteInventoryConfirm">Delete Item</button>
                    </div>
                </div>
            </div>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                bindEventHandlers();
                setupSearchFilter();

                // **Xử lý Thêm Inventory Item**
                $('#btnAddInventory').click(function () {
                    var itemName = $('#itemName').val();
                    var itemType = $('#itemType').val();
                    var itemPrice = $('#itemPrice').val();
                    var itemQuantity = $('#itemQuantity').val();
                    var itemUnit = $('#itemUnit').val();
                    var itemDescription = $('#itemDescription').val();


                    $.ajax({
                        url: 'AddInventoryItemController',
                        type: 'POST',
                        data: {
                            itemName: itemName,
                            itemType: itemType,
                            itemPrice: itemPrice,
                            itemQuantity: itemQuantity,
                            itemUnit: itemUnit,
                            itemDescription: itemDescription
                        },
                        success: function () {
                            var addInventoryModal = bootstrap.Modal.getInstance(document.getElementById('addInventoryModal'));
                            addInventoryModal.hide();
                            reloadViewInventory();
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Inventory item added successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                            $('#addInventoryForm')[0].reset();
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error adding inventory item: ' + error
                            });
                        }
                    });
                });

                // **Xử lý Cập nhật Inventory Item**
                $('#btnUpdateInventory').click(function () {
                    var itemId = $('#itemIdUpdate').val();
                    var itemName = $('#itemNameUpdate').val();
                    var itemType = $('#itemTypeUpdate').val();
                    var itemPrice = $('#itemPriceUpdate').val();
                    var itemQuantity = $('#itemQuantityUpdate').val();
                    var itemUnit = $('#itemUnitUpdate').val();
                    var itemDescription = $('#itemDescriptionUpdate').val();


                    $.ajax({
                        url: 'UpdateInventoryItemController',
                        type: 'POST',
                        data: {
                            itemId: itemId,
                            itemName: itemName,
                            itemType: itemType,
                            itemPrice: itemPrice,
                            itemQuantity: itemQuantity,
                            itemUnit: itemUnit,
                            itemDescription: itemDescription
                        },
                        success: function () {
                            var updateInventoryModal = bootstrap.Modal.getInstance(document.getElementById('updateInventoryModal'));
                            updateInventoryModal.hide();
                            reloadViewInventory();
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Inventory item updated successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        },
                        error: function (error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error updating inventory item: ' + error
                            });
                        }
                    });
                });

                // **Xử lý Xóa Inventory Item**
                $('#btnDeleteInventoryConfirm').click(function () {
                    var itemId = $('#inventoryItemIdDelete').val();
                    $.ajax({
                        url: 'DeleteInventoryItemController',
                        type: 'POST',
                        data: {
                            itemID: itemId
                        },
                        success: function (response) {
                            var deleteInventoryModal = bootstrap.Modal.getInstance(document.getElementById('deleteInventoryModal'));
                            deleteInventoryModal.hide();
                            $('#inventoryRow' + itemId).remove();
                            if ($('#inventoryTableBody tr').length === 0) {
                                $('#inventoryTableBody').html('<tr><td colspan="9"><div class="no-data">No inventory items found.</div></td></tr>');
                            }
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Inventory item deleted successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error deleting inventory item: ' + error
                            });
                        }
                    });
                });
            });

            function bindEventHandlers() {
                $(document).on('click', '.btn-update-inventory', function () {
                    var itemId = $(this).data('item-id');
                    var itemName = $(this).data('item-name');
                    var itemType = $(this).data('item-type');
                    var itemPrice = $(this).data('item-price');
                    var itemQuantity = $(this).data('item-quantity');
                    var itemUnit = $(this).data('item-unit');
                    var itemDescription = $(this).data('item-description');


                    $('#itemIdUpdate').val(itemId);
                    $('#itemIdUpdateDisplay').val(itemId);
                    $('#itemNameUpdate').val(itemName);
                    $('#itemTypeUpdate').val(itemType);
                    $('#itemPriceUpdate').val(itemPrice);
                    $('#itemQuantityUpdate').val(itemQuantity);
                    $('#itemUnitUpdate').val(itemUnit);
                    $('#itemDescriptionUpdate').val(itemDescription);

                });

                $(document).on('click', '.btn-delete-inventory', function () {
                    var itemId = $(this).data('item-id');
                    $('#inventoryItemIdDelete').val(itemId);
                });
            }

            function reloadViewInventory() {
                $.get('ViewInventoryController', function (data) {
                    var newBody = $(data).find('tbody').html();
                    $('tbody').html(newBody);
                    bindEventHandlers();
                });
            }

            function setupSearchFilter() {
                const searchInput = $("#searchInput");
                const columnFilter = $("#columnFilter");
                const inventoryTableBody = $("#inventoryTableBody");
                const noDataRow = $("#noDataRow");
                const rows = inventoryTableBody.find("tr"); // Select all rows initially

                function filterTable() {
                    const searchText = searchInput.val().toLowerCase();
                    const selectedColumn = columnFilter.val();
                    let rowVisible = false;

                    rows.each(function () { // Use the initially selected rows
                        const row = $(this);
                        if (row.attr('id') && row.attr('id') === 'noDataRow')
                            return true; // Skip noDataRow

                        let shouldShowRow = false;

                        row.find("td").each(function (index) {
                            if (index > 0) { // Skip the first column (No.)
                                const cell = $(this);
                                const cellText = cell.text().toLowerCase();
                                cell.html(cell.text()); // Reset highlight

                                let columnMatch = true;

                                if (selectedColumn && selectedColumn !== "") {
                                    let columnIndex;
                                    switch (selectedColumn) {
                                        case 'itemId':
                                            columnIndex = 1;
                                            break;
                                        case 'itemName':
                                            columnIndex = 2;
                                            break;
                                        case 'itemType':
                                            columnIndex = 3;
                                            break;
                                        case 'itemPrice':
                                            columnIndex = 4;
                                            break;
                                        case 'itemQuantity':
                                            columnIndex = 5;
                                            break;
                                        case 'itemUnit':
                                            columnIndex = 6;
                                            break;
                                        case 'itemDescription':
                                            columnIndex = 7;
                                            break;
                                        default:
                                            columnIndex = -1; // Should not happen, but for safety
                                    }
                                    if (index !== columnIndex) {
                                        columnMatch = false;
                                    }
                                }

                                if (columnMatch) {
                                    if (searchText && cellText.includes(searchText)) {
                                        const highlightedText = cell.text().replace(new RegExp(searchText, 'gi'), '<span class="highlight">$&</span>');
                                        cell.html(highlightedText);
                                        shouldShowRow = true;
                                    }
                                }
                            }
                        });

                        if (searchText === "" || shouldShowRow) {
                            row.show();
                            rowVisible = true;
                        } else {
                            row.hide();
                        }
                    });

                    if (rowVisible) {
                        noDataRow.hide();
                    } else {
                        noDataRow.show();
                    }
                }

                searchInput.on("keyup", filterTable);
                columnFilter.on("change", filterTable);
            }

        </script>
    </body>
</html>