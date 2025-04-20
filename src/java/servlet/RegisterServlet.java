/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pass.PasswordUtils;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // roleID from the form (1, 2, 3, or 4)

        // Validate input fields
        if (!isValidEmail(email)) {
            request.setAttribute("message", "Invalid email format.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (!isValidPhoneNumber(phoneNumber)) {
            request.setAttribute("message", "Phone number must be exactly 10 digits.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (!isValidPassword(password)) {
            request.setAttribute("message", "Password must meet the security criteria.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Register the user
        boolean isRegistered = registerUser(username, email, phoneNumber, password, role);

        if (isRegistered) {
            response.sendRedirect("login.jsp"); // Redirect to login page on success
        } else {
            request.setAttribute("message", "Registration failed. Username or email may already exist.");
            request.getRequestDispatcher("signup.jsp").forward(request, response); // Show error message
        }
    }

    /**
     * Registers a new user in the database.
     *
     * @param username    The username of the new user.
     * @param email       The email of the new user.
     * @param phoneNumber The phone number of the new user.
     * @param password    The password of the new user.
     * @param role        The roleID of the new user (1, 2, 3, or 4).
     * @return True if registration is successful, false otherwise.
     */
    private boolean registerUser(String username, String email, String phoneNumber, String password, String role) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("Failed to establish database connection!");
                return false;
            } else {
                System.out.println("Database connection established successfully.");
            }

            // Check if username or email already exists
            String checkQuery = "SELECT * FROM users WHERE LOWER(username) = LOWER(?) OR LOWER(email) = LOWER(?)";
            System.out.println("Executing query: " + checkQuery);
            System.out.println("Parameters: username=" + username + ", email=" + email);
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, username);
            ps.setString(2, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String existingUsername = rs.getString("username");
                String existingEmail = rs.getString("email");
                System.out.println("User already exists with username: " + existingUsername + " or email: " + existingEmail);
                return false;
            } else {
                System.out.println("No existing user found. Proceeding with registration.");
            }

            // Generate salt and hash the password
            String salt = PasswordUtils.generateSalt();
            String hashedPassword = PasswordUtils.hashPassword(password, salt);
            System.out.println("Password hashed successfully.");

            // Insert new user into the database
            String insertQuery = "INSERT INTO users (username, email, phoneNumber, password, salt, roleID) VALUES (?, ?, ?, ?, ?, ?)";
            System.out.println("Executing query: " + insertQuery);
            System.out.println("Parameters: username=" + username + ", email=" + email + ", phoneNumber=" + phoneNumber + ", roleID=" + role);
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phoneNumber);
            ps.setString(4, hashedPassword); // Store hashed password
            ps.setString(5, salt); // Store salt

            // Set roleID (convert role to integer)
            int roleID = Integer.parseInt(role); // Convert role to integer
            ps.setInt(6, roleID); // Store roleID

            int result = ps.executeUpdate();
            System.out.println("Insert result: " + result);
            return result > 0; // Return true if insertion is successful

        } catch (SQLException e) {
            System.err.println("SQL Exception: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (NumberFormatException e) {
            System.err.println("Invalid roleID format: " + e.getMessage());
            return false;
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Validates the email format.
     *
     * @param email The email to validate.
     * @return True if the email is valid, false otherwise.
     */
    private boolean isValidEmail(String email) {
        return email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
    }

    /**
     * Validates the phone number format.
     *
     * @param phoneNumber The phone number to validate.
     * @return True if the phone number is valid, false otherwise.
     */
    private boolean isValidPhoneNumber(String phoneNumber) {
        return phoneNumber.matches("^\\d{10}$");
    }

    /**
     * Validates the password format.
     *
     * @param password The password to validate.
     * @return True if the password is valid, false otherwise.
     */
    private boolean isValidPassword(String password) {
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$");
    }
}