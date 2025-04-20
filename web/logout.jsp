<%-- 
    Document   : logout
    Created on : 3 Mar 2025, 3:01:00 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the session to log out the user
    if (session != null) {
        session.invalidate();
    }
    
    // Redirect to index.jsp
    response.sendRedirect("index.jsp");
%>