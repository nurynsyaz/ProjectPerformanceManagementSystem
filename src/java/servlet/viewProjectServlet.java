/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectDAO;
import dao.UserDAO;
import model.Project;
import model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ViewProjectServlet")
public class viewProjectServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ProjectDAO projectDAO = new ProjectDAO();
        List<Project> projects;

        if (roleID != null && roleID == 1) {
            // Head Manager: show projects created by them
            projects = projectDAO.getProjectsByUser(userID);
        } else {
            // Others: show projects assigned to them
            projects = projectDAO.getAssignedProjects(userID);
        }

        request.setAttribute("projects", projects);

        // Assigned users map: projectID -> list of users (only for Head Manager view)
        Map<Integer, List<User>> assignedUsersMap = new HashMap<>();
        for (Project project : projects) {
            List<User> assignedUsers = projectDAO.getAssignedUsersByProject(project.getProjectID());
            assignedUsersMap.put(project.getProjectID(), assignedUsers);
        }
        request.setAttribute("assignedUsersMap", assignedUsersMap);

        // Only Head Manager can assign users
        if (roleID != null && roleID == 1) {
            UserDAO userDAO = new UserDAO();
            List<User> eligibleUsers = userDAO.getUsersByRoles(Arrays.asList(2, 3, 4));
            request.setAttribute("eligibleUsers", eligibleUsers);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("viewProject.jsp");
        dispatcher.forward(request, response);
    }
}
