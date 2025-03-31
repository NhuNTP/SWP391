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

    String successMessage = (String) session.getAttribute("message");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (successMessage != null) {
        session.removeAttribute("message");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }
        .notification {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            display: none;
            position: relative;
        }
        .notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
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
        <% if (successMessage != null) { %>
        <div id="successNotification" class="notification">
            <%= successMessage %>
        </div>
        <% } %>
        <% if (errorMessage != null) { %>
        <div id="errorNotification" class="notification error">
            <%= errorMessage %>
        </div>
        <% } %>

        <section class="main-content">
            <div class="text-left mb-4">
                <h4>Customer Management</h4>
            </div>
            <div class="container-fluid">
                <main>
                    <div class="content-header">
                        <div class="search-bar">
                            <input type="text" class="form-control" placeholder="Search" id="searchInput" onkeyup="filterTable()">
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
                                <td><%= displayIndex++ %></td>
                                <td><%= customer.getCustomerId() %></td>
                                <td><%= customer.getCustomerName() %></td>
                                <td><%= customer.getCustomerPhone() %></td>
                                <td><%= customer.getNumberOfPayment() %></td>
                                <td>
                                    <button type="button" class="btn btn-edit"
                                            data-customer-id="<%= customer.getCustomerId() %>"
                                            data-customer-name="<%= customer.getCustomerName() %>"
                                            data-customer-phone="<%= customer.getCustomerPhone() %>"
                                            data-number-of-payment="<%= customer.getNumberOfPayment() %>"
                                            onclick="openEditModal(this)">
                                        <i class="fas fa-edit"></i> Update
                                    </button>
                                    <button type="button" class="btn btn-delete"
                                            onclick="confirmDelete('<%= customer.getCustomerId() %>')">
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
                                    <div class="no-data">Customer Not Found.</div>
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

<div id="addCustomerModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Customer</h5>
                <button type="button" class="btn-close" onclick="closeModal('addCustomerModal')" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addCustomerForm" action="${pageContext.request.contextPath}/AddCustomer" method="POST">
                    <div class="mb-3">
                        <label for="customerName" class="form-label">Customer Name:</label>
                        <input type="text" class="form-control" id="customerName" name="CustomerName">
                        <span id="customerNameError" class="text-danger"></span>
                    </div>
                    <div class="mb-3">
                        <label for="customerPhone" class="form-label">Customer Phone:</label>
                        <input type="text" class="form-control" id="customerPhone" name="CustomerPhone">
                        <span id="customerPhoneError" class="text-danger"></span>
                    </div>
                    <div class="mb-3">
                        <label for="numberOfPayment" class="form-label">Number of Payments:</label>
                        <input type="number" class="form-control" id="numberOfPayment" name="NumberOfPayment">
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

<div id="updateCustomerModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Customer</h5>
                <button type="button" class="btn-close" onclick="closeModal('updateCustomerModal')" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateCustomerForm" action="${pageContext.request.contextPath}/UpdateCustomer" method="POST">
                    <input type="hidden" id="customerIdUpdate" name="customerId">
                    <div class="mb-3">
                        <label for="customerNameUpdate" class="form-label">Customer Name:</label>
                        <input type="text" class="form-control" id="customerNameUpdate" name="CustomerName">
                        <span id="customerNameUpdateError" class="text-danger"></span>
                    </div>
                    <div class="mb-3">
                        <label for="customerPhoneUpdate" class="form-label">Customer Phone:</label>
                        <input type="text" class="form-control" id="customerPhoneUpdate" name="CustomerPhone">
                        <span id="customerPhoneUpdateError" class="text-danger"></span>
                    </div>
                    <div class="mb-3">
                        <label for="numberOfPaymentUpdate" class="form-label">Number of Payments:</label>
                        <input type="number" class="form-control" id="numberOfPaymentUpdate" name="NumberOfPayment">
                        <span id="numberOfPaymentUpdateError" class="text-danger"></span>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('updateCustomerModal')">Cancel</button>
                        <button type="submit" class="btn btn-primary" id="btnUpdateCustomer">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        var successNotification = $("#successNotification");
        var errorNotification = $("#errorNotification");

        if (successNotification.length) {
            successNotification.show();
            setTimeout(function () {
                successNotification.fadeOut(500);
            }, 3000);
        }

        if (errorNotification.length) {
            errorNotification.show();
            setTimeout(function () {
                errorNotification.fadeOut(500);
            }, 3000);
        }
    });

    function confirmDelete(customerId) {
        Swal.fire({
            title: 'Are you sure?',
            text: `Do you want to delete customer ID: ${customerId}?`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/DeleteCustomer?customerId=' + customerId;
            }
        });
    }

    function openModal(modalId) {
        document.getElementById(modalId).style.display = "block";
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
        if (modalId === 'addCustomerModal') {
            $("#customerNameError, #customerPhoneError, #numberOfPaymentError").text("");
        } else if (modalId === 'updateCustomerModal') {
            $("#customerNameUpdateError, #customerPhoneUpdateError, #numberOfPaymentUpdateError").text("");
        }
    }

    function openEditModal(button) {
        document.getElementById("customerIdUpdate").value = button.dataset.customerId;
        document.getElementById("customerNameUpdate").value = button.dataset.customerName;
        document.getElementById("customerPhoneUpdate").value = button.dataset.customerPhone;
        document.getElementById("numberOfPaymentUpdate").value = button.dataset.numberOfPayment;
        openModal("updateCustomerModal");
    }

    function filterTable() {
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const table = document.querySelector('.table-responsive table tbody');
        const rows = table.querySelectorAll('tr');
        let hasResults = false;

        rows.forEach(row => {
            const id = row.querySelector('td:nth-child(2)')?.textContent.toLowerCase();
            const customerName = row.querySelector('td:nth-child(3)')?.textContent.toLowerCase();
            const customerPhone = row.querySelector('td:nth-child(4)')?.textContent.toLowerCase();
            const numberOfPayment = row.querySelector('td:nth-child(5)')?.textContent.toLowerCase();

            if (searchText === "") {
                row.style.display = '';
                hasResults = true;
            } else if (id && customerName && customerPhone && numberOfPayment) {
                let matchesSearch = id.includes(searchText) || customerName.includes(searchText) ||
                    customerPhone.includes(searchText) || numberOfPayment.includes(searchText);
                row.style.display = matchesSearch ? '' : 'none';
                if (matchesSearch) hasResults = true;
            }
        });

        const noDataRow = document.querySelector('.no-data-row');
        if (noDataRow) noDataRow.remove();

        if (!hasResults && searchText !== "") {
            const newRow = document.createElement('tr');
            newRow.classList.add('no-data-row');
            newRow.innerHTML = '<td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i> No matching customers found.</td>';
            table.appendChild(newRow);
        }
    }
</script>
</body>
</html>