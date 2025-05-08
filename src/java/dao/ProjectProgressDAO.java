/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class ProjectProgressDAO {

    public Map<String, Integer> getTaskStatusCounts(int projectID) {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT s.statusDescription, COUNT(*) AS count "
                   + "FROM tasks t JOIN status s ON t.statusID = s.statusID "
                   + "WHERE t.projectID = ? "
                   + "GROUP BY s.statusDescription";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                statusCounts.put(rs.getString("statusDescription"), rs.getInt("count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusCounts;
    }

    public int getTotalTasks(int projectID) {
        String sql = "SELECT COUNT(*) AS total FROM tasks WHERE projectID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Integer> getUserTaskStatusCounts(int userID) {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT s.statusDescription, COUNT(*) AS count "
                   + "FROM tasks t "
                   + "JOIN status s ON t.statusID = s.statusID "
                   + "JOIN task_assignment ta ON t.taskID = ta.taskID "
                   + "WHERE ta.userID = ? "
                   + "GROUP BY s.statusDescription";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                statusCounts.put(rs.getString("statusDescription"), rs.getInt("count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusCounts;
    }

    public Map<String, Integer> getHeadManagerTaskStatusCounts(int userID) {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT s.statusDescription, COUNT(*) AS count "
                   + "FROM tasks t "
                   + "JOIN projects p ON t.projectID = p.projectID "
                   + "JOIN status s ON t.statusID = s.statusID "
                   + "WHERE p.createdBy = ? "
                   + "GROUP BY s.statusDescription";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                statusCounts.put(rs.getString("statusDescription"), rs.getInt("count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusCounts;
    }

    public Map<String, Integer> getProjectManagerTaskStatusCounts(int userID) {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT s.statusDescription, COUNT(*) AS count "
                   + "FROM tasks t "
                   + "JOIN status s ON t.statusID = s.statusID "
                   + "JOIN project_assignment pa ON t.projectID = pa.projectID "
                   + "WHERE pa.userID = ? "
                   + "GROUP BY s.statusDescription";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                statusCounts.put(rs.getString("statusDescription"), rs.getInt("count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusCounts;
    }

    // ✅ Head Manager - Projects created by them
    public Map<String, Map<String, Integer>> getProjectsByCreatedBy(int userID) {
        return getStatusGroupedByProject("WHERE p.userID = ?", userID);
    }

    // ✅ Project Manager - Assigned to projects
    public Map<String, Map<String, Integer>> getProjectsByProjectAssignment(int userID) {
        return getStatusGroupedByProject("JOIN project_assignment pa ON p.projectID = pa.projectID WHERE pa.userID = ?", userID);
    }

    // ✅ Team Member or Client - Assigned to tasks
    public Map<String, Map<String, Integer>> getProjectsByTaskAssignment(int userID) {
        return getStatusGroupedByProject("JOIN task_assignment ta ON t.taskID = ta.taskID WHERE ta.userID = ?", userID);
    }

    // ✅ Reusable logic for status distribution
    private Map<String, Map<String, Integer>> getStatusGroupedByProject(String whereClause, int userID) {
        Map<String, Map<String, Integer>> result = new LinkedHashMap<>();
        String sql = "SELECT p.projectName, s.statusDescription, COUNT(*) AS count "
                   + "FROM tasks t "
                   + "JOIN status s ON t.statusID = s.statusID "
                   + "JOIN projects p ON t.projectID = p.projectID "
                   + whereClause + " "
                   + "GROUP BY p.projectName, s.statusDescription";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String projectName = rs.getString("projectName");
                String status = rs.getString("statusDescription");
                int count = rs.getInt("count");

                if (!result.containsKey(projectName)) {
                    result.put(projectName, new HashMap<String, Integer>());
                }
                result.get(projectName).put(status, count);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}
