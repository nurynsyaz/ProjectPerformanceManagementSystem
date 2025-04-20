<%-- 
    Document   : index
    Created on : 3 Mar 2025, 12:59:30 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

        <title>Project Performance Management System</title>
    </head>
    <body>
        <nav class="navbar fixed-top navbar-expand-sm navbar-light custom-navbar">
            <div class="container">
                <a href="#" class="navbar-brand mb-0 h1">
                    <img class="d-inline-block align-top" src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" alt="PPMS Logo" width="85" height="80">
                </a>
                <button type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" class="navbar-toggler" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>    
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a href="#" class="nav-link active">Home</a></li> 
                        <li class="nav-item"><a href="signup.jsp" class="nav-link">Sign Up</a></li>
                        <li class="nav-item"><a href="#about-us" class="nav-link">About</a></li>
                        <li class="nav-item"><a href="#contact-us" class="nav-link">Contact</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Title Section -->
        <div class="title-container" style="padding-top: 200px;"> <!-- Add padding-top to account for the fixed navbar -->
            <div class="title-content">
                <h1>Project Performance Management System</h1>
                <p class="description">
                    A comprehensive solution designed to track, evaluate, and enhance project performance efficiently. 
                    Stay organized, improve collaboration, and achieve project goals seamlessly.
                </p>
                <a href="login.jsp" class="btn btn-primary login-btn">Login Here</a>
            </div>
        </div>

        <!-- About Us Section -->
            <div class="container about-us" id="about-us">
                <h2>ABOUT US</h2>
                <p>PPMS is a comprehensive system designed to manage and monitor project performance effectively.</p>
                <p> This system was created by Nurin Syazwani Binti Faizal Azmir for Final Year Project during 3rd Year of Bachelor of Computer Science (Software Engineering) with Honours in Universiti Malaysia Terengganu (UMT).</p>
            </div>

            <!-- Contact Us Section -->
            <div class="container contact-us" id="contact-us">
                <h2>CONTACT US</h2>
                <p>If you have any questions or need assistance, feel free to reach out to us!</p>
                <div class="row">
                    <div class="col-md-3 text-center box">
                        <h4>Email Us</h4>
                        <p><a href="mailto:support@ppms.com">support@ppms.com</a></p>
                    </div>
                    <div class="col-md-3 text-center box">
                        <h4>Call Us</h4>
                        <p><a href="tel:+44 1234 567890">+44 1234 567890</a></p>
                    </div>
                    
                </div>
            </div>

        <!-- Footer -->
        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
    </body>
</html>