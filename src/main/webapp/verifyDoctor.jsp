<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String doctorEmail = request.getParameter("doctorEmail");
    
    if (doctorEmail != null) {
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123")) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Update doctor's status to 'verified'
            String updateQuery = "UPDATE doctor SET status = 'verified' WHERE doc_email = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                pstmt.setString(1, doctorEmail);
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Redirect back to the doctor list
    response.sendRedirect("admin_dashboard.jsp?section=doctorList");
%>
