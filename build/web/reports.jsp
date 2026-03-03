<%-- 
    Document   : reports
    Created on : 15 Feb 2026, 10:43:20
    Author     : PC
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: Arial; padding: 20px; }
        .card {
            background: #f4f4f4;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<h2>Reservation Reports</h2>

<div class="card">
    <h3>Total Reservations</h3>
    <p id="totalReservations"></p>
</div>

<div class="card">
    <h3>Total Revenue</h3>
    <p id="totalRevenue"></p>
</div>

<div class="card">
    <h3>Reservations by Room Type</h3>
    <canvas id="roomChart"></canvas>
</div>

<div class="card">
    <h3>Monthly Revenue</h3>
    <canvas id="monthlyChart"></canvas>
</div>

<script>
fetch('reports')
.then(response => response.json())
.then(data => {

    document.getElementById("totalReservations").innerText = data.totalReservations;
    document.getElementById("totalRevenue").innerText = "LKR " + data.totalRevenue;

    const roomLabels = data.roomTypeData.map(r => r.room);
    const roomCounts = data.roomTypeData.map(r => r.count);

    new Chart(document.getElementById("roomChart"), {
        type: 'bar',
        data: {
            labels: roomLabels,
            datasets: [{
                label: 'Reservations',
                data: roomCounts
            }]
        }
    });

    const monthLabels = data.monthlyData.map(m => "Month " + m.month);
    const monthRevenue = data.monthlyData.map(m => m.revenue);

    new Chart(document.getElementById("monthlyChart"), {
        type: 'line',
        data: {
            labels: monthLabels,
            datasets: [{
                label: 'Revenue',
                data: monthRevenue
            }]
        }
    });

});
</script>

</body>
</html>

