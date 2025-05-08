/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.NotificationDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Notification;

/**
 *
 * @author nurin
 */
@WebServlet("/ReadNotificationHistoryServlet")
public class ReadNotificationHistoryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userID = (int) session.getAttribute("userID");
        NotificationDAO dao = new NotificationDAO();
        List<Notification> readNotifications = dao.getReadNotificationsByUserID(userID);
        request.setAttribute("readNotifications", readNotifications);
        request.getRequestDispatcher("readNotifications.jsp").forward(request, response);
    }
}

    

