<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Admin Profile</title>
</head>
<body>

<%
    String name = request.getParameter("admin_name");
	String admin_email_ses =(String)session.getAttribute("email");
    String email = request.getParameter("admin_email");
    String phoneNumber = request.getParameter("admin_no");
    String oldPassword = request.getParameter("admin_old_pass");
    String newPassword = request.getParameter("admin_new_pass");


    if (name == null || email == null || phoneNumber == null || oldPassword == null || newPassword == null) {
        out.println("Error: Missing required fields.");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

        // Validate old password
        String validateQuery = "SELECT * FROM admin WHERE admin_email=? AND admin_pass=?";
        PreparedStatement validatePstmt = con.prepareStatement(validateQuery);
        validatePstmt.setString(1, admin_email_ses);
        validatePstmt.setString(2, oldPassword);
        ResultSet rs = validatePstmt.executeQuery();

        if (rs.next()) 
        {
            // Update admin profile
            String updateQuery = "UPDATE admin SET admin_name=?, admin_email=?, admin_no=?, admin_pass=? WHERE admin_email=?";
            PreparedStatement updatePstmt = con.prepareStatement(updateQuery);
            updatePstmt.setString(1, name);
            updatePstmt.setString(2, email);
            updatePstmt.setString(3, phoneNumber);
            updatePstmt.setString(4, newPassword);
            updatePstmt.setString(5, admin_email_ses);

            int rowsAffected = updatePstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Profile updated successfully!'); window.location.href='admin_dashboard.jsp';</script>");
            } 
            else 
            {
                out.println("<script>alert('Error: Profile update failed.'); window.location.href='admin_dashboard.jsp';</script>");
            }

            updatePstmt.close();
        } 
        else 
        {
            out.println("<script>alert('Error: Old password is incorrect.'); window.location.href='admin_dashboard.jsp';</script>");
        }

        rs.close();
        validatePstmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</body>
</html>