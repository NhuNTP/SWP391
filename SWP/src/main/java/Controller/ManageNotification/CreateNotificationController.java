package Controller.ManageNotification;

import DAO.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import DAO.AccountDAO;
import java.util.List;

@WebServlet("/createnotification")
public class CreateNotificationController extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private static final Logger LOGGER = Logger.getLogger(CreateNotificationController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("userId", request.getParameter("userId"));

        String target = request.getParameter("target");
        List<String> roles = accountDAO.getAllRoles();
         request.setAttribute("roles", roles);
        request.setAttribute("target", target);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/ManageNotification/createnotification.jsp");
        dispatcher.forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String target = request.getParameter("target"); // "all", "role", or "user"
        String notificationContent = request.getParameter("notificationContent");
        String userIdStr;
        Integer userId = null;

        boolean isCreated = false;

        try {
            switch (target) {
                case "all":
                    // Create notification for all users (UserId is null)
                    isCreated = notificationDAO.createNotification(null, notificationContent);
                    break;
                case "role":
                    // Create notification for a specific role
                    String role = request.getParameter("role");

                List<Integer> userIdsForRole = accountDAO.getUserIdsByRole(role);
                    if (userIdsForRole != null) {
                       for (Integer id : userIdsForRole) {
                            isCreated = notificationDAO.createNotification(id, notificationContent);
                       }
                    }

                    break;
                case "user":
                    // Create notification for a specific user
                    userIdStr = request.getParameter("userId");
                    if (userIdStr != null && !userIdStr.isEmpty()) {
                        try {
                            userId = Integer.parseInt(userIdStr);
                            isCreated = notificationDAO.createNotification(userId, notificationContent);
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "Invalid User ID.");
                        }
                    }
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid target audience.");
                    break;
            }

            if (isCreated) {
                request.setAttribute("message", "Notification created successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to create notification. See server logs.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
            request.setAttribute("errorMessage", "Error creating notification. See server logs.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/ManageNotification/createnotification.jsp");
        request.setAttribute("target", target);
        List<String> roles = accountDAO.getAllRoles();
         request.setAttribute("roles", roles);
        dispatcher.forward(request, response);
    }
}