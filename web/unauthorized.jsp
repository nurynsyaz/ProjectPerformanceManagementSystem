<%-- 
    Document   : unauthorized
    Created on : 14 Apr 2025, 12:00:18 pm
    Author     : nurin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Unauthorized Access</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Optional: Reuse your navbar if consistent -->
    <header>
        <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
            <div class="container">
                <a class="navbar-brand mb-0 h1">
                    <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                </a>
            </div>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="main d-flex flex-column align-items-center">
        <div class="container mt-5">
            <div class="col-md-8 offset-md-2">
                <div class="card shadow text-center p-5">
                    <h1 class="text-danger display-4"><i class='bx bx-block'></i> Access Denied</h1>
                    <p class="lead mt-3">You do not have permission to access this page or perform this action.</p>
                    <a href="dashboard.jsp" class="btn btn-primary mt-4">
                        <i class='bx bx-home'></i> Return to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <div class="container text-center">
            <p>&copy; 2024 PPMS. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
