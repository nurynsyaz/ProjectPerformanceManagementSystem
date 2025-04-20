/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteProjectServlet")
public class DeleteProjectServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int projectID = Integer.parseInt(request.getParameter("projectID"));
        ProjectDAO dao = new ProjectDAO();

        boolean success = dao.deleteProject(projectID);
        if (success) {
            response.sendRedirect("ViewProjectServlet");
        } else {
            response.getWriter().println("Error deleting project.");
        }
    }
}
