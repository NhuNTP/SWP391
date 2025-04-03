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
        <title>Manage Customer - Admin Dashboard</title>
        <!-- Bootstrap 5.3.0 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- SweetAlert2 for enhanced alerts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
            .search-bar input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: 250px;
            }
            .table-responsive {
                overflow-x: auto;
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
            .btn-edit i, .btn-delete i {
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
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
            }
            .sidebar .nav-link {
                font-size: 0.9rem;
            }
            .sidebar h4 {
                font-size: 1.5rem;
            }
            .modal-header{
                background-color: #f7f7f0
            }
            .highlight {
                background-color: yellow !important; /* Thêm !important */
            }
             .table {
            width: 100%;
            margin-bottom: 1rem;
            background-color: #fff;
        }
        .table th,
        .table td {
            padding: 12px;
            vertical-align: middle;
            text-align: left;
        }
        .table thead th {
            background-color: #343a40;
            color: white;
            border-color: #454d55;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f1f1;
        }
        .table-bordered {
            border: 1px solid #dee2e6;
        }
        .table-bordered th,
        .table-bordered td {
            border: 1px solid #dee2e6;
        }
           .text-left.mb-4 {

                overflow: hidden; /* Đảm bảo background và border-radius hoạt động đúng với nội dung bên trong */
                /* Các tùy chỉnh tùy chọn để làm đẹp thêm (có thể bỏ nếu không cần) */
                background: linear-gradient(to right, #2C3E50, #42A5F5);
                padding: 1rem; /* Thêm padding bên trong để tạo khoảng cách, tùy chọn */
                color:white;
                margin-left : -24px !important;
                margin-top: -25px !important;
                margin-right: -25px !important;
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

            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="text-left mb-4">
                        <h4>Customer Management</h4>
                    </div>
                    <div class="container-fluid">
                        <main>
                            <div class="content-header">
                                <div class="search-filter">
                                    <div class="search-bar">
                                        <input type="text" id="searchInput" placeholder="Search">  <!-- Thêm id="searchInput" -->
                                    </div>
                                </div>

                                <div class="header-buttons">
                                    <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addCustomerModal"> <i class="fas fa-plus"></i>Add New</button>
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
                                        <tr id="noResultsRow" style="display: none;">
                                            <td colspan="6" style="text-align: center; color: gray">Customer Not Found.</td>
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
                                            <td><%= displayIndex++%></td>
                                            <td><%= customer.getCustomerId()%></td>
                                            <td><%= customer.getCustomerName()%></td>
                                            <td><%= customer.getCustomerPhone()%></td>
                                            <td><%= customer.getNumberOfPayment()%></td>
                                            <td>
                                                <button type="button" class="btn btn-edit btn-update-customer"
                                                        data-bs-toggle="modal" data-bs-target="#updateCustomerModal"
                                                        data-customer-id="<%= customer.getCustomerId()%>"
                                                        data-customer-name="<%= customer.getCustomerName()%>"
                                                        data-customer-phone="<%= customer.getCustomerPhone()%>"
                                                        data-number-of-payment="<%= customer.getNumberOfPayment()%>">
                                                    <i class="fas fa-edit"></i> Update
                                                </button>
                                                <button type="button" class="btn btn-delete btn-delete-customer"
                                                        data-bs-toggle="modal" data-bs-target="#deleteCustomerModal"
                                                        data-customer-id="<%= customer.getCustomerId()%>">
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
        <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCustomerModalLabel">Add New Customer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addCustomerForm">
                            <div class="mb-3 row">
                                <label for="customerName" class="col-sm-4 col-form-label">Customer Name:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="customerName" name="CustomerName" required>

                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="customerPhone" class="col-sm-4 col-form-label">Customer Phone:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8">
                                    <input type="number" class="form-control" id="customerPhone" name="CustomerPhone" required>
                                    <small class="text-muted">Enter customer phone number.</small>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="numberOfPayment" class="col-sm-4 col-form-label">Number of Payments:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8">
                                    <input type="number" class="form-control" id="numberOfPayment" name="NumberOfPayment" required min="0">
                                    <small class="text-muted">Enter a non-negative number.</small>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnAddCustomer">Add Customer</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Customer Modal -->
        <div class="modal fade" id="updateCustomerModal" tabindex="-1" aria-labelledby="updateCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateCustomerModalLabel">Update Customer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateCustomerForm">
                            <input type="hidden" id="customerIdUpdate" name="customerId">
                            <div class="mb-3 row">
                                <label for="customerIdUpdateDisplay" class="col-sm-4 col-form-label">Customer ID(Just View):</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="customerIdUpdateDisplay" readonly >
                                    <input type="hidden" id="customerIdUpdate" name="customerId">
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="customerNameUpdate" class="col-sm-4 col-form-label">Customer Name:</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="customerNameUpdate" name="CustomerName" required>
                                    <small class="text-muted">Enter customer name.</small>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="customerPhoneUpdate" class="col-sm-4 col-form-label">Customer Phone:</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="customerPhoneUpdate" name="CustomerPhone" required>
                                    <small class="text-muted">Enter customer phone number.</small>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="numberOfPaymentUpdate" class="col-sm-4 col-form-label">Number of Payments:</label>
                                <div class="col-sm-8">
                                    <input type="number" class="form-control" id="numberOfPaymentUpdate" name="NumberOfPayment" required min="0">
                                    <small class="text-muted">Enter a non-negative integer.</small>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnUpdateCustomer">Save change</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Customer Modal -->
        <div class="modal fade" id="deleteCustomerModal" tabindex="-1" aria-labelledby="deleteCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteCustomerModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to DELETE this customer?</p>
                        <input type="hidden" id="customerIdDelete">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteCustomerConfirm">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5.3.0 JS (bao gồm Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
        <script>
            $(document).ready(function () {
                bindEventHandlers(); // Gọi bindEventHandlers ngay từ đầu
                reloadViewCustomer();

                // **Xử lý Thêm Customer**
                $('#btnAddCustomer').click(function () {
                    // **Xóa các thông báo lỗi cũ (nếu có)**
                    $('.error-message').remove();
                    $('.is-invalid').removeClass('is-invalid');

                    var customerNameInput = $('#customerName');
                    var customerPhoneInput = $('#customerPhone');
                    var numberOfPaymentInput = $('#numberOfPayment');

                    var customerName = customerNameInput.val().trim();
                    var customerPhone = customerPhoneInput.val().trim();
                    var numberOfPayment = numberOfPaymentInput.val();

                    var isValid = true;

                    // **Kiểm tra trường Customer Name**
                    if (customerName === '') {
                        isValid = false;
                        displayError('customerName', 'Please input this field');
                    } else if (!/^[a-zA-Z]/.test(customerName)) {
                        isValid = false;
                        displayError('customerName', 'Customer name must start with a letter.');
                    } else if (customerName.length > 50) {
                        isValid = false;
                        displayError('customerName', 'Customer name cannot exceed 50 characters.');
                    }


                    // **Kiểm tra trường Customer Phone**
                    if (customerPhone === '') {
                        isValid = false;
                        displayError('customerPhone', 'Please input this field.');
                    } else if (!customerPhone.startsWith('0')) {
                        isValid = false;
                        displayError('customerPhone', 'Phone number must start with \'0\'.');
                    } else if (!/^\d{10}$/.test(customerPhone)) {
                        isValid = false;
                        displayError('customerPhone', 'Phone number must be exactly 10 digits.');
                    }

                    // **Kiểm tra trường Number of Payments**
                    if (numberOfPayment === '') {
                        isValid = false;
                        displayError('numberOfPayment', 'Please input this field.');
                    } else if (isNaN(numberOfPayment)) {
                        isValid = false;
                        displayError('numberOfPayment', 'Number of Payments must be a number.');
                    } else if (parseInt(numberOfPayment) <= 0) {
                        isValid = false;
                        displayError('numberOfPayment', 'Number of Payments least 1.');
                    }

                    if (isValid) {
                        $.ajax({
                            url: 'AddCustomer', // Your controller URL
                            type: 'POST',
                            data: {
                                CustomerName: customerName,
                                CustomerPhone: customerPhone,
                                NumberOfPayment: numberOfPayment
                            },
                            success: function (response) { // **Success Callback - Handle actual success**
                                var addCustomerModal = bootstrap.Modal.getInstance(document.getElementById('addCustomerModal'));
                                addCustomerModal.hide();
                                reloadViewCustomer();
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success!',
                                    text: 'Customer added successfully.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                $('#addCustomerForm')[0].reset();
                            },
                            error: function (xhr, status, error) { // **Error Callback - Handle all error cases**
                                if (xhr.status === 400) { // **Check for 400 Bad Request (Duplicate Phone)**
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Sorry!',
                                        text: 'Phone number already exists. Please use a different phone number.', // Specific error message for duplicate phone
                                        confirmButtonText: 'OK',
                                        confirmButtonColor: '#dc3545'
                                    });
                                } else { // **Handle other errors (e.g., server errors, database errors)**
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Sorry!',
                                        text: 'Your transaction has failed. Please go back and try again.', // Generic error message
                                        confirmButtonText: 'OK',
                                        confirmButtonColor: '#dc3545'
                                    });
                                }
                            }
                        });
                    }
                });
                function displayError(fieldId, errorMessage) {
                    $('#' + fieldId).addClass('is-invalid'); // Thêm class 'is-invalid' để hiển thị lỗi CSS nếu cần
                    $('#' + fieldId).after('<div class="error-message" style="color: red;">' + errorMessage + '</div>'); // Thêm thông báo lỗi
                }

                $('#btnUpdateCustomer').click(function (event) {
                    // **Handle Customer Update**
                    // **Clear old error messages (if any)**
                    $('.error-message').remove();
                    $('.is-invalid').removeClass('is-invalid');

                    var customerNameInputUpdate = $('#customerNameUpdate');
                    var customerPhoneInputUpdate = $('#customerPhoneUpdate');
                    var numberOfPaymentInputUpdate = $('#numberOfPaymentUpdate');

                    var customerNameUpdate = customerNameInputUpdate.val().trim();
                    var customerPhoneUpdate = customerPhoneInputUpdate.val().trim();
                    var numberOfPaymentUpdate = numberOfPaymentInputUpdate.val();

                    var isValid = true; // Flag to track form validity

                    // **Validate Customer Name Update field**
                    if (customerNameUpdate === '') {
                        isValid = false;
                        displayError('customerNameUpdate', 'Please input this field.');
                    } else if (!/^[a-zA-Z]/.test(customerNameUpdate)) {
                        isValid = false;
                        displayError('customerNameUpdate', 'Customer name must start with a letter.');
                    } else if (customerNameUpdate.length > 50) {
                        isValid = false;
                        displayError('customerNameUpdate', 'Customer name cannot exceed 50 characters.');
                    }

                    // **Validate Customer Phone Update field**
                    if (customerPhoneUpdate === '') {
                        isValid = false;
                        displayError('customerPhoneUpdate', 'Please input this field.');
                    } else if (!customerPhoneUpdate.startsWith('0')) {
                        isValid = false;
                        displayError('customerPhoneUpdate', 'Phone number must start with \'0\'.');
                    } else if (!/^\d{10}$/.test(customerPhoneUpdate)) {
                        isValid = false;
                        displayError('customerPhoneUpdate', 'Phone number must be exactly 10 digits.');
                    }

                    // **Validate Number of Payments Update field**
                    if (numberOfPaymentUpdate === '') {
                        isValid = false;
                        displayError('numberOfPaymentUpdate', 'Please input this field.');
                    } else if (isNaN(numberOfPaymentUpdate)) {
                        isValid = false;
                        displayError('numberOfPaymentUpdate', 'Number of Payments must be a number.');
                    } else if (parseInt(numberOfPaymentUpdate) < 0) {
                        isValid = false;
                        displayError('numberOfPaymentUpdate', 'Number of Payments cannot be negative.');
                    }

                    if (isValid) { // Prevent form submission if invalid
                        var customerId = $('#customerIdUpdate').val();
                        var customerName = $('#customerNameUpdate').val();
                        var customerPhone = $('#customerPhoneUpdate').val();
                        var numberOfPayment = $('#numberOfPaymentUpdate').val();

                        $.ajax({
                            url: 'UpdateCustomer', // Your controller URL for UpdateCustomer
                            type: 'POST',
                            data: {
                                customerId: customerId,
                                CustomerName: customerName,
                                CustomerPhone: customerPhone,
                                NumberOfPayment: numberOfPayment
                            },
                            success: function (response) { // **Success Callback - Handle actual success**
                                var updateCustomerModal = bootstrap.Modal.getInstance(document.getElementById('updateCustomerModal')); // Correct modal ID
                                updateCustomerModal.hide();
                                reloadViewCustomer();
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success!',
                                    text: 'Customer updated successfully.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            },
                            error: function (xhr, status, error) { // **Error Callback - Handle all error cases**
                                if (xhr.status === 400) { // **Check for 400 Bad Request (Duplicate Phone)**
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Sorry!',
                                        text: 'Phone number already exists. Please use a different phone number.', // Specific error message for duplicate phone
                                        confirmButtonText: 'OK',
                                        confirmButtonColor: '#dc3545'
                                    });
                                } else { // **Handle other errors (e.g., server errors, database errors)**
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Sorry!',
                                        text: 'Update error. Your transaction has failed. Please go back and try again.', // Generic error message - More informative for update
                                        confirmButtonText: 'OK',
                                        confirmButtonColor: '#dc3545'
                                    });
                                }
                            }
                        });
                    }
                });
                function displayError(fieldId, errorMessage) {
                    $('#' + fieldId).addClass('is-invalid'); // Add 'is-invalid' class to display CSS error if needed
                    $('#' + fieldId).after('<div class="error-message" style="color: red;">' + errorMessage + '</div>'); // Add error message
                }
                // **Xử lý Xóa Customer**
                $('#btnDeleteCustomerConfirm').click(function () {
                    var customerId = $('#customerIdDelete').val();
                    $.ajax({
                        url: 'DeleteCustomer', // Thay đổi URL controller cho Customer
                        type: 'GET',
                        data: {
                            customerId: customerId
                        },
                        success: function (response) {
                            var deleteCustomerModal = bootstrap.Modal.getInstance(document.getElementById('deleteCustomerModal'));
                            deleteCustomerModal.hide();

                            // Xóa dòng vừa xóa
                            $('#customerRow' + customerId).remove();

                            // Kiểm tra xem còn customer nào không sau khi xóa
                            if ($('#customerTableBody tr').length === 0) {
                                $('#customerTableBody').html('<tr><td colspan="6"><div class="no-data">No Customer.</div></td></tr>');
                            }
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Customer deleted successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error deleting customer: ' + error
                            });
                        }
                    });
                });


                function bindEventHandlers() {
                    $(document).on('click', '.btn-update-customer', function () {
                        var customerId = $(this).data('customer-id');
                        var customerName = $(this).data('customer-name');
                        var customerPhone = $(this).data('customer-phone');
                        var numberOfPayment = $(this).data('number-of-payment');

                        $('#customerIdUpdate').val(customerId);
                        $('#customerIdUpdateDisplay').val(customerId); // Display Customer ID in update modal
                        $('#customerNameUpdate').val(customerName);
                        $('#customerPhoneUpdate').val(customerPhone);
                        $('#numberOfPaymentUpdate').val(numberOfPayment);
                    });

                    $(document).on('click', '.btn-delete-customer', function () {
                        var customerId = $(this).data('customer-id');
                        $('#customerIdDelete').val(customerId);
                    });
                }
                function reloadViewCustomer() {
                    $.get('ViewCustomerList', function (data) { // Thay đổi URL controller cho Customer
                        var newBody = $(data).find('tbody').html();
                        $('tbody').html(newBody);
                        bindEventHandlers(); // Re-bind sau khi reload
                    });
                }


                // ******************* BẮT ĐẦU ĐOẠN CODE THÊM VÀO CHO TÌM KIẾM *******************

                // ******************* KẾT THÚC ĐOẠN CODE THÊM VÀO CHO TÌM KIẾM *******************
                const searchInput = document.getElementById('searchInput');
                const table = document.querySelector('.table');

                const noResultsRow = document.getElementById('noResultsRow'); // Lấy hàng "Không tìm thấy kết quả"

                function searchCustomerColumn() {
                    const searchText = searchInput.value.trim().toLowerCase();
                    let foundMatch = false;
                    noResultsRow.style.display = 'none';
                    const rows = table.querySelectorAll('tbody tr:not(#noResultsRow)');

                    if (searchText.trim() === "") { // Xử lý trường hợp ô tìm kiếm trống
                        rows.forEach(row => {
                            row.style.display = ''; // Hiển thị lại tất cả các hàng
                            // **Thêm đoạn code này để reset highlight khi ô tìm kiếm trống:**
                            const customerNameColumn = row.querySelector('td:nth-child(3)');
                            const customerPhoneColumn = row.querySelector('td:nth-child(4)');
                            const customerIdColumn = row.querySelector('td:nth-child(2)');

                            if (customerNameColumn) {
                                customerNameColumn.innerHTML = customerNameColumn.textContent; // Reset về text gốc
                            }
                            if (customerPhoneColumn) {
                                customerPhoneColumn.innerHTML = customerPhoneColumn.textContent; // Reset về text gốc
                            }
                            if (customerIdColumn) {
                                customerIdColumn.innerHTML = customerIdColumn.textContent; // Reset về text gốc
                            }
                        });
                        return; // Kết thúc hàm sớm
                    }


                    rows.forEach(row => {
                        const customerNameColumn = row.querySelector('td:nth-child(3)');
                        const customerPhoneColumn = row.querySelector('td:nth-child(4)');
                        const customerIdColumn = row.querySelector('td:nth-child(2)');

                        let rowMatch = false;

                        if (customerNameColumn) {
                            const originalNameText = customerNameColumn.textContent;
                            const customerNameText = originalNameText.toLowerCase();
                            customerNameColumn.innerHTML = originalNameText; // Reset highlight trước khi tìm kiếm lại

                            if (customerNameText.includes(searchText)) {
                                customerNameColumn.innerHTML = highlightSearchText(originalNameText, searchText);
                                rowMatch = true;
                            }
                        }
                        if (customerPhoneColumn) {
                            const originalPhoneText = customerPhoneColumn.textContent;
                            const customerPhoneText = originalPhoneText.toLowerCase();
                            customerPhoneColumn.innerHTML = originalPhoneText; // Reset highlight trước khi tìm kiếm lại

                            if (customerPhoneText.includes(searchText)) {
                                customerPhoneColumn.innerHTML = highlightSearchText(originalPhoneText, searchText);
                                rowMatch = true;
                            }
                        }
                        if (customerIdColumn) {
                            const originalIdText = customerIdColumn.textContent;
                            const customerIdText = originalIdText.toLowerCase();
                            customerIdColumn.innerHTML = originalIdText; // Reset highlight trước khi tìm kiếm lại

                            if (customerIdText.includes(searchText)) {
                                customerIdColumn.innerHTML = highlightSearchText(originalIdText, searchText);
                                rowMatch = true;
                            }
                        }


                        if (rowMatch) {
                            row.style.display = '';
                            foundMatch = true;
                        } else {
                            row.style.display = 'none';
                        }
                    });

                    if (!foundMatch && searchText.trim() !== "") {
                        noResultsRow.style.display = '';
                    }
                }
                function highlightSearchText(originalText, searchText) {
                    let highlightedText = "";
                    let currentIndex = 0;
                    let searchIndex = originalText.toLowerCase().indexOf(searchText, currentIndex);

                    while (searchIndex !== -1) {
                        highlightedText += originalText.slice(currentIndex, searchIndex);
                        highlightedText += '<span class="highlight">' + originalText.slice(searchIndex, searchIndex + searchText.length) + '</span>';
                        currentIndex = searchIndex + searchText.length;
                        searchIndex = originalText.toLowerCase().indexOf(searchText, currentIndex);
                    }
                    highlightedText += originalText.slice(currentIndex);
                    return highlightedText;
                }


                searchInput.addEventListener('keyup', searchCustomerColumn);
            });
        </script>
    </body>
</html>