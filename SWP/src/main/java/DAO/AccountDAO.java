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
import static DB.DBContext.getConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccountDAO {

    private Connection conn;
    private String sql;

    public AccountDAO() throws ClassNotFoundException, SQLException {
        conn = DBContext.getConnection();
    }

    public Account login(String username, String password) {
        String query = "SELECT * FROM Account WHERE UserName = ? AND UserPassword = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                        rs.getString("UserId"), // Use getString to match Model
                        rs.getString("UserEmail"),
                        rs.getString("UserPassword"),
                        rs.getString("UserName"),
                        rs.getString("UserRole"),
                        rs.getString("IdentityCard"),
                        rs.getString("UserAddress"),
                        rs.getString("UserImage"),
                        rs.getBoolean("IsDeleted") // Retrieve IsDeleted
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ResultSet getAllAccount() {
        ResultSet rs = null;
        try {
            Statement st = conn.createStatement();
            sql = "SELECT * FROM Account where IsDeleted = 0";
            rs = st.executeQuery(sql);
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace(); // **THÊM DÒNG NÀY ĐỂ IN LỖI SQL CHI TIẾT RA LOG**
        }
        return rs;
    }

    public int createAccount(Account account) throws ClassNotFoundException {
        int count = 0;
        String sql = "INSERT INTO Account (UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage, IsDeleted) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"; // Include UserId in INSERT
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            String userId = generateUniqueUserId(account.getUserRole()); // Generate Unique UserId based on role
            account.setUserId(userId); // Set the generated UserId back to account object

            ps.setString(1, account.getUserId()); // Set UserId as String
            ps.setString(2, account.getUserEmail());
            ps.setString(3, account.getUserPassword());
            ps.setString(4, account.getUserName());
            ps.setString(5, account.getUserRole());
            ps.setString(6, account.getIdentityCard());
            ps.setString(7, account.getUserAddress());
            ps.setString(8, account.getUserImage());
            ps.setBoolean(9, account.isIsDeleted()); // Set IsDeleted

            count = ps.executeUpdate(); // **Thực thi câu lệnh INSERT**
        } catch (SQLException e) {
            e.printStackTrace(); // **In lỗi SQLException trong DAO**
        }
        return count; // **Trả về count (số hàng bị ảnh hưởng)**
    }

    private String generateUniqueUserId(String userRole) throws SQLException, ClassNotFoundException {
        String prefix = getPrefixForRole(userRole);
        int nextNumber = 1;
        while (true) {
            String userId = prefix + String.format("%02d", nextNumber);
            if (!isUserIdExists(userId)) {
                return userId;
            }
            nextNumber++;
        }
    }

    private String getPrefixForRole(String userRole) {
        switch (userRole) {
            case "Admin":
                return "AD";
            case "Manager":
                return "MA";
            case "Waiter":
                return "WA";
            case "Cashier":
                return "CA";
            case "Kitchen staff":
                return "KS";
            default:
                return "EM"; // Default prefix for Employee or other roles if needed
        }
    }

    private boolean isUserIdExists(String userId) throws SQLException, ClassNotFoundException {
        String sqlCheckId = "SELECT UserId FROM Account WHERE UserId = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sqlCheckId)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Returns true if UserId exists
        }
    }

    public Account getAccountId(String id) { // Parameter is String now
        Account obj = null;
        try {
            sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage FROM Account WHERE UserId = ?"; // Select IsDeleted
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id); // Set parameter as String
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Account();
                obj.setUserId(rs.getString("UserId")); // Use getString
                obj.setUserEmail(rs.getString("UserEmail"));
                obj.setUserPassword(rs.getString("UserPassword"));
                obj.setUserName(rs.getString("UserName"));
                obj.setUserRole(rs.getString("UserRole"));
                obj.setIdentityCard(rs.getString("IdentityCard"));
                obj.setUserAddress(rs.getString("UserAddress"));
                obj.setUserImage(rs.getString("UserImage"));

            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return obj;
    }

    public int updateAccount(String id, Account newInfo) throws SQLException, ClassNotFoundException {
        int count = 0;
        Account existingAccount = getAccountByIdForUpdate(id); // Get existing account for role comparison
        
        if (existingAccount != null && !existingAccount.getUserRole().equals(newInfo.getUserRole())) {
            // Role has changed, need to regenerate UserId
            String newUserId;
            String newRolePrefix = getPrefixForRole(newInfo.getUserRole());
            int suffix = 1;
            while (true) {
                newUserId = newRolePrefix + String.format("%03d", suffix);
                if (!isUserIdExists(newUserId)) {
                    newInfo.setUserId(newUserId); // Set new UserId to newInfo
                    break; // Unique UserId found
                }
                suffix++;
            }
        } else {
            // Role not changed, keep the existing UserId (or if you want to allow UserId update even without role change, you can generate new userId here too based on new Role)
            newInfo.setUserId(id); // Keep the same UserId if role is not changed. Or you can comment this line if you want to regenerate even if role is same.
        }

        try {
            sql = "UPDATE Account SET UserId=?, UserEmail=?, UserPassword=?, UserName=?, UserRole=?, IdentityCard=?, UserAddress=?, UserImage=?, IsDeleted=? WHERE UserId=?"; // Include UserId in UPDATE
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getUserId()); // Set potentially new UserId
            pst.setString(2, newInfo.getUserEmail());
            pst.setString(3, newInfo.getUserPassword()); // Nếu cần băm mật khẩu, hãy gọi hàm băm tại đây
            pst.setString(4, newInfo.getUserName());
            pst.setString(5, newInfo.getUserRole());
            pst.setString(6, newInfo.getIdentityCard());
            pst.setString(7, newInfo.getUserAddress());
            pst.setString(8, newInfo.getUserImage());
            pst.setBoolean(9, newInfo.isIsDeleted()); // Set IsDeleted
            pst.setString(10, id); // Set original id for WHERE clause

            count = pst.executeUpdate();

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error update account", ex);
            throw ex; // Re-throw the exception so the caller knows update failed
        }
        return count;
    }

    private Account getAccountByIdForUpdate(String id) throws SQLException, ClassNotFoundException {
        Account obj = null;
        String sqlSelect = "SELECT UserId, UserRole FROM Account WHERE UserId = ?"; // Just need UserId and UserRole
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sqlSelect)) {
            pst.setString(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Account();
                obj.setUserId(rs.getString("UserId")); // Get UserId
                obj.setUserRole(rs.getString("UserRole")); // Get UserRole for comparison
            }
        }
        return obj;
    }

    public int deleteNotificationsByUserId(int userId) { // Keep as int if Notification uses int UserId
        int count = 0;
        try {
            // Assuming you want to soft delete notifications as well
            sql = "UPDATE Notification SET IsDeleted = 1 WHERE UserId = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, userId); // Keep as setInt if userId for Notification is int
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    // Xóa mềm tài khoản (soft delete) - Thay đổi phương thức deleteAccount
    public int deleteAccount(String id) { // Parameter id is String
        int count = 0;
        try {
            sql = "UPDATE Account SET IsDeleted = 1 WHERE UserId = ?"; // Đặt IsDeleted thành 1 thay vì xóa
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id); // Set id as String
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error delete account", ex); // Use the logger
        }
        return count;
    }

    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    public List<String> getAllRoles() {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT DISTINCT UserRole FROM Account"; // Adjust table and column names as needed

        try (Connection connection = DBContext.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql); ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                roles.add(resultSet.getString("UserRole")); // Adjust column name as needed
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all roles", e);
            return null;
        }
        return roles;
    }

    public List<String> getUserIdsByRole(String role) { // Return List<String> now
        List<String> userIds = new ArrayList<>();
        String sql = "SELECT UserId FROM Account WHERE UserRole = ?"; // Adjust table and column names as needed

        try (Connection connection = DBContext.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, role);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    userIds.add(resultSet.getString("UserId")); // Use getString and add String to list
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting user IDs by role", e);
            return null;
        }
        return userIds;
    }
}
