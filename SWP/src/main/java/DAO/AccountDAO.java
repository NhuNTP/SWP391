package DAO;

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

    private Connection conn;
    private String sql;
    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    public AccountDAO() throws ClassNotFoundException, SQLException {
        conn = DBContext.getConnection();
    }

    public Account login(String username, String password) throws ClassNotFoundException, SQLException {
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage, UserPhone, IsDeleted "
                + "FROM Account WHERE UserName = ? AND UserPassword = ? AND IsDeleted = 0";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Account account = new Account();
                account.setUserId(rs.getString("UserId"));
                account.setUserEmail(rs.getString("UserEmail"));
                account.setUserPassword(rs.getString("UserPassword"));
                account.setUserName(rs.getString("UserName"));
                account.setUserRole(rs.getString("UserRole"));
                account.setIdentityCard(rs.getString("IdentityCard"));
                account.setUserAddress(rs.getString("UserAddress"));
                account.setUserImage(rs.getString("UserImage"));
                account.setUserPhone(rs.getString("UserPhone"));
                account.setIsDeleted(rs.getBoolean("IsDeleted"));
                LOGGER.info("Login successful for user: " + username);
                return account;
            } else {
                LOGGER.info("Login failed for user: " + username + " - Account not found or deleted.");
                return null;
            }
        }
    }


    public List<Account> getAllAccount() throws SQLException, ClassNotFoundException {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserPhone, UserImage "
                + "FROM Account WHERE IsDeleted = 0";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Account account = new Account();
                account.setUserId(rs.getString("UserId"));
                account.setUserEmail(rs.getString("UserEmail"));
                account.setUserPassword(rs.getString("UserPassword"));
                account.setUserName(rs.getString("UserName"));
                account.setUserRole(rs.getString("UserRole"));
                account.setIdentityCard(rs.getString("IdentityCard"));
                account.setUserAddress(rs.getString("UserAddress"));
                account.setUserPhone(rs.getString("UserPhone"));
                account.setUserImage(rs.getString("UserImage"));
                accounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching all accounts with full details", ex);
            throw ex;
        }
        return accounts;
    }

    public Account getAccountById(String id, boolean fullDetails) throws SQLException, ClassNotFoundException {
        Account obj = null;
        String sql = fullDetails
                ? "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, UserPhone, IdentityCard, UserAddress, UserImage FROM Account WHERE UserId = ?"
                : "SELECT UserId, UserRole, UserEmail, UserName, UserPhone FROM Account WHERE UserId = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Account();
                obj.setUserId(rs.getString("UserId"));
                obj.setUserPhone(rs.getString("UserPhone"));
                if (fullDetails) {
                    obj.setUserEmail(rs.getString("UserEmail"));
                    obj.setUserPassword(rs.getString("UserPassword"));
                    obj.setUserName(rs.getString("UserName"));
                    obj.setIdentityCard(rs.getString("IdentityCard"));
                    obj.setUserAddress(rs.getString("UserAddress"));
                    obj.setUserImage(rs.getString("UserImage"));
                }
                obj.setUserRole(rs.getString("UserRole"));
            }
        }
        return obj;
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
                return "EM";
        }
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

    private boolean isUserIdExists(String userId) throws SQLException, ClassNotFoundException {
        String sqlCheckId = "SELECT UserId FROM Account WHERE UserId = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlCheckId)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public boolean isEmailExists(String email, String userIdToExclude) throws SQLException, ClassNotFoundException {
        String sqlCheckEmail = "SELECT UserEmail FROM Account WHERE UserEmail = ? AND IsDeleted = 0"
                + (userIdToExclude != null ? " AND UserId <> ?" : "");
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlCheckEmail)) {
            ps.setString(1, email);
            if (userIdToExclude != null) {
                ps.setString(2, userIdToExclude);
            }
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public boolean isIdentityCardExists(String identityCard, String userIdToExclude) throws SQLException, ClassNotFoundException {
        String sqlCheckIdCard = "SELECT IdentityCard FROM Account WHERE IdentityCard = ? AND IsDeleted = 0"
                + (userIdToExclude != null ? " AND UserId <> ?" : "");
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlCheckIdCard)) {
            ps.setString(1, identityCard);
            if (userIdToExclude != null) {
                ps.setString(2, userIdToExclude);
            }
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // Cập nhật phương thức createAccount
    public int createAccount(Account account) throws ClassNotFoundException, SQLException {
        int count = 0;
        if (isEmailExists(account.getUserEmail(), null)) {
            LOGGER.warning("createAccount - Email already exists: " + account.getUserEmail());
            return -1;
        }
        if (account.getIdentityCard() != null && !account.getIdentityCard().isEmpty() && isIdentityCardExists(account.getIdentityCard(), null)) {
            LOGGER.warning("createAccount - IdentityCard already exists: " + account.getIdentityCard());
            return -2;
        }

        String sql = "INSERT INTO Account (UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage, UserPhone, IsDeleted) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String userId = generateUniqueUserId(account.getUserRole());
            account.setUserId(userId);

            ps.setString(1, userId);
            ps.setString(2, account.getUserEmail());
            ps.setString(3, account.getUserPassword());
            ps.setString(4, account.getUserName());
            ps.setString(5, account.getUserRole());
            ps.setString(6, account.getIdentityCard());
            ps.setString(7, account.getUserAddress());
            ps.setString(8, account.getUserImage());
             ps.setString(9, account.getUserPhone());
            ps.setBoolean(10, false);

            count = ps.executeUpdate();
            LOGGER.info("createAccount - Account created: " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "createAccount - SQLException: ", e);
            throw e;
        }
        return count;
    }

    // Cập nhật phương thức updateAccount
    public int updateAccount(String oldId, Account newInfo) throws SQLException, ClassNotFoundException {
        int count = 0;
        Connection con = null;
        PreparedStatement pstAccount = null;

        try {
            con = DBContext.getConnection();
            con.setAutoCommit(false);

            Account existingAccount = getAccountById(oldId, false); // Chỉ lấy thông tin cơ bản

            if (!existingAccount.getUserRole().equals(newInfo.getUserRole())) {
                String newUserId = generateUniqueUserId(newInfo.getUserRole());
                newInfo.setUserId(newUserId);
            } else {
                newInfo.setUserId(oldId);
            }

            if (!newInfo.getUserEmail().equals(existingAccount.getUserEmail()) && isEmailExists(newInfo.getUserEmail(), oldId)) {
                LOGGER.warning("updateAccount - Email already exists: " + newInfo.getUserEmail());
                return -1;
            }

            if (newInfo.getIdentityCard() != null && !newInfo.getIdentityCard().isEmpty()
                    && !newInfo.getIdentityCard().equals(existingAccount.getIdentityCard())
                    && isIdentityCardExists(newInfo.getIdentityCard(), oldId)) {
                LOGGER.warning("updateAccount - IdentityCard already exists: " + newInfo.getIdentityCard());
                return -2;
            }

            sql = "UPDATE Account SET UserId=?, UserEmail=?, UserPassword=?, UserName=?, UserRole=?, IdentityCard=?, UserAddress=?, UserImage=?, UserPhone=?, IsDeleted=? WHERE UserId=?";
            pstAccount = con.prepareStatement(sql);
            pstAccount.setString(1, newInfo.getUserId());
            pstAccount.setString(2, newInfo.getUserEmail());
            pstAccount.setString(3, newInfo.getUserPassword());
            pstAccount.setString(4, newInfo.getUserName());
            pstAccount.setString(5, newInfo.getUserRole());
            pstAccount.setString(6, newInfo.getIdentityCard());
            pstAccount.setString(7, newInfo.getUserAddress());
            pstAccount.setString(8, newInfo.getUserImage());
            pstAccount.setString(9, newInfo.getUserPhone());
            pstAccount.setBoolean(10, newInfo.isIsDeleted());
            pstAccount.setString(11, oldId);

            count = pstAccount.executeUpdate();
            con.commit();
            LOGGER.info("updateAccount - Account updated successfully, affected rows: " + count);
        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            LOGGER.log(Level.SEVERE, "updateAccount - SQLException: ", ex);
            throw ex;
        } finally {
            if (pstAccount != null) {
                pstAccount.close();
            }
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return count;
    }

    public int deleteAccount(String id) {
        int count = 0;
        try {
            sql = "UPDATE Account SET IsDeleted = 1 WHERE UserId = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting account", ex);
        }
        return count;
    }

    public List<String> getAllRoles() {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT DISTINCT UserRole FROM Account";
        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(rs.getString("UserRole"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all roles", e);
            return null;
        }
        return roles;
    }

    public List<String> getUserIdsByRole(String role) {
        List<String> userIds = new ArrayList<>();
        String sql = "SELECT UserId FROM Account WHERE UserRole = ?";
        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    userIds.add(rs.getString("UserId"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting user IDs by role", e);
            return null;
        }
        return userIds;
    }
}