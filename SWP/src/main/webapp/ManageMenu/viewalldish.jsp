<%@ page import="Model.Dish" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View All Dishes</title>
</head>
<body>
    <h1>All Dishes</h1>

    <% if (request.getSession().getAttribute("message") != null) { %>
        <p style="color: green;"><%= request.getSession().getAttribute("message") %></p>
        <% request.getSession().removeAttribute("message"); %>
    <% } %>

    <% if (request.getSession().getAttribute("errorMessage") != null) { %>
        <p style="color: red;"><%= request.getSession().getAttribute("errorMessage") %></p>
        <% request.getSession().removeAttribute("errorMessage"); %>
    <% } %>

    <%
        List<Dish> dishList = (List<Dish>) request.getAttribute("dishList");
        if (dishList != null && !dishList.isEmpty()) {
    %>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Type</th>
                <th>Price</th>
                <th>Description</th>
                <th>Image</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for (Dish dish : dishList) { %>
            <tr>
                <td><%= dish.getDishId() %></td>
                <td><%= dish.getDishName() %></td>
                <td><%= dish.getDishType() %></td>
                <td><%= dish.getDishPrice() %></td>
                <td><%= dish.getDishDescription() %></td>
                <td><img src="<%= dish.getDishImage() %>" alt="Dish Image" width="100"></td>
                <td>
                    <a href="updatedish?dishId=<%= dish.getDishId() %>">Edit</a>
                    <form action="deletedish" method="post" style="display:inline;">
                        <input type="hidden" name="dishId" value="<%= dish.getDishId() %>">
                        <button type="submit">Delete</button>
                    </form>
                        <a href="dishdetail?dishId=<%= dish.getDishId() %>">View Details</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <% } else { %>
        <p>No dishes found.</p>
    <% } %>
    <a href="addnewdish">Add New Dish</a>
</body>
</html>