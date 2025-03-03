package DAO;

import DB.DBContext;
import Model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HuynhPhuBinh
 */
public class CustomerDAO {

    public boolean addCustomer(Customer customer) throws SQLException, ClassNotFoundException  {
    String sql = "INSERT INTO Customer (CustomerName, CustomerPhone, NumberOfPayment) VALUES (?, ?, ?)";
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
             
        ps.setString(1, customer.getCustomerName());
        ps.setString(2, customer.getCustomerPhone());
        ps.setInt(3, customer.getNumberOfPayment());
        int rowsAffected = ps.executeUpdate();

        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    public List<Customer> getAllCustomers() throws SQLException, ClassNotFoundException  {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("CustomerId"),
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

    public Customer getCustomerById(int customerId) throws SQLException, ClassNotFoundException  {
        String query = "SELECT CustomerId, CustomerName, CustomerPhone, NumberOfPayment FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("CustomerId"),
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

    public boolean updateCustomer(Customer customer) throws SQLException, ClassNotFoundException  {
        String query = "UPDATE Customer SET CustomerName = ?, CustomerPhone = ?, NumberOfPayment = ? WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getCustomerPhone());
            ps.setInt(3, customer.getNumberOfPayment());
            ps.setInt(4, customer.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating customer: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteCustomer(int customerId) throws SQLException, ClassNotFoundException  {
        String query = "DELETE FROM Customer WHERE CustomerId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
        }
        return false;
    }
}
