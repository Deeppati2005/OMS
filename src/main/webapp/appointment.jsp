<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment</title>
    <link rel="stylesheet" href="appointment.css">
    <script>
        // JavaScript to ensure only weekdays can be selected
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('appointment_date').addEventListener('change', function () {
                const selectedDate = new Date(this.value);
                const day = selectedDate.getDay(); // 0: Sunday, 1: Monday, ..., 6: Saturday
                
                if (day === 0 || day === 6) { // If selected date is Sunday or Saturday
                    alert("Please select a weekday (Monday to Friday).");
                    this.value = ""; // Clear the input
                }
            });

            // Validate phone number length
            document.getElementById('appointmentForm').addEventListener('submit', function(event) {
                const phoneNumber = document.getElementById('pat_number').value;
                if (phoneNumber.length !== 10) {
                    alert("Please enter a valid 10-digit phone number.");
                    event.preventDefault(); // Prevent form submission
                }
            });
        });
    </script>
</head>
<body>

<%
	String doc_fee = request.getParameter("doc_fee");
    String doc_name = request.getParameter("doc_name");
    String doc_email = request.getParameter("doc_email"); // Get the doctor's email from the URL parameter
    String pat_email = request.getParameter("pat_email");
    String message = ""; // To store the success or error message
    boolean appointmentBooked = false; // To track if the appointment was booked successfully

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS","root","Deep@123");

        // Fetch doctor's name dynamically based on the doc_name
        String sql = "SELECT doc_name, doc_fee FROM doctor WHERE doc_name= ?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setString(1, doc_name);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            doc_name = rs.getString("doc_name");
            doc_fee = String.valueOf(rs.getDouble("doc_fee"));
        }

        // Handle form submission
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String pat_name = request.getParameter("pat_name");
            String pat_number = request.getParameter("pat_number");
            String pat_gender = request.getParameter("pat_gender");
            String pat_age = request.getParameter("pat_age");
            String appointment_date = request.getParameter("appointment_date");
            String appointment_time = request.getParameter("appointment_time");

            // Ensure time is in the correct format HH:MM:SS
            String formattedTime = appointment_time;

            // Insert appointment details into the database
            String insertSQL = "INSERT INTO appointment (doctor_name, doctor_email, pat_name, pat_number, pat_email, pat_gender, pat_age, appointment_date, appointment_time,doc_fee) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ? , ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertSQL);
            insertStmt.setString(1, doc_name);
            insertStmt.setString(2, doc_email); // Set doctor's email
            insertStmt.setString(3, pat_name);
            insertStmt.setString(4, pat_number);
            insertStmt.setString(5, pat_email);
            insertStmt.setString(6, pat_gender);
            insertStmt.setInt(7, Integer.parseInt(pat_age));
            insertStmt.setDate(8, java.sql.Date.valueOf(appointment_date));  // YYYY-MM-DD format
            insertStmt.setTime(9, java.sql.Time.valueOf(formattedTime));  // HH:MM:SS format
            insertStmt.setDouble(10, Double.parseDouble(doc_fee));

            int rowsInserted = insertStmt.executeUpdate();
            if (rowsInserted > 0) {
                appointmentBooked = true;
                message = "Appointment booked successfully!";
            } else {
                message = "Failed to book appointment.";
            }
        }

    } 
    catch (Exception e) {
        e.printStackTrace(); // Print stack trace for debugging
        message = "An error occurred: " + e.getMessage(); // General error message
    }
    request.setAttribute("doc_name", doc_name);
    request.setAttribute("doc_fee", doc_fee);
%>

