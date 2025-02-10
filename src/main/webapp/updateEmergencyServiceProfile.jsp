<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String emer_email = (String) session.getAttribute("email");
    String oldPass = request.getParameter("old_pass");
    String newPass = request.getParameter("new_pass");
    String emer_type = request.getParameter("emer_type");
    String emer_num = request.getParameter("emer_num");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String statusMessage = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

        // Verify old password
        String verifyQuery = "SELECT * FROM emergency_service WHERE emer_email = ?";
        pstmt = conn.prepareStatement(verifyQuery);
        pstmt.setString(1, emer_email);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String currentPass = rs.getString("emer_pass");
            if (!currentPass.equals(oldPass)) {
                statusMessage = "old_password_incorrect";
            } else if (currentPass.equals(newPass)) {
                statusMessage = "new_password_same";
            } else {
                // Update profile
                String updateQuery = "UPDATE emergency_service SET emer_pass = ?, emer_type = ?, emer_no = ? WHERE emer_email = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(1, newPass);
                pstmt.setString(2, emer_type);
                pstmt.setString(3, emer_num);
                pstmt.setString(4, emer_email);
                pstmt.executeUpdate();
                statusMessage = "profile_updated";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
    
    // Set statusMessage in request scope for use in JavaScript
    request.setAttribute("statusMessage", statusMessage);
%>

<script type="text/javascript">
    window.onload = function() {
        var statusMessage = '<%= request.getAttribute("statusMessage") %>';
        if (statusMessage === 'old_password_incorrect') {
            alert("The old password you entered is incorrect.");
            window.location.href = "emer_dashboard.jsp?section=editProfile";
        } else if (statusMessage === 'new_password_same') {
            alert("The new password cannot be the same as the old password.");
            window.location.href = "emer_dashboard.jsp?section=editProfile";
        } else if (statusMessage === 'profile_updated') {
            alert("Your profile has been updated successfully.");
            window.location.href = "emer_dashboard.jsp";
        }
    };
</script>

<!-- Your existing HTML content -->
