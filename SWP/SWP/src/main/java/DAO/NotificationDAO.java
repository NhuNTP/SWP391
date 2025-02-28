package DAO;

import Model.Notification;
import DB.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    public boolean createNotification(Integer userId, String notificationContent) {
        String sql = "INSERT INTO Notification (UserId, NotificationContent, UserRole, UserName) " +
                     "VALUES (?, ?, (SELECT UserRole FROM Account WHERE UserId = ?), (SELECT UserName FROM Account WHERE UserId = ?))";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            if (userId != null) {
                preparedStatement.setInt(1, userId);
                preparedStatement.setInt(3, userId); // For UserRole subquery
                preparedStatement.setInt(4, userId); // For UserName subquery
            } else {
                preparedStatement.setNull(1, Types.INTEGER);
                preparedStatement.setNull(3, Types.INTEGER);
                preparedStatement.setNull(4, Types.INTEGER);
            }
            preparedStatement.setString(2, notificationContent);

            int affectedRows = preparedStatement.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
            return false;
        }
    }

    public List<Notification> getAllNotificationsForUser(Integer userId) {
        List<Notification> notificationList = new ArrayList<>();
        String sql;
        PreparedStatement preparedStatement = null;
        Connection connection = null;

        try {
            connection = DBContext.getConnection();
            if (userId != null) {
                sql = "SELECT NotificationId, UserId, NotificationContent, NotificationCreateAt, UserRole, UserName " +
                      "FROM Notification " +
                      "WHERE UserId IS NULL OR UserId = ? " +
                      "ORDER BY NotificationCreateAt DESC";
                preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1, userId);
            } else {
                sql = "SELECT NotificationId, UserId, NotificationContent, NotificationCreateAt, UserRole, UserName " +
                      "FROM Notification " +
                      "WHERE UserId IS NULL " +
                      "ORDER BY NotificationCreateAt DESC";
                preparedStatement = connection.prepareStatement(sql);
            }

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    Notification notification = new Notification();
                    notification.setNotificationId(resultSet.getInt("NotificationId"));
                    notification.setUserId(resultSet.getInt("UserId"));
                    notification.setNotificationContent(resultSet.getString("NotificationContent"));
                    notification.setNotificationCreateAt(resultSet.getTimestamp("NotificationCreateAt"));
                    notification.setUserRole(resultSet.getString("UserRole")); // Retrieve UserRole
                    notification.setUserName(resultSet.getString("UserName")); // Retrieve UserName
                    notificationList.add(notification);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for user", e);
            return null;
        } finally {
            // Close resources in the reverse order of creation
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error closing PreparedStatement", e);
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error closing Connection", e);
                }
            }
        }
        return notificationList;
    }
}