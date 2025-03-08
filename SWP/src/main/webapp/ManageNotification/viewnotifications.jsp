<%@ page import="Model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Notifications</title>
    <style>
        .notification-container { margin: 20px; }
        .notification-list { list-style-type: none; padding: 0; }
        .notification-item { border: 1px solid #ddd; padding: 10px; margin-bottom: 10px; border-radius: 5px; }
        .notification-content { font-weight: bold; }
        .notification-date { color: #666; font-size: 0.9em; }
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
            List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            if (notifications != null && !notifications.isEmpty()) {
        %>
        <ul class="notification-list">
            <% for (Notification notification : notifications) { %>
            <li class="notification-item">
                <p class="notification-content"><%= notification.getNotificationContent() %></p>
                <p class="notification-date">Created at: <%= dateFormat.format(notification.getNotificationCreateAt()) %></p>
                <p class="notification-date">User: <%= notification.getUserName() %> (<%= notification.getUserRole() %>)</p>
            </li>
            <% } %>
        </ul>
        <% } else { %>
            <p>No notifications found.</p>
        <% } %>

        <a href="${pageContext.request.contextPath}/Dashboard/AdminDashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>