<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Ambulance</title>
    <link rel="stylesheet" href="appointment.css">
    <script>
        // Validate phone number length and time format
        document.getElementById('appointmentForm').addEventListener('submit', function(event) {
            const phoneNumber = document.getElementById('pat_number').value;
            const appointmentTime = document.getElementById('appointment_time').value;

            // Validate phone number length
            if (phoneNumber.length !== 10) {
                alert("Please enter a valid 10-digit phone number.");
                event.preventDefault(); // Prevent form submission
            }

            // Validate time format (HH:MM)
            const timePattern = /^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$/; // 24-hour format
            if (!timePattern.test(appointmentTime)) {
                alert("Please enter a valid time in the format HH:MM.");
                event.preventDefault(); // Prevent form submission
            }
        });
    </script>
</head>
<body>

<%
    String emer_car_no = request.getParameter("emer_car_no");
	String emer_type = request.getParameter("emer_type");
    String emer_email = request.getParameter("emer_email");
    String pat_email = request.getParameter("pat_email");
    String message = "";
    
    boolean appointmentBooked = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS","root","Deep@123");

        // Fetch driver's phone number based on car number.
        String sql = "SELECT * FROM emergency_service WHERE emer_car_no= ?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setString(1, emer_car_no);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
        }
        String emer_no = rs.getString("emer_no");

        // Handle form submission
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String pat_name = request.getParameter("pat_name");
            String pat_number = request.getParameter("pat_number");
            String pat_address = request.getParameter("pat_address");
            String booking_type = request.getParameter("booking_type");
            String appointment_date = request.getParameter("appointment_date");
            String appointment_time = request.getParameter("appointment_time");

            /* // Debugging: Log the time input value
            System.out.println("Appointment Time received: " + appointment_time); */

            // Ensure time is in the correct format (HH:MM:SS)
            if (appointment_time != null && !appointment_time.isEmpty()) {
                // Check if time is in HH:MM format, if so append :00 to make it HH:MM:SS
                if (!appointment_time.contains(":")) {
                    throw new IllegalArgumentException("Invalid time format. Time should be in HH:MM format.");
                }

                // Check if it is in HH:MM format
                if (appointment_time.length() == 5) {
                    appointment_time = appointment_time + ":00"; // Append :00 to make it HH:MM:SS
                }

                /* // Debugging: Log the adjusted time
                System.out.println("Formatted Appointment Time: " + appointment_time); */

            } else {
                throw new IllegalArgumentException("Appointment time is required and cannot be empty.");
            }

            // Insert appointment details into the database
            String insertSQL = "INSERT INTO booking (emer_car_no, emer_email, emer_no, booking_type, pat_name, pat_number, pat_email, pat_address, appointment_date, appointment_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertSQL);
            insertStmt.setString(1, emer_car_no);
            insertStmt.setString(2, emer_email);
            insertStmt.setString(3, emer_no);
            insertStmt.setString(4, booking_type);
            insertStmt.setString(5, pat_name);
            insertStmt.setString(6, pat_number);
            insertStmt.setString(7, pat_email);
            insertStmt.setString(8, pat_address);
            insertStmt.setDate(9, java.sql.Date.valueOf(appointment_date));  // Format: YYYY-MM-DD
            insertStmt.setTime(10, java.sql.Time.valueOf(appointment_time));  // Format: HH:MM:SS

            int rowsInserted = insertStmt.executeUpdate();
            if (rowsInserted > 0) {
                appointmentBooked = true;
                message = "Appointment booked successfully!";
            } else {
                message = "Failed to book appointment.";
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
        message = "SQL error: " + e.toString();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        message = "Driver not found: " + e.toString();
    } catch (IllegalArgumentException e) {
        e.printStackTrace();
        message = "Invalid input error: " + e.toString();  // Catch time format issues
    } catch (Exception e) {
        e.printStackTrace();
        message = "An unexpected error occurred: " + e.toString();
    }

    request.setAttribute("emer_car_no", emer_car_no);
%>

<div class="container">
    <h1>Book Ambulance</h1>

    <form id="appointmentForm" method="post">
        <div class="form-group">
            <label for="doc_name">Car Number</label>
            <input type="text" id="doc_name" name="doc_name" value="<%= request.getAttribute("emer_car_no") != null ? request.getAttribute("emer_car_no") : "" %>" readonly>
        </div>
        
        <div class="form-group">
            <label for="doc_name">Booking Type</label>
            <input type="text" id="booking_type" name="booking_type" value="<%= emer_type %>" readonly>
		</div>
        <div class="form-group">
            <label for="pat_name">Name</label>
            <input type="text" id="pat_name" name="pat_name" placeholder="Enter Patient name" required>
        </div>

        <div class="form-group">
            <label for="pat_number">Phone Number</label>
            <input type="number" id="pat_number" name="pat_number" placeholder="Enter Patient Phone Number" required>
        </div>
        
        <div class="form-group">
            <label for="pat_address">Address</label>
            <textarea id="pat_address" name="pat_address" placeholder="Enter your address" rows="4" cols="52" required></textarea>
        </div>

        <div class="form-group">
            <label for="pat_email">Email</label>
            <input type="text" id="pat_email" name="pat_email" value="<%= session.getAttribute("email") %>" readonly>
        </div>

        <!-- Date Selection -->
        <div class="form-group">
            <label for="appointment_date">Booking Date</label>
            <input type="date" id="appointment_date" name="appointment_date" required 
                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(java.util.Calendar.getInstance().getTime()) %>">
        </div>

        <!-- Appointment Time Selection -->
        <div class="form-group">
            <label for="appointment_time">Booking Time</label>
            <input type="time" id="appointment_time" name="appointment_time" required>
        </div>

        <button type="submit" id="bookAppointmentButton">Book Appointment</button>
    </form>

    <% if (appointmentBooked) { %>
        <script>
            alert('<%= message %>');
            window.location.href = 'patient_dashboard.jsp'; // Redirect to the dashboard after booking
        </script>
    <% } else if (!message.isEmpty()) { %>
        <script>
            alert('<%= message %>');
        </script>
    <% } %>

</div>
</body>
</html>
