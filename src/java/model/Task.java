/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class Task {

    private int taskID;
    private String taskName;
    private String taskDetails;
    private Date taskStartDate;
    private Date taskEndDate;
    private int statusID;
    private String statusDescription; // from status table
    private int projectID;
    private String projectName; // from projects table
    private int assignedUserID;

    public Task() {
    }

    // Full constructor with projectID and projectName
    public Task(int taskID, int projectID, String taskName, String taskDetails, Date taskStartDate,
            Date taskEndDate, int statusID, String statusDescription) {
        this.taskID = taskID;
        this.projectID = projectID;
        this.taskName = taskName;
        this.taskDetails = taskDetails;
        this.taskStartDate = taskStartDate;
        this.taskEndDate = taskEndDate;
        this.statusID = statusID;
        this.statusDescription = statusDescription;
    }

    // Getters and Setters
    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getTaskDetails() {
        return taskDetails;
    }

    public void setTaskDetails(String taskDetails) {
        this.taskDetails = taskDetails;
    }

    public Date getTaskStartDate() {
        return taskStartDate;
    }

    public void setTaskStartDate(Date taskStartDate) {
        this.taskStartDate = taskStartDate;
    }

    public Date getTaskEndDate() {
        return taskEndDate;
    }

    public void setTaskEndDate(Date taskEndDate) {
        this.taskEndDate = taskEndDate;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public String getStatusDescription() {
        return statusDescription;
    }

    public void setStatusDescription(String statusDescription) {
        this.statusDescription = statusDescription;
    }

    public int getProjectID() {
        return projectID;
    }

    public void setProjectID(int projectID) {
        this.projectID = projectID;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public int getAssignedUserID() {
        return assignedUserID;
    }

    public void setAssignedUserID(int assignedUserID) {
        this.assignedUserID = assignedUserID;
    }
}
