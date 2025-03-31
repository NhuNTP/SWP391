package Controller.ManageOrder;

import DAO.CustomerDAO;
import DAO.MenuDAO;
import DAO.OrderDAO;
import DAO.TableDAO;
import Model.Account;
import Model.Customer;
import Model.Dish;
import Model.Order;
import Model.OrderDetail;
import Model.Table;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrderController", urlPatterns = {"/orderold"})
public class OrderController extends HttpServlet {

    private final TableDAO tableDAO;
    private final MenuDAO dishDAO;
    private final OrderDAO orderDAO;
    private final CustomerDAO customerDAO;

    public OrderController() {
        this.tableDAO = new TableDAO();
        this.dishDAO = new MenuDAO();
        this.orderDAO = new OrderDAO();
        this.customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        String userRole = account.getUserRole();

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("selectTable")) {
                listTables(request, response);
            } else if (action.equals("tableOverview")) {
                showTableOverview(request, response);
            } else if (action.equals("viewOrder")) {
                viewOrder(request, response);
            } else if (action.equals("cancelOrder")) {
                cancelOrder(request, response);
            } else if (action.equals("completeOrder")) {
                completeOrder(request, response);
            } else if (action.equals("addCustomer")) {
                addCustomer(request, response);
            } else if (action.equals("selectCustomer")) {
                selectCustomer(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        String userRole = account.getUserRole();

        String action = request.getParameter("action");

        try {
            if (action.equals("submitOrder")) {
                submitOrder(request, response);
            } else if (action.equals("updateOrder")) {
                updateOrder(request, response);
            } else if (action.equals("addDish")) {
                addDish(request, response);
            } else if (action.equals("editDishQuantity")) {
                editDishQuantity(request, response);
            } else if (action.equals("deleteDish")) {
                deleteDish(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }

    private void listTables(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        List<Table> tables = tableDAO.getAllTables();
        for (Table table : tables) {
            boolean hasOrder = tableDAO.hasOrder(table.getTableId());
            table.setHasOrder(hasOrder);
        }
        request.setAttribute("tables", tables);
        request.getRequestDispatcher("ManageOrder/listTables.jsp").forward(request, response);
    }

    private void showTableOverview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        if (tableId == null || tableId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing tableId");
            return;
        }

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        String orderId = orderDAO.getOrderIdByTableId(tableId);
        Order order = orderId != null ? orderDAO.getOrderById(orderId) : (Order) session.getAttribute("tempOrder");

        if (order == null && orderId == null) {
            order = new Order();
            order.setOrderId(orderDAO.generateNextOrderId());
            order.setUserId(account.getUserId());
            order.setTableId(tableId);
            order.setOrderStatus("Pending");
            order.setOrderType("Dine-in");
            order.setOrderDate(new Date());
            order.setTotal(0);
            order.setOrderDetails(new ArrayList<>());
            session.setAttribute("tempOrder", order);
        }

        List<OrderDetail> orderDetails = (order != null && order.getOrderDetails() != null) ? order.getOrderDetails() : new ArrayList<>();
        boolean hasDishes = !orderDetails.isEmpty();

        // Lấy danh sách món để hiển thị trong tableOverview.jsp
        List<Dish> dishes = dishDAO.getAvailableDishes();

        // Lấy danh sách khách hàng để hiển thị trong dropdown
        List<Customer> customers = customerDAO.getAllCustomers();

        // Lấy thông tin khách hàng hiện tại (nếu có)
        Customer currentCustomer = null;
        if (order != null && order.getCustomerId() != null) {
            currentCustomer = customerDAO.getCustomerById(order.getCustomerId());
        }

        request.setAttribute("tableId", tableId);
        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("hasDishes", hasDishes);
        request.setAttribute("dishes", dishes);
        request.setAttribute("customers", customers);
        request.setAttribute("currentCustomer", currentCustomer);
        request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("orderold?action=selectTable");
            return;
        }
        List<OrderDetail> orderDetails = order.getOrderDetails();
        boolean hasDishes = orderDetails != null && !orderDetails.isEmpty();

        // Lấy danh sách món để hiển thị trong tableOverview.jsp
        List<Dish> dishes = dishDAO.getAvailableDishes();

        // Lấy danh sách khách hàng để hiển thị trong dropdown
        List<Customer> customers = customerDAO.getAllCustomers();

        // Lấy thông tin khách hàng hiện tại (nếu có)
        Customer currentCustomer = null;
        if (order.getCustomerId() != null) {
            currentCustomer = customerDAO.getCustomerById(order.getCustomerId());
        }

        request.setAttribute("tableId", order.getTableId());
        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("hasDishes", hasDishes);
        request.setAttribute("dishes", dishes);
        request.setAttribute("customers", customers);
        request.setAttribute("currentCustomer", currentCustomer);
        request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
    }

    private void submitOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        String[] dishIds = request.getParameterValues("dishId");
        String[] quantities = new String[dishIds != null ? dishIds.length : 0];

        if (dishIds != null) {
            for (int i = 0; i < dishIds.length; i++) {
                quantities[i] = request.getParameter("quantity_" + dishIds[i]);
            }
        }

        if (tableId == null || dishIds == null || quantities == null || dishIds.length != quantities.length) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or mismatched parameters");
            return;
        }

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);

        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

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
        }

        List<Dish> dishes = dishDAO.getAvailableDishes();
        if (dishes == null) {
            dishes = new ArrayList<>();
        }

        for (int i = 0; i < dishIds.length; i++) {
            try {
                int qty = Integer.parseInt(quantities[i].trim());
                if (qty > 0) {
                    String dishId = dishIds[i];
                    Dish dish = dishes.stream().filter(d -> d.getDishId().equals(dishId)).findFirst().orElse(null);
                    if (dish != null) {
                        OrderDetail existingDetail = order.getOrderDetails().stream()
                                .filter(d -> d.getDishId().equals(dishId))
                                .findFirst()
                                .orElse(null);

                        if (existingDetail != null) {
                            existingDetail.setQuantity(existingDetail.getQuantity() + qty);
                            existingDetail.setSubtotal(existingDetail.getQuantity() * dish.getDishPrice());
                        } else {
                            OrderDetail detail = new OrderDetail();
                            detail.setOrderId(order.getOrderId());
                            detail.setDishId(dish.getDishId());
                            detail.setQuantity(qty);
                            detail.setSubtotal(dish.getDishPrice() * qty);
                            detail.setDishName(dish.getDishName());
                            String orderDetailId = orderDAO.generateUniqueOrderDetailId();
                            detail.setOrderDetailId(orderDetailId);
                            order.getOrderDetails().add(detail);
                        }
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid quantity format for dishId " + dishIds[i] + ": " + e.getMessage());
            }
        }

        double total = order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum();
        order.setTotal(total);

        session.setAttribute("tempOrder", order);
        response.sendRedirect("orderold?action=tableOverview&tableId=" + tableId);
    }

    private void updateOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String customerPhone = request.getParameter("customerPhone");

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("orderold?action=selectTable");
            return;
        }

        order.setCustomerPhone(customerPhone);
        orderDAO.updateOrder(order);

        response.sendRedirect("orderold?action=viewOrder&orderId=" + orderId);
    }

    private void addDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String dishId = request.getParameter("dishId");
        String quantityParam = request.getParameter("quantity");

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order not found");
            return;
        }

        Dish dish = dishDAO.getDishById(dishId);
        if (dish == null || !"Available".equals(dish.getDishStatus()) || !"Sufficient".equals(dish.getIngredientStatus())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dish not available");
            return;
        }

        int quantity = Integer.parseInt(quantityParam);
        List<OrderDetail> orderDetails = order.getOrderDetails() != null ? order.getOrderDetails() : new ArrayList<>();
        OrderDetail existingDetail = orderDetails.stream()
                .filter(d -> d.getDishId().equals(dishId))
                .findFirst()
                .orElse(null);

        if (existingDetail != null) {
            existingDetail.setQuantity(existingDetail.getQuantity() + quantity);
            existingDetail.setSubtotal(dish.getDishPrice() * existingDetail.getQuantity());
        } else {
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            detail.setDishId(dishId);
            detail.setQuantity(quantity);
            detail.setSubtotal(dish.getDishPrice() * quantity);
            detail.setDishName(dish.getDishName());
            String orderDetailId = orderDAO.generateUniqueOrderDetailId();
            detail.setOrderDetailId(orderDetailId);
            orderDetails.add(detail);
        }

        order.setOrderDetails(orderDetails);
        orderDAO.updateOrder(order);

        response.setContentType("text/plain");
        response.getWriter().write("Success");
    }

    private void editDishQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String newQuantityParam = request.getParameter("newQuantity");
        String tableId = request.getParameter("tableId");

        int newQuantity = Integer.parseInt(newQuantityParam);
        if (newQuantity <= 0) {
            orderDAO.deleteOrderDetail(orderDetailId);
        } else {
            orderDAO.updateOrderDetailQuantity(orderDetailId, newQuantity);
        }

        response.sendRedirect("orderold?action=tableOverview&tableId=" + tableId);
    }

    private void deleteDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String tableId = request.getParameter("tableId");

        orderDAO.deleteOrderDetail(orderDetailId);
        response.sendRedirect("orderold?action=tableOverview&tableId=" + tableId);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("tempOrder");
        response.sendRedirect("orderold?action=selectTable");
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
            response.sendRedirect("orderold?action=selectTable");
            return;
        }

        for (OrderDetail detail : order.getOrderDetails()) {
            if (detail.getOrderDetailId() == null || detail.getOrderDetailId().isEmpty()) {
                String orderDetailId = orderDAO.generateUniqueOrderDetailId();
                detail.setOrderDetailId(orderDetailId);
            }
        }

        double total = order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum();
        order.setTotal(total);

        if (orderId == null) {
            orderDAO.CreateOrder(order);
            tableDAO.updateTableStatus(tableId, "Occupied");
        } else {
            order.setOrderStatus("Pending");
            orderDAO.updateOrder(order);
        }

        session.removeAttribute("tempOrder");
        response.sendRedirect("orderold?action=selectTable");
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");

        if (tableId == null || customerName == null || customerPhone == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);

        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            Customer customer = new Customer();
            customer.setCustomerName(customerName);
            customer.setCustomerPhone(customerPhone);
            String customerId = customerDAO.createCustomer(customer);
            order.setCustomerId(customerId);
            order.setCustomerPhone(customerPhone);
            if (orderId != null) {
                orderDAO.updateOrder(order);
            } else {
                session.setAttribute("tempOrder", order);
            }
        }

        response.sendRedirect("orderold?action=tableOverview&tableId=" + tableId);
    }

    private void selectCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        String customerId = request.getParameter("customerId");

        if (tableId == null || customerId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);

        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            Customer customer = customerDAO.getCustomerById(customerId);
            if (customer != null) {
                order.setCustomerId(customerId);
                order.setCustomerPhone(customer.getCustomerPhone());
                if (orderId != null) {
                    orderDAO.updateOrder(order);
                } else {
                    session.setAttribute("tempOrder", order);
                }
            }
        }

        response.sendRedirect("orderold?action=tableOverview&tableId=" + tableId);
    }
}