<%-- 
    Document   : projectTimeline
    Created on : 1 Apr 2025, 8:33:01 am
    Author     : nurin
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Project Timeline</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="main-content">
        <div class="welcome-container">
            <h2>Project Timeline</h2>

            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Project ID</th>
                            <th>Project Name</th>
                            <th>Status</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ppms", "root", "admin");

                                String query = "SELECT pt.projectID, p.projectName, s.statusDescription, pt.startDate, pt.endDate " +
                                               "FROM Project_Timeline pt " +
                                               "JOIN projects p ON pt.projectID = p.projectID " +
                                               "JOIN status s ON pt.statusID = s.statusID";

                                ps = conn.prepareStatement(query);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("projectID") %></td>
                            <td><%= rs.getString("projectName") %></td>
                            <td><%= rs.getString("statusDescription") %></td>
                            <td><%= rs.getDate("startDate") %></td>
                            <td><%= rs.getDate("endDate") != null ? rs.getDate("endDate") : "Ongoing" %></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <footer>
        &copy; 2025 Project Performance Management System
    </footer>
</body>
</html>

