/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import com.google.gson.Gson;
import db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author nurin
 */
@WebServlet("/UserAssignmentChartServlet")
public class UserAssignmentChartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Integer userID = (Integer) session.getAttribute("userID");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (userID == null) {
            out.write("{\"error\": \"User not logged in\"}");
            return;
        }

        Map<String, Integer> data = new LinkedHashMap<>();
        int projectCount = 0;
        int taskCount = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Count assigned projects
            String sqlProjects = "SELECT COUNT(*) FROM project_assignment WHERE userID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlProjects)) {
                stmt.setInt(1, userID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) projectCount = rs.getInt(1);
            }

            // Count assigned tasks
            String sqlTasks = "SELECT COUNT(*) FROM task_assignment WHERE userID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlTasks)) {
                stmt.setInt(1, userID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) taskCount = rs.getInt(1);
            }

            data.put("Assigned Projects", projectCount);
            data.put("Assigned Tasks", taskCount);

            String json = new Gson().toJson(data);
            out.write(json);

        } catch (SQLException e) {
            e.printStackTrace();
            out.write("{\"error\": \"Database error\"}");
        }
    }
}
