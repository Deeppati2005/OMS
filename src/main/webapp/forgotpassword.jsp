<%@ page import='jakarta.servlet.*' %>
<%@ page import='jakarta.servlet.http.*' %>
<%@ page import='java.io.*' %>
<%@ page import='java.sql.*' %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script
      src="https://kit.fontawesome.com/af6366cb0d.js"
      crossorigin="anonymous"
    ></script>
    <link rel="stylesheet" href="./registration.css" />
    <title>Forgot Password</title>
  </head>
  <body>
    <div class="container">
      <div class="forms-container">
        <div class="signin-signup">
          <form action="resetpassword.jsp" class="forgot-password-form" method="post">
            <h2 class="title">Forgot Password</h2>
            <div class="input-field">
						<i class="fas fa-user-tag"></i> 
						<select name="role" required>
							<option value="Select Your Role">Select Your Role</option>
							<option value="admin">Admin</option>
							<option value="doctor">Doctor</option>
							<option value="patient">Patient</option>
							<option value="emergency">Emergency Service</option>
						</select>
			</div>
            <div class="input-field">
              <i class="fas fa-envelope"></i>
              <input type="email" placeholder="Email" name="email" id="email" required />
            </div>
            <div class="input-field">
              <i class="fas fa-question-circle"></i>
              <select name="security_question" required>
                <option value="">Select a Security Question</option>
                <option value="What is your maiden name?">What is your maiden name?</option>
                <option value="What is the name of your first pet?">What is the name of your first pet?</option>
                <option value="What was your first car?">What was your first car?</option>
                <option value="What elementary school did you attend?">What elementary school did you attend?</option>
              </select>
            </div>
            <div class="input-field">
              <i class="fas fa-pencil-alt"></i>
              <input
                type="text"
                placeholder="Security Answer"
                name="security_answer"
                id="security_answer"
                required
              />
            </div>
            <input type="submit" class="btn" value="Submit" />
          </form>
        </div>
      </div>
            <div class="panels-container">
        <div class="panel left-panel">
          <div class="content">
            <h3>Forgot Your Password ?</h3>
            <p>If you’ve forgotten your password, don’t worry! We’ll help you reset it so you can get back to managing your account.</p>
            <button class="btn transparent" id="sign-up-btn">Back to Sign in</button>
          </div>
          <img src="img/forgot.svg" class="image" alt="" />
        </div>
      </div>
    </div>
    <script>
      document.getElementById("sign-up-btn").addEventListener("click", function () {
        window.location.href = "registration.jsp";
      });
    </script>
  </body>
</html>