/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectDAO;
import model.Project;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/EditProjectServlet")
public class EditProjectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer roleID = (Integer) session.getAttribute("roleID");
        if (roleID == null || roleID != 1) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        int projectID = Integer.parseInt(request.getParameter("projectID"));
        String projectName = request.getParameter("projectName");
        String projectDetails = request.getParameter("projectDetails");
        Date startDate = Date.valueOf(request.getParameter("projectStartDate"));
        Date endDate = Date.valueOf(request.getParameter("projectEndDate"));

        ProjectDAO dao = new ProjectDAO();
        Project existingProject = dao.getProjectById(projectID);

        if (existingProject == null) {
            response.sendRedirect("ViewProjectServlet?status=not_found");
            return;
        }

        Project updatedProject = new Project(
                projectID,
                projectName,
                projectDetails,
                existingProject.getUserID(),
                existingProject.getRoleID(),
                existingProject.getUsername(),
                startDate,
                endDate
        );

        boolean success = dao.updateProject(updatedProject);

        if (success) {
            response.sendRedirect("ViewProjectServlet?status=updated");
        } else {
            request.setAttribute("error", "Failed to update project.");
            request.setAttribute("project", updatedProject);
            request.getRequestDispatcher("editProject.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer roleID = (Integer) session.getAttribute("roleID");
        if (roleID == null || roleID != 1) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        int projectID = Integer.parseInt(request.getParameter("projectID"));
        ProjectDAO dao = new ProjectDAO();
        Project project = dao.getProjectById(projectID);

        if (project != null) {
            request.setAttribute("project", project);
            request.getRequestDispatcher("editProject.jsp").forward(request, response);
        } else {
            response.sendRedirect("ViewProjectServlet");
        }
    }
}