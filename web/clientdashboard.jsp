<%-- 
    Document   : clientdashboard
    Created on : 5 Mar 2025, 6:33:15 pm
    Author     : nurin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body class="d-flex flex-column min-vh-100">

        <header>
            <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
                <div class="container">
                    <a href="#" class="navbar-brand mb-0 h1">
                        <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" width="85" height="80" alt="PPMS Logo" class="d-inline-block align-top">
                    </a>
                    <div class="ms-auto">
                        <jsp:include page="notifications.jsp"/>
                    </div>
                </div>
            </nav>
        </header>

        <%
            if (session == null || session.getAttribute("username") == null || session.getAttribute("role") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");

            if (!"4".equals(role)) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="container-sidebar">
            <jsp:include page="sidebar.jsp"/>
        </div>

        <main class="main">
            <div class="welcome-container">
                <h1>Welcome, <%= username%>!</h1>
                <h2>Role: Client</h2>
                <p>This is your dashboard. You can manage projects, tasks, and more from here.</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-md-6">
                    <jsp:include page="assignedProjectsChart.jsp" />
                </div>
            </div>
            <!-- Full-width stacked bar chart -->
            <div class="row justify-content-center mt-4">
                <div class="col-12"><jsp:include page="projectTaskStatusChart.jsp" /></div>
            </div>

            <!-- Full-width doughnut chart below -->
            <div class="row justify-content-center mt-4">
                <div class="col-12"><jsp:include page="projectCompletionChart.jsp" /></div>
            </div>
        </main>

        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
