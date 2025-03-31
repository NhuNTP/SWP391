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
import java.util.Enumeration;

@WebServlet("/order")
public class CreateOrderController extends HttpServlet {

    private OrderDAO orderDAO;
    private TableDAO tableDAO;
    private MenuDAO menuDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        try {
            orderDAO = new OrderDAO();
            tableDAO = new TableDAO();
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
        if (action == null) {
            action = "listTables"; // Default action
        }
        try {
            switch (action) {
                case "listTables":
                case "selectTable": // Add this case to handle selectTable
                    listTables(request, response);
                    break;
                case "tableOverview":
                    showTableOverview(request, response);
                    break;
                case "selectDish":
                    selectDish(request, response);
                    break;
                case "cancelOrder":
                    cancelOrder(request, response);
                    break;
                case "completeOrder":
                    completeOrder(request, response);
                    break;
                case "addCustomer":
                    addCustomer(request, response);
                    break;
                case "selectCustomer":
                    selectCustomer(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        try {
            switch (action) {
                case "submitOrder":
                    submitOrder(request, response);
                    break;
                case "editDishQuantity":
                    editDishQuantity(request, response);
                    break;
                case "deleteDish":
                    deleteDish(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

// Trong listTables
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

// Trong showTableOverview
    private void showTableOverview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        if (tableId == null || tableId.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu mã bàn.");
            request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        String orderId = orderDAO.getOrderIdByTableId(tableId);
        Order order = orderId != null ? orderDAO.getOrderById(orderId) : (Order) session.getAttribute("tempOrder");

        // Initialize hasDishes with a default value of false
        boolean hasDishes = false;  // Khởi tạo giá trị mặc định là false

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

        // Assign the value to hasDishes based on the order's details
        if (order != null && order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
            hasDishes = true;
        }

        List<Customer> customers = customerDAO.getAllCustomers();
        Customer currentCustomer = order != null && order.getCustomerId() != null ? customerDAO.getCustomerById(order.getCustomerId()) : null;

        request.setAttribute("tableId", tableId);
        request.setAttribute("order", order);
        request.setAttribute("hasDishes", hasDishes);
        request.setAttribute("customers", customers);
        request.setAttribute("currentCustomer", currentCustomer);
        request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
    }

// Trong selectDish
    private void selectDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        if (tableId == null) {
            request.setAttribute("error", "Thiếu mã bàn.");
            request.getRequestDispatcher("ManageOrder/selectDish.jsp").forward(request, response);
            return;
        }
        List<Dish> dishes = menuDAO.getAvailableDishes();
        request.setAttribute("dishes", dishes);
        request.getRequestDispatcher("ManageOrder/selectDish.jsp").forward(request, response);
    }

    private void submitOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        if (tableId == null) {
            request.setAttribute("error", "Thiếu mã bàn.");
            request.getRequestDispatcher("ManageOrder/selectDish.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order == null) {
            request.setAttribute("error", "Không tìm thấy đơn hàng.");
            request.getRequestDispatcher("ManageOrder/selectDish.jsp").forward(request, response);
            return;
        }

        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("quantity_")) {
                String dishId = paramName.substring("quantity_".length());
                int quantity = Integer.parseInt(request.getParameter(paramName));
                if (quantity > 0) {
                    Dish dish = menuDAO.getDishById(dishId);
                    if (dish != null) {
                        OrderDetail detail = new OrderDetail();
                        detail.setOrderDetailId(orderDAO.generateNextOrderDetailId()); // Sinh ID mới
                        detail.setOrderId(order.getOrderId());
                        detail.setDishId(dishId);
                        detail.setQuantity(quantity);
                        detail.setSubtotal(dish.getDishPrice() * quantity);
                        detail.setDishName(dish.getDishName());

                        if (orderId == null) { // tempOrder
                            order.getOrderDetails().add(detail);
                            order.setTotal(order.getTotal() + detail.getSubtotal());
                        } else { // Đơn đã lưu trong DB
                            orderDAO.addOrderDetail(detail);
                            orderDAO.updateOrderTotal(order.getOrderId());
                        }
                    }
                }
            }
        }

        if (orderId == null) {
            session.setAttribute("tempOrder", order);
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void editDishQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String newQuantityParam = request.getParameter("newQuantity");
        String tableId = request.getParameter("tableId");
        int newQuantity = Integer.parseInt(newQuantityParam);

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            OrderDetail detail = order.getOrderDetails().stream()
                    .filter(d -> d.getOrderDetailId().equals(orderDetailId))
                    .findFirst().orElse(null);
            if (detail != null) {
                double dishPrice = menuDAO.getDishById(detail.getDishId()).getDishPrice();
                detail.setQuantity(newQuantity);
                detail.setSubtotal(newQuantity * dishPrice);
                order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());
                if (orderId != null) {
                    orderDAO.updateOrderDetailQuantity(orderDetailId, newQuantity);
                    orderDAO.updateOrder(order);
                } else {
                    session.setAttribute("tempOrder", order);
                }
            }
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void deleteDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String tableId = request.getParameter("tableId");

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            order.getOrderDetails().removeIf(d -> d.getOrderDetailId().equals(orderDetailId));
            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());
            if (orderId != null) {
                orderDAO.deleteOrderDetail(orderDetailId);
                orderDAO.updateOrder(order);
            } else {
                session.setAttribute("tempOrder", order);
            }
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("tempOrder");
        response.sendRedirect("order?action=listTables");
    }

    private void completeOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tableId = request.getParameter("tableId");
        if (tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing tableId");
            return;
        }

        HttpSession session = request.getSession();
        Order tempOrder = (Order) session.getAttribute("tempOrder");
        String orderId = null;
        try {
            orderId = orderDAO.getOrderIdByTableId(tableId);
            Order order = orderId != null ? orderDAO.getOrderById(orderId) : tempOrder;

            if (order == null || order.getOrderDetails() == null || order.getOrderDetails().isEmpty()) {
                response.sendRedirect("order?action=listTables");
                return;
            }

            // Calculate total before persisting
            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());

            // Persist the order (either create new or update existing)
            if (orderId == null) {
                orderDAO.CreateOrder(order);
                tableDAO.updateTableStatus(tableId, "Occupied");
            } else {
                order.setOrderStatus("Pending");
                orderDAO.updateOrder(order);
            }
            session.removeAttribute("tempOrder");

            // Calculate hasDishes
            boolean hasDishes = !order.getOrderDetails().isEmpty();
            System.out.println("completeOrder: hasDishes = " + hasDishes); // Log giá trị hasDishes
            request.setAttribute("hasDishes", hasDishes);  // Set hasDishes attribute
            System.out.println("completeOrder: hasDishes attribute set"); // Log sau khi set attribute
            request.setAttribute("tableId", tableId);  // Set tableId for consistent behavior

            // Forward to tableOverview.jsp, NOT listTables
            request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("error", "Lỗi khi hoàn tất đơn hàng: " + e.getMessage());
            request.setAttribute("tableId", tableId);
            request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
        }
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
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
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
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void addDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String dishId = request.getParameter("dishId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String tableId = request.getParameter("tableId");

        Order order = orderId != null ? orderDAO.getOrderById(orderId) : (Order) request.getSession().getAttribute("tempOrder");
        Dish dish = menuDAO.getDishById(dishId);

        if (order != null && dish != null) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderDetailId(orderDAO.generateNextOrderDetailId());
            detail.setOrderId(order.getOrderId());
            detail.setDishId(dishId);
            detail.setQuantity(quantity);
            detail.setSubtotal(dish.getDishPrice() * quantity);
            detail.setDishName(dish.getDishName());

            if (orderId != null) {
                orderDAO.addOrderDetail(detail);
            } else {
                order.getOrderDetails().add(detail);
                order.setTotal(order.getTotal() + detail.getSubtotal());
                request.getSession().setAttribute("tempOrder", order);
            }
            response.setContentType("text/plain");
            response.getWriter().write("Success");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order or dish");
        }
    }
}
