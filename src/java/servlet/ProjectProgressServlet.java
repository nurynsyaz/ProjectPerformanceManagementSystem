/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectProgressDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/ProjectProgressServlet")
public class ProjectProgressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (userID == null || roleID == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in.");
            return;
        }

        ProjectProgressDAO dao = new ProjectProgressDAO();
        Map<String, Integer> statusCounts;

        switch (roleID) {
            case 1: // Head Manager
                statusCounts = dao.getHeadManagerTaskStatusCounts(userID);
                break;
            case 2: // Project Manager
                statusCounts = dao.getProjectManagerTaskStatusCounts(userID);
                break;
            case 3: // Team Member
            case 4: // Client
                statusCounts = dao.getUserTaskStatusCounts(userID);
                break;
            default:
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid role.");
                return;
        }

        String json = new Gson().toJson(statusCounts);
        response.getWriter().write(json);
    }
}
