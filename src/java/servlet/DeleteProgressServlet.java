/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskProgressDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.TaskProgress;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteProgressServlet")
public class DeleteProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fileName = request.getParameter("fileName");
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            int projectID = Integer.parseInt(request.getParameter("projectID"));
            int userID = (Integer) request.getSession().getAttribute("userID");

            if (fileName == null || fileName.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing fileName");
                return;
            }

            TaskProgressDAO dao = new TaskProgressDAO();
            boolean deletedFromDB = dao.deleteProgressByFileName(fileName);

            if (deletedFromDB) {
                String appPath = request.getServletContext().getRealPath("");
                File file = new File(appPath + File.separator + UPLOAD_DIR + File.separator + fileName);

                if (file.exists()) {
                    file.delete();
                }

                // 🔔 Send notification
                UserDAO userDAO = new UserDAO();
                NotificationDAO notifDAO = new NotificationDAO();
                List<User> relatedUsers = userDAO.getUsersRelatedToProject(projectID, userID);
                String message = "A task progress was deleted for Task ID: " + taskID + ".";

                for (User u : relatedUsers) {
                    notifDAO.addNotification(u.getUserID(), message);
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Deleted");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Failed to delete progress by fileName");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal error");
        }
    }
}
