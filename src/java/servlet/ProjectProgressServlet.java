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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (userID == null || roleID == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in.");
            return;
        }

        ProjectProgressDAO dao = new ProjectProgressDAO();
        Map<String, Map<String, Integer>> rawData = new HashMap<>();

        try {
            switch (roleID) {
                case 1: // Head Manager - projects created by them
                    rawData = dao.getProjectsByCreatedBy(userID);
                    break;
                case 2: // Project Manager - assigned to projects
                    rawData = dao.getProjectsByProjectAssignment(userID);
                    break;
                case 3: // Team Member
                case 4: // Client - assigned to tasks
                    rawData = dao.getProjectsByTaskAssignment(userID);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid role.");
                    return;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Data access error.");
            e.printStackTrace();
            return;
        }

        List<Map<String, Object>> formatted = new ArrayList<>();

        for (Map.Entry<String, Map<String, Integer>> entry : rawData.entrySet()) {
            String projectName = entry.getKey();
            Map<String, Integer> statusMap = entry.getValue();

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("projectName", projectName);
            row.put("inProgress", statusMap.getOrDefault("In Progress", 0));
            row.put("onTime", statusMap.getOrDefault("On-Time", 0));
            row.put("delayed", statusMap.getOrDefault("Delayed", 0));
            row.put("notStarted", statusMap.getOrDefault("Not Started", 0));

            formatted.add(row);
        }

        new Gson().toJson(formatted, response.getWriter());
    }
}

