package DAO;

import Model.Account;
import DB.DBContext;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccountDAO {

    private Connection conn;
    private String sql;
    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    private static final String FROM_EMAIL = "tastyrestaurantg3@gmail.com"; // Thay bằng email của bạn
    private static final String PASSWORD = "xdwa hgtj frfs cnng"; // Thay bằng App Password nếu dùng Gmail

    public AccountDAO() throws ClassNotFoundException, SQLException {
        conn = DBContext.getConnection();
    }

    public String generateConfirmationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    public void sendConfirmationCodeEmail(String toEmail, String code) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác nhận đăng ký tài khoản");
            message.setText("Mã xác nhận của bạn là: " + code + "\nMã này có hiệu lực trong 3 phút.");
            Transport.send(message);
            LOGGER.info("Confirmation email sent successfully to: " + toEmail);
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send confirmation email to: " + toEmail, e);
            // Kiểm tra lỗi cụ thể từ Gmail
            String errorMessage = e.getMessage();
            if (errorMessage != null && (errorMessage.contains("Invalid Addresses") || errorMessage.contains("550"))) {
                throw new MessagingException("Invalid email address"); // Ném lỗi khi không tìm thấy địa chỉ
            } else if (errorMessage != null && (errorMessage.contains("Authentication failed") || errorMessage.contains("535"))) {
                throw new MessagingException("SMTP authentication failed");
            } else if (errorMessage != null && (errorMessage.contains("Connection refused") || errorMessage.contains("timeout"))) {
                throw new MessagingException("Unable to connect to SMTP server");
            }
            throw new MessagingException("Lỗi không xác định: " + e.getMessage());
        }
    }

    public boolean isEmailExists(String email, String excludeUserId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT UserEmail FROM Account WHERE UserEmail = ? AND (UserId != ? OR ? IS NULL)";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, excludeUserId);
            ps.setString(3, excludeUserId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
public boolean isPhoneExists(String phone, String excludeUserId) throws SQLException, ClassNotFoundException {
    String sql = "SELECT UserPhone FROM Account WHERE UserPhone = ? AND (UserId != ? OR ? IS NULL)";
    try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, phone);
        ps.setString(2, excludeUserId);
        ps.setString(3, excludeUserId);
        ResultSet rs = ps.executeQuery();
        return rs.next();
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error checking phone existence for: " + phone, e);
        throw e;
    }
}

    public boolean isIdentityCardExists(String identityCard, String excludeUserId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT IdentityCard FROM Account WHERE IdentityCard = ? AND (UserId != ? OR ? IS NULL)";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, identityCard);
            ps.setString(2, excludeUserId);
            ps.setString(3, excludeUserId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private String generateUniqueUserId(String userRole) throws SQLException, ClassNotFoundException {
        String prefix;
        switch (userRole.toLowerCase()) {
            case "admin":
                prefix = "AD";
                break;
            case "manager":
                prefix = "MG";
                break;
            case "cashier":
                prefix = "CS";
                break;
            case "waiter":
                prefix = "WT";
                break;
            case "kitchen staff":
                prefix = "KS";
                break;
            default:
                throw new IllegalArgumentException("Vai trò người dùng không hợp lệ: " + userRole);
        }

        String sql = "SELECT MAX(UserId) AS MaxId FROM Account WHERE UserId LIKE ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String maxId = rs.getString("MaxId");
                if (maxId == null) {
                    return prefix + "001";
                }
                int number = Integer.parseInt(maxId.substring(2)) + 1;
                return prefix + String.format("%03d", number);
            }
            return prefix + "001";
        }
    }

    public int createAccount(Account account, String confirmationToken) throws ClassNotFoundException, SQLException {
        if (isEmailExists(account.getUserEmail(), null)) {
            LOGGER.warning("createAccount - Email đã tồn tại: " + account.getUserEmail());
            return -1;
        }
        if (account.getIdentityCard() != null && !account.getIdentityCard().isEmpty() && isIdentityCardExists(account.getIdentityCard(), null)) {
            LOGGER.warning("createAccount - Số CCCD đã tồn tại: " + account.getIdentityCard());
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

            int count = ps.executeUpdate();
            LOGGER.info("createAccount - Tài khoản đã được tạo: " + userId);
            return count;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "createAccount - SQLException: ", e);
            throw e;
        }
    }

    public void sendAccountInfoEmail(String toEmail, String username, String password) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Thông tin tài khoản của bạn");

            String emailContent = "Chào bạn,\n\n"
                    + "Tài khoản của bạn đã được tạo thành công. Dưới đây là thông tin đăng nhập:\n"
                    + "Email: " + toEmail + "\n"
                    + "Tên đăng nhập: " + username + "\n"
                    + "Mật khẩu: " + password + "\n\n"
                    + "Vui lòng đăng nhập để sử dụng dịch vụ.\n\n"
                    + "Trân trọng,\nĐội ngũ Nhà hàng Tasty";
            message.setText(emailContent);
            Transport.send(message);
            LOGGER.info("Email thông tin tài khoản đã được gửi tới: " + toEmail);
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi gửi email thông tin tài khoản tới: " + toEmail, e);
        }
    }

    // Các phương thức khác giữ nguyên (login, getAllAccount, getAccountById, updateAccount, deleteAccount, getAllRoles, getUserIdsByRole)
    public Account login(String email, String password) throws ClassNotFoundException, SQLException {
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage, IsDeleted "
                + "FROM Account WHERE UserEmail = ? AND UserPassword = ? AND IsDeleted = 0";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
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
                account.setIsDeleted(rs.getBoolean("IsDeleted"));
                LOGGER.info("Đăng nhập thành công cho người dùng: " + email);
                return account;
            } else {
                LOGGER.info("Đăng nhập thất bại cho người dùng: " + email + " - Tài khoản không tồn tại hoặc đã bị xóa.");
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi trong quá trình đăng nhập cho người dùng: " + email, e);
            throw e;
        }
    }

    public List<Account> getAllAccount() throws SQLException, ClassNotFoundException {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserPhone, UserImage, IsDeleted "
                + "FROM Account"; // Bỏ điều kiện WHERE IsDeleted = 0
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
                account.setIsDeleted(rs.getBoolean("IsDeleted")); // Thêm trạng thái IsDeleted
                accounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy tất cả tài khoản", ex);
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

    public int updateAccount(String oldId, Account newInfo) throws SQLException, ClassNotFoundException {
        int count = 0;
        Connection con = null;
        PreparedStatement pstAccount = null;

        try {
            con = DBContext.getConnection();
            con.setAutoCommit(false);

            Account existingAccount = getAccountById(oldId, false);

            if (!existingAccount.getUserRole().equals(newInfo.getUserRole())) {
                String newUserId = generateUniqueUserId(newInfo.getUserRole());
                newInfo.setUserId(newUserId);
            } else {
                newInfo.setUserId(oldId);
            }

            if (!newInfo.getUserEmail().equals(existingAccount.getUserEmail()) && isEmailExists(newInfo.getUserEmail(), oldId)) {
                LOGGER.warning("updateAccount - Email đã tồn tại: " + newInfo.getUserEmail());
                return -1;
            }

            if (newInfo.getIdentityCard() != null && !newInfo.getIdentityCard().isEmpty()
                    && !newInfo.getIdentityCard().equals(existingAccount.getIdentityCard())
                    && isIdentityCardExists(newInfo.getIdentityCard(), oldId)) {
                LOGGER.warning("updateAccount - Số CCCD đã tồn tại: " + newInfo.getIdentityCard());
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
            LOGGER.info("updateAccount - Tài khoản đã được cập nhật thành công, số dòng ảnh hưởng: " + count);
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
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa tài khoản", ex);
        }
        return count;
    }

    public int restoreAccount(String id) {
        int count = 0;
        try {
            sql = "UPDATE Account SET IsDeleted = 0 WHERE UserId = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id);
            count = pst.executeUpdate();
            LOGGER.info("restoreAccount - Tài khoản " + id + " đã được khôi phục thành công, số dòng ảnh hưởng: " + count);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi khôi phục tài khoản", ex);
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
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy tất cả vai trò", e);
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
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy ID người dùng theo vai trò", e);
            return null;
        }
        return userIds;
    }

    // Lấy danh sách tài khoản đang hoạt động (IsDeleted = 0)
    public List<Account> getActiveAccounts() throws SQLException, ClassNotFoundException {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserPhone, UserImage, IsDeleted "
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
                account.setIsDeleted(rs.getBoolean("IsDeleted"));
                accounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách tài khoản đang hoạt động", ex);
            throw ex;
        }
        return accounts;
    }

    // Lấy danh sách tài khoản ngưng hoạt động (IsDeleted = 1)
    public List<Account> getInactiveAccounts() throws SQLException, ClassNotFoundException {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserPhone, UserImage, IsDeleted "
                + "FROM Account WHERE IsDeleted = 1";
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
                account.setIsDeleted(rs.getBoolean("IsDeleted"));
                accounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách tài khoản ngưng hoạt động", ex);
            throw ex;
        }
        return accounts;
    }
}
