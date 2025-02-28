<%@ page import="Model.Dish" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Admin - Quản Lý Quán Ăn</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    /* Custom Styles */
    body {
      font-family: 'Roboto', sans-serif;
      background-color: #f8f9fa;
    }

    .sidebar {
      background: linear-gradient(to bottom, #2C3E50, #34495E);
      color: white;
      height: 100vh;
    }

    .sidebar a {
      color: white;
      text-decoration: none;
    }

    .sidebar a:hover {
      background-color: #1A252F;
    }

    .card-stats {
      background: linear-gradient(to right, #4CAF50, #81C784);
      color: white;
    }

    .card-stats i {
      font-size: 2rem;
    }

    .chart-container {
      position: relative;
      height: 300px;
    }
  </style>
</head>
<body>
  <!-- Sidebar -->
  <div class="d-flex">
    <div class="sidebar col-md-2 p-3">
      <h4 class="text-center mb-4">Quản Lý</h4>
      <ul class="nav flex-column">
        <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-utensils me-2"></i>Quản lý món ăn</a></li>
        <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Quản lý đơn hàng</a></li>
        <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-users me-2"></i>Quản lý nhân viên</a></li>
        <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-chart-bar me-2"></i>Báo cáo doanh thu</a></li>
        <li class="nav-item"><a href="#" class="nav-link"><i class="fas fa-cog me-2"></i>Cài đặt</a></li>
      </ul>
    </div>

<div>
  <h3>Danh sách món ăn</h3>

  <!-- Thông báo -->
  <% if (request.getSession().getAttribute("message") != null) { %>
    <div class="alert alert-success">
      <%= request.getSession().getAttribute("message") %>
    </div>
    <% request.getSession().removeAttribute("message"); %>
  <% } %>

  <% if (request.getSession().getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger">
      <%= request.getSession().getAttribute("errorMessage") %>
    </div>
    <% request.getSession().removeAttribute("errorMessage"); %>
  <% } %>

  <!-- Bảng danh sách món ăn -->
  <%
    List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
    if (dishList != null && !dishList.isEmpty()) {
  %>
  <table class="table table-bordered table-striped">
    <thead class="table-dark">
      <tr>
        <th>ID</th>
        <th>Tên món</th>
        <th>Loại</th>
        <th>Giá</th>
        <th>Mô tả</th>
        <th>Hình ảnh</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% for (Dish dish : dishList) { %>
      <tr>
        <td><%= dish.getDishId() %></td>
        <td><%= dish.getDishName() %></td>
        <td><%= dish.getDishType() %></td>
        <td><%= dish.getDishPrice() %> VNĐ</td>
        <td><%= dish.getDishDescription() %></td>
        <td><img src="<%= dish.getDishImage() %>" alt="Hình ảnh món ăn" width="100"></td>
        <td>
          <a href="updatedish?dishId=<%= dish.getDishId() %>" class="btn btn-warning btn-sm">Sửa</a>
          <form action="deletedish" method="post" style="display:inline;">
            <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
            <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
          </form>
          <a href="dishdetail?dishId=<%= dish.getDishId() %>" class="btn btn-info btn-sm">Chi tiết</a>
        </td>
      </tr>
      <% } %>
    </tbody>
  </table>
  <% } else { %>
    <p class="text-muted">Không có món ăn nào.</p>
  <% } %>

  <!-- Nút thêm món ăn -->
  <a href="addnewdish" class="btn btn-primary">Thêm món ăn mới</a>
</div>
  </div>