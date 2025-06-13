<%-- 
    Document   : signup
    Created on : 3 Mar 2025, 3:14:40 pm
    Author     : nurin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Register Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="d-flex align-items-center justify-content-center vh-100 bg-light">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow p-4">
                <h2 class="text-center mb-4">Register</h2>

                <c:if test="${not empty message}">
                    <div class="alert alert-danger text-center">
                        <c:out value="${message}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="e.g. nurin_99" required>
                                <small class="text-muted">Only letters, numbers, underscores. Must be unique.</small>
                            </div>

                            <div class="mb-2">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${param.email}" placeholder="e.g. user@example.com" required>
                                <small class="text-muted">Please use a valid email format.</small>
                            </div>

                            <div class="mb-2">
                                <label for="phoneNumber" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${param.phoneNumber}" placeholder="e.g. 0123456789" required>
                                <small class="text-muted">Exactly 10 digits without dashes or spaces.</small>
                            </div>

                            <div class="mb-2">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
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

                                <!-- Progress Bar -->
                                <div class="progress mt-2" style="height: 8px;">
                                    <div id="pwStrengthBar" class="progress-bar" role="progressbar" style="width: 0%;"></div>
                                </div>
                                <small id="pwStrengthText" class="form-text text-muted mt-1"></small>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="col-md-6">
                            <div class="mb-2">
                                <label for="securityQuestion" class="form-label">Security Question</label>
                                <select class="form-select" name="securityQuestion" id="securityQuestion" required>
                                    <option value="" disabled selected>Select a question</option>
                                    <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                                    <option value="What was your first pet's name?">What was your first pet's name?</option>
                                    <option value="What is your favorite book?">What is your favorite book?</option>
                                </select>
                            </div>

                            <div class="mb-2">
                                <label for="securityAnswer" class="form-label">Your Answer</label>
                                <input type="text" class="form-control" name="securityAnswer" id="securityAnswer" placeholder="e.g. Harry Potter" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label d-block">Select Role</label>
                                <div class="form-check"><input class="form-check-input" type="radio" id="role1" name="role" value="1" ${param.role == '1' ? 'checked' : ''} required><label class="form-check-label" for="role1">Head Manager</label></div>
                                <div class="form-check"><input class="form-check-input" type="radio" id="role2" name="role" value="2" ${param.role == '2' ? 'checked' : ''}><label class="form-check-label" for="role2">Project Manager</label></div>
                                <div class="form-check"><input class="form-check-input" type="radio" id="role3" name="role" value="3" ${param.role == '3' ? 'checked' : ''}><label class="form-check-label" for="role3">Team Member</label></div>
                                <div class="form-check"><input class="form-check-input" type="radio" id="role4" name="role" value="4" ${param.role == '4' ? 'checked' : ''}><label class="form-check-label" for="role4">Client</label></div>
                                <small class="text-muted">Select your role in the system.</small>
                            </div>
                        </div>
                    </div>

                    <hr class="text-secondary">
                    <button type="submit" class="btn btn-primary w-100">Register</button>
                </form>

                <button type="button" class="btn btn-danger w-100 mt-2" onclick="window.location.href = 'index.jsp'">Cancel</button>
                <div class="text-center mt-3">
                    Already have an account? <a href="login.jsp">Login Here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Password Strength Logic -->
<script>
    const passwordInput = document.getElementById("password");
    const pwStrengthBar = document.getElementById("pwStrengthBar");
    const pwStrengthText = document.getElementById("pwStrengthText");

    passwordInput.addEventListener("input", function () {
        const password = passwordInput.value;
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
            pwStrengthText.textContent = "Medium strength password";
        } else {
            pwStrengthBar.style.width = "100%";
            pwStrengthBar.className = "progress-bar bg-success";
            pwStrengthText.textContent = "Strong password";
        }
    });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/signupvalidation.js"></script>
</body>
</html>

