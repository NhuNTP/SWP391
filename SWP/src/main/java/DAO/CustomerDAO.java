package DAO;

import DB.DBContext;
import Model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HuynhPhuBinh
 */
public class CustomerDAO {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    // Thêm khách hàng mới
    public void addCustomer(Customer customer) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Customer (CustomerId, CustomerName, CustomerPhone, NumberOfPayment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getCustomerId());
            stmt.setString(2, customer.getCustomerName());
            stmt.setString(3, customer.getCustomerPhone());
            stmt.setInt(4, customer.getNumberOfPayment());
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding customer: " + e.getMessage(), e);
            throw e;
        }
    }

    // Tạo CustomerId mới (dạng CUxxx)
    public String generateNextCustomerId() throws SQLException, ClassNotFoundException {
        String nextId = "CU001"; // Giá trị mặc định
        String sql = "SELECT MAX(CustomerId) as MaxId FROM Customer";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next() && rs.getString("MaxId") != null) {
                String maxId = rs.getString("MaxId"); // Ví dụ: "CU005"
                int numericPart = Integer.parseInt(maxId.substring(2)); // Lấy "005" -> 5
                numericPart++; // Tăng lên 6
                nextId = "CU" + String.format("%03d", numericPart); // "CU006"
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error generating next customer ID: " + e.getMessage(), e);
            throw e;
        }
        return nextId;
    }

    // Lấy danh sách tất cả khách hàng
    public List<Customer> getAllCustomers() throws SQLException, ClassNotFoundException {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getString("CustomerId"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setCustomerPhone(rs.getString("CustomerPhone"));
                customer.setNumberOfPayment(rs.getInt("NumberOfPayment"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all customers: " + e.getMessage(), e);
            throw e;
        }
        return customers;
    }

    // Lấy khách hàng theo ID
    public Customer getCustomerById(String customerId) throws SQLException, ClassNotFoundException {
        String query = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getString("CustomerId"),
                            rs.getString("CustomerName"),
                            rs.getString("CustomerPhone"),
                            rs.getInt("NumberOfPayment")
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving customer by ID: " + e.getMessage(), e);
            throw e;
        }
        return null;
    }

    // Cập nhật thông tin khách hàng
    public boolean updateCustomer(Customer customer) throws SQLException, ClassNotFoundException {
        String query = "UPDATE Customer SET CustomerName = ?, CustomerPhone = ?, NumberOfPayment = ? WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getCustomerPhone());
            ps.setInt(3, customer.getNumberOfPayment());
            ps.setString(4, customer.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating customer: " + e.getMessage(), e);
            throw e;
        }
    }

    // Xóa khách hàng
    public boolean deleteCustomer(String customerId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting customer: " + e.getMessage(), e);
            throw e;
        }
    }

    // Tăng NumberOfPayment của khách hàng
    public void incrementNumberOfPayment(String customerId) throws SQLException, ClassNotFoundException {
        if (customerId == null || customerId.isEmpty()) return; // Không tăng nếu không có CustomerId

        String sql = "UPDATE Customer SET NumberOfPayment = NumberOfPayment + 1 WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customerId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing number of payment: " + e.getMessage(), e);
            throw e;
        }
    }
   public boolean isPhoneExists(String phone, String excludeCustomerId) throws SQLException, ClassNotFoundException {
    String sql = "SELECT COUNT(*) FROM Customer WHERE CustomerPhone = ? AND (CustomerId != ? OR ? IS NULL)";
    try (Connection conn = DBContext.getConnection(); // Giả định có phương thức getConnection
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, phone);
        stmt.setString(2, excludeCustomerId != null ? excludeCustomerId : "");
        stmt.setString(3, excludeCustomerId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }
    return false;
}
}