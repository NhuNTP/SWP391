<%-- 
    Document   : ViewCustomerList
    Created on : Feb 22, 2025, 9:16:19 PM
    Author     : HuynhPhuBinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Customer" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer List</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
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
                max-width: 900px;
                margin: 40px auto;
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }
            h2 {
                text-align: center;
                color: #007bff;
            }
            .btn {
                display: inline-block;
                padding: 8px 12px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: bold;
                border: none;
                cursor: pointer;
                text-align: center;
            }
            .btn-add {
                background-color: #28a745;
                color: white;
                margin-bottom: 10px;
                display: block;
                text-align: center;
                width: 200px;
                margin: 10px auto;
            }
            .btn-add:hover {
                background-color: #218838;
            }
            .btn-danger {
                background-color: #dc3545;
                color: white;
            }
            .btn-danger:hover {
                background-color: #c82333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 10px;
                text-align: center;
            }
            th {
                background-color: #007bff;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            tr:hover {
                background-color: #ddd;
            }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="navbar-brand">Manage Customer</div>
        </div>

        <div class="container">
            <h2>Customer List</h2>

            <a href="AddCustomer" class="btn btn-add">Add Customer</a>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Number of Payment</th>
                    <th>Action</th>
                </tr>
                <% 
                    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
                    if (customerList != null && !customerList.isEmpty()) {
                        for (Customer customer : customerList) { 
                %>
                <tr>
                    <td><%= customer.getCustomerId()%></td>
                    <td><%= customer.getCustomerName()%></td>
                    <td><%= customer.getCustomerPhone()%></td>
                    <td><%= customer.getNumberOfPayment()%></td>
                    <td>
                        <a href="DeleteCustomer?customerId=<%= customer.getCustomerId()%>" class="btn btn-danger" 
                           onclick="return confirm('Are you sure you want to delete this customer?');">Delete</a>
                        <a href="UpdateCustomerProfile?customerId=<%= customer.getCustomerId()%>" class="btn btn-profile">Update</a>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr>
                    <td colspan="5" style="text-align: center; color: red;">No customers available!</td>
                </tr>
                <% } %>
            </table>
        </div>

    </body>
</html>


