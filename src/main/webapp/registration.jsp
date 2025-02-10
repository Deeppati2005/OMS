<%@ page import='jakarta.servlet.*'%>
<%@ page import='jakarta.servlet.http.*'%>
<%@ page import='java.io.*'%>
<%@ page import='java.sql.*'%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="./registration.css" />
<title>Sign in & Sign up Form</title>
</head>
<body>

	<div class="container">
		<div class="forms-container">
			<div class="signin-signup">

				<!-- Sign In Section -->

				<form action="signin.jsp" class="sign-in-form" method="post">
					<h2 class="title">Sign in</h2>
					<div class="input-field">
						<i class="fas fa-user-tag"></i> 
						<select name="role">
							<option value="Select Your Role">Select Your Role</option>
							<option value="admin">Admin</option>
							<option value="doctor">Doctor</option>
							<option value="patient">Patient</option>
							<option value="emergency">Emergency Service</option>
						</select>
					</div>
					<div class="input-field">
						<i class="fas fa-user"></i> <input type="email"
							placeholder="Email" name="email" id="email" required />
					</div>
					<div class="input-field">
						<i class="fas fa-lock"></i> <input type="password"
							placeholder="Password" name="password" id="password" required />
					</div>

					<!-- Forgot Password Link -->
					<a href="forgotpassword.jsp" class="forgot-password">Forgot
						Password?</a> <input type="submit" value="Login" class="btn solid" />
				</form>


				<!-- Sign Up Section -->

