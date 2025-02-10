<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <!-- =============== Navigation ================ -->
    <div class="container">
        <div class="navigation">
            <ul>
                <li>
                    <a href="#">
                        <span class="icon">
                            <ion-icon name="medkit-outline"></ion-icon>
                        </span>
                        <span class="title">
                          Welcome, <%= session.getAttribute("pat_name") != null ? session.getAttribute("pat_name") : "Guest" %>
                        </span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp">
                        <span class="icon">
                            <ion-icon name="home-outline"></ion-icon>
                        </span>
                        <span class="title">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp?section=bookAppointments">
                        <span class="icon">
                            <ion-icon name="calendar-outline"></ion-icon>
                        </span>
                        <span class="title">Book appointments</span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp?section=myAppointments">
                        <span class="icon">
                            <ion-icon name="clipboard-outline"></ion-icon>
                        </span>
                        <span class="title">My appointments</span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp?section=bookAmbulance">
                        <span class="icon">
                            <ion-icon name="calendar-outline"></ion-icon>
                        </span>
                        <span class="title">Book Ambulance</span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp?section=viewBookings">
                        <span class="icon">
                            <ion-icon name="clipboard-outline"></ion-icon>
                        </span>
                        <span class="title">View Bookings</span>
                    </a>
                </li>
                <li>
                    <a href="patient_dashboard.jsp?section=editProfile">
                        <span class="icon">
                            <ion-icon name="person-outline"></ion-icon>
                        </span>
                        <span class="title">Edit Profile</span>
                    </a>
                </li>
                <li>
                    <a href="registration.jsp">
                        <span class="icon">
                            <ion-icon name="log-out-outline"></ion-icon>
                        </span>
                        <span class="title">Sign Out</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- ========================= Main ==================== -->
        <div class="main">
            <div class="topbar">
                <div class="toggle">
                    <ion-icon name="menu-outline"></ion-icon>
                </div>
            </div>

            <!-- ======================= Dynamic Section ================== -->
            <div class="details">
                <%
                    String patientEmail = (String) session.getAttribute("email");
                    if (patientEmail == null) {
                        response.sendRedirect("signin.jsp");
                        return;
                    }

                    String section = request.getParameter("section");
                    if ("bookAppointments".equals(section)) {
                %>
                <!-- Book Appointments Section -->
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Book Appointments</h2>
                    </div>
                    <div class="search">
                        <label>
                            <input type="text" placeholder="Search Doctor" id="searchInput" onkeyup="searchTable()" />
                            <ion-icon name="search-outline"></ion-icon>
                        </label>
                    </div>
                    <table id="doctorTable">
                        <thead>
                            <tr>
                                <td>Doctor Name</td>
                                <td>Doctor Email</td> <!-- New column for Doctor Email -->
                                <td>Specialty</td>
                                <td>Doctor Fee</td>
                                <td>Book Appointment</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
                                    
                                    // Fetch only verified doctors
                                    String sql = "SELECT * FROM doctor WHERE status = 'verified'";
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("doc_name") %></td>
                                <td><%= rs.getString("doc_email") %></td> <!-- Fetching and displaying Doctor Email -->
                                <td><%= rs.getString("doc_specialty") %></td>
                                <td><%= rs.getDouble("doc_fee") %></td>
                                <td><a href="appointment.jsp?doc_name=<%= rs.getString("doc_name") %>&doc_email=<%= rs.getString("doc_email") %>&pat_email=<%= patientEmail %>&doc_fee=<%= rs.getDouble("doc_fee") %>" class="btn-appointment">Book Appointment</a></td>
                            </tr>
                            <%
                                    }
                                    rs.close();
                                    ps.close();
                                    con.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    } else if ("myAppointments".equals(section)) {
                %>
                <!-- My Appointments Section -->
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>My Appointments</h2>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <td>Doctor Name</td>
                                <td>Patient Name</td>
                                <td>Patient Email</td>
                                <td>Appointment Date</td>
                                <td>Appointment Time</td>
                                <td>Doctor Fee</td>
                                <td>Status</td>
                                <td>Cancellation</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
                                    String sql = "SELECT appointment_id, doctor_name, pat_name, pat_email, appointment_date, appointment_time, doc_fee, pat_status FROM appointment WHERE pat_email= ?";
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    ps.setString(1, patientEmail);
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("doctor_name") %></td>
                                <td><%= rs.getString("pat_name") %></td>
                                <td><%= rs.getString("pat_email") %></td>
                                <td><%= rs.getDate("appointment_date") %></td>
                                <td><%= rs.getTime("appointment_time") %></td>
                                 <td><%= rs.getBigDecimal("doc_fee") %></td>
                                <td><%= rs.getString("pat_status") %></td>
                                <td><a href="javascript:void(0);" onclick="confirmCancellation(<%= rs.getInt("appointment_id") %>)" class="btn-appointment">Remove</a></td>
                            </tr>
                            <%
                                    }
                                    rs.close();
                                    ps.close();
                                    con.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    } else if ("bookAmbulance".equals(section)) {
                %>
                        <!-- Book Ambulance Section -->
                        <div class="recentOrders">
                            <div class="cardHeader">
                                <h2>Book Ambulance</h2>
                            </div>
                            <div class="search">
		                        <label>
		                            <input type="text" placeholder="Search Service Location or Type" id="searchEmergencyInput" onkeyup="searchEmergencyTable()" />
		                            <ion-icon name="search-outline"></ion-icon>
		                        </label>
		                    </div>
                            <table id="emerTable">
                                <thead>
                                    <tr>
                                        <td>Car No</td>
                                        <td>Car type</td>
                                        <td>Driver's Phone Number</td>
                                        <td>Car Location</td>
                                        <td>Book Ambulance</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
                                            String sql = "SELECT * from emergency_service WHERE status = 'verified';";
                                            PreparedStatement ps = con.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();
                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getString("emer_car_no") %></td>
                                        <td><%= rs.getString("emer_type") %></td>
                                        <td><%= rs.getString("emer_no") %></td>
                                        <td><%= rs.getString("emer_loc") %></td>
                                        <td><a href="booking.jsp?emer_car_no=<%= rs.getString("emer_car_no") %>&emer_type=<%= rs.getString("emer_type") %>&emer_email=<%= rs.getString("emer_email") %>&pat_email=<%= patientEmail %>%>" class="btn-appointment">Book Ambulance</a></td>
                                    </tr>    
                                    
                                    <%
                                            }
                                            rs.close();
                                            ps.close();
                                            con.close();
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                <%
                    } else if ("viewBookings".equals(section)) {
                %>
                        <!-- View Bookings Section -->
                        <div class="recentOrders">
                            <div class="cardHeader">
                                <h2>Current Bookings</h2>
                            </div>
                            <table>
                                <thead>
                                    <tr>
                                        <td>Car No</td>
                                        <td>Booking Type</td>
                                        <td>Driver Phone Number</td>
                                        <td>Patient Name</td>
                                        <td>Date</td>
                                        <td>Time</td>
                                        <td>Status</td>
                                        <td>Cancellation</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
                                            String sql = "SELECT * FROM booking WHERE pat_email= ?";
                                            PreparedStatement ps = con.prepareStatement(sql);
                                            ps.setString(1, patientEmail);
                                            ResultSet rs = ps.executeQuery();
                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getString("emer_car_no") %></td>
                                        <td><%= rs.getString("booking_type") %></td>
                                        <td><%= rs.getString("emer_no") %></td>
                                        <td><%= rs.getString("pat_name") %></td>
                                        <td><%= rs.getDate("appointment_date") %></td>
                                        <td><%= rs.getTime("appointment_time") %></td>
                                        <td><%= rs.getString("pat_status") %></td>
                                        <td><a href="javascript:void(0);" onclick="confirmCancellationBooking(<%= rs.getInt("booking_id") %>)" class="btn-appointment">Remove</a></td>
                                    </tr>
                                    <%
                                            }
                                            rs.close();
                                            ps.close();
                                            con.close();
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                <%
                                    
                    } else if ("editProfile".equals(section)) {
                %>
                <!-- Edit Profile Section -->
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Edit Profile</h2>
                    </div>
                    <form action="updateProfile.jsp" method="post">
                        <div class="formGroup">
                            <label for="pat_name">Name</label>
                            <input type="text" id="pat_name" name="pat_name" placeholder="Enter New Name" required />
                        </div>
                        <div class="formGroup">
                            <label for="pat_old_pass">Old Password</label>
                            <input type="password" id="pat_old_pass" name="pat_old_pass" placeholder="Enter old password" required />
                        </div>
                        <div class="formGroup">
                            <label for="pat_new_pass">New Password</label>
                            <input type="password" id="pat_new_pass" name="pat_new_pass" placeholder="Enter new password" required />
                        </div>
                        <div class="formGroup">
                            <button type="submit" class="btn-update">Update Profile</button>
                        </div>
                    </form>
                </div>
                <%
                    } else {
                %>
                <!-- Default Section (Dashboard) -->
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Welcome to the Dashboard</h2>
                    </div>
                    <div class="cardBox">
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
                                String sql = "SELECT doc_specialty, COUNT(*) as count FROM doctor WHERE status = 'verified' GROUP BY doc_specialty";
                                PreparedStatement ps = con.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                        %>
                        <div class="card">
                            <div class="numbers"><%= rs.getInt("count") %></div>
                            <div class="cardName"><%= rs.getString("doc_specialty") %></div>
                        </div>
                        <%
                                }
                                rs.close();
                                ps.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

