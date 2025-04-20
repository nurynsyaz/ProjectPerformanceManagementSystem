/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userID); // ✅ Get the user first
        boolean deleted = userDAO.deleteUser(userID);

        if (deleted) {
            if (user != null && user.getRoleID() == 4) {
                response.sendRedirect("ManageUsersServlet?status=client_deleted");
            } else {
                response.sendRedirect("ManageUsersServlet?status=deleted");
            }
        } else {
            response.sendRedirect("ManageUsersServlet?status=delete_failed");
        }
    }
}
