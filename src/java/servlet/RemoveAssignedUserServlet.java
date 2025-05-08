/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.NotificationDAO;
import dao.TaskDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RemoveAssignedUserServlet")
public class RemoveAssignedUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer projectManagerID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (projectManagerID == null || roleID == null || roleID != 2) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        try {
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            int userID = Integer.parseInt(request.getParameter("userID"));
            int projectID = Integer.parseInt(request.getParameter("projectID"));

            TaskDAO taskDAO = new TaskDAO();
            boolean removed = taskDAO.removeAssignedTaskUser(taskID, userID);

            if (removed) {
                // Send notification to removed user
                NotificationDAO notificationDAO = new NotificationDAO();
                String message = "You have been removed from task (ID: " + taskID + ") under project (ID: " + projectID + ").";
                notificationDAO.addNotification(userID, message);

                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=removed");
            } else {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=remove_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewTasksServlet?status=invalid_input");
        }
    }
}
