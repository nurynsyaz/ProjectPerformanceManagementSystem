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
import java.net.URLEncoder;

@WebServlet("/ResetPasswordHandlerServlet")
public class ResetPasswordHandlerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "❌ Passwords do not match.");
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
                return;
            }

            String salt = PasswordUtils.generateSalt();
            String hashedPassword = PasswordUtils.hashPassword(newPassword, salt);

            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updatePasswordByPhone(phone, hashedPassword, salt);

            if (success) {
                response.sendRedirect("login.jsp?message=" + URLEncoder.encode("Password reset successful!", "UTF-8"));
            } else {
                request.setAttribute("error", "❌ Failed to reset password.");
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ An unexpected error occurred.");
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        }
    }
}
