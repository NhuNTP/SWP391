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
}