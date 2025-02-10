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
<title>Update Password</title>
</head>
<body>
<%

String newpassword = request.getParameter("new_password");
String role = (String) session.getAttribute("role");
String email = (String) session.getAttribute("email");

try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS","root","Deep@123");
	Statement stmt = con.createStatement();
	String query = "";
	if ("doctor".equals(role)) 
	{
		query = "update doctor set doc_pass='"+newpassword+"' where doc_email='"+email+"';";
	} 
	else if ("admin".equals(role)) 
	{
		query = "update admin set admin_pass='"+newpassword+"' where admin_email='"+email+"';";
	} 
	else if ("patient".equals(role)) 
	{
		query = "update patient set pat_pass='"+newpassword+"' where pat_email='" +email+ "';";
	} 
	else if ("emergency".equals(role)) 
	{
		query = "update emergency_service set emer_pass='"+newpassword+"'";
	}
	int x = stmt.executeUpdate(query);
	if (x>0) 
    {
		%>
    	<script>
			alert("Password Changed Successfully!");
			window.location.href = "registration.jsp";
		</script>
		<%
    } 
    else 
    {
		%>
        	<jsp:forward page="failure.jsp" />
		<%
    }
    con.close();
}
catch(Exception e)
{
	out.println("Error: " + e.getMessage());
}

%>
</body>
</html>