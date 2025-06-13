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
    String securityQuestion = loggedInUser.getSecurityQuestion();
    String securityAnswer = loggedInUser.getSecurityAnswer();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Update Profile</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body class="d-flex flex-column min-vh-100">
<header>
    <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
        <div class="container">
            <a href="#" class="navbar-brand mb-0 h1">
                <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" width="85" height="80" alt="PPMS Logo">
            </a>
            <div class="ms-auto">
                <jsp:include page="notifications.jsp"/>
            </div>
        </div>
    </nav>
</header>

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
                            <input type="text" class="form-control" id="username" name="username" value="<%= username %>" required>
                            <small class="text-muted">Only letters, numbers, underscores. Must be unique.</small>
                        </div>

                        <div class="mb-3">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                            <small class="text-muted">e.g., user@example.com</small>
                        </div>

                        <div class="mb-3">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<%= phoneNumber %>" required>
                            <small class="text-muted">Exactly 10 digits.</small>
                        </div>

                        <div class="mb-3">
                            <label for="password">New Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter new password">
                            <small class="text-muted">
                                <a href="#" data-bs-toggle="collapse" data-bs-target="#pwHelp" style="text-decoration: underline;">Password requirements</a>
                            </small>
                            <div class="collapse" id="pwHelp">
                                <ul class="small mt-1">
                                    <li>At least 8 characters</li>
                                    <li>One uppercase letter</li>
                                    <li>One lowercase letter</li>
                                    <li>One digit</li>
                                    <li>One special character (@#$%^&+=!)</li>
                                </ul>
                            </div>
                            <div class="progress mt-2" style="height: 8px;">
                                <div id="pwStrengthBar" class="progress-bar" role="progressbar" style="width: 0%;"></div>
                            </div>
                            <small id="pwStrengthText" class="form-text mt-1 text-muted"></small>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                        </div>

                        <div class="mb-3" id="securityQAGroup" style="display: none;">
                            <label for="securityQuestion">Security Question</label>
                            <select class="form-select" id="securityQuestion" name="securityQuestion">
                                <option value="">Select a question</option>
                                <option value="What is your mother's maiden name?" <%= "What is your mother's maiden name?".equals(securityQuestion) ? "selected" : "" %>>What is your mother's maiden name?</option>
                                <option value="What was your first pet's name?" <%= "What was your first pet's name?".equals(securityQuestion) ? "selected" : "" %>>What was your first pet's name?</option>
                                <option value="What is your favorite book?" <%= "What is your favorite book?".equals(securityQuestion) ? "selected" : "" %>>What is your favorite book?</option>
                            </select>
                        </div>

                        <div class="mb-3" id="securityAnswerGroup" style="display: none;">
                            <label for="securityAnswer">Your Answer</label>
                            <input type="text" class="form-control" id="securityAnswer" name="securityAnswer" value="<%= securityAnswer != null ? securityAnswer : "" %>">
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

<!-- Password validation & strength checker -->
<script>
    const passwordField = document.getElementById("password");
    const confirmPasswordField = document.getElementById("confirmPassword");
    const securityQAGroup = document.getElementById("securityQAGroup");
    const securityAnswerGroup = document.getElementById("securityAnswerGroup");
    const securityQuestionSelect = document.getElementById("securityQuestion");
    const securityAnswerInput = document.getElementById("securityAnswer");
    const pwStrengthBar = document.getElementById("pwStrengthBar");
    const pwStrengthText = document.getElementById("pwStrengthText");

    function updateStrengthMeter(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[@#$%^&+=!]/.test(password)) strength++;

        if (!password) {
            pwStrengthBar.style.width = "0%";
            pwStrengthBar.className = "progress-bar";
            pwStrengthText.textContent = "";
        } else if (strength <= 2) {
            pwStrengthBar.style.width = "33%";
            pwStrengthBar.className = "progress-bar bg-danger";
            pwStrengthText.textContent = "Weak password";
        } else if (strength <= 4) {
            pwStrengthBar.style.width = "66%";
            pwStrengthBar.className = "progress-bar bg-warning";
            pwStrengthText.textContent = "Medium password";
        } else {
            pwStrengthBar.style.width = "100%";
            pwStrengthBar.className = "progress-bar bg-success";
            pwStrengthText.textContent = "Strong password";
        }
    }

    passwordField.addEventListener("input", function () {
        const value = passwordField.value;
        updateStrengthMeter(value);

        if (value.trim() !== "") {
            securityQAGroup.style.display = "block";
            securityAnswerGroup.style.display = "block";
            securityQuestionSelect.required = true;
            securityAnswerInput.required = true;
        } else {
            securityQAGroup.style.display = "none";
            securityAnswerGroup.style.display = "none";
            securityQuestionSelect.required = false;
            securityAnswerInput.required = false;
            securityQuestionSelect.value = "";
            securityAnswerInput.value = "";
        }
    });

    document.getElementById("updateProfileForm").addEventListener("submit", function (event) {
        if (passwordField.value && passwordField.value !== confirmPasswordField.value) {
            event.preventDefault();
            alert("Passwords do not match.");
        }
    });

    document.getElementById("cancelButton").addEventListener("click", function () {
        document.getElementById("updateProfileForm").reset();
        pwStrengthBar.style.width = "0%";
        pwStrengthBar.className = "progress-bar";
        pwStrengthText.textContent = "";
        securityQAGroup.style.display = "none";
        securityAnswerGroup.style.display = "none";
    });
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
