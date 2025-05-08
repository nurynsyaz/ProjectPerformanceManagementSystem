<%-- 
    Document   : projectProgressChart
    Created on : 21 Apr 2025, 2:33:37 pm
    Author     : nurin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<div class="chart-card-wide-x">
    <h5 class="text-center">Project Task Status Distribution</h5>
    <canvas id="projectProgressChart"></canvas>
</div>

<style>
    .chart-card-wide-x {
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 30px auto;
        width: 1000px;
        text-align: center;
    }

    .chart-card-wide-x canvas {
        width: 950px !important;
        height: 400px !important;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    fetch("ProjectProgressServlet")
        .then(response => response.json())
        .then(data => {
            const projectNames = data.map(item => item.projectName);
            const inProgressData = data.map(item => item.inProgress);
            const onTimeData = data.map(item => item.onTime);
            const delayedData = data.map(item => item.delayed);
            const notStartedData = data.map(item => item.notStarted);

            const ctx = document.getElementById('projectProgressChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: projectNames,
                    datasets: [
                        { label: 'In Progress', data: inProgressData, backgroundColor: 'rgba(255, 165, 0, 0.7)' },
                        { label: 'On-Time', data: onTimeData, backgroundColor: 'rgba(0, 128, 0, 0.7)' },
                        { label: 'Delayed', data: delayedData, backgroundColor: 'rgba(255, 0, 0, 0.7)' },
                        { label: 'Not Started', data: notStartedData, backgroundColor: 'rgba(128, 128, 128, 0.7)' }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' },
                        tooltip: { mode: 'index', intersect: false }
                    },
                    scales: {
                        x: {
                            stacked: true,
                            title: { display: true, text: 'Projects' }
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            title: { display: true, text: 'Number of Tasks' }
                        }
                    }
                }
            });
        });
</script>
