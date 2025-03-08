package Controller.ManageNotification;

import DAO.NotificationDAO;
import Model.Account;
import Model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-notifications")
public class ViewNotificationController extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        // Lấy đối tượng Account từ session
        Account account = (Account) session.getAttribute("account");
        String UserRole = account.getUserRole();
        String UserId = account.getUserId();

        // Lấy danh sách thông báo cho user
        List<Notification> notifications = notificationDAO.getNotificationsForUser(UserId, UserRole);
        request.setAttribute("notifications", notifications);

        // Nếu là Admin hoặc Manager, lấy danh sách user để tạo thông báo
        if ("Admin".equals(UserRole) || "Manager".equals(UserRole)) {
            List<Account> accounts = notificationDAO.getAllAccounts();
            request.setAttribute("accounts", accounts);
        }

        request.getRequestDispatcher("/ManageNotification/viewnotifications.jsp").forward(request, response);
    }

}