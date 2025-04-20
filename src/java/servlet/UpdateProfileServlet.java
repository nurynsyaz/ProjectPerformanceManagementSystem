/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import model.User;
import dao.UserDAO;

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

        int userId = loggedInUser.getUserID();
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");

        // Validate username
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            request.setAttribute("error", "Invalid username format.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Validate phone number
        if (!phoneNumber.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Validate password (if changed)
        if (!password.isEmpty() && !password.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$")) {
            request.setAttribute("error", "Password does not meet requirements.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String newPassword = password.isEmpty()
                ? loggedInUser.getPassword()
                : pass.PasswordUtils.hashPassword(password, loggedInUser.getSalt());

        User updatedUser = new User(
                userId,
                username,
                email,
                phoneNumber,
                newPassword,
                loggedInUser.getSalt(),
                loggedInUser.getRoleID()
        );

        boolean updateSuccess = userDAO.updateUser(updatedUser);

        if (updateSuccess) {
            session.setAttribute("username", username); // update session username if changed
            response.sendRedirect("profile.jsp?success=true");
        } else {
            request.setAttribute("error", "Update failed. Try again.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
