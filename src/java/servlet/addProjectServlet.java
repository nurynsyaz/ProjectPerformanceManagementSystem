/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import db.DBConnection;

@WebServlet("/addProjectServlet")
public class addProjectServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form data
        String projectName = request.getParameter("projectName");
        String projectDetails = request.getParameter("projectDetails");
        String startDateStr = request.getParameter("projectStartDate");
        String endDateStr = request.getParameter("projectEndDate");

        // ✅ Retrieve userID and roleID from session
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        System.out.println("userID: " + userID);
        System.out.println("roleID: " + roleID);

        // If userID or roleID is missing, redirect to login
        if (userID == null || roleID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Convert string to SQL date
        java.sql.Date startDate = null;
        java.sql.Date endDate = null;
        try {
            startDate = java.sql.Date.valueOf(startDateStr);
            endDate = java.sql.Date.valueOf(endDateStr);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid date format. Please use yyyy-MM-dd.");
            request.getRequestDispatcher("projectError.jsp").forward(request, response);
            return;
        }

        // Database connection and insertion
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "INSERT INTO projects (projectName, projectDetails, projectStartDate, projectEndDate, userID, roleID) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, projectName);
            ps.setString(2, projectDetails);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);
            ps.setInt(5, userID);
            ps.setInt(6, roleID);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("ViewProjectServlet?status=added");
            } else {
                response.sendRedirect("ViewProjectServlet?status=add_failed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("projectError.jsp").forward(request, response);
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
