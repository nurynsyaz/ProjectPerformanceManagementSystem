
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectDAO;
import dao.TaskDAO;
import dao.UserDAO;
import model.Project;
import model.Task;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ViewTasksServlet")
public class ViewTasksServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        TaskDAO taskDAO = new TaskDAO();
        ProjectDAO projectDAO = new ProjectDAO();
        UserDAO userDAO = new UserDAO();

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (userID == null || roleID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Project> projects;

        if (roleID == 1) {
            projects = projectDAO.getProjectsByUser(userID);
        } else {
            projects = projectDAO.getAssignedProjects(userID);
        }

        request.setAttribute("projects", projects);

        String projectIDParam = request.getParameter("projectID");
        List<Task> tasks = new ArrayList<>();

        if (projectIDParam != null && !projectIDParam.isEmpty()) {
            int projectID = Integer.parseInt(projectIDParam);
            boolean hasAccess = false;

            for (Project p : projects) {
                if (p.getProjectID() == projectID) {
                    hasAccess = true;
                    break;
                }
            }

            if (hasAccess) {
                tasks = taskDAO.getTasksByProjectID(projectID);
            }
        } else {
            if (roleID == 1) {
                tasks = taskDAO.getAllTasksWithStatus();
            }
        }

        request.setAttribute("tasks", tasks);

// ✅ Filter only Team Members and Clients
        List<User> allUsers = userDAO.getAllUsers();
        List<User> eligibleUsers = new ArrayList<User>();
        for (User user : allUsers) {
            if (user.getRoleID() == 3 || user.getRoleID() == 4) {
                eligibleUsers.add(user);
            }
        }
        request.setAttribute("eligibleUsers", eligibleUsers);

// ✅ Add this line to fix missing assignment data
        if (!tasks.isEmpty()) {
            request.setAttribute("taskAssignments", taskDAO.getAssignedUsersForTasks(tasks));
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("viewTasks.jsp");
        dispatcher.forward(request, response);
    }
    
    }
