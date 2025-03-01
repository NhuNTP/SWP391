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
            // 1. Lấy dữ liệu từ request
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

            // 5. Chuyển hướng về trang danh sách order (hoặc trang thông báo thành công)
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
}
