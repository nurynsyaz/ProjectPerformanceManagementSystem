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
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <title>Register Form</title>
    </head>
    <body class="d-flex align-items-center justify-content-center vh-100 bg-light">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card shadow p-4">
                        <h2 class="text-center mb-4">Register</h2>

                        <c:if test="${not empty message}">
                            <div class="alert alert-danger text-center">
                                <c:out value="${message}" />
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return validateForm()">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <input type="text" class="form-control" id="username" name="username" value="${param.username}" placeholder="Enter Username" required>
                                        <small id="usernameError" class="text-muted">Username must be unique and contain only letters, numbers, and underscores.</small>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${param.email}" placeholder="Enter Email" required>
                                        <small id="emailError" class="text-muted">Enter a valid email address (e.g., example@domain.com).</small>
                                    </div>
                                    <div class="mb-3">
                                        <label for="phoneNumber" class="form-label">Phone Number</label>
                                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${param.phoneNumber}" placeholder="Enter Phone Number" required>
                                        <small id="phoneError" class="text-muted">Phone number must be exactly 10 digits (e.g., 0123456789).</small>
                                    </div>
                                </div>

                                <!-- Vertical Divider -->
                                <div class="col-md-1 d-flex justify-content-center align-items-center">
                                    <div class="vertical-divider"></div>
                                </div>

                                <div class="col-md-5">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter Password" required>
                                        <small id="passwordError" class="text-muted">
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
                                    <div class="mb-3">
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
                                        <small id="roleError" class="text-muted">Select your role in the system.</small>
                                    </div>
                                </div>
                            </div>

                            <hr class="text-secondary">

                            <button type="submit" class="btn btn-primary w-100">Register</button>
                            <button type="button" class="btn btn-danger w-100 mt-2" onclick="window.location.href = 'index.jsp'">Cancel</button>
                            <div class="text-center mt-3">
                                Already have an account? <a href="login.jsp">Login Here</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Javascript -->
        <script src="${pageContext.request.contextPath}/assets/js/signupvalidation.js"></script>
    </body>
</html>