/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.NotificationDAO;
import model.Notification;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/FetchNotificationsServlet")
public class FetchNotificationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // ✅ Step 1: Check session and get userID
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userID") == null) {
            System.out.println("❌ [FetchNotificationsServlet] No session or userID found.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer userID = (Integer) session.getAttribute("userID");
        System.out.println("🔍 [FetchNotificationsServlet] Session userID: " + userID);

        // ✅ Step 2: Fetch notifications for this user
        NotificationDAO dao = new NotificationDAO();
        List<Notification> notifications = dao.getUnreadNotificationsByUserID(userID);

        System.out.println("✅ [FetchNotificationsServlet] Notifications fetched: " + notifications.size());

        // ✅ Step 3: Return JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
        gson.toJson(notifications, response.getWriter());

    }
}
