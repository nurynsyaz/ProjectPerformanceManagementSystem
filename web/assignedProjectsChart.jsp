<%-- 
    Document   : assignedProjectsChart
    Created on : 21 Apr 2025, 5:00:17 pm
    Author     : nurin
--%>

<div class="card shadow p-4">
    <h5 class="text-center">Your Assigned Projects</h5>
    <canvas id="projectChart" width="400" height="400"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const centerTextPlugin = {
        id: 'centerTextPlugin',
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

    fetch("UserAssignmentChartServlet")
        .then(response => response.json())
        .then(data => {
            const ctx = document.getElementById('projectChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ["Assigned Projects"],
                    datasets: [{
                        label: 'Projects',
                        data: [data["Assigned Projects"]],
                        backgroundColor: ['rgba(54, 162, 235, 0.7)']
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
                                    return context.label + ": " + context.parsed + " projects";
                                }
                            }
                        }
                    }
                },
                plugins: [centerTextPlugin]
            });
        });
</script>