<div class="container">
    <h1>Book Appointment</h1>

    <form id="appointmentForm" method="post">
        <div class="form-group">
            <label for="doc_name">Doctor's Name</label>
            <input type="text" id="doc_name" name="doc_name" value="<%= request.getAttribute("doc_name") != null ? request.getAttribute("doc_name") : "" %>" readonly>
        </div>

        <div class="form-group">
            <label for="pat_name">Name</label>
            <input type="text" id="pat_name" name="pat_name" placeholder="Enter Patient name" required>
        </div>

        <div class="form-group">
            <label for="pat_number">Number</label>
            <input type="number" id="pat_number" name="pat_number" required>
        </div>

        <div class="form-group">
            <label for="pat_email">Email</label>
            <input type="text" id="pat_email" name="pat_email" value="<%= pat_email != null ? pat_email : "" %>" readonly>
        </div>

        <div class="form-group">
            <label for="pat_gender">Gender</label>
            <select name="pat_gender" id="pat_gender" required>
                <option value="" selected>Select your gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
            </select>
        </div>

        <div class="form-group">
            <label>Age</label>
            <input type="number" id="pat_age" name="pat_age" required>
        </div>

        <!-- Date Selection -->
        <div class="form-group">
            <label for="appointment_date">Appointment Date</label>
            <input type="date" id="appointment_date" name="appointment_date" required 
                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(java.util.Calendar.getInstance().getTime()) %>">
        </div>

        <!-- Appointment Time Selection -->
        <div class="form-group">
            <label for="appointment_time">Appointment Time</label>
            <select id="appointment_time" name="appointment_time" required>
                <option value="" selected>Select appointment time</option>
                <optgroup label="Morning Slots">
                    <option value="10:00:00">10:00 AM</option>
                    <option value="10:30:00">10:30 AM</option>
                    <option value="11:00:00">11:00 AM</option>
                    <option value="11:30:00">11:30 AM</option>
                </optgroup>
                <optgroup label="Evening Slots">
                    <option value="17:30:00">5:30 PM</option>
                    <option value="18:00:00">6:00 PM</option>
                    <option value="19:00:00">7:00 PM</option>
                    <option value="19:30:00">7:30 PM</option>
                </optgroup>
            </select>
        </div>
         <div class="form-group">
            <label for="doc_fee">Doctor's Fee(To be Collected After Check-up)</label>
            <input type="text" id="doc_fee" name="doc_fee" value="<%= request.getAttribute("doc_fee") != null ? request.getAttribute("doc_fee") : "" %>" readonly>
        </div>

        <button type="submit" id="bookAppointmentButton">Book Appointment</button>
    </form>

    <% if (appointmentBooked) { %>
        <script>
            alert('<%= message %>');
            window.location.href = 'patient_dashboard.jsp';
        </script>
    <% } else if (!message.isEmpty()) { %>
        <script>
            alert('<%= message %>');
        </script>
    <% } %>

</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('appointment_date');
        const timeSelect = document.getElementById('appointment_time');

        function validateDateTime() {
            const selectedDate = new Date(dateInput.value);
            const today = new Date();
            const day = selectedDate.getDay(); // 0: Sunday, 1: Monday, ..., 6: Saturday

            // Check for weekends
            if (day === 0 || day === 6) {
                alert("Please select a weekday (Monday to Friday).");
                dateInput.value = ""; // Clear the input
                return;
            }

            // If the selected date is today
            if (selectedDate.toDateString() === today.toDateString()) {
                const currentHours = today.getHours();
                const currentMinutes = today.getMinutes();
                const currentTimeInMinutes = currentHours * 60 + currentMinutes;

                // Get the selected time in minutes
                const selectedTimeParts = timeSelect.value.split(':');
                const selectedHours = parseInt(selectedTimeParts[0]);
                const selectedMinutes = parseInt(selectedTimeParts[1]);
                const selectedTimeInMinutes = selectedHours * 60 + selectedMinutes;

                // Compare times
                if (selectedTimeInMinutes < currentTimeInMinutes) {
                    alert("Please select a valid time.");
                    timeSelect.value = ""; // Clear the time selection
                }
            }
        }

        // Event listeners
        dateInput.addEventListener('change', validateDateTime);
        timeSelect.addEventListener('change', validateDateTime);
    });
</script>
</body>
</html>
