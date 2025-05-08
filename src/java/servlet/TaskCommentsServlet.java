/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.CommentDAO;
import dao.NotificationDAO;
import dao.TaskDAO;
import dao.UserDAO;
import model.Comment;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/TaskCommentsServlet")
public class TaskCommentsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userID = (Integer) session.getAttribute("userID");
        Integer roleID = (Integer) session.getAttribute("roleID");

        if (userID == null || roleID == null || !(roleID == 1 || roleID == 2 || roleID == 3 || roleID == 4)) {
            response.sendRedirect("unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        int taskID = Integer.parseInt(request.getParameter("taskID"));
        String commentText = request.getParameter("commentText");

        CommentDAO commentDAO = new CommentDAO();

        // Get role label for notification
        String roleLabel;
        switch (roleID) {
            case 1: roleLabel = "Head Manager"; break;
            case 2: roleLabel = "Project Manager"; break;
            case 3: roleLabel = "Team Member"; break;
            case 4: roleLabel = "Client"; break;
            default: roleLabel = "User"; break;
        }

        try {
            if ("add".equals(action)) {
                Comment comment = new Comment();
                comment.setTaskID(taskID);
                comment.setUserID(userID);
                comment.setCommentText(commentText);
                commentDAO.addComment(comment);
                notifyStakeholders(taskID, userID, roleLabel + " added a new comment.");

            } else if ("edit".equals(action)) {
                int commentID = Integer.parseInt(request.getParameter("commentID"));
                Comment comment = new Comment();
                comment.setCommentID(commentID);
                comment.setUserID(userID);
                comment.setCommentText(commentText);
                commentDAO.updateComment(comment);
                notifyStakeholders(taskID, userID, roleLabel + " edited a comment.");

            } else if ("delete".equals(action)) {
                int commentID = Integer.parseInt(request.getParameter("commentID"));
                commentDAO.deleteComment(commentID, userID);
                notifyStakeholders(taskID, userID, roleLabel + " deleted a comment.");
            }

            response.sendRedirect("ViewCommentsServlet?taskID=" + taskID);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewTasks.jsp?status=comment_error");
        }
    }

    private void notifyStakeholders(int taskID, int senderUserID, String message) {
        try {
            TaskDAO taskDAO = new TaskDAO();
            int projectID = taskDAO.getProjectIDByTaskID(taskID);

            UserDAO userDAO = new UserDAO();
            NotificationDAO notifDAO = new NotificationDAO();

            List<User> relatedUsers = userDAO.getUsersRelatedToProject(projectID, senderUserID);

            for (User user : relatedUsers) {
                notifDAO.addNotification(user.getUserID(), message + " [Task ID: " + taskID + "]");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
