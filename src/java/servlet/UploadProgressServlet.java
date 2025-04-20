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
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 20 * 1024 * 1024)   // 20MB
public class UploadProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int taskID = Integer.parseInt(request.getParameter("taskID"));
        int projectID = Integer.parseInt(request.getParameter("projectID"));
        String progressNotes = request.getParameter("progressNotes");

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");

        Part filePart = request.getPart("progressFile");

        if (filePart == null || filePart.getSize() == 0 || userID == null) {
            response.sendRedirect("viewTasks.jsp?status=error");
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileName = taskID + "_" + System.currentTimeMillis() + "_" + originalFileName; // to avoid overwrite
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String savedPath = uploadPath + File.separator + fileName;
        filePart.write(savedPath);

        // Save to DB
        TaskProgress progress = new TaskProgress();
        progress.setTaskID(taskID);
        progress.setUserID(userID);
        progress.setFileName(fileName);
        progress.setNotes(progressNotes);

        TaskProgressDAO progressDAO = new TaskProgressDAO();
        boolean saved = progressDAO.addProgress(progress);

        if (saved) {
            response.sendRedirect("viewTasks.jsp?status=uploaded");
        } else {
            response.sendRedirect("viewTasks.jsp?status=error");
        }
    }
}
