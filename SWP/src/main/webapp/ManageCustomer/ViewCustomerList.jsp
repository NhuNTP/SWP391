<%--
    Document   : ViewCustomerList
    Created on : Mar 1, 2025, 12:00:00 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Admin Dashboard</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function confirmDelete(customerId, customerName) {
            if (confirm('Are you sure you want to delete customer ID: ' + customerId + ' - ' + customerName + '?')) {
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
            document.getElementById("editCustomerIdHidden").value = button.dataset.customerid;
            document.getElementById("editCustomerName").value = button.dataset.customername;
            document.getElementById("editCustomerPhone").value = button.dataset.customerphone;

            // Check if dataset.numberofpayment is null/empty, and default to 0
            let numberOfPayments = button.dataset.numberofpayment;
            if (!numberOfPayments) { // Covers both null and empty string
                numberOfPayments = "0";  // Or some other appropriate default
            }
            document.getElementById("editNumberOfPayment").value = numberOfPayments;
            openModal("editCustomerModal");
        }
    </script>
    <style>
        /* Existing styles... */
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

        body {
            font-size: 14px;
            line-height: 1.5;
        }

        .main-header {
            background-color: #f8f8f8;
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }

        .header-container, .nav-container, .container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
        }

        .logo img {
            height: 30px;
        }

        .top-nav {
            margin-left: auto;
        }

        .top-nav ul {
            display: flex;
        }

        .top-nav li {
            margin-left: 20px;
            position: relative;
        }

        .top-nav a {
            display: block;
            padding: 8px 12px;
            color: #555;
        }

        .main-nav {
            background-color: #fff;
            border-bottom: 1px solid #eee;
        }

        .main-menu, .right-menu {
            display: flex;
        }

        .main-menu li, .right-menu li {
            position: relative;
        }

        .main-menu > li > a {
            display: block;
            padding: 15px 20px;
            color: #333;
            font-weight: bold;
        }

        .main-menu li.active > a, .right-menu li a:hover, .main-menu li a:hover {
            background-color: #e0e0e0;
            color: #007bff;
        }

        .sub-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background-color: #fff;
            border: 1px solid #eee;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            z-index: 10;
        }

        .main-menu li:hover > .sub-menu {
            display: block;
        }

        .sub-menu li a {
            display: block;
            padding: 10px 20px;
            color: #555;
            white-space: nowrap;
        }

        .sub-menu li a:hover {
            background-color: #f0f0f0;
        }

        .right-menu {
            margin-left: auto;
        }

        .right-menu li {
            margin-left: 10px;
        }

        .right-menu li a {
            display: block;
            padding: 10px 15px;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
            font-weight: bold;
        }



        .container {
            display: flex;
        }


        .sidebar-box {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #eee;
            background-color: #fff;
            border-radius: 5px;
        }

        .sidebar-box h3 {
            margin-bottom: 10px;
            font-size: 16px;
        }

        .sidebar-box label {
            display: block;
            margin-bottom: 5px;
        }

        .sidebar-box select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            box-sizing: border-box;
        }

        .sidebar-box .add-button {
            float: right;
            margin-top: -25px;
            margin-right: 5px;
            color: #007bff;
            font-size: 1.2em;
        }

        .content-area {
            flex: 1;
            background-color: #fff;
            padding: 20px;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        /* Style cho ô input tìm kiếm */
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 250px;
        }

        .filter-bar select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: auto;
            background-color: white;
            font-size: 14px;
            font-family: inherit;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'%3E%3Cpath fill='%23333' d='M2 0L0 2h4zm0 5L0 3h4z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.7em top 50%, 0 0;
            background-size: 0.65em auto, 100%;
            padding-right: 30px;
        }

        /* Đặt search, filter và button cạnh nhau */
        .search-filter {
            display: flex;         /* Bật Flexbox */
            align-items: center;    /* Căn giữa theo chiều dọc */
            gap: 10px;            /* Khoảng cách giữa các phần tử */
            flex-wrap: wrap;       /* Cho phép xuống dòng nếu không đủ chỗ */
            justify-content: flex-start; /* Căn các phần tử về bên trái */
        }

        .header-buttons button {
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        .header-buttons button.export-btn {
            background-color: #28a745;
        }

        .employee-grid {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
        }

        .employee-grid .no-data {
            padding: 50px 0;
            color: #777;
        }

        .employee-grid .no-data i {
            font-size: 2em;
            display: block;
            margin-bottom: 10px;
        }

        .mobile-menu-button {
            display: none;
            flex-direction: column;
            justify-content: space-around;
            width: 30px;
            height: 20px;
            cursor: pointer;
            margin-right: 20px;
        }

        .mobile-menu-button span {
            display: block;
            height: 2px;
            width: 100%;
            background-color: #333;
            border-radius: 2px;
        }

        .main-nav {
            /* ... (styles desktop) ... */
        }

        .main-nav.mobile-open {
            display: block !important;
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            background-color: #fff;
            z-index: 100;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .main-nav.mobile-open .nav-container {
            flex-direction: column;
            align-items: flex-start;
        }

        .main-nav.mobile-open .main-menu, .main-nav.mobile-open .right-menu {
            flex-direction: column;
            width: 100%;
        }

        .main-nav.mobile-open .main-menu > li > a, .main-nav.mobile-open .right-menu li a {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        .main-nav.mobile-open .right-menu {
            margin-left: 0;
        }

        .main-nav.mobile-open .right-menu li a {
            border-radius: 0;
            background-color: transparent;
            color: #007bff;
            font-weight: normal;
            text-align: left;
        }

        .main-nav.mobile-open .sub-menu {
            position: static;
            border: none;
            box-shadow: none;
            display: none;
        }

        .main-nav.mobile-open .main-menu li.has-sub > a::after {
            content: "\f107";
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            float: right;
            margin-left: 10px;
        }

        .main-nav.mobile-open .main-menu li.has-sub.sub-open > a::after {
            content: "\f106";
        }

        .main-nav.mobile-open .sub-menu li a {
            padding-left: 40px;
            border-bottom: 1px solid #eee;
        }

        @media (max-width: 768px) {
            .header-container {
                display: flex;
                justify-content: space-between;
            }

            .mobile-menu-button {
                display: flex;
            }

            .top-nav, .branch-selector, .language-selector, .user-section, .right-menu {
                display: none;
            }

            .main-nav {
                display: none;
            }

            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .content-area {
                border: none;
                padding: 0;
            }

            .content-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-buttons {
                margin-top: 15px;
                display: flex;
                flex-wrap: wrap;
            }

            .header-buttons button {
                margin-bottom: 10px;
            }
        }
        /* Kết thúc nội dung CSS */

        /* CSS cho Modal - GIỮ NGUYÊN */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        /* Style the modal content for a cleaner look */
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto; /* Adjust margin for better positioning */
            padding: 20px;
            border: 1px solid #888;
            width: 80%; /* Make the modal wider */
            max-width: 600px; /* Set a maximum width */
            border-radius: 10px; /* Round the corners */
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); /* Add a subtle shadow */
            position: relative; /* Needed for close button positioning */
        }

        /* Style the close button */
        .close-button {
            color: #aaa;
            position: absolute; /* Position it absolutely */
            top: 10px;
            right: 10px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        /* Style form labels */
        .modal-form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333; /* Darken the label text */
        }

        /* Style form inputs */
        .modal-form-container input[type="text"],
        .modal-form-container input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        /* Style the modal action buttons */
        .modal-actions {
            text-align: right;
            margin-top: 20px;
        }

        .modal-actions button,
        .modal-actions input[type="submit"] {
            padding: 12px 20px;
            margin: 0 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            color: white;
            background-color: #007bff;
        }

        .modal-actions button.close-button {
            background-color: #6c757d;
        }

        .modal-actions button:hover,
        .modal-actions input[type="submit"]:hover {
            opacity: 0.8;
        }

        .card-stats {
            background: linear-gradient(to right, #4CAF50, #81C784);
            color: white;
        }

        .card-stats i {
            font-size: 2rem;
        }

        /* Custom styles for table buttons */
        .btn-edit {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-edit:hover {
            background-color: #0056b3;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-left: 5px;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        /* Basic table styling for better look */
        .employee-grid table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .employee-grid th, .employee-grid td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .employee-grid th {
            background-color: #f4f4f4;
            font-weight: bold;
        }

        .employee-grid tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .employee-grid tbody tr:hover {
            background-color: #f0f0f0;
        }

        .sidebar .nav-link {
            font-size: 1rem;
        }

        .sidebar h4 {
            font-size: 1.5rem;
        }

        .table-bordered {
            border-radius: 20px;
        }

    </style>
</head>
<body>

<div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar col-md-2 p-3">
        <h4 class="text-center mb-4">Admin</h4>
        <ul class="nav flex-column">
            <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-utensils me-2"></i>Menu Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Table Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Customer Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Coupon Management</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Inventory Management</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="col-md-10 bg-white p-3">
        <!-- Navbar -->
        <div class="text-left mb-4">
            <h4>Customer Management</h4>
        </div>

        <%-- Display error message --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div class="alert alert-danger"><%= errorMessage%></div>
        <%
            }
        %>

        <div class="content-header">
            <div class="search-filter">
                <form method="get" action="ViewCustomerList">
                    <div class="search-bar">
                        <input type="text" id="searchInput" name="searchName" placeholder="Search by Name">
                    </div>
                </form>
            </div>
            <div class="header-buttons">
                <button class="btn btn-primary" onclick="openModal('createCustomerModal')"><i class="far fa-plus"></i> Customer</button>
            </div>
        </div>
        <div class = "employee-grid">
        <table class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Payments</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Customer> customers = (List<Customer>) request.getAttribute("customerList");
                    if (customers != null) {
                        int counter = 1;
                        String searchName = request.getParameter("searchName"); // Get search parameter
                        if (searchName == null) {
                            searchName = ""; // Default to empty string if null
                        }
                        searchName = searchName.toLowerCase(); // Make search case-insensitive
                        for (Customer customer : customers) {
                            if (customer.getCustomerName().toLowerCase().contains(searchName)) { // Perform search
                %>
                <tr>
                    <td><%= counter++%></td>
                    <td><%= customer.getCustomerId()%></td>
                    <td><%= customer.getCustomerName()%></td>
                    <td><%= customer.getCustomerPhone()%></td>
                    <td><%= customer.getNumberOfPayment()%></td>
                    <td>
                        <button class="btn btn-primary btn-sm"
                                data-customerid="<%= customer.getCustomerId()%>"
                                data-customername="<%= customer.getCustomerName()%>"
                                data-customerphone="<%= customer.getCustomerPhone()%>"
                                data-numberofpayment="<%= customer.getNumberOfPayment()%>"
                                onclick="openEditModal(this)">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="confirmDelete('<%= customer.getCustomerId()%>', '<%= customer.getCustomerName()%>')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </td>
                </tr>
                <%
                            }
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5">
                        <div class="no-data">
                            <i class="fal fa-user"></i>
                            <span>
                                No customers found.
                            </span>
                        </div>
                    </td>
                </tr>
                <% }%>
            </tbody>
        </table>
        </div>
    </div>
</div>

<!-- Modal Create Customer -->
<div id="createCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-button" onclick="closeModal('createCustomerModal')">×</span>
        <h2>Create Customer</h2>
        <form method="post" action="AddCustomer" class="modal-form-container">
            <div>
                <label>Name</label>
                <input type="text" name="CustomerName" required>
            </div>
            <div>
                <label>Phone</label>
                <input type="text" name="CustomerPhone" required>
            </div>
            <div>
                <label>Number of Payments</label>
                <input type="number" name="NumberOfPayment" required>
            </div>
            <div class="modal-actions">
                <input type="submit" value="Create" class="btn btn-primary"/>
            </div>
        </form>
    </div>
</div>

<!-- Modal Edit Customer -->
<div id="editCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-button" onclick="closeModal('editCustomerModal')">×</span>
        <h2>Edit Customer</h2>
        <form method="post" action="UpdateCustomer"  class="modal-form-container">
            <input type="hidden" id="editCustomerIdHidden" name="customerId">
            <div>
                <label>Name</label>
                <input type="text" id="editCustomerName" name="CustomerName" required>
            </div>
            <div>
                <label>Phone</label>
                <input type="text" id="editCustomerPhone" name="CustomerPhone" required>
            </div>
            <div>
                <label>Number of Payments</label>
                <input type="number" id="editNumberOfPayment" name="NumberOfPayment" required>
            </div>
            <div class="modal-actions">
                 <input type="submit" value="Update" class="btn btn-primary"/>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Modal Create Customer
        var createModal = document.getElementById("createCustomerModal");
        var createBtn = document.querySelector(".btn.btn-primary[onclick=\"openModal('createCustomerModal')\"]");
        var closeCreateButtons = document.querySelectorAll("#createCustomerModal .close-button");

        if (createBtn && createModal) {
            createBtn.onclick = function () {
                createModal.style.display = "block";
            }
        }

        if (closeCreateButtons) {
            closeCreateButtons.forEach(function (btnClose) {
                btnClose.onclick = function () {
                    createModal.style.display = "none";
                }
            });
        }

        // Modal Edit Account
        var editModal = document.getElementById("editCustomerModal");
        var editButtons = document.querySelectorAll(".btn.btn-primary.btn-sm");
        var closeEditButtons = document.querySelectorAll("#editCustomerModal .close-button");

        if (editButtons) {
            editButtons.forEach(function (btnEdit) {
                btnEdit.onclick = function (e) {
                    e.preventDefault();
                    document.getElementById('editCustomerIdHidden').value = btnEdit.dataset.customerid;
                    document.getElementById('editCustomerName').value = btnEdit.dataset.customername;
                    document.getElementById('editCustomerPhone').value = btnEdit.dataset.customerphone;
                    document.getElementById('editNumberOfPayment').value = btnEdit.dataset.numberofpayment;

                    editModal.style.display = "block";
                }
            });
        }

        if (closeEditButtons) {
            closeEditButtons.forEach(function (btnClose) {
                btnClose.onclick = function () {
                    editModal.style.display = "none";
                }
            });
        }

        window.onclick = function (event) {
            if (event.target == createModal) {
                createModal.style.display = "none";
            }
            if (event.target == editModal) {
                editModal.style.display = "none";
            }
        }
    });
    
</script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {



            });


            const searchInput = document.getElementById('searchInput');



            function filterTable() {
                const searchText = searchInput.value.toLowerCase();



                rows.forEach(row => {
                    const id = row.querySelector('td:nth-child(1)').textContent.toLowerCase();
                    const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const phone = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                    const payment = row.querySelector('td:nth-child(4)').textContent.toLowerCase();

                    let matchesSearch = id.includes(searchText) || name.includes(searchText) || phone.includes(searchText) || payment.includes(searchText);

                    if (matchesSearch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            searchInput.addEventListener('keyup', filterTable); // Gọi hàm filterTable khi gõ vào ô tìm kiếm


        </script>

    </body>
</html>