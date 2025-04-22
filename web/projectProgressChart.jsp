<%-- 
    Document   : projectProgressChart
    Created on : 21 Apr 2025, 2:33:37 pm
    Author     : nurin
--%>

<%@ page contentType="application/json; charset=UTF-8" %>
<div class="card shadow p-4">
    <h5 class="text-center">Project Task Status Distribution</h5>
    <canvas id="projectProgressChart" width="400" height="400"></canvas>
</div>

<div class="card shadow p-4 mt-4">
    <h5 class="text-center">Project Completion Percentages</h5>
    <canvas id="completionChart" width="400" height="400"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const centerLabelPlugin = {
        id: 'centerLabelPlugin',
        beforeDraw(chart) {
            const { width, height, ctx } = chart;
            const total = chart.config.data.datasets[0].data.reduce((a, b) => a + b, 0);
            ctx.restore();
            ctx.font = 'bold 22px sans-serif';
            ctx.textBaseline = 'middle';
            ctx.fillStyle = '#000';
            const text = total.toString();
            const textX = (width - ctx.measureText(text).width) / 2;
            const textY = height / 2;
            ctx.fillText(text, textX, textY);
            ctx.save();
        }
    };

    // Chart for Task Status
    fetch("ProjectProgressServlet")
        .then(response => response.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);
            const ctx = document.getElementById('projectProgressChart').getContext('2d');

            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Task Status',
                        data: values,
                        backgroundColor: [
                            'rgba(255, 165, 0, 0.7)',
                            'rgba(0, 128, 0, 0.7)',
                            'rgba(255, 0, 0, 0.7)',
                            'rgba(255, 165, 0, 0.5)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    cutout: '75%',
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.parsed;
                                    return `${label}: ${value} tasks`;
                                }
                            }
                        }
                    }
                },
                plugins: [centerLabelPlugin]
            });
        })
        .catch(err => console.error("Chart load error:", err));

    // Chart for Project Completion Percentages
    fetch('GetProjectCompletionDataServlet')
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById('completionChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Completion %',
                        data: data.values,
                        backgroundColor: ['#4caf50', '#f44336', '#ff9800', '#2196f3', '#9c27b0'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    return tooltipItem.label + ': ' + tooltipItem.raw + '%';
                                }
                            }
                        }
                    }
                },
                plugins: [centerLabelPlugin]
            });
        });
</script>
