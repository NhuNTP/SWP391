<%--
    Document   : ViewCoupon
    Created on : Feb 22, 2025, 10:08:13 AM
    Author     : DELL-Laptop
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Coupon</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> <%-- Updated to jQuery 3.6.0 for better compatibility --%>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

        <script>
            $(document).ready(function () {
                // Function để làm mới bảng coupon (gọi lại server để lấy dữ liệu mới nhất)
                function refreshCouponTable() {
                    $.ajax({
                        url: 'ViewCoupon.jsp', // Thay đổi URL này nếu endpoint lấy dữ liệu coupon khác
                        type: 'GET',
                        success: function (data) {
                            // Giả sử server trả về HTML của bảng coupon trong data
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
                        url: 'AddCouponController', // Thay 'AddCouponServlet' bằng URL servlet/controller xử lý thêm coupon
                        type: 'POST',
                        data: {
                            discountAmount: discountAmount,
                            expirationDate: expirationDate
                        },
                        success: function (response) {
                            $('#addCouponModal').modal('hide');
                            window.location.reload(true);
//                            if (response === 'success') {
//                                $('#addCouponModal').modal('hide'); // Ẩn modal sau khi thêm thành công
//                                $('#addCouponForm')[0].reset(); // Reset form
//                                refreshCouponTable(); // Làm mới bảng
//                                // Hiển thị thông báo thành công (có thể thêm div thông báo thành công nếu cần)
//                                alert('Coupon added successfully!');
//                            } else {
//                                // Hiển thị thông báo lỗi (có thể thêm div thông báo lỗi nếu cần)
//                                alert('Failed to add coupon.');
//                            }
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
                        url: 'UpdateCouponController', // Thay 'UpdateCouponServlet' bằng URL servlet/controller xử lý cập nhật coupon
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
//                            if (response === 'success') {
//                                
//                            $('#updateCouponModal').modal('hide');
//                                $('#updateCouponModal').modal('hide'); // Ẩn modal
//                                $('#updateSuccessLabel').show(); // Hiển thị thông báo thành công
//                                $('#updateErrorLabel').hide(); // Ẩn thông báo lỗi nếu đang hiển thị
//                                // Cập nhật trực tiếp dòng trong bảng mà không cần refresh toàn bộ bảng
//                                var rowId = "#couponRow" + couponId;
//                                $(rowId).find('td:nth-child(3)').text(discountAmount); // Cột Discount Amount
//                                $(rowId).find('td:nth-child(4)').text(expirationDate); // Cột Expiration Date
//
//                                // Ẩn thông báo thành công sau vài giây (tùy chọn)
//                                setTimeout(function () {
//                                    $('#updateSuccessLabel').fadeOut('slow');
//                                }, 3000); // 3 giây
//                            } else {
//                                 $('#updateCouponModal').modal('hide');
//                                $('#updateErrorLabel').show(); // Hiển thị thông báo lỗi
//                                $('#updateSuccessLabel').hide(); // Ẩn thông báo thành công nếu đang hiển thị
//                                // Ẩn thông báo lỗi sau vài giây (tùy chọn)
//                                setTimeout(function () {
//                                    $('#updateErrorLabel').fadeOut('slow');
//                                }, 3000); // 3 giây
//                            }
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
                        url: 'DeleteCouponController', // Thay 'DeleteCouponServlet' bằng URL servlet/controller xử lý xóa coupon
                        type: 'POST',
                        data: {
                            couponId: couponId
                        },
                        success: function (response) {
                            $('#deleteCouponModal').modal('hide'); // Ẩn modal
                            window.location.reload(true);
//                            if (response === 'success') {
//                                $('#deleteCouponModal').modal('hide'); // Ẩn modal
//                                $("#couponRow" + couponId).remove(); // Xóa dòng khỏi bảng
//                                // Hiển thị thông báo thành công (tùy chọn)
//                                alert('Coupon deleted successfully!');
//                            } else {
//                                // Hiển thị thông báo lỗi (tùy chọn)
//                                alert('Failed to delete coupon.');
//                            }
                        },
                        error: function () {
                            alert('Error deleting coupon.');
                        }
                    });
                });
            });
        </script>
    </head>

    <body>
        <div class="container body-content">
            <h2>MANAGE COUPON</h2>
            <p>
                <button type="button" class="btn btn-info" id="btnCreate" data-toggle="modal" data-target="#addCouponModal">Add New</button> <%-- Nút mở modal Thêm mới --%>
            </p>
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
                        <th>Actions</th> <%-- Thêm cột Actions --%>
                    </tr>
                </thead>
                <tbody id="couponTableBody"> <%-- Thêm tbody để dễ thao tác với jQuery --%>
                    <%
                        java.util.List<Model.Coupon> couponList = (java.util.List<Model.Coupon>) request.getAttribute("couponList");
                        if (couponList != null && !couponList.isEmpty()) {
                            int displayIndex = 1;
                            for (Model.Coupon coupon : couponList) {
                    %>
                    <tr id="couponRow<%=coupon.getCouponId()%>"> <%-- Thêm ID cho mỗi dòng coupon --%>
                        <Td valign="middle"><% out.print(displayIndex++); %></td>
                        <Td valign="middle"><% out.print(coupon.getCouponId()); %></td>
                        <Td valign="middle"><% out.print(coupon.getDiscountAmount()); %></td>
                        <Td valign="middle"><% out.print(coupon.getExpirationDate()); %></td>
                        <Td valign="middle"><% out.print(coupon.getTimesUsed());%></td>
                        <Td valign="middle">
                            <button type="button" class="btn btn-warning btn-update-coupon"
                                    data-coupon-id="<%= coupon.getCouponId()%>"
                                    data-discount-amount="<%= coupon.getDiscountAmount()%>"
                                    data-expiration-date="<%= coupon.getExpirationDate()%>"
                                    data-times-used="<%= coupon.getTimesUsed()%>"
                                    data-toggle="modal" data-target="#updateCouponModal">Update</button>
                            <button type="button" class="btn btn-danger btn-delete-coupon"
                                    data-coupon-id="<%= coupon.getCouponId()%>"
                                    data-toggle="modal" data-target="#deleteCouponModal">Delete</button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="6">No coupons available.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <!-- Modal Thêm mới Coupon -->
        <div class="modal fade" id="addCouponModal" tabindex="-1" role="dialog" aria-labelledby="addCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="addCouponModalLabel">Add New Coupon</h4>
                    </div>
                    <div class="modal-body">
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
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnAddCoupon">Add Coupon</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Cập nhật Coupon -->
        <div class="modal fade" id="updateCouponModal" tabindex="-1" role="dialog" aria-labelledby="updateCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="updateCouponModalLabel">Update Coupon</h4>
                    </div>
                    <div class="modal-body">
                        <form id="updateCouponForm">
                            <input type="hidden" id="couponIdUpdate" name="couponId"> <%-- Hidden input để lưu couponId --%>
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
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnUpdateCoupon">Update Coupon</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xóa Coupon -->
        <div class="modal fade" id="deleteCouponModal" tabindex="-1" role="dialog" aria-labelledby="deleteCouponModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="deleteCouponModalLabel">Confirm Delete</h4>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this coupon?</p>
                        <input type="hidden" id="couponIdDelete" > <%-- Hidden input để lưu couponId cần xóa --%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="btnDeleteCouponConfirm">Delete Coupon</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>