/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/GetProjectCompletionDataServlet")
public class GetProjectCompletionDataServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();

        String sql = "SELECT p.projectName, pc.completionPercentage FROM project_completion pc JOIN projects p ON pc.projectID = p.projectID";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                labels.add(rs.getString("projectName"));
                values.add(rs.getDouble("completionPercentage"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("labels", labels);
        jsonMap.put("values", values);

        String json = new Gson().toJson(jsonMap);
        response.getWriter().write(json);
    }
}
