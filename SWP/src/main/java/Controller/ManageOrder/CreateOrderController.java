package Controller.ManageOrder;

import DAO.OrderDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/CreateOrder")
public class CreateOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

         response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 1. Lấy dữ liệu từ request (thông tin chung của Order)
            String userIdStr = request.getParameter("userId");
            String customerIdStr = request.getParameter("customerId");
            String couponIdStr = request.getParameter("couponId");
            String tableIdStr = request.getParameter("tableId");

            String userId = userIdStr;
            String customerId = customerIdStr;
            String couponId = couponIdStr;
            String tableId = tableIdStr;

            String orderDateString = request.getParameter("orderDate");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
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

            // 3. Gọi DAO để tạo Order mới và lấy orderId
            OrderDAO orderDAO = new OrderDAO();
            String orderId = orderDAO.generateNextOrderId();
            order.setOrderId(orderId);

            // 4. Gọi DAO để thêm order vào database
            orderDAO.CreateOrder(order); // Tạo Order mới
            response.getWriter().write("success");

        } catch (ParseException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
             response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
              response.getWriter().write("Invalid date format: " + ex.getMessage());

        } catch (SQLException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
             response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
               response.getWriter().write("Database error: " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
                 response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
               response.getWriter().write("Class not found: " + ex.getMessage());
        } finally {
             if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true); // Reset lại autoCommit
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
    }


}