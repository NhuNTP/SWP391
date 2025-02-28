/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author LxP
 */
import Model.Account;
import DB.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccountDAO {
    public Account login(String username, String password) {
        String query = "SELECT * FROM Account WHERE UserName = ? AND UserPassword = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                        rs.getInt("UserId"),
                        rs.getString("UserEmail"),
                        rs.getString("UserPassword"),
                        rs.getString("UserName"),
                        rs.getString("UserRole"),
                        rs.getString("IdentityCard"),
                        rs.getString("UserAddress"),
                        rs.getString("UserImage")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    
    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    public List<String> getAllRoles() {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT DISTINCT UserRole FROM Account"; // Adjust table and column names as needed

        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                roles.add(resultSet.getString("UserRole")); // Adjust column name as needed
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all roles", e);
            return null;
        }
        return roles;
    }

    public List<Integer> getUserIdsByRole(String role) {
        List<Integer> userIds = new ArrayList<>();
        String sql = "SELECT UserId FROM Account WHERE UserRole = ?"; // Adjust table and column names as needed

        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, role);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    userIds.add(resultSet.getInt("UserId")); // Adjust column name as needed
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting user IDs by role", e);
            return null;
        }
        return userIds;
    }
}