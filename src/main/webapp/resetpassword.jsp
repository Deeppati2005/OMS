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
<title>Insert title here</title>
</head>
<%
String role = request.getParameter("role");
String email = request.getParameter("email");
String sq = request.getParameter("security_question");
String sa = request.getParameter("security_answer");

try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS","root","Deep@123");
	Statement stmt = con.createStatement();
	String query = "";
	if ("doctor".equals(role)) 
	{
		session.setAttribute("role", role);
		 session.setAttribute("email", email);
		query = "select * from doctor where doc_email='" + email + "' and doc_sq='" + sq + "' and doc_sa='"+sa+"'";
	} 
	else if ("admin".equals(role)) 
	{
		session.setAttribute("role", role);
		 session.setAttribute("email", email);
		query = "select * from admin where admin_email='" + email + "' and admin_sq='" + sq + "' and admin_sa='"+sa+"'";
	} 
	else if ("patient".equals(role)) 
	{
		session.setAttribute("role", role);
		 session.setAttribute("email", email);
		query = "select * from patient where pat_email='" + email + "' and pat_sq='" + sq + "' and pat_sa='"+sa+"'";
	} 
	else if ("emergency".equals(role)) 
	{
		session.setAttribute("role", role);
		 session.setAttribute("email", email);
		query = "select * from emergency_service where emer_email='" + email + "' and emer_sq='" + sq + "' and emer_sa='"+sa+"'";
	}
	ResultSet rs = stmt.executeQuery(query);
	if(rs.next())
	{
		%>
		<jsp:forward page="setpassword.jsp"></jsp:forward>
		<%
	}
	else
	{
		%>
		<jsp:forward page="failure.jsp"></jsp:forward>
		<%
	}
}
catch(Exception e)
{
	out.println("Error: " + e.getMessage());
}

%>
<body>

</body>
</html>