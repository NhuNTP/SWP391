<%--
    Document   : ViewOrderList
    Created on : Feb 27, 2025, 4:24:31 AM
    Author     : HuynhPhuBinh
--%>

<%@page import="DAO.OrderDAO"%>
<%@page import="Model.Order"%>
<%@page import="Model.OrderDetail"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order List</title>
        <script>
            function confirmDelete(userId, userName) {
                if (confirm('Bạn có chắc chắn muốn xóa tài khoản ID: ' + userId + ' - Tên người dùng: ' + userName + ' không?')) {
                    window.location.href = 'DeleteAccount?id=' + userId;
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

            <!-- Main Content -->
            <div class="col-md-10 bg-white p-3">
                <!-- Navbar -->
                <div class="text-left mb-4">
                    <h4>Order Management</h4>
                </div>
                <div class="content-header">
                    <div class="search-filter">
                        <div class="search-bar">
                            <input type="text" id="searchInput" placeholder="Search">  <!-- Thêm id="searchInput" -->
                        </div>
                    </div>
                    <div class="header-buttons">
                        <button class="add-employee-btn" onclick="window.location.href = 'CreateOrder'"><i class="far fa-plus"></i> Add Order</button>
                    </div>
                </div>
                <div class = "employee-grid">
                    <table class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>User ID</th>
                                <th>Customer ID</th>
                                <th>Order Date</th>
                                <th>Order Status</th>
                                <th>Order Type</th>
                                <th>Order Description</th>
                                <th>Coupon ID</th>
                                <th>Table ID</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Order> orders = (List<Order>) request.getAttribute("orderList");
                                if (orders != null) {
                                    for (Order order : orders) {
                            %>
                            <tr>
                                <td><%= order.getOrderId()%></td>
                                <td><%= order.getUserId()%></td>
                                <td><%= order.getCustomerId()%></td>
                                <td><%= order.getOrderDate()%></td>
                                <td><%= order.getOrderStatus()%></td>
                                <td><%= order.getOrderType()%></td>
                                <td><%= order.getOrderDescription()%></td>
                                <td><%= order.getCouponId()%></td>
                                <td><%= order.getTableId()%></td>
                                <td>
                                    <a href="UpdateOrder?orderId=<%= order.getOrderId()%>" class="btn btn-profile btn-edit"><i class="fas fa-edit"></i>Update</a>
                                    <a href="ViewOrderDetail?orderId=<%= order.getOrderId()%>" class="btn btn-profile btn-edit"><i class="fas fa-edit"></i>Detail</a>
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
                                            No orders found.
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

        <!-- Modal Create Employee Account -->


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