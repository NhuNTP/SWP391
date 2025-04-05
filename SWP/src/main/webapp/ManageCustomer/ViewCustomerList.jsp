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
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
        .sidebar { background: linear-gradient(to bottom, #2C3E50, #34495E); color: white; height: 100vh; }
        .sidebar a { color: white; text-decoration: none; }
        .sidebar a:hover { background-color: #1A252F; }
        .main-content-area { padding: 20px; }
        .content-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .content-header h2 { margin-top: 0; font-size: 24px; }
        .search-bar input { padding: 8px 12px; border: 1px solid #ccc; border-radius: 3px; width: 250px; }
        .table-responsive { overflow-x: auto; }
        .btn-edit, .btn-delete { padding: 5px 10px; border-radius: 5px; color: white; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-edit { background-color: #007bff; }
        .btn-edit:hover { background-color: #0056b3; }
        .btn-delete { background-color: #dc3545; margin-left: 5px; }
        .btn-delete:hover { background-color: #c82333; }
        .btn-edit i, .btn-delete i { margin-right: 5px; }
        .header-buttons .btn-info { background-color: #007bff; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; }
        .header-buttons .btn-info:hover { background-color: #0056b3; }
        .no-data { padding: 20px; text-align: center; color: #777; }
        .sidebar .nav-link { font-size: 0.9rem; }
        .sidebar h4 { font-size: 1.5rem; }
        .modal-header { background-color: #f7f7f0; }
        .highlight { background-color: yellow !important; }
        .table { width: 100%; margin-bottom: 1rem; background-color: #fff; }
        .table th, .table td { padding: 12px; vertical-align: middle; text-align: left; }
        .table thead th { background-color: #343a40; color: white; border-color: #454d55; }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
        .table-bordered { border: 1px solid #dee2e6; }
        .table-bordered th, .table-bordered td { border: 1px solid #dee2e6; }
        .text-left.mb-4 { overflow: hidden; background: linear-gradient(to right, #2C3E50, #42A5F5); padding: 1rem; color: white; margin-left: -24px !important; margin-top: -25px !important; margin-right: -25px !important; }
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
                                    <input type="text" id="searchInput" placeholder="Search">
                                </div>
                            </div>
                            <div class="header-buttons">
                                <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addCustomerModal"><i class="fas fa-plus"></i> Add New</button>
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
                                        <td colspan="6"><div class="no-data">Customer Not Found.</div></td>
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
                            <label for="customerName" class="col-sm-4 col-form-label">Customer Name:</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="customerName" name="CustomerName" required>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="customerPhone" class="col-sm-4 col-form-label">Customer Phone:</label>
                            <div class="col-sm-8">
                                <input type="number" class="form-control" id="customerPhone" name="CustomerPhone" required>
                                <small class="text-muted">Enter customer phone number.</small>
                            </div>
                        </div>
                        <input type="hidden" id="numberOfPayment" name="NumberOfPayment" value="0">
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
                            <label for="customerIdUpdateDisplay" class="col-sm-4 col-form-label">Customer ID (Just View):</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="customerIdUpdateDisplay" readonly>
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

    <!-- Bootstrap 5.3.0 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>

    <script>
    $(document).ready(function () {
        bindEventHandlers();
        reloadViewCustomer();

        // Xử lý Thêm Customer
        $('#btnAddCustomer').click(function () {
            $('.error-message').remove();
            $('.is-invalid').removeClass('is-invalid');

            var customerName = $('#customerName').val().trim();
            var customerPhone = $('#customerPhone').val().trim();
            var numberOfPayment = $('#numberOfPayment').val();

            var isValid = true;

            // Validation cho Customer Name
            if (customerName === '') {
                isValid = false;
                displayError('customerName', 'Please input this field');
            }

            // Validation cho Customer Phone
            if (customerPhone === '') {
                isValid = false;
                displayError('customerPhone', 'Please input this field');
            } else if (!customerPhone.startsWith('0')) {
                isValid = false;
                displayError('customerPhone', 'Phone number must start with 0');
            } else if (!/^\d{10}$/.test(customerPhone)) {
                isValid = false;
                displayError('customerPhone', 'Phone number must be exactly 10 digits, no special characters');
            }

            if (isValid) {
                $.ajax({
                    url: 'AddCustomer',
                    type: 'POST',
                    data: {
                        CustomerName: customerName,
                        CustomerPhone: customerPhone,
                        NumberOfPayment: numberOfPayment
                    },
                    success: function (response) {
                        $('#addCustomerModal').modal('hide');
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
                    error: function (xhr) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: xhr.responseText || 'Error adding customer.',
                            confirmButtonColor: '#dc3545'
                        });
                    }
                });
            }
        });

        // Xử lý Cập nhật Customer (giữ nguyên validation cũ, có thể thêm validation tương tự nếu cần)
        $('#btnUpdateCustomer').click(function () {
            $('.error-message').remove();
            $('.is-invalid').removeClass('is-invalid');

            var customerId = $('#customerIdUpdate').val();
            var customerName = $('#customerNameUpdate').val().trim();
            var customerPhone = $('#customerPhoneUpdate').val().trim();

            var isValid = true;
            if (customerName === '') {
                isValid = false;
                displayError('customerNameUpdate', 'Please input this field');
            }
            if (customerPhone === '') {
                isValid = false;
                displayError('customerPhoneUpdate', 'Please input this field');
            } else if (!customerPhone.startsWith('0')) {
                isValid = false;
                displayError('customerPhoneUpdate', 'Phone number must start with 0');
            } else if (!/^\d{10}$/.test(customerPhone)) {
                isValid = false;
                displayError('customerPhoneUpdate', 'Phone number must be exactly 10 digits, no special characters');
            }

            if (isValid) {
                $.ajax({
                    url: 'UpdateCustomer',
                    type: 'POST',
                    data: {
                        customerId: customerId,
                        CustomerName: customerName,
                        CustomerPhone: customerPhone
                    },
                    success: function (response) {
                        $('#updateCustomerModal').modal('hide');
                        reloadViewCustomer();
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: 'Customer updated successfully.',
                            timer: 2000,
                            showConfirmButton: false
                        });
                    },
                    error: function (xhr) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: xhr.responseText || 'Error updating customer.',
                            confirmButtonColor: '#dc3545'
                        });
                    }
                });
            }
        });

        // Xử lý Xóa Customer (giữ nguyên)
        $('#btnDeleteCustomerConfirm').on('click', function () {
            var customerId = $('#customerIdDelete').val();
            $.ajax({
                url: 'DeleteCustomer',
                type: 'GET',
                data: { customerId: customerId },
                success: function (response) {
                    $('#deleteCustomerModal').modal('hide');
                    $('#customerRow' + customerId).remove();
                    if ($('#customerTableBody tr').length === 0) {
                        $('#customerTableBody').html('<tr><td colspan="6"><div class="no-data">No Customer.</div></td></tr>');
                    }
                    reloadViewCustomer();
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'Customer deleted successfully.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                },
                error: function (xhr) {
                    $('#deleteCustomerModal').modal('hide');
                    var errorMessage = xhr.responseText || 'An unknown error occurred.';
                    if (xhr.status === 409) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Cannot Delete!',
                            text: 'This customer has associated orders and cannot be deleted.',
                            confirmButtonColor: '#dc3545'
                        });
                    } else if (xhr.status === 404) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Not Found!',
                            text: 'Customer not found.',
                            confirmButtonColor: '#dc3545'
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: 'Error deleting customer: ' + errorMessage,
                            confirmButtonColor: '#dc3545'
                        });
                    }
                }
            });
        });

        // Hàm hiển thị lỗi
        function displayError(fieldId, message) {
            $('#' + fieldId).addClass('is-invalid');
            $('#' + fieldId).after('<div class="error-message" style="color: red;">' + message + '</div>');
        }

        // Gắn sự kiện cho các nút Update và Delete
        function bindEventHandlers() {
            $('.btn-update-customer').off('click').on('click', function () {
                var customerId = $(this).data('customer-id');
                var customerName = $(this).data('customer-name');
                var customerPhone = $(this).data('customer-phone');
                var numberOfPayment = $(this).data('number-of-payment');

                $('#customerIdUpdate').val(customerId);
                $('#customerIdUpdateDisplay').val(customerId);
                $('#customerNameUpdate').val(customerName);
                $('#customerPhoneUpdate').val(customerPhone);
            });

            $('.btn-delete-customer').off('click').on('click', function () {
                var customerId = $(this).data('customer-id');
                $('#customerIdDelete').val(customerId);
            });
        }

        // Tải lại danh sách khách hàng
        function reloadViewCustomer() {
            $.ajax({
                url: 'ViewCustomerList',
                type: 'GET',
                cache: false,
                success: function (data) {
                    var newBody = $(data).find('#customerTableBody').html();
                    $('#customerTableBody').html(newBody);
                    bindEventHandlers();
                },
                error: function (xhr) {
                    console.error('Error reloading customer list:', xhr.responseText);
                }
            });
        }

        // Tìm kiếm khách hàng
        $('#searchInput').on('keyup', function () {
            var searchText = $(this).val().trim().toLowerCase();
            var $rows = $('#customerTableBody tr:not(#noResultsRow)');
            var foundMatch = false;

            $rows.each(function () {
                var customerId = $(this).find('td:nth-child(2)').text().toLowerCase();
                var customerName = $(this).find('td:nth-child(3)').text().toLowerCase();
                var customerPhone = $(this).find('td:nth-child(4)').text().toLowerCase();

                if (customerId.includes(searchText) || customerName.includes(searchText) || customerPhone.includes(searchText)) {
                    $(this).show();
                    foundMatch = true;
                } else {
                    $(this).hide();
                }
            });

            $('#noResultsRow').toggle(!foundMatch && searchText !== '');
        });
    });
</script>
</body>
</html>