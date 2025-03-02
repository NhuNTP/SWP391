<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Create Notification</title>
    <style>
        /* Your CSS styles here */
    </style>
</head>
<body>
    <h1>Create Notification</h1>

    <div class="notification-container">
        <% if (request.getAttribute("message") != null) { %>
            <p style="color: green;"><%= request.getAttribute("message") %></p>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <form action="/createnotification" method="post">
            <label for="target">Target Audience:</label>
            <select id="target" name="target">
                <option value="all" ${target == 'all' ? 'selected' : ''}>All Users</option>
                <option value="role" ${target == 'role' ? 'selected' : ''}>Specific Role</option>
                <option value="user" ${target == 'user' ? 'selected' : ''}>Specific User</option>
            </select>
            <br><br>

            <div id="roleSection" style="display: none;">
                <label for="role">Role:</label>
                <select id="role" name="role">
                   <%List<String> roles = (List<String>) request.getAttribute("roles");
                   if (roles!=null){
                    for (String role : roles) {%>
                        <option value="<%= role %>"><%= role %></option>
                    <% }
                   }
                    %>
                </select>
                <br><br>
            </div>

            <div id="userSection" style="display: none;">
                <label for="userId">User ID:</label>
                <input type="number" id="userId" name="userId">
                <br><br>
            </div>

            <label for="notificationContent">Notification Content:</label><br>
            <textarea id="notificationContent" name="notificationContent" required></textarea><br><br>

            <button type="submit">Create Notification</button>
        </form>
        <a href="viewalldishes">Back to All Dishes</a>
    </div>

    <script>
        const targetSelect = document.getElementById("target");
        const roleSection = document.getElementById("roleSection");
        const userSection = document.getElementById("userSection");

        function updateVisibility() {
            roleSection.style.display = (targetSelect.value === "role") ? "block" : "none";
            userSection.style.display = (targetSelect.value === "user") ? "block" : "none";
        }

        targetSelect.addEventListener("change", updateVisibility);
        updateVisibility(); // Call on page load
    </script>
</body>
</html>