<%-- 
    Document   : login
    Created on : 3 Mar 2025, 3:01:00 pm
    Author     : nurin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <title>Login Form</title>
    </head>
    
    <body class="d-flex align-items-center justify-content-center vh-100 bg-light">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow p-4">
                        <h2 class="text-center mb-4">Login Form</h2>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger text-center">
                                ${errorMessage}
                            </div>
                        </c:if>

                        <form action="login" method="POST">
                            <div class="mb-3">
                                <label for="username" class="form-label"><b>Username</b></label>
                                <input type="text" class="form-control" placeholder="Enter Username" name="username" id="username" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label"><b>Password</b></label>
                                <input type="password" class="form-control" placeholder="Enter Password" name="password" id="password" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label"><b>Select Role</b></label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role1" name="role" value="1" required>
                                    <label class="form-check-label" for="role1">Head Manager</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role2" name="role" value="2">
                                    <label class="form-check-label" for="role2">Project Manager</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role3" name="role" value="3">
                                    <label class="form-check-label" for="role3">Team Member</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" id="role4" name="role" value="4">
                                    <label class="form-check-label" for="role4">Client</label>
                                </div>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" name="remember" id="remember">
                                <label class="form-check-label" for="remember">Remember Me</label>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">Login</button>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary w-100 mt-2">Cancel</a>

                            <div class="text-center mt-3">
                                Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp">Register Here</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Link to the external loginvalidation.js file -->
        <script src="${pageContext.request.contextPath}/assets/js/loginvalidation.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYkQnUZNnAtGmYI1GNhMwDzA2lL5x1sNj4R4L+iwG0aF/zlr+iJo36Kwf" crossorigin="anonymous"></script>
    </body>
</html>
