<%--
    Document   : test
    Created on : Feb 28, 2025, 9:42:15 PM
    Author     : ADMIN
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.AccountDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Account List - Admin Dashboard</title>
        <script>
            function confirmDelete(userId, userName) {
                if (confirm('Are you sure you want to delete the account with ID: ' + userId + ' - user name: ' + userName + '?')) {
                    window.location.href = 'DeleteAccount?UserId=' + userId; // **Đổi 'id' thành 'UserId'**
                }
            }
            function validateForm() {
                let email = document.getElementById("UserEmail").value.trim();
                let password = document.getElementById("UserPassword").value.trim();
                let name = document.getElementById("UserName").value.trim();
                let role = document.getElementById("UserRole").value;
                let idCard = document.getElementById("IdentityCard").value.trim();
                let address = document.getElementById("UserAddress").value.trim();

                if (!email || !password || !name || !role || !idCard || !address) {
                    alert("Please complete all fields.");
                    return false;
                }

                if (!email.endsWith("@gmail.com")) {
                    alert("Emails must end with '@gmail.com'.");
                    return false;
                }

                if (!/^\d{12}$/.test(idCard)) {
                    alert("ID card/CCCD number must be exactly 12 digits.");
                    return false;
                }

                return true;
            }
            function validateUpdateForm() {
                let email = document.getElementById("EditUserEmail").value.trim();
                let password = document.getElementById("EditUserPassword").value.trim();
                let name = document.getElementById("EditUserName").value.trim();
                let role = document.getElementById("EditUserRole").value;
                let idCard = document.getElementById("EditIdentityCard").value.trim();
                let address = document.getElementById("EditUserAddress").value.trim();

                if (!email || !password || !name || !role || !idCard || !address) {
                    alert("Vui lòng điền đầy đủ tất cả các trường.");
                    return false;
                }

                if (!email.endsWith("@gmail.com")) {
                    alert("Email phải kết thúc bằng '@gmail.com'.");
                    return false;
                }

                if (!/^\d{12}$/.test(idCard)) {
                    alert("Số CMND/CCCD phải đúng 12 chữ số.");
                    return false;
                }

                return true;
            }
        </script>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
                justify-content: center;
                align-items: center;
            }

            .modal-content {
                background-color: #fefefe;
                margin-top: 4%;
                margin-left: auto; /* Giữ margin-left và margin-right là auto để căn giữa ngang */
                margin-right: auto;
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
            .btn-edit {
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

            .btn-edit:hover {
                background-color: #0056b3; /* Darker blue on hover */
            }

            .btn-delete {
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

            .btn-delete:hover {
                background-color: #c82333; /* Darker red on hover */
            }

            .btn-edit i, .btn-delete i {
                margin-right: 5px; /* Spacing between icon and text */
            }

            .button-container {
                display: flex; /* Kích hoạt Flexbox cho container */
                flex-direction: row; /* Sắp xếp các nút theo hàng ngang */
                align-items: center; /* Căn chỉnh các nút theo chiều dọc (tùy chọn) */
                gap: 5px; /* Khoảng cách giữa các nút (tùy chỉnh) */
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

            .table-bordered {
                border-radius: 20px; /* Bo tròn viền ngoài của bảng */
            }
            .rounded-image {
                width: 100px;  /* Giữ nguyên kích thước, hoặc điều chỉnh nếu cần */
                height: 100px;
                border-radius: 50%; /* Làm tròn ảnh */
                object-fit: cover; /* Đảm bảo ảnh lấp đầy khung tròn */
                object-position: center; /* Căn giữa ảnh */
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
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>View Notifications</a></li>

                    <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>

                    <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 bg-white p-3 main-content-area">
                <section class="main-content">
                    <div class="container-fluid">
                        <div class="text-left mb-4">
                            <h4>Employee Management</h4>
                        </div>
                        <div class="content-header">
                            <div class="search-filter">
                                <div class="search-bar">
                                    <input type="text" id="searchInput" placeholder="Search">  <!-- Thêm id="searchInput" -->
                                </div>
                                <div class="filter-bar">
                                    <select id="roleFilter">
                                        <option value="">All Roles</option>  <!-- Thêm option "All Roles" -->
                                        <option value="Admin">Admin</option>
                                        <option value="Waiter">Waiter</option>
                                        <option value="Manager">Manager</option>
                                        <option value="Kitchen staff">Kitchen staff</option>
                                        <option value="Cashier">Cashier</option>
                                    </select>
                                </div>
                            </div>
                            <div class="header-buttons">
                                <button class="add-employee-btn"><i class="far fa-plus"></i> Employee </button>
                            </div>
                        </div>
                        <div class="employee-grid">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>ID</th>
                                        <th>Image</th>
                                        <th>Account Email</th>
                                        <th>Account Password</th>
                                        <th>Account Name</th>
                                        <th>Account Role</th>
                                        <th>Identity Card</th>
                                        <th>User Address</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Account> accounts = (List<Account>) request.getAttribute("accountList");
                                        int pageSize = 4; // Số tài khoản trên mỗi trang
                                        int totalAccounts = (accounts != null) ? accounts.size() : 0;
                                        int totalPages = (int) Math.ceil((double) totalAccounts / pageSize);
                                        int currentPage = 1; // Mặc định là trang 1

                                        // Lấy trang hiện tại từ request
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
                                                currentPage = 1;
                                            }
                                        }

                                        // Xác định phạm vi hiển thị
                                        int startIndex = (currentPage - 1) * pageSize;
                                        int endIndex = Math.min(startIndex + pageSize, totalAccounts);
                                        List<Account> paginatedAccounts = (accounts != null) ? accounts.subList(startIndex, endIndex) : null;

                                        if (paginatedAccounts != null && !paginatedAccounts.isEmpty()) {
                                            int counter = startIndex + 1;
                                            for (Account account : paginatedAccounts) {
                                    %>
                                    <tr>
                                        <td><%= counter++%></td>
                                        <td><%= account.getUserId()%></td>
                                        <td>
                                            <%
                                                String imagePath = account.getUserImage();
                                                if (imagePath != null && !imagePath.trim().isEmpty()) {
                                            %>
                                            <img src="<%= imagePath%>" alt="<%= account.getUserName()%> " class="rounded-image">
                                            <%
                                            } else {
                                            %>
                                            No Image
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td><%= account.getUserEmail()%></td>
                                        <td><%= account.getUserPassword()%></td> 
                                        <td><%= account.getUserName()%></td>
                                        <td><%= account.getUserRole()%></td>
                                        <td><%= account.getIdentityCard()%></td>
                                        <td><%= account.getUserAddress()%></td>
                                        <td >
                                            <% if (!account.getUserRole().equalsIgnoreCase("admin")) {%>
                                            <div class="button-container"> <%-- Thêm div container với class="button-container" --%>
                                                <a href="#" class="edit-employee-btn btn-edit"
                                                   data-userid="<%=account.getUserId()%>"
                                                   data-useremail="<%=account.getUserEmail()%>"
                                                   data-username="<%=account.getUserName()%>"
                                                   data-userpassword="<%=account.getUserPassword()%>"
                                                   data-userrole="<%=account.getUserRole()%>"
                                                   data-identitycard="<%=account.getIdentityCard()%>"
                                                   data-useraddress="<%=account.getUserAddress()%>"
                                                   data-userimage="<%=account.getUserImage()%>">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="#" onclick="confirmDelete('<%= account.getUserId()%>', '<%= account.getUserName()%>')" class="btn-delete">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </a>
                                            </div> <%-- Đóng div container --%>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="10">
                                            <div class="no-data">
                                                <i class="fal fa-user"></i>
                                                <span>
                                                    <% if (request.getParameter("search") != null) { %>
                                                    Can not find result.
                                                    <% } else { %>
                                                    NOT ACCOUNT HERE. CLICK <a href="#">HERE</a> TO ADD NEW EMPLOYEE.
                                                    <% } %>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>  

                        <%-- Phân trang --%>
                        <% if (totalPages > 1) { %>
                        <ul class="pagination">
                            <%-- Nút Previous --%>
                            <% if (currentPage > 1) {%>
                            <li><a href="?page=<%= currentPage - 1%>">Back</a></li>
                                <% } %>

                            <%-- Các số trang --%>
                            <% for (int i = 1; i <= totalPages; i++) {%>
                            <li><a href="?page=<%= i%>" <% if (currentPage == i) { %>class="active"<% }%>><%= i%></a></li>
                                <% } %>

                            <%-- Nút Next --%>
                            <% if (currentPage < totalPages) {%>
                            <li><a href="?page=<%= currentPage + 1%>">Next</a></li>
                                <% } %>
                        </ul>
                        <% }%>                
                </section>
            </div>
        </div>

        <!-- Modal Create Employee Account -->
        <div id="createEmployeeModal" class="modal">
            <div class="modal-content">
                <span class="close-button">×</span>
                <h2>Create New Employee Account</h2>
                <div class="modal-form-container">
                    <form method="post" action="CreateAccount" enctype="multipart/form-data" onsubmit="return validateForm()">
                        <div>
                            <label for="UserEmail">Email Address</label>
                            <input type="email" id="UserEmail" name="UserEmail" placeholder="Enter email" required="Please fill in this field">
                        </div>
                        <div>
                            <label for="UserPassword">Password</label>
                            <input type="password" id="UserPassword" name="UserPassword" placeholder="Password" required="Please fill in this field">
                        </div>
                        <div>
                            <label for="UserName">Full Name</label>
                            <input type="text" id="UserName" name="UserName" placeholder="Enter full name" required="Please fill in this field">
                        </div>
                        <div>
                            <label for="UserRole">Role</label>
                            <select id="UserRole" name="UserRole" required="Please select in this field">
                                <option value="Manager">Manager</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Waiter">Waiter</option>
                                <option value="Kitchen staff">Kitchen staff</option>
                            </select>
                        </div>
                        <div>
                            <label for="IdentityCard">Identity Card (12 digits)</label>
                            <input type="text" id="IdentityCard" name="IdentityCard" placeholder="Enter 12-digit ID Card number" required="Please fill in this field">
                        </div>
                        <div>
                            <label for="UserAddress">Address</label>
                            <input type="text" id="UserAddress" name="UserAddress" placeholder="Enter address" required="Please fill in this field">
                        </div>
                        <div>
                            <label for="UserImage">Profile Image</label>
                            <input type="file" id="UserImage" name="UserImage" required="Please fill in this field">
                        </div>
                        <div class="modal-actions">
                            <input type="submit" class="btn btn-primary" name="btnSubmit" value="Create Account"/>
                            <button type="button" class="btn btn-secondary close-button">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Edit Employee Account -->
        <div id="editEmployeeModal" class="modal">
            <div class="modal-content">
                <span class="close-button">×</span>
                <h2>Edit Employee Account</h2>
                <div class="modal-form-container">
                    <form method="post" action="UpdateAccount" enctype="multipart/form-data" onsubmit="return validateUpdateForm()">
                        <input type="hidden" id="EditUserIdHidden" name="UserIdHidden" value=""/>
                        <div>
                            <div>
                                <div>
                                    <img id="EditCurrentImage" src="" alt="Current Image" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover;"/>
                                </div>
                                <label for="EditUserImage">Update Profile Image</label>
                                <input type="file" id="EditUserImage" name="UserImage"/>
                            </div>
                            <div>
                                <div>
                                    <label for="EditUserId">User ID</label>
                                    <input type="text" id="EditUserId" name="UserId" value="" readonly/>
                                </div>
                                <div>
                                    <label for="EditUserEmail">Email Address</label>
                                    <input type="email" id="EditUserEmail" name="UserEmail" value="" required="Please fill in this field"/>
                                </div>
                                <div>
                                    <label for="EditUserPassword">Password</label>
                                    <input type="password" id="EditUserPassword" name="UserPassword" value="" required="Please fill in this field"/>
                                </div>
                                <div>
                                    <label for="EditUserName">Full Name</label>
                                    <input type="text" id="EditUserName" name="UserName" value="" required="Please fill in this field"/>
                                </div>
                                <div>
                                    <label for="EditUserRole">Role</label>
                                    <select id="EditUserRole" name="UserRole" required="Please select in this field">
                                        <option value="Manager">Manager</option>
                                        <option value="Cashier">Cashier</option>
                                        <option value="Waiter">Waiter</option>
                                        <option value="Kitchen staff">Kitchen staff</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="EditIdentityCard">Identity Card (12 digits)</label>
                                    <input type="text" id="EditIdentityCard" name="IdentityCard" value="" required="Please fill in this field"/>
                                </div>
                                <div>
                                    <label for="EditUserAddress">Address</label>
                                    <input type="text" id="EditUserAddress" name="UserAddress" value="" required="Please fill in this field"/>
                                </div>
                            </div>
                        </div>

                        <!-- Save and Back to List Buttons -->
                        <div class="modal-actions">
                            <input type="submit" class="btn btn-primary" name="btnSubmit" value="Save Changes"/>
                            <button type="button" class="btn btn-secondary close-button">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Modal Create Account
                var createModal = document.getElementById("createEmployeeModal");
                var createBtn = document.querySelector(".add-employee-btn");
                var closeCreateButtons = document.querySelectorAll("#createEmployeeModal .close-button");

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
                var editModal = document.getElementById("editEmployeeModal");
                var editButtons = document.querySelectorAll(".edit-employee-btn");
                var closeEditButtons = document.querySelectorAll("#editEmployeeModal .close-button");

                if (editButtons) {
                    editButtons.forEach(function (btnEdit) {
                        btnEdit.onclick = function (e) {
                            e.preventDefault();
                            document.getElementById('EditUserIdHidden').value = btnEdit.dataset.userid;
                            document.getElementById('EditUserId').value = btnEdit.dataset.userid;
                            document.getElementById('EditUserEmail').value = btnEdit.dataset.useremail;
                            document.getElementById('EditUserName').value = btnEdit.dataset.username;
                            document.getElementById('EditUserPassword').value = btnEdit.dataset.userpassword;
                            document.getElementById('EditUserRole').value = btnEdit.dataset.userrole;
                            document.getElementById('EditIdentityCard').value = btnEdit.dataset.identitycard;
                            document.getElementById('EditUserAddress').value = btnEdit.dataset.useraddress;
                            document.getElementById('EditCurrentImage').src = '<%= request.getContextPath()%>' + btnEdit.dataset.userimage;

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
            const searchInput = document.getElementById('searchInput');
            const roleFilter = document.getElementById('roleFilter'); // Lấy phần tử select
            const table = document.querySelector('.table');
            const rows = table.querySelectorAll('tbody tr');

            function filterTable() {
                const searchText = searchInput.value.toLowerCase();
                const selectedRole = roleFilter.value; // Lấy role được chọn

                rows.forEach(row => {
                    const id = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const name = row.querySelector('td:nth-child(6)').textContent.toLowerCase();
                    const email = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                    const role = row.querySelector('td:nth-child(7)').textContent; // Lấy role của hàng, không chuyển thành chữ thường

                    let matchesSearch = id.includes(searchText) || name.includes(searchText) || email.includes(searchText);
                    let matchesRole = selectedRole === '' || role === selectedRole; // So sánh với role được chọn, hoặc hiển thị tất cả nếu chọn "All Roles"

                    if (matchesSearch && matchesRole) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }
            searchInput.addEventListener('keyup', filterTable); // Gọi hàm filterTable khi gõ vào ô tìm kiếm
            roleFilter.addEventListener('change', filterTable); // Gọi hàm filterTable khi thay đổi lựa chọn trong dropdown

        </script>
    </body>
</html>