<%@page import="java.util.List"%>
<%@page import="Model.Coupon"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Coupon - Admin Dashboard</title>
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
                background-color: #fcfcf7;
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

            /* Main Content Area */
            .main-content-area {
                padding: 20px;
            }

            /* Content Header */
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

            /* Search Bar */
            .search-bar input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
                width: 250px;
            }
            .modal-header{
                background-color: #f7f7f0
            }
            /* Table Styles */
            .table-responsive {
                overflow-x: auto;
            }

            /* Nút trong bảng */
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
            #couponIdUpdateDisplay{
                background-color: #fcfcf7
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

            /* No Data Message */
            .no-data {
                padding: 20px;
                text-align: center;
                color: #777;
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
            <!-- Sidebar -->
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4 main-content-area">
                <section class="main-content">
                    <div class="text-left mb-4">
                        <h4>Coupon Management</h4>
                    </div>
                    <div class="container-fluid">
                        <main>
                            <div class="content-header">
                                <div class="search-bar">
                                    <input type="text" class="form-control" placeholder="Search by Description" id="couponSearchInput">
                                </div>
                                <div class="header-buttons">
                                    <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addCouponModal">
                                        Add New
                                    </button>
                                </div>

                            </div>

                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>No.</th>
                                            <th>Coupon ID</th>
                                            <th>Discount Amount</th>
                                            <th>Expiration Date</th>
                                            <th>Times Used</th>
                                            <th>Description</th>
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
                                            <td><%= displayIndex++%></td>
                                            <td><%= coupon.getCouponId()%></td>
                                            <td><%= coupon.getDiscountAmount()%></td>
                                            <td><%= coupon.getExpirationDate()%></td>
                                            <td><%= coupon.getTimesUsed()%></td>
                                            <td><%= coupon.getDescription()%></td>
                                            <td>
                                                <button type="button" class="btn btn-edit btn-update-coupon"
                                                        data-bs-toggle="modal" data-bs-target="#updateCouponModal"
                                                        data-coupon-id="<%= coupon.getCouponId()%>"
                                                        data-discount-amount="<%= coupon.getDiscountAmount()%>"
                                                        data-expiration-date="<%= coupon.getExpirationDate()%>"
                                                        data-times-used="<%= coupon.getTimesUsed()%>"
                                                        data-description="<%= coupon.getDescription()%>">
                                                    <i class="fas fa-edit"></i> Update
                                                </button>
                                                <button type="button" class="btn btn-delete btn-delete-coupon"
                                                        data-bs-toggle="modal" data-bs-target="#deleteCouponModal"
                                                        data-coupon-id="<%= coupon.getCouponId()%>">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="7">
                                                <div class="no-data">
                                                    Coupon Not Found.
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

        <!-- Add Coupon Modal -->
        <div class="modal fade" id="addCouponModal" tabindex="-1" aria-labelledby="addCouponModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCouponModalLabel">Add New Coupon</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addCouponForm">

                            <div class="mb-3 row"> 
                                <label for="discountAmount" class="col-sm-4 col-form-label">Discount Amount:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="number" class="form-control" id="discountAmount" name="discountAmount" required min="1" max="100" step="0.01">
                                    <small class="text-muted">Enter a non-negative number.</small>
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="expirationDate" class="col-sm-4 col-form-label">Expiration Date:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="date" class="form-control" id="expirationDate" name="expirationDate" required>
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="description" class="col-sm-4 col-form-label">Description:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <textarea class="form-control" id="description" name="description" rows="2" required=""></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnAddCoupon">Add Coupon</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Update Coupon Modal -->
        <div class="modal fade" id="updateCouponModal" tabindex="-1" aria-labelledby="updateCouponModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateCouponModalLabel">Update Coupon</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateCouponForm">
                            <input type="hidden" id="couponIdUpdate" name="couponId">
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="couponIdUpdateDisplay" class="col-sm-4 col-form-label">Coupon ID(Just View):</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="text" class="form-control" id="couponIdUpdateDisplay" readonly >
                                    <input type="hidden" id="couponIdUpdate" name="couponId">
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="discountAmountUpdate" class="col-sm-4 col-form-label">Discount Amount:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="number" class="form-control" id="discountAmountUpdate" name="discountAmount" min="0" max="100" required step="0.01">
                                    <small class="text-muted">Enter a non-negative number.</small>
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="expirationDateUpdate" class="col-sm-4 col-form-label">Expiration Date:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="date" class="form-control" id="expirationDateUpdate" name="expirationDate" required="">
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="timesUsedUpdate" class="col-sm-4 col-form-label">Times Used:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <input type="number" class="form-control" id="timesUsedUpdate" name="timesUsed" required min="0">
                                    <small class="text-muted">Enter a non-negative integer.</small>
                                </div>
                            </div>
                            <div class="mb-3 row"> <!- Thêm class 'row' vào div.mb-3 -->
                                <label for="descriptionUpdate" class="col-sm-4 col-form-label">Description:</label> <!- Thêm class 'col-sm-4' và 'col-form-label' cho label -->
                                <div class="col-sm-8"> <!- Bọc input trong một div với class 'col-sm-8' -->
                                    <textarea class="form-control" id="descriptionUpdate" name="description" rows="2" required=""></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnUpdateCoupon">Save change</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Delete Coupon Modal -->
        <div class="modal fade" id="deleteCouponModal" tabindex="-1" aria-labelledby="deleteCouponModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteCouponModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to DELETE this coupon?</p>
                        <input type="hidden" id="couponIdDelete">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteCouponConfirm">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5.3.0 JS (bao gồm Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
        <script>
            $(document).ready(function () {
                bindEventHandlers(); // Gọi bindEventHandlers ngay từ đầu

                // **Xử lý Thêm Coupon**
                $('#btnAddCoupon').click(function () {
                    const expirationDateInput = $('#expirationDate')[0];
                    const form = document.getElementById('addCouponForm');
                    const expirationDateValue = expirationDateInput.value;
                    const dateRegex = /^\d{4}-\d{2}-\d{2}$/; // Regex cho yyyy-MM-dd
                    if (!expirationDateValue) {
                        expirationDateInput.setCustomValidity('Vui lòng chọn ngày hết hạn.'); // Bắt buộc chọn ngày (required)
                    } else if (!dateRegex.test(expirationDateValue)) {
                        expirationDateInput.setCustomValidity('Định dạng ngày hết hạn không hợp lệ. Vui lòng nhập theo định dạng.');
                    } else {
                        const dateObj = new Date(expirationDateValue);
                        if (isNaN(dateObj.getTime())) { // Kiểm tra ngày tháng có hợp lệ không (ví dụ: 2024-02-30 là không hợp lệ)
                            expirationDateInput.setCustomValidity('Ngày hết hạn không hợp lệ. Vui lòng nhập ngày tháng hợp lệ.');
                        } else {
                            expirationDateInput.setCustomValidity(''); // Hợp lệ, xóa thông báo lỗi
                        }
                    }


                    if (!form.checkValidity()) { // Kiểm tra form có hợp lệ không (bao gồm cả custom validity)
                        event.preventDefault();
                        form.reportValidity();
                        return;
                    }

                    var discountAmount = $('#discountAmount').val();
                    var expirationDate = $('#expirationDate').val();
                    var description = $('#description').val();


                    $.ajax({
                        url: 'AddCouponController',
                        type: 'POST',
                        data: {

                            discountAmount: discountAmount,
                            expirationDate: expirationDate,
                            description: description
                        },
                        success: function () {
                            var addCouponModal = bootstrap.Modal.getInstance(document.getElementById('addCouponModal'));
                            addCouponModal.hide();
                            reloadViewCoupon();
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Coupon added successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                            $('#addCouponForm')[0].reset(); // Reset form sau khi thành công
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error adding coupon: ' + error
                            });
                        }
                    });
                });


                // **Xử lý Cập nhật Coupon**
                $('#btnUpdateCoupon').click(function () {
                    const expirationDateInputUpdate = $('#expirationDateUpdate')[0];
                    const formUpdate = document.getElementById('updateCouponForm');
                    const expirationDateValueUpdate = expirationDateInputUpdate.value;
                    const dateRegex = /^\d{4}-\d{2}-\d{2}$/; // Regex cho yyyy-MM-dd

                    if (expirationDateValueUpdate && !dateRegex.test(expirationDateValueUpdate)) { // Kiểm tra định dạng nếu có nhập
                        expirationDateInputUpdate.setCustomValidity('Định dạng ngày hết hạn không hợp lệ. Vui lòng nhập theo định dạng.');
                    } else if (expirationDateValueUpdate) { // Kiểm tra ngày hợp lệ nếu có nhập
                        const dateObj = new Date(expirationDateValueUpdate);
                        if (isNaN(dateObj.getTime())) {
                            expirationDateInputUpdate.setCustomValidity('Ngày hết hạn không hợp lệ. Vui lòng nhập ngày tháng hợp lệ.');
                        } else {
                            expirationDateInputUpdate.setCustomValidity('');
                        }
                    } else {
                        expirationDateInputUpdate.setCustomValidity(''); // Không có lỗi nếu không nhập (vì không required ở js validation này, nếu muốn required thì thêm if (!expirationDateValueUpdate) ...)
                    }


                    if (!formUpdate.checkValidity()) {
                        event.preventDefault();
                        formUpdate.reportValidity();
                        return;
                    }


                    var couponId = $('#couponIdUpdate').val();
                    var discountAmount = $('#discountAmountUpdate').val();
                    var expirationDate = $('#expirationDateUpdate').val();
                    var timesUsed = $('#timesUsedUpdate').val();
                    var description = $('#descriptionUpdate').val();


                    $.ajax({
                        url: 'UpdateCouponController',
                        type: 'POST',
                        data: {
                            couponId: couponId,
                            discountAmount: discountAmount,
                            expirationDate: expirationDate,
                            timesUsed: timesUsed,
                            description: description
                        },
                        success: function (response) {
                            var updateCouponModal = bootstrap.Modal.getInstance(document.getElementById('updateCouponModal'));
                            updateCouponModal.hide();
                            reloadViewCoupon();
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Coupon updated successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        },
                        error: function (error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error updating coupon: ' + error
                            });
                        }
                    });
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
                            var deleteCouponModal = bootstrap.Modal.getInstance(document.getElementById('deleteCouponModal'));
                            deleteCouponModal.hide();

                            // Xóa dòng vừa xóa
                            $('#couponRow' + couponId).remove();

                            // Kiểm tra xem còn coupon nào không sau khi xóa
                            if ($('#couponTableBody tr').length === 0) {
                                $('#couponTableBody').html('<tr><td colspan="7"><div class="no-data">Không có coupon nào.</div></td></tr>');
                            }
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Coupon deleted successfully.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Error deleting coupon: ' + error
                            });
                        }
                    });
                });
            });

            function bindEventHandlers() {
                $(document).on('click', '.btn-update-coupon', function () {
                    var couponId = $(this).data('coupon-id');
                    var discountAmount = $(this).data('discount-amount');
                    var expirationDate = $(this).data('expiration-date');
                    var timesUsed = $(this).data('times-used');
                    var description = $(this).data('description');

                    $('#couponIdUpdate').val(couponId);
                    $('#couponIdUpdateDisplay').val(couponId); // Display Coupon ID in update modal
                    $('#discountAmountUpdate').val(discountAmount);
                    $('#expirationDateUpdate').val(expirationDate);
                    $('#timesUsedUpdate').val(timesUsed);
                    $('#descriptionUpdate').val(description);
                });

                $(document).on('click', '.btn-delete-coupon', function () {
                    var couponId = $(this).data('coupon-id');
                    $('#couponIdDelete').val(couponId);
                });
            }

            function reloadViewCoupon() {
                $.get('ViewCouponController', function (data) {
                    var newBody = $(data).find('tbody').html();
                    $('tbody').html(newBody);
                    bindEventHandlers(); // Re-bind sau khi reload
                });
            }

            // ******************* BẮT ĐẦU ĐOẠN CODE THÊM VÀO CHO TÌM KIẾM *******************
            $(document).ready(function () {
                const searchInput = document.getElementById('couponSearchInput');
                const couponTableBody = document.getElementById('couponTableBody');
                const rows = couponTableBody.querySelectorAll('tr');

                searchInput.addEventListener('keyup', function () {
                    const searchTerm = searchInput.value.toLowerCase();

                    rows.forEach(row => {
                        const descriptionCell = row.querySelector('td:nth-child(6)'); // Search in Description column (6th column)
                        if (descriptionCell) {
                            const descriptionText = descriptionCell.textContent.toLowerCase();
                            if (descriptionText.includes(searchTerm)) {
                                row.style.display = "Coupon not found"; // Show row if description matches
                            } else {
                                row.style.display = "none"; // Hide row if no match
                            }
                        } else {
                            row.style.display = "none"; // Hide row if description cell is not found (shouldn't happen)
                        }
                    });
                });
            });
            // ******************* KẾT THÚC ĐOẠN CODE THÊM VÀO CHO TÌM KIẾM *******************

        </script>
    </body>
</html>