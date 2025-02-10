<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Emergency Service Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css" />
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
						Welcome, <%= session.getAttribute("emer_type") != null ? session.getAttribute("emer_type") : "Emergency Service" %>   
                        </span>
                    </a>
                </li>
                <li>
                    <a href="emer_dashboard.jsp">
                        <span class="icon">
                            <ion-icon name="home-outline"></ion-icon>
                        </span>
                        <span class="title">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="emer_dashboard.jsp?section=editProfile">
                        <span class="icon">
                            <ion-icon name="person-circle-outline"></ion-icon>
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
                    String emer_email = (String) session.getAttribute("email");
                    if (emer_email == null) {
                        response.sendRedirect("signin.jsp");
                        return;
                    }

                    String section = request.getParameter("section");
                    if ("editProfile".equals(section)) {
                        // Fetch current emergency service details from the database
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        String emer_car_no= "", emer_pass = "", emer_type = "", emer_no = "";

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

                            String query = "SELECT * FROM emergency_service WHERE emer_email = ?";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, emer_email);
                            rs = pstmt.executeQuery();

                            if (rs.next()) {
                                emer_car_no = rs.getString("emer_car_no");
                                emer_pass = rs.getString("emer_pass");
                                emer_type = rs.getString("emer_type");
                                emer_no = rs.getString("emer_no");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                %>
                <!-- Edit Profile Section -->
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Edit Profile</h2>
                    </div>
                    <form action="updateEmergencyServiceProfile.jsp" method="post">
                        <div class="formGroup">
                            <label for="old_pass">Old Password</label>
                            <input type="password" id="old_pass" name="old_pass" placeholder="Enter Old Password" required />
                        </div>
                        <div class="formGroup">
                            <label for="new_pass">New Password</label>
                            <input type="password" id="new_pass" name="new_pass" placeholder="Enter New Password" required />
                        </div>
                        <div class="formGroup">
                            <label for="emer_type">Ambulance Type</label><br />
						    <input type="radio" id="basic" name="emer_type" value="Basic" <% if ("Basic".equals(emer_type)) { %>checked<% } %> />
						    <label for="basic">Basic</label><br />
						    
						    <input type="radio" id="ac" name="emer_type" value="AC" <% if ("AC".equals(emer_type)) { %>checked<% } %> />
						    <label for="ac">AC</label><br />
						    
						    <input type="radio" id="icu" name="emer_type" value="ICU" <% if ("ICU".equals(emer_type)) { %>checked<% } %> />
						    <label for="icu">ICU</label>

                        </div>
                        <div class="formGroup">
                            <label for="emer_num">Contact Number</label>
                            <input type="text" id="emer_num" name="emer_num" value="<%= emer_no %>" placeholder="Enter Contact Number" required />
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
                <div class="cardBox">
                    <div class="card">
                        <div>
                            <div class="numbers">
                                <%
                                    // JDBC connection setup for Total Bookings
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    session = request.getSession();
                                    //String emer_email = (String) session.getAttribute("email");
                                    //System.out.println(emer_email);

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

                                        String totalAppointmentsQuery = "SELECT COUNT(*) AS total FROM booking WHERE emer_email = ?";
                                        pstmt = conn.prepareStatement(totalAppointmentsQuery);
                                        pstmt.setString(1, emer_email);
                                        rs = pstmt.executeQuery();

                                        if (rs.next()) {
                                            int totalAppointments = rs.getInt("total");
                                            out.println(totalAppointments);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs != null) rs.close();
                                        if (pstmt != null) pstmt.close();
                                        if (conn != null) conn.close();
                                    }
                                %>
                            </div>
                            <div class="cardName">Total Bookings</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="people-outline"></ion-icon>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers">
                                <%
                                    // JDBC connection setup for Today's Bookings
                                    conn = null;
                                    pstmt = null;
                                    rs = null;

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

                                        String todayAppointmentsQuery = "SELECT COUNT(*) AS today FROM booking WHERE emer_email = ? AND appointment_date = CURDATE()";
                                        pstmt = conn.prepareStatement(todayAppointmentsQuery);
                                        pstmt.setString(1, emer_email);
                                        rs = pstmt.executeQuery();

                                        if (rs.next()) {
                                            int todayAppointments = rs.getInt("today");
                                            out.println(todayAppointments);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs != null) rs.close();
                                        if (pstmt != null) pstmt.close();
                                        if (conn != null) conn.close();
                                    }
                                %>
                            </div>
                            <div class="cardName">Today Bookings</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="people-outline"></ion-icon>
                        </div>
                    </div>
                </div>

                <!-- ================ Bookings List ================= -->
                <div class="details">
                    <div class="recentOrders">
                        <div class="cardHeader">
                            <h2>Up-Coming Bookings</h2>
                        </div>

                        <!-- Search input for filtering appointments by patient name -->
                        <div class="search">
                            <label>
                                <ion-icon name="search-outline" class="search-icon"></ion-icon>
                                <input type="text" id="searchInput" placeholder="Search by patient name" onkeyup="searchTable()" />
                            </label>
                        </div>

                        <table id="bookingsTable">
                            <thead>
                                <tr>
                                    <td>Patient Name</td>
                                    <td>Patient No.</td>
                                    <td>Email</td>
                                    <td>Address</td>
                                    <td>Date</td>
                                    <td>Time</td>
                                    <td>Status</td>
                                    <td>Action</td>
                                    <td>Remove</td>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    conn = null;
                                    pstmt = null;
                                    rs = null;
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

                                        String query = "SELECT * FROM booking WHERE emer_email = ? ORDER BY appointment_date, appointment_time";
                                        pstmt = conn.prepareStatement(query);
                                        pstmt.setString(1, emer_email);
                                        rs = pstmt.executeQuery();

                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("pat_name") %></td>
                                    <td><%= rs.getLong("pat_number") %></td>
                                    <td><%= rs.getString("pat_email") %></td>
                                    <td><%= rs.getString("pat_address") %></td>
                                    <td><%= rs.getDate("appointment_date") %></td>
                                    <td><%= rs.getTime("appointment_time") %></td>
                                    <td><%= rs.getString("pat_status") %></td>
                                    <td>
                                        <form action="update_status_booking.jsp" method="post" class="status-form">
                                            <input type="hidden" name="booking_id" value="<%= rs.getInt("booking_id") %>">
                                            <input type="hidden" name="current_status" value="<%= rs.getString("pat_status") %>">
                                            <input type="hidden" name="status" value="confirmed">
                                            <button type="submit" class="btn-appointment approve-btn">Confirm</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="removeBooking.jsp" method="post" class="remove-form">
                                            <input type="hidden" name="appointment_id" value="<%= rs.getInt("booking_id") %>">
                                            <button type="submit" class="btn-appointment remove-btn" onclick="return confirm('Are you sure you want to remove this appointment?');">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <!-- =========== Scripts =========  -->
    <script src="assets/js/main.js"></script>

    <!-- ====== ionicons ======= -->
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

    <!-- JavaScript for search functionality -->
    <script>
    	
    	//a function to search the patient table
	    function searchTable() {		
	        let input = document.getElementById("searchInput");
	        let filter = input.value.toUpperCase();
	        let table = document.getElementById("bookingsTable");
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
    
    
    
        

   

        // JavaScript to handle form submission and show alerts
        document.querySelectorAll('.status-form').forEach(form => {
            form.addEventListener('submit', function(event) {
                event.preventDefault();
                const currentStatus = this.querySelector('input[name="current_status"]').value;
                if (currentStatus === 'confirmed') {
                    alert('Already confirmed');
                } else {
                    this.submit();
                }
            });
        });
    </script>

    <!-- JavaScript to show alerts based on status message -->
    <%
        String statusMessage = (String) request.getAttribute("statusMessage");
        if (statusMessage != null) {
    %>
    <script>
        const statusMessage = "<%= statusMessage %>";
        if (statusMessage === "confirmed") {
            alert("Status confirmed");
        } else if (statusMessage === "removed") {
            alert("Appointment removed successfully");
        } else if (statusMessage === "error") {
            alert("Failed to update status or remove appointment");
        }
    </script>
    <%
        }
    %>
</body>
</html>