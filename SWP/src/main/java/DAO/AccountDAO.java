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
    
    public ResultSet getAllAccount() {
        ResultSet rs = null;
        try {
            Statement st = conn.createStatement();
            sql = "SELECT * FROM Account";
            rs = st.executeQuery(sql);
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace(); // **THÊM DÒNG NÀY ĐỂ IN LỖI SQL CHI TIẾT RA LOG**
        }
        return rs;
    }

    public int createAccount(Account account) throws ClassNotFoundException {
        int count = 0;
        String sql = "INSERT INTO Account (UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, account.getUserEmail());
            ps.setString(2, account.getUserPassword());
            ps.setString(3, account.getUserName());
            ps.setString(4, account.getUserRole());
            ps.setString(5, account.getIdentityCard());
            ps.setString(6, account.getUserAddress());
            ps.setString(7, account.getUserImage()); // **Đảm bảo set UserImage**

            count = ps.executeUpdate(); // **Thực thi câu lệnh INSERT**
        } catch (SQLException e) {
            e.printStackTrace(); // **In lỗi SQLException trong DAO**
        }
        return count; // **Trả về count (số hàng bị ảnh hưởng)**
    }

    public Account getAccountId(int id) {
        Account obj = null;
        try {
            sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage FROM Account WHERE UserId = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Account();
                obj.setUserId(rs.getInt("UserId"));
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

    public int updateAccount(int id, Account newInfo) {
        int count = 0;
        try {
            sql = "UPDATE Account SET UserEmail=?, UserPassword=?, UserName=?, UserRole=?, IdentityCard=?, UserAddress=?, UserImage=? WHERE UserId=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getUserEmail());
            pst.setString(2, newInfo.getUserPassword()); // Nếu cần băm mật khẩu, hãy gọi hàm băm tại đây
            pst.setString(3, newInfo.getUserName());
            pst.setString(4, newInfo.getUserRole());
            pst.setString(5, newInfo.getIdentityCard());
            pst.setString(6, newInfo.getUserAddress());
            pst.setString(7, newInfo.getUserImage());
            pst.setInt(8, id);

            count = pst.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public int deleteNotificationsByUserId(int userId) { // Phương thức mới để xóa notifications
        int count = 0;
        try {
            sql = "DELETE FROM Notification WHERE UserId = ?";
            PreparedStatement pst = conn.prepareStatement(sql); // Sử dụng connection từ DBContext
            pst.setInt(1, userId);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public int deleteAccount(int id) throws ClassNotFoundException { // Phương thức Delete đã sửa đổi
        int count = 0;
        Connection conn = null; // Khai báo connection trong phương thức
        PreparedStatement pstDeleteNotifications = null; // PreparedStatements cho cả hai truy vấn
        PreparedStatement pstDeleteAccount = null;

        try {
            conn = getConnection(); // Lấy connection từ DBContext
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Bước 1: Xóa các notifications liên quan
            int notificationsDeleted = deleteNotificationsByUserId(id);
            System.out.println("Notifications deleted: " + notificationsDeleted); // Log số notifications đã xóa

            // Bước 2: Xóa tài khoản
            sql = "DELETE FROM Account WHERE UserId=?";
            pstDeleteAccount = conn.prepareStatement(sql);
            pstDeleteAccount.setInt(1, id);
            count = pstDeleteAccount.executeUpdate();

            conn.commit(); // Commit transaction nếu cả hai bước thành công

        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction nếu có lỗi
                    System.err.println("Transaction rolled back due to error."); // Log rollback
                } catch (SQLException rollbackEx) {
                    Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, rollbackEx);
                }
            }
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
            count = 0; // Đảm bảo count = 0 khi có lỗi
        }
        return count;
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