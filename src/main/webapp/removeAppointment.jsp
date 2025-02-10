<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String appointmentId = request.getParameter("appointment_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

        String query = "DELETE FROM appointment WHERE appointment_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, Integer.parseInt(appointmentId));
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            request.setAttribute("statusMessage", "removed");
        } else {
            request.setAttribute("statusMessage", "error");
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("statusMessage", "error");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("doctor_dashboard.jsp");
%>