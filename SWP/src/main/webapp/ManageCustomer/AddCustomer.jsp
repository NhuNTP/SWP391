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
    <style>
        /* Đưa navbar sát viền trang */
        .navbar {
            background-color: #0056b3;
            padding: 12px 15px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            width: 100%;
            margin: 0;
            padding: 12px 15px;
            box-sizing: border-box;
        }

        .navbar-brand {
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }

        /* Định dạng lại body để không có khoảng trắng */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        h2 {
            font-size: 2.2rem;
            margin-bottom: 25px;
            color: #333;
            text-align: center;
        }

        .container {
            max-width: 500px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            background-color: white;
        }

        label {
            font-size: 16px;
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn-submit {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            margin-top: 15px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-submit:hover {
            background-color: #218838;
        }

        .btn-back {
            display: block;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .btn-back:hover {
            background-color: #0056b3;
        }
    </style>
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

