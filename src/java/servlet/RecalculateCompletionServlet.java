/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ProjectCompletionDAO;
import db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RecalculateCompletionServlet")
public class RecalculateCompletionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection(); 
             Statement stmt = conn.createStatement(); 
             ResultSet rs = stmt.executeQuery("SELECT DISTINCT projectID FROM tasks")) {

            ProjectCompletionDAO dao = new ProjectCompletionDAO();
            while (rs.next()) {
                int projectID = rs.getInt("projectID");
                dao.updateProjectCompletion(projectID);
            }
            response.getWriter().println("Completion percentages updated.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
