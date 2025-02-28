/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ADMIN
 */
import java.util.Date;

public class Notification {

    private int NotificationId;
    private int UserId;
    private String NotificationContent;
    private Date NotificationCreateAt;

    public Notification() {
    }

    public Notification(int NotificationId, int UserId, String NotificationContent, Date NotificationCreateAt) {
        this.NotificationId = NotificationId;
        this.UserId = UserId;
        this.NotificationContent = NotificationContent;
        this.NotificationCreateAt = NotificationCreateAt;
    }

    public int getNotificationId() {
        return NotificationId;
    }

    public void setNotificationId(int NotificationId) {
        this.NotificationId = NotificationId;
    }

    public int getUserId() {
        return UserId;
    }

    public void setUserId(int UserId) {
        this.UserId = UserId;
    }

    public String getNotificationContent() {
        return NotificationContent;
    }

    public void setNotificationContent(String NotificationContent) {
        this.NotificationContent = NotificationContent;
    }

    public Date getNotificationCreateAt() {
        return NotificationCreateAt;
    }

    public void setNotificationCreateAt(Date NotificationCreateAt) {
        this.NotificationCreateAt = NotificationCreateAt;
    }

    
}
