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

@WebServlet("/EditProgressServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 20 * 1024 * 1024) // 20MB
public class EditProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int progressID = Integer.parseInt(request.getParameter("progressID"));
        int taskID = Integer.parseInt(request.getParameter("taskID"));
        String progressNotes = request.getParameter("progressNotes");

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

        // Security: ensure only uploader can edit
       if (progress == null || progress.getUserID() != userID.intValue()) {
            response.sendRedirect("viewTasks.jsp?status=unauthorized");
            return;
        }

        // Update fields
        if (progressNotes != null) {
            progress.setNotes(progressNotes);
        }
        if (newFileName != null) {
            progress.setFileName(newFileName);
        }

        boolean updated = dao.updateProgress(progress);
        if (updated) {
            response.sendRedirect("viewTasks.jsp?status=updated");
        } else {
            response.sendRedirect("viewTasks.jsp?status=error");
        }
    }
}