<script>
    function searchTable() {
        let input = document.getElementById("searchInput");
        let filter = input.value.toLowerCase();
        let table = document.getElementById("doctorTable");
        let tr = table.getElementsByTagName("tr");

        // Loop through all rows, starting from index 1 to skip the header
        for (let i = 1; i < tr.length; i++) {
            let cells = tr[i].getElementsByTagName("td");
            let found = false;

            // Check each cell in the current row
            for (let j = 0; j < cells.length; j++) {
                let cell = cells[j];
                if (cell) {
                    // If the cell text matches the filter, mark as found
                    if (cell.innerHTML.toLowerCase().includes(filter)) {
                        found = true;
                        break; // No need to check more cells
                    }
                }
            }

            // Display or hide the row based on the found flag
            tr[i].style.display = found ? "" : "none";
        }
    }
    
 // Search Emergency Table
    function searchEmergencyTable() {
        let input = document.getElementById("searchEmergencyInput");
        let filter = input.value.toUpperCase();
        let table = document.getElementById("emerTable");
        let tr = table.getElementsByTagName("tr");

        for (let i = 0; i < tr.length; i++) {
            let tdType = tr[i].getElementsByTagName("td")[1];
            let tdLocation = tr[i].getElementsByTagName("td")[3];
            if (tdType || tdLocation) {
                let txtValueType = tdType.textContent || tdType.innerText;
                let txtValueLocation = tdLocation.textContent || tdLocation.innerText;
                if (txtValueType.toUpperCase().indexOf(filter) > -1 || txtValueLocation.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }

    function confirmCancellation(appointmentId) {
        if (confirm("Are you sure you want to cancel this appointment?")) {
            window.location.href = "cancelAppointment.jsp?appointment_id=" + appointmentId;
        }
    }
    
    function confirmCancellationBooking(bookingId) {
        if (confirm("Are you sure you want to cancel this booking?")) {
            window.location.href = "cancelBooking.jsp?booking_id=" + bookingId;
        }
    }

    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');

        if (status === 'success') {
            alert('Profile updated successfully!');
        } else if (status === 'failure') {
            alert('Profile update failed. Please try again.');
        }
    };
</script>
<script src="assets/js/main.js"></script>
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>
</html>
