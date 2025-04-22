<%-- 
    Document   : assignedTasksChart
    Created on : 21 Apr 2025, 5:00:43 pm
    Author     : nurin
--%>
<div class="card shadow p-4">
    <h5 class="text-center">Your Assigned Tasks</h5>
    <canvas id="taskChart" width="400" height="400"></canvas>
</div>

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
