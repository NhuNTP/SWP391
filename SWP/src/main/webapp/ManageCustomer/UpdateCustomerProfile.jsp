<%-- 
    Document   : UpdateCustomerProfile
    Created on : Feb 23, 2025, 8:52:09 PM
    Author     : HuynhPhuBinh
--%>

<%-- 
    Document   : UpdateCustomerProfile
    Created on : Feb 23, 2025, 8:52:09 PM
    Author     : HuynhPhuBinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Customer" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Customer Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #0056b3;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: white;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }

        h2 {
            text-align: center;
            color: #007bff;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }

        input {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            width: 100%;
            padding: 10px;
            text-align: center;
            display: inline-block;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .btn-update {
            background-color: #007bff;
            color: white;
        }

        .btn-update:hover {
            background-color: #0056b3;
        }

        .btn-cancel {
            background-color: #dc3545;
            color: white;
            margin-top: 10px;
        }

        .btn-cancel:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="navbar-brand">Manage Customer</div>
    </div>

    <div class="container">
        <h2>Update Customer Profile</h2>
        <% Customer customer = (Customer) request.getAttribute("customer"); 
           if (customer != null) { %>
            <form action="UpdateCustomerProfile" method="post">
                <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">

                <label for="customerName">Customer Name:</label>
                <input type="text" id="customerName" name="customerName" value="<%= customer.getCustomerName() %>" required>

                <label for="customerPhone">Phone:</label>
                <input type="text" id="customerPhone" name="customerPhone" value="<%= customer.getCustomerPhone() %>" required>

                <label for="numberOfPayment">Number of Payment:</label>
                <input type="number" id="numberOfPayment" name="numberOfPayment" value="<%= customer.getNumberOfPayment() %>" required>

                <button type="submit" class="btn btn-update">Update</button>
            </form>
            <a href="ViewCustomerList" class="btn btn-cancel">Cancel</a>
        <% } else { %>
            <p style="text-align:center; color:red;">Customer is not available!</p>
            <a href="ViewCustomerList" class="btn btn-cancel">Back</a>
        <% } %>
    </div>

</body>
</html>

