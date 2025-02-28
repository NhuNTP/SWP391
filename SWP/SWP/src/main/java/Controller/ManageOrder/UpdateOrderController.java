/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageOrder;

import DAO.OrderDAO;
import Model.Order;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HuynhPhuBinh
 */
@WebServlet("/UpdateOrder")
public class UpdateOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = null; 
        try {
            order = orderDAO.getOrderById(orderId);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("order", order);
        request.getRequestDispatcher("/ManageOrder/UpdateOrder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String orderDateStr = request.getParameter("orderDate");
        String orderStatus = request.getParameter("orderStatus");
        String orderType = request.getParameter("orderType");
        String orderDescription = request.getParameter("orderDescription");
        int couponId = Integer.parseInt(request.getParameter("couponId"));
        int tableId = Integer.parseInt(request.getParameter("tableId"));

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date orderDate = null;
        try {
            orderDate = formatter.parse(orderDateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Order order = new Order();
        order.setOrderId(orderId);
        order.setUserId(userId);
        order.setCustomerId(customerId);
        order.setOrderDate(orderDate);
        order.setOrderStatus(orderStatus);
        order.setOrderType(orderType);
        order.setOrderDescription(orderDescription);
        order.setCouponId(couponId);
        order.setTableId(tableId);

        boolean success = false;
        try {
            success = orderDAO.updateOrder(order);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateOrderController.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (success) {
            response.sendRedirect("ViewOrderListController");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
            request.getRequestDispatcher("Manage/UpdateOrder.jsp").forward(request, response);
        }
    }
}
