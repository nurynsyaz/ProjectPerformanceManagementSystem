/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import java.sql.*;

public class ProjectCompletionDAO {

    public boolean updateProjectCompletion(int projectID) {
        String sql = "INSERT INTO project_completion (projectID, totalTasks, completedTasks, completionPercentage) " +
                     "SELECT p.projectID, COUNT(t.taskID), " +
                     "SUM(CASE WHEN s.statusDescription = 'On-Time' THEN 1 ELSE 0 END), " +
                     "ROUND(AVG(CASE " +
                     "WHEN s.statusDescription = 'On-Time' THEN 100 " +
                     "WHEN s.statusDescription = 'In Progress' THEN 50 " +
                     "WHEN s.statusDescription = 'Delayed' THEN 50 " +
                     "WHEN s.statusDescription = 'Not Started' THEN 0 ELSE 0 END), 2) " +
                     "FROM projects p " +
                     "JOIN tasks t ON p.projectID = t.projectID " +
                     "JOIN status s ON t.statusID = s.statusID " +
                     "WHERE p.projectID = ? GROUP BY p.projectID " +
                     "ON DUPLICATE KEY UPDATE totalTasks = VALUES(totalTasks), " +
                     "completedTasks = VALUES(completedTasks), " +
                     "completionPercentage = VALUES(completionPercentage), " +
                     "calculatedAt = CURRENT_TIMESTAMP";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 