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

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "listTables";
        }
        try {
            switch (action) {
                case "listTables":
                case "selectTable":
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
            throw new ServletException("Database error: " + e.getMessage(), e);
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
                case "addDish":
                    addDish(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
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

    boolean hasDishes = order != null && order.getOrderDetails() != null && !order.getOrderDetails().isEmpty();
    List<Customer> customers = customerDAO.getAllCustomers();
    Customer currentCustomer = order != null && order.getCustomerId() != null ? customerDAO.getCustomerById(order.getCustomerId()) : null;

    // Kiểm tra danh sách món ăn
    List<Dish> dishes = menuDAO.getAvailableDishes();
    System.out.println("Dishes size: " + (dishes != null ? dishes.size() : "null"));
    if (dishes != null) {
        for (Dish dish : dishes) {
            System.out.println("Dish: " + dish.getDishName() + ", Status: " + dish.getDishStatus() + ", Ingredient: " + dish.getIngredientStatus());
        }
    }

    request.setAttribute("tableId", tableId);
    request.setAttribute("order", order);
    request.setAttribute("hasDishes", hasDishes);
    request.setAttribute("customers", customers);
    request.setAttribute("currentCustomer", currentCustomer);
    request.setAttribute("dishes", dishes);
    request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
}

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
        request.setAttribute("tableId", tableId);
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
            Account account = (Account) session.getAttribute("account");
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
                        detail.setOrderId(order.getOrderId());
                        detail.setDishId(dishId);
                        detail.setQuantity(quantity);
                        detail.setSubtotal(dish.getDishPrice() * quantity);
                        detail.setDishName(dish.getDishName());

                        if (orderId == null) {
                            order.getOrderDetails().add(detail);
                            order.setTotal(order.getTotal() + detail.getSubtotal());
                        } else {
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
                    .filter(d -> d.getOrderDetailId() != null && d.getOrderDetailId().equals(orderDetailId))
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
            order.getOrderDetails().removeIf(d -> d.getOrderDetailId() != null && d.getOrderDetailId().equals(orderDetailId));
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

            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());

            if (orderId == null) {
                orderDAO.CreateOrder(order);
                tableDAO.updateTableStatus(tableId, "Occupied");
            } else {
                order.setOrderStatus("Pending");
                orderDAO.updateOrder(order);
            }
            session.removeAttribute("tempOrder");

            response.sendRedirect("order?action=listTables");
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
    String quantityParam = request.getParameter("quantity");
    String tableId = request.getParameter("tableId");

    System.out.println("addDish - orderId: " + orderId + ", dishId: " + dishId + ", quantity: " + quantityParam + ", tableId: " + tableId);

    int quantity;
    try {
        quantity = Integer.parseInt(quantityParam);
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity: " + quantityParam);
        return;
    }

    if (tableId == null || tableId.trim().isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid tableId");
        return;
    }

    HttpSession session = request.getSession();
    Order order = null;
    if (orderId != null && !orderId.trim().isEmpty()) {
        order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order not found in database for orderId: " + orderId);
            return;
        }
    } else {
        order = (Order) session.getAttribute("tempOrder");
        if (order == null) {
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
                return;
            }
            // Kiểm tra tableId có tồn tại trong DB không
            Table table = tableDAO.getTableById(tableId);
            if (table == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid tableId: " + tableId + " does not exist in database");
                return;
            }
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
            System.out.println("Created new tempOrder: " + order.getOrderId());
        }
    }

    Dish dish = menuDAO.getDishById(dishId);
    System.out.println("Order: " + (order != null ? order.getOrderId() : "null"));
    System.out.println("Dish: " + (dish != null ? dish.getDishName() : "null"));

    if (order != null && dish != null) {
        OrderDetail detail = new OrderDetail();
        detail.setOrderId(order.getOrderId());
        detail.setDishId(dishId);
        detail.setQuantity(quantity);
        detail.setSubtotal(dish.getDishPrice() * quantity);
        detail.setDishName(dish.getDishName());

        if (orderId != null && !orderId.trim().isEmpty()) {
            orderDAO.addOrderDetail(detail);
            orderDAO.updateOrderTotal(order.getOrderId());
        } else {
            order.getOrderDetails().add(detail);
            order.setTotal(order.getTotal() + detail.getSubtotal());
            session.setAttribute("tempOrder", order);
        }
        response.setContentType("text/plain");
        response.getWriter().write("Success");
    } else {
        String errorMsg = "Invalid order or dish - Order: " + (order != null ? order.getOrderId() : "null") + 
                        ", Dish: " + (dish != null ? dish.getDishName() : "null");
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, errorMsg);
    }
}
}