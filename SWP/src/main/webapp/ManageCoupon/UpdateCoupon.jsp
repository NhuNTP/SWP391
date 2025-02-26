<%--
    Document   : UpdateCoupon
    Created on : Feb 23, 2025, 2:46:50 PM
    Author     : DELL-Laptop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Web Application Development</title>
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
            <h4>MANAGE COUPON </h4>
            <div class="form-horizontal">
                <h5>Update</h5>
                <hr />
                <form action="../UpdateCouponController" method="POST"> <!-- Thêm thẻ <form> -->
                    <div class="form-group">
                        <div class="control-label col-md-2">Coupon ID</div>
                        <div class="col-md-10">
                            <input type="text" readonly="true" class="form-control" value="<% out.print(request.getParameter("couponId")); %>" name="couponId" required/>
                        </div>
                    </div>


                    <div class="form-group">
                        <div class="control-label col-md-2">Discount Amount</div>
                        <div class="col-md-10">
                            <input type="number" step="0.01" class="form-control" value="<% out.print(request.getParameter("discountAmount")); %>" name="discountAmount"required/>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="control-label col-md-2">Expiration Date</div>
                        <div class="col-md-10">
                            <input type="date" class="form-control" value="<% out.print(request.getParameter("expirationDate")); %>" name="expirationDate"required/>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-md-offset-2 col-md-10">
                            <input type="submit" value="Update" class="btn btn-warning" />
                            <a href="../ViewCouponController" class="btn btn-info">Back to list</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>