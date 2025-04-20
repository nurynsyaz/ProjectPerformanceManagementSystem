<%-- 
    Document   : addTask
    Created on : 7 Mar 2025, 4:39:47 pm
    Author     : nurin
--%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ProjectDAO"%>
<%@page import="model.Project"%>
<%@page import="dao.UserDAO"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Task</title>
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <header>
            <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
                <div class="container">
                    <a href="#" class="navbar-brand mb-0 h1">
                        <img class="d-inline-block align-top" src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                    </a>
                    <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                </div>
            </nav>
        </header>

        <div class="container-fluid mt-5">
            <div class="row">
                <div class="container-sidebar">
                    <jsp:include page="sidebar.jsp"/>
                </div>
                <main class="main d-flex flex-column align-items-center">
                    <div class="container mt-5">
                        <div class="col-md-8 offset-md-2">
                            <div class="card shadow p-4">
                                <div class="container text-center">
                                    <h2 class="mb-4">Add New Task</h2>
                                </div>
                                <%
                                    String status = request.getParameter("status");
                                    if ("error".equals(status)) {
                                %>
                                <div class="alert alert-danger text-center">
                                    ❌ Failed to add task. Please try again.
                                </div>
                                <%
                                    }
                                %>

                                <form action="${pageContext.request.contextPath}/addTaskServlet" method="POST">
                                    <%
                                        String projectID = request.getParameter("projectID");
                                        if (projectID == null || projectID.isEmpty()) {
                                    %>
                                    <div class="alert alert-warning text-center" role="alert">
                                        ⚠️ No project selected. Please go back and select a project first.
                                    </div>
                                    <%
                                    } else {
                                        ProjectDAO projectDAO = new ProjectDAO();
                                        Project currentProject = projectDAO.getProjectById(Integer.parseInt(projectID));
                                        String minDate = currentProject.getProjectStartDate().toString();
                                        String maxDate = currentProject.getProjectEndDate().toString();
                                    %>
                                    <input type="hidden" name="projectID" value="<%= projectID%>">

                                    <div class="mb-3">
                                        <label for="taskName" class="form-label">Task Name</label>
                                        <input type="text" class="form-control" id="taskName" name="taskName" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="taskDetails" class="form-label">Task Details</label>
                                        <textarea class="form-control" id="taskDetails" name="taskDetails" rows="4" required></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="taskStartDate" class="form-label">Start Date</label>
                                        <input type="date" class="form-control" id="taskStartDate" name="taskStartDate" min="<%= minDate%>" max="<%= maxDate%>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="taskEndDate" class="form-label">End Date</label>
                                        <input type="date" class="form-control" id="taskEndDate" name="taskEndDate" min="<%= minDate%>" max="<%= maxDate%>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="statusID" class="form-label">Status</label>
                                        <select id="statusID" name="statusID" class="form-select" required>
                                            <option value="1">In Progress</option>
                                            <option value="2">On-Time</option>
                                            <option value="3">Delayed</option>
                                            <option value="4">Not Started</option>
                                        </select>
                                    </div>
                                    <%
                                        UserDAO userDAO = new UserDAO();
                                        List<User> assignableUsers = userDAO.getAllUsers(); 
                                    %>


                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/ViewTasksServlet?projectID=<%= projectID%>" class="btn btn-secondary">
                                            <i class='bx bx-arrow-back'></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-success">
                                            <i class='bx bx-plus'></i> Add Task
                                        </button>
                                    </div>
                                    <% }%>
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
