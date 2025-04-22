/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import model.Task;
import model.User;
import dao.UserDAO;
import java.sql.*;
import java.util.*;

public class TaskDAO {

    public List<Task> getAllTasksWithStatus() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, s.statusDescription, p.projectName "
                + "FROM tasks t "
                + "JOIN status s ON t.statusID = s.statusID "
                + "JOIN projects p ON t.projectID = p.projectID";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Task task = new Task(
                        rs.getInt("taskID"),
                        rs.getInt("projectID"),
                        rs.getString("taskName"),
                        rs.getString("taskDetails"),
                        rs.getDate("taskStartDate"),
                        rs.getDate("taskEndDate"),
                        rs.getInt("statusID"),
                        rs.getString("statusDescription")
                );
                task.setProjectName(rs.getString("projectName"));
                tasks.add(task);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    public List<Task> getTasksByProjectID(int projectID) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, s.statusDescription, p.projectName "
                + "FROM tasks t "
                + "JOIN status s ON t.statusID = s.statusID "
                + "JOIN projects p ON t.projectID = p.projectID "
                + "WHERE t.projectID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Task task = new Task(
                        rs.getInt("taskID"),
                        rs.getInt("projectID"),
                        rs.getString("taskName"),
                        rs.getString("taskDetails"),
                        rs.getDate("taskStartDate"),
                        rs.getDate("taskEndDate"),
                        rs.getInt("statusID"),
                        rs.getString("statusDescription")
                );
                task.setProjectName(rs.getString("projectName"));
                tasks.add(task);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    public Task getTaskById(int taskID) {
        Task task = null;
        String sql = "SELECT t.*, s.statusDescription, p.projectName "
                + "FROM tasks t "
                + "JOIN status s ON t.statusID = s.statusID "
                + "JOIN projects p ON t.projectID = p.projectID "
                + "WHERE t.taskID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                task = new Task(
                        rs.getInt("taskID"),
                        rs.getInt("projectID"),
                        rs.getString("taskName"),
                        rs.getString("taskDetails"),
                        rs.getDate("taskStartDate"),
                        rs.getDate("taskEndDate"),
                        rs.getInt("statusID"),
                        rs.getString("statusDescription")
                );
                task.setProjectName(rs.getString("projectName"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return task;
    }

    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET projectID=?, taskName=?, taskDetails=?, taskStartDate=?, taskEndDate=?, statusID=? WHERE taskID=?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, task.getProjectID());
            stmt.setString(2, task.getTaskName());
            stmt.setString(3, task.getTaskDetails());
            stmt.setDate(4, new java.sql.Date(task.getTaskStartDate().getTime()));
            stmt.setDate(5, new java.sql.Date(task.getTaskEndDate().getTime()));
            stmt.setInt(6, task.getStatusID());
            stmt.setInt(7, task.getTaskID());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTask(int taskID) {
        String sql = "DELETE FROM tasks WHERE taskID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean assignTaskToUser(int taskID, int userID) {
        String sql = "INSERT INTO task_assignment (taskID, userID) VALUES (?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskID);
            stmt.setInt(2, userID);
            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeAssignedTaskUser(int taskID, int userID) {
        String sql = "DELETE FROM task_assignment WHERE taskID = ? AND userID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskID);
            stmt.setInt(2, userID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<Integer, List<User>> getAssignedUsersForTasks(List<Task> tasks) {
        Map<Integer, List<User>> assignments = new HashMap<>();
        String sql = "SELECT ta.taskID, u.userID, u.username, u.email, u.phoneNumber, u.roleID "
                + "FROM task_assignment ta "
                + "JOIN users u ON ta.userID = u.userID "
                + "WHERE ta.taskID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (Task task : tasks) {
                stmt.setInt(1, task.getTaskID());
                try ( ResultSet rs = stmt.executeQuery()) {
                    List<User> assigned = new ArrayList<>();
                    while (rs.next()) {
                        User user = new User();
                        user.setUserID(rs.getInt("userID"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setPhoneNumber(rs.getString("phoneNumber"));
                        user.setRoleID(rs.getInt("roleID"));
                        assigned.add(user);
                    }
                    assignments.put(task.getTaskID(), assigned);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assignments;
    }

    public boolean updateTaskStatus(int taskID, int statusID) {
        String sql = "UPDATE tasks SET statusID = ? WHERE taskID = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, statusID);
            stmt.setInt(2, taskID);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
