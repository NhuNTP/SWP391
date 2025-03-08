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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/CreateOrder")
public class CreateOrderController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CreateOrderController.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Get data from request
            String userId = request.getParameter("userId");
            String customerId = request.getParameter("customerId");
            String couponId = request.getParameter("couponId");
            String tableId = request.getParameter("tableId");
            String orderDateString = request.getParameter("orderDate");
            String orderStatus = request.getParameter("orderStatus");
            String orderType = request.getParameter("orderType");
            String orderDescription = request.getParameter("orderDescription");

            logger.log(Level.INFO, "Received parameters: userId={0}, customerId={1}, orderDate={2}, orderStatus={3}, orderType={4}, orderDescription={5}, couponId={6}, tableId={7}",
                    new Object[]{userId, customerId, orderDateString, orderStatus, orderType, orderDescription, couponId, tableId});

            // 2. Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date orderDate = null;
            try {
                orderDate = dateFormat.parse(orderDateString);
            } catch (ParseException e) {
                logger.log(Level.SEVERE, "Error parsing date: " + orderDateString, e);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); //400
                response.getWriter().write("Invalid date format.  Please use yyyy-MM-ddTHH:mm");
                return; // Stop further processing
            }

            // 3. Create Order object
            Order order = new Order();
            order.setUserId(userId);
            order.setCustomerId(customerId);
            order.setOrderDate(orderDate);
            order.setOrderStatus(orderStatus);
            order.setOrderType(orderType);
            order.setOrderDescription(orderDescription);
            order.setCouponId(couponId);
            order.setTableId(tableId);

            // 4. Call DAO to create the order
            OrderDAO orderDAO = new OrderDAO();
            String orderId = orderDAO.generateNextOrderId();
            order.setOrderId(orderId);

            try {
                orderDAO.CreateOrder(order);
                logger.log(Level.INFO, "Order created successfully with orderId={0}", orderId);
                response.getWriter().write("success");
            } catch (SQLException | ClassNotFoundException e) {
                logger.log(Level.SEVERE, "Error creating order in database", e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
                response.getWriter().write("Database error: " + e.getMessage());
            }

        } catch (Exception e) {  // Catch any other exceptions for robustness
            logger.log(Level.SEVERE, "Unexpected error in CreateOrderController", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An unexpected error occurred: " + e.getMessage());
        }
    }
}