<form action="signup.jsp" class="sign-up-form" method="post" id="regForm" onsubmit="return validateForm()">
    <h2 class="title">Sign up</h2>

    <!-- Common fields -->
    <div class="input-field">
        <i class="fas fa-user-tag"></i> <!-- Role Selection Icon -->
        <select name="role" id="role" required>
            <option value="Select Your Role">Select Your Role</option>
            <!-- <option value="admin">Admin</option> -->
            <option value="doctor">Doctor</option>
            <option value="patient">Patient</option>
            <option value="emergency">Emergency Service</option>
        </select>
    </div>

    <!-- Doctor-specific fields -->
    <div id="doctor-fields" style="display: none">
        <div class="input-field">
            <i class="fas fa-user-md"></i> <!-- Icon for Doctor Name -->
            <input type="text" placeholder="Enter your Name" name="doc_name" id="doc_name" />
        </div>
        <div class="input-field">
            <i class="fas fa-envelope"></i> <!-- Icon for Doctor Email -->
            <input type="email" placeholder="Enter your Email" name="doc_email" id="doc_email" />
        </div>
        <div class="input-field">
            <i class="fas fa-lock"></i> <!-- Icon for Doctor Password -->
            <input type="password" placeholder="Enter your Password" name="doc_pass" id="doc_pass" />
        </div>
        <div class="input-field">
            <i class="fas fa-user-md"></i> <!-- Icon for Specialty -->
            <input type="text" placeholder="Specialty" name="doc_specialty" id="doc_specialty" />
        </div>
        <div class="input-field">
            <i class="fas fa-briefcase"></i> <!-- Icon for Experience -->
            <input type="text" placeholder="Years of Experience" name="doc_exp" id="doc_exp" />
        </div>
        <div class="input-field">
            <i class="fas fa-phone"></i> <!-- Icon for Phone Number -->
            <input type="number" placeholder="Phone Number" name="doc_num" id="doc_num" />
        </div>
        <div class="input-field">
            <i class="fas fa-question-circle"></i> <!-- Icon for Security Question -->
            <select name="doc_sq">
                <option value="">Select a Security Question</option>
                <option value="What is your maiden name?">What is your maiden name?</option>
                <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                <option value="What was your first car?">What was your first car?</option>
                <option value="What elementary school did you attend?">What elementary school did you attend?</option>
            </select>
        </div>
        <div class="input-field">
            <i class="fas fa-pencil-alt"></i> <!-- Icon for Security Answer -->
            <input type="text" placeholder="Security Answer" name="doc_sa" id="doc_sa" />
        </div>
    </div>

    <!-- Patient-specific fields -->
    <div id="patient-fields" style="display: none">
        <div class="input-field">
            <i class="fas fa-user"></i> <!-- Icon for Patient Name -->
            <input type="text" placeholder="Enter your Name" name="pat_name" id="pat_name" />
        </div>
        <div class="input-field">
            <i class="fas fa-envelope"></i> <!-- Icon for Patient Email -->
            <input type="email" placeholder="Enter your Email" name="pat_email" id="pat_email" />
        </div>
        <div class="input-field">
            <i class="fas fa-lock"></i> <!-- Icon for Patient Password -->
            <input type="password" placeholder="Enter your Password" name="pat_pass" id="pat_pass" />
        </div>
        <div class="input-field">
            <i class="fas fa-question-circle"></i> <!-- Icon for Security Question -->
            <select name="pat_sq">
                <option value="">Select a Security Question</option>
                <option value="What is your maiden name?">What is your maiden name?</option>
                <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                <option value="What was your first car?">What was your first car?</option>
                <option value="What elementary school did you attend?">What elementary school did you attend?</option>
            </select>
        </div>
        <div class="input-field">
            <i class="fas fa-pencil-alt"></i> <!-- Icon for Security Answer -->
            <input type="text" placeholder="Security Answer" name="pat_sa" id="pat_sa" />
        </div>
    </div>
    
    <!-- Emergency-specific fields -->
    <div id="emergency-fields" style="display: none">
        <!-- <div class="input-field">
            <i class="fas fa-user"></i> <!-- Icon for Emergency Service Name 
            <input type="text" placeholder="Enter Ambulance Service Name" name="emer_name" id="emer_name" />
        </div> -->
        <div class="input-field">
            <i class="fas fa-envelope"></i> <!-- Icon for Emergency Service Email -->
            <input type="email" placeholder="Enter Service Email" name="emer_email" id="emer_email" />
        </div>
        <div class="input-field">
            <i class="fas fa-lock"></i> <!-- Icon for Emergency Service Password -->
            <input type="password" placeholder="Enter Password" name="emer_pass" id="emer_pass" />
        </div>
        <div class="input-field">
            <i class="fas fa-phone"></i> <!-- Icon for Emergency Service Phone Number -->
            <input type="text" placeholder="Enter Ambulance Phone Number" name="emer_no" id="emer_no" />
        </div>
        <div class="input-field">
            <i class="fas fa-pencil-alt"></i> <!-- Icon for Emergency Service Car Number -->
            <input type="text" placeholder="Enter Ambulance Car Number" name="emer_car_no" id="emer_car_no" />
        </div>
        <div class="input-field">
            <i class="fas fa-question-circle"></i> <!-- Icon for Emergency Service Type (AC / ICU / None) -->
            <select name="emer_type">
                <option value="">Select Service Type</option>
                <option value="Basic">Basic</option>
                <option value="AC">AC</option>
                <option value="ICU">ICU</option>
            </select>
        </div>
        <div class="input-field">
            <i class="fas fa-pencil-alt"></i> <!-- Icon for Emergency Service Location -->
            <input type="text" placeholder="Enter Ambulance Service City" name="emer_loc" id="emer_loc" />
        </div>
        <div class="input-field">
            <i class="fas fa-question-circle"></i> <!-- Icon for Security Question -->
            <select name="emer_sq">
                <option value="">Select a Security Question</option>
                <option value="What is your maiden name?">What is your maiden name?</option>
                <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                <option value="What was your first car?">What was your first car?</option>
                <option value="What elementary school did you attend?">What elementary school did you attend?</option>
            </select>
        </div>
        <div class="input-field">
            <i class="fas fa-pencil-alt"></i> <!-- Icon for Security Answer -->
            <input type="text" placeholder="Security Answer" name="emer_sa" id="emer_sa" />
        </div>
    </div>

    
    <input type="submit" class="btn" value="Sign up" />
</form>

	</div>
		</div>
		<div class="panels-container">
			<div class="panel left-panel">
				<div class="content">
					<h3>New here ?</h3>
					<p>Join us today to access a wide range of medical services tailored to meet your needs. Create an account to get started!</p>
					<button class="btn transparent" id="sign-up-btn">Sign up</button>
				</div>
				<img src="img/log.svg" class="image" alt="" />
			</div>
			<div class="panel right-panel">
				<div class="content">
					<h3>One of us ?</h3>
					<p>If you already have an account, sign in access your records.</p>
					<button class="btn transparent" id="sign-in-btn">Sign in</button>
				</div>
				<img src="img/register.svg" class="image" alt="" />
			</div>
		</div>
	</div>
	<script>
  document.getElementById("role").addEventListener("change", function () {
    var role = this.value;

    // Hide all role-specific fields initially
    document.getElementById("doctor-fields").style.display = "none";
    document.getElementById("patient-fields").style.display = "none";
    document.getElementById("emergency-fields").style.display = "none";

    // Show fields based on selected role
    if (role === "doctor") {
      document.getElementById("doctor-fields").style.display = "block";
    } else if (role === "patient") {
      document.getElementById("patient-fields").style.display = "block";
    } else if (role === "emergency") {
    	document.getElementById("emergency-fields").style.display = "block";
    }
  });
</script>
	
	<script src="./registration.js"></script>
</body>
</html>