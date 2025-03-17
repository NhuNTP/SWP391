package Controller.ManageOrder;

import DAO.TableDAO;
import DAO.OrderDAO;
import DAO.CustomerDAO;
import Model.Order;
import Model.Account;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {
    private OrderDAO orderDAO;
    private TableDAO tableDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        try {
            orderDAO = new OrderDAO();
            tableDAO = new TableDAO();
            customerDAO = new CustomerDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "listOrders";

        try {
            switch (action) {
                case "listOrders":
                    listOrders(request, response);
                    break;
                case "viewOrder":
                    viewOrder(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            throw new ServletException("Error in doGet: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("payOrder".equals(action)) {
                payOrder(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            throw new ServletException("Error in doPost: " + e.getMessage(), e);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
       /* HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || !account.getUserRole().equals("Cashier")) {
            response.sendRedirect("login");
            return;
       }
*/
        List<Order> orders = orderDAO.getOrdersByStatus("Pending");
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/ManageOrder/orderPaymentList.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId");
            return;
        }
/*
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || !account.getUserRole().equals("Cashier")) {
            response.sendRedirect("login");
            return;
        }
*/
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/ManageOrder/paymentDetail.jsp").forward(request, response);
    }

    private void payOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");

        if (orderId == null || tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order != null && "Pending".equals(order.getOrderStatus())) {
            order.setOrderStatus("Completed");
            orderDAO.updateOrder(order);
            customerDAO.incrementNumberOfPayment(order.getCustomerId());
            tableDAO.updateTableStatus(tableId, "Available");
        }

        response.sendRedirect("payment?action=listOrders");
    }
}