/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageOrder;

import DAO.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author HuynhPhuBinh
 */
@WebServlet("/UpdateStatus")
public class UpdateStatusController extends HttpServlet {
  @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String orderStatus = request.getParameter("orderStatus");

            System.out.println("Received orderId: " + orderId + ", orderStatus: " + orderStatus); // Debug log

            OrderDAO orderDAO = new OrderDAO();
            boolean updated = orderDAO.updateOrderStatus(orderId, orderStatus);

            System.out.println("Update status result: " + updated); // Debug log

            response.setContentType("text/plain");
            response.getWriter().write(updated ? "Success" : "Failed");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error");
        }
    }
}
