/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.User;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import static db.DBConnection.getConnection;
import java.util.UUID;

public class UserDAO {

    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("userID"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("password"),
                        rs.getString("salt"),
                        rs.getInt("roleID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, phoneNumber = ? WHERE userID = ?";
        try ( Connection conn = getConnection();  PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhoneNumber());
            pstmt.setInt(4, user.getUserID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserById(int userID) {
        User user = null;
        String sql = "SELECT * FROM users WHERE userID = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("userID"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("password"),
                        rs.getString("salt"),
                        rs.getInt("roleID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean deleteUser(int userID) {
        String sql = "DELETE FROM users WHERE userID = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT userID, username, email, phoneNumber, roleID FROM users";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

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

    public List<User> getUsersByRoles(List<Integer> roleIDs) {
        List<User> users = new ArrayList<>();
        if (roleIDs == null || roleIDs.isEmpty()) {
            return users;
        }

        StringBuilder placeholdersBuilder = new StringBuilder();
        for (int i = 0; i < roleIDs.size(); i++) {
            placeholdersBuilder.append("?");
            if (i < roleIDs.size() - 1) {
                placeholdersBuilder.append(",");
            }
        }
        String placeholders = placeholdersBuilder.toString();

        String sql = "SELECT userID, username, email, phoneNumber, roleID FROM users WHERE roleID IN (" + placeholders + ")";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < roleIDs.size(); i++) {
                stmt.setInt(i + 1, roleIDs.get(i));
            }

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

    public int getRoleByUserID(int userID) {
        String sql = "SELECT roleID FROM users WHERE userID = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("roleID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // return -1 if not found or error
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, email, phoneNumber, password, salt, roleID) VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getSalt());
            stmt.setInt(6, user.getRoleID());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(String email, String hashedPassword, String salt) {
        String sql = "UPDATE users SET password = ?, salt = ? WHERE email = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, salt);
            stmt.setString(3, email);
            return stmt.executeUpdate() > 0;  // Return true if password is updated
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Failed to update
    }

    public User getUserByPhoneAndHints(String phoneNumber, String answer1, String answer2) {
        User user = null;
        String sql = "SELECT * FROM users WHERE phoneNumber = ? AND security_answer_1 = ? AND security_answer_2 = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phoneNumber);
            stmt.setString(2, answer1);
            stmt.setString(3, answer2);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User(
                        rs.getInt("userID"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("password"),
                        rs.getString("salt"),
                        rs.getInt("roleID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updatePasswordByPhone(String phoneNumber, String hashedPassword, String salt) {
        String sql = "UPDATE users SET password = ?, salt = ? WHERE phoneNumber = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, salt);
            stmt.setString(3, phoneNumber);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public User getUserByPhone(String phoneNumber) {
    User user = null;
    String sql = "SELECT * FROM users WHERE phoneNumber = ?";
    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, phoneNumber);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            user = new User(
                rs.getInt("userID"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("phoneNumber"),
                rs.getString("password"),
                rs.getString("salt"),
                rs.getInt("roleID")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return user;
}
    public User getUserByPhoneAndHint(String phoneNumber, String passwordHint) {
    User user = null;
    String sql = "SELECT * FROM users WHERE phoneNumber = ? AND password_hint = ?";

    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, phoneNumber);
        stmt.setString(2, passwordHint);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            user = new User(
                rs.getInt("userID"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("phoneNumber"),
                rs.getString("password"),
                rs.getString("salt"),
                rs.getInt("roleID")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return user;
}
    public boolean updatePasswordAndHintByPhone(String phoneNumber, String hashedPassword, String salt, String passwordHint) {
    String sql = "UPDATE users SET password = ?, salt = ?, password_hint = ? WHERE phoneNumber = ?";
    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, hashedPassword);
        stmt.setString(2, salt);
        stmt.setString(3, passwordHint);
        stmt.setString(4, phoneNumber);
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

}