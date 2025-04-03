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

    // Lấy OrderId theo TableId (chỉ lấy đơn hàng chưa hoàn tất)
    public String getOrderIdByTableId(String tableId) throws SQLException, ClassNotFoundException {
        String orderId = null;
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT OrderId FROM [Order] WHERE TableId = ? AND OrderStatus = 'Pending'")) {
            stmt.setString(1, tableId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                orderId = rs.getString("OrderId");
            }
        }
        return orderId;
    }

    // Lấy chi tiết đơn hàng theo OrderId
    public List<OrderDetail> getOrderDetailsByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> details = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT OrderDetailId, DishId, Quantity, Subtotal, DishName FROM OrderDetail WHERE OrderId = ?")) {
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getString("OrderDetailId"));
                detail.setOrderId(orderId);
                detail.setDishId(rs.getString("DishId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setSubtotal(rs.getDouble("Subtotal"));
                detail.setDishName(rs.getString("DishName"));
                details.add(detail);
            }
        }
        return details;
    }

    // Lấy đơn hàng theo OrderId
    public Order getOrderById(String orderId) throws SQLException, ClassNotFoundException {
        Order order = null;
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId, CustomerPhone, Total "
                + "FROM [Order] WHERE OrderId = ?")) {
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                order = new Order();
                order.setOrderId(orderId);
                order.setUserId(rs.getString("UserId"));
                order.setCustomerId(rs.getString("CustomerId"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getString("CouponId"));
                order.setTableId(rs.getString("TableId"));
                order.setCustomerPhone(rs.getString("CustomerPhone"));
                order.setTotal(rs.getDouble("Total"));
                order.setOrderDetails(getOrderDetailsByOrderId(orderId));
            }
        }
        return order;
    }

    // Tạo đơn hàng mới
    public void CreateOrder(Order order) throws SQLException, ClassNotFoundException {
    Connection conn = null;
    PreparedStatement pstmtOrder = null;
    PreparedStatement pstmtOrderDetail = null;
    try {
        conn = DBContext.getConnection();
        conn.setAutoCommit(false); // Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu

        // Chèn vào bảng Order
        String sqlOrder = "INSERT INTO [Order] (OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, TableId, Total) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmtOrder = conn.prepareStatement(sqlOrder);
        pstmtOrder.setString(1, order.getOrderId());
        pstmtOrder.setString(2, order.getUserId());
        pstmtOrder.setString(3, order.getCustomerId());
        pstmtOrder.setTimestamp(4, new Timestamp(order.getOrderDate().getTime()));
        pstmtOrder.setString(5, order.getOrderStatus());
        pstmtOrder.setString(6, order.getOrderType());
        pstmtOrder.setString(7, order.getTableId());
        pstmtOrder.setDouble(8, order.getTotal());
        pstmtOrder.executeUpdate();

        // Chèn vào bảng OrderDetail nếu có
        if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
            String sqlOrderDetail = "INSERT INTO OrderDetail (OrderDetailId, OrderId, DishId, Quantity, Subtotal, DishName) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            pstmtOrderDetail = conn.prepareStatement(sqlOrderDetail);
            int detailCounter = 1;
            for (OrderDetail detail : order.getOrderDetails()) {
                String orderDetailId = order.getOrderId() + String.format("%03d", detailCounter++); // Sinh OrderDetailId
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

        conn.commit(); // Commit transaction
    } catch (SQLException e) {
        if (conn != null) {
            conn.rollback(); // Rollback nếu có lỗi
        }
        throw new SQLException("Lỗi khi tạo Order: " + e.getMessage(), e);
    } finally {
        if (pstmtOrderDetail != null) pstmtOrderDetail.close();
        if (pstmtOrder != null) pstmtOrder.close();
        if (conn != null) conn.close();
    }
}
    // Tạo mã OrderId mới
    public String generateNextOrderId() throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT TOP 1 OrderId FROM [Order] ORDER BY OrderId DESC")) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String lastId = rs.getString("OrderId");
                int num = Integer.parseInt(lastId.substring(2)) + 1;
                return "OR" + String.format("%03d", num);
            }
            return "OR001"; // Nếu chưa có đơn hàng nào
        }
    }

    // Thêm OrderDetail
    public void addOrderDetail(String orderId, OrderDetail detail) throws SQLException, ClassNotFoundException {
    try (Connection conn = DBContext.getConnection()) {
        conn.setAutoCommit(false);
        try {
            String sql = "INSERT INTO OrderDetail (OrderId, DishId, Quantity, Subtotal, DishName) "
                    + "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, orderId);
            stmt.setString(2, detail.getDishId());
            stmt.setInt(3, detail.getQuantity());
            stmt.setDouble(4, detail.getSubtotal());
            stmt.setString(5, detail.getDishName());
            stmt.executeUpdate();

            // Lấy orderDetailId tự sinh (nếu cần)
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                detail.setOrderDetailId(generatedKeys.getString(1)); // Cập nhật ID tự sinh
            }

            updateOrderTotal(orderId, conn);
            conn.commit();
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        }
    }
}

    // Tạo mã OrderDetailId mới
    public String generateNextOrderDetailId() throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT TOP 1 OrderDetailId FROM OrderDetail ORDER BY OrderDetailId DESC")) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String lastId = rs.getString("OrderDetailId");
                int num = Integer.parseInt(lastId.substring(2)) + 1;
                return "OD" + String.format("%03d", num);
            }
            return "OD001";
        }
    }

    // Cập nhật tổng tiền đơn hàng
    private void updateOrderTotal(String orderId, Connection conn) throws SQLException {
        String sql = "UPDATE [Order] SET Total = (SELECT SUM(Subtotal) FROM OrderDetail WHERE OrderId = ?) WHERE OrderId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderId);
            stmt.setString(2, orderId);
            stmt.executeUpdate();
        }
    }

    // Cập nhật đơn hàng
    public void updateOrder(Order order) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE [Order] SET orderStatus = ?, couponId = ?, total = ? WHERE orderId = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, order.getOrderStatus());
        ps.setString(2, order.getCouponId());
        ps.setDouble(3, order.getTotal());
        ps.setString(4, order.getOrderId());
        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("Updated order " + order.getOrderId() + " with total: " + order.getTotal());
        } else {
            System.out.println("Order " + order.getOrderId() + " not found");
        }
    }
}

    // Cập nhật CustomerId cho đơn hàng
    public void updateOrderCustomer(String orderId, String customerId) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "UPDATE [Order] SET CustomerId = ? WHERE OrderId = ?")) {
            stmt.setString(1, customerId);
            stmt.setString(2, orderId);
            stmt.executeUpdate();
        }
    }

    // Xóa OrderDetail
    public void deleteOrderDetail(String orderDetailId) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String orderIdSql = "SELECT OrderId FROM OrderDetail WHERE OrderDetailId = ?";
                String orderId;
                try (PreparedStatement stmt = conn.prepareStatement(orderIdSql)) {
                    stmt.setString(1, orderDetailId);
                    ResultSet rs = stmt.executeQuery();
                    orderId = rs.next() ? rs.getString("OrderId") : null;
                }

                String sql = "DELETE FROM OrderDetail WHERE OrderDetailId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, orderDetailId);
                    stmt.executeUpdate();
                }

                if (orderId != null) {
                    updateOrderTotal(orderId, conn);
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // Cập nhật số lượng OrderDetail
    public void updateOrderDetailQuantity(String orderDetailId, int newQuantity) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String sql = "SELECT OrderId, DishId FROM OrderDetail WHERE OrderDetailId = ?";
                String orderId;
                String dishId;
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, orderDetailId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        orderId = rs.getString("OrderId");
                        dishId = rs.getString("DishId");
                    } else {
                        throw new SQLException("OrderDetail not found");
                    }
                }

                double dishPrice = getDishPrice(dishId);
                double newSubtotal = dishPrice * newQuantity;

                String updateSql = "UPDATE OrderDetail SET Quantity = ?, Subtotal = ? WHERE OrderDetailId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setInt(1, newQuantity);
                    stmt.setDouble(2, newSubtotal);
                    stmt.setString(3, orderDetailId);
                    stmt.executeUpdate();
                }

                updateOrderTotal(orderId, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // Lấy giá món ăn
    private double getDishPrice(String dishId) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT DishPrice FROM Dish WHERE DishId = ?")) {
            stmt.setString(1, dishId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getDouble("DishPrice") : 0;
        }
    }

    // Lấy danh sách đơn hàng theo trạng thái
    public List<Order> getOrdersByStatus(String status) throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId, CustomerPhone, Total "
                + "FROM [Order] WHERE OrderStatus = ?")) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
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
                order.setCustomerPhone(rs.getString("CustomerPhone"));
                order.setTotal(rs.getDouble("Total"));
                order.setOrderDetails(getOrderDetailsByOrderId(rs.getString("OrderId")));
                orders.add(order);
            }
        }
        return orders;
    }

