<%-- 
    Document   : readNotifications
    Created on : 7 May 2025, 3:16:45 am
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Notification"%>
<%@page import="dao.NotificationDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Read Notifications</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body class="d-flex flex-column min-vh-100">

        <header>
            <nav class="navbar fixed-top navbar-expand-sm navbar custom-navbar">
                <div class="container">
                    <a href="#" class="navbar-brand mb-0 h1">
                        <img src="${pageContext.request.contextPath}/assets/img/PPMSlogo.png" width="85" height="80" alt="PPMS Logo" class="d-inline-block align-top">
                    </a>
                    <div class="ms-auto">
                        <jsp:include page="notifications.jsp"/>
                    </div>
                </div>
            </nav>
        </header>

        <%
            if (session == null || session.getAttribute("userID") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int userID = (int) session.getAttribute("userID");
            List<Notification> readNotifications = (List<Notification>) request.getAttribute("readNotifications");
        %>

        <div class="container-sidebar">
            <jsp:include page="sidebar.jsp"/>
        </div>

        <main class="main">
            <div class="container">
                <div class="welcome-container text-center">
                    <h2>📖 Read Notifications</h2>
                    <p>Below is the list of notifications you have already read.</p>
                </div>

                <!-- ✅ White Card Container -->
                <div class="card mt-4">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-dark">
                                    <tr>
                                        <th>#</th>
                                        <th>Message</th>
                                        <th>Date Read</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int count = 1;
                                        for (Notification notif : readNotifications) {
                                    %>
                                    <tr>
                                        <td><%= count++%></td>
                                        <td><%= notif.getMessage()%></td>
                                        <td><%= notif.getCreatedAt()%></td>
                                    </tr>
                                    <%
                                        }
                                        if (readNotifications.isEmpty()) {
                                    %>
                                    <tr>
                                        <td colspan="3" class="text-muted text-center">You have not read any notifications yet.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>


        <footer>
            <div class="container text-center">
                <p>&copy; 2024 PPMS. All rights reserved.</p>
            </div>
        </footer>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
