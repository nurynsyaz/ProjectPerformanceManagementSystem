<%-- 
    Document   : editTask
    Created on : 24 Mar 2025, 10:11:05 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Task" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Task</title>
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
            <div class="container-sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <main class="main d-flex flex-column align-items-center">
                <div class="container mt-5">
                    <div class="col-md-8 offset-md-2">
                        <div class="card shadow p-4">
                            <div class="container text-center">
                                <h2 class="mb-4">Edit Task</h2>
                            </div>

                            <form action="${pageContext.request.contextPath}/EditTaskServlet" method="POST">
                                <%
                                    Task task = (Task) request.getAttribute("task");
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                %>
                                <input type="hidden" name="taskID" value="<%= task.getTaskID() %>">
                                <input type="hidden" name="projectID" value="<%= task.getProjectID() %>">

                                <div class="mb-3">
                                    <label for="taskName" class="form-label">Task Name</label>
                                    <input type="text" class="form-control" id="taskName" name="taskName" value="<%= task.getTaskName() %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="taskDetails" class="form-label">Task Details</label>
                                    <textarea class="form-control" id="taskDetails" name="taskDetails" rows="4" required><%= task.getTaskDetails() %></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="taskStartDate" class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="taskStartDate" name="taskStartDate" value="<%= sdf.format(task.getTaskStartDate()) %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="taskEndDate" class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="taskEndDate" name="taskEndDate" value="<%= sdf.format(task.getTaskEndDate()) %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="statusID" class="form-label">Status</label>
                                    <select id="statusID" name="statusID" class="form-select" required>
                                        <option value="1" <%= task.getStatusID() == 1 ? "selected" : "" %>>In Progress</option>
                                        <option value="2" <%= task.getStatusID() == 2 ? "selected" : "" %>>On-Time</option>
                                        <option value="3" <%= task.getStatusID() == 3 ? "selected" : "" %>>Delayed</option>
                                        <option value="4" <%= task.getStatusID() == 4 ? "selected" : "" %>>Not Started</option>
                                    </select>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/ViewTasksServlet?projectID=<%= task.getProjectID() %>" class="btn btn-secondary">
                                        <i class='bx bx-arrow-back'></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class='bx bx-edit'></i> Update Task
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