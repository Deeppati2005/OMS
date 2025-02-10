<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css" />
</head>

<body>
    <div class="container">
        <div class="navigation">
            <ul>
                <li>
                    <a href="#">
                        <span class="icon">
                            <ion-icon name="medkit-outline"></ion-icon>
                        </span>
                        <span class="title">
                         Welcome, <%= session.getAttribute("admin_name") != null ? session.getAttribute("admin_name") : "Guest" %>
                        </span>
                    </a>
                </li>
                <li>
                    <a href="admin_dashboard.jsp?section=doctorsListSection">
                        <span class="icon">
                            <ion-icon name="people-outline"></ion-icon>
                        </span>
                        <span class="title">Doctors List</span>
                    </a>
                </li>
                <li>
                    <a href="admin_dashboard.jsp?section=usersListSection">
                        <span class="icon">
                            <ion-icon name="people-outline"></ion-icon>
                        </span>
                        <span class="title">Users List</span>
                    </a>
                </li>
                <li>
                    <a href="admin_dashboard.jsp?section=EmergencySection">
                        <span class="icon">
                            <ion-icon name="people-outline"></ion-icon>
                        </span>
                        <span class="title">Emergency Services List</span>
                    </a>
                </li>
                <li>
                    <a href="admin_dashboard.jsp?section=appointmentDetailsSection">
                        <span class="icon">
                            <ion-icon name="calendar-outline"></ion-icon>
                        </span>
                        <span class="title">Appointment Details</span>
                    </a>
                </li>
                <li>
                    <a href="admin_dashboard.jsp?section=editProfileSection">
                        <span class="icon">
                            <ion-icon name="create-outline"></ion-icon>
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

        <div class="main">
            <div class="topbar">
                <div class="toggle">
                    <ion-icon name="menu-outline"></ion-icon>
                </div>
            </div>

            <!-- Doctor List Section -->
            <div id="doctorListSection" class="details">
                <%
                
                String url = "jdbc:mysql://localhost:3306/HMS";
                String user = "root";
                String password = "Deep@123";
                Connection conn = null;
                
                String section = request.getParameter("section");
		    	if ("doctorsListSection".equals(section)) {

                    // Remove doctor if requested
                    String doctorEmailToRemove = request.getParameter("removeDoctorEmail");
                    if (doctorEmailToRemove != null) {
                        try {
                            conn = DriverManager.getConnection(url, user, password);
                            String removeDoctorQuery = "DELETE FROM doctor WHERE doc_email = ?";
                            PreparedStatement pstmt = conn.prepareStatement(removeDoctorQuery);
                            pstmt.setString(1, doctorEmailToRemove);
                            int rowsAffected = pstmt.executeUpdate();
                            if (rowsAffected > 0) {
                                out.println("<script>alert('Doctor removed successfully!');</script>");
                            } else {
                                out.println("<script>alert('Error: Doctor not found.');</script>");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<script>alert('Error while removing doctor.');</script>");
                        } finally {
                            if (conn != null) {
                                conn.close();
                            }
                        }
                    }

                    // Fetch total number of doctors
                    try {
                        conn = DriverManager.getConnection(url, user, password);
                        String totalDoctorsQuery = "SELECT COUNT(*) AS total FROM doctor";
                        PreparedStatement pstmt = conn.prepareStatement(totalDoctorsQuery);
                        ResultSet rs = pstmt.executeQuery();
                        int totalDoctors = 0;
                        if (rs.next()) {
                            totalDoctors = rs.getInt("total");
                        }
                %>

                <div class="cardBox">
                    <div class="card">
                        <div>
                            <div class="numbers"><%= totalDoctors %></div>
                            <div class="cardName">Total Doctors</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="medkit-outline"></ion-icon>
                        </div>
                    </div>
                </div>

                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Doctor List</h2>
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
                                <td>Doctor Email</td>
                                <td>Specialty</td>
                                <td>Experience (Years)</td>
                                <td>Doctor Number</td>
                                <td>Status</td>
                                <td>Doctor Fee</td>
                                <td>Action</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Fetch and display verified doctors first then non-verified ones
                                String doctorQuery = "SELECT * FROM doctor ORDER BY status DESC;";
                                PreparedStatement psVerified = conn.prepareStatement(doctorQuery);
                                ResultSet rsVerified = psVerified.executeQuery();
                                while (rsVerified.next()) {
                            %>
                            <tr>
                                <td><%= rsVerified.getString("doc_name") %></td>
                                <td><%= rsVerified.getString("doc_email") %></td>
                                <td><%= rsVerified.getString("doc_specialty") %></td>
                                <td><%= rsVerified.getInt("doc_exp") %></td>
                                <td><%= rsVerified.getString("doc_num") %></td>
                                <td><%= rsVerified.getString("status") %></td>
                                <td><%= rsVerified.getBigDecimal("doc_fee").toString() %></td>
                                <td>
                                    <form method="post" action="verifyDoctor.jsp" onsubmit="return confirmVerify('<%= rsVerified.getString("status") %>');">
                                        <input type="hidden" name="doctorEmail" value="<%= rsVerified.getString("doc_email") %>">
                                        <input type="submit" value="Verify" class="verify-button">
                                    </form>
                                    <form method="post" action="admin_dashboard.jsp" onsubmit="return confirmRemove();">
                                        <input type="hidden" name="removeDoctorEmail" value="<%= rsVerified.getString("doc_email") %>">
                                        <input type="submit" value="Remove" class="remove-button">
                                    </form>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <%
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (conn != null) {
                                conn.close();
                            }
                        }
                %>
            </div>
            <%
		    	} else if ("usersListSection".equals(section)) {
            %>

		<!-- Users List Section -->
		<div id="usersListSection" class="details">
		    <%
		        // Connect to the database
		        // Remove patient if requested
		        String patientEmailToRemove = request.getParameter("removePatientEmail");
		        if (patientEmailToRemove != null) {
		            try {
		                conn = DriverManager.getConnection(url, user, password);
		                String removePatientQuery = "DELETE FROM patient WHERE pat_email = ?";
		                PreparedStatement pstmt = conn.prepareStatement(removePatientQuery);
		                pstmt.setString(1, patientEmailToRemove);
		                int rowsAffected = pstmt.executeUpdate();
		                if (rowsAffected > 0) {
		                    out.println("<script>alert('Patient removed successfully!');</script>");
		                } else {
		                    out.println("<script>alert('Error: Patient not found.');</script>");
		                }
		            } catch (SQLException e) {
		                e.printStackTrace();
		                out.println("<script>alert('Error while removing patient.');</script>");
		            } finally {
		                if (conn != null) {
		                    conn.close();
		                }
		            }
		        }
		
		        // Fetch total number of patients
		        int totalPatients = 0;
		        try {
		            conn = DriverManager.getConnection(url, user, password);
		            String totalPatientsQuery = "SELECT COUNT(*) AS total FROM patient";
		            PreparedStatement pstmt = conn.prepareStatement(totalPatientsQuery);
		            ResultSet rs = pstmt.executeQuery();
		            if (rs.next()) {
		                totalPatients = rs.getInt("total");
		            }
		        } catch (SQLException e) {
		            e.printStackTrace();
		        } finally {
		            if (conn != null) {
		                conn.close();
		            }
		        }
		
		        // Fetch patient list
		        try {
		            conn = DriverManager.getConnection(url, user, password);
		            String patientQuery = "SELECT * FROM patient";
		            PreparedStatement ps = conn.prepareStatement(patientQuery);
		            ResultSet rs = ps.executeQuery();
		    %>
		
		    <div class="cardBox">
		        <div class="card">
		            <div>
		                <div class="numbers"><%= totalPatients %></div>
		                <div class="cardName">Total Patients</div>
		            </div>
		            <div class="iconBx">
		                <ion-icon name="people-outline"></ion-icon>
		            </div>
		        </div>
		    </div>
		
		    <div class="recentOrders">
		        <div class="cardHeader">
		            <h2>Users List</h2>
		        </div>
		        <div class="search">
		            <label>
		                <input type="text" placeholder="Search Patient" id="searchPatientInput" onkeyup="searchPatientTable()" />
		                <ion-icon name="search-outline"></ion-icon>
		            </label>
		        </div>
		        <table id="patientTable">
		            <thead>
		                <tr>
		                    <td>Patient Name</td>
		                    <td>Patient Email</td>
		                    <td>Action</td>
		                </tr>
		            </thead>
		            <tbody>
		                <%
		                    while (rs.next()) {
		                %>
		                <tr>
		                    <td><%= rs.getString("pat_name") %></td>
		                    <td><%= rs.getString("pat_email") %></td>
		                    <td>
		                        <form method="post" action="admin_dashboard.jsp?section=usersListSection" onsubmit="return confirmRemovePatient();">
		                            <input type="hidden" name="removePatientEmail" value="<%= rs.getString("pat_email") %>">
		                            <input type="submit" value="Remove" class="remove-button-patient">
		                        </form>
		                    </td>
		                </tr>
		                <%
		                    }
		                %>
		            </tbody>
		        </table>
		    </div>
		
		    <%
		        } catch (SQLException e) {
		            e.printStackTrace();
		        } finally {
		            if (conn != null) {
		                conn.close();
		            }
		        }
		    %>
		</div>
		
		<%
		    } else if ("EmergencySection".equals(section)) {
        %>
		
		<!-- Emergency List Section -->
		            <div id="EmergencySection" class="details">
		                <%
		
		                    // Remove doctor if requested
		                    String emer_email = request.getParameter("remove_emer_email");
		                    if (emer_email != null) {
		                        try {
		                            conn = DriverManager.getConnection(url, user, password);
		                            String removeDoctorQuery = "DELETE FROM emergency_service WHERE emer_email = ?";
		                            PreparedStatement pstmt = conn.prepareStatement(removeDoctorQuery);
		                            pstmt.setString(1, emer_email);
		                            int rowsAffected = pstmt.executeUpdate();
		                            if (rowsAffected > 0) {
		                                out.println("<script>alert('Emergency Service removed successfully!');</script>");
		                            } else {
		                                out.println("<script>alert('Error: Emergency Service not found.');</script>");
		                            }
		                        } catch (SQLException e) {
		                            e.printStackTrace();
		                            out.println("<script>alert('Error while removing emergency service.');</script>");
		                        } finally {
		                            if (conn != null) {
		                                conn.close();
		                            }
		                        }
		                    }
		
		                    // Fetch total number of emergency services
		                    try {
		                        conn = DriverManager.getConnection(url, user, password);
		                        String total_emer_query = "SELECT COUNT(*) AS total FROM emergency_service";
		                        PreparedStatement pstmt = conn.prepareStatement(total_emer_query);
		                        ResultSet rs = pstmt.executeQuery();
		                        int total_emers = 0;
		                        if (rs.next()) {
		                            total_emers = rs.getInt("total");
		                        }
		                %>
		
		                <div class="cardBox">
		                    <div class="card">
		                        <div>
		                            <div class="numbers"><%= total_emers %></div>
		                            <div class="cardName">Total Emergency Services</div>
		                        </div>
		                        <div class="iconBx">
		                            <ion-icon name="medkit-outline"></ion-icon>
		                        </div>
		                    </div>
		                </div>
		
		                <div class="recentOrders">
		                    <div class="cardHeader">
		                        <h2>Emergency Services List</h2>
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
		                                <td>Ambulance Car No</td>
		                                <td>Service Email</td>
		                                <td>Ambulance Type</td>
		                                <td>Service Location</td>
		                                <td>Contact Number</td>
		                                <td>Status</td>
		                                <td>Action</td>
		                            </tr>
		                        </thead>
		                        <tbody>
		                            <%
		                                // Fetch and display verified doctors first then non-verified ones
		                                String emerQuery = "SELECT * FROM emergency_service ORDER BY status DESC;";
		                                PreparedStatement psVerified = conn.prepareStatement(emerQuery);
		                                ResultSet rsVerified = psVerified.executeQuery();
		                                while (rsVerified.next()) {
		                            %>
		                            <tr>
		                                <td><%= rsVerified.getString("emer_car_no") %></td>
		                                <td><%= rsVerified.getString("emer_email") %></td>
		                                <td><%= rsVerified.getString("emer_type") %></td>
		                                <td><%= rsVerified.getString("emer_loc") %></td>
		                                <td><%= rsVerified.getString("emer_no") %></td>
		                                <td><%= rsVerified.getString("status") %></td>
		                                <td>
		                                    <form method="post" action="verifyEmergencyService.jsp" onsubmit="return confirmVerify('<%= rsVerified.getString("status") %>');">
		                                        <input type="hidden" name="emer_email" value="<%= rsVerified.getString("emer_email") %>">
		                                        <input type="submit" value="Verify" class="verify-button">
		                                    </form>
		                                    <form method="post" action="admin_dashboard.jsp?section=EmergencySection" onsubmit="return confirmRemove();">
		                                        <input type="hidden" name="remove_emer_email" value="<%= rsVerified.getString("emer_email") %>">
		                                        <input type="submit" value="Remove" class="remove-button">
		                                    </form>
		                                </td>
		                            </tr>
		                            <%
		                                }
		                            %>
		                        </tbody>
		                    </table>
		                </div>
		
		                <%
		                        } catch (SQLException e) {
		                            e.printStackTrace();
		                        } finally {
		                            if (conn != null) {
		                                conn.close();
		                            }
		                        }
		                %>
		            </div>
		            
		            <%
		   				 } else if ("appointmentDetailsSection".equals(section)) {
       				%>
		
		            <!-- Appointment Details Section -->
		<!-- Appointment Details Section -->
		<div id="appointmentDetailsSection" class="details">
		    <%
		        // Connect to the database
		        // Remove appointment if requested
		        String appointmentIdToRemove = request.getParameter("removeAppointmentId");
		        if (appointmentIdToRemove != null) {
		            try {
		                conn = DriverManager.getConnection(url, user, password);
		                String removeAppointmentQuery = "DELETE FROM appointment WHERE appointment_id = ?";
		                PreparedStatement pstmt = conn.prepareStatement(removeAppointmentQuery);
		                pstmt.setInt(1, Integer.parseInt(appointmentIdToRemove));
		                int rowsAffected = pstmt.executeUpdate();
		                if (rowsAffected > 0) {
		                    out.println("<script>alert('Appointment removed successfully!');</script>");
		                } else {
		                    out.println("<script>alert('Error: Appointment not found.');</script>");
		                }
		            } catch (SQLException e) {
		                e.printStackTrace();
		                out.println("<script>alert('Error while removing appointment.');</script>");
		            } finally {
		                if (conn != null) {
		                    conn.close();
		                }
		            }
		        }
		
		        // Fetch total number of appointments
		        int totalAppointments = 0;
		        try {
		            conn = DriverManager.getConnection(url, user, password);
		            String totalAppointmentsQuery = "SELECT COUNT(*) AS total FROM appointment";
		            PreparedStatement pstmt = conn.prepareStatement(totalAppointmentsQuery);
		            ResultSet rs = pstmt.executeQuery();
		            if (rs.next()) {
		                totalAppointments = rs.getInt("total");
		            }
		        } catch (SQLException e) {
		            e.printStackTrace();
		        } finally {
		            if (conn != null) {
		                conn.close();
		            }
		        }
		
		        // Fetch appointment list
		        try {
		            conn = DriverManager.getConnection(url, user, password);
		            String appointmentQuery = "SELECT * FROM appointment";
		            PreparedStatement ps = conn.prepareStatement(appointmentQuery);
		            ResultSet rs = ps.executeQuery();
		    %>
		
		    <div class="cardBox">
		        <div class="card">
		            <div>
		                <div class="numbers"><%= totalAppointments %></div>
		                <div class="cardName">Total Appointments</div>
		            </div>
		            <div class="iconBx">
		                <ion-icon name="calendar-outline"></ion-icon>
		            </div>
		        </div>
		    </div>
		
		    <div class="recentOrders">
		        <div class="cardHeader">
		            <h2>Appointment Details</h2>
		        </div>
		        <div class="search">
		            <label>
		                <input type="text" placeholder="Search Appointment" id="searchAppointmentInput" onkeyup="searchAppointmentTable()" />
		                <ion-icon name="search-outline"></ion-icon>
		            </label>
		        </div>
		        <table id="appointmentTable">
		            <thead>
		                <tr>
		                    <td>Doctor Name</td>
		                    <td>Patient Name</td>
		                    <td>Patient Number</td>
		                    <td>Patient Age</td>
		                    <td>Appointment Date</td>
		                    <td>Appointment Time</td>
		                    <td>Status</td>
		                    <td>Doctor Fee</td>
		                    <td>Remove</td> <!-- New column for Remove button -->
		                </tr>
		            </thead>
		            <tbody>
		                <%
		                    while (rs.next()) {
		                %>
		                <tr>
		                    <td><%= rs.getString("doctor_name") %></td>
		                    <td><%= rs.getString("pat_name") %></td>
		                    <td><%= rs.getLong("pat_number") %></td>
		                    <td><%= rs.getInt("pat_age") %></td>
		                    <td><%= rs.getDate("appointment_date") %></td>
		                    <td><%= rs.getTime("appointment_time") %></td>
		                    <td><%= rs.getString("pat_status") %></td>
		                    <td><%= rs.getBigDecimal("doc_fee").toString() %></td>
		                    <td>
		                        <form method="post" action="admin_dashboard.jsp?section=appointmentDetailsSection" onsubmit="return confirmRemoveAppointment();">
		                            <input type="hidden" name="removeAppointmentId" value="<%= rs.getInt("appointment_id") %>">
		                            <input type="submit" value="Remove" class="remove-button-patient">
		                        </form>
		                    </td>
		                </tr>
		                <%
		                    }
		                %>
		            </tbody>
		        </table>
		    </div>
		
		    <%
		        } catch (SQLException e) {
		            e.printStackTrace();
		        } finally {
		            if (conn != null) {
		                conn.close();
		            }
		        }
		    %>
		</div>
		
		<%
			} else if ("editProfileSection".equals(section)) {
       	%>
		            <!-- Edit Profile Section -->
		<div id="editProfileSection" class="details">
		    <div class="cardHeader">
		                        <h2>Edit Profile</h2>
		                  </div>
		    <form action="updateAdminProfile.jsp" method="post">
		        <div class="formGroup">
		            <label for="admin_name">Name</label>
		            <input type="text" id="admin_name" name="admin_name" placeholder="Enter New Name" required />
		        </div>
		        <div class="formGroup">
		            <label for="admin_email">Email</label>
		            <input type="email" id="admin_email" name="admin_email" placeholder="Enter New Email" required />
		        </div>
		        <div class="formGroup">
		            <label for="admin_no">Phone Number</label>
		            <input type="text" id="admin_no" name="admin_no" placeholder="Enter New Phone Number" required />
		        </div>
		        <div class="formGroup">
		            <label for="admin_old_pass">Old Password</label>
		            <input type="password" id="admin_old_pass" name="admin_old_pass" placeholder="Enter Old Password" required />
		        </div>
		        <div class="formGroup">
		            <label for="admin_new_pass">New Password</label>
		            <input type="password" id="admin_new_pass" name="admin_new_pass" placeholder="Enter New Password" required />
		        </div>
		        <div class="formGroup">
		            <button type="submit" class="btn-update">Update Profile</button>
		        </div>
		    </form>
		</div>
		
		<%} else {
			// if no section is provided in the html, then by default it will redirect to the doctorsListSection
		%>
			
			<jsp:forward page="admin_dashboard.jsp?section=doctorsListSection"></jsp:forward>
		<%} %>
		
        </div>
    </div>

    <!-- JavaScript to handle section display and search functionalities -->
    <script>
        // Automatically show the Doctor List section when the page loads
        window.onload = function() {
            showSection('doctorListSection');
        };

        // Search Table for Doctor List
        function searchTable() {
            let input = document.getElementById("searchInput");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("doctorTable");
            let tr = table.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                let td = tr[i].getElementsByTagName("td")[0];
                if (td) {
                    let txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        // Search Patient Table
        function searchPatientTable() {
            let input = document.getElementById("searchPatientInput");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("patientTable");
            let tr = table.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                let td = tr[i].getElementsByTagName("td")[0];
                if (td) {
                    let txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
        
     // Search Emergency Table
        function searchEmergencyTable() {
            let input = document.getElementById("searchEmergencyInput");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("emerTable");
            let tr = table.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                let tdType = tr[i].getElementsByTagName("td")[2];
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
        
     // Search Appointment Table
        function searchAppointmentTable() {
            let input = document.getElementById("searchAppointmentInput");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("appointmentTable");
            let tr = table.getElementsByTagName("tr");

            for (let i = 0; i < tr.length; i++) {
                let tdDoctor = tr[i].getElementsByTagName("td")[0]; // Doctor Name
                let tdPatient = tr[i].getElementsByTagName("td")[1]; // Patient Name
                if (tdDoctor || tdPatient) {
                    let txtValueDoctor = tdDoctor.textContent || tdDoctor.innerText;
                    let txtValuePatient = tdPatient.textContent || tdPatient.innerText;
                    if (txtValueDoctor.toUpperCase().indexOf(filter) > -1 || txtValuePatient.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        // Confirm Remove
        function confirmRemove() {
            return confirm("Are you sure you want to remove this account?");
        }

        // Confirm Remove Patient
        function confirmRemovePatient() {
            return confirm("Are you sure you want to remove this patient?");
        }

        // Confirm Verify
        function confirmVerify(status) {
            if (status === "verified") {
                alert("Account is already verified.");
                return false;
            }
            return confirm("Are you sure you want to verify this account?");
        }
    </script>

<script src="assets/js/main.js"></script>
    <!-- Importing Ionicons -->
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>

</html>