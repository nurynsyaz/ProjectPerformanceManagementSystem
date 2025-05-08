/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.NotificationDAO;
import db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Date;

@WebServlet("/CheckAndNotifyStatusServlet")
public class CheckAndNotifyStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try ( Connection conn = DBConnection.getConnection()) {
            NotificationDAO notificationDAO = new NotificationDAO();
            Date today = new Date();
            long oneDayMillis = 1L * 24 * 60 * 60 * 1000;

            // ✅ Declare all maps at the top
            Map<Integer, List<Integer>> projectAssignments = new HashMap<>();
            Map<Integer, String> projectNames = new HashMap<>();
            Map<Integer, Integer> delayedCount = new HashMap<>();
            Map<Integer, Integer> notStartedCount = new HashMap<>();

            // ✅ 1. Check for delayed or not started projects
            String projectSQL = "SELECT p.projectID, p.projectName, t.statusID, t.taskEndDate "
                    + "FROM projects p JOIN tasks t ON p.projectID = t.projectID";

            try ( PreparedStatement stmt = conn.prepareStatement(projectSQL);  ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    int projectID = rs.getInt("projectID");
                    String projectName = rs.getString("projectName");
                    int statusID = rs.getInt("statusID");
                    java.sql.Date sqlDate = rs.getDate("taskEndDate");
                    Date taskEndDate = (sqlDate != null) ? new Date(sqlDate.getTime()) : null;

                    projectNames.put(projectID, projectName);

                    if (statusID == 4) {
                        notStartedCount.put(projectID, notStartedCount.getOrDefault(projectID, 0) + 1);
                    }
                    if (taskEndDate != null && taskEndDate.before(today) && statusID != 2) {
                        delayedCount.put(projectID, delayedCount.getOrDefault(projectID, 0) + 1);
                    }
                }
            }

            // ✅ Get assigned users for each project
            String assignSQL = "SELECT projectID, userID FROM project_assignment";
            try ( PreparedStatement stmt = conn.prepareStatement(assignSQL);  ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    int projectID = rs.getInt("projectID");
                    int userID = rs.getInt("userID");

                    // Proper type-safe initialization
                    if (!projectAssignments.containsKey(projectID)) {
                        projectAssignments.put(projectID, new ArrayList<Integer>());
                    }

                    projectAssignments.get(projectID).add(userID);
                }
            }

            // ✅ Send project-level notifications
            for (Map.Entry<Integer, String> entry : projectNames.entrySet()) {
                int projectID = entry.getKey();
                String name = entry.getValue();

                List<Integer> users;
                if (projectAssignments.containsKey(projectID)) {
                    users = projectAssignments.get(projectID);
                } else {
                    users = new ArrayList<>();
                }

                if (delayedCount.getOrDefault(projectID, 0) > 0) {
                    for (int userID : users) {
                        notificationDAO.addNotification(userID, "⚠ Project \"" + name + "\" has delayed task(s).");
                    }
                } else if (notStartedCount.getOrDefault(projectID, 0) > 0) {
                    for (int userID : users) {
                        notificationDAO.addNotification(userID, "⏳ Project \"" + name + "\" is mostly not started.");
                    }
                }
            }

            // ✅ 2. Check for individual delayed or old not-started tasks
            String taskSQL = "SELECT t.taskID, t.taskName, t.taskEndDate, t.statusID, ta.userID "
                    + "FROM tasks t JOIN task_assignment ta ON t.taskID = ta.taskID";

            try ( PreparedStatement stmt = conn.prepareStatement(taskSQL);  ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    String taskName = rs.getString("taskName");
                    int statusID = rs.getInt("statusID");
                    int userID = rs.getInt("userID");

                    java.sql.Date sqlEnd = rs.getDate("taskEndDate");
                    if (sqlEnd == null) {
                        continue;
                    }

                    Date endDate = new Date(sqlEnd.getTime());
                    long ageMillis = today.getTime() - endDate.getTime();

                    if (statusID == 4 && ageMillis >= oneDayMillis) {
                        notificationDAO.addNotification(userID, "⏰ Task \"" + taskName + "\" has not started for over 1 day.");
                    } else if (statusID != 2 && endDate.before(today)) {
                        notificationDAO.addNotification(userID, "❗ Task \"" + taskName + "\" is delayed.");
                    }
                }
            }

            response.getWriter().println("✅ Notifications checked and dispatched.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error during notification dispatch: " + e.getMessage());
        }
    }
}
