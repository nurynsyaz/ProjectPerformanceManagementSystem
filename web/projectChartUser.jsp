<%-- 
    Document   : projectChartUser
    Created on : 4 Apr 2025, 12:46:30 pm
    Author     : nurin
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Project" %>
<%@ page import="dao.ProjectDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userID = null;
    int userProjectCount = 0;

    if (session != null) {
        userID = (Integer) session.getAttribute("userID");
    }

    if (userID != null) {
        ProjectDAO dao = new ProjectDAO();
        List<Project> userProjects = dao.getProjectsByUser(userID);
        userProjectCount = userProjects.size();
    }
%>

<div class="chart-card-wide">
    <h4 class="text-center">Your Projects</h4>

    <% if (userID == null) { %>
        <p class="text-danger text-center">⚠️ Please log in to view your chart.</p>
    <% } else { %>
        <canvas id="userProjectChart"></canvas>

        <script>
            const userCenterText = {
                id: 'userCenterText',
                beforeDraw(chart) {
                    const { width, height, ctx } = chart;
                    ctx.restore();
                    ctx.font = "bold 32px sans-serif";
                    ctx.textBaseline = 'middle';
                    ctx.fillStyle = '#000';

                    const text = '<%= userProjectCount %>';
                    const textX = (width - ctx.measureText(text).width) / 2;
                    const textY = height / 2;

                    ctx.fillText(text, textX, textY);
                    ctx.save();
                }
            };

            const ctxUser = document.getElementById('userProjectChart').getContext('2d');
            new Chart(ctxUser, {
                type: 'doughnut',
                data: {
                    labels: ['My Projects'],
                    datasets: [{
                        label: 'Project Count',
                        data: [<%= userProjectCount %>, 100 - <%= userProjectCount %>],
                        backgroundColor: ['rgba(75, 192, 192, 0.7)', '#e9ecef'],
                        borderWidth: 1
                    }]
                },
                options: {
                    cutout: '70%',
                    plugins: {
                        legend: { display: false }
                    }
                },
                plugins: [userCenterText]
            });
        </script>
    <% } %>
</div>

<style>
    .chart-card-wide {
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 20px auto;
        max-width: 500px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
    }

    .chart-card-wide canvas {
        width: 250px !important;  /* Fixed canvas size for consistency */
        height: 250px !important;
    }
</style>
