<%-- 
    Document   : editProject
    Created on : 24 Mar 2025, 8:12:14 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Project"%>
<%
    Project project = (Project) request.getAttribute("project");
    if (project == null) {
        response.sendRedirect("ViewProjectServlet");
        return;
    }

    // ✅ Get current user role from session
    Integer sessionRoleID = (Integer) session.getAttribute("roleID");
    boolean isAdmin = sessionRoleID != null && (sessionRoleID == 1 || sessionRoleID == 2); // 1 = Head Manager, 2 = Project Manager
%>
<%
    Integer roleID = (Integer) session.getAttribute("roleID");
    if (roleID == null || roleID != 1) {
        response.sendRedirect("unauthorized.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Project</title>
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <header>
            <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
                <div class="container">
                    <a href="#" class="navbar-brand mb-0 h1">
                        <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                    </a>
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
                                    <h2 class="mb-4">Edit Project</h2>
                                </div>

                                <form action="${pageContext.request.contextPath}/EditProjectServlet" method="POST">
                                    <input type="hidden" name="projectID" value="<%= project.getProjectID()%>">
                                    <input type="hidden" name="userID" value="<%= project.getUserID()%>">
                                    <input type="hidden" name="roleID" value="<%= project.getRoleID()%>">

                                    <div class="mb-3">
                                        <label for="projectName" class="form-label">Project Name</label>
                                        <input type="text" class="form-control" id="projectName" name="projectName" value="<%= project.getProjectName()%>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="projectDetails" class="form-label">Project Details</label>
                                        <textarea class="form-control" id="projectDetails" name="projectDetails" rows="4" required><%= project.getProjectDetails()%></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="projectStartDate" class="form-label">Start Date</label>
                                        <input type="date" class="form-control" id="projectStartDate" name="projectStartDate" value="<%= project.getProjectStartDate()%>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="projectEndDate" class="form-label">End Date</label>
                                        <input type="date" class="form-control" id="projectEndDate" name="projectEndDate" value="<%= project.getProjectEndDate()%>" required>
                                    </div>


                                    <%-- ✅ Optional display of user info for admins --%>
                                    <% if (isAdmin) {%>
                                    <div class="mb-3">
                                        <label class="form-label">User ID:</label>
                                        <input type="text" class="form-control" value="<%= project.getUserID()%>" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Role ID:</label>
                                        <input type="text" class="form-control" value="<%= project.getRoleID()%>" readonly>
                                    </div>
                                    <% }%>

                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/ViewProjectServlet" class="btn btn-secondary">
                                            <i class='bx bx-arrow-back'></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class='bx bx-save'></i> Save Changes
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
