<%-- 
    Document   : viewProject
    Created on : 7 Mar 2025, 6:40:07 pm
    Author     : Nurin
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.Project"%>
<%@page import="model.User"%>
<%@page import="db.DBConnection"%>

<%
    List<User> eligibleUsers = (List<User>) request.getAttribute("eligibleUsers");
    List<Project> projects = (List<Project>) request.getAttribute("projects");
    Integer roleID = (Integer) session.getAttribute("roleID");
    String status = request.getParameter("status");
%>

<%!
    public String getRoleName(int roleID) {
        switch (roleID) {
            case 1:
                return "Head Manager";
            case 2:
                return "Project Manager";
            case 3:
                return "Team Member";
            case 4:
                return "Client";
            default:
                return "Unknown";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>View Projects</title>
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
                        <span class="bx bx-menu"></span>
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
                        <div class="card shadow p-4">
                            <div class="container text-center">
                                <h2 class="mb-4">Lists of Registered Project </h2>
                            </div>

                            <% if (status != null) {%>
                            <div class="alert alert-<%="added".equals(status) || "assigned".equals(status) || "removed".equals(status) ? "success"
                                    : "deleted".equals(status) ? "danger"
                                    : "add_failed".equals(status) || "delete_failed".equals(status)
                                    || "assign_failed".equals(status) || "remove_failed".equals(status)
                                    || "invalid_user_role".equals(status) ? "warning" : "info"%> alert-dismissible fade show text-center">
                                <strong>
                                    <%="added".equals(status) ? "Project Added Successfully!"
                                            : "deleted".equals(status) ? "Project Deleted Successfully!"
                                            : "assigned".equals(status) ? "User Assigned Successfully!"
                                            : "assign_failed".equals(status) ? "Failed to Assign User!"
                                            : "removed".equals(status) ? "User Removed from Project Successfully!"
                                            : "remove_failed".equals(status) ? "Failed to Remove User from Project!"
                                            : "invalid_user_role".equals(status) ? "Invalid User Role!"
                                            : ""%>
                                </strong>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% } %>

                            <% if (roleID != null && roleID == 1) { %>
                            <div class="mb-3 d-flex justify-content-end">
                                <a href="${pageContext.request.contextPath}/addProject.jsp" class="btn btn-success">
                                    <i class='bx bx-plus'></i> Add Project
                                </a>
                            </div>
                            <% } %>


                            <div class="table-container">
                                <table class="table table-striped table-bordered">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Project ID</th>
                                            <th>Project Name</th>
                                            <th>Project Details</th>
                                            <th>Created By</th>
                                            <th>Start Date</th> 
                                            <th>End Date</th>   
                                            <th class="text-center">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (projects != null && !projects.isEmpty()) {
                                                for (Project project : projects) {
                                        %>
                                        <tr>
                                            <td><%= project.getProjectID()%></td>
                                            <td><%= project.getProjectName()%></td>
                                            <td><%= project.getProjectDetails()%></td>
                                            <td><%= project.getUsername()%></td>
                                            <td><%= project.getProjectStartDate()%></td> 
                                            <td><%= project.getProjectEndDate()%></td>   
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/EditProjectServlet?projectID=<%= project.getProjectID()%>" class="btn btn-sm btn-primary me-2">
                                                    <i class='bx bx-edit'></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/DeleteProjectServlet?projectID=<%= project.getProjectID()%>" class="btn btn-sm btn-danger me-2" onclick="return confirm('Are you sure?');">
                                                    <i class='bx bx-trash'></i> Delete
                                                </a>

                                                <% if (roleID != null && roleID == 1) {%>
                                                <button class="btn btn-sm btn-secondary" data-bs-toggle="modal" data-bs-target="#assignModal<%= project.getProjectID()%>">
                                                    <i class='bx bx-user-plus'></i> Assign
                                                </button>

                                                <!-- Assign Modal -->
                                                <div class="modal fade" id="assignModal<%= project.getProjectID()%>" tabindex="-1">
                                                    <div class="modal-dialog modal-xl">
                                                        <form id="assignmentForm<%= project.getProjectID()%>" method="post">
                                                            <input type="hidden" name="projectID" value="<%= project.getProjectID()%>">
                                                            <input type="hidden" id="selectedUserID<%= project.getProjectID()%>" name="userID" value="">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Assign User to <%= project.getProjectName()%></h5>
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
                                                                                <% if (eligibleUsers != null && !eligibleUsers.isEmpty()) {
                                                                                        for (User user : eligibleUsers) {%>
                                                                                <tr class="text-center">
                                                                                    <td>
                                                                                        <input type="radio" name="selectUser<%= project.getProjectID()%>" value="<%= user.getUserID()%>"
                                                                                               onclick="document.getElementById('selectedUserID<%= project.getProjectID()%>').value = this.value">
                                                                                    </td>
                                                                                    <td><%= user.getUserID()%></td>
                                                                                    <td><%= user.getUsername()%></td>
                                                                                    <td><%= user.getEmail()%></td>
                                                                                    <td><%= user.getPhoneNumber()%></td>
                                                                                    <td><%= getRoleName(user.getRoleID())%></td>
                                                                                </tr>
                                                                                <% }
                                                                                } else { %>
                                                                                <tr><td colspan="6" class="text-center text-muted">No eligible users found.</td></tr>
                                                                                <% }%>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="submit" formaction="${pageContext.request.contextPath}/AddAssignmentServlet" class="btn btn-primary">Assign</button>
                                                                    <button type="submit" formaction="${pageContext.request.contextPath}/RemoveAssignmentServlet" class="btn btn-danger">Remove</button>
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>

                                                <button class="btn btn-sm btn-info mt-1" data-bs-toggle="modal" data-bs-target="#assignedUsersModal<%= project.getProjectID()%>">
                                                    <i class='bx bx-group'></i> View Assigned
                                                </button>

                                                <!-- Assigned Users Modal -->
                                                <div class="modal fade" id="assignedUsersModal<%= project.getProjectID()%>" tabindex="-1">
                                                    <div class="modal-dialog modal-xl">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title">Assigned Users for <%= project.getProjectName()%></h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="table-responsive">
                                                                    <table class="table table-bordered">
                                                                        <thead class="table-light text-center">
                                                                            <tr>
                                                                                <th>User ID</th>
                                                                                <th>Username</th>
                                                                                <th>Email</th>
                                                                                <th>Phone</th>
                                                                                <th>Role</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <%
                                                                                Map<Integer, List<User>> assignedUsersMap = (Map<Integer, List<User>>) request.getAttribute("assignedUsersMap");
                                                                                List<User> assignedUsers = assignedUsersMap != null ? assignedUsersMap.get(project.getProjectID()) : null;

                                                                                if (assignedUsers != null && !assignedUsers.isEmpty()) {
                                                                                    for (User user : assignedUsers) {
                                                                            %>
                                                                            <tr class="text-center">
                                                                                <td><%= user.getUserID()%></td>
                                                                                <td><%= user.getUsername()%></td>
                                                                                <td><%= user.getEmail()%></td>
                                                                                <td><%= user.getPhoneNumber()%></td>
                                                                                <td><%= getRoleName(user.getRoleID())%></td>
                                                                            </tr>
                                                                            <% }
                                                                            } else { %>
                                                                            <tr><td colspan="6" class="text-center text-muted">No eligible users available.</td></tr>
                                                                            <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% }
                                        } else { %>
                                        <tr><td colspan="5" class="text-center">No projects found.</td></tr>
                                        <% }%>
                                    </tbody>
                                </table>
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
                                                                                                   const alertBox = document.querySelector(".alert");
                                                                                                   if (alertBox) {
                                                                                                       alertBox.scrollIntoView({behavior: "smooth"});
                                                                                                   }
        </script>
    </body>
</html>

