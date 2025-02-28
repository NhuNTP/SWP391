package Model;

import java.util.Date;

public class Notification {
    private int NotificationId;
    private int UserId;
    private String NotificationContent;
    private Date NotificationCreateAt;
    private String UserRole;  // New field
    private String UserName;  // New field

    public Notification() {
    }

    // Getters and setters for all fields, including UserRole and UserName

    public int getNotificationId() {
        return NotificationId;
    }

    public void setNotificationId(int notificationId) {
        NotificationId = notificationId;
    }

    public int getUserId() {
        return UserId;
    }

    public void setUserId(int userId) {
        UserId = userId;
    }

    public String getNotificationContent() {
        return NotificationContent;
    }

    public void setNotificationContent(String notificationContent) {
        NotificationContent = notificationContent;
    }

    public Date getNotificationCreateAt() {
        return NotificationCreateAt;
    }

    public void setNotificationCreateAt(Date notificationCreateAt) {
        NotificationCreateAt = notificationCreateAt;
    }

    public String getUserRole() {
        return UserRole;
    }

    public void setUserRole(String userRole) {
        UserRole = userRole;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String userName) {
        UserName = userName;
    }
}