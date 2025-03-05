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
                if (confirm('Are you sure you want to delete the table with ID: ' + tableId + ' - Status: ' + tableStatus + '?')) {
                    window.location.href = 'DeleteTable?TableId=' + tableId;
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
                font-size: 0.9rem; /* Hoặc 16px, tùy vào AdminDashboard.jsp */
            }

            .sidebar h4{
                font-size: 1.5rem;
            }
            .table-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr); /* 4 columns */
                gap: 10px; /* Spacing between table items */
            }

            .table-item {
                border: 1px solid #ddd;
                padding: 10px;
                border-radius: 5px;
                background-color: white;
                display: flex;
                flex-direction: column; /* Stack content vertically */
                justify-content: space-between; /* Space out content and buttons */
                min-height: 100px; /* Adjust as needed */
                position: relative; /* For absolute positioning of buttons */
            }
            /* Status Colors */
            .table-item.available {
                background-color: #fffff5;
            }

            .table-item.occupied {
                background-color: #c7fdc4; /* Light green */
            }

            .table-item.reserved {
                background-color: #b6eaff; /* Blue */
                color: white;  /* White text for reserved */
            }

            .table-info {
                text-align: left; /* Left-align table information */
                margin-bottom: 10px; /* Space between info and buttons */
            }
            .table-id-seats {
                font-weight: bold;
            }
            .table-buttons {
                position: absolute;
                top: 5px;
                right: 5px;
                display: flex;
                flex-direction: column; /* Stack buttons vertically */
                gap: 5px; /* Space between buttons */
            }

            /* Style for individual buttons (make them equal size) */
            .table-buttons a { /* Apply to both edit and delete buttons */
                padding: 5px; /* Consistent padding */
                border: 1px solid #ccc;
                background-color: #ffffff;
                text-decoration: none;
                color: black;
                border-radius: 3px;
                width: 25px;      /* Set a fixed width */
                height: 25px;      /* Set a fixed height */
                display: flex;    /* Use flexbox for centering */
                align-items: center; /* Center vertically */
                justify-content: center; /* Center horizontally */
            }

            .no-data {
                grid-column: span 4;
                text-align: center;
            }

            /* Style for the icons (optional, for consistent size) */
            .table-buttons a i {
                font-size: 16px;  /* Adjust icon size as needed */
            }

            /* Style phân trang */
            .pagination {
                display: flex;
                justify-content: center;
                list-style: none;
                padding: 0;
                margin-top: 20px;
            }

            .pagination li {
                margin: 0 5px;
            }

            .pagination a {
                padding: 5px 10px;
                border: 1px solid #ccc;
                text-decoration: none;
                color: black;
                border-radius: 3px;
            }

            .pagination a.active {
                background-color: #3498db;
                color: white;
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
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>  <!-- Hoặc fas fa-utensils -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li> <!-- Hoặc fas fa-users -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li> <!-- Hoặc fas fa-ticket-alt -->
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
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
                                    <input type="text" id="searchInput" placeholder="Search" onkeyup="filterTables()">
                                </div>
                                <div class="filter-bar">
                                    <select id="statusFilter" onchange="filterTables()">
                                        <option value="">All Status</option>
                                        <option value="Available">Available</option>
                                        <option value="Occupied">Occupied</option>
                                        <option value="Reserved">Reserved</option>
                                    </select>
                                    <select id="floorFilter" style="margin-left: 10px;" onchange="filterTables()">
                                        <option value="all">All Floors</option>
                                        <%
                                            List<Integer> floorNumbers = (List<Integer>) request.getAttribute("floorNumberList");
                                            if (floorNumbers != null) {
                                                for (Integer floor : floorNumbers) {
                                        %>
                                        <option value="<%= floor%>">Floor <%= floor%></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                            <div class="header-buttons">
                                <button class="add-table-btn"><i class="far fa-plus"></i> Table </button>

                            </div>
                        </div>
                        <div class="table-grid" id="tableGrid"> <%-- Thêm ID cho table grid --%>
                            <%
                                List<Table> allTables = (List<Table>) request.getAttribute("tableList");
                                int pageSize = 20; // Số bàn trên mỗi trang.  PHẢI LÀ BỘI SỐ CỦA 4!
                                int totalTables = (allTables != null) ? allTables.size() : 0;
                                int totalPages = (int) Math.ceil((double) totalTables / pageSize);
                                int currentPage = 1; // Mặc định là trang 1

                                // Lấy trang hiện tại từ tham số request
                                String pageParam = request.getParameter("page");
                                if (pageParam != null && !pageParam.isEmpty()) {
                                    try {
                                        currentPage = Integer.parseInt(pageParam);
                                        if (currentPage < 1) {
                                            currentPage = 1;
                                        }
                                        if (currentPage > totalPages) {
                                            currentPage = totalPages;
                                        }
                                    } catch (NumberFormatException e) {
                                        currentPage = 1; // Mặc định là 1 nếu số trang không hợp lệ
                                    }
                                }

                                if (allTables != null && !allTables.isEmpty()) {
                                    int startIndex = (currentPage - 1) * pageSize;
                                    int endIndex = Math.min(startIndex + pageSize, totalTables);
                                    List<Table> tables = allTables.subList(startIndex, endIndex);

                                    for (Table table : tables) {
                                        String tableClass = "table-item";
                                        String statusText = table.getTableStatus();

                                        if (table.getTableStatus().equals("Available")) {
                                            tableClass += " available";
                                        } else if (table.getTableStatus().equals("Occupied")) {
                                            tableClass += " occupied";
                                        } else if (table.getTableStatus().equals("Reserved")) {
                                            tableClass += " reserved";
                                        }
                            %>
                            <div class="<%= tableClass%>">
                                <div class="table-info">
                                    <div class="table-id">ID: <%= table.getTableId()%></div>
                                    <div class="table-floor">Floor: <%= table.getFloorNumber()%></div>
                                    <div class="table-seats">Seats: <%= table.getNumberOfSeats()%></div>
                                    <div class="table-status">Status: <%= statusText%></div>
                                </div>
                                <div class="table-buttons">
                                    <a href="#" class="edit-table-btn btn-edit-table"
                                       data-tableid="<%= table.getTableId()%>"
                                       data-floornumber="<%= table.getFloorNumber()%>"
                                       data-numberofseats="<%= table.getNumberOfSeats()%>"
                                       data-tablestatus="<%= table.getTableStatus()%>">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="#" onclick="confirmDelete('<%= table.getTableId()%>', '<%= table.getTableStatus()%>')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </div>
                            </div>
                            <%
                                }
                            } else {
                            %>
                            <div class="no-data">
                                <i class="fas fa-table"></i>
                                <span>NO TABLE HERE.<br> CLICK <a href="#">HERE</a> TO ADD NEW TABLE.</span>
                            </div>
                            <%
                                }
                            %>
                        </div>
                        <% if (totalPages > 1) { %>
                        <ul class="pagination">
                            <%-- Nút Previous --%>
                            <% if (currentPage > 1) {%>
                            <li><a href="?page=<%= currentPage - 1%>">Back</a></li>
                                <% } %>
                                <%
                                    int startPage = Math.max(1, currentPage - 2);
                                    int endPage = Math.min(totalPages, currentPage + 2);
                                %>

                            <% for (int i = startPage; i <= endPage; i++) {%>
                            <li>
                                <a href="?page=<%= i%>" class="<%= (currentPage == i) ? "active" : ""%>"><%= i%></a>
                            </li>
                            <% } %>

                            <% if (currentPage < totalPages) {%>
                            <li><a href="?page=<%= currentPage + 1%>">Next</a></li>
                                <% } %>
                        </ul>
                        <% }%>

                    </div>
                </section>
            </div>
        </div>

        <!-- Modal Create Table -->
        <div id="createTableModal" class="modal">
            <div class="modal-content">
                <span class="close-button">×</span>
                <h2>Create New Table</h2>
                <form method="post" action="CreateTable"> <%-- Thêm method="post" --%>
                    <div>
                        <label for="TableStatus">Table Status</label>
                        <select id="TableStatus" name="TableStatus" required> <%-- Thêm name --%>
                            <option value="Available">Available</option>
                            <option value="Occupied">Occupied</option>
                            <option value="Reserved">Reserved</option>
                        </select>
                    </div>
                    <div>
                        <label for="FloorNumber">Number Of Floors</label>
                        <input type="number" id="FloorNumber" name="FloorNumber" min="1" required> <%-- Thêm name --%>
                    </div>
                    <div>
                        <label for="NumberOfSeats">Number Of Seats</label>
                        <input type="number" id="NumberOfSeats" name="NumberOfSeats" min="1" required> <%-- Thêm name --%>
                    </div>
                    <div class="modal-actions">
                        <input type="submit" class="btn btn-primary" value="Create Table"/>
                        <button type="button" class="btn btn-secondary close-button">Cancel</button>
                    </div>
                </form>
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
                                <label for="EditFloorNumber">Number Of Floors</label>
                                <input type="number" id="EditFloorNumber" name="FloorNumber" value="" min="1" required>
                            </div>
                            <div>
                                <label for="EditNumberOfSeats">Number Of Seats</label>
                                <input type="number" id="EditNumberOfSeats" name="NumberOfSeats" value="" min="1" required/>
                            </div>
                            <div>
                                <label for="EditTableStatus">Table Status</label>
                                <select id="EditTableStatus" name="TableStatus" required>
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
                            document.getElementById('EditFloorNumber').value = btnEdit.dataset.floornumber;
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

            function filterTables() {
                const searchText = document.getElementById('searchInput').value.toLowerCase();
                const selectedStatus = document.getElementById('statusFilter').value;
                const selectedFloor = document.getElementById('floorFilter').value;
                const tableGrid = document.getElementById('tableGrid'); // Lấy container của table grid
                const tables = tableGrid.querySelectorAll('.table-item'); // Lấy tất cả table items bên trong grid

                tables.forEach(table => {
                    const tableIdText = table.querySelector('.table-id').textContent.toLowerCase();
                    const seatsText = table.querySelector('.table-seats').textContent.toLowerCase();
                    const statusText = table.querySelector('.table-status').textContent.replace('Status:', '').trim(); // Loại bỏ "Status:" và trim
                    const floorText = table.querySelector('.table-floor').textContent.replace('Floor:', '').trim(); // Loại bỏ "Floor:" và trim

                    // Kiểm tra tìm kiếm
                    const matchesSearch = searchText === "" || tableIdText.includes(searchText) || seatsText.includes(searchText);

                    // Kiểm tra trạng thái
                    const matchesStatus = selectedStatus === "" || statusText === selectedStatus;

                    // Kiểm tra tầng
                    const matchesFloor = selectedFloor === "all" || floorText === selectedFloor;

                    if (matchesSearch && matchesStatus && matchesFloor) {
                        table.style.display = ''; // Hiển thị nếu phù hợp tất cả tiêu chí
                    } else {
                        table.style.display = 'none'; // Ẩn nếu không phù hợp
                    }
                });
            }
        </script>
    </body>
</html>