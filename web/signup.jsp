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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <!-- Custom CSS -->
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
                                <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="Enter Username" required>
                                <small class="text-muted">Only letters, numbers, underscores. Must be unique.</small>
                            </div>

                            <div class="mb-2">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${param.email}" placeholder="Enter Email" required>
                                <small class="text-muted">e.g., user@example.com</small>
                            </div>

                            <div class="mb-2">
                                <label for="phoneNumber" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${param.phoneNumber}" placeholder="e.g., 0123456789" required>
                                <small class="text-muted">Exactly 10 digits.</small>
                            </div>

                            <div class="mb-2">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter Password" required>
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
                                <input type="text" class="form-control" name="securityAnswer" id="securityAnswer" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label d-block">Select Role</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role1" name="role" value="1" ${param.role == '1' ? 'checked' : ''} required>
                                    <label class="form-check-label" for="role1">Head Manager</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role2" name="role" value="2" ${param.role == '2' ? 'checked' : ''}>
                                    <label class="form-check-label" for="role2">Project Manager</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role3" name="role" value="3" ${param.role == '3' ? 'checked' : ''}>
                                    <label class="form-check-label" for="role3">Team Member</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role4" name="role" value="4" ${param.role == '4' ? 'checked' : ''}>
                                    <label class="form-check-label" for="role4">Client</label>
                                </div>
                                <small class="text-muted">Choose your role in the system.</small>
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/signupvalidation.js"></script>
</body>
</html>
