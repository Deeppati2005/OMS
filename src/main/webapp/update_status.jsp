<%@ page import="java.sql.*" %>
<%
  String appointmentId = request.getParameter("appointment_id");
  String status = request.getParameter("status");

  Connection conn = null;
  PreparedStatement pstmt = null;

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Deep@123");

    String updateQuery = "UPDATE appointment SET pat_status = ? WHERE appointment_id = ?";
    pstmt = conn.prepareStatement(updateQuery);
    pstmt.setString(1, status);
    pstmt.setInt(2, Integer.parseInt(appointmentId));
    int rowsUpdated = pstmt.executeUpdate();

    if (rowsUpdated > 0) {
      request.setAttribute("statusMessage", "confirmed");
    } else {
      request.setAttribute("statusMessage", "error");
    }
  } catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("statusMessage", "error");
  } 

  request.getRequestDispatcher("doctor_dashboard.jsp").forward(request, response);
%>