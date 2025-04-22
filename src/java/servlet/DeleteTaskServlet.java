/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteTaskServlet")
public class DeleteTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer roleID = (Integer) session.getAttribute("roleID");
        if (roleID == null || roleID != 2) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        try {
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            int projectID = Integer.parseInt(request.getParameter("projectID"));

            TaskDAO dao = new TaskDAO();
            boolean deleted = dao.deleteTask(taskID);

            if (deleted) {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=deleted");
            } else {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewTasksServlet?status=delete_failed");
        }
    }
}
