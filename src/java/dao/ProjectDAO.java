/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Project;
import model.User;

public class ProjectDAO {

    private static final String JDBC_URL = System.getenv("DB_URL");
    private static final String JDBC_USERNAME = System.getenv("DB_USER");
    private static final String JDBC_PASSWORD = System.getenv("DB_PASS");

    public List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT p.projectID, p.projectName, p.projectDetails, p.userID, p.roleID, " +
                     "p.projectStartDate, p.projectEndDate, u.username " +
                     "FROM projects p JOIN users u ON p.userID = u.userID";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("projectID"),
                        rs.getString("projectName"),
                        rs.getString("projectDetails"),
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getString("username"),
                        rs.getDate("projectStartDate"),
                        rs.getDate("projectEndDate")
                );
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return projects;
    }

    public Project getProjectById(int projectID) {
        String sql = "SELECT p.projectID, p.projectName, p.projectDetails, p.userID, p.roleID, " +
                     "p.projectStartDate, p.projectEndDate, u.username " +
                     "FROM projects p JOIN users u ON p.userID = u.userID WHERE p.projectID = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Project(
                        rs.getInt("projectID"),
                        rs.getString("projectName"),
                        rs.getString("projectDetails"),
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getString("username"),
                        rs.getDate("projectStartDate"),
                        rs.getDate("projectEndDate")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProject(Project project) {
        String sql = "UPDATE projects SET projectName = ?, projectDetails = ?, " +
                     "projectStartDate = ?, projectEndDate = ? WHERE projectID = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getProjectName());
            stmt.setString(2, project.getProjectDetails());
            stmt.setDate(3, project.getProjectStartDate());
            stmt.setDate(4, project.getProjectEndDate());
            stmt.setInt(5, project.getProjectID());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProject(int projectID) {
        String sql = "DELETE FROM projects WHERE projectID = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addProject(Project project) {
        String sql = "INSERT INTO projects (projectName, projectDetails, userID, roleID, projectStartDate, projectEndDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getProjectName());
            stmt.setString(2, project.getProjectDetails());
            stmt.setInt(3, project.getUserID());
            stmt.setInt(4, project.getRoleID());
            stmt.setDate(5, project.getProjectStartDate());
            stmt.setDate(6, project.getProjectEndDate());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Project> getProjectsByUser(int userID) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT p.projectID, p.projectName, p.projectDetails, p.userID, p.roleID, " +
                     "p.projectStartDate, p.projectEndDate, u.username " +
                     "FROM projects p JOIN users u ON p.userID = u.userID WHERE p.userID = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("projectID"),
                        rs.getString("projectName"),
                        rs.getString("projectDetails"),
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getString("username"),
                        rs.getDate("projectStartDate"),
                        rs.getDate("projectEndDate")
                );
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return projects;
    }

    public boolean assignUserToProject(int projectID, int userID, int assignedBy) {
        String sql = "INSERT INTO project_assignment (projectID, userID, assignedBy) VALUES (?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            stmt.setInt(2, userID);
            stmt.setInt(3, assignedBy);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAssignedUsersByProject(int projectID) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.userID, u.username, u.email, u.phoneNumber, u.roleID " +
                     "FROM project_assignment pa " +
                     "JOIN users u ON pa.userID = u.userID " +
                     "WHERE pa.projectID = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setRoleID(rs.getInt("roleID"));
                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    public List<Project> getAssignedProjects(int userID) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT p.projectID, p.projectName, p.projectDetails, p.userID, p.roleID, " +
                     "p.projectStartDate, p.projectEndDate, u.username " +
                     "FROM project_assignment pa " +
                     "JOIN projects p ON pa.projectID = p.projectID " +
                     "JOIN users u ON p.userID = u.userID " +
                     "WHERE pa.userID = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project(
                        rs.getInt("projectID"),
                        rs.getString("projectName"),
                        rs.getString("projectDetails"),
                        rs.getInt("userID"),
                        rs.getInt("roleID"),
                        rs.getString("username"),
                        rs.getDate("projectStartDate"),
                        rs.getDate("projectEndDate")
                );
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return projects;
    }

    public boolean removeUserFromProject(int projectID, int userID) {
        String sql = "DELETE FROM project_assignment WHERE projectID = ? AND userID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectID);
            stmt.setInt(2, userID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
