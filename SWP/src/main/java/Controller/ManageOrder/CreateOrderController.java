/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
// CreateOrderController.java
// CreateOrderController.java
package Controller.ManageOrder;

import DAO.OrderDAO;
import DB.DBContext;
import Model.Order;
import Model.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/CreateOrder")
public class CreateOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        try {
            List<String> orderStatuses = orderDAO.getAllOrderStatuses();
            List<String> orderTypes = orderDAO.getAllOrderTypes();

            request.setAttribute("orderStatuses", orderStatuses);
            request.setAttribute("orderTypes", orderTypes);

        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Error retrieving order statuses/types: " + ex.getMessage());
        }

        // Hiển thị form tạo order
        request.getRequestDispatcher("ManageOrder/CreateOrder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ request (thông tin chung của Order)
            String userIdStr = request.getParameter("userId");
            String customerIdStr = request.getParameter("customerId");
            String couponIdStr = request.getParameter("couponId");
            String tableIdStr = request.getParameter("tableId");

            int userId = (userIdStr != null && !userIdStr.isEmpty()) ? Integer.parseInt(userIdStr) : 0;
            int customerId = (customerIdStr != null && !customerIdStr.isEmpty()) ? Integer.parseInt(customerIdStr) : 0;
            int couponId = (couponIdStr != null && !couponIdStr.isEmpty()) ? Integer.parseInt(couponIdStr) : 0;
            int tableId = (tableIdStr != null && !tableIdStr.isEmpty()) ? Integer.parseInt(tableIdStr) : 0;

            // Chuyển đổi chuỗi ngày thành đối tượng Date
            String orderDateString = request.getParameter("orderDate");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm"); // Định dạng phù hợp với datetime-local
            Date orderDate = dateFormat.parse(orderDateString);

            String orderStatus = request.getParameter("orderStatus");
            String orderType = request.getParameter("orderType");
            String orderDescription = request.getParameter("orderDescription");

            // 2. Tạo đối tượng Order
            Order order = new Order();
            order.setUserId(userId);
            order.setCustomerId(customerId);
            order.setOrderDate(orderDate);
            order.setOrderStatus(orderStatus);
            order.setOrderType(orderType);
            order.setOrderDescription(orderDescription);
            order.setCouponId(couponId);
            order.setTableId(tableId);

            // 3. Gọi DAO để thêm order vào database
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.CreateOrder(order); // Tạo Order mới

            // 4. Lấy orderId vừa tạo
            int orderId = orderDAO.getLastInsertedId(); // Lấy orderId

            // ---------------------------------------------------------------------
            // 5. Lấy danh sách các món ăn từ request
            List<OrderDetail> orderDetails = new ArrayList<>();
            int i = 1;
            while (request.getParameter("dishId_" + i) != null) {
                String dishIdStr = request.getParameter("dishId_" + i);
                String quantityStr = request.getParameter("quantity_" + i);

                if (dishIdStr != null && !dishIdStr.isEmpty() && quantityStr != null && !quantityStr.isEmpty()) {
                    int dishId = Integer.parseInt(dishIdStr);
                    int quantity = Integer.parseInt(quantityStr);

                    // Tạo đối tượng OrderDetail
                    OrderDetail orderDetail = new OrderDetail();
                    orderDetail.setOrderId(orderId); // Set orderId
                    orderDetail.setDishId(dishId);
                    orderDetail.setQuantity(quantity);

                    //Lấy tên món ăn từ database
                    String dishName = getDishName(dishId);
                    orderDetail.setDishName(dishName);

                    // Tính toán subtotal (ví dụ: lấy giá từ database)
                    double dishPrice = getDishPrice(dishId); // Lấy giá từ database
                    orderDetail.setSubtotal(dishPrice * quantity);

                    orderDetails.add(orderDetail);
                }
                i++;
            }

            // 6. Lưu danh sách OrderDetail vào database
            for (OrderDetail orderDetail : orderDetails) {
                //Gán order id trước khi lưu
                orderDetail.setOrderId(orderId);
                orderDAO.createOrderItem(orderDetail);
            }
            // ---------------------------------------------------------------------
            // 7. Chuyển hướng về trang danh sách order (hoặc trang thông báo thành công)
            response.sendRedirect("ViewOrderList");

        } catch (SQLException ex) {
            Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            // Xử lý lỗi SQLException (ví dụ: hiển thị thông báo lỗi cho người dùng)
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/CreateOrder.jsp").forward(request, response); // Trở lại form với thông báo lỗi
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            // Xử lý lỗi ClassNotFoundException
            request.setAttribute("errorMessage", "Class not found: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/CreateOrder.jsp").forward(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            // Xử lý lỗi ParseException (lỗi chuyển đổi ngày tháng)
            request.setAttribute("errorMessage", "Invalid date format: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/CreateOrder.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            // Xử lý lỗi NumberFormatException (lỗi chuyển đổi số)
            request.setAttribute("errorMessage", "Invalid number format: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/CreateOrder.jsp").forward(request, response);
        }
    }

    private double getDishPrice(int dishId) throws SQLException, ClassNotFoundException {
        // Logic để lấy giá món ăn từ database dựa trên dishId
        // (Ví dụ: SELECT Price FROM Dish WHERE DishId = ?)
        String sql = "SELECT DishPrice FROM Dish WHERE DishId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, dishId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("DishPrice");
            }
        }
        return 0.0; // Giá mặc định nếu không tìm thấy
    }

    private String getDishName(int dishId) throws SQLException, ClassNotFoundException {
        // Logic để lấy tên món ăn từ database dựa trên dishId
        String sql = "SELECT DishName FROM Dish WHERE DishId = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, dishId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("DishName");
            }
        }
        return null; // Giá mặc định nếu không tìm thấy
    }
}