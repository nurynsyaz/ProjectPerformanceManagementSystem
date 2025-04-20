<%-- 
    Document   : profile
    Created on : 17 Mar 2025, 3:41:36 pm
    Author     : nurin
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    User loggedInUser = userDAO.getUserByUsername(username);

    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email = loggedInUser.getEmail();
    String phoneNumber = loggedInUser.getPhoneNumber();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Update Profile</title>
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
        <div class="container-sidebar">
            <jsp:include page="sidebar.jsp"/>
        </div>
        <main class="main d-flex justify-content-center align-items-center">
    <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow p-4 mt-5">
                            <h2 class="text-center mb-4">Update Profile</h2>
                            <form id="updateProfileForm" action="${pageContext.request.contextPath}/UpdateProfileServlet" method="POST">
                                <div class="mb-3">
                                    <label for="username">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= username%>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="email">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= email%>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phoneNumber">Phone Number</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<%= phoneNumber%>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="password">New Password</label>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter new password">
                                </div>

                                <div class="mb-3">
                                    <label for="confirmPassword">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                                </div>

                                <button type="submit" class="btn btn-primary w-100">Update Profile</button>
                                <button type="button" id="cancelButton" class="btn btn-secondary w-100 mt-2">Cancel</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer class="text-center mt-auto">
            <p>&copy; 2024 PPMS. All rights reserved.</p>
        </footer>

        <script>
            document.getElementById("updateProfileForm").addEventListener("submit", function (event) {
                const password = document.getElementById("password").value;
                const confirmPassword = document.getElementById("confirmPassword").value;
                if (password && password !== confirmPassword) {
                    event.preventDefault();
                    alert("Passwords do not match.");
                }
            });

            document.getElementById("cancelButton").addEventListener("click", function () {
                document.getElementById("updateProfileForm").reset();
            });
        </script>
    </body>
</html>
