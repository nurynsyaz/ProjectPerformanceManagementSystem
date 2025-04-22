<%-- 
    Document   : forgotPassword
    Created on : 21 Apr 2025, 5:55:11 pm
    Author     : nurin
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <style>
            .forgot-password-card {
                background: rgba(255, 255, 255, 0.95);
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                max-width: 450px;
                width: 90%;
                margin: auto;
                margin-top: 120px;
                text-align: center;
            }

            .forgot-password-card h4 {
                margin-bottom: 1.5rem;
                color: #222;
            }

            .forgot-password-card .form-label {
                font-weight: bold;
                text-align: left;
                display: block;
            }

            .forgot-password-card .btn-primary {
                background-color: #007bff;
                border: none;
                transition: background-color 0.3s ease;
            }

            .forgot-password-card .btn-primary:hover {
                background-color: #0056b3;
            }

            .text-start {
                text-align: start !important;
            }
        </style>
    </head>
    <body class="d-flex justify-content-center align-items-center vh-100" style="background-color: #f0f2f5;">

        <div class="forgot-password-card">
            <h4>🔐 Forgot Password</h4>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger text-center mt-3">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="ForgotPasswordVerifyServlet" method="post">
                <div class="mb-3 text-start">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="text" class="form-control" name="phone" id="phone" required>
                </div>
                <div class="mb-3 text-start">
                    <label for="passwordHint" class="form-label">Password Hint</label>
                    <input type="text" class="form-control" name="passwordHint" id="passwordHint" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Verify & Continue</button>
            </form>

            <div class="mt-3">
                <a href="login.jsp" class="text-decoration-none">Back to Login</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
