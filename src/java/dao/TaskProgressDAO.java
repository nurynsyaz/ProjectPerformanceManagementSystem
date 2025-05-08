/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import model.TaskProgress;

import java.sql.*;
import java.util.*;
import model.Task;

public class TaskProgressDAO {

    public boolean addProgress(TaskProgress progress) {
        String sql = "INSERT INTO task_progress (taskID, userID, fileName, notes, projectID) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, progress.getTaskID());
            stmt.setInt(2, progress.getUserID());
            stmt.setString(3, progress.getFileName());
            stmt.setString(4, progress.getNotes());
            stmt.setInt(5, progress.getProjectID()); // ✅ Insert projectID

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<TaskProgress> getProgressByTaskID(int taskID) {
        List<TaskProgress> list = new ArrayList<>();
        String sql = "SELECT * FROM task_progress WHERE taskID = ? ORDER BY uploadedAt DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TaskProgress progress = new TaskProgress(
                        rs.getInt("progressID"),
                        rs.getInt("taskID"),
                        rs.getInt("userID"),
                        rs.getString("fileName"),
                        rs.getString("notes"),
                        rs.getTimestamp("uploadedAt"),
                        rs.getInt("projectID") // only in JOIN queries with the `tasks` table
                );

                list.add(progress);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public TaskProgress getProgressByID(int progressID) {
        String sql = "SELECT tp.*, t.projectID FROM task_progress tp JOIN tasks t ON tp.taskID = t.taskID WHERE tp.progressID = ?";
        TaskProgress progress = null;

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, progressID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                progress = new TaskProgress(
                        rs.getInt("progressID"),
                        rs.getInt("taskID"),
                        rs.getInt("userID"),
                        rs.getString("fileName"),
                        rs.getString("notes"),
                        rs.getTimestamp("uploadedAt"),
                        rs.getInt("projectID") // 🔄 NEW
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return progress;
    }

    public boolean updateProgress(TaskProgress progress) {
        String sql = "UPDATE task_progress SET fileName = ?, notes = ?, uploadedAt = CURRENT_TIMESTAMP WHERE progressID = ? AND userID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, progress.getFileName());
            stmt.setString(2, progress.getNotes());
            stmt.setInt(3, progress.getProgressID());
            stmt.setInt(4, progress.getUserID());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteProgressByID(int progressID) {
        String sql = "DELETE FROM task_progress WHERE progressID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, progressID);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows deleted: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getFileNameByProgressID(int progressID) {
        String sql = "SELECT fileName FROM task_progress WHERE progressID = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, progressID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("fileName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteProgressByFileName(String fileName) {
        String sql = "DELETE FROM task_progress WHERE fileName = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, fileName);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("🧹 Rows deleted by fileName: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public Map<Integer, List<TaskProgress>> getProgressForTasks(List<Task> tasks) {
    Map<Integer, List<TaskProgress>> map = new HashMap<>();
    String sql = "SELECT * FROM task_progress WHERE taskID = ? ORDER BY uploadedAt DESC";

    try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        for (model.Task task : tasks) {
            stmt.setInt(1, task.getTaskID());
            try (ResultSet rs = stmt.executeQuery()) {
                List<TaskProgress> progressList = new ArrayList<>();
                while (rs.next()) {
                    TaskProgress progress = new TaskProgress(
                        rs.getInt("progressID"),
                        rs.getInt("taskID"),
                        rs.getInt("userID"),
                        rs.getString("fileName"),
                        rs.getString("notes"),
                        rs.getTimestamp("uploadedAt"),
                        rs.getInt("projectID")
                    );
                    progressList.add(progress);
                }
                map.put(task.getTaskID(), progressList);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return map;
}


}
