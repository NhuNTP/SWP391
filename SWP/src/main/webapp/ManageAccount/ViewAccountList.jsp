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
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Account List - Admin Dashboard</title>

        <!-- Thêm jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Thêm Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Thêm Font Awesome cho các biểu tượng -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- Thêm SweetAlert2 cho thông báo thành công -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <style>
            /* Giữ nguyên phần CSS của bạn, chỉ thêm hoặc điều chỉnh một số style cần thiết */
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

            .is-invalid {
                border: 1px solid #dc3545 !important;
            }

            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
            }

            .input-error-wrapper {
                position: relative;
                display: inline-block;
                width: 100%;
            }

            .input-error-wrapper .is-invalid {
                border: 1px solid #dc3545 !important;
                padding-right: 40px;
            }

            .input-error-wrapper .error-icon {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #dc3545;
                font-size: 1.2rem;
                display: none;
            }

            .input-error-wrapper .is-invalid ~ .error-icon {
                display: block;
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

            /* Các style khác giữ nguyên */
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
                            <button class="add-employee-btn" data-bs-toggle="modal" data-bs-target="#createEmployeeModal"><i class="far fa-plus"></i> Employee</button>
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
                            <tbody id="accountTableBody">
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
                                        for (Account acc : paginatedAccounts) {
                                %>
                                <tr id="accountRow<%= acc.getUserId()%>">
                                    <td><%= counter++%></td>
                                    <td><%= acc.getUserId()%></td>
                                    <td><%= acc.getUserName()%></td>
                                    <td><%= acc.getUserEmail()%></td>
                                    <td><%= acc.getUserRole()%></td>
                                    <td>
                                        <a href="#" class="btn-detail view-detail-btn"
                                           data-userid="<%= acc.getUserId()%>"
                                           data-useremail="<%= acc.getUserEmail()%>"
                                           data-userpassword="<%= acc.getUserPassword()%>"
                                           data-username="<%= acc.getUserName()%>"
                                           data-userrole="<%= acc.getUserRole()%>"
                                           data-identitycard="<%= acc.getIdentityCard()%>"
                                           data-useraddress="<%= acc.getUserAddress()%>"
                                           data-userphone="<%= acc.getUserPhone()%>"
                                           data-userimage="<%= acc.getUserImage()%>">View Profile</a>
                                        <% if (!acc.getUserRole().equalsIgnoreCase("Admin")) {%>
                                        <a href="#" class="btn-delete btn-delete-account"
                                           data-bs-toggle="modal" data-bs-target="#deleteAccountModal"
                                           data-account-id="<%= acc.getUserId()%>"
                                           data-account-name="<%= acc.getUserName()%>">Delete</a>
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
        <div class="modal fade" id="createEmployeeModal" tabindex="-1" aria-labelledby="createEmployeeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createEmployeeModalLabel">Create New Employee Account</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-form-container">
                            <form id="createAccountForm" enctype="multipart/form-data">
                                <div>
                                    <label for="UserEmail">Email Address</label>
                                    <div class="input-error-wrapper">
                                        <input type="email" id="UserEmail" name="UserEmail" placeholder="Enter email" required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="UserPassword">Password</label>
                                    <div class="input-error-wrapper">
                                        <input type="password" id="UserPassword" name="UserPassword" placeholder="Enter password" required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="UserName">Full Name</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="UserName" name="UserName" placeholder="Enter full name" required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="UserRole">Role</label>
                                    <div class="input-error-wrapper">
                                        <select id="UserRole" name="UserRole" required>
                                            <option value="">Select Role</option>
                                            <option value="Manager">Manager</option>
                                            <option value="Cashier">Cashier</option>
                                            <option value="Waiter">Waiter</option>
                                            <option value="Kitchen staff">Kitchen staff</option>
                                        </select>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="IdentityCard">Identity Card (12 digits)</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="IdentityCard" name="IdentityCard" placeholder="Enter 12-digit ID card number" required maxlength="12" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12)">
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="UserAddress">Address</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="UserAddress" name="UserAddress" placeholder="Enter address" required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="UserPhone">Phone (10 digits, starts with 0)</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="UserPhone" name="UserPhone" placeholder="Enter 10-digit phone (e.g., 0123456789)" required maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10)">
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
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
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <input type="submit" class="btn btn-primary" value="Create Account">
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
                            <form id="updateAccountDetailForm" enctype="multipart/form-data">
                                <input type="hidden" id="DetailUserIdHidden" name="UserIdHidden">
                                <input type="hidden" id="DetailUserRoleHidden" name="UserRoleHidden">
                                <div>
                                    <label>Current Image</label>
                                    <img id="DetailCurrentImage" src="" alt="Current Image" class="rounded-image">
                                    <p id="noImageMessage" style="display:none; color: gray;">No image selected</p>
                                </div>
                                <div id="imageUpdateSection" style="display:none;">
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
                                    <div class="input-error-wrapper">
                                        <input type="text" id="DetailUserId" name="UserId" readonly>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserEmail">Email Address</label>
                                    <div class="input-error-wrapper">
                                        <input type="email" id="DetailUserEmail" name="UserEmail" readonly required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserPassword">Password</label>
                                    <div class="input-error-wrapper">
                                        <input type="password" id="DetailUserPassword" name="UserPassword" readonly required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserName">Full Name</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="DetailUserName" name="UserName" readonly required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserRole">Role</label>
                                    <div class="input-error-wrapper">
                                        <select id="DetailUserRole" name="UserRole" disabled required>
                                            <option value="">Select Role</option>
                                            <option value="Manager">Manager</option>
                                            <option value="Cashier">Cashier</option>
                                            <option value="Waiter">Waiter</option>
                                            <option value="Kitchen staff">Kitchen staff</option>
                                        </select>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailIdentityCard">Identity Card (12 digits)</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="DetailIdentityCard" name="IdentityCard" readonly required maxlength="12" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12)">
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserAddress">Address</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="DetailUserAddress" name="UserAddress" readonly required>
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
                                </div>
                                <div>
                                    <label for="DetailUserPhone">Phone (10 digits, starts with 0)</label>
                                    <div class="input-error-wrapper">
                                        <input type="text" id="DetailUserPhone" name="UserPhone" readonly required maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10)">
                                        <span class="error-icon"><i class="fas fa-exclamation-circle"></i></span>
                                    </div>
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
                        <p>Are you sure you want to DELETE this account?</p>
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

        <!-- Bootstrap 5.3.0 JS (bao gồm Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>

        <script>
                                            // Hàm hiển thị thông báo lỗi
                                            function displayError(fieldId, errorMessage) {
                                                $('#' + fieldId).addClass('is-invalid');
                                                $('#' + fieldId).closest('.input-error-wrapper').after('<div class="error-message">' + errorMessage + '</div>');
                                            }

                                            // Hàm kiểm tra form tạo tài khoản
                                            function validateCreateForm() {
                                                $('.error-message').remove();
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

                                                // Kiểm tra email
                                                if (!email) {
                                                    isValid = false;
                                                    displayError('UserEmail', 'Vui lòng nhập địa chỉ email.');
                                                } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                    isValid = false;
                                                    displayError('UserEmail', 'Email phải có định dạng hợp lệ và kết thúc bằng "@gmail.com".');
                                                }

                                                // Kiểm tra mật khẩu
                                                if (!password) {
                                                    isValid = false;
                                                    displayError('UserPassword', 'Vui lòng nhập mật khẩu.');
                                                } else if (password.length < 6) {
                                                    isValid = false;
                                                    displayError('UserPassword', 'Mật khẩu phải có ít nhất 6 ký tự.');
                                                }

                                                // Kiểm tra tên
                                                if (!name) {
                                                    isValid = false;
                                                    displayError('UserName', 'Vui lòng nhập họ và tên.');
                                                } else if (name.length < 2 || name.length > 50) {
                                                    isValid = false;
                                                    displayError('UserName', 'Tên phải từ 2 đến 50 ký tự.');
                                                }

                                                // Kiểm tra vai trò
                                                if (!role) {
                                                    isValid = false;
                                                    displayError('UserRole', 'Vui lòng chọn vai trò.');
                                                }

                                                // Kiểm tra Identity Card
                                                if (!idCard) {
                                                    isValid = false;
                                                    displayError('IdentityCard', 'Vui lòng nhập số CMND/CCCD.');
                                                } else if (!/^\d{12}$/.test(idCard)) {
                                                    isValid = false;
                                                    displayError('IdentityCard', 'CMND/CCCD phải gồm 12 chữ số.');
                                                }

                                                // Kiểm tra địa chỉ
                                                if (!address) {
                                                    isValid = false;
                                                    displayError('UserAddress', 'Vui lòng nhập địa chỉ.');
                                                } else if (address.length < 5 || address.length > 100) {
                                                    isValid = false;
                                                    displayError('UserAddress', 'Địa chỉ phải từ 5 đến 100 ký tự.');
                                                }

                                                // Kiểm tra số điện thoại
                                                if (!phone) {
                                                    isValid = false;
                                                    displayError('UserPhone', 'Vui lòng nhập số điện thoại.');
                                                } else if (!/^0\d{9}$/.test(phone)) {
                                                    isValid = false;
                                                    displayError('UserPhone', 'Số điện thoại phải bắt đầu bằng 0 và gồm 10 chữ số.');
                                                }

                                                // Kiểm tra hình ảnh (tùy chọn)
                                                if (!image) {
                                                    isValid = false;
                                                    displayError('UserImage', 'Vui lòng chọn ảnh đại diện.');
                                                }

                                                return isValid;
                                            }

                                            // Hàm kiểm tra form cập nhật tài khoản
                                            function validateUpdateDetailForm() {
                                                $('.error-message').remove();
                                                $('.is-invalid').removeClass('is-invalid');

                                                let email = $("#DetailUserEmail").val().trim();
                                                let password = $("#DetailUserPassword").val().trim();
                                                let name = $("#DetailUserName").val().trim();
                                                let role = $("#DetailUserRole").val();
                                                let idCard = $("#DetailIdentityCard").val().trim();
                                                let address = $("#DetailUserAddress").val().trim();
                                                let phone = $("#DetailUserPhone").val().trim();

                                                let isValid = true;

                                                // Kiểm tra email
                                                if (!email) {
                                                    isValid = false;
                                                    displayError('DetailUserEmail', 'Vui lòng nhập địa chỉ email.');
                                                } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                    isValid = false;
                                                    displayError('DetailUserEmail', 'Email phải có định dạng hợp lệ và kết thúc bằng "@gmail.com".');
                                                }

                                                // Kiểm tra mật khẩu
                                                if (!password) {
                                                    isValid = false;
                                                    displayError('DetailUserPassword', 'Vui lòng nhập mật khẩu.');
                                                } else if (password.length < 6) {
                                                    isValid = false;
                                                    displayError('DetailUserPassword', 'Mật khẩu phải có ít nhất 6 ký tự.');
                                                }

                                                // Kiểm tra tên
                                                if (!name) {
                                                    isValid = false;
                                                    displayError('DetailUserName', 'Vui lòng nhập họ và tên.');
                                                } else if (name.length < 2 || name.length > 50) {
                                                    isValid = false;
                                                    displayError('DetailUserName', 'Tên phải từ 2 đến 50 ký tự.');
                                                }

                                                // Kiểm tra vai trò
                                                if (!role) {
                                                    isValid = false;
                                                    displayError('DetailUserRole', 'Vui lòng chọn vai trò.');
                                                }

                                                // Kiểm tra Identity Card
                                                if (!idCard) {
                                                    isValid = false;
                                                    displayError('DetailIdentityCard', 'Vui lòng nhập số CMND/CCCD.');
                                                } else if (!/^\d{12}$/.test(idCard)) {
                                                    isValid = false;
                                                    displayError('DetailIdentityCard', 'CMND/CCCD phải gồm 12 chữ số.');
                                                }

                                                // Kiểm tra địa chỉ
                                                if (!address) {
                                                    isValid = false;
                                                    displayError('DetailUserAddress', 'Vui lòng nhập địa chỉ.');
                                                } else if (address.length < 5 || address.length > 100) {
                                                    isValid = false;
                                                    displayError('DetailUserAddress', 'Địa chỉ phải từ 5 đến 100 ký tự.');
                                                }

                                                // Kiểm tra số điện thoại
                                                if (!phone) {
                                                    isValid = false;
                                                    displayError('DetailUserPhone', 'Vui lòng nhập số điện thoại.');
                                                } else if (!/^0\d{9}$/.test(phone)) {
                                                    isValid = false;
                                                    displayError('DetailUserPhone', 'Số điện thoại phải bắt đầu bằng 0 và gồm 10 chữ số.');
                                                }

                                                return isValid;
                                            }

                                            // Hàm gửi form tạo tài khoản
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
                                                                title: 'Thành công!',
                                                                text: 'Tài khoản đã được tạo thành công.',
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
                                                                displayError('UserEmail', response.message || 'Không thể tạo tài khoản.');
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
                                                                displayError('UserEmail', errorResponse.message || 'Lỗi khi tạo tài khoản: ' + error);
                                                            }
                                                        } catch (e) {
                                                            displayError('UserEmail', 'Lỗi khi tạo tài khoản: ' + error);
                                                        }
                                                    }
                                                });
                                            }

                                            // Hàm gửi form cập nhật tài khoản
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
                                                                title: 'Thành công!',
                                                                text: 'Tài khoản đã được cập nhật thành công.',
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
                                                                displayError('DetailUserEmail', response.message || 'Không thể cập nhật tài khoản.');
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
                                                                displayError('DetailUserEmail', errorResponse.message || 'Lỗi khi cập nhật tài khoản: ' + error);
                                                            }
                                                        } catch (e) {
                                                            displayError('DetailUserEmail', 'Lỗi khi cập nhật tài khoản: ' + error);
                                                        }
                                                    }
                                                });
                                            }

                                            // Hàm kiểm tra hình ảnh được chọn
                                            function checkImageSelected(mode) {
                                                if (mode === 'create') {
                                                    var imageInput = $("#UserImage")[0];
                                                    var noImageMessage = $("#createNoImageMessage");
                                                    var currentImage = $("#createCurrentImage");
                                                    var fileNameDisplay = $("#createFileNameDisplay");

                                                    if (imageInput.files.length === 0) {
                                                        fileNameDisplay.text("Không có tệp nào được chọn");
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
                                                        fileNameDisplay.text("Không có tệp nào được chọn");
                                                        if (currentImage.attr('src') === '') {
                                                            noImageMessage.show();
                                                            currentImage.hide();
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

                                            // Hàm kích hoạt chế độ chỉnh sửa
                                            function enableEditMode() {
                                                $("#detailModalHeading").text("Cập nhật hồ sơ");
                                                $("#DetailUserEmail, #DetailUserPassword, #DetailUserName, #DetailUserAddress, #DetailUserPhone, #DetailIdentityCard")
                                                        .prop("readonly", false);
                                                $("#DetailUserRole").prop("disabled", false);
                                                $("#imageUpdateSection").show();

                                                var modalActions = $("#modalActions");
                                                modalActions.empty();
                                                modalActions.append('<input type="submit" class="btn btn-primary" value="Lưu">');
                                                modalActions.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>');

                                                $("#updateCustomFileButton").off("click").on("click", function () {
                                                    $("#DetailUserImage").click();
                                                });
                                            }

                                            $(document).ready(function () {
                                                var createBtn = $(".add-employee-btn");
                                                var detailButtons = $(".view-detail-btn");

                                                // Show create modal and reset form
                                                createBtn.on("click", function () {
                                                    $("#createAccountForm")[0].reset();
                                                    $("#createNoImageMessage").show();
                                                    $("#createCurrentImage").hide().attr('src', '');
                                                    $("#createFileNameDisplay").text("Không có tệp nào được chọn");
                                                    checkImageSelected('create');
                                                    $("#createCustomFileButton").off("click").on("click", function () {
                                                        $("#UserImage").click();
                                                    });

                                                    $('.error-message').remove();
                                                    $('.is-invalid').removeClass('is-invalid');

                                                    var createModal = new bootstrap.Modal(document.getElementById('createEmployeeModal'));
                                                    createModal.show();
                                                });

                                                // Clear errors when create modal is closed
                                                $('#createEmployeeModal').on('hidden.bs.modal', function () {
                                                    $('.error-message').remove();
                                                    $('.is-invalid').removeClass('is-invalid');
                                                    $("#createAccountForm")[0].reset();
                                                    $("#createNoImageMessage").show();
                                                    $("#createCurrentImage").hide().attr('src', '');
                                                    $("#createFileNameDisplay").text("Không có tệp nào được chọn");
                                                });

                                                // Handle create form submission
                                                $("#createAccountForm").submit(submitCreateForm);

                                                // Handle detail view and update form
                                                detailButtons.on("click", function (e) {
                                                    e.preventDefault();
                                                    var btn = $(this);
                                                    var isAdmin = btn.data("userrole").toLowerCase() === "admin";

                                                    $("#detailModalHeading").text("Chi tiết tài khoản");
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
                                                    $("#DetailCurrentImage").attr("src", btn.data("userimage") || '');
                                                    $("#DetailOldImagePath").val(btn.data("userimage") || '');
                                                    $("#imageUpdateSection").hide();

                                                    $('.error-message').remove();
                                                    $('.is-invalid').removeClass('is-invalid');

                                                    var modalActions = $("#modalActions");
                                                    modalActions.empty();

                                                    if (!isAdmin) {
                                                        modalActions.append('<button type="button" class="btn btn-primary" id="editButton">Cập nhật</button>');
                                                        modalActions.append('<button type="button" class="btn btn-danger btn-delete-account" data-bs-toggle="modal" data-bs-target="#deleteAccountModal" data-account-id="' + btn.data("userid") + '" data-account-name="' + btn.data("username") + '">Xóa</button>');
                                                    }
                                                    modalActions.append('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>');

                                                    $("#editButton").off("click").on("click", function () {
                                                        enableEditMode();
                                                    });

                                                    var detailModal = new bootstrap.Modal(document.getElementById('viewAccountDetailModal'));
                                                    detailModal.show();
                                                    checkImageSelected('update');
                                                });

                                                // Clear errors when detail modal is closed
                                                $('#viewAccountDetailModal').on('hidden.bs.modal', function () {
                                                    $('.error-message').remove();
                                                    $('.is-invalid').removeClass('is-invalid');
                                                    $("#updateAccountDetailForm")[0].reset();
                                                    $("#noImageMessage").show();
                                                    $("#DetailCurrentImage").hide().attr('src', '');
                                                    $("#updateFileNameDisplay").text("Không có tệp nào được chọn");
                                                });

                                                // Handle update form submission
                                                $("#updateAccountDetailForm").submit(submitUpdateDetailForm);

                                                // Real-time validation for create form
                                                $("#UserEmail").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let email = $(this).val().trim();
                                                    if (!email) {
                                                        displayError('UserEmail', 'Vui lòng nhập địa chỉ email.');
                                                    } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                        displayError('UserEmail', 'Email phải có định dạng hợp lệ và kết thúc bằng "@gmail.com".');
                                                    }
                                                });

                                                $("#UserPassword").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let password = $(this).val().trim();
                                                    if (!password) {
                                                        displayError('UserPassword', 'Vui lòng nhập mật khẩu.');
                                                    } else if (password.length < 6) {
                                                        displayError('UserPassword', 'Mật khẩu phải có ít nhất 6 ký tự.');
                                                    }
                                                });

                                                $("#UserName").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let name = $(this).val().trim();
                                                    if (!name) {
                                                        displayError('UserName', 'Vui lòng nhập họ và tên.');
                                                    } else if (name.length < 2 || name.length > 50) {
                                                        displayError('UserName', 'Tên phải từ 2 đến 50 ký tự.');
                                                    }
                                                });

                                                $("#UserRole").on("change", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    if (!$(this).val()) {
                                                        displayError('UserRole', 'Vui lòng chọn vai trò.');
                                                    }
                                                });

                                                $("#IdentityCard").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let idCard = $(this).val().trim();
                                                    if (!idCard) {
                                                        displayError('IdentityCard', 'Vui lòng nhập số CMND/CCCD.');
                                                    } else if (!/^\d{12}$/.test(idCard)) {
                                                        displayError('IdentityCard', 'CMND/CCCD phải gồm 12 chữ số.');
                                                    }
                                                });

                                                $("#UserAddress").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let address = $(this).val().trim();
                                                    if (!address) {
                                                        displayError('UserAddress', 'Vui lòng nhập địa chỉ.');
                                                    } else if (address.length < 5 || address.length > 100) {
                                                        displayError('UserAddress', 'Địa chỉ phải từ 5 đến 100 ký tự.');
                                                    }
                                                });

                                                $("#UserPhone").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let phone = $(this).val().trim();
                                                    if (!phone) {
                                                        displayError('UserPhone', 'Vui lòng nhập số điện thoại.');
                                                    } else if (!/^0\d{9}$/.test(phone)) {
                                                        displayError('UserPhone', 'Số điện thoại phải bắt đầu bằng 0 và gồm 10 chữ số.');
                                                    }
                                                });

                                                // Real-time validation for update form
                                                $("#DetailUserEmail").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let email = $(this).val().trim();
                                                    if (!email) {
                                                        displayError('DetailUserEmail', 'Vui lòng nhập địa chỉ email.');
                                                    } else if (!/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(email)) {
                                                        displayError('DetailUserEmail', 'Email phải có định dạng hợp lệ và kết thúc bằng "@gmail.com".');
                                                    }
                                                });

                                                $("#DetailUserPassword").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let password = $(this).val().trim();
                                                    if (!password) {
                                                        displayError('DetailUserPassword', 'Vui lòng nhập mật khẩu.');
                                                    } else if (password.length < 6) {
                                                        displayError('DetailUserPassword', 'Mật khẩu phải có ít nhất 6 ký tự.');
                                                    }
                                                });

                                                $("#DetailUserName").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let name = $(this).val().trim();
                                                    if (!name) {
                                                        displayError('DetailUserName', 'Vui lòng nhập họ và tên.');
                                                    } else if (name.length < 2 || name.length > 50) {
                                                        displayError('DetailUserName', 'Tên phải từ 2 đến 50 ký tự.');
                                                    }
                                                });

                                                $("#DetailUserRole").on("change", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    if (!$(this).val()) {
                                                        displayError('DetailUserRole', 'Vui lòng chọn vai trò.');
                                                    }
                                                });

                                                $("#DetailIdentityCard").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let idCard = $(this).val().trim();
                                                    if (!idCard) {
                                                        displayError('DetailIdentityCard', 'Vui lòng nhập số CMND/CCCD.');
                                                    } else if (!/^\d{12}$/.test(idCard)) {
                                                        displayError('DetailIdentityCard', 'CMND/CCCD phải gồm 12 chữ số.');
                                                    }
                                                });

                                                $("#DetailUserAddress").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let address = $(this).val().trim();
                                                    if (!address) {
                                                        displayError('DetailUserAddress', 'Vui lòng nhập địa chỉ.');
                                                    } else if (address.length < 5 || address.length > 100) {
                                                        displayError('DetailUserAddress', 'Địa chỉ phải từ 5 đến 100 ký tự.');
                                                    }
                                                });

                                                $("#DetailUserPhone").on("input", function () {
                                                    $(this).closest('.input-error-wrapper').next('.error-message').remove();
                                                    $(this).removeClass('is-invalid');
                                                    let phone = $(this).val().trim();
                                                    if (!phone) {
                                                        displayError('DetailUserPhone', 'Vui lòng nhập số điện thoại.');
                                                    } else if (!/^0\d{9}$/.test(phone)) {
                                                        displayError('DetailUserPhone', 'Số điện thoại phải bắt đầu bằng 0 và gồm 10 chữ số.');
                                                    }
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

                                                // Xử lý khi nhấn nút Delete trong bảng
                                                $(document).on('click', '.btn-delete-account', function () {
                                                    var accountId = $(this).data('account-id');
                                                    var accountName = $(this).data('account-name');
                                                    $('#accountIdDelete').val(accountId);
                                                    $('#accountNameDelete').val(accountName);
                                                    $('#deleteAccountModal .modal-body p').text('Bạn có chắc chắn muốn XÓA tài khoản của ' + accountName + ' (ID: ' + accountId + ')?');
                                                });

                                                // Xử lý khi nhấn nút Delete trong modal
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
                                                                $('#accountTableBody').html('<tr><td colspan="6">Không tìm thấy tài khoản.</td></tr>');
                                                            }
                                                            Swal.fire({
                                                                icon: 'success',
                                                                title: 'Thành công!',
                                                                text: 'Tài khoản đã được xóa thành công.',
                                                                timer: 2000,
                                                                showConfirmButton: false
                                                            });
                                                        },
                                                        error: function (xhr, status, error) {
                                                            $('#deleteAccountModal .modal-body p').after('<div class="error-message">Lỗi khi xóa tài khoản: ' + error + '</div>');
                                                        }
                                                    });
                                                });
                                            });
        </script>
    </body>
</html>