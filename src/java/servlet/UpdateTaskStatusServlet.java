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

@WebServlet("/UpdateTaskStatusServlet")
public class UpdateTaskStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int taskID = Integer.parseInt(request.getParameter("taskID"));
        int statusID = Integer.parseInt(request.getParameter("statusID"));

        TaskDAO taskDAO = new TaskDAO();
        boolean updated = taskDAO.updateTaskStatus(taskID, statusID);

        if (updated) {
            // You can optionally log or trigger future progress tracking here
            response.getWriter().write("Status Updated");
        } else {
            response.getWriter().write("Failed to update status");
        }
    }
}
