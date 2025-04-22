/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskDAO;
import model.Task;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/EditTaskServlet")
public class EditTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer roleID = (Integer) session.getAttribute("roleID");
        if (roleID == null || roleID != 2) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        int taskID = Integer.parseInt(request.getParameter("taskID"));
        TaskDAO dao = new TaskDAO();
        Task task = dao.getTaskById(taskID);

        if (task != null) {
            request.setAttribute("task", task);
            request.getRequestDispatcher("editTask.jsp").forward(request, response);
        } else {
            response.sendRedirect("ViewTasksServlet?status=edit_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            String taskName = request.getParameter("taskName");
            String taskDetails = request.getParameter("taskDetails");
            Date taskStartDate = Date.valueOf(request.getParameter("taskStartDate"));
            Date taskEndDate = Date.valueOf(request.getParameter("taskEndDate"));
            int statusID = Integer.parseInt(request.getParameter("statusID"));

            Task updatedTask = new Task();
            updatedTask.setTaskID(taskID);
            updatedTask.setProjectID(projectID);
            updatedTask.setTaskName(taskName);
            updatedTask.setTaskDetails(taskDetails);
            updatedTask.setTaskStartDate(taskStartDate);
            updatedTask.setTaskEndDate(taskEndDate);
            updatedTask.setStatusID(statusID);

            TaskDAO dao = new TaskDAO();
            boolean success = dao.updateTask(updatedTask);

            if (success) {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=updated");
            } else {
                response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=edit_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewTasksServlet?status=edit_failed");
        }
    }
}