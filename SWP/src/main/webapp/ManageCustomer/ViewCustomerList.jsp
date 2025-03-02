<%--
    Document   : ViewCustomerList
    Created on : Feb 22, 2025, 9:16:19 PM
    Author     : HuynhPhuBinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Customer" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
          integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Reset some default browser styles */
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
            font-size: 14px;
            line-height: 1.5;
            margin: 0;
            padding: 0;
        }

        /* Container to hold the sidebar and content */
        .d-flex {
            display: flex;
        }

        /* Sidebar styles */
        .sidebar {
            background: linear-gradient(to bottom, #2C3E50, #34495E);
            color: white;
            width: 200px; /* Matching width from test.jsp sidebar */
            height: 100vh;
            padding: 15px;  /*Matching padding from test.jsp sidebar*/
            box-sizing: border-box;
        }

        .sidebar h4 {
            text-align: center;
            margin-bottom: 20px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 5px; /* Reduce spacing between sidebar links */
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 8px;  /* Reduce padding in sidebar links*/
            border-radius: 5px;
            font-size: 14px; /* Matching font size for sidebar links from test.jsp*/
        }

        .sidebar a:hover {
            background-color: #1A252F;
        }

        /* Main content area styles */
        .content {
            flex: 1;
            padding: 20px;
        }

        .content-area {
            flex: 1;
            background-color: #fff;
            padding: 20px;
            border: 1px solid #eee;
            border-radius: 5px;
        }

        /* Content header styles - Search bar and button */
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 250px;
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

        /* Styles for the Customer Table - MATCHING test.jsp */
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

        /* General Button styles - MATCHING test.jsp */
        .btn {
            background-color: #007bff; /* Default button color from test.jsp */
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 5px;
             font-size: 12px; /* Smaller font size for buttons, like in test.jsp*/
        }

        .btn:hover {
            background-color: #0056b3;
        }
         /* Add customer button style*/
        .add-employee-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px; /* Smaller font size for buttons, like in test.jsp*/
        }

        /* Specific button styles (if needed) */
        .btn-add, .btn-danger, .btn-profile {
            background-color: #007bff; /* Keep the same color */
            border: none;
        }

        .btn-add:hover, .btn-danger:hover, .btn-profile:hover {
            background-color: #0056b3; /* Keep the same hover color */
        }

        /* Responsive Design Adjustments */
        @media (max-width: 768px) {
            .d-flex {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
            }

            .content {
                padding: 10px;
            }
            .content-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
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
    </style>
    <script>
        function validateCustomerForm() {
            //Add validate if needed
            return true;
        }
        function validateUpdateCustomerForm() {
            //Add validate if needed
            return true;
        }
        function confirmDelete(event, customerId, customerName) {
            event.preventDefault(); // Prevent immediate redirection

            if (confirm('Bạn có chắc chắn muốn xóa khách hàng ID: ' + customerId + ' - Tên: ' + customerName + ' không?')) {
                window.location.href = 'DeleteCustomer?customerId=' + customerId;
            } else {
                // Do nothing if the user cancels
            }
        }
        document.addEventListener('DOMContentLoaded', function () {
            // Modal Create Customer
            var createModal = document.getElementById("createCustomerModal");
            var createBtn = document.querySelector(".add-employee-btn");
            var closeCreateButtons = document.querySelectorAll("#createCustomerModal .close-button");

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

            // Modal Edit Customer
            var editModal = document.getElementById("editCustomerModal");
            var editButtons = document.querySelectorAll(".btn-profile");
            var closeEditButtons = document.querySelectorAll("#editCustomerModal .close-button");

            if (editButtons) {
                editButtons.forEach(function (btnEdit) {
                    btnEdit.onclick = function (e) {
                        e.preventDefault();
                        // Lấy dữ liệu từ hàng trong bảng và điền vào modal
                        var customerId = btnEdit.dataset.customerid;
                        var customerName = btnEdit.dataset.customername;
                        var customerPhone = btnEdit.dataset.customerphone;
  var numberOfPayment = btnEdit.dataset.numberofpayment;


                        document.getElementById('EditCustomerIdHidden').value = customerId;
                        document.getElementById('EditCustomerName').value = customerName;
                        document.getElementById('EditCustomerPhone').value = customerPhone;
                        document.getElementById('EditNumberOfPayment').value = numberOfPayment;


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
    </script>
</head>
<body>
<div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar col-md-2 p-3">
        <h4 class="text-center mb-4">Quản Lý</h4>
        <ul class="nav flex-column">
            <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i
                    class="fas fa-home me-2"></i>Dashboard</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i
                    class="fas fa-utensils me-2"></i>Quản lý món ăn</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i
                    class="fas fa-shopping-cart me-2"></i>Quản lý đặt bàn</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i
                    class="fas fa-users me-2"></i>Quản lý nhân viên</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-users me-2"></i>Quản lý khách hàng</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-chart-bar me-2"></i>Báo cáo doanh thu</a>
            </li>
            <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-cog me-2"></i>Cài đặt</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="col-md-10 p-4">
        <section class="main-content">
            <div class="container-fluid">
                <main class="content-area">
                    <!-- Content Header: Search bar and button -->
                    <div class="content-header">
                        <div class="search-bar">
                            <input type="text" placeholder="Tìm theo mã, tên khách hàng">
                        </div>
                        <div class="header-buttons">
                            <button class="add-employee-btn"><i class="far fa-plus"></i> Customer</button>
                        </div>
                    </div>

                    <div class="employee-grid">
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Phone</th>
                                <th>Payments</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
                                if (customerList != null && !customerList.isEmpty()) {
                                    for (Customer customer : customerList) {
                            %>
                            <tr>
                                <td><%= customer.getCustomerId() %>
                                </td>
                                <td><%= customer.getCustomerName() %>
                                </td>
                                <td><%= customer.getCustomerPhone() %>
                                </td>
                                <td><%= customer.getNumberOfPayment() %>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-profile"
                                       data-customerid="<%= customer.getCustomerId() %>"
                                       data-customername="<%= customer.getCustomerName() %>"
                                       data-customerphone="<%= customer.getCustomerPhone() %>"
                                       data-numberofpayment="<%= customer.getNumberOfPayment() %>">Update</a>
                                    <a href="#" class="btn btn-danger"
                                       data-customerid="<%= customer.getCustomerId() %>"
                                       data-customername="<%= customer.getCustomerName() %>"
                                       onclick="confirmDelete(event, '<%= customer.getCustomerId() %>', '<%= customer.getCustomerName() %>')">Delete</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5">No customers available.</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </section>
    </div>
</div>

<!-- Modal Create Customer -->
<div id="createCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-button">×</span>
        <h2>Thêm Khách Hàng Mới</h2>
        <div class="modal-form-container">
            <form method="post" action="AddCustomer" onsubmit="return validateCustomerForm()">
                <div>
                    <label for="CustomerName">Tên Khách Hàng</label>
                    <input type="text" id="CustomerName" name="customerName" placeholder="Nhập tên khách hàng">
                </div>
                <div>
                    <label for="CustomerPhone">Số Điện Thoại</label>
                    <input type="text" id="CustomerPhone" name="customerPhone" placeholder="Nhập số điện thoại">
                </div>
                 <div>
                    <label for="NumberOfPayment">Số Thanh Toán</label>
                    <input type="text" id="NumberOfPayment" name="numberOfPayment" placeholder="Nhập so thanh toan">
                </div>
                <!-- Thêm các trường khác nếu cần -->
                <div class="modal-actions">
                    <input type="submit" class="btn btn-primary" value="Thêm Khách Hàng"/>
                    <button type="button" class="btn btn-secondary close-button">Hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Edit Customer -->
<div id="editCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-button">×</span>
        <h2>Cập Nhật Thông Tin Khách Hàng</h2>
        <div class="modal-form-container">
            <form method="post" action="UpdateCustomerProfile" onsubmit="return validateUpdateCustomerForm()">
                <input type="hidden" id="EditCustomerIdHidden" name="customerId" value=""/>
                <div>
                    <label for="EditCustomerName">Tên Khách Hàng</label>
                    <input type="text" id="EditCustomerName" name="customerName" value="">
                </div>
                <div>
                    <label for="EditCustomerPhone">Số Điện Thoại</label>
                    <input type="text" id="EditCustomerPhone" name="customerPhone" value="">
                </div>
                 <div>
                    <label for="EditNumberOfPayment">Số Thanh Toán</label>
                    <input type="text" id="EditNumberOfPayment" name="numberOfPayment" value="">
                </div>
                <!-- Thêm các trường khác nếu cần -->
                <div class="modal-actions">
                    <input type="submit" class="btn btn-primary" value="Cập Nhật"/>
                    <button type="button" class="btn btn-secondary close-button">Hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    function validateCustomerForm() {
        //Add validate if needed
        return true;
    }
    function validateUpdateCustomerForm() {
        //Add validate if needed
        return true;
    }
    function confirmDelete(event, customerId, customerName) {
        event.preventDefault(); // Prevent immediate redirection

        if (confirm('Bạn có chắc chắn muốn xóa khách hàng ID: ' + customerId + ' - Tên: ' + customerName + ' không?')) {
            window.location.href = 'DeleteCustomer?customerId=' + customerId;
        } else {
            // Do nothing if the user cancels
        }
    }
    document.addEventListener('DOMContentLoaded', function () {
        // Modal Create Customer
        var createModal = document.getElementById("createCustomerModal");
        var createBtn = document.querySelector(".add-employee-btn");
        var closeCreateButtons = document.querySelectorAll("#createCustomerModal .close-button");

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

        // Modal Edit Customer
        var editModal = document.getElementById("editCustomerModal");
        var editButtons = document.querySelectorAll(".btn-profile");
        var closeEditButtons = document.querySelectorAll("#editCustomerModal .close-button");

        if (editButtons) {
            editButtons.forEach(function (btnEdit) {
                btnEdit.onclick = function (e) {
                    e.preventDefault();
                    // Lấy dữ liệu từ hàng trong bảng và điền vào modal
                    var customerId = btnEdit.dataset.customerid;
                    var customerName = btnEdit.dataset.customername;
                    var customerPhone = btnEdit.dataset.customerphone;
                    var numberOfPayment = btnEdit.dataset.numberofpayment;

                    document.getElementById('EditCustomerIdHidden').value = customerId;
                    document.getElementById('EditCustomerName').value = customerName;
                    document.getElementById('EditCustomerPhone').value = customerPhone;
                    document.getElementById('EditNumberOfPayment').value = numberOfPayment;


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
</script>
</body>
</html>