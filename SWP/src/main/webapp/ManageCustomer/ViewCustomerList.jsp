<%@page import="Model.Account"%>
<%@page import="java.util.List"%>
<%@page import="Model.Customer"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
%>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Admin Dashboard</title>
    <!-- Bootstrap 5.3.0 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
        crossorigin="anonymous">
    <!-- Font Awesome Icons (nếu bạn muốn dùng icon) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- jQuery (nếu bạn dùng AJAX) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

        .card-stats {
            background: linear-gradient(to right, #4CAF50, #81C784);
            color: white;
        }

        .card-stats i {
            font-size: 2rem;
        }

        .chart-container {
            position: relative;
            height: 300px;
        }

        /* Main Content Area */
        .main-content-area {
            padding: 20px;
        }

        /* Content Header */
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

        /* Search Bar */
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 250px;
        }

        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
        }

        /* Nút trong bảng */
        .btn-edit,
        .btn-delete {
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
        }

        .btn-edit:hover {
            background-color: #0056b3;
        }

        .btn-delete {
            background-color: #dc3545;
            margin-left: 5px;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .btn-edit i,
        .btn-delete i {
            margin-right: 5px;
        }

        .header-buttons .btn-info {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }

        .header-buttons .btn-info:hover {
            background-color: #0056b3;
        }

        /* No Data Message */
        .no-data {
            padding: 20px;
            text-align: center;
            color: #777;
        }

        .sidebar .nav-link {
            font-size: 0.9rem;
            /* Hoặc 16px, tùy vào AdminDashboard.jsp */
        }

        .sidebar h4 {
            font-size: 1.5rem;
        }

        /* The Modal (background) */
        .modal {
            display: none;
            /* Hidden by default */
            position: fixed;
            /* Stay in place */
            z-index: 1;
            /* Sit on top */
            left: 0;
            top: 0;
            width: 100%;
            /* Full width */
            height: 100%;
            /* Full height */
            overflow: auto;
            /* Enable scroll if needed */
            background-color: rgba(0, 0, 0, 0.4);
            /* Black w/ opacity */
        }

        /* Modal Content/Box */
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            /* Could be more or less, depending on screen size */
        }
    </style>
    <script>
        function confirmDelete(customerId) {
            if (confirm('Are you sure you want to delete customer ID: ' + customerId + '?')) {
                window.location.href = 'DeleteCustomer?customerId=' + customerId;
            }
        }

        function openModal(modalId) {
            document.getElementById(modalId).style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        function openEditModal(button) {
            document.getElementById("customerIdUpdate").value = button.dataset.customerId;
            document.getElementById("customerNameUpdate").value = button.dataset.customerName;
            document.getElementById("customerPhoneUpdate").value = button.dataset.customerPhone;
            document.getElementById("numberOfPaymentUpdate").value = button.dataset.numberOfPayment;

            openModal("updateCustomerModal");
        }

        function filterTable() {
            const searchText = searchInput.value.toLowerCase();
            const table = document.querySelector('.table-responsive table tbody');
            const rows = table.querySelectorAll('tr');
            let hasResults = false; // Flag to check if there are any matching rows

            rows.forEach(row => {
                const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const customerName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                const customerPhone = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const numberOfPayment = row.querySelector('td:nth-child(5)').textContent.toLowerCase();

                // Nếu ô tìm kiếm trống, hiển thị tất cả các hàng
                if (searchText === "") {
                    row.style.display = '';
                    hasResults = true;
                } else {
                    let matchesSearch = (id.includes(searchText)) || (customerName.includes(searchText)) || (customerPhone.includes(searchText)) || (numberOfPayment.includes(searchText));

                    if (matchesSearch) {
                        row.style.display = ''; // Show the row
                        hasResults = true;
                    } else {
                        row.style.display = 'none'; // Hide the row
                    }
                }
            });

            const noDataRow = document.querySelector('.table-responsive table tbody .no-data-row');
            if (noDataRow) {
                noDataRow.remove();
            }

            if (!hasResults && searchText !== "") { // Chỉ hiển thị "No matching..." khi có text search
                const newRow = document.createElement('tr');
                newRow.classList.add('no-data-row');
                newRow.innerHTML = '<td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i>  No matching customers found.</td>';
                table.appendChild(newRow);
            }
        }

        function validateNumberInput(inputElement) {
            const errorSpanId = inputElement.id + 'Error';
            const errorSpan = document.getElementById(errorSpanId);

            if (inputElement.value < 0) {
                errorSpan.textContent = "Please enter a non-negative number.";
                inputElement.value = ''; // Xóa giá trị trong ô input
            } else {
                errorSpan.textContent = ''; // Xóa thông báo lỗi nếu hợp lệ
            }
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
        <div class="col-md-10 p-4 main-content-area">
            <section class="main-content">
                <div class="text-left mb-4">
                    <h4>Customer Management</h4>
                </div>
                <div class="container-fluid">
                    <main>
                        <div class="content-header">
                            <div class="search-bar">
                                <input type="text" class="form-control" placeholder="Search" id="searchInput"
                                    onkeyup="filterTable()">
                            </div>
                            <div class="header-buttons">
                                <button type="button" class="btn btn-info" onclick="openModal('addCustomerModal')">
                                    <i class="fas fa-plus"></i> Add New
                                </button>
                            </div>

                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>Customer ID</th>
                                        <th>Customer Name</th>
                                        <th>Customer Phone</th>
                                        <th>Number of Payments</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="customerTableBody">
                                    <%
                                    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
                                    if (customerList != null && !customerList.isEmpty()) {
                                        int displayIndex = 1;
                                        for (Customer customer : customerList) {
                                    %>
                                    <tr id="customerRow<%=customer.getCustomerId()%>">
                                        <td>
                                            <%= displayIndex++%>
                                        </td>
                                        <td>
                                            <%= customer.getCustomerId()%>
                                        </td>
                                        <td>
                                            <%= customer.getCustomerName()%>
                                        </td>
                                        <td>
                                            <%= customer.getCustomerPhone()%>
                                        </td>
                                        <td>
                                            <%= customer.getNumberOfPayment()%>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-edit"
                                                data-customer-id="<%= customer.getCustomerId()%>"
                                                data-customer-name="<%= customer.getCustomerName()%>"
                                                data-customer-phone="<%= customer.getCustomerPhone()%>"
                                                data-number-of-payment="<%= customer.getNumberOfPayment()%>"
                                                onclick="openEditModal(this)">
                                                <i class="fas fa-edit"></i> Update
                                            </button>
                                            <button type="button" class="btn btn-delete"
                                                onclick="confirmDelete('<%= customer.getCustomerId()%>')">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6">
                                            <div class="no-data">
                                                Customer Not Found.
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

    <!-- Add Customer Modal -->
    <div id="addCustomerModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Customer</h5>
                    <button type="button" class="btn-close" onclick="closeModal('addCustomerModal')"
                        aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addCustomerForm" action="AddCustomer" method="POST">
                        <div class="mb-3">
                            <label for="customerName" class="form-label">Customer Name:</label>
                            <input type="text" class="form-control" id="customerName" name="CustomerName" required >
                        </div>
                        <div class="mb-3">
                            <label for="customerPhone" class="form-label">Customer Phone:</label>
                            <input type="number" class="form-control" id="customerPhone" name="CustomerPhone"
                                    required min="0">
                            <span id="customerPhoneError" class="text-danger"></span>
                        </div>
                        <div class="mb-3">
                            <label for="numberOfPayment" class="form-label">Number of Payments:</label>
                            <input type="number" class="form-control" id="numberOfPayment" name="NumberOfPayment"
                                    required min="0">
                            <span id="numberOfPaymentError" class="text-danger"></span>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addCustomerModal')">Cancel</button>
                            <button type="submit" class="btn btn-primary" id="btnAddCustomer">Add Customer</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Update Customer Modal -->
    <div id="updateCustomerModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Customer</h5>
                    <button type="button" class="btn-close" onclick="closeModal('updateCustomerModal')"
                        aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="updateCustomerForm" action="UpdateCustomer" method="POST">
                        <input type="hidden" id="customerIdUpdate" name="customerId">
                        <div class="mb-3">
                            <label for="customerNameUpdate" class="form-label">Customer Name:</label>
                            <input type="text" class="form-control" id="customerNameUpdate" name="CustomerName"
                                   required min="0">
                        </div>
                        <div class="mb-3">
                            <label for="customerPhoneUpdate" class="form-label">Customer Phone:</label>
                            <input type="number" class="form-control" id="customerPhoneUpdate" name="CustomerPhone"
                                    required min="0">
                            <span id="customerPhoneUpdateError" class="text-danger"></span>
                        </div>
                        <div class="mb-3">
                            <label for="numberOfPaymentUpdate" class="form-label">Number of Payments:</label>
                            <input type="number" class="form-control" id="numberOfPaymentUpdate"
                                name="NumberOfPayment"  required min="0">
                            <span id="numberOfPaymentUpdateError" class="text-danger"></span>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                onclick="closeModal('updateCustomerModal')">Cancel</button>
                            <button type="submit" class="btn btn-primary" id="btnUpdateCustomer">Save changes</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
    <script>
        function confirmDelete(customerId) {
            if (confirm('Are you sure you want to delete customer ID: ' + customerId + '?')) {
                window.location.href = 'DeleteCustomer?customerId=' + customerId;
            }
        }

        function openModal(modalId) {
            document.getElementById(modalId).style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        function openEditModal(button) {
            document.getElementById("customerIdUpdate").value = button.dataset.customerId;
            document.getElementById("customerNameUpdate").value = button.dataset.customerName;
            document.getElementById("customerPhoneUpdate").value = button.dataset.customerPhone;
            document.getElementById("numberOfPaymentUpdate").value = button.dataset.numberOfPayment;

            openModal("updateCustomerModal");
        }

        function filterTable() {
            const searchText = searchInput.value.toLowerCase();
            const table = document.querySelector('.table-responsive table tbody');
            const rows = table.querySelectorAll('tr');
            let hasResults = false; // Flag to check if there are any matching rows

            rows.forEach(row => {
                const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const customerName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                const customerPhone = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const numberOfPayment = row.querySelector('td:nth-child(5)').textContent.toLowerCase();

                // Nếu ô tìm kiếm trống, hiển thị tất cả các hàng
                if (searchText === "") {
                    row.style.display = '';
                    hasResults = true;
                } else {
                    let matchesSearch = (id.includes(searchText)) || (customerName.includes(searchText)) || (customerPhone.includes(searchText)) || (numberOfPayment.includes(searchText));

                    if (matchesSearch) {
                        row.style.display = ''; // Show the row
                        hasResults = true;
                    } else {
                        row.style.display = 'none'; // Hide the row
                    }
                }
            });

            const noDataRow = document.querySelector('.table-responsive table tbody .no-data-row');
            if (noDataRow) {
                noDataRow.remove();
            }

            if (!hasResults && searchText !== "") { // Chỉ hiển thị "No matching..." khi có text search
                const newRow = document.createElement('tr');
                newRow.classList.add('no-data-row');
                newRow.innerHTML = '<td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i>  No matching customers found.</td>';
                table.appendChild(newRow);
            }
        }

        function validateNumberInput(inputElement) {
            const errorSpanId = inputElement.id + 'Error';
            const errorSpan = document.getElementById(errorSpanId);

            if (inputElement.value < 0) {
                errorSpan.textContent = "Please enter a non-negative number.";
                inputElement.value = ''; // Xóa giá trị trong ô input
            } else {
                errorSpan.textContent = ''; // Xóa thông báo lỗi nếu hợp lệ
            }
        }
         const searchInput = document.getElementById('searchInput');
            searchInput.addEventListener('keyup', filterTable);
    </script>
</body>

</html>