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
import dao.CommentDAO;

@WebServlet("/TaskCommentsServlet")
public class TaskCommentsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (userID == null || roleID == null || roleID != 4) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        int taskID = Integer.parseInt(request.getParameter("taskID"));
        String commentText = request.getParameter("commentText");

        dao.CommentDAO commentDAO = new dao.CommentDAO();

        try {
            if ("add".equals(action)) {
                model.Comment comment = new model.Comment();
                comment.setTaskID(taskID);
                comment.setUserID(userID);
                comment.setCommentText(commentText);
                commentDAO.addComment(comment);

            } else if ("edit".equals(action)) {
                int commentID = Integer.parseInt(request.getParameter("commentID"));
                model.Comment comment = new model.Comment();
                comment.setCommentID(commentID);
                comment.setUserID(userID);
                comment.setCommentText(commentText);
                commentDAO.updateComment(comment);

            } else if ("delete".equals(action)) {
                int commentID = Integer.parseInt(request.getParameter("commentID"));
                commentDAO.deleteComment(commentID, userID);
            }

            response.sendRedirect("ViewCommentsServlet?taskID=" + taskID);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewTasks.jsp?status=comment_error");
        }
    }
}
