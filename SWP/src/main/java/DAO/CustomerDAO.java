package DAO;

import DB.DBContext;
import Model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CustomerDAO {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    // Thêm khách hàng mới và trả về CustomerId
    public String createCustomer(Customer customer) throws SQLException, ClassNotFoundException {
        String customerId = "CU001"; // Giá trị mặc định
        String sqlMaxId = "SELECT MAX(CustomerId) as MaxId FROM Customer WITH (UPDLOCK, ROWLOCK)";
        String sqlInsert = "INSERT INTO Customer (CustomerId, CustomerName, CustomerPhone, NumberOfPayment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection()) {
            // Bắt đầu transaction để đảm bảo tính duy nhất của CustomerId
            conn.setAutoCommit(false);

            // Sinh CustomerId mới
            try (PreparedStatement stmtMaxId = conn.prepareStatement(sqlMaxId);
                 ResultSet rs = stmtMaxId.executeQuery()) {
                if (rs.next() && rs.getString("MaxId") != null) {
                    String maxId = rs.getString("MaxId");
                    int numericPart = Integer.parseInt(maxId.substring(2)) + 1;
                    customerId = "CU" + String.format("%03d", numericPart);
                }
            }

            // Thêm khách hàng với CustomerId vừa sinh
            try (PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert)) {
                stmtInsert.setString(1, customerId);
                stmtInsert.setString(2, customer.getCustomerName());
                stmtInsert.setString(3, customer.getCustomerPhone());
                stmtInsert.setInt(4, customer.getNumberOfPayment());
                stmtInsert.executeUpdate();
            }

            // Commit transaction
            conn.commit();
            LOGGER.log(Level.INFO, "Created customer with ID: {0}", customerId);
            return customerId; // Trả về CustomerId
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding customer: {0}", e.getMessage());
            throw e;
        }
    }

    // Giữ nguyên generateNextCustomerId nếu cần dùng riêng ở nơi khác
    public String generateNextCustomerId() throws SQLException, ClassNotFoundException {
        String nextId = "CU001";
        String sql = "SELECT MAX(CustomerId) as MaxId FROM Customer WITH (UPDLOCK, ROWLOCK)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next() && rs.getString("MaxId") != null) {
                String maxId = rs.getString("MaxId");
                int numericPart = Integer.parseInt(maxId.substring(2)) + 1;
                nextId = "CU" + String.format("%03d", numericPart);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error generating next customer ID: {0}", e.getMessage());
            throw e;
        }
        return nextId;
    }

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
            LOGGER.log(Level.SEVERE, "Error retrieving all customers: {0}", e.getMessage());
            throw e;
        }
        return customers;
    }

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
            LOGGER.log(Level.SEVERE, "Error retrieving customer by ID: {0}", e.getMessage());
            throw e;
        }
        return null;
    }

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
            LOGGER.log(Level.SEVERE, "Error updating customer: {0}", e.getMessage());
            throw e;
        }
    }

    public boolean deleteCustomer(String customerId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting customer: {0}", e.getMessage());
            throw e;
        }
    }

    public void incrementNumberOfPayment(String customerId) throws SQLException, ClassNotFoundException {
        if (customerId == null || customerId.isEmpty()) {
            return;
        }
        String sql = "UPDATE Customer SET NumberOfPayment = NumberOfPayment + 1 WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customerId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing number of payment: {0}", e.getMessage());
            throw e;
        }
    }

    public boolean isPhoneExists(String phone, String excludeCustomerId) throws SQLException, ClassNotFoundException {
        String sql = excludeCustomerId == null || excludeCustomerId.isEmpty()
                ? "SELECT COUNT(*) FROM Customer WHERE CustomerPhone = ?"
                : "SELECT COUNT(*) FROM Customer WHERE CustomerPhone = ? AND CustomerId != ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            if (excludeCustomerId != null && !excludeCustomerId.isEmpty()) {
                stmt.setString(2, excludeCustomerId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking phone existence: {0}", e.getMessage());
            throw e;
        }
        return false;
    }
}