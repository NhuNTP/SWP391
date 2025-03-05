package Controller.ManageNotification;

import DAO.NotificationDAO;
import Model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewnotifications")
public class ViewNotificationController extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private static final Logger LOGGER = Logger.getLogger(ViewNotificationController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer userId = null;
            String userIdStr = request.getParameter("userId");
              if (userIdStr != null && !userIdStr.isEmpty()) {
                   userId = Integer.parseInt(userIdStr);
              }
             
            List<Notification> notificationList = notificationDAO.getAllNotificationsForUser(userId);

            if (notificationList != null) {
                request.setAttribute("notificationList", notificationList);
                request.setAttribute("userId", userId);
            } else {
                request.getSession().setAttribute("errorMessage", "Error retrieving notifications. See server logs.");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid User ID.");
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("ManageNotification/viewnotifications.jsp");
        dispatcher.forward(request, response);
    }
}