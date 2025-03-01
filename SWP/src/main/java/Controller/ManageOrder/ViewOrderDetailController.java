/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageOrder;

import DAO.OrderDAO;
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

        List<OrderDetail> orderDetails = null;
        // 1. Lấy orderId từ request
       int orderId = Integer.parseInt(request.getParameter("orderId"));
        // 2. Gọi DAO để lấy danh sách OrderDetail từ database
        OrderDAO orderDAO = new OrderDAO();
        try {
            orderDetails = orderDAO.getOrderDetailsByOrderId(orderId); // SỬA Ở ĐÂY
        } catch (SQLException ex) {
            Logger.getLogger(ViewOrderDetailController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewOrderDetailController.class.getName()).log(Level.SEVERE, null, ex);
        }
        // 3. Kiểm tra xem danh sách OrderDetail có null hoặc rỗng không
        if (orderDetails != null && !orderDetails.isEmpty()) {
            request.setAttribute("orderDetails", orderDetails); // Gửi danh sách OrderDetail
            // 4. Hiển thị trang chi tiết OrderDetail
            request.getRequestDispatcher("ManageOrder/ViewOrderDetail.jsp").forward(request, response);
            return; // Kết thúc nếu thành công
        }
        // Xử lý trường hợp không tìm thấy order detail (ví dụ: hiển thị thông báo lỗi)
        request.setAttribute("errorMessage", "No order details found for Order ID: " + orderId);
        request.getRequestDispatcher("ViewOrderList").forward(request, response);
    }
}