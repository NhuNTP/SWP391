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
            function confirmDelete(couponId) {
                if (confirm("Are you sure you want to DELETE this coupon?")) {
                    $.ajax({
                        url: "DeleteCouponController", // Đường dẫn đến Servlet DeleteCouponController
                        type: "POST", // Sử dụng phương thức POST để xóa
                        data: {couponId: couponId}, // Truyền couponId làm tham số
                        success: function (data) {
                            // Xử lý khi xóa thành công
                            alert("Delete coupon successfull!");
                            // Tải lại trang hoặc cập nhật lại danh sách coupon để hiển thị thay đổi
                            window.location.reload(); // Cách đơn giản nhất là tải lại trang
                            // Hoặc bạn có thể cập nhật phần tử HTML hiển thị danh sách coupon bằng jQuery
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            // Xử lý khi xóa thất bại
                            alert("Error when delete coupon: " + textStatus + ", " + errorThrown);
                        }
                    });
                }
            }
        </script>

    </head>


    <body>
        <div class="container body-content">
            <h2>MANAGE COUPON</h2>
            <p>
                <a href="ManageCoupon/AddCoupon.jsp" class="btn btn-info" id="btnCreate">Add New</a>
            </p>
            <table class="table table-bordered"  method="post">
                <tr>
                    <th>STT</th> <%-- Thêm cột STT (Số Thứ Tự) --%>
                    <th>Coupon ID</th>
                    <th>Discount Amount</th>
                    <th>Expiration Date</th>
                    <th>Quantity </th>
                </tr>
                <%
                    java.util.List<Model.Coupon> couponList = (java.util.List<Model.Coupon>) request.getAttribute("couponList");
                    if (couponList != null && !couponList.isEmpty()) {
                        int displayIndex = 1;
                        for (Model.Coupon coupon : couponList) {
                %>
                <tr>
                    <Td valign="middle"><% out.print(displayIndex++); %></td>
                    <Td valign="middle"><% out.print(coupon.getCouponId()); %></td> 
                    <Td valign="middle"><% out.print(coupon.getDiscountAmount()); %></td>
                    <Td valign="middle"><% out.print(coupon.getExpirationDate()); %></td>
                    <Td valign="middle"><% out.print(coupon.getTimesUsed()); %></td>

                    <Td valign="middle">
                        <form action="ManageCoupon/UpdateCoupon.jsp?couponID=<% out.print(coupon.getCouponId()); %>" method="post" style="display:inline;">
                            <input type="hidden" name="couponId" value="<% out.print(coupon.getCouponId()); %>">
                            <input type="hidden" name="discountAmount" value="<% out.print(coupon.getDiscountAmount()); %>">
                            <input type="hidden" name="expirationDate" value="<% out.print(coupon.getExpirationDate()); %>">
                            <input type="hidden" name="timesUsed" value="<% out.print(coupon.getTimesUsed());%>">

                            <button type="submit" class="btn btn-warning">Update</button>
                        </form>
                        <button type="button" class="btn btn-danger" onclick="confirmDelete('<%= coupon.getCouponId()%>')">Delete</button> 
                    </td>
                </tr>

                <%
                    } // end for loop
                } else {
                %>
                <tr>
                    <td colspan="6">No coupons available.</td> 
                </tr>
                <%
                    } // end if couponList not null and not empty
                %>
            </table>
        </div>

    </body>
</html>