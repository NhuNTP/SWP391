package Controller.ManageOrder;

import DAO.CustomerDAO;
import DAO.MenuDAO;
import DAO.OrderDAO;
import DAO.TableDAO;
import DB.DBContext;
import Model.Account;
import Model.Customer;
import Model.Dish;
import Model.Order;
import Model.OrderDetail;
import Model.Table;
import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
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
                case "addCustomer":
                    addCustomer(request, response);
                    break;
                case "selectCustomer":
                    selectCustomer(request, response);
                    break;
                case "completeOrder":
                    completeOrder(request, response);
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
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (order == null || (orderId != null && !order.getOrderId().equals(orderId))) {
            order = orderId != null ? orderDAO.getOrderById(orderId) : new Order();
            if (order.getOrderId() == null) {
                order.setOrderId(orderDAO.generateNextOrderId());
                order.setUserId(account.getUserId());
                order.setTableId(tableId);
                order.setOrderStatus("Pending");
                order.setOrderType("Dine-in");
                order.setOrderDate(new Date());
                order.setTotal(0);
                order.setOrderDetails(new ArrayList<>());
            }
            session.setAttribute("tempOrder", order);
        }

        boolean hasDishes = order.getOrderDetails() != null && !order.getOrderDetails().isEmpty();
        List<Customer> customers = customerDAO.getAllCustomers();
        Customer currentCustomer = order.getCustomerId() != null ? customerDAO.getCustomerById(order.getCustomerId()) : null;

        List<Dish> dishes = menuDAO.getAvailableDishes();
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
                        order.getOrderDetails().add(detail);
                        order.setTotal(order.getTotal() + detail.getSubtotal());
                    }
                }
            }
        }

        if (orderId == null) {
            session.setAttribute("tempOrder", order);
        } else {
            // Cập nhật OrderDetail hiện có
            updateOrderDetail(order);
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void updateOrderDetail(Order order) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            ObjectMapper mapper = new ObjectMapper();
            String dishListJson = mapper.writeValueAsString(order.getOrderDetails());
            double total = order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum();

            String sql = "UPDATE OrderDetail SET DishList = ?, Total = ? WHERE OrderId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, dishListJson);
                stmt.setDouble(2, total);
                stmt.setString(3, order.getOrderId());
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    // Nếu không có bản ghi, chèn mới
                    String insertSql = "INSERT INTO OrderDetail (OrderDetailId, OrderId, DishList, Total) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, "OD" + order.getOrderId().substring(2));
                        insertStmt.setString(2, order.getOrderId());
                        insertStmt.setString(3, dishListJson);
                        insertStmt.setDouble(4, total);
                        insertStmt.executeUpdate();
                    }
                }
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw new SQLException("Error updating OrderDetail: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    private void editDishQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderDetailId = request.getParameter("orderDetailId");
        String dishId = request.getParameter("dishId");
        int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));
        String tableId = request.getParameter("tableId");

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            List<OrderDetail> details = order.getOrderDetails();
            OrderDetail detail = details.stream().filter(d -> d.getDishId().equals(dishId)).findFirst().orElse(null);
            if (detail != null) {
                double dishPrice = menuDAO.getDishById(dishId).getDishPrice();
                detail.setQuantity(newQuantity);
                detail.setSubtotal(newQuantity * dishPrice);
                order.setTotal(details.stream().mapToDouble(OrderDetail::getSubtotal).sum());
                if (orderId != null) {
                    updateOrderDetail(order);
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
        String dishId = request.getParameter("dishId");
        String tableId = request.getParameter("tableId");

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        String orderId = orderDAO.getOrderIdByTableId(tableId);
        if (order == null && orderId != null) {
            order = orderDAO.getOrderById(orderId);
        }

        if (order != null) {
            order.getOrderDetails().removeIf(d -> d.getDishId().equals(dishId));
            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());
            if (orderId != null) {
                updateOrderDetail(order);
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
            throws ServletException, IOException, SQLException, ClassNotFoundException {
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

            if (order == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng nào để hoàn tất.");
                request.setAttribute("tableId", tableId);
                request.setAttribute("dishes", menuDAO.getAvailableDishes());
                request.setAttribute("customers", customerDAO.getAllCustomers());
                request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
                return;
            }

            if (order.getOrderDetails() == null || order.getOrderDetails().isEmpty()) {
                request.setAttribute("error", "Không có món ăn nào trong đơn hàng. Vui lòng thêm món trước khi hoàn tất.");
                request.setAttribute("tableId", tableId);
                request.setAttribute("order", order);
                request.setAttribute("dishes", menuDAO.getAvailableDishes());
                request.setAttribute("customers", customerDAO.getAllCustomers());
                request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
                return;
            }

            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());

            if (orderId == null) {
                // Xóa OrderDetailId cũ trong tempOrder để tránh trùng lặp
                if (order.getOrderDetails() != null) {
                    for (OrderDetail detail : order.getOrderDetails()) {
                        detail.setOrderDetailId(null); // Đặt lại để CreateOrder tạo mới
                        System.out.println("Cleared OrderDetailId for: " + detail.getDishName());
                    }
                }
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
            request.setAttribute("order", tempOrder);
            request.setAttribute("dishes", menuDAO.getAvailableDishes());
            request.setAttribute("customers", customerDAO.getAllCustomers());
            request.getRequestDispatcher("ManageOrder/tableOverview.jsp").forward(request, response);
        }
    }

    private void selectCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        String customerId = request.getParameter("customerId");
        String orderId = request.getParameter("orderId");

        if (tableId == null || customerId == null || customerId.isEmpty()) {
            response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
            return;
        }

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        if (order == null || (orderId != null && !orderId.trim().isEmpty() && !order.getOrderId().equals(orderId))) {
            order = orderId != null && !orderId.trim().isEmpty() ? orderDAO.getOrderById(orderId) : null;
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
        }

        if (order != null) {
            Customer customer = customerDAO.getCustomerById(customerId);
            if (customer != null) {
                order.setCustomerId(customerId);
                order.setCustomerPhone(customer.getCustomerPhone());
                order.setCustomerName(customer.getCustomerName());
                if (orderId != null && !orderId.trim().isEmpty() && orderDAO.getOrderById(orderId) != null) {
                    orderDAO.updateOrder(order);
                }
                session.setAttribute("tempOrder", order);
                System.out.println("Customer assigned to order: " + order.getCustomerId());
            }
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String tableId = request.getParameter("tableId");
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String orderId = request.getParameter("orderId");

        if (tableId == null || customerName == null || customerPhone == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("tempOrder");
        if (order == null || (orderId != null && !orderId.trim().isEmpty() && !order.getOrderId().equals(orderId))) {
            order = orderId != null && !orderId.trim().isEmpty() ? orderDAO.getOrderById(orderId) : null;
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
        }

        if (order != null) {
            Customer customer = new Customer();
            customer.setCustomerName(customerName);
            customer.setCustomerPhone(customerPhone);
            String customerId = customerDAO.createCustomer(customer);
            order.setCustomerId(customerId);
            order.setCustomerPhone(customerPhone);
            order.setCustomerName(customerName);
            if (orderId != null && !orderId.trim().isEmpty() && orderDAO.getOrderById(orderId) != null) {
                orderDAO.updateOrder(order);
            }
            session.setAttribute("tempOrder", order);
        }
        response.sendRedirect("order?action=tableOverview&tableId=" + tableId);
    }

    private void addDish(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String dishId = request.getParameter("dishId");
        String quantityParam = request.getParameter("quantity");
        String tableId = request.getParameter("tableId");

        // Kiểm tra dữ liệu đầu vào
        if (dishId == null || quantityParam == null || tableId == null || tableId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu hoặc không hợp lệ tham số: dishId, quantity, tableId");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityParam);
            if (quantity <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng không hợp lệ: " + quantityParam);
            return;
        }

        HttpSession session = request.getSession(true);
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
            return;
        }

        Order order = (Order) session.getAttribute("tempOrder");
        if (order == null || (orderId != null && !orderId.trim().isEmpty() && !order.getOrderId().equals(orderId))) {
            order = orderId != null && !orderId.trim().isEmpty() ? orderDAO.getOrderById(orderId) : null;
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
                session.setAttribute("tempOrder", order);
            }
        }

        Dish dish = menuDAO.getDishById(dishId);
        if (dish == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Món ăn không tồn tại: " + dishId);
            return;
        }

        List<OrderDetail> details = order.getOrderDetails();
        OrderDetail existingDetail = details.stream()
                .filter(d -> d.getDishId().equals(dishId))
                .findFirst()
                .orElse(null);

        if (orderId != null && !orderId.trim().isEmpty() && orderDAO.getOrderById(orderId) != null) {
            // Đơn hàng đã tồn cố trong DB
            if (existingDetail != null) {
                // Cập nhật số lượng trong DB
                int newQuantity = existingDetail.getQuantity() + quantity;
                orderDAO.updateOrderDetailQuantity(existingDetail.getOrderDetailId(), newQuantity);
            } else {
                // Thêm mới OrderDetail vào DB
                OrderDetail detail = new OrderDetail();
                detail.setOrderId(order.getOrderId());
                detail.setDishId(dishId);
                detail.setQuantity(quantity);
                detail.setSubtotal(dish.getDishPrice() * quantity);
                detail.setDishName(dish.getDishName());
                orderDAO.addOrderDetail(detail);
            }
            orderDAO.updateOrderTotal(order.getOrderId());
        } else {
            // Đơn hàng chưa lưu vào DB (tempOrder)
            if (existingDetail != null) {
                existingDetail.setQuantity(existingDetail.getQuantity() + quantity);
                existingDetail.setSubtotal(existingDetail.getQuantity() * dish.getDishPrice());
            } else {
                OrderDetail detail = new OrderDetail();
                detail.setOrderId(order.getOrderId());
                detail.setDishId(dishId);
                detail.setQuantity(quantity);
                detail.setSubtotal(dish.getDishPrice() * quantity);
                detail.setDishName(dish.getDishName());
                details.add(detail);
            }
            order.setTotal(order.getOrderDetails().stream().mapToDouble(OrderDetail::getSubtotal).sum());
            session.setAttribute("tempOrder", order);
        }

        response.setContentType("text/plain");
        response.getWriter().write("Success");
    }
}
