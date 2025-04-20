<%-- 
    Document   : projectError
    Created on : 7 Mar 2025, 3:52:57 pm
    Author     : nurin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/addproject.css">
    </head>
    <body>
        <h1>Error Occurred!</h1>
        <p>${errorMessage}</p>
        <a href="addProject.jsp">Try Again</a>
    </body>
</html>