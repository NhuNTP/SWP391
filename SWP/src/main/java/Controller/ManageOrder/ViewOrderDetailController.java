/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
// ViewOrderDetailController.java
package Controller.ManageOrder;

import DAO.OrderDAO;
import Model.Order;
import Model.OrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ViewOrderDetail")
public class ViewOrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy orderId từ request
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // 2. Gọi DAO để lấy Order
        OrderDAO orderDAO = new OrderDAO();
        Order order = null;
        try {
            order = orderDAO.getOrderById(orderId);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewOrderDetailController.class.getName()).log(Level.SEVERE, null, ex);
        }

        // 3. Kiểm tra xem Order có null không
        if (order == null) {
            request.setAttribute("errorMessage", "Order not found");
            request.getRequestDispatcher("ViewOrderList").forward(request, response);
            return;
        }

        // 4. Lấy danh sách OrderDetail từ Order (đã được lấy trong getOrderById)
        List<OrderDetail> orderDetails = order.getOrderDetails();

        // 5. Gửi Order và OrderDetails đến view
        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("ManageOrder/ViewOrderDetail.jsp").forward(request, response);
        
        
    }
    
}