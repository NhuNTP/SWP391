package DAO;

import DB.DBContext;
import Model.Notification;
import Model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationDAO {

    // Khai báo Logger
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    
    // Phương thức tạo thông báo
    public void createNotification(Notification notification) {
        String sql = "INSERT INTO Notification (UserId, NotificationContent, NotificationCreateAt, UserRole, UserName) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, notification.getUserId());
            pstmt.setString(2, notification.getNotificationContent());
            pstmt.setTimestamp(3, new Timestamp(notification.getNotificationCreateAt().getTime()));
            pstmt.setString(4, notification.getUserRole());
            pstmt.setString(5, notification.getUserName());
            pstmt.executeUpdate();
            LOGGER.info("Notification created successfully: " + notification.getNotificationContent());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Phương thức lấy tất cả thông báo
    public List<Notification> getAllNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("NotificationId"));
                notification.setUserId(rs.getString("UserId"));
                notification.setNotificationContent(rs.getString("NotificationContent"));
                notification.setNotificationCreateAt(rs.getTimestamp("NotificationCreateAt"));
                notification.setUserRole(rs.getString("UserRole"));
                notification.setUserName(rs.getString("UserName"));
                notifications.add(notification);
            }
            LOGGER.info("Retrieved all notifications: " + notifications.size() + " notifications found.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all notifications", e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return notifications;
    }

    // Phương thức lấy thông báo cho một người dùng cụ thể
    public List<Notification> getNotificationsForUser(String userId, String userRole) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE (UserId = ? OR UserRole = ? OR (UserRole IS NULL AND UserId IS NULL)) AND UserId != ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userRole);
            pstmt.setString(3, userId); // Loại bỏ thông báo mà người dùng tự tạo
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("NotificationId"));
                notification.setUserId(rs.getString("UserId"));
                notification.setNotificationContent(rs.getString("NotificationContent"));
                notification.setNotificationCreateAt(rs.getTimestamp("NotificationCreateAt"));
                notification.setUserRole(rs.getString("UserRole"));
                notification.setUserName(rs.getString("UserName"));
                notifications.add(notification);
            }
            LOGGER.info("Retrieved notifications for user " + userId + ": " + notifications.size() + " notifications found.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving notifications for user " + userId, e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return notifications;
    }

    // Phương thức lấy thông báo theo role
    public List<Notification> getNotificationsByRole(String userRole) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserRole = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userRole);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("NotificationId"));
                notification.setUserId(rs.getString("UserId"));
                notification.setNotificationContent(rs.getString("NotificationContent"));
                notification.setNotificationCreateAt(rs.getTimestamp("NotificationCreateAt"));
                notification.setUserRole(rs.getString("UserRole"));
                notification.setUserName(rs.getString("UserName"));
                notifications.add(notification);
            }
            LOGGER.info("Retrieved notifications for role " + userRole + ": " + notifications.size() + " notifications found.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving notifications for role " + userRole, e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return notifications;
    }

    // Phương thức lấy thông báo cho một người dùng cụ thể (theo UserId)
    public List<Notification> getNotificationsByUserId(String userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("NotificationId"));
                notification.setUserId(rs.getString("UserId"));
                notification.setNotificationContent(rs.getString("NotificationContent"));
                notification.setNotificationCreateAt(rs.getTimestamp("NotificationCreateAt"));
                notification.setUserRole(rs.getString("UserRole"));
                notification.setUserName(rs.getString("UserName"));
                notifications.add(notification);
            }
            LOGGER.info("Retrieved notifications for user ID " + userId + ": " + notifications.size() + " notifications found.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving notifications for user ID " + userId, e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return notifications;
    }

    // Phương thức lấy tất cả tài khoản
    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Account account = new Account();
                account.setUserId(rs.getString("UserId"));
                account.setUserName(rs.getString("UserName"));
                account.setUserRole(rs.getString("UserRole"));
                accounts.add(account);
            }
            LOGGER.info("Retrieved all accounts: " + accounts.size() + " accounts found.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all accounts", e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return accounts;
    }

    // Phương thức xóa thông báo
    public void deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notification WHERE NotificationId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, notificationId);
            pstmt.executeUpdate();
            LOGGER.info("Notification deleted successfully: ID " + notificationId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting notification with ID " + notificationId, e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Phương thức cập nhật thông báo
    public void updateNotification(Notification notification) {
        String sql = "UPDATE Notification SET NotificationContent = ?, UserRole = ?, UserName = ? WHERE NotificationId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, notification.getNotificationContent());
            pstmt.setString(2, notification.getUserRole());
            pstmt.setString(3, notification.getUserName());
            pstmt.setInt(4, notification.getNotificationId());
            pstmt.executeUpdate();
            LOGGER.info("Notification updated successfully: ID " + notification.getNotificationId());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating notification with ID " + notification.getNotificationId(), e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}