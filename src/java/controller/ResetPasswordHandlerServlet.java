/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;
import pass.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/ResetPasswordHandlerServlet")
public class ResetPasswordHandlerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String passwordHint = request.getParameter("passwordHint");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "❌ Passwords do not match.");
            request.getRequestDispatcher("resetPassword.jsp?phone=" + phone).forward(request, response);
            return;
        }

        String salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(newPassword, salt);

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updatePasswordAndHintByPhone(phone, hashedPassword, salt, passwordHint);

        if (success) {
            response.sendRedirect("login.jsp?message=Password reset successful!");
        } else {
            request.setAttribute("error", "❌ Failed to reset password.");
            request.getRequestDispatcher("resetPassword.jsp?phone=" + phone).forward(request, response);
        }
    }
}
