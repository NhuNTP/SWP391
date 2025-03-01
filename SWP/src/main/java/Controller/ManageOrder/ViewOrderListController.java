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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HuynhPhuBinh
 */
@WebServlet("/ViewOrderList")
public class ViewOrderListController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = null;
        try {
            orderList = orderDAO.getAllOrders();
        } catch (SQLException ex) {
            Logger.getLogger(ViewOrderListController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewOrderListController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("ManageOrder/ViewOrderList.jsp").forward(request, response);
    }
}
