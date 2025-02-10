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
    <title>Set Password</title>
    <script>
      function validateForm() {
        var newPassword = document.getElementById("new_password").value;
        var confirmPassword = document.getElementById("confirm_password").value;
        if (newPassword !== confirmPassword) {
          alert("Passwords do not match. Please try again.");
          return false;
        }
        return true;
      }
    </script>
  </head>
  <body>
    <div class="container">
      <div class="forms-container">
        <div class="signin-signup">
          <form action="updatepassword.jsp" class="set-password-form" method="post" onsubmit="return validateForm()">
            <h2 class="title">Set New Password</h2>
            <div class="input-field">
              <i class="fas fa-lock"></i>
              <input type="password" placeholder="New Password" name="new_password" id="new_password" required />
            </div>
            <div class="input-field">
              <i class="fas fa-lock"></i>
              <input type="password" placeholder="Confirm Password" name="confirm_password" id="confirm_password" required />
            </div>
            <input type="submit" class="btn" value="Submit" />
          </form>
        </div>
      </div>
      <div class="panels-container">
        <div class="panel left-panel">
          <div class="content">
            <h3>New here ?</h3>
            <p>
              Resetting your password is quick and easy. Ensure your new password is strong and secure to keep your account safe.
            </p>
          </div>
          <img src="img/reset.svg" class="image" alt="" />
        </div>
      </div>
    </div>
  </body>
</html>