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

    public boolean addCustomer(Customer customer) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Customer (CustomerId, CustomerName, CustomerPhone, NumberOfPayment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getCustomerId());
            ps.setString(2, customer.getCustomerName());
            ps.setString(3, customer.getCustomerPhone());
            ps.setInt(4, customer.getNumberOfPayment());
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Customer> getAllCustomers() throws SQLException, ClassNotFoundException {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                customers.add(new Customer(
                        rs.getString("CustomerId"),
                        rs.getString("CustomerName"),
                        rs.getString("CustomerPhone"),
                        rs.getInt("NumberOfPayment")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving customers: " + e.getMessage());
        }
        return customers;
    }

    public Customer getCustomerById(String customerId) throws SQLException, ClassNotFoundException {
        String query = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getString("CustomerId"),
                        rs.getString("CustomerName"),
                        rs.getString("CustomerPhone"),
                        rs.getInt("NumberOfPayment")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving customer by ID: " + e.getMessage());
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
            System.err.println("Error updating customer: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteCustomer(String customerId) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
        }
        return false;
    }

   public String generateNextCouponId() throws SQLException, ClassNotFoundException {
        String lastCouponId = getLastCouponIdFromDB();
        int nextNumber = 1; // Số bắt đầu nếu chưa có coupon nào

        if (lastCouponId != null && !lastCouponId.isEmpty()) {
            try {
                String numberPart = lastCouponId.substring(2); // Loại bỏ "CO"
                nextNumber = Integer.parseInt(numberPart) + 1;
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu phần số không đúng định dạng (ví dụ: log lỗi hoặc ném exception)
                System.err.println("Lỗi định dạng CustomerId cuối cùng: " + lastCouponId);
                // Trong trường hợp lỗi định dạng, vẫn nên tạo mã mới bắt đầu từ CP001 để đảm bảo tiếp tục hoạt động
                return "CU001";
            }
        }

        // Định dạng số thành chuỗi 3 chữ số (ví dụ: 1 -> "001", 10 -> "010", 100 -> "100")
        String numberStr = String.format("%03d", nextNumber);
        return "CU" + numberStr; // **Sửa thành "CP" thay vì "CO"**
    }

    private String getLastCouponIdFromDB() throws SQLException, ClassNotFoundException {
        String lastCouponId = null;
        // **Sửa câu SQL cho đúng tên bảng và cột, và dùng TOP 1 cho SQL Server**
        String sql = "SELECT TOP 1 CustomerId FROM [db1].[dbo].[Customer] ORDER BY CustomerId DESC";
        Connection connection = null; // Khai báo connection để quản lý đóng kết nối trong finally
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBContext.getConnection(); // Gọi phương thức getConnection() để lấy Connection - **Cần đảm bảo getConnection() được implement đúng**
            preparedStatement = connection.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                lastCouponId = resultSet.getString("CustomerId"); // **Sửa thành "CouponId" cho đúng tên cột**
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi hoặc xử lý lỗi kết nối database
            throw e; // Re-throw để servlet xử lý nếu cần
        } finally {
            // Đóng resources trong finally block để đảm bảo giải phóng kết nối và resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return lastCouponId;
    }
}
