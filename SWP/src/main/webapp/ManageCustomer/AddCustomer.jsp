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
            <label for="customerName">Customer Name:</label>
            <input type="text" id="customerName" name="customerName" required>

            <label for="customerPhone">Phone:</label>
            <input type="text" id="customerPhone" name="customerPhone" required>

            <label for="numberOfPayment">Number of Payment:</label>
            <input type="number" id="numberOfPayment" name="numberOfPayment" required>

            <button type="submit" class="btn-submit">Add</button>
        </form>
        <a href="ViewCustomerList" class="btn-back">Back</a>
    </div>

</body>
</html>

