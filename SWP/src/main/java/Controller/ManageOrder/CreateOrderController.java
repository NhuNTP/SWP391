/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageOrder;

import DAO.OrderDAO;
import Model.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HuynhPhuBinh
 */
@WebServlet("/CreateOrder")
public class CreateOrderController extends HttpServlet {
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Điều hướng đến trang CreateOrder.jsp
        request.getRequestDispatcher("/ManageOrder/CreateOrder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        int userId = Integer.parseInt(request.getParameter("userId"));
        String orderStatus = request.getParameter("orderStatus");
        String orderType = request.getParameter("orderType");
        String orderDescription = request.getParameter("orderDescription");
        
        // Kiểm tra giá trị null cho các giá trị có thể trống
        String customerIdStr = request.getParameter("customerId");
        String couponIdStr = request.getParameter("couponId");
        String tableIdStr = request.getParameter("tableId");

        Integer customerId = (customerIdStr != null && !customerIdStr.isEmpty()) ? Integer.valueOf(customerIdStr) : null;
        Integer couponId = (couponIdStr != null && !couponIdStr.isEmpty()) ? Integer.valueOf(couponIdStr) : null;
        Integer tableId = (tableIdStr != null && !tableIdStr.isEmpty()) ? Integer.valueOf(tableIdStr) : null;

        // Tạo đối tượng Order
        Order newOrder = new Order();
        newOrder.setUserId(userId);
        newOrder.setCustomerId(customerId != null ? customerId : 0);
        newOrder.setOrderDate(new Date()); 
        newOrder.setOrderStatus(orderStatus);
        newOrder.setOrderType(orderType);
        newOrder.setOrderDescription(orderDescription);
        newOrder.setCouponId(couponId != null ? couponId : 0);
        newOrder.setTableId(tableId != null ? tableId : 0);

        // Thêm vào database
        OrderDAO orderDAO = new OrderDAO();
        try {
            try {
                orderDAO.createOrder(newOrder);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(CreateOrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.sendRedirect("ViewOrderList");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating order: " + e.getMessage());
            request.getRequestDispatcher("/ManageOrder/CreateOrder.jsp").forward(request, response);
        }
    }
}