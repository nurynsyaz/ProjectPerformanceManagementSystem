/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskDAO;
import dao.TaskProgressDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.TaskProgress;
import model.User;

import java.io.*;
import java.nio.file.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditProgressServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024)
public class EditProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int progressID = Integer.parseInt(request.getParameter("progressID"));
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            String progressNotes = request.getParameter("progressNotes");
            String statusIDStr = request.getParameter("statusID");

            HttpSession session = request.getSession();
            Integer userID = (Integer) session.getAttribute("userID");

            Part filePart = request.getPart("progressFile");
            String newFileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                newFileName = taskID + "_" + System.currentTimeMillis() + "_" + originalFileName;

                String appPath = request.getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String savedPath = uploadPath + File.separator + newFileName;
                filePart.write(savedPath);
            }

            TaskProgressDAO dao = new TaskProgressDAO();
            TaskProgress progress = dao.getProgressByID(progressID);

            if (progress == null || progress.getUserID() != userID.intValue()) {
                response.sendRedirect("viewTasks.jsp?status=unauthorized");
                return;
            }

            if (progressNotes != null) {
                progress.setNotes(progressNotes);
            }
            if (newFileName != null) {
                progress.setFileName(newFileName);
            }

            boolean updatedProgress = dao.updateProgress(progress);

            boolean updatedStatus = false;
            if (statusIDStr != null && !statusIDStr.isEmpty()) {
                int statusID = Integer.parseInt(statusIDStr);
                TaskDAO taskDAO = new TaskDAO();
                updatedStatus = taskDAO.updateTaskStatus(taskID, statusID);
            }

            if (updatedProgress || updatedStatus) {
                // 🔔 Send notification
                UserDAO userDAO = new UserDAO();
                NotificationDAO notifDAO = new NotificationDAO();
                List<User> relatedUsers = userDAO.getUsersRelatedToProject(progress.getProjectID(), userID);
                String message = "A task progress was updated for Task ID: " + taskID + ".";

                for (User u : relatedUsers) {
                    notifDAO.addNotification(u.getUserID(), message);
                }

                response.getWriter().write("success");
            } else {
                response.getWriter().write("error: update failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
}
