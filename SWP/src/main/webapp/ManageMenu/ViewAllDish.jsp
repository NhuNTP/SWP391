<%@page import="Model.InventoryItem"%>
<%@page import="Model.Account"%>
<%@ page import="Model.Dish" %>
<%@ page import="Model.DishInventory" %>
<%@ page import="Model.InventoryItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Menu Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
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
            .sidebar .nav-link {
                font-size: 0.9rem;
            }
            .sidebar h4 {
                font-size: 1.5rem;
            }
            .content-area {
                padding: 20px;
            }
            .error {
                color: red;
            }
            .success {
                color: green;
            }
            .table {
                width: 100%;
                margin-bottom: 1rem;
                background-color: #fff;
            }
            .table th,
            .table td {
                padding: 12px;
                vertical-align: middle;
                text-align: left;
            }
            .table thead th {
                background-color: #343a40;
                color: white;
                border-color: #454d55;
            }
            .table-hover tbody tr:hover {
                background-color: #f1f1f1;
            }
            .table-bordered {
                border: 1px solid #dee2e6;
            }
            .table-bordered th,
            .table-bordered td {
                border: 1px solid #dee2e6;
            }
            .text-left.mb-4 {

                overflow: hidden; /* Đảm bảo background và border-radius hoạt động đúng với nội dung bên trong */
                /* Các tùy chỉnh tùy chọn để làm đẹp thêm (có thể bỏ nếu không cần) */
                background: linear-gradient(to right, #2C3E50, #42A5F5);
                padding: 1rem; /* Thêm padding bên trong để tạo khoảng cách, tùy chọn */
                color:white;
                margin-left : -24px !important;
                margin-top: -25px !important;
                margin-right: -25px !important;
            }
            .btn-warning {
                background-color: #ffca28; /* Chọn màu vàng ấm áp: #ffca28 (hoặc #ffb300, #ffc107, tùy bạn thích) */
                border-color: #ffca28;    /* Viền cùng màu nền */
                color: white;         /* Chữ tối màu */
                transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease; /* Transition mượt mà */
            }

            .btn-warning:hover {
                background-color: #ffda6a; /* Vàng sáng hơn một chút khi hover: #ffda6a (hoặc #ffe082, tùy màu nền) */
                border-color: #ffda6a;    /* Viền cùng màu nền hover */
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Bóng đổ nhẹ */
            }

            .btn-danger {
                background-color: #f44336; /* Màu đỏ "đỏ hơn", ví dụ: #f44336 (hoặc #e53935, #d32f2f, tùy chọn) */
                border-color: #f44336;    /* Viền cùng màu nền */
                color: white;             /* Chữ trắng */
                transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease; /* Transition mượt mà */
            }

            .btn-danger:hover {
                background-color: #e53935; /* Đỏ đậm hơn một chút khi hover, ví dụ: #e53935 (hoặc #d32f2f, tùy màu nền) */
                border-color: #e53935;    /* Viền cùng màu nền hover */
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Bóng đổ nhẹ */
                color: black;
            }
            .text-left.mb-4 {

                overflow: hidden; /* Đảm bảo background và border-radius hoạt động đúng với nội dung bên trong */
                /* Các tùy chỉnh tùy chọn để làm đẹp thêm (có thể bỏ nếu không cần) */
                background: linear-gradient(to right, #2C3E50, #42A5F5);
                padding: 1rem; /* Thêm padding bên trong để tạo khoảng cách, tùy chọn */
                color:white;
                margin-left : -24px !important;
                margin-top: -25px !important;
                margin-right: -25px !important;
            }
        </style>
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar col-md-2 p-3">
                <h4 class="text-center mb-4">Admin</h4>
                <ul class="nav flex-column">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/view-revenue" class="nav-link"><i class="fas fa-chart-line me-2"></i>View Revenue</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/viewalldish" class="nav-link"><i class="fas fa-list-alt me-2"></i>Menu Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/addnewdish" class="nav-link"><i class="fas fa-plus me-2"></i>Add New Dish</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewAccountList" class="nav-link"><i class="fas fa-users me-2"></i>Employee Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewTableList" class="nav-link"><i class="fas fa-building me-2"></i>Table Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewOrderList" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Order Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCustomerList" class="nav-link"><i class="fas fa-user-friends me-2"></i>Customer Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewCouponController" class="nav-link"><i class="fas fa-tag me-2"></i>Coupon Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/ViewInventoryController" class="nav-link"><i class="fas fa-boxes me-2"></i>Inventory Management</a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>View Notifications</a></li>
                        <% if ("Admin".equals(UserRole) || "Manager".equals(UserRole)) { %>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/create-notification" class="nav-link"><i class="fas fa-plus me-2"></i>Create Notification</a></li>
                        <% } %>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>
            <div class="col-md-10 p-4 content-area">
                <div class="text-left mb-4">
                    <h4>Menu Management</h4>
                </div>

                <% if (request.getSession().getAttribute("message") != null) {%>
                <div class="alert alert-success" id="successMessage">
                    <%= request.getSession().getAttribute("message")%>
                </div>
                <% request.getSession().removeAttribute("message"); %>
                <% } %>
                <% if (request.getSession().getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger" id="errorMessage">
                    <%= request.getSession().getAttribute("errorMessage")%>
                </div>
                <% request.getSession().removeAttribute("errorMessage"); %>
                <% } %>

                <!-- Add New Dish Button -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/addnewdish" class="btn btn-primary ">
                        <i class="fas fa-plus me-2"></i>Add New Dish
                    </a>
                </div>

                <!-- Filter and Sort Form -->
                <div class="mb-3">
                    <form id="searchForm" class="row g-3">
                        <div class="col-auto">
                            <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="Enter dish name">
                        </div>
                        <div class="col-auto">
                            <select class="form-select" id="filterStatus" name="filterStatus">
                                <option value="">All Status</option>
                                <option value="Available">Available</option>
                                <option value="Unavailable">Unavailable</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <select class="form-select" id="filterIngredientStatus" name="filterIngredientStatus">
                                <option value="">All Ingredients</option>
                                <option value="Sufficient">Sufficient</option>
                                <option value="Insufficient">Insufficient</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <select class="form-select" id="filterDishType" name="filterDishType">
                                <option value="">All Types</option>
                                <option value="Food">Food</option>
                                <option value="Drink">Drink</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <select class="form-select" id="sortOption" name="sortOption">
                                <option value="">Sort</option>
                                <option value="price-asc">Price: Low to High</option>
                                <option value="price-desc">Price: High to Low</option>
                                <option value="name-asc">Name: A-Z</option>
                                <option value="name-desc">Name: Z-A</option>
                            </select>
                        </div>
                    </form>
                </div>

                <div id="dishListContainer">
                    <%
                        List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
                        if (dishList != null && !dishList.isEmpty()) {
                    %>
                    <table class="table table-bordered table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>Dish Name</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Ingredients</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="dishTableBody">
                            <% for (Dish dish : dishList) {%>
                            <tr data-dish-type="<%= dish.getDishType()%>">
                                <td><%= dish.getDishName()%></td>
                                <td><%= dish.getDishPrice()%> VNĐ</td>
                                <td><%= dish.getDishStatus()%></td>
                                <td><%= dish.getIngredientStatus()%></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/updatedish?dishId=<%= dish.getDishId()%>" class="btn btn-warning btn-sm">Edit</a>
                                    <form action="deletedish" method="post" style="display:inline;" onsubmit="return confirmDelete();">
                                        <input type="hidden" name="dishId" value="<%= dish.getDishId()%>">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                    <a href="${pageContext.request.contextPath}/dishdetail?dishId=<%= dish.getDishId()%>" class="btn btn-info btn-sm">Detail</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="text-muted">No dishes available.</p>
                    <% }%>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                             $(document).ready(function () {
                                 const searchKeyword = document.getElementById('searchKeyword');
                                 const filterStatus = document.getElementById('filterStatus');
                                 const filterIngredientStatus = document.getElementById('filterIngredientStatus');
                                 const filterDishType = document.getElementById('filterDishType');
                                 const sortOption = document.getElementById('sortOption');
                                 const dishTableBody = document.getElementById('dishTableBody');
                                 const rows = Array.from(dishTableBody.querySelectorAll('tr'));

                                 function filterAndSortTable() {
                                     const searchText = searchKeyword.value.toLowerCase();
                                     const selectedStatus = filterStatus.value;
                                     const selectedIngredientStatus = filterIngredientStatus.value;
                                     const selectedDishType = filterDishType.value;
                                     const sortValue = sortOption.value;

                                     let filteredRows = rows.filter(row => {
                                         const dishName = row.cells[0].textContent.toLowerCase();
                                         const status = row.cells[2].textContent;
                                         const ingredientStatus = row.cells[3].textContent;
                                         const dishType = row.getAttribute('data-dish-type');

                                         const matchesSearch = dishName.includes(searchText);
                                         const matchesStatus = selectedStatus === '' || status.includes(selectedStatus);
                                         const matchesIngredientStatus = selectedIngredientStatus === '' || ingredientStatus.includes(selectedIngredientStatus);
                                         const matchesDishType = selectedDishType === '' || dishType === selectedDishType;

                                         return matchesSearch && matchesStatus && matchesIngredientStatus && matchesDishType;
                                     });

                                     if (sortValue) {
                                         const [sortField, sortDirection] = sortValue.split('-');
                                         if (sortField === 'price') {
                                             filteredRows.sort((a, b) => {
                                                 const priceA = parseFloat(a.cells[1].textContent);
                                                 const priceB = parseFloat(b.cells[1].textContent);
                                                 return sortDirection === 'asc' ? priceA - priceB : priceB - priceA;
                                             });
                                         } else if (sortField === 'name') {
                                             filteredRows.sort((a, b) => {
                                                 const nameA = a.cells[0].textContent.toLowerCase();
                                                 const nameB = b.cells[0].textContent.toLowerCase();
                                                 return sortDirection === 'asc' ? nameA.localeCompare(nameB) : nameB.localeCompare(nameA);
                                             });
                                         }
                                     }

                                     dishTableBody.innerHTML = '';
                                     filteredRows.forEach(row => dishTableBody.appendChild(row));
                                 }

                                 searchKeyword.addEventListener('keyup', filterAndSortTable);
                                 filterStatus.addEventListener('change', filterAndSortTable);
                                 filterIngredientStatus.addEventListener('change', filterAndSortTable);
                                 filterDishType.addEventListener('change', filterAndSortTable);
                                 sortOption.addEventListener('change', filterAndSortTable);

                                 setTimeout(function () {
                                     $('#successMessage').fadeOut('slow');
                                     $('#errorMessage').fadeOut('slow');
                                 }, 10000);
                             });

                             // Hàm xác nhận xóa
                             function confirmDelete() {
                                 return confirm("Are you sure you want to delete this dish?");
                             }
        </script>
    </body>
</html>