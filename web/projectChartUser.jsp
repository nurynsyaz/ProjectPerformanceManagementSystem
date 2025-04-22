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
    int createdProjectCount = 0;

    if (session != null) {
        userID = (Integer) session.getAttribute("userID");
    }

    if (userID != null) {
        ProjectDAO dao = new ProjectDAO();
        List<Project> allProjects = dao.getProjectsByUser(userID);
        for (Project p : allProjects) {
            if (p.getRoleID() == 1) {
                createdProjectCount++;
            }
        }
    }
%>

<div class="chart-card-wide">
    <h4 class="text-center">Your Created Projects</h4>

    <% if (userID == null) { %>
        <p class="text-danger text-center">⚠️ Please log in to view your chart.</p>
    <% } else { %>
        <canvas id="userProjectChart"></canvas>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const userCenterPlugin = {
                id: 'userCenterPlugin',
                beforeDraw(chart) {
                    const { width, height, ctx } = chart;
                    const total = chart.config.data.datasets[0].data[0];
                    ctx.restore();
                    ctx.font = "bold 32px sans-serif";
                    ctx.textBaseline = 'middle';
                    ctx.fillStyle = '#000';
                    const text = total.toString();
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
                    labels: ['Created Projects'],
                    datasets: [{
                        label: 'Project Count',
                        data: [<%= createdProjectCount %>, 100 - <%= createdProjectCount %>],
                        backgroundColor: ['rgba(75, 192, 192, 0.7)', '#e9ecef'],
                        borderWidth: 1
                    }]
                },
                options: {
                    cutout: '70%',
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.label + ": " + context.parsed + " projects";
                                }
                            }
                        }
                    }
                },
                plugins: [userCenterPlugin]
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
        width: 250px !important;
        height: 250px !important;
    }
</style>
