<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SignIn Processing</title>
</head>
<body>

<%
    String role = request.getParameter("role");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (role == null || email == null || password == null) {
        out.println("Error: Missing required fields.");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");
        String query = "";
        PreparedStatement pstmt = null;

        // Building query based on role
        if ("doctor".equals(role)) {
            session.setAttribute("email", email);
            query = "SELECT * FROM doctor WHERE doc_email=? AND doc_pass=? AND status='verified'";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
        } else if ("admin".equals(role)) {
            session.setAttribute("email", email);
            query = "SELECT * FROM admin WHERE admin_email=? AND admin_pass=?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
        } else if ("patient".equals(role)) {
            session.setAttribute("email", email);
            query = "SELECT * FROM patient WHERE pat_email=? AND pat_pass=?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
        } else if ("emergency".equals(role)) {
            session.setAttribute("email", email);
            query = "SELECT * FROM emergency_service WHERE emer_email=? AND emer_pass=? AND status = 'verified'";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
        }

        // Execute query
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            if ("admin".equals(role)) {
            	 String adminName = rs.getString("admin_name");
                 session.setAttribute("admin_name", adminName);
                %>
                <jsp:forward page="admin_dashboard.jsp"></jsp:forward>
                <%
            } else if ("doctor".equals(role)) {
            	String docName = rs.getString("doc_name");
                session.setAttribute("doc_name", docName);
                %>
                <jsp:forward page="doctor_dashboard.jsp"></jsp:forward>
                <%
            } else if ("patient".equals(role)) {
            	String patName = rs.getString("pat_name");
                session.setAttribute("pat_name", patName);
                %>
                <jsp:forward page="patient_dashboard.jsp"></jsp:forward>
                <%
            } else if ("emergency".equals(role)) {
            	String emerType = rs.getString("emer_type");
                session.setAttribute("emer_type", emerType);
                %>
                <jsp:forward page="emer_dashboard.jsp"></jsp:forward>
                <%
            }
        } else {
            // If no result or not verified for doctors
            if ("doctor".equals(role)) {
                out.println("Error: Doctor not verified.");
            }
            else if ("emergency".equals(role)) {
            	out.println("Error: Emergency Service not verified");
            }
            %>
            <jsp:forward page="failure.jsp"></jsp:forward>
            <%
        }
        // Close resources
        rs.close();
        pstmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</body>
</html>