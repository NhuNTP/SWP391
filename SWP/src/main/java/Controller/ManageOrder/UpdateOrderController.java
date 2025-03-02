/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy orderId từ request
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            // 2. Gọi DAO để lấy order từ database
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            // 3. Lấy danh sách OrderStatus và OrderType
            List<String> orderStatuses = orderDAO.getAllOrderStatuses();
            List<String> orderTypes = orderDAO.getAllOrderTypes();

            // 4. Gửi order và danh sách OrderStatus/OrderType đến trang JSP
            request.setAttribute("order", order);
            request.setAttribute("orderStatuses", orderStatuses);
            request.setAttribute("orderTypes", orderTypes);

            // 5. Hiển thị form chỉnh sửa order
            request.getRequestDispatcher("ManageOrder/UpdateOrder.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Error retrieving order: " + ex.getMessage());
            request.getRequestDispatcher("Manage/ViewOrderList").forward(request, response); // Quay lại trang danh sách với thông báo lỗi
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ request
            int orderId = Integer.parseInt(request.getParameter("orderId"));
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
            response.sendRedirect("ViewOrderList");

        } 
         catch (ParseException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Invalid date format: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/UpdateOrder.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Invalid number format: " + ex.getMessage());
            request.getRequestDispatcher("ManageOrder/UpdateOrder.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
