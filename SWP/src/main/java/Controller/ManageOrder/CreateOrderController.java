package Controller.ManageOrder;

import DAO.TableDAO;
import DAO.OrderDAO;
import DAO.MenuDAO;
import DAO.CustomerDAO;
import Model.Account;
import Model.Table;
import Model.Order;
import Model.OrderDetail;
import Model.Dish;
import Model.Customer;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@WebServlet("/order")
public class CreateOrderController extends HttpServlet {

    private TableDAO tableDAO;
    private OrderDAO orderDAO;
    private MenuDAO menuDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        try {
            tableDAO = new TableDAO();
            orderDAO = new OrderDAO();
            menuDAO = new MenuDAO();
            customerDAO = new CustomerDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("doGet - Received action: " + action); // Debug
        if (action == null) {
            action = "listTables";
        }

        try {
            switch (action) {
                case "listTables":
                    listTables(request, response);
                    break;
                case "tableOverview":
                    showTableOverview(request, response);
                    break;
                case "selectDishes":
                    showDishSelection(request, response);
                    break;
                case "cancelOrder":
                    cancelOrder(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("doPost - Received action: " + action); // Debug
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action");
            return;
        }

        try {
            switch (action) {
                case "submitOrder":
                    submitOrder(request, response);
                    break;
                case "updateCustomer":
                    updateCustomer(request, response);
                    break;
                case "editDishQuantity":
                    editDishQuantity(request, response);
                    break;
                case "deleteDish":
                    deleteDish(request, response);
                    break;
                case "completeOrder":
                    completeOrder(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error in doPost: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format in doPost: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error in doPost: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    private void listTables(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || !account.getUserRole().equals("Waiter")) {
            response.sendRedirect("login");
            return;
        }
        List<Table> tables = tableDAO.getAllTables();
        if (tables == null) {
            tables = new ArrayList<>(); // Tránh NullPointerException
        }
        request.setAttribute("tables", tables);
        request.getRequestDispatcher("/ManageOrder/tableList.jsp").forward(request, response);
    }

    private void showTableOverview(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SQLException, ClassNotFoundException {
    String tableId = request.getParameter("tableId");
    if (tableId == null || tableId.trim().isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty tableId");
        return;
    }

    HttpSession session = request.getSession();
    Account account = (Account) session.getAttribute("account");
    if (account == null || !account.getUserRole().equals("Waiter")) {
        response.sendRedirect("login");
        return;
    }

    Table table = tableDAO.getTableById(tableId);
    if (table == null || (!table.getTableStatus().equals("Available") && orderDAO.getOrderIdByTableId(tableId) == null)) {
        response.sendRedirect("order?action=listTables");
        return;
    }

    String orderId = orderDAO.getOrderIdByTableId(tableId);
    Order order = orderId != null ? orderDAO.getOrderById(orderId) : null;
    Order tempOrder = (Order) session.getAttribute("tempOrder");

    boolean hasDishes = (order != null && order.getOrderDetails() != null && !order.getOrderDetails().isEmpty())
            || (tempOrder != null && tempOrder.getOrderDetails() != null && !tempOrder.getOrderDetails().isEmpty());

    // Debug
    System.out.println("showTableOverview - tableId: " + tableId);
    System.out.println("order: " + (order != null ? order.getOrderId() : "null"));
    System.out.println("tempOrder: " + (tempOrder != null ? tempOrder.getOrderId() : "null"));
    System.out.println("hasDishes: " + hasDishes);

    if (hasDishes) { // Sửa điều kiện: chỉ cần hasDishes là đủ
        List<Customer> customers = customerDAO.getAllCustomers();
        System.out.println("customers size: " + (customers != null ? customers.size() : "null"));
        request.setAttribute("customers", customers);
    }

    request.setAttribute("order", order);
    request.setAttribute("hasDishes", hasDishes);
    request.setAttribute("table", table);
    request.getRequestDispatcher("/ManageOrder/tableOverview.jsp").forward(request, response);
}

    private void showDishSelection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tableId = request.getParameter("tableId");
        if (tableId == null || tableId.trim().isEmpty()) {
            System.out.println("tableId is null or empty, redirecting to listTables");
            response.sendRedirect("order?action=listTables");
            return;
        }

        List<Dish> dishes = menuDAO.getAvailableDishes();
        if (dishes == null) {
            dishes = new ArrayList<>(); // Tránh NullPointerException
        }
        request.setAttribute("dishes", dishes);
        request.setAttribute("tableId", tableId);
        request.getRequestDispatcher("/ManageOrder/dishSelection.jsp").forward(request, response);
    }

    private void submitOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");
        String[] dishIds = request.getParameterValues("dishId");
        String[] quantities = request.getParameterValues("quantity");

        if (tableId == null || dishIds == null || quantities == null || dishIds.length != quantities.length) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or mismatched parameters");
            return;
        }

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        Order order = (Order) session.getAttribute("tempOrder");
        boolean isNewOrder = false;

        if (order == null) {
            order = new Order();
            order.setOrderId(orderDAO.generateNextOrderId());
            order.setUserId(account.getUserId());
            order.setTableId(tableId);
            order.setOrderStatus("Pending");
            order.setOrderType("Dine-in");
            order.setOrderDate(new Date());
            order.setTotal(0);
            order.setOrderDetails(new ArrayList<>());
            isNewOrder = true;
        } else if (orderId != null && !orderId.trim().isEmpty() && !orderId.equals("null")) {
            Order dbOrder = orderDAO.getOrderById(orderId);
            if (dbOrder != null) {
                order = dbOrder;
                isNewOrder = false;
            }
        }

        List<Dish> dishes = menuDAO.getAvailableDishes();
        if (dishes == null) {
            dishes = new ArrayList<>(); // Tránh NullPointerException
        }

        for (int i = 0; i < dishIds.length; i++) {
            try {
                int qty = Integer.parseInt(quantities[i].trim());
                if (qty > 0) {
                    String dishId = dishIds[i];
                    Dish dish = dishes.stream().filter(d -> d.getDishId().equals(dishId)).findFirst().orElse(null);
                    if (dish != null) {
                        OrderDetail detail = new OrderDetail();
                        detail.setOrderDetailId(orderDAO.generateNextOrderDetailId());
                        detail.setOrderId(order.getOrderId());
                        detail.setDishId(dish.getDishId());
                        detail.setQuantity(qty);
                        detail.setSubtotal(dish.getDishPrice() * qty);
                        detail.setDishName(dish.getDishName());
                        order.getOrderDetails().add(detail);
                        if (!isNewOrder) {
                            orderDAO.addOrderDetail(order.getOrderId(), detail);
                        }
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid quantity format for dishId " + dishIds[i] + ": " + e.getMessage());
                // Bỏ qua món này thay vì lỗi toàn bộ
            }
        }

        session.setAttribute("tempOrder", order);
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");
        String customerOption = request.getParameter("customerOption");

        if (tableId == null || customerOption == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        HttpSession session = request.getSession();
        Order order = orderId != null && !orderId.trim().isEmpty() ? orderDAO.getOrderById(orderId) : (Order) session.getAttribute("tempOrder");
        if (order == null || order.getOrderDetails() == null || order.getOrderDetails().isEmpty()) {
            response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
            return;
        }

        if ("existing".equals(customerOption)) {
            String customerId = request.getParameter("customerId");
            if (customerId != null && !customerId.trim().isEmpty()) {
                order.setCustomerId(customerId);
                if (orderId != null) {
                    orderDAO.updateOrderCustomer(orderId, customerId);
                }
            }
        } else if ("new".equals(customerOption)) {
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            if (customerName != null && !customerName.trim().isEmpty() && customerPhone != null && customerPhone.matches("\\d{10}")) {
                Customer customer = new Customer();
                customer.setCustomerId(customerDAO.generateNextCustomerId());
                customer.setCustomerName(customerName);
                customer.setCustomerPhone(customerPhone);
                customer.setNumberOfPayment(0);
                customerDAO.addCustomer(customer);
                order.setCustomerId(customer.getCustomerId());
                if (orderId != null) {
                    orderDAO.updateOrderCustomer(orderId, customer.getCustomerId());
                }
            }
        }

        session.setAttribute("tempOrder", order);
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void editDishQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String tableId = request.getParameter("tableId");
        String newQuantityStr = request.getParameter("newQuantity");

        if (orderDetailId == null || tableId == null || newQuantityStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try {
            int newQuantity = Integer.parseInt(newQuantityStr.trim());
            if (newQuantity > 0) {
                orderDAO.updateOrderDetailQuantity(orderDetailId, newQuantity);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid quantity format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity: " + newQuantityStr);
            return;
        }

        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void deleteDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String tableId = request.getParameter("tableId");

        if (orderDetailId == null || tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        HttpSession session = request.getSession();
        Order order = orderDAO.getOrderById(orderDAO.getOrderIdByTableId(tableId));
        if (order != null) {
            orderDAO.deleteOrderDetail(orderDetailId);
        } else {
            Order tempOrder = (Order) session.getAttribute("tempOrder");
            if (tempOrder != null && tempOrder.getOrderDetails() != null) {
                tempOrder.getOrderDetails().removeIf(detail -> detail.getOrderDetailId().equals(orderDetailId));
                session.setAttribute("tempOrder", tempOrder);
            }
        }

        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void completeOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        if (tableId == null || tableId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing tableId");
            return;
        }

        HttpSession session = request.getSession();
        Order tempOrder = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        Order order = orderId != null ? orderDAO.getOrderById(orderId) : tempOrder;

        if (order == null || order.getOrderDetails() == null || order.getOrderDetails().isEmpty()) {
            response.sendRedirect("order?action=listTables");
            return;
        }

        if (orderId == null) {
            orderDAO.CreateOrder(order);
            for (OrderDetail detail : order.getOrderDetails()) {
                orderDAO.addOrderDetail(order.getOrderId(), detail);
            }
            tableDAO.updateTableStatus(tableId, "Occupied");
        } else {
            order.setOrderStatus("Pending");
            orderDAO.updateOrder(order);
        }
        session.removeAttribute("tempOrder");
        response.sendRedirect("order?action=listTables");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("tempOrder");
        response.sendRedirect("order?action=listTables");
    }
}