/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskProgressDAO;
import model.TaskProgress;

import java.io.*;
import java.nio.file.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadProgressServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10,        // 10MB
        maxFileSize = 1024L * 1024L * 1024L,         // 1GB
        maxRequestSize = 1024L * 1024L * 1024L * 2   // 2GB (in case of multiple parts)
)
public class UploadProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String taskIdStr = request.getParameter("taskID");
            String projectIdStr = request.getParameter("projectID");
            String progressNotes = request.getParameter("progressNotes");

            if (taskIdStr == null || projectIdStr == null || progressNotes == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters.");
                return;
            }

            int taskID = Integer.parseInt(taskIdStr);
            int projectID = Integer.parseInt(projectIdStr);

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userID") == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
                return;
            }

            Integer userID = (Integer) session.getAttribute("userID");
            Part filePart = request.getPart("progressFile");

            if (filePart == null || filePart.getSize() == 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File not uploaded.");
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileName = taskID + "_" + System.currentTimeMillis() + "_" + originalFileName;
            String appPath = request.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String savedPath = uploadPath + File.separator + fileName;
            filePart.write(savedPath);

            TaskProgress progress = new TaskProgress();
            progress.setTaskID(taskID);
            progress.setUserID(userID);
            progress.setFileName(fileName);
            progress.setNotes(progressNotes);

            TaskProgressDAO progressDAO = new TaskProgressDAO();
            boolean saved = progressDAO.addProgress(progress);

            if (saved) {
                response.getWriter().write("success");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database insert failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
