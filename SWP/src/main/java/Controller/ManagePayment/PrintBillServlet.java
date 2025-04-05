/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManagePayment;

import DAO.PaymentDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/printBill")
public class PrintBillServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
            return;
        }

        // Lấy dữ liệu từ PaymentDAO
        Order order = paymentDAO.getOrderForPrint(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        // Chuẩn bị dữ liệu cho JSP
        request.setAttribute("order", order);
        request.setAttribute("formattedDate", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getOrderDate()));

        // Chuyển hướng đến JSP
        request.getRequestDispatcher("/ManagePayment/printBill.jsp").forward(request, response);
    }
}