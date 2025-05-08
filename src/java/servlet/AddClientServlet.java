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

@WebServlet("/addclient")
public class AddClientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("✅ AddClientServlet: doPost triggered");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer = request.getParameter("securityAnswer");
        String role = "4"; // Fixed role for Client

        System.out.println("🔎 Received data: " + username + ", " + email + ", " + phoneNumber);

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

        String salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(password, salt);

        boolean success = registerUser(username, email, phoneNumber, hashedPassword, salt, role, securityQuestion, securityAnswer);

        if (success) {
            System.out.println("✅ Client inserted successfully.");
            response.sendRedirect("ManageUsersServlet?status=added");
        } else {
            System.out.println("❌ Client insertion failed.");
            returnWithError("❌ Failed to add client. Please check server logs.", request, response);
        }
    }

    private boolean isUserExists(String username, String email) {
        String query = "SELECT 1 FROM users WHERE LOWER(username) = LOWER(?) OR LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            boolean exists = rs.next();
            System.out.println("🔁 User exists? " + exists);
            return exists;
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    private boolean registerUser(String username, String email, String phoneNumber, String hashedPassword, String salt, String role, String securityQuestion, String securityAnswer) {
        String insertQuery = "INSERT INTO users (username, email, phoneNumber, password, salt, roleID, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(insertQuery)) {
            System.out.println("📥 Inserting user: " + username);

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phoneNumber);
            ps.setString(4, hashedPassword);
            ps.setString(5, salt);
            ps.setInt(6, Integer.parseInt(role));
            ps.setString(7, securityQuestion);
            ps.setString(8, securityAnswer);

            boolean inserted = ps.executeUpdate() > 0;
            System.out.println("✅ Insert success? " + inserted);
            return inserted;
        } catch (SQLException | NumberFormatException e) {
            System.out.println("⚠️ Insert failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

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
