<%@ page import="Model.Dish" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Món Ăn</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

            .dish-card {
                border: 1px solid #ddd;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
                text-align: center;
                transition: transform 0.3s ease;
            }

            .dish-card:hover {
                transform: scale(1.05);
            }

            .dish-card img {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
            }

            .dish-card h5 {
                margin-top: 10px;
                font-size: 1.2rem;
                color: #333;
            }

            .dish-card p.price {
                font-size: 1rem;
                color: #e74c3c;
                font-weight: bold;
            }

            .search-bar {
                margin-bottom: 20px;
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <div class="d-flex">
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-utensils me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Inventory Management</a></li>
                </ul>
            </div>

            <div class="col-md-10 p-4">
                <h3>Danh sách món ăn</h3>

                <!-- Thông báo -->
                <% if (request.getSession().getAttribute("message") != null) {%>
                <div class="alert alert-success">
                    <%= request.getSession().getAttribute("message")%>
                </div>
                <% request.getSession().removeAttribute("message"); %>
                <% } %>

                <% if (request.getSession().getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger">
                    <%= request.getSession().getAttribute("errorMessage")%>
                </div>
                <% request.getSession().removeAttribute("errorMessage"); %>
                <% } %>

                <!-- Thanh tìm kiếm -->
                <form class="search-bar" method="GET" action="${pageContext.request.contextPath}/viewalldish">
                    <div class="input-group">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm món ăn...">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </div>
                </form>

                <!-- Danh sách món ăn dạng card -->
                <%
                    List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
                    if (dishList != null && !dishList.isEmpty()) {
                %>
                <div class="row">
                    <% for (Dish dish : dishList) {%>
                    <div class="col-md-4">
                        <div class="dish-card">
                            <img src="<%= dish.getDishImage()%>" alt="Hình ảnh món ăn">
                            <h5><%= dish.getDishName()%></h5>
                            <p class="price"><%= dish.getDishPrice()%> VNĐ</p>
                            <p>Status: <%= dish.getDishStatus()%></p>
                            <p>Ingredients: <%= dish.getIngredientStatus()%></p>
                            <div class="actions">
                                <a href="updatedish?dishId=<%= dish.getDishId()%>" class="btn btn-warning btn-sm">Sửa</a>
                                <form action="deletedish" method="post" style="display:inline;">
                                    <input type="hidden" name="dishId" value="<%= dish.getDishId()%>">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                                <a href="dishdetail?dishId=<%= dish.getDishId()%>" class="btn btn-info btn-sm">Chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <p class="text-muted">Không có món ăn nào.</p>
                <% }%>

                <!-- Nút thêm món ăn mới -->
                <a href="addnewdish" class="btn btn-primary">Thêm món ăn mới</a>
            </div>
        </div>
    </body>

</html>