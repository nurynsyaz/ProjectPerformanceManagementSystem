<%-- 
    Document   : assignedTasksChart
    Created on : 21 Apr 2025, 5:00:43 pm
    Author     : nurin
--%>
<div class="chart-card-wide">
    <h5 class="text-center">Your Assigned Tasks</h5>
    <canvas id="taskChart" width="400" height="400"></canvas>
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

<script>
    fetch("UserAssignmentChartServlet")
        .then(response => response.json())
        .then(data => {
            const ctx = document.getElementById('taskChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ["Assigned Tasks"],
                    datasets: [{
                        label: 'Tasks',
                        data: [data["Assigned Tasks"]],
                        backgroundColor: ['rgba(255, 99, 132, 0.7)']
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
                                    return context.label + ": " + context.parsed + " tasks";
                                }
                            }
                        }
                    }
                },
                plugins: [centerTextPlugin]
            });
        });
</script>
