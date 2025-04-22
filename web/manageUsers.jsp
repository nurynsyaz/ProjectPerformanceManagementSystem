<%-- 
    Document   : manageUsers
    Created on : 24 Mar 2025, 10:43:03 pm
    Author     : nurin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage All Users</title>
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <header>
            <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
                <div class="container">
                    <a class="navbar-brand mb-0 h1">
                        <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                    </a>
                </div>
            </nav>
        </header>

        <div class="container-fluid mt-5">
            <div class="row">
                <div class="container-sidebar">
                    <jsp:include page="sidebar.jsp" />
                </div>

                <main class="main d-flex flex-column align-items-center">
                    <div class="container mt-5">
                        <div class="col-md-12">
                            <div class="card shadow p-4">
                                <div class="text-center mb-4">
                                    <h2>Manage All Users</h2>
                                    <%
                                        String status = request.getParameter("status");
                                        if (status != null) {
                                            String alertClass = "success";
                                            String message = "";

                                            switch (status) {
                                                case "added":
                                                    message = "✅ New Client Added Successfully!";
                                                    break;
                                                case "client_deleted":
                                                case "deleted":
                                                    message = "🗑️ User Deleted Successfully!";
                                                    break;
                                                case "delete_failed":
                                                    alertClass = "danger";
                                                    message = "❌ Failed to Delete User!";
                                                    break;
                                                case "add_failed":
                                                    alertClass = "danger";
                                                    message = "❌ Failed to Add Client!";
                                                    break;
                                            }
                                    %>
                                    <div class="alert alert-<%= alertClass%> alert-dismissible fade show text-center" role="alert">
                                        <strong><%= message%></strong>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <% } %>
                                </div>

                                <div class="table-container">
                                    <!-- Add New Client Button -->
                                    <div class="mb-3 d-flex justify-content-end">
                                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addClientModal">
                                            <i class='bx bx-user-plus'></i> Add New Client
                                        </button>
                                    </div>

                                    <!-- Add Client Modal -->
                                    <div class="modal fade" id="addClientModal" tabindex="-1" aria-labelledby="addClientModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <form method="post" action="${pageContext.request.contextPath}/AddClientServlet">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="addClientModalLabel">Add New Client</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <% if (request.getAttribute("addClientError") != null) {%>
                                                        <div class="alert alert-danger text-center">
                                                            <%= request.getAttribute("addClientError")%>
                                                        </div>
                                                        <% } %>

                                                        <div class="form-group mb-2">
                                                            <label for="username">Username</label>
                                                            <input type="text" class="form-control" name="username" required>
                                                            <small class="text-muted">Username must be unique and contain only letters, numbers, or underscores.</small>
                                                        </div>
                                                        <div class="form-group mb-2">
                                                            <label for="email">Email</label>
                                                            <input type="email" class="form-control" name="email" required>
                                                            <small class="text-muted">Enter a valid email address (e.g., user@example.com).</small>
                                                        </div>
                                                        <div class="form-group mb-2">
                                                            <label for="phoneNumber">Phone Number</label>
                                                            <input type="text" class="form-control" name="phoneNumber" required>
                                                            <small class="text-muted">Phone number must be exactly 10 digits (e.g., 0123456789).</small>
                                                        </div>
                                                        <div class="form-group mb-2">
                                                            <label for="password">Password</label>
                                                            <input type="password" class="form-control" name="password" required>
                                                            <small class="text-muted">
                                                                Password must contain:
                                                                <ul>
                                                                    <li>At least 8 characters</li>
                                                                    <li>One uppercase letter</li>
                                                                    <li>One lowercase letter</li>
                                                                    <li>One digit</li>
                                                                    <li>One special character (@#$%^&+=!)</li>
                                                                </ul>
                                                            </small>
                                                        </div>
                                                        <div class="form-group mb-2">
                                                            <label for="passwordHint">Password Hint</label>
                                                            <input type="text" class="form-control" name="passwordHint" required>
                                                            <small class="text-muted">This hint will help clients recover their password if forgotten.</small>
                                                        </div>

                                                        <!-- Hidden roleID for Client -->
                                                        <input type="hidden" name="roleID" value="4">
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="submit" class="btn btn-primary">Add User</button>
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>


                                    <table class="table table-striped table-bordered">
                                        <thead class="table-dark text-center">
                                            <tr>
                                                <th>User ID</th>
                                                <th>Username</th>
                                                <th>Email</th>
                                                <th>Phone Number</th>
                                                <th>Role ID</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<User> users = (List<User>) request.getAttribute("users");
                                                if (users != null && !users.isEmpty()) {
                                                    for (User user : users) {
                                            %>
                                            <tr class="text-center">
                                                <td><%= user.getUserID()%></td>
                                                <td><%= user.getUsername()%></td>
                                                <td><%= user.getEmail()%></td>
                                                <td><%= user.getPhoneNumber()%></td>
                                                <td><%= user.getRoleID()%></td>
                                                <td>
                                                    <a href="DeleteUserServlet?userID=<%= user.getUserID()%>" class="btn btn-sm btn-danger"
                                                       onclick="return confirm('Are you sure you want to delete this user?');">
                                                        <i class='bx bx-trash'></i> Delete
                                                    </a>
                                                </td>
                                            </tr>
                                            <% }
                                    } else { %>
                                            <tr>
                                                <td colspan="6" class="text-center">No users found.</td>
                                            </tr>
                                            <% } %>
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

        <!-- Auto-show modal if validation error occurred -->
        <script>
            <% if ("true".equals(request.getAttribute("showAddClientModal"))) { %>
                                                           var addClientModal = new bootstrap.Modal(document.getElementById('addClientModal'));
                                                           addClientModal.show();
            <% }%>
        </script>

    </body>
</html>