//---------
    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orderList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId, CustomerPhone, Total FROM [Order]";
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
                order.setCustomerPhone(rs.getString("CustomerPhone"));
                order.setTotal(rs.getDouble("Total"));
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

    public List<OrderDetail> getOrderDetails(String orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> orderDetails = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
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

    private double getDishPrice(String dishId, Connection conn) throws SQLException {
        String sql = "SELECT DishPrice FROM Dish WHERE DishId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dishId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("DishPrice");
            } else {
                throw new SQLException("Dish not found: " + dishId);
            }
        }
    }

    public void updateCustomerPhone(String orderId, String customerPhone) throws SQLException, ClassNotFoundException {
    try (Connection conn = DBContext.getConnection()) {
        String sql = "UPDATE [Order] SET CustomerPhone = ? WHERE OrderId = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, customerPhone);
        pstmt.setString(2, orderId);
        pstmt.executeUpdate();
        // Kiểm tra xem có thêm OrderDetail không
        logger.log(Level.INFO, "Updated customer phone for order {0} to {1}", new Object[]{orderId, customerPhone});
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Error updating customer phone", e);
        throw e;
    }
}

    // Thêm phương thức updateOrderCustomer
    // Helper method để lấy OrderId từ OrderDetailId
    private String getOrderIdFromDetailId(String orderDetailId, Connection conn) throws SQLException {
        String sql = "SELECT OrderId FROM OrderDetail WHERE OrderDetailId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, orderDetailId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() ? rs.getString("OrderId") : null;
        }
    }

    // Cập nhật trạng thái đơn hàng thành "Paid"
    public void payOrder(String orderId) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "UPDATE [Order] SET OrderStatus = 'Paid' WHERE OrderId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    //--------
}
