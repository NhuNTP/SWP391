package Controller.ManagePayment;

import DAO.OrderDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/printBill")
public class PrintBillServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
                return;
            }
            
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }
            
            request.setAttribute("order", order);
            request.setAttribute("formattedDate", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getOrderDate()));
            request.getRequestDispatcher("/ManagePayment/printBill.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(PrintBillServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(PrintBillServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}