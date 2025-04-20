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
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/ViewCommentsServlet")
public class ViewCommentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int taskID = Integer.parseInt(request.getParameter("taskID"));
        response.setContentType("text/html;charset=UTF-8");

        String sql = "SELECT c.commentID, c.taskID, c.userID, c.commentText, c.createdAt, u.username "
                + "FROM task_comments c JOIN users u ON c.userID = u.userID "
                + "WHERE c.taskID = ? ORDER BY c.createdAt DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  PrintWriter out = response.getWriter()) {

            stmt.setInt(1, taskID);
            ResultSet rs = stmt.executeQuery();

            HttpSession session = request.getSession(false);
            int currentUserID = (int) session.getAttribute("userID");
            int currentRoleID = (int) session.getAttribute("roleID");

            boolean hasComments = false;

            out.println("<div class='table-responsive'>");
            out.println("<table class='table table-bordered table-striped text-center align-middle'>");
            out.println("<thead class='table-light'><tr>");
            out.println("<th>Username</th><th>Comment</th><th>Posted At</th><th>Action</th>");
            out.println("</tr></thead><tbody>");

            while (rs.next()) {
                hasComments = true;
                int commentID = rs.getInt("commentID");
                int userID = rs.getInt("userID");
                String username = rs.getString("username");
                String commentText = rs.getString("commentText").replace("\"", "&quot;");
                Timestamp createdAt = rs.getTimestamp("createdAt");

                boolean isOwner = (currentRoleID == 4 && currentUserID == userID);

                out.println("<tr>");
                out.println("<td>" + username + "</td>");
                out.println("<td>" + commentText + "</td>");
                out.println("<td>" + createdAt + "</td>");

                if (isOwner) {
                    out.println("<td>");
                    out.println("<button class='btn btn-sm btn-primary btn-edit-comment' "
                            + "data-comment-id='" + commentID + "' "
                            + "data-task-id='" + taskID + "' "
                            + "data-comment-text=\"" + commentText + "\">Edit</button> ");

                    out.println("<button type='button' class='btn btn-sm btn-danger btn-delete-comment' "
                            + "data-comment-id='" + commentID + "' data-task-id='" + taskID + "'>Delete</button>");

                    out.println("</td>");
                } else {
                    out.println("<td><span class='text-muted'>-</span></td>");
                }

                out.println("</tr>");
            }

            out.println("</tbody></table></div>");

            if (!hasComments) {
                out.println("<p class='text-muted text-center'>No comments yet for this task.</p>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
