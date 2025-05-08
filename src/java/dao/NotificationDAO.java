/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBConnection;
import static db.DBConnection.getConnection;
import model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> getNotificationsByUserID(int userID) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE userID = ? ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationID(rs.getInt("notificationID"));
                n.setUserID(rs.getInt("userID"));
                n.setMessage(rs.getString("message"));
                n.setIsRead(rs.getBoolean("isRead"));
                n.setCreatedAt(rs.getTimestamp("createdAt"));
                notifications.add(n);
            }

        } catch (SQLException e) {
            System.err.println("❌ Error retrieving notifications: " + e.getMessage());
        }

        return notifications;
    }

    public boolean markAsRead(int notificationID) {
        String sql = "UPDATE notifications SET isRead = 1 WHERE notificationID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationID);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking notification as read: " + e.getMessage());
            return false;
        }
    }

    public boolean markAllAsRead(int userID) {
        String sql = "UPDATE notifications SET isRead = 1 WHERE userID = ? AND isRead = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking all notifications as read: " + e.getMessage());
            return false;
        }
    }

    public boolean addNotification(int userID, String message) {
        String sql = "INSERT INTO notifications (userID, message, isRead) VALUES (?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setString(2, message);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error adding notification: " + e.getMessage());
            return false;
        }
    }
    public List<Notification> getReadNotificationsByUserID(int userID) {
    List<Notification> list = new ArrayList<>();
    String sql = "SELECT * FROM notifications WHERE userID = ? AND isRead = 1 ORDER BY createdAt DESC";

    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Notification notif = new Notification(
                rs.getInt("notificationID"),
                rs.getInt("userID"),
                rs.getString("message"),
                rs.getBoolean("isRead"),
                rs.getTimestamp("createdAt")
            );
            list.add(notif);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
    public List<Notification> getUnreadNotificationsByUserID(int userID) {
    List<Notification> notifications = new ArrayList<>();
    String sql = "SELECT * FROM notifications WHERE userID = ? AND isRead = 0 ORDER BY createdAt DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userID);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Notification n = new Notification();
            n.setNotificationID(rs.getInt("notificationID"));
            n.setUserID(rs.getInt("userID"));
            n.setMessage(rs.getString("message"));
            n.setIsRead(rs.getBoolean("isRead"));
            n.setCreatedAt(rs.getTimestamp("createdAt"));
            notifications.add(n);
        }

    } catch (SQLException e) {
        System.err.println("❌ Error retrieving unread notifications: " + e.getMessage());
    }

    return notifications;
}


}
