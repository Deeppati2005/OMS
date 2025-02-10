<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String pat_name = request.getParameter("pat_name");
    String pat_old_pass = request.getParameter("pat_old_pass");
    String pat_new_pass = request.getParameter("pat_new_pass");

    String sessionEmail = (String) session.getAttribute("email");

    if (pat_name != null && pat_old_pass != null && pat_new_pass != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

            // Verify if the old password is correct
            String checkPassSql = "SELECT pat_pass FROM patient WHERE pat_email = ?";
            PreparedStatement checkPassStmt = con.prepareStatement(checkPassSql);
            checkPassStmt.setString(1, sessionEmail);
            ResultSet rs = checkPassStmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("pat_pass");

                if (!storedPassword.equals(pat_old_pass)) {
                    response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=failure");
                    return;
                }
            } else {
                response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=failure");
                return;
            }

            // If old password is correct, update profile
            String updateSql = "UPDATE patient SET pat_name = ?, pat_pass = ? WHERE pat_email = ?";
            PreparedStatement updateStmt = con.prepareStatement(updateSql);
            updateStmt.setString(1, pat_name);
            updateStmt.setString(2, pat_new_pass); // Correct index for new password
            updateStmt.setString(3, sessionEmail); // Correct index for email

            int updated = updateStmt.executeUpdate();
            if (updated > 0) {
                session.setAttribute("name", pat_name);
                response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=success");
            } else {
                response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=failure");
            }

            rs.close();
            checkPassStmt.close();
            updateStmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=failure");
        }
    } else {
        response.sendRedirect("patient_dashboard.jsp?section=editProfile&status=failure");
    }
%>