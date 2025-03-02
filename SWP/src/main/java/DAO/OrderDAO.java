package DAO;

import DB.DBContext;
import Model.Order;
import Model.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HuynhPhuBinh
 */
public class OrderDAO {

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

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

    public Order getOrderById(int orderId) throws ClassNotFoundException {
        Order order = null;
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM [Order] WHERE OrderId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setCustomerId(rs.getInt("CustomerId"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getInt("CouponId"));
                order.setTableId(rs.getInt("TableId"));
                // Lấy danh sách order details
                order.setOrderDetails(getOrderDetailsByOrderId(orderId));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    public List<String> getAllOrderStatuses() throws SQLException, ClassNotFoundException {
        List<String> statuses = new ArrayList<>();
        String query = "SELECT DISTINCT OrderStatus FROM [Order]";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                statuses.add(rs.getString("OrderStatus"));
            }
        }
        return statuses;
    }

    public List<String> getAllOrderTypes() throws SQLException, ClassNotFoundException {
        List<String> types = new ArrayList<>();
        String query = "SELECT DISTINCT OrderType FROM [Order]";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("OrderType"));
            }
        }
        return types;
    }

    public void CreateOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO [Order] (UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getCustomerId());
            pstmt.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
            pstmt.setString(4, order.getOrderStatus());
            pstmt.setString(5, order.getOrderType());
            pstmt.setString(6, order.getOrderDescription());
            pstmt.setInt(7, order.getCouponId());
            pstmt.setInt(8, order.getTableId());

            pstmt.executeUpdate();
        }
    }

    public int getLastInsertedId() throws SQLException, ClassNotFoundException {
        String sql = "SELECT IDENT_CURRENT('Order')"; // SQL Server
        //String sql = "SELECT last_insert_id()"; // MySQL
        //String sql = "SELECT currval(pg_get_serial_sequence('Order', 'OrderId'))"; // PostgreSQL
        int orderId = 0;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                orderId = rs.getInt(1);
            }
        }
        return orderId;
    }

    public void updateOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE [Order] SET UserId = ?, CustomerId = ?, OrderDate = ?, OrderStatus = ?, OrderType = ?, OrderDescription = ?, CouponId = ?, TableId = ? WHERE OrderId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getCustomerId());
            pstmt.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
            pstmt.setString(4, order.getOrderStatus());
            pstmt.setString(5, order.getOrderType());
            pstmt.setString(6, order.getOrderDescription());
            pstmt.setInt(7, order.getCouponId());
            pstmt.setInt(8, order.getTableId());
            pstmt.setInt(9, order.getOrderId()); // Điều kiện WHERE: OrderId

            pstmt.executeUpdate();
        }
    }

   public List<OrderDetail> getOrderDetailsByOrderId(int orderId) throws SQLException, ClassNotFoundException {
    List<OrderDetail> orderDetails = new ArrayList<>();
    String sql = "SELECT " +
                 "    OD.OrderDetailId, " +
                 "    OD.OrderId, " +
                 "    OD.DishId, " +
                 "    D.DishName, " +
                 "    OD.Quantity, " +
                 "    OD.Subtotal " +
                 "FROM " +
                 "    OrderDetail OD " +
                 "INNER JOIN " +
                 "    Dish D ON OD.DishId = D.DishId " +
                 "WHERE " +
                 "    OD.OrderId = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, orderId);
        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrderDetailId(rs.getInt("OrderDetailId"));
            orderDetail.setOrderId(rs.getInt("OrderId"));
            orderDetail.setDishId(rs.getInt("DishId"));
            orderDetail.setQuantity(rs.getInt("Quantity"));
            orderDetail.setSubtotal(rs.getDouble("Subtotal"));
            orderDetail.setDishName(rs.getString("DishName")); // Lấy tên món ăn

            orderDetails.add(orderDetail);
        }
    }
    return orderDetails;
}
   private String getDishName(int dishId) throws SQLException, ClassNotFoundException {
    String sql = "SELECT DishName FROM Dish WHERE DishId = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, dishId);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getString("DishName");
        }
    }
    return null; // Hoặc giá trị mặc định khác
}

    public void createOrderItem(OrderDetail orderDetail) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO OrderDetail (OrderId, DishId, Quantity, Subtotal) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderDetail.getOrderId());
            pstmt.setInt(2, orderDetail.getDishId());
            pstmt.setInt(3, orderDetail.getQuantity());
            pstmt.setDouble(4, orderDetail.getSubtotal());

            pstmt.executeUpdate();
        }
    }

}