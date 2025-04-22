<%-- 
    Document   : projectChart
    Created on : 4 Apr 2025, 12:18:57 pm
    Author     : nurin
--%>
<%@page import="java.sql.*"%>
<%@page import="db.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int totalProjects = 0;
    try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM projects");
        if (rs.next()) {
            totalProjects = rs.getInt("total");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="chart-card-wide">
    <h4 class="text-center">Total Projects in System</h4>
    <canvas id="projectChartAll"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const allCenterText = {
        id: 'allCenterText',
        beforeDraw(chart) {
            const { width, height, ctx } = chart;
            ctx.restore();
            ctx.font = "bold 32px sans-serif";
            ctx.textBaseline = 'middle';
            ctx.fillStyle = '#000';
            const text = '<%= totalProjects %>';
            const textX = (width - ctx.measureText(text).width) / 2;
            const textY = height / 2;
            ctx.fillText(text, textX, textY);
            ctx.save();
        }
    };

    const ctxAll = document.getElementById('projectChartAll').getContext('2d');
    new Chart(ctxAll, {
        type: 'doughnut',
        data: {
            labels: ['Projects'],
            datasets: [{
                label: 'Total Projects',
                data: [<%= totalProjects %>, 100 - <%= totalProjects %>],
                backgroundColor: ['rgba(54, 162, 235, 0.7)', '#e9ecef'],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            cutout: '70%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            return `${context.label}: ${context.parsed}`;
                        }
                    }
                }
            }
        },
        plugins: [allCenterText]
    });
</script>

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
