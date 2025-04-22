<%-- 
    Document   : viewTasks
    Created on : 7 Mar 2025, 5:54:09 pm
    Author     : nurin
--%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Task"%>
<%@page import="model.Project"%>
<%@page import="model.User"%>
<%@page import="dao.TaskProgressDAO"%>
<%@page import="model.TaskProgress"%>
<%@page import="model.Comment" %>
<%@page import="dao.CommentDAO" %>
<%@page import="javax.servlet.http.HttpSession"%>
<%
    Integer roleID = (Integer) session.getAttribute("roleID");
    Integer userID = (Integer) session.getAttribute("userID");
    boolean isProjectManager = roleID != null && roleID == 2;
    boolean isTeamMember = roleID != null && roleID == 3;
    boolean isClient = roleID != null && roleID == 4;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View Tasks</title>
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
                        <div class="col-md-12">
                            <div class="card shadow p-4">
                                <div class="text-center mb-4">
                                    <h2>List of Tasks</h2>
                                </div>

                                <% String status = request.getParameter("status");
                                    if (status != null) {
                                        String alertClass = "info", message = "";
                                        switch (status) {
                                            case "added":
                                                alertClass = "success";
                                                message = "✅ Task Added Successfully!";
                                                break;
                                            case "updated":
                                                alertClass = "primary";
                                                message = "✏️ Task Updated Successfully!";
                                                break;
                                            case "deleted":
                                                alertClass = "danger";
                                                message = "🗑️ Task Deleted Successfully!";
                                                break;
                                            case "error":
                                                alertClass = "warning";
                                                message = "⚠️ Something went wrong!";
                                                break;
                                        }%>
                                <div class="alert alert-<%= alertClass%> alert-dismissible fade show text-center" role="alert">
                                    <strong><%= message%></strong>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                <form method="get" action="${pageContext.request.contextPath}/ViewTasksServlet" class="mb-4">
                                    <div class="row g-2">
                                        <div class="col-md-10">
                                            <select name="projectID" class="form-select" onchange="this.form.submit()">
                                                <option value="">-- Filter by Project --</option>
                                                <% List<Project> projects = (List<Project>) request.getAttribute("projects");
                                                    int selectedProjectId = request.getParameter("projectID") != null ? Integer.parseInt(request.getParameter("projectID")) : -1;
                                                    if (projects != null) {
                                                        for (Project project : projects) {
                                                %>
                                                <option value="<%= project.getProjectID()%>" <%= project.getProjectID() == selectedProjectId ? "selected" : ""%>><%= project.getProjectName()%></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                        <% if (isProjectManager) {%>
                                        <div class="col-md-2">
                                            <a href="addTask.jsp?projectID=<%= selectedProjectId%>" class="btn btn-success w-100">
                                                <i class='bx bx-plus'></i> Add Task
                                            </a>
                                        </div>
                                        <% } %>
                                    </div>
                                </form>

                                <div class="table-container">
                                    <table class="table table-striped table-bordered">
                                        <thead class="table-dark text-center">
                                            <tr>
                                                <th>Task ID</th>
                                                <th>Project</th>
                                                <th>Task Name</th>
                                                <th>Details</th>
                                                <th>Start Date</th>
                                                <th>End Date</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                                                List<User> eligibleUsers = (List<User>) request.getAttribute("eligibleUsers");
                                                Map<Integer, List<User>> taskAssignments = (Map<Integer, List<User>>) request.getAttribute("taskAssignments");
                                                if (tasks != null && !tasks.isEmpty()) {
                                                    for (Task task : tasks) {
                                            %>
                                            <tr class="text-center">
                                                <td><%= task.getTaskID()%></td>
                                                <td><%= task.getProjectName()%></td>
                                                <td><%= task.getTaskName()%></td>
                                                <td><%= task.getTaskDetails()%></td>
                                                <td><%= task.getTaskStartDate()%></td>
                                                <td><%= task.getTaskEndDate()%></td>
                                                <td><%= task.getStatusDescription()%></td>
                                                <td>
                                                    <% if (isProjectManager) {%>
                                                    <a href="EditTaskServlet?taskID=<%= task.getTaskID()%>" class="btn btn-sm btn-primary me-2"><i class='bx bx-edit'></i> Edit</a>
                                                    <a href="DeleteTaskServlet?taskID=<%= task.getTaskID()%>&projectID=<%= selectedProjectId%>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?');"><i class='bx bx-trash'></i> Delete</a>

                                                    <!-- Assign Task Modal Trigger -->
                                                    <button class="btn btn-sm btn-secondary" data-bs-toggle="modal" data-bs-target="#assignModal<%= task.getTaskID()%>">Assign</button>
                                                    <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewAssignedModal<%= task.getTaskID()%>">View Assigned</button>

                                                    <!-- Assign Modal -->
                                                    <div class="modal fade" id="assignModal<%= task.getTaskID()%>" tabindex="-1">
                                                        <div class="modal-dialog modal-xl">
                                                            <form id="assignmentForm<%= task.getTaskID()%>" method="post">
                                                                <input type="hidden" name="taskID" value="<%= task.getTaskID()%>">
                                                                <input type="hidden" name="projectID" value="<%= selectedProjectId%>">
                                                                <input type="hidden" id="selectedUserID<%= task.getTaskID()%>" name="userID" value="">

                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Assign/Remove User for Task: <%= task.getTaskName()%></h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="table-responsive">
                                                                            <table class="table table-bordered">
                                                                                <thead class="table-light text-center">
                                                                                    <tr>
                                                                                        <th>Select</th>
                                                                                        <th>User ID</th>
                                                                                        <th>Username</th>
                                                                                        <th>Email</th>
                                                                                        <th>Phone</th>
                                                                                        <th>Role</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% for (User user : eligibleUsers) {
                                                                                            List<User> assignedUsers = taskAssignments.get(task.getTaskID());
                                                                                    %>
                                                                                    <tr class="text-center">
                                                                                        <td>
                                                                                            <input type="radio" name="selectUser<%= task.getTaskID()%>" value="<%= user.getUserID()%>"
                                                                                                   onclick="document.getElementById('selectedUserID<%= task.getTaskID()%>').value = this.value">
                                                                                        </td>
                                                                                        <td><%= user.getUserID()%></td>
                                                                                        <td><%= user.getUsername()%></td>
                                                                                        <td><%= user.getEmail()%></td>
                                                                                        <td><%= user.getPhoneNumber()%></td>
                                                                                        <td><%= user.getRoleID() == 3 ? "Team Member" : "Client"%></td>
                                                                                    </tr>
                                                                                    <% }%>
                                                                                </tbody>

                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="submit" formaction="AssignTaskServlet" class="btn btn-primary">Assign</button>
                                                                        <button type="submit" formaction="RemoveAssignedUserServlet" class="btn btn-danger">Remove</button>
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>


                                                    <!-- View Assigned Modal -->
                                                    <div class="modal fade" id="viewAssignedModal<%= task.getTaskID()%>" tabindex="-1">
                                                        <div class="modal-dialog modal-xl">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Assigned Users</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <% List<User> assignedUsers = taskAssignments.get(task.getTaskID());
                                                                        if (assignedUsers != null && !assignedUsers.isEmpty()) { %>
                                                                    <div class="table-responsive">
                                                                        <table class="table table-bordered table-striped text-center">
                                                                            <thead class="table-light">
                                                                                <tr>
                                                                                    <th>User ID</th>
                                                                                    <th>Username</th>
                                                                                    <th>Email</th>
                                                                                    <th>Phone</th>
                                                                                    <th>Role</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for (User user : assignedUsers) {%>
                                                                                <tr>
                                                                                    <td><%= user.getUserID()%></td>
                                                                                    <td><%= user.getUsername()%></td>
                                                                                    <td><%= user.getEmail()%></td>
                                                                                    <td><%= user.getPhoneNumber()%></td>
                                                                                    <td><%= user.getRoleID() == 3 ? "Team Member" : "Client"%></td>
                                                                                </tr>
                                                                                <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <% } else { %>
                                                                    <p class="text-muted text-center">No users assigned to this task.</p>
                                                                    <% } %>
                                                                </div>


                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>

                                                    <%
                                                        List<User> assignedUsers = taskAssignments.get(task.getTaskID());
                                                        boolean isAssignedToCurrentUser = false;

                                                        if (assignedUsers != null) {
                                                            for (User u : assignedUsers) {
                                                                if (u.getUserID() == userID) {
                                                                    isAssignedToCurrentUser = true;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                    %>

                                                    <%-- Upload Progress: only for assigned Team Members --%>
                                                    <% if (isTeamMember && isAssignedToCurrentUser) {%>
                                                    <!-- Upload Button to trigger Modal -->
                                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#uploadModal<%= task.getTaskID()%>">
                                                        <i class='bx bx-upload'></i> Upload Progress
                                                    </button>

                                                    <!-- Upload Modal -->
                                                    <div class="modal fade" id="uploadModal<%= task.getTaskID()%>" tabindex="-1" aria-labelledby="uploadLabel<%= task.getTaskID()%>" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl">
                                                            <form id="uploadProgressForm<%= task.getTaskID()%>" enctype="multipart/form-data" onsubmit="return false;">
                                                                <input type="hidden" name="taskID" value="<%= task.getTaskID()%>">
                                                                <input type="hidden" name="projectID" value="<%= selectedProjectId%>">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Upload Progress for: <%= task.getTaskName()%></h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <p><strong>Task Details:</strong> <%= task.getTaskDetails()%></p>
                                                                        <div class="mb-3">
                                                                            <label class="form-label">Progress Notes</label>
                                                                            <textarea name="progressNotes" class="form-control" rows="4" placeholder="Describe your progress..."></textarea>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label class="form-label">Upload File</label>
                                                                            <input type="file" name="progressFile" class="form-control" accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip" required>
                                                                            <small class="text-muted">Allowed: PDF, Word, Excel, PPT, ZIP (max 1GB)</small>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label class="form-label">Update Task Status</label>
                                                                            <select name="statusID" class="form-select" required>
                                                                                <option value="">-- Select Status --</option>
                                                                                <option value="1">In Progress</option>
                                                                                <option value="2">On-Time</option>
                                                                                <option value="3">Delayed</option>
                                                                                <option value="4">Not Started</option>
                                                                            </select>
                                                                        </div>

                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-success" onclick="submitUploadForm(<%= task.getTaskID()%>)">Upload</button>
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                    <% } %>

                                                    <%-- View Progress: for Project Manager, Head Manager, Client, or assigned Team Member --%>
                                                    <% if ((roleID == 1 || isProjectManager || isClient) || (isTeamMember && isAssignedToCurrentUser)) {%>
                                                    <!-- View Progress Button -->
                                                    <button class="btn btn-sm btn-info mt-1" data-bs-toggle="modal" data-bs-target="#viewProgressModal<%= task.getTaskID()%>">
                                                        <i class='bx bx-folder'></i> View Uploaded Progress
                                                    </button>

                                                    <!-- View Progress Modal -->
                                                    <div class="modal fade" id="viewProgressModal<%= task.getTaskID()%>" tabindex="-1">
                                                        <div class="modal-dialog modal-xl">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Uploaded Progress for: <%= task.getTaskName()%></h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <%
                                                                        dao.TaskProgressDAO progressDAO = new dao.TaskProgressDAO();
                                                                        List<model.TaskProgress> progressList = progressDAO.getProgressByTaskID(task.getTaskID());
                                                                        if (progressList != null && !progressList.isEmpty()) {
                                                                    %>
                                                                    <div class="table-responsive">
                                                                        <table class="table table-bordered table-striped text-center">

                                                                            <thead class="table-light">
                                                                                <tr>
                                                                                    <th>File Name</th>
                                                                                    <th>Notes</th>
                                                                                    <th>Uploaded At</th>
                                                                                    <th>Action</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for (model.TaskProgress p : progressList) {
                                                                                        boolean isUploader = p.getUserID() == userID;
                                                                                %>
                                                                                <tr>
                                                                                    <td><span title="<%= p.getFileName()%>"><%= p.getFileName()%></span></td>
                                                                                    <td><%= p.getNotes() != null ? p.getNotes() : "-"%></td>
                                                                                    <td><%= p.getUploadedAt()%></td>
                                                                                    <td>
                                                                                        <%
                                                                                            String encodedFileName = java.net.URLEncoder.encode(p.getFileName(), "UTF-8");
                                                                                        %>
                                                                                        <a href="DownloadServlet?fileName=<%= encodedFileName%>" class="btn btn-sm btn-success">
                                                                                            Download
                                                                                        </a>

                                                                                        <% if (isTeamMember && isUploader) {%>
                                                                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editProgressModal<%= p.getProgressID()%>">
                                                                                            <i class='bx bx-edit'></i> Edit
                                                                                        </button>
                                                                                        <button type="button" class="btn btn-sm btn-danger btn-remove-progress" data-file-name="<%= p.getFileName()%>">
                                                                                            <i class='bx bx-trash'></i> Remove
                                                                                        </button>
                                                                                        <% }%>
                                                                                    </td>
                                                                                </tr>



                                                                                <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <% for (model.TaskProgress p : progressList) {
                                                                            if (p.getUserID() == userID) {%>
                                                                    <!-- Edit Progress Modal -->
                                                                    <div class="modal fade" id="editProgressModal<%= p.getProgressID()%>" tabindex="-1">
                                                                        <div class="modal-dialog modal-xl">
                                                                            <form id="editProgressForm<%= p.getProgressID()%>" enctype="multipart/form-data" onsubmit="return false;">
                                                                                <input type="hidden" name="progressID" value="<%= p.getProgressID()%>">
                                                                                <input type="hidden" name="taskID" value="<%= p.getTaskID()%>"> <!-- fixed! -->
                                                                                <div class="modal-content">
                                                                                    <div class="modal-header">
                                                                                        <h5 class="modal-title">Edit Uploaded Progress</h5>
                                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                                    </div>
                                                                                    <div class="modal-body">
                                                                                        <div class="mb-3">
                                                                                            <label class="form-label">Progress Notes</label>
                                                                                            <textarea name="progressNotes" class="form-control" rows="4"><%= p.getNotes() != null ? p.getNotes() : ""%></textarea>
                                                                                        </div>
                                                                                        <div class="mb-3">
                                                                                            <label class="form-label">Replace File (optional)</label>
                                                                                            <input type="file" name="progressFile" class="form-control" accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip">
                                                                                            <small class="text-muted">Leave empty to keep existing file</small>
                                                                                        </div>
                                                                                        <div class="mb-3">
                                                                                            <label class="form-label">Update Task Status</label>
                                                                                            <select name="statusID" class="form-select" required>
                                                                                                <option value="">-- Select Status --</option>
                                                                                                <option value="1">In Progress</option>
                                                                                                <option value="2">On-Time</option>
                                                                                                <option value="3">Delayed</option>
                                                                                                <option value="4">Not Started</option>
                                                                                            </select>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="modal-footer">
                                                                                        <button type="button" class="btn btn-success" onclick="submitEditProgress(<%= p.getProgressID()%>)">Save Changes</button>
                                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                                    </div>
                                                                                </div>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                    <% }
                                                                        } %>


                                                                    <% } else { %>
                                                                    <p class="text-muted text-center">No progress files uploaded yet for this task.</p>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>



                                                    <% if (isClient) {%>
                                                    <!-- 💬 Comment Button -->
                                                    <button class="btn btn-sm btn-warning mt-2" data-bs-toggle="modal" data-bs-target="#addCommentModal<%= task.getTaskID()%>">
                                                        💬 Add Comment
                                                    </button>

                                                    <!-- Add Comment Modal -->
                                                    <div class="modal fade" id="addCommentModal<%= task.getTaskID()%>" tabindex="-1" aria-labelledby="addCommentModalLabel<%= task.getTaskID()%>" aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <form id="addCommentForm<%= task.getTaskID()%>" onsubmit="submitComment(event, <%= task.getTaskID()%>)">
                                                                    <input type="hidden" name="action" value="add">
                                                                    <input type="hidden" name="taskID" value="<%= task.getTaskID()%>">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="addCommentModalLabel<%= task.getTaskID()%>">Add Comment for: <%= task.getTaskName()%></h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="mb-3">
                                                                            <label for="commentText" class="form-label">Comment</label>
                                                                            <textarea id="commentText<%= task.getTaskID()%>" name="commentText" class="form-control" rows="4" required></textarea>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="submit" class="btn btn-primary">Post Comment</button>
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% }%>

                                                    <!-- View Comments Button (visible to all) -->
                                                    <button class="btn btn-sm btn-warning mt-1" data-bs-toggle="modal" data-bs-target="#viewCommentsModal<%= task.getTaskID()%>">
                                                        <i class='bx bx-comment'></i> View Comments
                                                    </button>

                                                    <!-- View Comments Modal -->
                                                    <div class="modal fade" id="viewCommentsModal<%= task.getTaskID()%>" tabindex="-1" aria-labelledby="viewCommentsModalLabel<%= task.getTaskID()%>" aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="viewCommentsModalLabel<%= task.getTaskID()%>">Comments for: <%= task.getTaskName()%></h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="table-responsive">
                                                                        <!-- This container will be filled dynamically via AJAX -->
                                                                        <div id="commentsContainer<%= task.getTaskID()%>"></div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Edit Comment Modal (Reusable) -->
                                                    <div class="modal fade" id="editCommentModal" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <form id="editCommentForm" onsubmit="submitEditComment(event)">
                                                                <input type="hidden" name="action" value="edit">
                                                                <input type="hidden" name="commentID" id="editCommentID">
                                                                <input type="hidden" name="taskID" id="editTaskID">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Edit Comment</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <textarea name="commentText" id="editCommentText" class="form-control" rows="4" style="resize: none;"></textarea>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="submit" class="btn btn-primary">Update</button>
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <% }
                                            } else { %>
                                            <tr><td colspan="8" class="text-center">No tasks found for the selected project.</td></tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>

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
        <script>
                                                                const contextPath = "<%= request.getContextPath()%>";
                                                                console.log("✅ contextPath:", contextPath);
        </script>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Load comments when modal is opened
                const commentsModals = document.querySelectorAll("[id^='viewCommentsModal']");
                commentsModals.forEach(modal => {
                    const taskID = modal.id.replace("viewCommentsModal", "");
                    modal.addEventListener("show.bs.modal", function () {
                        const container = document.getElementById("commentsContainer" + taskID);
                        fetch("ViewCommentsServlet?taskID=" + taskID)
                                .then(response => response.text())
                                .then(html => container.innerHTML = html)
                                .catch(() => container.innerHTML = "<p class='text-danger'>Failed to load comments.</p>");
                    });
                });

                // Handle Delete Progress Button Clicks
                const removeButtons = document.querySelectorAll(".btn-remove-progress");
                removeButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        const fileName = this.getAttribute("data-file-name");

                        if (!fileName) {
                            alert("❌ No file name found.");
                            return;
                        }

                        if (!confirm("Are you sure you want to delete this progress file?")) {
                            return;
                        }

                        fetch("DeleteProgressServlet", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: "fileName=" + encodeURIComponent(fileName)
                        })
                                .then(response => response.text())
                                .then(result => {
                                    if (result.trim() === "Deleted") {
                                        alert("✅ Progress deleted successfully.");
                                        location.reload();
                                    } else {
                                        alert("❌ Failed to delete progress.");
                                        console.error(result);
                                    }
                                })
                                .catch(error => {
                                    alert("❌ An error occurred while deleting progress.");
                                    console.error("Error:", error);
                                });
                    });
                });

                // Handle Edit Comment Button Click
                document.addEventListener("click", function (e) {
                    if (e.target && e.target.classList.contains("btn-edit-comment")) {
                        const commentID = e.target.getAttribute("data-comment-id");
                        const taskID = e.target.getAttribute("data-task-id");
                        const commentText = e.target.getAttribute("data-comment-text");

                        document.getElementById("editCommentID").value = commentID;
                        document.getElementById("editTaskID").value = taskID;
                        document.getElementById("editCommentText").value = commentText;

                        // Hide view comments modal
                        const viewModal = bootstrap.Modal.getInstance(document.getElementById("viewCommentsModal" + taskID));
                        if (viewModal)
                            viewModal.hide();

                        // Show edit comment modal
                        const editModal = new bootstrap.Modal(document.getElementById("editCommentModal"));
                        editModal.show();
                    }
                });

                // Handle Delete Comment Button Click via AJAX
                document.addEventListener("click", function (e) {
                    if (e.target && e.target.classList.contains("btn-delete-comment")) {
                        const commentID = e.target.getAttribute("data-comment-id");
                        const taskID = e.target.getAttribute("data-task-id");

                        if (!confirm("Are you sure you want to delete this comment?"))
                            return;

                        fetch("TaskCommentsServlet", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: new URLSearchParams({
                                action: "delete",
                                commentID: commentID,
                                taskID: taskID
                            })
                        })
                                .then(res => res.text())
                                .then(() => {
                                    const container = document.getElementById("commentsContainer" + taskID);
                                    fetch("ViewCommentsServlet?taskID=" + taskID)
                                            .then(res => res.text())
                                            .then(html => container.innerHTML = html);
                                })
                                .catch(err => {
                                    console.error("Error deleting comment:", err);
                                    alert("❌ Failed to delete comment.");
                                });
                    }
                });
            });

            function submitUploadForm(taskID) {
                const form = document.getElementById("uploadProgressForm" + taskID);
                const formData = new FormData(form);
                const statusID = form.querySelector("select[name='statusID']").value;

                for (let pair of formData.entries()) {
                    console.log("📝", pair[0], "=", pair[1]);
                }

                fetch(contextPath + "/UploadProgressServlet", {
                    method: "POST",
                    body: formData
                })
                        .then(response => response.text())
                        .then(result => {
                            if (statusID) {
                                return fetch(contextPath + "/UpdateTaskStatusServlet", {
                                    method: "POST",
                                    headers: {
                                        "Content-Type": "application/x-www-form-urlencoded"
                                    },
                                    body: `taskID=${taskID}&statusID=${statusID}`
                                });
                            }
                        })
                        .then(() => {
                            alert("✅ Progress uploaded and task status updated.");
                            location.reload();
                        })
                        .catch(error => {
                            console.error("❌ Upload or status update failed:", error);
                            alert("❌ Upload or status update failed.");
                        });
            }

            function submitComment(event, taskID) {
                event.preventDefault(); // Prevent form from reloading page

                const commentText = document.getElementById("commentText" + taskID).value.trim();
                if (!commentText) {
                    alert("⚠️ Please write a comment before submitting.");
                    return;
                }

                fetch("TaskCommentsServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        action: "add",
                        taskID: taskID,
                        commentText: commentText
                    })
                })
                        .then(res => res.text())
                        .then(() => {
                            document.getElementById("commentText" + taskID).value = "";
                            const modal = bootstrap.Modal.getInstance(document.getElementById("addCommentModal" + taskID));
                            modal.hide();
                            const commentsContainer = document.getElementById("commentsContainer" + taskID);
                            fetch("ViewCommentsServlet?taskID=" + taskID)
                                    .then(res => res.text())
                                    .then(html => commentsContainer.innerHTML = html);
                        })
                        .catch(err => {
                            console.error("Error posting comment:", err);
                            alert("❌ Failed to post comment.");
                        });
            }

            // Edit Comment Function
            function submitEditComment(event) {
                event.preventDefault();

                const commentID = document.getElementById("editCommentID").value;
                const taskID = document.getElementById("editTaskID").value;
                const commentText = document.getElementById("editCommentText").value.trim();

                if (!commentText) {
                    alert("⚠️ Comment cannot be empty.");
                    return;
                }

                fetch("TaskCommentsServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        action: "edit",
                        commentID: commentID,
                        taskID: taskID,
                        commentText: commentText
                    })
                })
                        .then(res => res.text())
                        .then(() => {
                            const modal = bootstrap.Modal.getInstance(document.getElementById("editCommentModal"));
                            modal.hide();
                            const viewModal = new bootstrap.Modal(document.getElementById("viewCommentsModal" + taskID));
                            const container = document.getElementById("commentsContainer" + taskID);
                            fetch("ViewCommentsServlet?taskID=" + taskID)
                                    .then(res => res.text())
                                    .then(html => {
                                        container.innerHTML = html;
                                        viewModal.show(); // Show updated view modal
                                    });
                        })
                        .catch(err => {
                            console.error("Error updating comment:", err);
                            alert("❌ Failed to update comment.");
                        });
            }

            function submitEditProgress(progressID) {
                const form = document.getElementById("editProgressForm" + progressID);
                if (!form) {
                    alert("⚠️ Edit form not found for progressID = " + progressID);
                    return;
                }

                const taskIDInput = form.querySelector("input[name='taskID']");
                const statusSelect = form.querySelector("select[name='statusID']");

                if (!taskIDInput || !statusSelect) {
                    alert("⚠️ Missing input(s) in Edit Progress Modal for progressID = " + progressID);
                    return;
                }

                const taskID = taskIDInput.value;
                const statusID = statusSelect.value;

                if (!taskID || !statusID) {
                    alert("⚠️ Please ensure both Task ID and Status are selected.");
                    return;
                }

                const formData = new FormData(form);


                fetch("EditProgressServlet", {
                    method: "POST",
                    body: formData
                })
                        .then(response => response.text())
                        .then(result => {
                            console.log("📨 EditProgressServlet response:", result); // NEW
                            if (result.includes("unauthorized") || result.includes("error")) {
                                throw new Error("Server error: " + result);
                            }

                            return fetch("UpdateTaskStatusServlet", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: "taskID=" + encodeURIComponent(taskID) + "&statusID=" + encodeURIComponent(statusID)
                            });
                        })
                        .then(response => response.text())
                        .then(result => {
                            console.log("📨 UpdateTaskStatusServlet response:", result); // NEW
                            alert("✅ Progress updated and status changed.");
                            const modal = bootstrap.Modal.getInstance(document.getElementById("editProgressModal" + progressID));
                            if (modal)
                                modal.hide();
                            location.reload();
                        })

                        .catch(error => {
                            console.error("❌ Edit or status update failed:", error.message || error);
                            alert("❌ Failed to update progress or status.\n\n" + error.message || error);
                        });

            }
        </script>

    </body>
</html>
