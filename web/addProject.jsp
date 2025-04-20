<%-- 
    Document   : addProject
    Created on : 7 Mar 2025, 3:12:42 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    out.println("Session UserID: " + session.getAttribute("userID"));
    out.println("Session RoleID: " + session.getAttribute("roleID"));
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Project</title>

        <!-- Boxicons -->
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>

    <body>
        <!-- Header/Navbar -->
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

        <div class="container-fluid mt-5">
            <div class="row">
                <!-- Sidebar -->
                <div class="container-sidebar">
                    <jsp:include page="sidebar.jsp"/>
                </div>

                <!-- Main Content -->
                <main class="main d-flex flex-column align-items-center">
                    <div class="container mt-5">
                        <div class="col-md-8 offset-md-2">
                            <div class="card shadow p-4">
                                <div class="container text-center">
                                    <h2 class="mb-4">Add Project</h2>
                                </div>

                                <form action="${pageContext.request.contextPath}/addProjectServlet" method="POST">
                                    <div class="mb-3">
                                        <label for="projectName" class="form-label">Project Name</label>
                                        <input type="text" class="form-control" id="projectName" name="projectName" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="projectDetails" class="form-label">Project Details</label>
                                        <textarea class="form-control" id="projectDetails" name="projectDetails" rows="4" required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="projectStartDate" class="form-label">Project Start Date</label>
                                        <input type="date" class="form-control" id="projectStartDate" name="projectStartDate" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="projectEndDate" class="form-label">Project End Date</label>
                                        <input type="date" class="form-control" id="projectEndDate" name="projectEndDate" required>
                                    </div>


                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/ViewProjectServlet" class="btn btn-secondary">
                                            <i class='bx bx-arrow-back'></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-success">
                                            <i class='bx bx-plus'></i> Add Project
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
