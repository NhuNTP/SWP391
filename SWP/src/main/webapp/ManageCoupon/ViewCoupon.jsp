<%--
    Document   : ViewCoupon
    Created on : Feb 22, 2025, 10:08:13 AM
    Author     : DELL-Laptop
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Coupon"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Coupon - Admin Dashboard</title>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <script>
            $(document).ready(function () {
                // Function để làm mới bảng coupon
                function refreshCouponTable() {
                    $.ajax({
                        url: 'ViewCoupon.jsp',
                        type: 'GET',
                        success: function (data) {
                            var newCouponTableBody = $(data).find('#couponTableBody').html();
                            $('#couponTableBody').html(newCouponTableBody);
                        },
                        error: function () {
                            alert('Failed to refresh coupon table.');
                        }
                    });
                }

                // **Xử lý Thêm Coupon**
                $('#btnAddCoupon').click(function () {
                    var discountAmount = $('#discountAmount').val();
                    var expirationDate = $('#expirationDate').val();

                    $.ajax({
                        url: 'AddCouponController',
                        type: 'POST',
                        data: {
                            discountAmount: discountAmount,
                            expirationDate: expirationDate
                        },
                        success: function (response) {
                            $('#addCouponModal').modal('hide');
                            window.location.reload(true);
                        },
                        error: function () {
                            alert('Error adding coupon.');
                        }
                    });
                });

                // **Xử lý Mở Modal Cập nhật và điền dữ liệu**
                $('.btn-update-coupon').click(function () {
                    var couponId = $(this).data('coupon-id');
                    var discountAmount = $(this).data('discount-amount');
                    var expirationDate = $(this).data('expiration-date');
                    var timesUsed = $(this).data('times-used');

                    $('#couponIdUpdate').val(couponId);
                    $('#discountAmountUpdate').val(discountAmount);
                    $('#expirationDateUpdate').val(expirationDate);
                    $('#timesUsedUpdate').val(timesUsed);
                });

                // **Xử lý Cập nhật Coupon**
                $('#btnUpdateCoupon').click(function () {
                    var couponId = $('#couponIdUpdate').val();
                    var discountAmount = $('#discountAmountUpdate').val();
                    var expirationDate = $('#expirationDateUpdate').val();
                    var timesUsed = $('#timesUsedUpdate').val();

                    $.ajax({
                        url: 'UpdateCouponController',
                        type: 'POST',
                        data: {
                            couponId: couponId,
                            discountAmount: discountAmount,
                            expirationDate: expirationDate,
                            timesUsed: timesUsed

                        },
                        success: function (response) {
                            $('#updateCouponModal').modal('hide');
                            window.location.reload(true);
                        },
                        error: function () {
                            alert('Error updating coupon.');
                        }
                    });
                });


                // **Xử lý Mở Modal Xóa và điền couponId**
                $('.btn-delete-coupon').click(function () {
                    var couponId = $(this).data('coupon-id');
                    $('#couponIdDelete').val(couponId);
                });

                // **Xử lý Xóa Coupon**
                $('#btnDeleteCouponConfirm').click(function () {
                    var couponId = $('#couponIdDelete').val();

                    $.ajax({
                        url: 'DeleteCouponController',
                        type: 'POST',
                        data: {
                            couponId: couponId
                        },
                        success: function (response) {
                            $('#deleteCouponModal').modal('hide');
                            window.location.reload(true);
                        },
                        error: function () {
                            alert('Error deleting coupon.');
                        }
                    });
                });
            });
        </script>
        <style>
            /* CSS Reset và Font (GIỮ NGUYÊN) */
            body {
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                line-height: 1.5;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }

            /* Sidebar (GIỮ NGUYÊN) */
            .sidebar {
                background: linear-gradient(to bottom, #2C3E50, #34495E);
                color: white;
                height: 100vh;
                padding-top: 20px;
            }

            .sidebar h4 {
                text-align: center;
                margin-bottom: 30px;
                color: white;
            }

            .sidebar .nav-link {
                color: white;
                padding: 10px 20px;
                display: block;
                text-decoration: none;
            }

            .sidebar .nav-link:hover {
                background-color: #1A252F;
            }

            .sidebar .nav-link i {
                margin-right: 10px;
            }

            /* Main Content Area (CHỈNH SỬA) */
            .main-content-area {
                padding: 20px;
            }

            /* Content Header (CHỈNH SỬA) */
            .content-header {
                display: flex;
                justify-content: space-between; /* Căn đều giữa search bar và header buttons */
                align-items: center;
                margin-bottom: 20px;
            }

            .content-header h2 {
                margin-top: 0;
                font-size: 24px;
            }

            .header-buttons {
                display: flex; /* Để các nút button nằm ngang hàng */
                gap: 10px; /* Khoảng cách giữa các nút */
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

            /* Search Bar (THÊM MỚI) */
            .search-bar input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: 250px; /* Điều chỉnh độ rộng nếu cần */
            }

            /* Employee Grid - Bảng Coupon (CHỈNH SỬA) */
            .employee-grid {
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 10px;
            }
            .employee-grid .table {
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

            /* Nút trong bảng - Custom Buttons (THAY ĐỔI HOÀN TOÀN) */
            .employee-grid .btn-edit, .employee-grid .btn-delete {
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
                text-decoration: none;
                cursor: pointer;
                display: inline-flex; /* Để icon và text trên cùng dòng */
                align-items: center;
                justify-content: center;
            }

            .employee-grid .btn-edit {
                background-color: #007bff; /* Màu xanh dương cho nút Edit */
            }

            .employee-grid .btn-edit:hover {
                background-color: #0056b3;
            }

            .employee-grid .btn-delete {
                background-color: #dc3545; /* Màu đỏ cho nút Delete */
                margin-left: 5px; /* Thêm khoảng cách giữa các nút */
            }

            .employee-grid .btn-delete:hover {
                background-color: #c82333;
            }

            .employee-grid .btn-edit i, .employee-grid .btn-delete i {
                margin-right: 5px; /* Khoảng cách giữa icon và text trong nút */
            }


            /* Modal (GIỮ NGUYÊN) */
            .modal .modal-header {
                background-color: #f0f0f0;
                border-bottom: 1px solid #ddd;
            }

            .modal .modal-title {
                font-weight: bold;
                font-size: 18px;
            }

            .modal .modal-body {
                padding: 20px;
            }

            .modal .modal-footer {
                padding: 15px;
                text-align: right;
                border-top: 1px solid #ddd;
            }

            .modal .modal-footer .btn {
                margin-left: 10px;
                padding: 8px 15px;
                border-radius: 5px;
                border: none;
                cursor: pointer;
            }

            .modal .modal-footer .btn-primary {
                background-color: #007bff;
                color: white;
            }

            .modal .modal-footer .btn-primary:hover {
                background-color: #0056b3;
            }

            .modal .modal-footer .btn-default, .modal .modal-footer .close-button {
                background-color: #6c757d;
                color: white;
            }

            .modal .modal-footer .btn-default:hover, .modal .modal-footer .close-button:hover {
                background-color: #5a6268;
            }

            /* Thông báo thành công/lỗi (GIỮ NGUYÊN) */
            .alert {
                padding: 10px 15px;
                margin-bottom: 15px;
                border-radius: 5px;
            }

            .alert-success {
                background-color: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }

            .alert-danger {
                background-color: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }

            /* No Data Message (GIỮ NGUYÊN) */
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Quản Lý</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-utensils me-2"></i>Quản lý món ăn</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Quản lý đặt bàn</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Quản lý nhân viên</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponList" class="nav-link active"><i class="fas fa-gift me-2"></i>Quản lý khuyến mãi</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryList" class="nav-link"><i class="fas fa-warehouse me-2"></i>Quản lý kho</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-chart-bar me-2"></i>Báo cáo doanh thu</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-cog me-2"></i>Cài đặt</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="container-fluid">
                        <main class="content-area">
                            <div class="content-header">
                                <div class="search-bar"> <%-- Thanh tìm kiếm --%>
                                    <input type="text" placeholder="Tìm theo mã, tên coupon">
                                </div>
                                <div class="header-buttons">
                                    <button type="button" class="btn btn-info add-coupon-btn" data-toggle="modal" data-target="#addCouponModal">Thêm mới</button>
                                </div>
                            </div>

                            <div class="employee-grid"> <%-- Đổi class thành employee-grid cho nhất quán --%>
                                <div id="updateSuccessLabel" class="alert alert-success" role="alert" style="display: none; margin-bottom: 10px;">
                                    <span class="glyphicon glyphicon-ok-sign" aria-hidden="true"></span>
                                    <span class="sr-only">Success:</span>
                                    Coupon updated successfully!
                                </div>
                                <div id="updateErrorLabel" class="alert alert-danger" role="alert" style="display: none; margin-bottom: 10px;">
                                    <span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span>
                                    <span class="sr-only">Error:</span>
                                    Update coupon failed!
                                </div>
                                <table class="table table-bordered"  method="post">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Coupon ID</th>
                                            <th>Discount Amount</th>
                                            <th>Expiration Date</th>
                                            <th>Quantity</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="couponTableBody">
                                        <%
                                            List<Coupon> couponList = (List<Coupon>) request.getAttribute("couponList");
                                            if (couponList != null && !couponList.isEmpty()) {
                                                int displayIndex = 1;
                                                for (Coupon coupon : couponList) {
                                        %>
                                        <tr id="couponRow<%=coupon.getCouponId()%>">
                                            <Td valign="middle"><% out.print(displayIndex++); %></td>
                                            <Td valign="middle"><% out.print(coupon.getCouponId()); %></td>
                                            <Td valign="middle"><% out.print(coupon.getDiscountAmount()); %></td>
                                            <Td valign="middle"><% out.print(coupon.getExpirationDate()); %></td>
                                            <Td valign="middle"><% out.print(coupon.getTimesUsed());%></td>
                                            <Td valign="middle">
                                                <a href="#" class="btn-edit btn-update-coupon"  <%-- Đổi class và dùng <a> tag --%>
                                                   data-coupon-id="<%= coupon.getCouponId()%>"
                                                   data-discount-amount="<%= coupon.getDiscountAmount()%>"
                                                   data-expiration-date="<%= coupon.getExpirationDate()%>"
                                                   data-times-used="<%= coupon.getTimesUsed()%>"
                                                   data-toggle="modal" data-target="#updateCouponModal">
                                                    <i class="fas fa-edit"></i> Sửa <%-- Thêm icon và text --%>
                                                </a>
                                                <a href="#" class="btn-delete btn-delete-coupon" <%-- Đổi class và dùng <a> tag --%>
                                                   data-coupon-id="<%= coupon.getCouponId()%>"
                                                   data-toggle="modal" data-target="#deleteCouponModal">
                                                    <i class="fas fa-trash-alt"></i> Xóa <%-- Thêm icon và text --%>
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="6">
                                                <div class="no-data">
                                                    Không có coupon nào.
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

        <!-- Modal Thêm mới Coupon (GIỮ NGUYÊN) -->
        <div class="modal fade" id="addCouponModal" tabindex="-1" role="dialog" aria-labelledby="addCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="addCouponModalLabel">Thêm mới Coupon</h4>
                    </div>
                    <div class="modal-body modal-form-container">
                        <form id="addCouponForm">
                            <div class="form-group">
                                <label for="discountAmount">Discount Amount:</label>
                                <input type="number" class="form-control" id="discountAmount" name="discountAmount" required>
                            </div>
                            <div class="form-group">
                                <label for="expirationDate">Expiration Date:</label>
                                <input type="date" class="form-control" id="expirationDate" name="expirationDate" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer modal-actions">
                        <button type="button" class="btn btn-default close-button" data-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="btnAddCoupon">Thêm Coupon</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Cập nhật Coupon (GIỮ NGUYÊN) -->
        <div class="modal fade" id="updateCouponModal" tabindex="-1" role="dialog" aria-labelledby="updateCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="updateCouponModalLabel">Cập nhật Coupon</h4>
                    </div>
                    <div class="modal-body modal-form-container">
                        <form id="updateCouponForm">
                            <input type="hidden" id="couponIdUpdate" name="couponId">
                            <div class="form-group">
                                <label for="discountAmountUpdate">Discount Amount:</label>
                                <input type="number" class="form-control" id="discountAmountUpdate" name="discountAmount" required>
                            </div>
                            <div class="form-group">
                                <label for="expirationDateUpdate">Expiration Date:</label>
                                <input type="date" class="form-control" id="expirationDateUpdate" name="expirationDate" required>
                            </div>
                            <div class="form-group">
                                <label for="timesUsedUpdate">Quantity:</label>
                                <input type="number" class="form-control" id="timesUsedUpdate" name="timesUsed" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer modal-actions">
                        <button type="button" class="btn btn-default close-button" data-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="btnUpdateCoupon">Lưu thay đổi</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xóa Coupon (GIỮ NGUYÊN) -->
        <div class="modal fade" id="deleteCouponModal" tabindex="-1" role="dialog" aria-labelledby="deleteCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="deleteCouponModalLabel">Xác nhận xóa</h4>
                    </div>
                    <div class="modal-body modal-form-container">
                        <p>Bạn có chắc chắn muốn xóa coupon này?</p>
                        <input type="hidden" id="couponIdDelete" >
                    </div>
                    <div class="modal-footer modal-actions">
                        <button type="button" class="btn btn-default close-button" data-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteCouponConfirm">Xóa Coupon</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>