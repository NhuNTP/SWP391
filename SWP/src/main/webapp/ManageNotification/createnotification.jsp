<%@ page import="Model.Account" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Kiểm tra session
   
    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
        return;
    }

    // Lấy đối tượng Account từ session
    Account account = (Account) session.getAttribute("account");
    String UserRole = account.getUserRole();

    // Chỉ Admin và Manager được truy cập
    if (!"Admin".equals(UserRole) && !"Manager".equals(UserRole)) {
        response.sendRedirect(request.getContextPath() + "/view-notifications");
        return;
    }

    // Lấy danh sách tài khoản từ request
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Notification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
        .sidebar { background: linear-gradient(to bottom, #2C3E50, #34495E); color: white; height: 100vh; }
        .sidebar a { color: white; text-decoration: none; }
        .sidebar a:hover { background-color: #1A252F; }
    </style>
</head>
<body>
<div class="d-flex">
    <div class="sidebar col-md-2 p-3">
        <h4 class="text-center mb-4"><%= UserRole %></h4>
        <ul class="nav flex-column">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/Dashboard/AdminDashboard.jsp" class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/view-notifications" class="nav-link"><i class="fas fa-bell me-2"></i>Notifications</a></li>
        </ul>
    </div>
    <div class="col-md-10 p-4">
        <h3>Create Notification</h3>
        <form action="${pageContext.request.contextPath}/create-notification" method="post">
            <div class="mb-3">
                <label for="notificationType" class="form-label">Send to:</label>
                <select class="form-select" id="notificationType" name="notificationType" onchange="toggleOptions(this)">
                    <option value="all">All Users (except yourself)</option>
                    <option value="role">Specific Role</option>
                    <option value="individual">Specific User</option>
                </select>
            </div>

            <div class="mb-3" id="roleOption" style="display:none;">
                <label for="role" class="form-label">Select Role:</label>
                <select class="form-select" id="role" name="role">
                    <option value="Cashier">Cashier</option>
                    <option value="Waiter">Waiter</option>
                    <option value="kitchen staff">Kitchen staff</option>
                    <% if ("Admin".equals(UserRole)) { %>
                        <option value="Manager">Manager</option>
                    <% } %>
                </select>
            </div>

            <div class="mb-3" id="userOption" style="display:none;">
                <label for="UserId" class="form-label">Select User:</label>
                <select class="form-select" id="UserId" name="UserId">
                    <% if (accounts != null) {
                        for (Account acc : accounts) { %>
                        <option value="<%= acc.getUserId() %>"><%= acc.getUserName() %> (<%= acc.getUserRole() %>)</option>
                    <% } } %>
                </select>
            </div>

            <div class="mb-3">
                <label for="content" class="form-label">Content:</label>
                <textarea class="form-control" id="content" name="content" rows="3" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Create Notification</button>
        </form>
    </div>
</div>
<script>
    function toggleOptions(select) {
        document.getElementById("roleOption").style.display = select.value === "role" ? "block" : "none";
        document.getElementById("userOption").style.display = select.value === "individual" ? "block" : "none";
    }
</script>
</body>
</html>