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
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orderList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        java.sql.ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId FROM [Order]";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("OrderId"));
                order.setUserId(rs.getString("UserId"));
                order.setCustomerId(rs.getString("CustomerId"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getString("CouponId"));
                order.setTableId(rs.getString("TableId"));
                orderList.add(order);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return orderList;
    }

    public Order getOrderById(String orderId) throws ClassNotFoundException {
        Order order = null;
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM [Order] WHERE OrderId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getString("OrderId"));
                order.setUserId(rs.getString("UserId"));
                order.setCustomerId(rs.getString("CustomerId"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getString("CouponId"));
                order.setTableId(rs.getString("TableId"));
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
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                statuses.add(rs.getString("OrderStatus"));
            }
        }
        return statuses;
    }

    public List<String> getAllOrderTypes() throws SQLException, ClassNotFoundException {
        List<String> types = new ArrayList<>();
        String query = "SELECT DISTINCT OrderType FROM [Order]";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("OrderType"));
            }
        }
        return types;
    }

    public void CreateOrder(Order order) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmtOrder = null;
        PreparedStatement pstmtOrderDetail = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            String sqlOrder = "INSERT INTO [Order] (OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmtOrder = conn.prepareStatement(sqlOrder);
            pstmtOrder.setString(1, order.getOrderId());
            pstmtOrder.setString(2, order.getUserId());
            if (order.getCustomerId() != null && !order.getCustomerId().isEmpty()) {
                pstmtOrder.setString(3, order.getCustomerId());
            } else {
                pstmtOrder.setNull(3, java.sql.Types.NVARCHAR);
            }
            pstmtOrder.setTimestamp(4, new Timestamp(order.getOrderDate().getTime()));
            pstmtOrder.setString(5, order.getOrderStatus());
            pstmtOrder.setString(6, order.getOrderType());
            pstmtOrder.setString(7, order.getOrderDescription());
            if (order.getCouponId() != null && !order.getCouponId().isEmpty()) {
                pstmtOrder.setString(8, order.getCouponId());
            } else {
                pstmtOrder.setNull(8, java.sql.Types.NVARCHAR);
            }
            if (order.getTableId() != null && !order.getTableId().isEmpty()) {
                pstmtOrder.setString(9, order.getTableId());
            } else {
                pstmtOrder.setNull(9, java.sql.Types.NVARCHAR);
            }
            pstmtOrder.executeUpdate();

            if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
                String sqlOrderDetail = "INSERT INTO OrderDetail (OrderDetailId, OrderId, DishId, Quantity, Subtotal, DishName) VALUES (?, ?, ?, ?, ?, ?)";
                pstmtOrderDetail = conn.prepareStatement(sqlOrderDetail);
                int detailCounter = 1;
                for (OrderDetail detail : order.getOrderDetails()) {
                    String orderDetailId = order.getOrderId() + String.format("%03d", detailCounter++);
                    pstmtOrderDetail.setString(1, orderDetailId);
                    pstmtOrderDetail.setString(2, order.getOrderId());
                    pstmtOrderDetail.setString(3, detail.getDishId());
                    pstmtOrderDetail.setInt(4, detail.getQuantity());
                    pstmtOrderDetail.setDouble(5, detail.getSubtotal());
                    pstmtOrderDetail.setString(6, detail.getDishName());
                    pstmtOrderDetail.addBatch();
                }
                pstmtOrderDetail.executeBatch();
            } else {
                System.out.println("No OrderDetail to save for OrderId: " + order.getOrderId());
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (pstmtOrderDetail != null) {
                pstmtOrderDetail.close();
            }
            if (pstmtOrder != null) {
                pstmtOrder.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    public String generateNextOrderId() throws SQLException, ClassNotFoundException {
        Connection conn = DBContext.getConnection();
        String sql = "SELECT TOP 1 OrderId FROM [Order] ORDER BY OrderId DESC";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        java.sql.ResultSet rs = pstmt.executeQuery();
        String nextId = "OR001";
        if (rs.next()) {
            String lastId = rs.getString("OrderId");
            int num = Integer.parseInt(lastId.substring(2)) + 1;
            nextId = "OR" + String.format("%03d", num);
        }
        rs.close();
        pstmt.close();
        conn.close();
        return nextId;
    }

    private String getLastOrderIdFromDB() throws SQLException, ClassNotFoundException {
        String lastOrderId = null;
        String sql = "SELECT TOP 1 OrderId FROM [Order] WHERE OrderId LIKE 'OR%' ORDER BY CAST(SUBSTRING(OrderId, 3, LEN(OrderId) - 2) AS INT) DESC";
        try (Connection connection = DBContext.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql); ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                lastOrderId = resultSet.getString("OrderId");
            }
        }
        return lastOrderId;
    }

    public void updateOrder(Order order) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmtOrder = null;
        PreparedStatement pstmtDeleteDetails = null;
        PreparedStatement pstmtOrderDetail = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            String sqlOrder = "UPDATE [Order] SET UserId = ?, CustomerId = ?, OrderDate = ?, OrderStatus = ?, OrderType = ?, OrderDescription = ?, CouponId = ?, TableId = ? WHERE OrderId = ?";
            pstmtOrder = conn.prepareStatement(sqlOrder);
            pstmtOrder.setString(1, order.getUserId());
            if (order.getCustomerId() != null && !order.getCustomerId().isEmpty()) {
                pstmtOrder.setString(2, order.getCustomerId());
            } else {
                pstmtOrder.setNull(2, java.sql.Types.NVARCHAR);
            }
            pstmtOrder.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
            pstmtOrder.setString(4, order.getOrderStatus());
            pstmtOrder.setString(5, order.getOrderType());
            pstmtOrder.setString(6, order.getOrderDescription());
            if (order.getCouponId() != null && !order.getCouponId().isEmpty()) {
                pstmtOrder.setString(7, order.getCouponId());
            } else {
                pstmtOrder.setNull(7, java.sql.Types.NVARCHAR);
            }
            if (order.getTableId() != null && !order.getTableId().isEmpty()) {
                pstmtOrder.setString(8, order.getTableId());
            } else {
                pstmtOrder.setNull(8, java.sql.Types.NVARCHAR);
            }
            pstmtOrder.setString(9, order.getOrderId());
            pstmtOrder.executeUpdate();

            String sqlDeleteDetails = "DELETE FROM OrderDetail WHERE OrderId = ?";
            pstmtDeleteDetails = conn.prepareStatement(sqlDeleteDetails);
            pstmtDeleteDetails.setString(1, order.getOrderId());
            pstmtDeleteDetails.executeUpdate();

            if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
                String sqlOrderDetail = "INSERT INTO OrderDetail (OrderDetailId, OrderId, DishId, Quantity, Subtotal, DishName) VALUES (?, ?, ?, ?, ?, ?)";
                pstmtOrderDetail = conn.prepareStatement(sqlOrderDetail);
                int detailCounter = 1;
                for (OrderDetail detail : order.getOrderDetails()) {
                    String orderDetailId = order.getOrderId() + String.format("%03d", detailCounter++);
                    pstmtOrderDetail.setString(1, orderDetailId);
                    pstmtOrderDetail.setString(2, order.getOrderId());
                    pstmtOrderDetail.setString(3, detail.getDishId());
                    pstmtOrderDetail.setInt(4, detail.getQuantity());
                    pstmtOrderDetail.setDouble(5, detail.getSubtotal());
                    pstmtOrderDetail.setString(6, detail.getDishName());
                    pstmtOrderDetail.addBatch();
                }
                pstmtOrderDetail.executeBatch();
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (pstmtOrderDetail != null) {
                pstmtOrderDetail.close();
            }
            if (pstmtDeleteDetails != null) {
                pstmtDeleteDetails.close();
            }
            if (pstmtOrder != null) {
                pstmtOrder.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    public List<OrderDetail> getOrderDetails(String orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> orderDetails = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        java.sql.ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT DishId, Quantity, Subtotal, DishName FROM OrderDetail WHERE OrderId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setDishId(rs.getString("DishId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setSubtotal(rs.getDouble("Subtotal"));
                detail.setDishName(rs.getString("DishName"));
                orderDetails.add(detail);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return orderDetails;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT OD.OrderDetailId, OD.OrderId, OD.DishId, D.DishName, OD.Quantity, OD.Subtotal "
                + "FROM OrderDetail OD "
                + "INNER JOIN Dish D ON OD.DishId = D.DishId "
                + "WHERE OD.OrderId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderDetailId(rs.getString("OrderDetailId"));
                orderDetail.setOrderId(rs.getString("OrderId"));
                orderDetail.setDishId(rs.getString("DishId"));
                orderDetail.setQuantity(rs.getInt("Quantity"));
                orderDetail.setSubtotal(rs.getDouble("Subtotal"));
                orderDetail.setDishName(rs.getString("DishName"));
                orderDetails.add(orderDetail);
            }
        }
        return orderDetails;
    }

    public void createOrderItem(OrderDetail orderDetail) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO OrderDetail (OrderId, DishId, Quantity, Subtotal) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, orderDetail.getOrderId());
            pstmt.setString(2, orderDetail.getDishId());
            pstmt.setInt(3, orderDetail.getQuantity());
            pstmt.setDouble(4, orderDetail.getSubtotal());
            pstmt.executeUpdate();
        }
    }
}
