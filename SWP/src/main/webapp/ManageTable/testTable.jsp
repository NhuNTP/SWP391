<%--
    Document   : TableManagement
    Created on : Feb 29, 2025, 10:00:00 AM
    Author     : ADMIN
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Table"%>
<%@page import="DAO.TableDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Table Management - Admin Dashboard</title>
        <script>
            function confirmDelete(tableId, tableStatus) {
                if (confirm('Bạn có chắc chắn muốn xóa bàn ID: ' + tableId + ' - Trạng thái: ' + tableStatus + ' không?')) {
                    window.location.href = 'DeleteTable?id=' + tableId;
                }
            }
        </script>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            /* Bắt đầu nội dung CSS từ tệp style.css */
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
            /* CSS giữ nguyên từ code trước - bao gồm CSS cho modal */
            /* Bắt đầu nội dung CSS từ tệp style.css */
            /*            body, h1, h2, h3, h4, h5, h6, p, ul, li {
                            margin: 0;
                            padding: 0;
                            list-style: none;
                            text-decoration: none;
                            color: #333;
                            font-family: sans-serif;
                        }*/

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
                /*                padding: 0 20px;*/
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
                border: 1px solid #eee;
                border-radius: 5px;
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

            .main-nav.mobile-open .main-menu li, .main-nav.mobile-open .right-menu li {
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

            .modal-content {
                background-color: #fefefe;
                margin: 15% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 60%;
                border-radius: 5px;
                position: relative;
            }

            .close-button {
                color: #aaa;
                float: right;
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

            .modal-form-container div {
                margin-bottom: 15px;
            }

            .modal-form-container label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .modal-form-container input[type="text"],
            .modal-form-container input[type="email"],
            .modal-form-container input[type="password"],
            .modal-form-container select,
            .modal-form-container input[type="file"] {
                width: calc(100% - 22px);
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            .modal-actions {
                text-align: right;
                margin-top: 20px;
            }

            .modal-actions input[type="submit"],
            .modal-actions button.close-button {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                margin-left: 10px; /* Khoảng cách giữa các nút */
            }

            .modal-actions input[type="submit"] {
                background-color: #007bff;
                color: white;
            }

            .modal-actions button.close-button {
                background-color: #dc3545;
                color: white;
            }


            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }

            .card-stats i {
                font-size: 2rem;
            }
            /* Custom styles for table buttons */
            .btn-edit-table {
                background-color: #007bff; /* Blue color for edit */
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none; /* Remove underline if it's an <a> tag */
                display: inline-flex; /* To align icon and text */
                align-items: center;
                justify-content: center;
            }

            .btn-edit-table:hover {
                background-color: #0056b3; /* Darker blue on hover */
            }

            .btn-delete-table {
                background-color: #dc3545; /* Red color for delete */
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none; /* Remove underline if it's an <a> tag */
                display: inline-flex; /* To align icon and text */
                align-items: center;
                justify-content: center;
                margin-left: 5px; /* Add some spacing between buttons */
            }

            .btn-delete-table:hover {
                background-color: #c82333; /* Darker red on hover */
            }

            .btn-edit-table i, .btn-delete-table i {
                margin-right: 5px; /* Spacing between icon and text */
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
                background-color: #f9f9f9; /* Optional: Even row highlight */
            }

            .employee-grid tbody tr:hover {
                background-color: #f0f0f0; /* Optional: Hover effect */
            }

            .sidebar .nav-link {
                font-size: 1rem; /* Hoặc 16px, tùy vào AdminDashboard.jsp */
            }

            .sidebar h4{
                font-size: 1.5rem;
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
            <div class="col-md-10 bg-white p-3">
                <section class="main-content">
                    <div class="container-fluid">
                        <div class="text-left mb-4">
                            <h4>Table Management</h4>
                        </div>
                        <div class="content-header">
                            <div class="search-filter">
                                <div class="search-bar">
                                    <input type="text" id="searchInput" placeholder="Search"> 
                                </div>
                                <div class="filter-bar">
                                    <select id="statusFilter">
                                        <option value="">All Status</option>
                                        <option value="Available">Available</option> <!-- Sửa value -->
                                        <option value="Occupied">Occupied</option> <!-- Sửa value -->
                                        <option value="Reserved">Reserved</option>  <!-- Sửa value -->
                                    </select>
                                </div>
                            </div>
                            <div class="header-buttons">
                                <button class="add-table-btn"><i class="far fa-plus"></i> Table </button>

                            </div>
                        </div>
                        <div class="employee-grid">
                            <table class="table table-striped table-bordered table-hover"> <%-- Added Bootstrap table classes --%>
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>ID</th>
                                        <th>Status</th>
                                        <th>Number of Seats</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- Sử dụng scriptlet để lặp qua tableList --%>
                                    <%
                                        List<Table> tables = (List<Table>) request.getAttribute("tableList");
                                        if (tables != null && !tables.isEmpty()) {
                                            int counter = 1;
                                            for (Table table : tables) {
                                    %>
                                    <tr>
                                        <td><%= counter++%></td>
                                        <td><%= table.getTableId()%></td>
                                        <td><%= table.getTableStatus()%></td>
                                        <td><%= table.getNumberOfSeats()%></td>
                                        <td>
                                            <a href="#" class="edit-table-btn btn-edit-table"     <%-- Added btn-edit-table class --%>
                                               data-tableid="<%=table.getTableId()%>"
                                               data-tablestatus="<%=table.getTableStatus()%>"
                                               data-numberofseats="<%=table.getNumberOfSeats()%>"
                                               ><i class="fas fa-edit"></i>Edit</a> <%-- Added edit icon --%>
                                            <a href="#" onclick="confirmDelete('<%= table.getTableId()%>', '<%= table.getTableStatus()%>')" class="btn-delete btn-delete-table"><i class="fas fa-trash-alt"></i>Delete</a> <%-- Added btn-delete-table class and delete icon --%>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="5">
                                            <div class="no-data">
                                                <i class="fas fa-table"></i>
                                                <span>Không có bàn ăn nào.<br>Nhấn <a href="#">vào đây</a> để thêm mới bàn ăn.</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </div>
        </section>
    </div>
</div>

<!-- Modal Create Table -->
<div id="createTableModal" class="modal">
    <div class="modal-content">
        <span class="close-button">×</span>
        <h2>Create New Table</h2>
        <div class="modal-form-container">
            <form method="post" action="CreateTable">
                <div>
                    <label for="TableStatus">Table Status</label>
                    <select id="TableStatus" name="TableStatus">
                        <option value="Available">Available</option>
                        <option value="Occupied">Occupied</option>
                        <option value="Reserved">Reserved</option>
                    </select>
                </div>
                <div>
                    <label for="NumberOfSeats">Number Of Seats</label>
                    <input type="number" id="NumberOfSeats" name="NumberOfSeats" >
                </div>
                <div class="modal-actions">
                    <input type="submit" class="btn btn-primary" name="btnSubmit" value="Create Table"/> <%-- Bootstrap button style --%>
                    <button type="button" class="btn btn-secondary close-button">Cancel</button> <%-- Bootstrap button style --%>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Edit Table Status -->
<div id="editTableModal" class="modal">
    <div class="modal-content">
        <span class="close-button">×</span>
        <h2>Edit Table Status</h2>
        <div class="modal-form-container">
            <form method="post" action="UpdateTable">
                <input type="hidden" id="EditTableIdHidden" name="TableIdHidden" value=""/>
                <div>
                    <div>
                        <label for="EditTableId">Table ID</label>
                        <input type="text" id="EditTableId" name="TableId" value="" readonly/>
                    </div>
                    <div>
                        <label for="EditNumberOfSeats">Number Of Seats</label>
                        <input type="number" id="EditNumberOfSeats" name="NumberOfSeats" value="" />
                    </div>
                    <div>
                        <label for="EditTableStatus">Table Status</label>
                        <select id="EditTableStatus" name="TableStatus">
                            <option value="Available">Available</option>
                            <option value="Occupied">Occupied</option>
                            <option value="Reserved">Reserved</option>
                        </select>
                    </div>
                </div>

                <!-- Save and Back to List Buttons -->
                <div class="modal-actions">
                    <input type="submit" class="btn btn-primary" name="btnSubmit" value="Save Changes"/> <%-- Bootstrap button style --%>
                    <button type="button" class="btn btn-secondary close-button">Cancel</button> <%-- Bootstrap button style --%>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Modal Create Table
        var createTableModel = document.getElementById("createTableModal");
        var createTableBtn = document.querySelector(".add-table-btn");
        var closeCreateTableButtons = document.querySelectorAll("#createTableModal .close-button");

        if (createTableBtn && createTableModel) {
            createTableBtn.onclick = function () {
                createTableModel.style.display = "block";
            }
        }

        if (closeCreateTableButtons) {
            closeCreateTableButtons.forEach(function (btnClose) {
                btnClose.onclick = function () {
                    createTableModel.style.display = "none";
                }
            });
        }

        // Modal Edit Table
        var editTableModel = document.getElementById("editTableModal");
        var editTableButtons = document.querySelectorAll(".edit-table-btn");
        var closeEditTableButtons = document.querySelectorAll("#editTableModal .close-button");

        if (editTableButtons) {
            editTableButtons.forEach(function (btnEdit) {
                btnEdit.onclick = function (e) {
                    e.preventDefault();
                    document.getElementById('EditTableIdHidden').value = btnEdit.dataset.tableid;
                    document.getElementById('EditTableId').value = btnEdit.dataset.tableid;
                    document.getElementById('EditTableStatus').value = btnEdit.dataset.tablestatus;
                    document.getElementById('EditNumberOfSeats').value = btnEdit.dataset.numberofseats;

                    editTableModel.style.display = "block";
                }
            });
        }

        if (closeEditTableButtons) {
            closeEditTableButtons.forEach(function (btnClose) {
                btnClose.onclick = function () {
                    editTableModel.style.display = "none";
                }
            });
        }


        window.onclick = function (event) {
            if (event.target == createTableModel) {
                createTableModel.style.display = "none";
            }
            if (event.target == editTableModel) {
                editTableModel.style.display = "none";
            }
        }
    });

    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const table = document.querySelector('.table');
    const rows = table.querySelectorAll('tbody tr');

    function filterTable() {
        const searchText = searchInput.value.toLowerCase();
        const selectedStatus = statusFilter.value;

        rows.forEach(row => {
            const numberOfSeats = row.querySelector('td:nth-child(4)').textContent.toLowerCase(); // Cột số ghế
            const status = row.querySelector('td:nth-child(3)').textContent; // Cột trạng thái

            // Tìm kiếm theo số ghế
            let matchesSearch = numberOfSeats.includes(searchText);

            // Lọc theo trạng thái
            let matchesStatus = selectedStatus === '' || status === selectedStatus;

            if (matchesSearch && matchesStatus) {
                row.style.display = ''; // Hiển thị
            } else {
                row.style.display = 'none'; // Ẩn
            }
        });
    }
    searchInput.addEventListener('keyup', filterTable);
    statusFilter.addEventListener('change', filterTable);
</script>
</body>
</html>