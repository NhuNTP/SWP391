package Controller.ManageOrder;

import DAO.OrderDAO;
import DAO.TableDAO;
import Model.Account;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "KitchenOrderStatusController", urlPatterns = {"/kitchen"})
public class KitchenOrderStatusController extends HttpServlet {

    private OrderDAO orderDAO;
    private TableDAO tableDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        tableDAO = new TableDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !"Kitchen staff".equals(account.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            if (action == null || "list".equals(action)) {
                // Hiển thị danh sách đơn hàng Pending và Processing
                List<Order> pendingOrders = orderDAO.getPendingOrders();
                request.setAttribute("pendingOrders", pendingOrders);
                if (request.getRequestDispatcher("/ManageOrder/kitchendb.jsp") == null) {
                    throw new ServletException("JSP file /ManageOrder/kitchendb.jsp not found");
                }
                request.getRequestDispatcher("/ManageOrder/kitchendb.jsp").forward(request, response);
            } else if ("viewOrder".equals(action)) {
                // Xem chi tiết đơn hàng
                String orderId = request.getParameter("orderId");
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    request.setAttribute("order", order);
                    if (request.getRequestDispatcher("/ManageOrder/kitchenod.jsp") == null) {
                        throw new ServletException("JSP file /ManageOrder/kitchenod.jsp not found");
                    }
                    request.getRequestDispatcher("/ManageOrder/kitchenod.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException("Error processing GET request: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !"Kitchen staff".equals(account.getUserRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only Kitchen staff role can update order status");
            return;
        }

        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            if ("Pending".equals(order.getOrderStatus()) && "Processing".equals(newStatus)) {
                orderDAO.updateOrderStatus(orderId, "Processing");
            }  else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status transition");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/kitchen");
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException("Error updating order status: " + e.getMessage(), e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles kitchen staff order management";
    }
}