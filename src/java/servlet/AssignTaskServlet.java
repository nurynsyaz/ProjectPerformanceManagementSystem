/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskDAO;
import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AssignTaskServlet")
public class AssignTaskServlet extends HttpServlet {

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

            UserDAO userDAO = new UserDAO();
            int targetRoleID = userDAO.getRoleByUserID(userID);

            if (targetRoleID == 3 || targetRoleID == 4) {
                TaskDAO taskDAO = new TaskDAO();
                boolean assigned = taskDAO.assignTaskToUser(taskID, userID);

                if (assigned) {
                    response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=assigned");
                } else {
                    response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=assign_failed");
                }
            } else {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=invalid_user_role");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewTasksServlet?status=invalid_input");
        }
    }
}
