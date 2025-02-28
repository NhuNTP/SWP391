/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DB.DBContext;
import Model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author HuynhPhuBinh
 */
public class OrderDAO {
     public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setCustomerId(rs.getInt("CustomerId"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getInt("CouponId"));
                order.setTableId(rs.getInt("TableId"));

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    public void createOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Orders (UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, order.getUserId());
            stmt.setInt(2, order.getCustomerId());
            stmt.setTimestamp(3, new java.sql.Timestamp(new Date().getTime()));
            stmt.setString(4, order.getOrderStatus());
            stmt.setString(5, order.getOrderType());
            stmt.setString(6, order.getOrderDescription());
            stmt.setInt(7, order.getCouponId());
            stmt.setInt(8, order.getTableId());

            stmt.executeUpdate();
        }
    }
     public Order getOrderById(int orderId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM [Order] WHERE OrderId = ?";
        Order order = null;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setCustomerId(rs.getInt("CustomerId"));
                order.setOrderDate(new Date(rs.getDate("OrderDate").getTime()));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getInt("CouponId"));
                order.setTableId(rs.getInt("TableId"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }
     public boolean updateOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE [Order] SET UserId=?, CustomerId=?, OrderDate=?, OrderStatus=?, OrderType=?, OrderDescription=?, CouponId=?, TableId=? WHERE OrderId=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, order.getUserId());
            stmt.setInt(2, order.getCustomerId());
            stmt.setDate(3, new java.sql.Date(order.getOrderDate().getTime()));
            stmt.setString(4, order.getOrderStatus());
            stmt.setString(5, order.getOrderType());
            stmt.setString(6, order.getOrderDescription());
            stmt.setInt(7, order.getCouponId());
            stmt.setInt(8, order.getTableId());
            stmt.setInt(9, order.getOrderId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     public boolean updateOrderStatus(int orderId, String orderStatus) throws SQLException, ClassNotFoundException {
    String query = "UPDATE Orders SET OrderStatus = ? WHERE OrderId = ?";
    try (Connection con = DBContext.getConnection();
         PreparedStatement ps = con.prepareStatement(query)) {
        ps.setString(1, orderStatus);
        ps.setInt(2, orderId);

        int rowsUpdated = ps.executeUpdate();
        System.out.println("Rows updated: " + rowsUpdated); // Debug log

        return rowsUpdated > 0;
    }
}

}

