<%@ page import='jakarta.servlet.*' %>
<%@ page import='jakarta.servlet.http.*' %>
<%@ page import='java.io.*' %>
<%@ page import='java.sql.*' %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Signup Processing</title>
</head>
<body>

<%
  // Get the selected role from the form
  String role = request.getParameter("role");

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
    Statement stmt = con.createStatement();
    String query = "";
    int x = 0;

    // Check the role and create an insert query accordingly
    if ("doctor".equals(role)) 
    {
    	  String doc_name = request.getParameter("doc_name");
    	  String doc_email = request.getParameter("doc_email");
    	  String doc_pass = request.getParameter("doc_pass");
    	  String doc_specialty = request.getParameter("doc_specialty");
    	  String doc_exp = request.getParameter("doc_exp");
    	  String doc_num = request.getParameter("doc_num");
    	  String doc_sq = request.getParameter("doc_sq");
    	  String doc_sa = request.getParameter("doc_sa");

      // Insert query for doctor
      query = "INSERT INTO doctor (doc_name, doc_email, doc_pass, doc_specialty, doc_exp, doc_num, doc_sq, doc_sa) VALUES('" + doc_name + "','" + doc_email + "','" + doc_pass + "','" + doc_specialty + "','"+doc_exp+"','"+doc_num+"','"+doc_sq+"','"+doc_sa+"')";
    } 
   /*  else if ("admin".equals(role))
    {
      String admin_name = request.getParameter("admin_name");
      String admin_email = request.getParameter("admin_email");
      String admin_pass = request.getParameter("admin_pass");
      String admin_no = request.getParameter("admin_no");
      String admin_sq = request.getParameter("admin_sq");
      String admin_sa = request.getParameter("admin_sa");

      // Insert query for admin
      query = "INSERT INTO admin (admin_name, admin_email, admin_pass, admin_no, admin_sq, admin_sa) VALUES ('" + admin_name + "','" + admin_email + "','" + admin_pass + "','" + admin_no + "','" + admin_sq + "','" + admin_sa + "')";
    } */ 
    else if ("patient".equals(role))
    {
    	 String pat_name = request.getParameter("pat_name");
         String pat_email = request.getParameter("pat_email");
         String pat_pass = request.getParameter("pat_pass");
         String pat_sq = request.getParameter("pat_sq");
         String pat_sa = request.getParameter("pat_sa");

      // Insert query for patient
      query = "INSERT INTO patient (pat_name, pat_email, pat_pass, pat_sq, pat_sa) VALUES ('" + pat_name + "','" + pat_email + "','" + pat_pass + "','" + pat_sq + "','" + pat_sa + "')";
    } 
    else if ("emergency".equals(role)) 
    {
      String emer_email = request.getParameter("emer_email");
      String emer_pass = request.getParameter("emer_pass");
      String emer_no = request.getParameter("emer_no");
      String emer_sq = request.getParameter("emer_sq");
      String emer_sa = request.getParameter("emer_sa");
      String emer_type = request.getParameter("emer_type");
      String emer_loc = request.getParameter("emer_loc");
      String emer_car_no = request.getParameter("emer_car_no");
      

      // Insert query for emergency service
      query = "INSERT INTO emergency_service (emer_email, emer_pass, emer_no, emer_sq, emer_sa, emer_type, emer_loc, emer_car_no) VALUES ('" + emer_email + "','" + emer_pass + "','" + emer_no + "','" + emer_sq + "','" + emer_sa + "' ,'"+emer_type+"','" +emer_loc+ "','" +emer_car_no+ "')";
    }

    // Execute the query and check for success
    x = stmt.executeUpdate(query);

    if (x > 0)
    {
%>
      <script>
        alert('Registration successful! Redirecting to the login page.');
        window.location.href = 'registration.jsp';
      </script>
<%
    } 
    else 
    {
      out.println("Registration failed. Please try again.");
    }

    con.close();
  } 
  catch (Exception e)
  {
    e.printStackTrace();
    out.println("Error occurred: " + e.getMessage());
  }
%>

</body>
</html>
