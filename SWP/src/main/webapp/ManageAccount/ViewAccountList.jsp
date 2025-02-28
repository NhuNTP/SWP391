<%--
    Document   : ViewAccountList
    Created on : Feb 21, 2025, 8:28:07 PM
    Author     : ADMIN
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.AccountDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Employee Account List</title>
        <script>
            function confirmDelete(userId, userName) {
                if (confirm('Bạn có chắc chắn muốn xóa tài khoản ID: ' + userId + ' - Tên người dùng: ' + userName + ' không?')) {
                    window.location.href = 'DeleteAccount?id=' + userId; // Chuyển hướng đến Servlet DeleteAccount nếu xác nhận
                } else {
                }
            }
        </script>
    </head>
    <body>
        <!-- Navbar -->
        <nav>
            <a href="#">Employee Accounts</a>
        </nav>

        <a href="CreateAccount">Create New Employee Account</a>
        <!-- Account Table -->
        <div>
            <table>
                <thead>
                    <tr>
                        <th>No.</th> <%-- Added No. column header --%>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Account Email</th>
                        <th>Account Password</th>
                        <th>Account Name</th>
                        <th>Account Role</th>
                        <th>Identity Card</th>
                        <th>User Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Sử dụng scriptlet để lặp qua accountList --%>
                    <%
                        List<Account> accounts = (List<Account>) request.getAttribute("accountList");
                        if (accounts != null) {
                            int counter = 1; // Initialize counter
                            for (Account account : accounts) {
                    %>
                    <tr>
                        <td><%= counter++%></td> <%-- Display counter and increment --%>
                        <td><%= account.getUserId()%></td>
                        <td>
                            <% String imagePath = request.getContextPath() + account.getUserImage();%>
                            Đường dẫn ảnh: <%= imagePath%><br> <%-- In đường dẫn ra --%>
                            <img src="<%= imagePath%>" alt="User Image" width="80" height="80" style="border-radius: 50%;"/>
                        </td>
                        <td>
                            <img src="<%= request.getContextPath() + account.getUserImage()%>" alt="User Image" width="80" height="80" style="border-radius: 50%;"/>
                        </td>                       
                        <td><%= account.getUserEmail()%></td>
                        <td><%= account.getUserPassword()%></td>
                        <td><%= account.getUserName()%></td>
                        <td><%= account.getUserRole()%></td>
                        <td><%= account.getIdentityCard()%></td>
                        <td><%= account.getUserAddress()%></td>
                        <td>
                            <a href="UpdateAccount?id=<%= account.getUserId()%>">Edit</a>
                            <a href="#" onclick="confirmDelete('<%= account.getUserId()%>', '<%= account.getUserName()%>')" class="btn-delete">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>