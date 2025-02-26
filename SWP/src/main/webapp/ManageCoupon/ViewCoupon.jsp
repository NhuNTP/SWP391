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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    </head>

    <body>
        <nav class="navbar navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="#">MANAGE COUPON</a>
                </div>
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">About us</a></li>
                    <li><a href="#">Contact Us</a></li>
                </ul>
            </div>
        </nav>
        <div class="container body-content">
            <h2>MANAGE COUPON</h2>
            <p>
                <a href="ManageCoupon/AddCoupon.jsp" class="btn btn-info" id="btnCreate">Add New</a>
            </p>
            <table class="table table-bordered"  method="post">
                <tr>
                    <th>Coupon ID</th>

                    <th>Discount Amount</th>
                    <th>Expiration Date</th>
                    <th>Coupon Status</th>
                </tr>
                <%
                    java.util.List<Model.Coupon> couponList = (java.util.List<Model.Coupon>) request.getAttribute("couponList");
                    if (couponList != null && !couponList.isEmpty()) {
                        for (Model.Coupon coupon : couponList) {
                %>
                    <tr>
                        <Td valign="middle"><% out.print(coupon.getCouponId()); %></td>
                        <Td valign="middle"><% out.print(coupon.getDiscountAmount()); %></td>
                        <Td valign="middle"><% out.print(coupon.getExpirationDate()); %></td>
                        <Td valign="middle"><% out.print(coupon.isIsUsed() ? "Used" : "Not Used"); %></td>

                        <Td valign="middle">


                            <form action="ManageCoupon/UpdateCoupon.jsp?couponID=<% out.print(coupon.getCouponId()); %>" method="post" style="display:inline;">
                                <input type="hidden" name="couponId" value="<% out.print(coupon.getCouponId()); %>">
                                <input type="hidden" name="discountAmount" value="<% out.print(coupon.getDiscountAmount()); %>">
                                <input type="hidden" name="expirationDate" value="<% out.print(coupon.getExpirationDate()); %>">
                                <input type="hidden" name="isUsed" value="<% out.print(coupon.isIsUsed() ? "Used" : "Not Used"); %>">

                                <button type="submit" class="btn btn-warning">Update</button>
                            </form>

                            <form action="ManageCoupon/DeleteCoupon.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="couponId" value="<% out.print(coupon.getCouponId()); %>">
                                <input type="hidden" name="discountAmount" value="<% out.print(coupon.getDiscountAmount()); %>">
                                <input type="hidden" name="expirationDate" value="<% out.print(coupon.getExpirationDate()); %>">
                                <input type="hidden" name="isUsed" value="<% out.print(coupon.isIsUsed() ? "Used" : "Not Used"); %>">
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>

                <%
                        } // end for loop
                    } else {
                %>
                    <tr>
                        <td colspan="5">No coupons available.</td>
                    </tr>
                <%
                    } // end if couponList not null and not empty
                %>


            </table>
        </div>

    </body>
</html>