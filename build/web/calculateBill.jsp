<%-- 
    Document   : calculateBill.jsp
    Created on : 15 Feb 2026, 10:42:36
    Author     : PC
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Calculate Bill</title>
<style>
body {
    font-family: 'Segoe UI';
    background: #1f1f1f;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.bill-box {
    background: #2d2d2d;
    padding: 40px;
    border-radius: 10px;
    width: 350px;
    box-shadow: 0 0 20px #00ffcc;
}

input, select {
    width: 100%;
    padding: 8px;
    margin: 10px 0;
}

button {
    width: 100%;
    padding: 10px;
    background: #00ffcc;
    border: none;
    cursor: pointer;
    font-weight: bold;
}
</style>
</head>
<body>

<div class="bill-box">
<h2>Calculate Bill</h2>

<form action="calculateBill" method="post">
    <input type="number" name="nights" placeholder="Number of Nights" required>

    <select name="roomType">
        <option value="5000">Standard - Rs 5000</option>
        <option value="8000">Deluxe - Rs 8000</option>
        <option value="12000">Suite - Rs 12000</option>
    </select>

    <button type="submit">Generate Bill</button>
</form>
</div>

</body>
</html>
