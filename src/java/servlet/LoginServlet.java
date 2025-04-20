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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pass.PasswordUtils;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        boolean remember = request.getParameter("remember") != null;

        System.out.println("LoginServlet: Starting login process...");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password); // Debug: Log the password (remove in production)
        System.out.println("Role: " + role);
        System.out.println("Remember Me: " + remember);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("LoginServlet: Failed to establish database connection!");
                request.setAttribute("errorMessage", "Database connection failed. Please try again later.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            } else {
                System.out.println("LoginServlet: Database connection established successfully.");
            }

            // Fetch stored hashed password and salt
            String sql = "SELECT userID, password, salt, roleID FROM users WHERE username = ? AND roleID = ?";
            System.out.println("LoginServlet: Executing query: " + sql);
            System.out.println("LoginServlet: Parameters: username=" + username + ", roleID=" + role);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, role);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");
                String storedSalt = rs.getString("salt");
                System.out.println("LoginServlet: Stored Hashed Password: " + storedHashedPassword);
                System.out.println("LoginServlet: Stored Salt: " + storedSalt);

                // Verify password using PasswordUtils
                String hashedEnteredPassword = PasswordUtils.hashPassword(password, storedSalt);
                System.out.println("LoginServlet: Entered Password Hash: " + hashedEnteredPassword);
                System.out.println("LoginServlet: Stored Password Hash: " + storedHashedPassword);

                if (PasswordUtils.verifyPassword(password, storedHashedPassword, storedSalt)) {
                    System.out.println("LoginServlet: Password verified successfully.");

                    int userID = rs.getInt("userID");
                    int roleID = rs.getInt("roleID");

                    HttpSession session = request.getSession();
                    session.setAttribute("userID", userID);
                    session.setAttribute("role", role);         // for role as string
                    session.setAttribute("roleID", roleID);     // ✅ needed by addProjectServlet
                    session.setAttribute("username", username);

                    if (remember) {
                        session.setMaxInactiveInterval(7 * 24 * 60 * 60);
                    }

                    System.out.println("LoginServlet: Session created for userID: " + userID + ", roleID: " + roleID);

                    switch (role) {
                        case "1":
                            response.sendRedirect("hmdashboard.jsp");
                            break;
                        case "2":
                            response.sendRedirect("pmdashboard.jsp");
                            break;
                        case "3":
                            response.sendRedirect("tmdashboard.jsp");
                            break;
                        case "4":
                            response.sendRedirect("clientdashboard.jsp");
                            break;
                        default:
                            response.sendRedirect("login.jsp");
                            break;
                    }
                    return;
                } else {
                    System.out.println("LoginServlet: Password verification failed.");
                }
            } else {
                System.out.println("LoginServlet: No user found with the given username and role.");
            }

            // If login fails
            request.setAttribute("errorMessage", "Invalid username, password, or role!");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("LoginServlet: Exception occurred - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }
}
