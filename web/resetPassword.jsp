<%-- 
    Document   : resetPassword
    Created on : 21 Apr 2025, 5:58:33 pm
    Author     : nurin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Reset Password - PPMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/a076d05399.js"></script>
        <style>
            .reset-container {
                background: rgba(255, 255, 255, 0.95);
                padding: 30px;
                border-radius: 10px;
                max-width: 450px;
                width: 90%;
                margin: 120px auto;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }
            .reset-title {
                font-weight: bold;
                color: #222;
                margin-bottom: 25px;
            }
            .btn-reset {
                background-color: #007bff;
                color: white;
                width: 100%;
            }
            .btn-reset:hover {
                background-color: #0056b3;
            }
            .eye-icon {
                position: absolute;
                right: 15px;
                top: 35%;
                cursor: pointer;
                z-index: 10;
            }
        </style>
    </head>
    <body>
        <div class="title-container">
            <div class="reset-container">
                <h3 class="reset-title text-center">🔐 Reset Your Password</h3>

                <form action="ResetPasswordHandlerServlet" method="post">
                    <%
                        String phone = request.getParameter("phone");
                        if (phone != null) {
                    %>
                    <input type="hidden" name="phone" value="<%= URLEncoder.encode(phone, "UTF-8")%>">
                    <% } else { %>
                    <div class="alert alert-danger text-center">⚠️ Invalid or expired reset link.</div>
                    <% }%>

                    <div class="mb-3 position-relative">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                        <i class="fas fa-eye eye-icon" id="toggleNewPassword" onclick="togglePassword('newPassword')"></i>
                    </div>

                    <div class="mb-3 position-relative">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required>
                        <i class="fas fa-eye eye-icon" id="toggleConfirmPassword" onclick="togglePassword('confirmPassword')"></i>
                    </div>

                    <div class="mb-3">
                        <label for="securityQuestion" class="form-label">Security Question</label>
                        <select class="form-select" name="securityQuestion" id="securityQuestion" required>
                            <option value="" disabled selected>Select a question</option>
                            <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                            <option value="What was your first pet's name?">What was your first pet's name?</option>
                            <option value="What is your favorite book?">What is your favorite book?</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="securityAnswer" class="form-label">Your Answer</label>
                        <input type="text" class="form-control" name="securityAnswer" id="securityAnswer" required>
                    </div>


                    <button type="submit" class="btn btn-reset">Reset Password</button>
                </form>
            </div>
        </div>

        <script>
            function togglePassword(fieldId) {
                var field = document.getElementById(fieldId);
                var icon = document.getElementById("toggle" + fieldId.charAt(0).toUpperCase() + fieldId.slice(1));

                if (field.type === "password") {
                    field.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    field.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }
        </script>
    </body>
</html>
