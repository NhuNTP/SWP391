<%--
    Document   : ViewIntentoryItem
    Created on : Feb 23, 2025, 9:43:14 PM
    Author     : DELL-Laptop
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Inventory"%> <%-- Assuming Model.Inventory exists, adjust if needed --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Kho hàng - Admin Dashboard</title> <%-- Updated title --%>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            function confirmDelete(itemId) {
                if (confirm("Bạn có chắc chắn muốn XÓA mục kho này?")) {
            <%-- Updated confirmation message --%>
                    $.ajax({
                        url: "DeleteInventoryItemController",
                        type: "POST",
                        data: {itemID: itemId},
                        success: function (data) {
                            alert("Xóa mục kho thành công!");
            <%-- Updated alert message --%>
                            window.location.reload();
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert("Lỗi khi xóa mục kho: " + textStatus + ", " + errorThrown);
            <%-- Updated error message --%>
                        }
                    });
                }
            }
        </script>
        <style>
            /* CSS Reset and Font */
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f8f9fa;
            }

            /* Sidebar Styles */
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

            /* Card Stats Styles */
            .card-stats {
                background: linear-gradient(to right, #4CAF50, #81C784);
                color: white;
            }

            .card-stats i {
                font-size: 2rem;
            }

            /* Chart Container Styles */
            .chart-container {
                position: relative;
                height: 300px;
            }

            /* Main Content */
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

            .header-buttons .btn-info {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
            }

            .header-buttons .btn-info:hover {
                background-color: #0056b3;
            }

            /* Inventory Table */
            .employee-grid .table { /* Reusing employee-grid class for table container */
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            .employee-grid .table th, .employee-grid .table td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            .employee-grid .table th {
                background-color: #f4f4f4;
                font-weight: bold;
            }

            .employee-grid .table tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .employee-grid .table tbody tr:hover {
                background-color: #f0f0f0;
            }

            /* Table Buttons */
            .employee-grid .btn-warning, .employee-grid .btn-danger {
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
                text-decoration: none;
                cursor: pointer;
                margin: 2px;
            }

            .employee-grid .btn-warning {
                background-color: #ffc107;
            }

            .employee-grid .btn-warning:hover {
                background-color: #e0a800;
            }

            .employee-grid .btn-danger {
                background-color: #dc3545;
            }

            .employee-grid .btn-danger:hover {
                background-color: #c82333;
            }

            /* No Data Message */
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
            }

            /* Image Style in Table */
            .employee-grid .table img {
                max-width: 100px;
                max-height: 100px;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }
            .sidebar .nav-link {
                font-size: 0.9rem; /* Hoặc 16px, tùy vào AdminDashboard.jsp */
            }

            .sidebar h4{
                font-size: 1.5rem;
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
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
            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="container-fluid">
                        <main class="content-area">
                            <div class="content-header">
                                <h2>QUẢN LÝ KHO HÀNG</h2> <%-- Consistent page title --%>
                                <div class="header-buttons">
                                    <a href="ManageInventory/AddInventoryItem.jsp" class="btn btn-info" id="btnCreate">Thêm mới</a> <%-- Updated button text --%>
                                </div>
                            </div>

                            <div class="employee-grid"> <%-- Reusing employee-grid class for layout consistency --%>
                                <table class="table table-bordered"  method="post">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>ID</th>
                                            <th>Tên</th>
                                            <th>Loại</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Đơn vị</th>
                                            <th>Mô tả</th>
                                            <th>Hình ảnh</th>
                                            <th>Hành động</th> <%-- Action column title --%>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Inventory> inventoryItemList = (List<Inventory>) request.getAttribute("InventoryItemList");
                                            if (inventoryItemList != null && !inventoryItemList.isEmpty()) {
                                                int displayIndex = 1;
                                                for (Inventory listItem : inventoryItemList) {
                                        %>
                                        <tr>
                                            <Td valign="middle"><% out.print(displayIndex++); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemId()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemName()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemType()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemPrice()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemQuantity()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemUnit()); %></td>
                                            <Td valign="middle"><% out.print(listItem.getItemDescription()); %></td>
                                            <Td valign="middle">
                                                <%
                                                    String imagePath = listItem.getItemImage();
                                                    if (imagePath != null && !imagePath.isEmpty()) {
                                                %>
                                                <img src="<%= imagePath%>" alt="<%= listItem.getItemName()%>">
                                                <%
                                                    } else {
                                                        out.print("No Image");
                                                    }
                                                %>
                                            </td>
                                            <Td valign="middle">
                                                <form action="ManageInventory/UpdateInventoryItem.jsp" method="post" style="display:inline;">
                                                    <input type="hidden" name="itemId" value="<% out.print(listItem.getItemId()); %>">
                                                    <input type="hidden" name="itemName" value="<% out.print(listItem.getItemName()); %>">
                                                    <input type="hidden" name="itemType" value="<% out.print(listItem.getItemType()); %>">
                                                    <input type="hidden" name="itemPrice" value="<% out.print(listItem.getItemPrice()); %>">
                                                    <input type="hidden" name="itemQuantity" value="<% out.print(listItem.getItemQuantity()); %>">
                                                    <input type="hidden" name="itemUnit" value="<% out.print(listItem.getItemUnit()); %>">
                                                    <input type="hidden" name="itemDescription" value="<% out.print(listItem.getItemDescription());%>">
                                                    <input type="hidden" name="itemImage" value="<%= listItem.getItemImage() != null ? listItem.getItemImage() : ""%>">

                                                    <button type="submit" class="btn btn-warning">Cập nhật</button> <%-- Updated button text --%>
                                                </form>
                                                <button type="button" class="btn btn-danger" onclick="confirmDelete('<%= listItem.getItemId()%>')">Xóa</button> <%-- Updated button text --%>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="10">
                                                <div class="no-data">
                                                    Không có mục kho hàng nào.
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
    </body>
</html>