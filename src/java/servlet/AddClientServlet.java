/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.UserDAO;
import model.User;
import pass.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddClientServlet") // ✅ updated URL mapping
public class AddClientServlet extends HttpServlet { // ✅ updated class name
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        int roleID = Integer.parseInt(request.getParameter("roleID")); // should always be 4 (Client)

        String salt = PasswordUtils.generateSalt();
        String hashedPassword = PasswordUtils.hashPassword(password, salt);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setPassword(hashedPassword);
        user.setSalt(salt);
        user.setRoleID(roleID);

        UserDAO dao = new UserDAO();
        boolean success = dao.addUser(user);

        if (success) {
            response.sendRedirect("ManageUsersServlet?status=added");
        } else {
            response.sendRedirect("ManageUsersServlet?status=add_failed");
        }
    }
}
