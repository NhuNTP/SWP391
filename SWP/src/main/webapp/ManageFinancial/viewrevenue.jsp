<%-- 
    Document   : viewrevenue
    Created on : Feb 26, 2025, 10:51:58 AM
    Author     : PNGLoc
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<html>
<head>
    <title>View Revenue</title>
</head>
<body>
    <h1>Revenue Statistics</h1>

    <%-- Total Revenue --%>
    <h2>Total Revenue:</h2>
    <% if (request.getAttribute("totalRevenue") != null) { %>
        <p><%= request.getAttribute("totalRevenue") %></p>
    <% } else { %>
        <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <%-- Daily Revenue --%>
    <h2>Daily Revenue:</h2>
    <form action="viewrevenue" method="get">
        <label for="dailyDate">Date (YYYY-MM-DD):</label>
        <input type="text" id="dailyDate" name="dailyDate" value="<%=(request.getAttribute("dailyDate") != null) ? request.getAttribute("dailyDate") : LocalDate.now()%>">
        <button type="submit">View</button>
    </form>
    <% if (request.getAttribute("dailyRevenue") != null) { %>
        <p>Revenue for <%= request.getAttribute("dailyDate") %>: <%= request.getAttribute("dailyRevenue") %></p>
    <% } else if (request.getAttribute("dailyRevenueError") != null) { %>
        <p style="color: red;"><%= request.getAttribute("dailyRevenueError") %></p>
    <% } %>

    <%-- Monthly Revenue --%>
    <h2>Monthly Revenue:</h2>
    <form action="viewrevenue" method="get">
        <label for="monthlyYear">Month (YYYY-MM):</label>
        <input type="text" id="monthlyYear" name="monthlyYear" value="<%=(request.getAttribute("monthlyYear") != null) ? request.getAttribute("monthlyYear") : YearMonth.now()%>">
        <button type="submit">View</button>
    </form>
    <% if (request.getAttribute("monthlyRevenue") != null) { %>
        <p>Revenue for <%= request.getAttribute("monthlyYear") %>: <%= request.getAttribute("monthlyRevenue") %></p>
    <% } else if (request.getAttribute("monthlyRevenueError") != null) { %>
        <p style="color: red;"><%= request.getAttribute("monthlyRevenueError") %></p>
    <% } %>

    <%-- Yearly Revenue --%>
    <h2>Yearly Revenue:</h2>
    <form action="viewrevenue" method="get">
        <label for="yearlyYear">Year:</label>
        <input type="text" id="yearlyYear" name="yearlyYear" value="<%=(request.getAttribute("yearlyYear") != null) ? request.getAttribute("yearlyYear") : LocalDate.now().getYear()%>">
        <button type="submit">View</button>
    </form>
    <% if (request.getAttribute("yearlyRevenue") != null) { %>
        <p>Revenue for <%= request.getAttribute("yearlyYear") %>: <%= request.getAttribute("yearlyRevenue") %></p>
    <% } else if (request.getAttribute("yearlyRevenueError") != null) { %>
        <p style="color: red;"><%= request.getAttribute("yearlyRevenueError") %></p>
    <% } %>

</body>
</html>

<%-- 
   Create a link in your application to the viewrevenue servlet:

<a href="viewrevenue">View Revenue Statistics</a>
--%>