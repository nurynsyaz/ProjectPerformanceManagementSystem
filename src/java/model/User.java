/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class User {

    private int userID;
    private String username;
    private String email;
    private String phoneNumber;
    private String password;
    private String salt;
    private int roleID;
    private String securityQuestion;
    private String securityAnswer;

    // Full constructor with security question and answer
    public User(int userID, String username, String email, String phoneNumber, String password, String salt, int roleID, String securityQuestion, String securityAnswer) {
        this.userID = userID;
        this.username = username;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.salt = salt;
        this.roleID = roleID;
        this.securityQuestion = securityQuestion;
        this.securityAnswer = securityAnswer;
    }

    // Constructor without security question/answer (for legacy use)
    public User(int userID, String username, String email, String phoneNumber, String password, String salt, int roleID) {
        this(userID, username, email, phoneNumber, password, salt, roleID, null, null);
    }

    // Empty constructor
    public User() {
    }

    // Getters and Setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public String getSecurityQuestion() {
        return securityQuestion;
    }

    public void setSecurityQuestion(String securityQuestion) {
        this.securityQuestion = securityQuestion;
    }

    public String getSecurityAnswer() {
        return securityAnswer;
    }

    public void setSecurityAnswer(String securityAnswer) {
        this.securityAnswer = securityAnswer;
    }
}
