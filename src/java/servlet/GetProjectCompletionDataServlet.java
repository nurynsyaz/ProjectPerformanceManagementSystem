/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/GetProjectCompletionDataServlet")
public class GetProjectCompletionDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String sql = "SELECT p.projectID, p.projectName, t.statusID, t.taskEndDate "
                + "FROM projects p "
                + "JOIN tasks t ON p.projectID = t.projectID";

        Map<String, Map<Integer, Integer>> projectStatusCounts = new HashMap<>();
        Map<String, Boolean> projectHasDelayed = new HashMap<>();

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            java.util.Date today = new java.util.Date();

            while (rs.next()) {
                String projectName = rs.getString("projectName");
                int statusID = rs.getInt("statusID");
                java.sql.Date taskEndSQL = rs.getDate("taskEndDate");
                java.util.Date taskEndDate = (taskEndSQL != null) ? new java.util.Date(taskEndSQL.getTime()) : null;

                projectStatusCounts.putIfAbsent(projectName, new HashMap<Integer, Integer>());
                Map<Integer, Integer> counts = projectStatusCounts.get(projectName);
                counts.put(statusID, counts.getOrDefault(statusID, 0) + 1);

                if (taskEndDate != null && taskEndDate.before(today) && statusID != 2) {
                    projectHasDelayed.put(projectName, true);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Final classification
        Map<String, Integer> projectCategoryCount = new LinkedHashMap<>();
        projectCategoryCount.put("In Progress", 0);
        projectCategoryCount.put("On-Time", 0);
        projectCategoryCount.put("Delayed", 0);
        projectCategoryCount.put("Not Started", 0);

        for (Map.Entry<String, Map<Integer, Integer>> entry : projectStatusCounts.entrySet()) {
            String projectName = entry.getKey();
            Map<Integer, Integer> counts = entry.getValue();

            if (projectHasDelayed.getOrDefault(projectName, false)) {
                projectCategoryCount.put("Delayed", projectCategoryCount.get("Delayed") + 1);
            } else {
                int maxCount = -1;
                int majorityStatusID = -1;
                for (Map.Entry<Integer, Integer> c : counts.entrySet()) {
                    if (c.getValue() > maxCount) {
                        maxCount = c.getValue();
                        majorityStatusID = c.getKey();
                    }
                }

                switch (majorityStatusID) {
                    case 1:
                        projectCategoryCount.put("In Progress", projectCategoryCount.get("In Progress") + 1);
                        break;
                    case 2:
                        projectCategoryCount.put("On-Time", projectCategoryCount.get("On-Time") + 1);
                        break;
                    case 4:
                        projectCategoryCount.put("Not Started", projectCategoryCount.get("Not Started") + 1);
                        break;
                    default:
                        projectCategoryCount.put("In Progress", projectCategoryCount.get("In Progress") + 1);
                        break;
                }

            }
        }

        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("labels", new ArrayList<>(projectCategoryCount.keySet()));
        jsonMap.put("values", new ArrayList<>(projectCategoryCount.values()));

        String json = new Gson().toJson(jsonMap);
        response.getWriter().write(json);
    }
}
