/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class Notification {

    private int notificationID;
    private int userID;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    // ✅ No-argument constructor (required for JSP and JavaBean compliance)
    public Notification() {
    }

    // ✅ All-arguments constructor (convenient for DAO usage)
    public Notification(int notificationID, int userID, String message, boolean isRead, Timestamp createdAt) {
        this.notificationID = notificationID;
        this.userID = userID;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public int getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
