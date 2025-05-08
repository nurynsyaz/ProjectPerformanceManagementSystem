<%-- 
    Document   : sidebar
    Created on : 19 Mar 2025, 4:00:24 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get role from session
    String role = (String) session.getAttribute("role");
    String dashboardLink = "#"; // Default link if no role is found

    // Set dashboard link based on role
    if ("1".equals(role)) {
        dashboardLink = "hmdashboard.jsp"; // Head Manager
    } else if ("2".equals(role)) {
        dashboardLink = "pmdashboard.jsp"; // Project Manager
    } else if ("3".equals(role)) {
        dashboardLink = "tmdashboard.jsp"; // Team Member
    } else if ("4".equals(role)) {
        dashboardLink = "clientdashboard.jsp"; // Client
    }
%>

<div class="sidebar">
    <ul>
        <li>
            <a href="<%= dashboardLink %>" class="nav-link">
                <span class="item-icon">
                    <i class='bx bxs-home'></i>
                </span>
                <span class="item-txt">Dashboard</span>
            </a> 
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">
                <span class="item-icon">
                    <i class='bx bxs-user-circle'></i>
                </span>
                <span class="item-txt">Profile</span>
            </a> 
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/ViewProjectServlet" class="nav-link">
                <span class="item-icon">
                    <i class='bx bx-task'></i>
                </span>
                <span class="item-txt">Project</span>
            </a> 
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/ViewTasksServlet" class="nav-link">
                <span class="item-icon">
                    <i class='bx bx-task'></i>
                </span>
                <span class="item-txt">Task</span>
            </a> 
        </li>

        <%-- Show Manage All User ONLY for Head Manager --%>
        <% if ("1".equals(role)) { %>
        <li>
            <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="nav-link">
                <span class="item-icon">
                    <i class='bx bxs-user-account'></i>
                </span>
                <span class="item-txt">Manage All User</span>
            </a> 
        </li>
        <% } %>
        <li>
            <a href="${pageContext.request.contextPath}/ReadNotificationHistoryServlet" class="nav-link">
                <span class="item-icon">
                    <i class='bx bx-task'></i>
                </span>
                <span class="item-txt">Log Read Notification History</span>
            </a> 
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link">
                <span class="item-icon">
                    <i class='bx bx-log-out'></i>
                </span>
                <span class="item-txt">Log Out</span>
            </a> 
        </li>
    </ul>
</div>
