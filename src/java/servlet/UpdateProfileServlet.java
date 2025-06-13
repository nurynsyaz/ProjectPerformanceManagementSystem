/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import model.User;
import dao.UserDAO;
import pass.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usernameInSession = (String) session.getAttribute("username");

        if (usernameInSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User loggedInUser = userDAO.getUserByUsername(usernameInSession);
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer = request.getParameter("securityAnswer");

        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            request.setAttribute("error", "Invalid username format.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        if (!phoneNumber.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        boolean updatePassword = password != null && !password.trim().isEmpty();

        if (updatePassword && !password.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$")) {
            request.setAttribute("error", "Password does not meet security requirements.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String newPassword = updatePassword
                ? PasswordUtils.hashPassword(password, loggedInUser.getSalt())
                : loggedInUser.getPassword();

        // ✅ Use the full constructor with security question and answer
        User updatedUser = new User(
                loggedInUser.getUserID(),
                username,
                email,
                phoneNumber,
                newPassword,
                loggedInUser.getSalt(),
                loggedInUser.getRoleID(),
                securityQuestion,
                securityAnswer
        );

        // ✅ Now this call matches the method signature
        boolean updateSuccess = userDAO.updateUser(updatedUser, updatePassword, securityQuestion, securityAnswer);

        if (updateSuccess) {
            session.setAttribute("username", username);
            response.sendRedirect("profile.jsp?success=true");
        } else {
            request.setAttribute("error", "Update failed. Please try again.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}


