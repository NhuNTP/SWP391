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
                  .dish-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            transition: transform 0.3s ease;
            /* Thêm các thuộc tính sau */
            height: 450px; /* Đặt chiều cao cố định cho card */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Đẩy các phần tử lên trên và xuống dưới */
        }

        .dish-card:hover {
            transform: scale(1.05);
        }

        .dish-card img {
            max-width: 100%;
            /*  height: auto;  Xóa thuộc tính này */
            height: 200px; /* Đặt chiều cao cố định cho ảnh */
            object-fit: cover; /*  Ảnh sẽ lấp đầy khung và có thể bị crop */
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

        /* Thêm class này để chứa các nút */
        .dish-card .actions {
            margin-top: 15px;
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
<a href="#" class="btn btn-primary add-dish-btn"
   data-bs-toggle="modal"
   data-bs-target="#addDishModal">Thêm món ăn mới</a>
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
                                <a href="#" class="btn btn-warning btn-sm edit-dish-btn"
                                   data-bs-toggle="modal"
                                   data-bs-target="#editDishModal"
                                   data-dish-id="<%= dish.getDishId()%>">Sửa</a>
                                <form action="deletedish" method="post" style="display:inline;">
                                    <input type="hidden" name="dishId" value="<%= dish.getDishId()%>">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                                <a href="#" class="btn btn-info btn-sm view-dish-btn"
   data-bs-toggle="modal"
   data-bs-target="#dishDetailModal"
   data-dish-id="<%= dish.getDishId() %>">Chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <p class="text-muted">Không có món ăn nào.</p>
                <% }%>

                <!-- Nút thêm món ăn mới -->
                
            </div>
        </div>
        <!-- Edit Dish Modal -->
        <div class="modal fade" id="editDishModal" tabindex="-1" aria-labelledby="editDishModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editDishModalLabel">Chỉnh sửa món ăn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Content will be loaded here via AJAX -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary" id="saveChangesBtn">Lưu thay đổi</button>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.edit-dish-btn').click(function () {
                    var dishId = $(this).data('dish-id');
                    var modalBody = $('#editDishModal .modal-body');

                    // Load content from updatedish.jsp using AJAX
                    $.ajax({
                        url: 'updatedish',
                        type: 'GET',
                        data: {dishId: dishId},
                        success: function (data) {
                            modalBody.html(data);
                        },
                        error: function (xhr, status, error) {
                            modalBody.html('<p>Error loading content.</p>');
                            console.error(error);
                        }
                    });
                });

                // Handle Save Changes button click
                $('#editDishModal').on('click', '#saveChangesBtn', function (event) {
                    event.preventDefault(); // Prevent the default action

                    // Submit the form inside the modal
                    var form = $('#editDishModal form');
                    $.ajax({
                        url: form.attr('action'),
                        type: 'POST',
                        data: new FormData(form[0]), // Serializing the form
                        processData: false,
                        contentType: false,
                        success: function (response) {
                            // Handle the response (e.g., close the modal, refresh the dish list)
                            $('#editDishModal').modal('hide');

                            // Reload the dish list (you might need to adjust this)
                            window.location.reload();
                        },
                        error: function (xhr, status, error) {
                            console.error(error);
                            alert('Error updating dish.');
                        }
                    });
                });
            });
        </script>
        
        <!-- Dish Detail Modal -->
<div class="modal fade" id="dishDetailModal" tabindex="-1" aria-labelledby="dishDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="dishDetailModalLabel">Chi tiết món ăn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Content will be loaded here via AJAX -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>
        <script>
    $(document).ready(function() {
        $('.view-dish-btn').click(function() {
            var dishId = $(this).data('dish-id');
            var modalBody = $('#dishDetailModal .modal-body');

            $.ajax({
                url: 'dishdetail',
                type: 'GET',
                data: { dishId: dishId },
                success: function(data) {
                    modalBody.html(data);
                },
                error: function(xhr, status, error) {
                    modalBody.html('<p>Error loading content.</p>');
                    console.error(error);
                }
            });
        });
    });
</script>

<!-- Add Dish Modal -->
<div class="modal fade" id="addDishModal" tabindex="-1" aria-labelledby="addDishModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addDishModalLabel">Thêm món ăn mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Content will be loaded here via AJAX -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" id="saveNewDishBtn">Thêm</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        $('.add-dish-btn').click(function() {
            var modalBody = $('#addDishModal .modal-body');

            $.ajax({
                url: 'addnewdish',
                type: 'GET',
                success: function(data) {
                    modalBody.html(data);
                },
                error: function(xhr, status, error) {
                    modalBody.html('<p>Error loading content.</p>');
                    console.error(error);
                }
            });
        });

            // Handle Save New Dish button click
        $('#addDishModal').on('click', '#saveNewDishBtn', function(event) {
            event.preventDefault(); // Prevent the default action

            // Submit the form inside the modal
            var form = $('#addDishModal form');
            $.ajax({
                url: form.attr('action'),
                type: 'POST',
                data: new FormData(form[0]), // Serializing the form
                processData: false,
                contentType: false,
                success: function(response) {
                    // Handle the response (e.g., close the modal, refresh the dish list)
                    $('#addDishModal').modal('hide');

                    // Reload the dish list (you might need to adjust this)
                    window.location.reload();
                },
                error: function(xhr, status, error) {
                    console.error(error);
                    alert('Error adding dish.');
                }
            });
        });
    });
</script>
    </body>

</html>