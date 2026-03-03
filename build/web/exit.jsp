<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Destroy session
    if (session != null) {
        session.invalidate();
    }

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>
