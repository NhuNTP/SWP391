<%@ page import="Model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Notifications</title>
    <style>
        /* Your CSS styles here */
    </style>
</head>
<body>
    <h1>Notifications</h1>

    <div class="notification-container">
        <% if (request.getAttribute("message") != null) { %>
            <p style="color: green;"><%= request.getAttribute("message") %></p>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <%-- Display Notifications --%>
        <%
            List<Notification> notificationList = (List<Notification>) request.getAttribute("notificationList");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // Date formatting

            if (notificationList != null && !notificationList.isEmpty()) {
        %>
        <ul class="notification-list">
            <% for (Notification notification : notificationList) { %>
            <li class="notification-item">
                <p class="notification-content"><%= notification.getNotificationContent() %></p>
                <p class="notification-date">Created at: <%= dateFormat.format(notification.getNotificationCreateAt()) %></p>
                   <p class="notification-date">UserName: <%= notification.getUserName() %></p>
                     <p class="notification-date">UserRole: <%= notification.getUserRole() %></p>
            </li>
            <% } %>
        </ul>
        <% } else { %>
            <p>No notifications found.</p>
        <% } %>

        <a href="viewalldishes">Back to All Dishes</a>
    </div>
</body>
</html>