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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <title>Employee Account List - Admin Dashboard</title>
        <%-- <script>
            function confirmDelete(userId, userName) {
                if (confirm('Are you sure you want to delete the account with ID: ' + userId + ' - User Name: ' + userName + '?')) {
                    $.ajax({
                        url: 'DeleteAccount',
                        type: 'GET',
                        data: {UserId: userId},
                        success: function () {
                            location.reload();
                        },
                        error: function (xhr, status, error) {
                            alert("Error deleting account: " + error);
                        }
                    });
                }
            }

            function validateCreateForm() {
                let email = $("#UserEmail").val().trim();
                let password = $("#UserPassword").val().trim();
                let name = $("#UserName").val().trim();
                let role = $("#UserRole").val();
                let idCard = $("#IdentityCard").val().trim();
                let address = $("#UserAddress").val().trim();
                let phone = $("#UserPhone").val().trim();

                if (!email || !password || !name || !role || !idCard || !address || !phone) {
                    alert("Please fill in all required fields.");
                    return false;
                }
                if (!email.endsWith("@gmail.com")) {
                    alert("Email must end with '@gmail.com'.");
                    return false;
                }
                if (!/^\d{12}$/.test(idCard)) {
                    alert("ID card/CCCD number must be exactly 12 digits.");
                    return false;
                }
                return true;
            }

            function validateUpdateDetailForm() {
                let email = $("#DetailUserEmail").val().trim();
                let password = $("#DetailUserPassword").val().trim();
                let name = $("#DetailUserName").val().trim();
                let role = $("#DetailUserRole").val();
                let idCard = $("#DetailIdentityCard").val().trim();
                let address = $("#DetailUserAddress").val().trim();
                let phone = $("#DetailUserPhone").val().trim();

                if (!email || !password || !name || !role || !idCard || !address || !phone) {
                    alert("Please fill in all required fields.");
                    return false;
                }
                if (!email.endsWith("@gmail.com")) {
                    alert("Email must end with '@gmail.com'.");
                    return false;
                }
                if (!/^\d{12}$/.test(idCard)) {
                    alert("Identity Card must be exactly 12 digits.");
                    return false;
                }
                return true;
            }

            function submitCreateForm(event) {
                event.preventDefault();
                if (!validateCreateForm())
                    return false;

                var formData = new FormData($("#createAccountForm")[0]);
                $.ajax({
                    url: "CreateAccount",
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            alert("Account created successfully!");
                            $("#createEmployeeModal").hide();
                            location.reload();
                        } else {
                            alert(response.message || "Failed to create account.");
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error creating account: " + error);
                    }
                });
                return false;
            }

            function submitUpdateDetailForm(event) {
                event.preventDefault();
                if (!validateUpdateDetailForm())
                    return false;

                var formData = new FormData($("#updateAccountDetailForm")[0]);
                $.ajax({
                    url: "UpdateAccount",
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            alert("Account updated successfully!");
                            $("#viewAccountDetailModal").hide();
                            location.reload();
                        } else {
                            alert(response.message || "Failed to update account.");
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error updating account: " + error);
                    }
                });
                return false;
            }

            function checkImageSelected() {
                var imageInput = $("#DetailUserImage")[0];
                var noImageMessage = $("#noImageMessage");
                var currentImage = $("#DetailCurrentImage");

                if (imageInput.files.length === 0 && currentImage.attr('src') === '') {
                    noImageMessage.show();
                    currentImage.hide();
                } else {
                    noImageMessage.hide();
                    currentImage.show();
                }
            }

            $(document).ready(function () {
                var createModal = $("#createEmployeeModal");
                var detailModal = $("#viewAccountDetailModal");
                var createBtn = $(".add-employee-btn");
                var detailButtons = $(".view-detail-btn");

                // Override default HTML5 validation messages to English
                function setCustomValidationMessages(formId) {
                    $(`#${formId} [required]`).each(function () {
                        $(this).on('invalid', function (e) {
                            e.preventDefault();
                            this.setCustomValidity('Please fill in this field.');
                        });
                        $(this).on('input', function () {
                            this.setCustomValidity('');
                        });
                    });
                }

                // Apply custom validation messages to both forms
                setCustomValidationMessages('createAccountForm');
                setCustomValidationMessages('updateAccountDetailForm');

                createBtn.on("click", function () {
                    createModal.show();
                    $("#createAccountForm")[0].reset();
                    $("#createNoImageMessage").show();
                    $("#createCurrentImage").hide();
                });

                detailButtons.on("click", function (e) {
                    e.preventDefault();
                    var btn = $(this);
                    var isAdmin = btn.data("userrole").toLowerCase() === "admin";

                    $("#DetailUserIdHidden").val(btn.data("userid"));
                    $("#DetailUserRoleHidden").val(btn.data("userrole"));
                    $("#DetailUserId").val(btn.data("userid"));
                    $("#DetailUserEmail").val(btn.data("useremail"));
                    $("#DetailUserPassword").val(btn.data("userpassword"));
                    $("#DetailUserName").val(btn.data("username"));
                    $("#DetailUserRole").val(btn.data("userrole"));
                    $("#DetailIdentityCard").val(btn.data("identitycard"));
                    $("#DetailUserAddress").val(btn.data("useraddress"));
                    $("#DetailUserPhone").val(btn.data("userphone") || '');
                    $("#DetailCurrentImage").attr("src", btn.data("userimage") || '');
                    $("#DetailOldImagePath").val(btn.data("userimage") || '');

                    $("#DetailUserEmail, #DetailUserPassword, #DetailUserName, #DetailUserRole, #DetailIdentityCard, #DetailUserAddress, #DetailUserPhone, #DetailUserImage")
                            .prop("disabled", isAdmin);

                    var modalActions = $("#modalActions");
                    modalActions.empty();
                    if (isAdmin) {
                        modalActions.append('<button type="button" class="close-button" onclick="$(\'#viewAccountDetailModal\').hide();">Close</button>');
                    } else {
                        modalActions.append('<input type="submit" value="Update">');
                        modalActions.append('<button type="button" class="delete-button" id="deleteAccountBtn">Delete</button>');
                        modalActions.append('<button type="button" class="close-button" onclick="$(\'#viewAccountDetailModal\').hide();">Cancel</button>');

                        $("#deleteAccountBtn").off("click").on("click", function () {
                            confirmDelete(btn.data("userid"), btn.data("username"));
                        });
                    }

                    detailModal.show();
                    checkImageSelected();
                });

                $("#createAccountForm").submit(submitCreateForm);
                $("#updateAccountDetailForm").submit(submitUpdateDetailForm);

                $(window).on("click", function (event) {
                    if (event.target == createModal[0])
                        createModal.hide();
                    if (event.target == detailModal[0])
                        detailModal.hide();
                });

                $("#searchInput").on("keyup", filterTable);
                $("#roleFilter").on("change", filterTable);

                function filterTable() {
                    const searchText = $("#searchInput").val().toLowerCase();
                    const selectedRole = $("#roleFilter").val();
                    $("table tbody tr").each(function () {
                        const id = $(this).find("td:nth-child(2)").text().toLowerCase();
                        const name = $(this).find("td:nth-child(3)").text().toLowerCase();
                        const email = $(this).find("td:nth-child(4)").text().toLowerCase();
                        const role = $(this).find("td:nth-child(5)").text();

                        let matchesSearch = id.includes(searchText) || name.includes(searchText) || email.includes(searchText);
                        let matchesRole = selectedRole === '' || role === selectedRole;

                        $(this).css("display", (matchesSearch && matchesRole) ? '' : 'none');
                    });
                }
            });
        </script> --%>

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

            /* CSS cho Modal */
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
                margin-left: auto;
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
            .modal-actions button {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                margin-left: 10px;
                transition: background-color 0.3s ease;
            }

            .modal-actions input[type="submit"] {
                background-color: #007bff;
                color: white;
            }

            .modal-actions input[type="submit"]:hover {
                background-color: #0056b3;
            }

            .modal-actions button.close-button {
                background-color: #6c757d; /* Gray for "Close" button */
                color: white;
            }

            .modal-actions button.close-button:hover {
                background-color: #5a6268;
            }

            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }

            .card-stats i {
                font-size: 2rem;
            }

            /* Updated styles for buttons */
            .btn-detail {
                background-color: #17a2b8; /* Cyan color for "View Detail" */
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.3s ease;
            }

            .btn-detail:hover {
                background-color: #138496; /* Darker cyan on hover */
            }

            .btn-delete {
                background-color: #dc3545; /* Red color for "Delete" */
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-left: 5px;
                transition: background-color 0.3s ease;
            }

            .btn-delete:hover {
                background-color: #c82333; /* Darker red on hover */
            }

            /* Style for the delete button in the modal */
            .modal-actions .delete-button {
                background-color: #dc3545; /* Red color for "Delete" in modal */
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                margin-left: 10px;
                transition: background-color 0.3s ease;
            }

            .modal-actions .delete-button:hover {
                background-color: #c82333; /* Darker red on hover */
            }

            .button-container {
                display: flex;
                flex-direction: row;
                align-items: center;
                gap: 5px;
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
                font-size: 0.9rem;
            }

            .sidebar h4 {
                font-size: 1.5rem;
            }

            .table-bordered {
                border-radius: 20px;
            }

            .rounded-image {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                object-position: center;
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

            .custom-file-upload {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .btn.btn-secondary {
                padding: 8px 16px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn.btn-secondary:hover {
                background-color: #0056b3;
            }

            #createFileNameDisplay, #updateFileNameDisplay {
                font-size: 14px;
                color: #555;
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

                    <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>

                    <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 bg-white p-3 content-area">
                <div class="container-fluid">
                    <div class="text-left mb-4">
                        <h4>Employee Management</h4>
                    </div>
                    <div class="content-header">
                        <div class="search-filter">
                            <div class="search-bar">
                                <input type="text" id="searchInput" placeholder="Search">
                            </div>
                            <div class="filter-bar">
                                <select id="roleFilter">
                                    <option value="">All Roles</option>
                                    <option value="Admin">Admin</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Cashier">Cashier</option>
                                    <option value="Waiter">Waiter</option>
                                    <option value="Kitchen staff">Kitchen staff</option>
                                </select>
                            </div>
                        </div>
                        <div class="header-buttons">
                            <button class="add-employee-btn"><i class="far fa-plus"></i> Employee</button>
                        </div>
                    </div>
                    <div class="employee-grid">
                        <table class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>User ID</th>
                                    <th>User Name</th>
                                    <th>User Email</th>
                                    <th>User Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Account> accounts = (List<Account>) request.getAttribute("accountList");
                                    int pageSize = 4;
                                    int totalAccounts = (accounts != null) ? accounts.size() : 0;
                                    int totalPages = (int) Math.ceil((double) totalAccounts / pageSize);
                                    int currentPage = 1;

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
                                    <td><%= account.getUserName()%></td>
                                    <td><%= account.getUserEmail()%></td>
                                    <td><%= account.getUserRole()%></td>
                                    <td>
                                        <a href="#" class="btn-detail view-detail-btn"
                                           data-userid="<%= account.getUserId()%>"
                                           data-useremail="<%= account.getUserEmail()%>"
                                           data-userpassword="<%= account.getUserPassword()%>"
                                           data-username="<%= account.getUserName()%>"
                                           data-userrole="<%= account.getUserRole()%>"
                                           data-identitycard="<%= account.getIdentityCard()%>"
                                           data-useraddress="<%= account.getUserAddress()%>"
                                           data-userphone="<%= account.getUserPhone()%>"
                                           data-userimage="<%= account.getUserImage()%>">View Profile</a>
                                        <% if (!account.getUserRole().equalsIgnoreCase("Admin")) {%>
                                        <a href="#" onclick="confirmDelete('<%= account.getUserId()%>', '<%= account.getUserName()%>')" class="btn-delete">Delete</a>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr><td colspan="6">No accounts found.</td></tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <% if (totalPages > 1) { %>
                    <ul class="pagination">
                        <% if (currentPage > 1) {%>
                        <li><a href="?page=<%= currentPage - 1%>">Back</a></li>
                            <% } %>
                            <% for (int i = 1; i <= totalPages; i++) {%>
                        <li><a href="?page=<%= i%>" <% if (currentPage == i) { %>class="active"<% }%>><%= i%></a></li>
                            <% } %>
                            <% if (currentPage < totalPages) {%>
                        <li><a href="?page=<%= currentPage + 1%>">Next</a></li>
                            <% } %>
                    </ul>
                    <% }%>
                </div>
            </div>
        </div>

        <!-- Modal Create Employee Account -->
        <div id="createEmployeeModal" class="modal">
            <div class="modal-content">
                <span class="close-button" onclick="$('#createEmployeeModal').hide();">×</span>
                <h2>Create New Employee Account</h2>
                <div class="modal-form-container">
                    <form id="createAccountForm" enctype="multipart/form-data">
                        <div>
                            <label for="UserEmail">Email Address</label>
                            <input type="email" id="UserEmail" name="UserEmail" placeholder="Enter email" required>
                        </div>
                        <div>
                            <label for="UserPassword">Password</label>
                            <input type="password" id="UserPassword" name="UserPassword" placeholder="Enter password" required>
                        </div>
                        <div>
                            <label for="UserName">Full Name</label>
                            <input type="text" id="UserName" name="UserName" placeholder="Enter full name" required>
                        </div>
                        <div>
                            <label for="UserRole">Role</label>
                            <select id="UserRole" name="UserRole" required>
                                <option value="Manager">Manager</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Waiter">Waiter</option>
                                <option value="Kitchen staff">Kitchen staff</option>
                            </select>
                        </div>
                        <div>
                            <label for="IdentityCard">Identity Card (12 digits)</label>
                            <input type="text" id="IdentityCard" name="IdentityCard" placeholder="Enter 12-digit ID card number" required>
                        </div>
                        <div>
                            <label for="UserAddress">Address</label>
                            <input type="text" id="UserAddress" name="UserAddress" placeholder="Enter address" required>
                        </div>
                        <div>
                            <label for="UserPhone">Phone</label>
                            <input type="text" id="UserPhone" name="UserPhone" placeholder="Enter phone number" required>
                        </div>
                        <div>
                            <label for="UserImage">Profile Image</label>
                            <img id="createCurrentImage" src="" alt="Profile Image" class="rounded-image" style="display:none;">
                            <p id="createNoImageMessage" style="color: gray;">No image selected</p>
                            <div class="custom-file-upload">
                                <input type="file" id="UserImage" name="UserImage" onchange="checkImageSelected('create')" accept="image/*" style="display: none;">
                                <button type="button" id="createCustomFileButton" class="btn btn-secondary">Choose File</button>
                                <span id="createFileNameDisplay">No file chosen</span>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <input type="submit" value="Create Account">
                            <button type="button" class="close-button" onclick="$('#createEmployeeModal').hide();">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal View Account Detail -->
        <div id="viewAccountDetailModal" class="modal">
            <div class="modal-content">
                <span class="close-button" onclick="$('#viewAccountDetailModal').hide();">×</span>
                <h2>Account Detail</h2>
                <div class="modal-form-container">
                    <form id="updateAccountDetailForm" enctype="multipart/form-data">
                        <input type="hidden" id="DetailUserIdHidden" name="UserIdHidden">
                        <input type="hidden" id="DetailUserRoleHidden" name="UserRoleHidden">
                        <div>
                            <label>Current Image</label>
                            <img id="DetailCurrentImage" src="" alt="Current Image" class="rounded-image">
                            <p id="noImageMessage" style="display:none; color: gray;">No image selected</p>
                        </div>
                        <div>
                            <label for="DetailUserImage">Update Image</label>
                            <div class="custom-file-upload">
                                <input type="file" id="DetailUserImage" name="UserImage" onchange="checkImageSelected('update')" accept="image/*" style="display: none;">
                                <button type="button" id="updateCustomFileButton" class="btn btn-secondary">Choose File</button>
                                <span id="updateFileNameDisplay">No file chosen</span>
                            </div>
                            <input type="hidden" name="oldImagePath" id="DetailOldImagePath">
                        </div>
                        <div>
                            <label for="DetailUserId">User ID</label>
                            <input type="text" id="DetailUserId" name="UserId" readonly>
                        </div>
                        <div>
                            <label for="DetailUserEmail">Email Address</label>
                            <input type="email" id="DetailUserEmail" name="UserEmail" placeholder="Enter email address" required>
                        </div>
                        <div>
                            <label for="DetailUserPassword">Password</label>
                            <input type="password" id="DetailUserPassword" name="UserPassword" placeholder="Enter password" required>
                        </div>
                        <div>
                            <label for="DetailUserName">Full Name</label>
                            <input type="text" id="DetailUserName" name="UserName" placeholder="Enter full name" required>
                        </div>
                        <div>
                            <label for="DetailUserRole">Role</label>
                            <select id="DetailUserRole" name="UserRole" required>
                                <option value="Manager">Manager</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Waiter">Waiter</option>
                                <option value="Kitchen staff">Kitchen staff</option>
                            </select>
                        </div>
                        <div>
                            <label for="DetailIdentityCard">Identity Card</label>
                            <input type="text" id="DetailIdentityCard" name="IdentityCard" placeholder="Enter identity card" required>
                        </div>
                        <div>
                            <label for="DetailUserAddress">Address</label>
                            <input type="text" id="DetailUserAddress" name="UserAddress" placeholder="Enter address" required>
                        </div>
                        <div>
                            <label for="DetailUserPhone">Phone</label>
                            <input type="text" id="DetailUserPhone" name="UserPhone" placeholder="Enter phone number" required>
                        </div>
                        <div class="modal-actions" id="modalActions">
                            <!-- Dynamic buttons added via JavaScript -->
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function confirmDelete(userId, userName) {
                if (confirm('Are you sure you want to delete the account with ID: ' + userId + ' - User Name: ' + userName + '?')) {
                    $.ajax({
                        url: 'DeleteAccount',
                        type: 'GET',
                        data: {UserId: userId},
                        success: function () {
                            location.reload();
                        },
                        error: function (xhr, status, error) {
                            alert("Error deleting account: " + error);
                        }
                    });
                }
            }

            function validateCreateForm() {
                let email = $("#UserEmail").val().trim();
                let password = $("#UserPassword").val().trim();
                let name = $("#UserName").val().trim();
                let role = $("#UserRole").val();
                let idCard = $("#IdentityCard").val().trim();
                let address = $("#UserAddress").val().trim();
                let phone = $("#UserPhone").val().trim();

                if (!email || !password || !name || !role || !idCard || !address || !phone) {
                    alert("Please complete all fields.");
                    return false;
                }
                if (!email.endsWith("@gmail.com")) {
                    alert("Email must end with '@gmail.com'.");
                    return false;
                }
                if (!/^\d{12}$/.test(idCard)) {
                    alert("ID card/CCCD number must be exactly 12 digits.");
                    return false;
                }
                return true;
            }

            function validateUpdateDetailForm() {
                let email = $("#DetailUserEmail").val().trim();
                let password = $("#DetailUserPassword").val().trim();
                let name = $("#DetailUserName").val().trim();
                let role = $("#DetailUserRole").val();
                let idCard = $("#DetailIdentityCard").val().trim();
                let address = $("#DetailUserAddress").val().trim();
                let phone = $("#DetailUserPhone").val().trim();

                if (!email || !password || !name || !role || !idCard || !address || !phone) {
                    alert("Please complete all fields.");
                    return false;
                }
                if (!email.endsWith("@gmail.com")) {
                    alert("Email must end with '@gmail.com'.");
                    return false;
                }
                if (!/^\d{12}$/.test(idCard)) {
                    alert("Identity Card must be exactly 12 digits.");
                    return false;
                }
                return true;
            }

            function submitCreateForm(event) {
                event.preventDefault();
                if (!validateCreateForm())
                    return;

                var formData = new FormData($("#createAccountForm")[0]);
                $.ajax({
                    url: "CreateAccount",
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            if (response.action === "closeAndReload") {
                                $("#createEmployeeModal").hide();
                                location.reload();
                            }
                        } else {
                            alert(response.message || "Failed to create account.");
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error creating account: " + error);
                    }
                });
            }

            function submitUpdateDetailForm(event) {
                event.preventDefault();
                if (!validateUpdateDetailForm())
                    return;

                var formData = new FormData($("#updateAccountDetailForm")[0]);
                $.ajax({
                    url: "UpdateAccount",
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            if (response.action === "closeAndReload") {
                                $("#viewAccountDetailModal").hide();
                                location.reload();
                            }
                        } else {
                            alert(response.message || "Failed to update account.");
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error updating account: " + error);
                    }
                });
            }

            function checkImageSelected(mode) {
                if (mode === 'create') {
                    var imageInput = $("#UserImage")[0];
                    var noImageMessage = $("#createNoImageMessage");
                    var currentImage = $("#createCurrentImage");
                    var fileNameDisplay = $("#createFileNameDisplay");

                    if (imageInput.files.length === 0) {
                        fileNameDisplay.text("No file chosen");
                        noImageMessage.show();
                        currentImage.hide();
                    } else {
                        fileNameDisplay.text(imageInput.files[0].name);
                        noImageMessage.hide();
                        currentImage.show();
                        // Display the preview of the selected image
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            currentImage.attr('src', e.target.result);
                        };
                        reader.readAsDataURL(imageInput.files[0]);
                    }
                } else if (mode === 'update') {
                    var imageInput = $("#DetailUserImage")[0];
                    var noImageMessage = $("#noImageMessage");
                    var currentImage = $("#DetailCurrentImage");
                    var fileNameDisplay = $("#updateFileNameDisplay");

                    if (imageInput.files.length === 0) {
                        fileNameDisplay.text("No file chosen");
                        if (currentImage.attr('src') === '') {
                            noImageMessage.show();
                            currentImage.hide();
                        }
                    } else {
                        fileNameDisplay.text(imageInput.files[0].name);
                        noImageMessage.hide();
                        currentImage.show();
                        // Display the preview of the selected image
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            currentImage.attr('src', e.target.result);
                        };
                        reader.readAsDataURL(imageInput.files[0]);
                    }
                }
            }

            $(document).ready(function () {
                var createModal = $("#createEmployeeModal");
                var detailModal = $("#viewAccountDetailModal");
                var createBtn = $(".add-employee-btn");
                var detailButtons = $(".view-detail-btn");

                // Show create modal and reset form
                createBtn.on("click", function () {
                    createModal.show();
                    $("#createAccountForm")[0].reset();
                    $("#createNoImageMessage").show();
                    $("#createCurrentImage").hide().attr('src', ''); // Clear the image preview
                    $("#createFileNameDisplay").text("No file chosen"); // Reset file name display
                    checkImageSelected('create');
                    $("#createCustomFileButton").off("click").on("click", function () {
                        $("#UserImage").click();
                    });
                });

                // Handle create form submission
                $("#createAccountForm").submit(submitCreateForm);

                // Handle detail view and update form
                detailButtons.on("click", function (e) {
                    e.preventDefault();
                    var btn = $(this);
                    var isAdmin = btn.data("userrole").toLowerCase() === "admin";

                    $("#DetailUserIdHidden").val(btn.data("userid"));
                    $("#DetailUserRoleHidden").val(btn.data("userrole"));
                    $("#DetailUserId").val(btn.data("userid"));
                    $("#DetailUserEmail").val(btn.data("useremail"));
                    $("#DetailUserPassword").val(btn.data("userpassword"));
                    $("#DetailUserName").val(btn.data("username"));
                    $("#DetailUserRole").val(btn.data("userrole"));
                    $("#DetailIdentityCard").val(btn.data("identitycard"));
                    $("#DetailUserAddress").val(btn.data("useraddress"));
                    $("#DetailUserPhone").val(btn.data("userphone") || '');
                    $("#DetailCurrentImage").attr("src", btn.data("userimage") || '');
                    $("#DetailOldImagePath").val(btn.data("userimage") || '');

                    $("#DetailUserEmail, #DetailUserPassword, #DetailUserName, #DetailUserRole, #DetailIdentityCard, #DetailUserAddress, #DetailUserPhone, #DetailUserImage")
                            .prop("disabled", isAdmin);

                    var modalActions = $("#modalActions");
                    modalActions.empty();
                    if (isAdmin) {
                        modalActions.append('<button type="button" class="close-button" onclick="$(\'#viewAccountDetailModal\').hide();">Close</button>');
                    } else {
                        modalActions.append('<input type="submit" value="Update">');
                        modalActions.append('<button type="button" class="delete-button" id="deleteAccountBtn">Delete</button>');
                        modalActions.append('<button type="button" class="close-button" onclick="$(\'#viewAccountDetailModal\').hide();">Close</button>');

                        $("#deleteAccountBtn").off("click").on("click", function () {
                            confirmDelete(btn.data("userid"), btn.data("username"));
                        });
                    }

                    detailModal.show();
                    checkImageSelected('update');
                    $("#updateCustomFileButton").off("click").on("click", function () {
                        $("#DetailUserImage").click();
                    });
                });

                // Handle update form submission
                $("#updateAccountDetailForm").submit(submitUpdateDetailForm);

                // Close modal when clicking outside
                $(window).on("click", function (event) {
                    if (event.target == createModal[0])
                        createModal.hide();
                    if (event.target == detailModal[0])
                        detailModal.hide();
                });

                // Search and filter functionality
                $("#searchInput").on("keyup", filterTable);
                $("#roleFilter").on("change", filterTable);

                function filterTable() {
                    const searchText = $("#searchInput").val().toLowerCase();
                    const selectedRole = $("#roleFilter").val();
                    $("table tbody tr").each(function () {
                        const id = $(this).find("td:nth-child(2)").text().toLowerCase();
                        const name = $(this).find("td:nth-child(3)").text().toLowerCase();
                        const email = $(this).find("td:nth-child(4)").text().toLowerCase();
                        const role = $(this).find("td:nth-child(5)").text();

                        let matchesSearch = id.includes(searchText) || name.includes(searchText) || email.includes(searchText);
                        let matchesRole = selectedRole === '' || role === selectedRole;

                        $(this).css("display", (matchesSearch && matchesRole) ? '' : 'none');
                    });
                }
            });
        </script>
    </body>
</html>