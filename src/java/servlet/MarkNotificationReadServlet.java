/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.NotificationDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/MarkNotificationReadServlet")
public class MarkNotificationReadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");

        NotificationDAO dao = new NotificationDAO();

        // 🔄 Handle "mark all as read"
        if ("all".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

            if (userID == null) {
                System.err.println("❌ [MarkNotificationReadServlet] Session userID missing.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            boolean success = dao.markAllAsRead(userID);
            if (success) {
                System.out.println("✅ [MarkNotificationReadServlet] All notifications marked as read for userID: " + userID);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                System.err.println("❌ [MarkNotificationReadServlet] Failed to mark all notifications as read.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // ✅ Handle individual notification
        if (idParam == null || idParam.isEmpty()) {
            System.err.println("❌ [MarkNotificationReadServlet] Notification ID is missing.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int notificationID = Integer.parseInt(idParam);
            boolean success = dao.markAsRead(notificationID);

            if (success) {
                System.out.println("✅ [MarkNotificationReadServlet] Notification marked as read: ID = " + notificationID);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                System.err.println("❌ [MarkNotificationReadServlet] Failed to mark notification as read: ID = " + notificationID);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ [MarkNotificationReadServlet] Invalid ID format: " + idParam);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
