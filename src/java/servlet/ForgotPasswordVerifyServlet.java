/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ForgotPasswordVerifyServlet")
public class ForgotPasswordVerifyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String question = request.getParameter("securityQuestion");
        String answer = request.getParameter("securityAnswer");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByPhoneAndSecurityAnswer(phone, question, answer);

        if (user != null) {
            response.sendRedirect("resetPassword.jsp?phone=" + phone);
        } else {
            request.setAttribute("error", "❌ Phone number or security answer is incorrect.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
        }
    }
}
