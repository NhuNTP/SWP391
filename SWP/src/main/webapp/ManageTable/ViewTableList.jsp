<%--
    Document   : ViewTableList
    Created on : Feb 21, 2025, 8:28:07 PM
    Author     : ADMIN
--%>

<%@page import="java.util.List"%>
<%@page import="Model.Table"%>
<%@page import="DAO.TableDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Table List</title>
        <script>
            function confirmDelete(tableId, tableStatus) {
                if (confirm('Bạn có chắc chắn muốn xóa bàn ID: ' + tableId + ' - Trạng thái: ' + tableStatus + ' không?')) {
                    window.location.href = 'DeleteTable?id=' + tableId;
                } else {
                }
            }
        </script>
    </head>
    <body>
        <!-- Navbar -->
        <nav>
            <a href="#">Table Management</a>
        </nav>

        <a href="CreateTable">Create New Table</a>
        <!-- Table Table -->
        <div>
            <table>
                <thead>
                    <tr>
                        <th>No.</th> <%-- Added No. column header --%>
                        <th>ID</th>
                        <th>Status</th>
                        <th>Number of Seats</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Sử dụng scriptlet để lặp qua tableList --%>
                    <%
                        List<Table> tables = (List<Table>) request.getAttribute("tableList");
                        if (tables != null) {
                            int counter = 1; // Initialize counter
                            for (Table table : tables) {
                    %>
                    <tr>
                        <td><%= counter++%></td> <%-- Display counter and increment --%>
                        <td><%= table.getTableId()%></td>
                        <td><%= table.getTableStatus()%></td>
                        <td><%= table.getNumberOfSeats()%></td>
                        <td>
                            <a href="UpdateTable?id=<%= table.getTableId()%>">Edit Status</a>
                            <a href="#" onclick="confirmDelete('<%= table.getTableId()%>', '<%= table.getTableStatus()%>')" class="btn-delete">Delete</a>
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