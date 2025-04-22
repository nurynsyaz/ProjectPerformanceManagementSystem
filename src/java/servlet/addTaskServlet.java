/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import db.DBConnection;

@WebServlet("/addTaskServlet")
public class addTaskServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer roleID = (Integer) session.getAttribute("roleID");
        if (roleID == null || roleID != 2) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        int projectID = Integer.parseInt(request.getParameter("projectID"));
        String taskName = request.getParameter("taskName");
        String taskDetails = request.getParameter("taskDetails");
        String taskStartDateStr = request.getParameter("taskStartDate");
        String taskEndDateStr = request.getParameter("taskEndDate");
        int statusID = Integer.parseInt(request.getParameter("statusID"));

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = null;
        Date endDate = null;

        try {
            startDate = sdf.parse(taskStartDateStr);
            endDate = sdf.parse(taskEndDateStr);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addTask.jsp?projectID=" + projectID + "&status=error");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO tasks (projectID, taskName, taskDetails, taskStartDate, taskEndDate, statusID) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, projectID);
                ps.setString(2, taskName);
                ps.setString(3, taskDetails);
                ps.setDate(4, new java.sql.Date(startDate.getTime()));
                ps.setDate(5, new java.sql.Date(endDate.getTime()));
                ps.setInt(6, statusID);

                int result = ps.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("ViewTasksServlet?projectID=" + projectID + "&status=added");
                } else {
                    response.sendRedirect("addTask.jsp?projectID=" + projectID + "&status=error");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addTask.jsp?projectID=" + projectID + "&status=error");
        }
    }
}