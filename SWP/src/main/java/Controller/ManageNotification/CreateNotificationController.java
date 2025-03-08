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
import java.util.Date;
import java.util.List;

@WebServlet("/create-notification")
public class CreateNotificationController extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        String UserRole = account.getUserRole();

        // Chỉ Admin và Manager được truy cập
        if (!"Admin".equals(UserRole) && !"Manager".equals(UserRole)) {
            response.sendRedirect(request.getContextPath() + "/view-notifications");
            return;
        }

        // Lấy danh sách tài khoản phù hợp với quyền
        List<Account> accounts = notificationDAO.getAllAccounts();
        if ("Admin".equals(UserRole)) {
            // Admin không thể tạo thông báo cho chính mình
            accounts.removeIf(acc -> acc.getUserId().equals(account.getUserId()));
        } else if ("Manager".equals(UserRole)) {
            // Manager không thể tạo thông báo cho chính mình và Admin
            accounts.removeIf(acc -> acc.getUserId().equals(account.getUserId()) || "Admin".equals(acc.getUserRole()));
        }

        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/ManageNotification/createnotification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        String UserRole = account.getUserRole();

        if (!"Admin".equals(UserRole) && !"Manager".equals(UserRole)) {
            session.setAttribute("errorMessage", "You do not have permission to create notifications.");
            response.sendRedirect(request.getContextPath() + "/view-notifications");
            return;
        }

        String notificationType = request.getParameter("notificationType");
        String content = request.getParameter("content");
        Notification notification = new Notification();
        notification.setNotificationContent(content);
        notification.setNotificationCreateAt(new Date());
        notification.setUserId(account.getUserId()); // Người tạo thông báo

        if ("all".equals(notificationType)) {
            // Thông báo cho tất cả (trừ người tạo)
            notification.setUserRole(null);
            notification.setUserName(null);
        } else if ("role".equals(notificationType)) {
            // Thông báo theo role
            String selectedRole = request.getParameter("role");
            notification.setUserRole(selectedRole);
            notification.setUserName(null);
        } else if ("individual".equals(notificationType)) {
            // Thông báo cho từng cá nhân
            String selectedUserId = request.getParameter("UserId");
            Account selectedAccount = notificationDAO.getAllAccounts().stream()
                    .filter(a -> a.getUserId().equals(selectedUserId))
                    .findFirst().orElse(null);
            if (selectedAccount != null) {
                notification.setUserId(selectedUserId);
                notification.setUserRole(selectedAccount.getUserRole());
                notification.setUserName(selectedAccount.getUserName());
            }
        }

        // Lưu thông báo vào cơ sở dữ liệu
        notificationDAO.createNotification(notification);

        session.setAttribute("message", "Notification created successfully!");
        response.sendRedirect(request.getContextPath() + "/view-notifications");
    }
}