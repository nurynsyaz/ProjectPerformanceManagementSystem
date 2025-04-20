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
        <!-- link to boxicons website for including icons -->
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <!-- link to css file -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    </head>
    <header>
        <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
            <div class="container">
                <a href="#" class="navbar-brand mb-0 h1">
                    <img class="d-inline-block align-top" src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                </a>
                <button type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" class="navbar-toggler" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>    
                </button>
            </div>
        </nav>
    </header>
    <body class="d-flex flex-column min-vh-100">
        <%
            // Check if the user is logged in
            if (session == null || session.getAttribute("username") == null || session.getAttribute("role") == null) {
                // Redirect to login page if the user is not logged in
                response.sendRedirect("login.jsp");
                return;
            }

            // Retrieve session attributes
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");

            // Ensure the user is a Head Manager
            if (!"4".equals(role)) {
                response.sendRedirect("login.jsp"); // Redirect to login if the role is not Head Manager
                return;
            }
        %>
        <div class="container-sidebar">
    <jsp:include page="sidebar.jsp"/>
</div>


        <!-- Main Content Area -->
        <main class="main">
            <div class="welcome-container">
                <h1>Welcome, <%= username%>!</h1>
                <h2>Role: Client</h2>
                <p>This is your dashboard. You can manage projects, tasks, and more from here.</p>
            </div>
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <jsp:include page="projectChartUser.jsp" />
                    </div>
                </div>
        </main>

        <!-- Footer -->
        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>
    </body>


</html>
