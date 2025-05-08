/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.NotificationDAO;
import dao.ProjectDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RemoveAssignmentServlet")
public class RemoveAssignmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer headManagerID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (headManagerID == null || roleID == null || roleID != 1) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        int projectID = Integer.parseInt(request.getParameter("projectID"));
        int userID = Integer.parseInt(request.getParameter("userID"));

        ProjectDAO projectDAO = new ProjectDAO();
        boolean removed = projectDAO.removeUserFromProject(projectID, userID);

        if (removed) {
            // Send notification to removed user
            NotificationDAO notificationDAO = new NotificationDAO();
            String message = "You have been removed from project (ID: " + projectID + ").";
            notificationDAO.addNotification(userID, message);

            response.sendRedirect("ViewProjectServlet?status=removed");
        } else {
            response.sendRedirect("ViewProjectServlet?status=remove_failed");
        }
    }
}
