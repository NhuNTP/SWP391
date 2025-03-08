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

/**
 *
 * @author HuynhPhuBinh
 */
public class OrderDAO {

    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("OrderId"));  // Changed to getString
                order.setUserId(rs.getString("UserId"));    // Changed to getString
                order.setCustomerId(rs.getString("CustomerId")); // Changed to getString
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getString("CouponId"));  // Changed to getString
                order.setTableId(rs.getString("TableId"));   // Changed to getString

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(String orderId) throws ClassNotFoundException {  // Changed to String
        Order order = null;
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM [Order] WHERE OrderId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, orderId); // Changed to setString
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                order = new Order();
                 order.setOrderId(rs.getString("OrderId"));  // Changed to getString
                order.setUserId(rs.getString("UserId"));    // Changed to getString
                order.setCustomerId(rs.getString("CustomerId")); // Changed to getString
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setOrderStatus(rs.getString("OrderStatus"));
                order.setOrderType(rs.getString("OrderType"));
                order.setOrderDescription(rs.getString("OrderDescription"));
                order.setCouponId(rs.getString("CouponId"));  // Changed to getString
                order.setTableId(rs.getString("TableId"));   // Changed to getString
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
    String sql = "INSERT INTO [Order] (OrderId, UserId, CustomerId, OrderDate, OrderStatus, OrderType, OrderDescription, CouponId, TableId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        logger.log(Level.INFO, "Executing SQL: {0}", sql);

        pstmt.setString(1, order.getOrderId());
        pstmt.setString(2, order.getUserId());

        // Handle nullable CustomerId
        if (order.getCustomerId() != null && !order.getCustomerId().isEmpty()) {
            pstmt.setString(3, order.getCustomerId());
        } else {
            pstmt.setNull(3, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }

        pstmt.setTimestamp(4, new Timestamp(order.getOrderDate().getTime()));
        pstmt.setString(5, order.getOrderStatus());
        pstmt.setString(6, order.getOrderType());
        pstmt.setString(7, order.getOrderDescription());

        // Handle nullable CouponId
        if (order.getCouponId() != null && !order.getCouponId().isEmpty()) {
            pstmt.setString(8, order.getCouponId());
        } else {
            pstmt.setNull(8, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }

        // Handle nullable TableId
        if (order.getTableId() != null && !order.getTableId().isEmpty()) {
            pstmt.setString(9, order.getTableId());
        } else {
            pstmt.setNull(9, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }

        pstmt.executeUpdate();
        logger.info("Order created successfully in database.");
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Error creating order in database", e);
        throw e;  // Re-throw the exception so it's handled in the controller
    }
}

public String generateNextOrderId() throws SQLException, ClassNotFoundException {
    String lastOrderId = getLastOrderIdFromDB();
    int nextNumber = 1;

    if (lastOrderId != null && !lastOrderId.isEmpty()) {
        try {
            String numberPart = lastOrderId.substring(2); // Loại bỏ "OD"
            nextNumber = Integer.parseInt(numberPart) + 1;
        } catch (NumberFormatException e) {
            System.err.println("Lỗi định dạng OrderId cuối cùng: " + lastOrderId);
            return "OD001"; // Trường hợp lỗi định dạng, bắt đầu từ OD001
        }
    }

    String numberStr = String.format("%03d", nextNumber);
    return "OD" + numberStr;
}

    private String getLastOrderIdFromDB() throws SQLException, ClassNotFoundException {
    String lastOrderId = null;
    String sql = "SELECT TOP 1 OrderId FROM [Order] ORDER BY OrderId DESC";

    try (Connection connection = DBContext.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql);
         ResultSet resultSet = preparedStatement.executeQuery()) {

        if (resultSet.next()) {
            lastOrderId = resultSet.getString("OrderId");
        }
    }
    return lastOrderId;
}

    public void updateOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE [Order] SET UserId = ?, CustomerId = ?, OrderDate = ?, OrderStatus = ?, OrderType = ?, OrderDescription = ?, CouponId = ?, TableId = ? WHERE OrderId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, order.getUserId());
               // Handle nullable CustomerId
        if (order.getCustomerId() != null && !order.getCustomerId().isEmpty()) {
            pstmt.setString(2, order.getCustomerId());
        } else {
            pstmt.setNull(2, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }
            pstmt.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
            pstmt.setString(4, order.getOrderStatus());
            pstmt.setString(5, order.getOrderType());
            pstmt.setString(6, order.getOrderDescription());
               // Handle nullable CouponId
        if (order.getCouponId() != null && !order.getCouponId().isEmpty()) {
            pstmt.setString(7, order.getCouponId());
        } else {
            pstmt.setNull(7, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }

        // Handle nullable TableId
        if (order.getTableId() != null && !order.getTableId().isEmpty()) {
            pstmt.setString(8, order.getTableId());
        } else {
            pstmt.setNull(8, java.sql.Types.NVARCHAR); // Or appropriate SQL type for NVARCHAR
        }
            pstmt.setString(9, order.getOrderId()); // Điều kiện WHERE: OrderId

            pstmt.executeUpdate();
        }
    }

   public List<OrderDetail> getOrderDetailsByOrderId(String orderId) throws SQLException, ClassNotFoundException {  // Changed to String
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

        pstmt.setString(1, orderId);  // Changed to setString
        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrderDetailId(rs.getString("OrderDetailId")); //change to String
            orderDetail.setOrderId(rs.getString("OrderId"));//change to String
            orderDetail.setDishId(rs.getString("DishId"));//change to String
            orderDetail.setQuantity(rs.getInt("Quantity"));
            orderDetail.setSubtotal(rs.getDouble("Subtotal"));
            orderDetail.setDishName(rs.getString("DishName")); // Lấy tên món ăn

            orderDetails.add(orderDetail);
        }
    }
    return orderDetails;
}


    public void createOrderItem(OrderDetail orderDetail) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO OrderDetail (OrderId, DishId, Quantity, Subtotal) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, orderDetail.getOrderId());//change to String
            pstmt.setString(2, orderDetail.getDishId());//change to String
            pstmt.setInt(3, orderDetail.getQuantity());
            pstmt.setDouble(4, orderDetail.getSubtotal());

            pstmt.executeUpdate();
        }
    }

}