/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.TaskProgressDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/DeleteProgressServlet")
public class DeleteProgressServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_progress";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fileName = request.getParameter("fileName");

            if (fileName == null || fileName.isEmpty()) {
                System.err.println("❌ Missing fileName parameter.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing fileName");
                return;
            }

            System.out.println("🔍 DeleteProgressServlet called with fileName = " + fileName);

            TaskProgressDAO dao = new TaskProgressDAO();
            boolean deletedFromDB = dao.deleteProgressByFileName(fileName);
            System.out.println("✅ Deleted from DB by fileName: " + deletedFromDB);

            if (deletedFromDB) {
                String appPath = request.getServletContext().getRealPath("");
                File file = new File(appPath + File.separator + UPLOAD_DIR + File.separator + fileName);
                System.out.println("📁 File path to delete: " + file.getAbsolutePath());

                if (file.exists()) {
                    boolean deletedFromDisk = file.delete();
                    System.out.println("🗑️ File deleted from disk: " + deletedFromDisk);
                } else {
                    System.out.println("⚠️ File not found on disk.");
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Deleted");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Failed to delete progress by fileName");
            }

        } catch (Exception e) {
            System.out.println("🚨 Exception in DeleteProgressServlet:");
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal error");
        }
    }
}
