package Controller.ManageOrder;

import DAO.OrderDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/UpdateOrder")
public class UpdateOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
        try {
            // 1. Lấy dữ liệu từ request
            String orderId = request.getParameter("orderId"); //change to String
            String userIdStr = request.getParameter("userId");
            String customerIdStr = request.getParameter("customerId");
            String couponIdStr = request.getParameter("couponId");
            String tableIdStr = request.getParameter("tableId");

            // Correct way: Retain strings, validate if needed
            String userId = userIdStr;
            String customerId = customerIdStr;
            String couponId = couponIdStr;
            String tableId = tableIdStr;

            // Chuyển đổi chuỗi ngày thành đối tượng Date
            String orderDateString = request.getParameter("orderDate");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm"); // Định dạng phù hợp với datetime-local
            Date orderDate = dateFormat.parse(orderDateString);

            String orderStatus = request.getParameter("orderStatus");
            String orderType = request.getParameter("orderType");
            String orderDescription = request.getParameter("orderDescription");

            // 2. Tạo đối tượng Order
            Order order = new Order();
            order.setOrderId(orderId);  // Quan trọng: Set orderId để biết order nào cần update
            order.setUserId(userId);
            order.setCustomerId(customerId);
            order.setOrderDate(orderDate);
            order.setOrderStatus(orderStatus);
            order.setOrderType(orderType);
            order.setOrderDescription(orderDescription);
            order.setCouponId(couponId);
            order.setTableId(tableId);

            // 3. Gọi DAO để cập nhật order vào database
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.updateOrder(order);

            // Trả về một response để thông báo thành công hoặc lỗi
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
        }
    }
}