/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import db.DBConnection;
import pass.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AddClientServlet")
public class AddClientServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String passwordHint = request.getParameter("passwordHint");
        String role = "4"; // Client role fixed as 4

        // ✅ Validation
        if (!isValidEmail(email)) {
            returnWithError("❌ Invalid email format.", request, response);
            return;
        }

        if (!isValidPhoneNumber(phoneNumber)) {
            returnWithError("❌ Phone number must be exactly 10 digits.", request, response);
            return;
        }

        if (!isValidPassword(password)) {
            returnWithError("❌ Password must be at least 8 characters, with uppercase, lowercase, digit, and special character.", request, response);
            return;
        }

        if (isUserExists(username, email)) {
            returnWithError("❌ Username or email already exists.", request, response);
            return;
        }

        // ✅ Hashing
        String salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(password, salt);

        boolean success = registerUser(username, email, phoneNumber, hashedPassword, salt, role, passwordHint);

        if (success) {
            response.sendRedirect("ManageUsersServlet?status=added");
        } else {
            returnWithError("❌ Failed to add client.", request, response);
        }
    }

    private boolean isUserExists(String username, String email) {
        String query = "SELECT 1 FROM users WHERE LOWER(username) = LOWER(?) OR LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    private boolean registerUser(String username, String email, String phoneNumber, String hashedPassword, String salt, String role, String passwordHint) {
        String insertQuery = "INSERT INTO users (username, email, phoneNumber, password, salt, roleID, password_hint) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(insertQuery)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phoneNumber);
            ps.setString(4, hashedPassword);
            ps.setString(5, salt);
            ps.setInt(6, Integer.parseInt(role));
            ps.setString(7, passwordHint);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    // === Validation Methods ===
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
    }

    private boolean isValidPhoneNumber(String phoneNumber) {
        return phoneNumber != null && phoneNumber.matches("^\\d{10}$");
    }

    private boolean isValidPassword(String password) {
        return password != null && password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$");
    }

    private void returnWithError(String errorMessage, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("addClientError", errorMessage);
        request.setAttribute("showAddClientModal", true);
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }
}
