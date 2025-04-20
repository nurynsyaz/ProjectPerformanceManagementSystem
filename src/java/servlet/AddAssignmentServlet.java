/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectDAO;
import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddAssignmentServlet")
public class AddAssignmentServlet extends HttpServlet {

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

        UserDAO userDAO = new UserDAO();
        int targetRole = userDAO.getRoleByUserID(userID);

        if (targetRole == 2 || targetRole == 3 || targetRole == 4) {
            ProjectDAO projectDAO = new ProjectDAO();
            boolean assigned = projectDAO.assignUserToProject(projectID, userID, headManagerID);
            if (assigned) {
                response.sendRedirect("ViewProjectServlet?status=assigned");
            } else {
                response.sendRedirect("ViewProjectServlet?status=assign_failed");
            }
        } else {
            response.sendRedirect("ViewProjectServlet?status=invalid_user_role");
        }
    }
}
