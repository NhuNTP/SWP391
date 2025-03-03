<%-- 
    Document   : AddCustomer
    Created on : Feb 23, 2025, 9:07:37 PM
    Author     : HuynhPhuBinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Customer</title>
</head>
<body>
    <div class="navbar">
        <span class="navbar-brand">Manage Customer</span>
    </div>

    <div class="container">
        <h2>Add Customer</h2>
        <form action="AddCustomer" method="post">
            <label for="CustomerName">Customer Name:</label>
            <input type="text" id="CustomerName" name="CustomerName" required>

            <label for="CustomerPhone">Phone:</label>
            <input type="text" id="CustomerPhone" name="CustomerPhone" required>

            <label for="NumberOfPayment">Number of Payment:</label>
            <input type="number" id="NumberOfPayment" name="NumberOfPayment" required>

            <button type="submit" class="btn-submit">Add</button>
        </form>
        <a href="ViewCustomerList" class="btn-back">Back</a>
    </div>
</body>
</html>
