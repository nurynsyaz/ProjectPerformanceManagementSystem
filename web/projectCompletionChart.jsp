<%-- 
    Document   : projectCompletionChart
    Created on : 8 May 2025, 5:29:28 pm
    Author     : nurin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<div class="chart-card">
    <h5 class="text-center">Project Completion Status</h5>
    <canvas id="completionChart"></canvas>
</div>

<style>
    .chart-card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 30px auto;
        width: 1000px;
        text-align: center;
    }

    .chart-card canvas {
        width: 100% !important;
        height: 400px !important;
        max-width: 1000px;
        margin: 0 auto;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    fetch('GetProjectCompletionDataServlet')
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById('completionChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Number of Projects',
                        data: data.values,
                        backgroundColor: ['#ff9800', '#4caf50', '#f44336', '#9e9e9e'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    return tooltipItem.raw + ' project(s)';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Projects Count' }
                        },
                        x: {
                            title: { display: true, text: 'Status Category' }
                        }
                    }
                }
            });
        });
</script>

