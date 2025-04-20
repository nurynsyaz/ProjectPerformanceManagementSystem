/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // Retrieve all comments for a given task ID
    public List<Comment> getCommentsByTaskID(int taskID) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.commentID, c.taskID, c.userID, c.commentText, c.createdAt, u.username " +
                     "FROM task_comments c JOIN users u ON c.userID = u.userID " +
                     "WHERE c.taskID = ? ORDER BY c.createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setCommentID(rs.getInt("commentID"));
                comment.setTaskID(rs.getInt("taskID"));
                comment.setUserID(rs.getInt("userID"));
                comment.setCommentText(rs.getString("commentText"));
                comment.setCreatedAt(rs.getTimestamp("createdAt"));
                comment.setUsername(rs.getString("username"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return comments;
    }

    // Add new comment
    public boolean addComment(Comment comment) {
        String sql = "INSERT INTO task_comments (taskID, userID, commentText, createdAt) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getTaskID());
            stmt.setInt(2, comment.getUserID());
            stmt.setString(3, comment.getCommentText());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update existing comment
    public boolean updateComment(Comment comment) {
        String sql = "UPDATE task_comments SET commentText = ? WHERE commentID = ? AND userID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, comment.getCommentText());
            stmt.setInt(2, comment.getCommentID());
            stmt.setInt(3, comment.getUserID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete comment by ID and user
    public boolean deleteComment(int commentID, int userID) {
        String sql = "DELETE FROM task_comments WHERE commentID = ? AND userID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, commentID);
            stmt.setInt(2, userID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
