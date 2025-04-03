<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.AccountDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Account List - Admin Dashboard</title>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- SweetAlert2 -->
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

            .sidebar .nav-link {
                font-size: 0.9rem;
            }

            .sidebar h4 {
                font-size: 1.5rem;
            }

            .main-content-area {
                padding: 20px;
            }

            .content-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                flex-wrap: nowrap;
            }

            .search-filter {
                display: flex;
                align-items: center;
                gap: 10px;
            }

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
                width: 150px;
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

            .table-responsive {
                overflow-x: auto;
            }

            .table {
                width: 100%;
                margin-bottom: 1rem;
                background-color: #fff; /* Solid white background for the table */
            }

            .table thead th {
                background-color: #343a40;
                color: white;
                border-color: #454d55;
            }

            .table-hover tbody tr:hover {
                background-color: #f1f1f1;
            }

            /* Fix the width of the Actions column to fit the two buttons */
            .table th.actions-column,
            .table td.actions-column {
                width: 150px; /* Adjust this value as needed to fit the two buttons */
                white-space: nowrap;
            }

            .btn-warning {
                background-color: #ffca28;
                border-color: #ffca28;
                color: white;
                transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .btn-warning:hover {
                background-color: #ffda6a;
                border-color: #ffda6a;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .btn-danger {
                background-color: #f44336;
                border-color: #f44336;
                color: white;
                transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .btn-danger:hover {
                background-color: #e53935;
                border-color: #e53935;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                color: black;
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

            .modal-header {
                background-color: #f7f7f0;
            }

            .modal-form-container input[type="text"],
            .modal-form-container input[type="email"],
            .modal-form-container input[type="password"],
            .modal-form-container input[type="number"],
            .modal-form-container select,
            .modal-form-container input[type="file"] {
                width: calc(100% - 22px);
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }

            .text-left.mb-4 {
                overflow: hidden;
                background: linear-gradient(to right, #2C3E50, #42A5F5);
                padding: 1rem;
                color: white;
                margin-left: -24px !important;
                margin-top: -25px !important;
                margin-right: -25px !important;
            }

            .rounded-image {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
            }

            /* Bootstrap-like error styling */
            .is-invalid {
                border-color: #dc3545 !important;
                padding-right: calc(1.5em + 0.75rem);
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right calc(0.375em + 0.1875rem) center;
                background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
            }

            .invalid-feedback {
                display: none;
                width: 100%;
                margin-top: 0.25rem;
                font-size: 0.875em;
                color: #dc3545;
            }

            .is-invalid ~ .invalid-feedback {
                display: block;
            }


            .pagination {
                display: flex;
                justify-content: center; /* Căn giữa các nút pagination */
                list-style: none;
                padding: 0;
                margin-top: 30px;
            }

            .pagination li {
                margin: 0 3px;
            }

            .pagination a, .pagination span {
                padding: 6px 12px;
                border: 1px solid #dee2e6;
                text-decoration: none;
                color: #0d6efd;
                background-color: #fff;
                border-radius: .25rem;
                transition: background-color 0.2s ease, color 0.2s ease;
                font-size: 0.9rem;
            }

            .pagination a:hover {
                background-color: #e9ecef;
                color: #0a58ca;
            }

            .pagination a.active {
                background-color: #0d6efd;
                color: white;
                border-color: #0d6efd;
                font-weight: bold;
            }

            .pagination .disabled span {
                color: #6c757d;
                pointer-events: none;
                background-color: #e9ecef;
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
            <div class="col-md-10 p-4 main-content-area">
                <div class="text-left mb-4">
                    <h4>Employee Management</h4>
                </div>
                <div class="container-fluid">
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
                            <button class="btn btn-info add-employee-btn" data-bs-toggle="modal" data-bs-target="#createEmployeeModal"><i class="fas fa-plus"></i> Create</button>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <!-- Removed table-striped class to remove alternating gray rows -->
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>User ID</th>
                                    <th>User Name</th>
                                    <th>User Email</th>
                                    <th>User Role</th>
                                    <th class="actions-column">Actions</th> <!-- Added class for Actions column -->
                                </tr>
                            </thead>
                            <tbody id="accountTableBody">
                                <%
                                    List<Account> accounts = (List<Account>) request.getAttribute("accountList");
                                    int pageSize = 10;
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
                                        for (Account acc : paginatedAccounts) {
                                %>
                                <tr id="accountRow<%= acc.getUserId()%>">
                                    <td><%= counter++%></td>
                                    <td><%= acc.getUserId()%></td>
                                    <td><%= acc.getUserName()%></td>
                                    <td><%= acc.getUserEmail()%></td>
                                    <td><%= acc.getUserRole()%></td>
                                    <td class="actions-column">
                                        <a href="#" class="btn-edit view-detail-btn"
                                           data-userid="<%= acc.getUserId()%>"
                                           data-useremail="<%= acc.getUserEmail()%>"
                                           data-userpassword="<%= acc.getUserPassword()%>"
                                           data-username="<%= acc.getUserName()%>"
                                           data-userrole="<%= acc.getUserRole()%>"
                                           data-identitycard="<%= acc.getIdentityCard()%>"
                                           data-useraddress="<%= acc.getUserAddress()%>"
                                           data-userphone="<%= acc.getUserPhone()%>"
                                           data-userimage="<%= acc.getUserImage()%>"><i class="fas fa-eye"></i> View</a>
                                        <% if (!acc.getUserRole().equalsIgnoreCase("Admin")) {%>
                                        <a href="#" class="btn-delete btn-delete-account"
                                           data-bs-toggle="modal" data-bs-target="#deleteAccountModal"
                                           data-account-id="<%= acc.getUserId()%>"
                                           data-account-name="<%= acc.getUserName()%>"><i class="fas fa-trash-alt"></i> Delete</a>
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
                    <% if (totalPages > 1) {%>
                    <nav aria-label="Account navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item <%= (currentPage <= 1) ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage - 1%>" aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                            <% int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                if (startPage > 1) {
                                    out.println("<li class='page-item'><a class='page-link' href='?page=1'>1</a></li>");
                                    if (startPage > 2) {
                                        out.println("<li class='page-item disabled'><span class='page-link'>...</span></li>");
                                    }
                                }
                                for (int i = startPage; i <= endPage; i++) {%>
                            <li class="page-item <%= (currentPage == i) ? "active" : ""%>">
                                <a class="page-link" href="?page=<%= i%>"><%= i%></a>
                            </li>
                            <% }
                                if (endPage < totalPages) {
                                    if (endPage < totalPages - 1) {
                                        out.println("<li class='page-item disabled'><span class='page-link'>...</span></li>");
                                    }
                                    out.println("<li class='page-item'><a class='page-link' href='?page=" + totalPages + "'>" + totalPages + "</a></li>");
                                }%>
                            <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage + 1%>" aria-label="Next">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    <% }%>
                </div>
            </div>
        </div>

        <!-- Modal Create Employee Account -->
        <div class="modal fade" id="createEmployeeModal" tabindex="-1" aria-labelledby="createEmployeeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createEmployeeModalLabel">Create New Employee Account</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-form-container">
                            <form id="createAccountForm" enctype="multipart/form-data" novalidate>
                                <div class="mb-3">
                                    <label for="UserEmail" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="UserEmail" name="UserEmail" placeholder="Enter email">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserPassword" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="UserPassword" name="UserPassword" placeholder="Enter password">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="UserName" name="UserName" placeholder="Enter full name">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserRole" class="form-label">Role</label>
                                    <select class="form-control" id="UserRole" name="UserRole">
                                        <option value="">Select Role</option>
                                        <option value="Manager">Manager</option>
                                        <option value="Cashier">Cashier</option>
                                        <option value="Waiter">Waiter</option>
                                        <option value="Kitchen staff">Kitchen staff</option>
                                    </select>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="IdentityCard" class="form-label">Identity Card (12 digits)</label>
                                    <input type="text" class="form-control" id="IdentityCard" name="IdentityCard" placeholder="Enter 12-digit ID card number" maxlength="12" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12)">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserAddress" class="form-label">Address</label>
                                    <input type="text" class="form-control" id="UserAddress" name="UserAddress" placeholder="Enter address">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserPhone" class="form-label">Phone (10 digits, starts with 0)</label>
                                    <input type="text" class="form-control" id="UserPhone" name="UserPhone" placeholder="Enter 10-digit phone (e.g., 0123456789)" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10)">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="UserImage" class="form-label">Profile Image</label>
                                    <img id="createCurrentImage" src="" alt="Profile Image" class="rounded-image" style="display:none;">
                                    <p id="createNoImageMessage" style="color: gray;">No image selected</p>
                                    <div class="custom-file-upload">
                                        <input type="file" id="UserImage" name="UserImage" onchange="checkImageSelected('create')" accept="image/*" style="display: none;">
                                        <button type="button" id="createCustomFileButton" class="btn btn-secondary">Choose File</button>
                                        <span id="createFileNameDisplay">No file chosen</span>
                                    </div>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <input type="submit" class="btn btn-primary" value="Create">
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal View Account Detail -->
        <div class="modal fade" id="viewAccountDetailModal" tabindex="-1" aria-labelledby="viewAccountDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detailModalHeading">Account Detail</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-form-container">
                            <form id="updateAccountDetailForm" enctype="multipart/form-data" novalidate>
                                <input type="hidden" id="DetailUserIdHidden" name="UserIdHidden">
                                <input type="hidden" id="DetailUserRoleHidden" name="UserRoleHidden">
                                <div class="mb-3">
                                    <label class="form-label">Current Image</label>
                                    <img id="DetailCurrentImage" src="" alt="Current Image" class="rounded-image">
                                    <p id="noImageMessage" style="display:none; color: gray;">No image selected</p>
                                </div>
                                <div id="imageUpdateSection" style="display:none;" class="mb-3">
                                    <label for="DetailUserImage" class="form-label">Update Image</label>
                                    <div class="custom-file-upload">
                                        <input type="file" id="DetailUserImage" name="UserImage" onchange="checkImageSelected('update')" accept="image/*" style="display: none;">
                                        <button type="button" id="updateCustomFileButton" class="btn btn-secondary">Choose File</button>
                                        <span id="updateFileNameDisplay">No file chosen</span>
                                    </div>
                                    <input type="hidden" name="oldImagePath" id="DetailOldImagePath">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserId" class="form-label">User ID</label>
                                    <input type="text" class="form-control" id="DetailUserId" name="UserId" readonly>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserEmail" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="DetailUserEmail" name="UserEmail" readonly>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserPassword" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="DetailUserPassword" name="UserPassword" readonly>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="DetailUserName" name="UserName" readonly>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserRole" class="form-label">Role</label>
                                    <select class="form-control" id="DetailUserRole" name="UserRole" disabled>
                                        <option value="">Select Role</option>
                                        <option value="Manager">Manager</option>
                                        <option value="Cashier">Cashier</option>
                                        <option value="Waiter">Waiter</option>
                                        <option value="Kitchen staff">Kitchen staff</option>
                                    </select>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailIdentityCard" class="form-label">Identity Card (12 digits)</label>
                                    <input type="text" class="form-control" id="DetailIdentityCard" name="IdentityCard" readonly maxlength="12" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12)">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserAddress" class="form-label">Address</label>
                                    <input type="text" class="form-control" id="DetailUserAddress" name="UserAddress" readonly>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="DetailUserPhone" class="form-label">Phone (10 digits, starts with 0)</label>
                                    <input type="text" class="form-control" id="DetailUserPhone" name="UserPhone" readonly maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10)">
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="modal-footer" id="modalActions">
                                    <!-- Dynamic buttons added via JavaScript -->
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Account Modal -->
        <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteAccountModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this account?</p>
                        <input type="hidden" id="accountIdDelete">
                        <input type="hidden" id="accountNameDelete">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteAccountConfirm">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5.3.0 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>

        <script>
                                            // Display error message
                                            function displayError(fieldId, errorMessage) {
                                                const $field = $('#' + fieldId);
                                                $field.addClass('is-invalid');
                                                $field.siblings('.invalid-feedback').text(errorMessage);
                                            }

                                            // Validate create form
                                            function validateCreateForm() {
                                                $('.invalid-feedback').text('');
                                                $('.is-invalid').removeClass('is-invalid');

                                                let email = $("#UserEmail").val().trim();
                                                let password = $("#UserPassword").val().trim();
                                                let name = $("#UserName").val().trim();
                                                let role = $("#UserRole").val();
                                                let idCard = $("#IdentityCard").val().trim();
                                                let address = $("#UserAddress").val().trim();
                                                let phone = $("#UserPhone").val().trim();
                                                let image = $("#UserImage")[0].files.length;

                                                let isValid = true;

                                                if (!email) {
                                                    isValid = false;
                                                    displayError('UserEmail', 'Please enter an email address.');
                                                } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                    isValid = false;
                                                    displayError('UserEmail', 'Email must be valid and end with "@gmail.com".');
                                                }

                                                if (!password) {
                                                    isValid = false;
                                                    displayError('UserPassword', 'Please enter a password.');
                                                } else if (password.length < 6) {
                                                    isValid = false;
                                                    displayError('UserPassword', 'Password must be at least 6 characters long.');
                                                }

                                                if (!name) {
                                                    isValid = false;
                                                    displayError('UserName', 'Please enter a full name.');
                                                } else if (name.length < 2 || name.length > 50) {
                                                    isValid = false;
                                                    displayError('UserName', 'Name must be between 2 and 50 characters.');
                                                }

                                                if (!role) {
                                                    isValid = false;
                                                    displayError('UserRole', 'Please select a role.');
                                                }

                                                if (!idCard) {
                                                    isValid = false;
                                                    displayError('IdentityCard', 'Please enter an identity card number.');
                                                } else if (!/^\d{12}$/.test(idCard)) {
                                                    isValid = false;
                                                    displayError('IdentityCard', 'Identity card must be 12 digits.');
                                                }

                                                if (!address) {
                                                    isValid = false;
                                                    displayError('UserAddress', 'Please enter an address.');
                                                } else if (address.length < 5 || address.length > 100) {
                                                    isValid = false;
                                                    displayError('UserAddress', 'Address must be between 5 and 100 characters.');
                                                }

                                                if (!phone) {
                                                    isValid = false;
                                                    displayError('UserPhone', 'Please enter a phone number.');
                                                } else if (!/^0\d{9}$/.test(phone)) {
                                                    isValid = false;
                                                    displayError('UserPhone', 'Phone number must start with 0 and be 10 digits.');
                                                }

                                                if (!image) {
                                                    isValid = false;
                                                    displayError('UserImage', 'Please select a profile image.');
                                                }

                                                return isValid;
                                            }

                                            // Validate update form
                                            function validateUpdateDetailForm() {
                                                $('.invalid-feedback').text('');
                                                $('.is-invalid').removeClass('is-invalid');

                                                let email = $("#DetailUserEmail").val().trim();
                                                let password = $("#DetailUserPassword").val().trim();
                                                let name = $("#DetailUserName").val().trim();
                                                let role = $("#DetailUserRole").val();
                                                let idCard = $("#DetailIdentityCard").val().trim();
                                                let address = $("#DetailUserAddress").val().trim();
                                                let phone = $("#DetailUserPhone").val().trim();

                                                let isValid = true;

                                                if (!email) {
                                                    isValid = false;
                                                    displayError('DetailUserEmail', 'Please enter an email address.');
                                                } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                    isValid = false;
                                                    displayError('DetailUserEmail', 'Email must be valid and end with "@gmail.com".');
                                                }

                                                if (!password) {
                                                    isValid = false;
                                                    displayError('DetailUserPassword', 'Please enter a password.');
                                                } else if (password.length < 6) {
                                                    isValid = false;
                                                    displayError('DetailUserPassword', 'Password must be at least 6 characters long.');
                                                }

                                                if (!name) {
                                                    isValid = false;
                                                    displayError('DetailUserName', 'Please enter a full name.');
                                                } else if (name.length < 2 || name.length > 50) {
                                                    isValid = false;
                                                    displayError('DetailUserName', 'Name must be between 2 and 50 characters.');
                                                }

                                                if (!role) {
                                                    isValid = false;
                                                    displayError('DetailUserRole', 'Please select a role.');
                                                }

                                                if (!idCard) {
                                                    isValid = false;
                                                    displayError('DetailIdentityCard', 'Please enter an identity card number.');
                                                } else if (!/^\d{12}$/.test(idCard)) {
                                                    isValid = false;
                                                    displayError('DetailIdentityCard', 'Identity card must be 12 digits.');
                                                }

                                                if (!address) {
                                                    isValid = false;
                                                    displayError('DetailUserAddress', 'Please enter an address.');
                                                } else if (address.length < 5 || address.length > 100) {
                                                    isValid = false;
                                                    displayError('DetailUserAddress', 'Address must be between 5 and 100 characters.');
                                                }

                                                if (!phone) {
                                                    isValid = false;
                                                    displayError('DetailUserPhone', 'Please enter a phone number.');
                                                } else if (!/^0\d{9}$/.test(phone)) {
                                                    isValid = false;
                                                    displayError('DetailUserPhone', 'Phone number must start with 0 and be 10 digits.');
                                                }

                                                return isValid;
                                            }

                                            // Submit create form
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
                                                            var createModal = bootstrap.Modal.getInstance(document.getElementById('createEmployeeModal'));
                                                            createModal.hide();
                                                            Swal.fire({
                                                                icon: 'success',
                                                                title: 'Success!',
                                                                text: 'Account created successfully.',
                                                                timer: 2000,
                                                                showConfirmButton: false
                                                            }).then(() => {
                                                                location.reload();
                                                            });
                                                        } else {
                                                            if (response.errors) {
                                                                for (let field in response.errors) {
                                                                    displayError('User' + field.charAt(0).toUpperCase() + field.slice(1), response.errors[field]);
                                                                }
                                                            } else {
                                                                displayError('UserEmail', response.message || 'Failed to create account.');
                                                            }
                                                        }
                                                    },
                                                    error: function (xhr, status, error) {
                                                        try {
                                                            var errorResponse = JSON.parse(xhr.responseText);
                                                            if (errorResponse.errors) {
                                                                for (let field in errorResponse.errors) {
                                                                    displayError('User' + field.charAt(0).toUpperCase() + field.slice(1), errorResponse.errors[field]);
                                                                }
                                                            } else {
                                                                displayError('UserEmail', errorResponse.message || 'Error creating account: ' + error);
                                                            }
                                                        } catch (e) {
                                                            displayError('UserEmail', 'Error creating account: ' + error);
                                                        }
                                                    }
                                                });
                                            }

                                            // Submit update form
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
                                                            var detailModal = bootstrap.Modal.getInstance(document.getElementById('viewAccountDetailModal'));
                                                            detailModal.hide();
                                                            Swal.fire({
                                                                icon: 'success',
                                                                title: 'Success!',
                                                                text: 'Account updated successfully.',
                                                                timer: 2000,
                                                                showConfirmButton: false
                                                            }).then(() => {
                                                                location.reload();
                                                            });
                                                        } else {
                                                            if (response.errors) {
                                                                for (let field in response.errors) {
                                                                    displayError('DetailUser' + field.charAt(0).toUpperCase() + field.slice(1), response.errors[field]);
                                                                }
                                                            } else {
                                                                displayError('DetailUserEmail', response.message || 'Failed to update account.');
                                                            }
                                                        }
                                                    },
                                                    error: function (xhr, status, error) {
                                                        try {
                                                            var errorResponse = JSON.parse(xhr.responseText);
                                                            if (errorResponse.errors) {
                                                                for (let field in errorResponse.errors) {
                                                                    displayError('DetailUser' + field.charAt(0).toUpperCase() + field.slice(1), errorResponse.errors[field]);
                                                                }
                                                            } else {
                                                                displayError('DetailUserEmail', errorResponse.message || 'Error updating account: ' + error);
                                                            }
                                                        } catch (e) {
                                                            displayError('DetailUserEmail', 'Error updating account: ' + error);
                                                        }
                                                    }
                                                });
                                            }

                                            // Check selected image
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
                                                        // Check if there is an existing image in the currentImage src
                                                        if (!currentImage.attr('src') || currentImage.attr('src') === '') {
                                                            noImageMessage.show();
                                                            currentImage.hide();
                                                        } else {
                                                            noImageMessage.hide();
                                                            currentImage.show();
                                                        }
                                                    } else {
                                                        fileNameDisplay.text(imageInput.files[0].name);
                                                        noImageMessage.hide();
                                                        currentImage.show();
                                                        var reader = new FileReader();
                                                        reader.onload = function (e) {
                                                            currentImage.attr('src', e.target.result);
                                                        };
                                                        reader.readAsDataURL(imageInput.files[0]);
                                                    }
                                                }
                                            }

                                            // Enable edit mode
                                            function enableEditMode() {
                                                $("#detailModalHeading").text("Update Profile");
                                                $("#DetailUserEmail, #DetailUserPassword, #DetailUserName, #DetailUserAddress, #DetailUserPhone, #DetailIdentityCard")
                                                        .prop("readonly", false);
                                                $("#DetailUserRole").prop("disabled", false);
                                                $("#imageUpdateSection").show();

                                                var modalActions = $("#modalActions");
                                                modalActions.empty();
                                                modalActions.append('<input type="submit" class="btn btn-primary" value="Save">');
                                                modalActions.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>');

                                                $("#updateCustomFileButton").off("click").on("click", function () {
                                                    $("#DetailUserImage").click();
                                                });
                                            }

                                            $(document).ready(function () {
                                                var createBtn = $(".add-employee-btn");
                                                var detailButtons = $(".view-detail-btn");

                                                createBtn.on("click", function () {
                                                    $("#createAccountForm")[0].reset();
                                                    $("#createNoImageMessage").show();
                                                    $("#createCurrentImage").hide().attr('src', '');
                                                    $("#createFileNameDisplay").text("No file chosen");
                                                    checkImageSelected('create');
                                                    $("#createCustomFileButton").off("click").on("click", function () {
                                                        $("#UserImage").click();
                                                    });

                                                    $('.invalid-feedback').text('');
                                                    $('.is-invalid').removeClass('is-invalid');

                                                    var createModal = new bootstrap.Modal(document.getElementById('createEmployeeModal'));
                                                    createModal.show();
                                                });

                                                $('#createEmployeeModal').on('hidden.bs.modal', function () {
                                                    $('.invalid-feedback').text('');
                                                    $('.is-invalid').removeClass('is-invalid');
                                                    $("#createAccountForm")[0].reset();
                                                    $("#createNoImageMessage").show();
                                                    $("#createCurrentImage").hide().attr('src', '');
                                                    $("#createFileNameDisplay").text("No file chosen");
                                                });

                                                $("#createAccountForm").submit(submitCreateForm);

                                                detailButtons.on("click", function (e) {
                                                    e.preventDefault();
                                                    var btn = $(this);
                                                    var isAdmin = btn.data("userrole").toLowerCase() === "admin";

                                                    $("#detailModalHeading").text("Account Detail");
                                                    $("#DetailUserIdHidden").val(btn.data("userid"));
                                                    $("#DetailUserRoleHidden").val(btn.data("userrole"));
                                                    $("#DetailUserId").val(btn.data("userid"));
                                                    $("#DetailUserEmail").val(btn.data("useremail")).prop("readonly", true);
                                                    $("#DetailUserPassword").val(btn.data("userpassword")).prop("readonly", true);
                                                    $("#DetailUserName").val(btn.data("username")).prop("readonly", true);
                                                    $("#DetailUserRole").val(btn.data("userrole")).prop("disabled", true);
                                                    $("#DetailIdentityCard").val(btn.data("identitycard")).prop("readonly", true);
                                                    $("#DetailUserAddress").val(btn.data("useraddress")).prop("readonly", true);
                                                    $("#DetailUserPhone").val(btn.data("userphone") || '').prop("readonly", true);

                                                    // Set the image source and handle visibility
                                                    var userImage = btn.data("userimage") || '';
                                                    $("#DetailCurrentImage").attr("src", userImage);
                                                    $("#DetailOldImagePath").val(userImage);
                                                    if (userImage) {
                                                        $("#noImageMessage").hide();
                                                        $("#DetailCurrentImage").show();
                                                    } else {
                                                        $("#noImageMessage").show();
                                                        $("#DetailCurrentImage").hide();
                                                    }

                                                    $("#imageUpdateSection").hide();

                                                    $('.invalid-feedback').text('');
                                                    $('.is-invalid').removeClass('is-invalid');

                                                    var modalActions = $("#modalActions");
                                                    modalActions.empty();

                                                    if (!isAdmin) {
                                                        modalActions.append('<button type="button" class="btn btn-warning" id="editButton"><i class="fas fa-edit"></i> Update</button>');
                                                        modalActions.append('<button type="button" class="btn btn-danger btn-delete-account" data-bs-toggle="modal" data-bs-target="#deleteAccountModal" data-account-id="' + btn.data("userid") + '" data-account-name="' + btn.data("username") + '"><i class="fas fa-trash-alt"></i> Delete</button>');
                                                    }
                                                    modalActions.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>');

                                                    $("#editButton").off("click").on("click", function () {
                                                        enableEditMode();
                                                    });

                                                    var detailModal = new bootstrap.Modal(document.getElementById('viewAccountDetailModal'));
                                                    detailModal.show();
                                                    checkImageSelected('update');
                                                });

                                                $('#viewAccountDetailModal').on('hidden.bs.modal', function () {
                                                    $('.invalid-feedback').text('');
                                                    $('.is-invalid').removeClass('is-invalid');
                                                    $("#updateAccountDetailForm")[0].reset();
                                                    $("#noImageMessage").show();
                                                    $("#DetailCurrentImage").hide().attr('src', '');
                                                    $("#updateFileNameDisplay").text("No file chosen");
                                                });

                                                $("#updateAccountDetailForm").submit(submitUpdateDetailForm);

                                                $("#UserEmail").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let email = $(this).val().trim();
                                                    if (!email) {
                                                        displayError('UserEmail', 'Please enter an email address.');
                                                    } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                        displayError('UserEmail', 'Email must be valid and end with "@gmail.com".');
                                                    }
                                                });

                                                $("#UserPassword").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let password = $(this).val().trim();
                                                    if (!password) {
                                                        displayError('UserPassword', 'Please enter a password.');
                                                    } else if (password.length < 6) {
                                                        displayError('UserPassword', 'Password must be at least 6 characters long.');
                                                    }
                                                });

                                                $("#UserName").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let name = $(this).val().trim();
                                                    if (!name) {
                                                        displayError('UserName', 'Please enter a full name.');
                                                    } else if (name.length < 2 || name.length > 50) {
                                                        displayError('UserName', 'Name must be between 2 and 50 characters.');
                                                    }
                                                });

                                                $("#UserRole").on("change", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    if (!$(this).val()) {
                                                        displayError('UserRole', 'Please select a role.');
                                                    }
                                                });

                                                $("#IdentityCard").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let idCard = $(this).val().trim();
                                                    if (!idCard) {
                                                        displayError('IdentityCard', 'Please enter an identity card number.');
                                                    } else if (!/^\d{12}$/.test(idCard)) {
                                                        displayError('IdentityCard', 'Identity card must be 12 digits.');
                                                    }
                                                });

                                                $("#UserAddress").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let address = $(this).val().trim();
                                                    if (!address) {
                                                        displayError('UserAddress', 'Please enter an address.');
                                                    } else if (address.length < 5 || address.length > 100) {
                                                        displayError('UserAddress', 'Address must be between 5 and 100 characters.');
                                                    }
                                                });

                                                $("#UserPhone").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let phone = $(this).val().trim();
                                                    if (!phone) {
                                                        displayError('UserPhone', 'Please enter a phone number.');
                                                    } else if (!/^0\d{9}$/.test(phone)) {
                                                        displayError('UserPhone', 'Phone number must start with 0 and be 10 digits.');
                                                    }
                                                });

                                                $("#DetailUserEmail").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let email = $(this).val().trim();
                                                    if (!email) {
                                                        displayError('DetailUserEmail', 'Please enter an email address.');
                                                    } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                        displayError('DetailUserEmail', 'Email must be valid and end with "@gmail.com".');
                                                    }
                                                });

                                                $("#DetailUserPassword").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let password = $(this).val().trim();
                                                    if (!password) {
                                                        displayError('DetailUserPassword', 'Please enter a password.');
                                                    } else if (password.length < 6) {
                                                        displayError('DetailUserPassword', 'Password must be at least 6 characters long.');
                                                    }
                                                });

                                                $("#DetailUserName").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let name = $(this).val().trim();
                                                    if (!name) {
                                                        displayError('DetailUserName', 'Please enter a full name.');
                                                    } else if (name.length < 2 || name.length > 50) {
                                                        displayError('DetailUserName', 'Name must be between 2 and 50 characters.');
                                                    }
                                                });

                                                $("#DetailUserRole").on("change", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    if (!$(this).val()) {
                                                        displayError('DetailUserRole', 'Please select a role.');
                                                    }
                                                });

                                                $("#DetailIdentityCard").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let idCard = $(this).val().trim();
                                                    if (!idCard) {
                                                        displayError('DetailIdentityCard', 'Please enter an identity card number.');
                                                    } else if (!/^\d{12}$/.test(idCard)) {
                                                        displayError('DetailIdentityCard', 'Identity card must be 12 digits.');
                                                    }
                                                });

                                                $("#DetailUserAddress").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let address = $(this).val().trim();
                                                    if (!address) {
                                                        displayError('DetailUserAddress', 'Please enter an address.');
                                                    } else if (address.length < 5 || address.length > 100) {
                                                        displayError('DetailUserAddress', 'Address must be between 5 and 100 characters.');
                                                    }
                                                });

                                                $("#DetailUserPhone").on("input", function () {
                                                    $(this).removeClass('is-invalid');
                                                    $(this).siblings('.invalid-feedback').text('');
                                                    let phone = $(this).val().trim();
                                                    if (!phone) {
                                                        displayError('DetailUserPhone', 'Please enter a phone number.');
                                                    } else if (!/^0\d{9}$/.test(phone)) {
                                                        displayError('DetailUserPhone', 'Phone number must start with 0 and be 10 digits.');
                                                    }
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

                                                $(document).on('click', '.btn-delete-account', function () {
                                                    var accountId = $(this).data('account-id');
                                                    var accountName = $(this).data('account-name');
                                                    $('#accountIdDelete').val(accountId);
                                                    $('#accountNameDelete').val(accountName);
                                                    $('#deleteAccountModal .modal-body p').text('Are you sure you want to delete the account of ' + accountName + ' (ID: ' + accountId + ')?');
                                                });

                                                $('#btnDeleteAccountConfirm').click(function () {
                                                    var accountId = $('#accountIdDelete').val();
                                                    $.ajax({
                                                        url: 'DeleteAccount',
                                                        type: 'GET',
                                                        data: {UserId: accountId},
                                                        success: function () {
                                                            var deleteAccountModal = bootstrap.Modal.getInstance(document.getElementById('deleteAccountModal'));
                                                            deleteAccountModal.hide();
                                                            $('#accountRow' + accountId).remove();
                                                            if ($('#accountTableBody tr').length === 0) {
                                                                $('#accountTableBody').html('<tr><td colspan="6">No accounts found.</td></tr>');
                                                            }
                                                            Swal.fire({
                                                                icon: 'success',
                                                                title: 'Success!',
                                                                text: 'Account deleted successfully.',
                                                                timer: 2000,
                                                                showConfirmButton: false
                                                            });
                                                        },
                                                        error: function (xhr, status, error) {
                                                            $('#deleteAccountModal .modal-body p').after('<div class="invalid-feedback d-block">Error deleting account: ' + error + '</div>');
                                                        }
                                                    });
                                                });
                                            });
        </script>
    </body>
</html>