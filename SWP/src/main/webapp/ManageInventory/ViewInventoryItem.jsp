<%-- 
    Document   : ViewIntentoryItem
    Created on : Feb 23, 2025, 9:43:14 PM
    Author     : DELL-Laptop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Inventory</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    </head>

    <body>
        <nav class="navbar navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="#">MANAGE INVENTORY</a>
                </div>

            </div>
        </nav>
        <div class="container body-content">
            <h2>MANAGE INVENTORY</h2>
            <p>
                <a href="ManageCoupon/AddCoupon.jsp" class="btn btn-info" id="btnCreate">Add New</a>
            </p>
            <table class="table table-bordered"  method="post">
                <tr>
                    <th> ID</th>
                    <th> Name</th>
                    <th> Type</th>
                    <th> Price</th>
                    <th> Quantity</th>
                    <th> Unit</th>
                    <th> Description</th>

                    
                  
                </tr>
                  <c:forEach items="${requestScope.inventoryItemList}" var="listItem">
                    <tr>
                        <Td valign="middle">${listItem.ItemId}</td> 
                        <Td valign="middle">${listItem.ItemName}</td>
                        <Td valign="middle">${listItem.ItemType}</td>
                        <Td valign="middle">${listItem.ItemPrice}</td>
                        <Td valign="middle">${listItem.ItemQuantiry}</td>
                        <Td valign="middle">${listItem.ItemUnit}</td>
                        <Td valign="middle">${listItem.ItemDescription}</td>
                        
                      

                        <Td valign="middle">


                            <form action="ManageCoupon/UpdateCoupon.jsp?couponID=${coupon.couponId}" method="post" style="display:inline;">
                                <input type="hidden" name="couponId" value="${coupon.couponId}">
                                <input type="hidden" name="discountAmount" value="${coupon.discountAmount}">
                                <input type="hidden" name="expirationDate" value="${coupon.expirationDate}">
                                <input type="hidden" name="isUsed" value="${coupon.isUsed?'Used':'Not Used'}">

                                <button type="submit" class="btn btn-warning">Update</button>
                            </form>

                            <form action="ManageCoupon/DeleteCoupon.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="couponId" value="${coupon.couponId}">
                                <input type="hidden" name="discountAmount" value="${coupon.discountAmount}">
                                <input type="hidden" name="expirationDate" value="${coupon.expirationDate}">
                                <input type="hidden" name="isUsed" value="${coupon.isUsed?'Used':'Not Used'}">
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>

                </c:forEach>


            </table>
        </div>

    </body>
</html>
