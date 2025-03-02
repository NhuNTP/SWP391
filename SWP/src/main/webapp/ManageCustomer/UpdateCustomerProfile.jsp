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

