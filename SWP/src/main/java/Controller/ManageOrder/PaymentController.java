package Controller.ManageOrder;

import DAO.TableDAO;
import DAO.OrderDAO;
import DAO.CustomerDAO;
import DAO.CouponDAO;
import Model.Order;
import Model.Coupon;
import Model.Table;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {

    private OrderDAO orderDAO;
    private TableDAO tableDAO;
    private CustomerDAO customerDAO;
    private CouponDAO couponDAO;

    @Override
    public void init() throws ServletException {
        try {
            orderDAO = new OrderDAO();
            tableDAO = new TableDAO();
            customerDAO = new CustomerDAO();
            couponDAO = new CouponDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listOrders";
        }

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
        System.out.println("Action received: " + action);
        System.out.println("OrderId: " + request.getParameter("orderId"));
        System.out.println("TableId: " + request.getParameter("tableId"));
        System.out.println("CouponId: " + request.getParameter("couponId"));
        try {
            if ("payOrder".equals(action)) {
                payOrder(request, response);
            } else if ("payCash".equals(action)) {
                payCash(request, response);
            } else if ("payOnline".equals(action)) {
                payOnline(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            throw new ServletException("Error in doPost: " + e.getMessage(), e);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        List<Table> tables = tableDAO.getAllTables();
        for (Table table : tables) {
            Order order = orderDAO.getOrderByTableId(table.getTableId());
            table.setOrder(order);
        }
        request.setAttribute("tables", tables);
        request.getRequestDispatcher("/ManageOrder/orderPaymentList.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is missing");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        if ("Processing".equals(order.getOrderStatus())) {
            List<Coupon> coupons = couponDAO.getAvailableCoupons();
            request.setAttribute("coupons", coupons);
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/ManageOrder/paymentDetail.jsp").forward(request, response);
    }

    private void payOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");
        String couponId = request.getParameter("couponId");

        if (orderId == null || tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || !"Processing".equals(order.getOrderStatus())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order not valid for payment");
            return;
        }

        double totalBeforeDiscount = order.getTotal();
        double finalPrice = totalBeforeDiscount; // Khởi tạo FinalPrice

        if (couponId != null && !couponId.trim().isEmpty()) {
            Coupon coupon = couponDAO.getCouponById(couponId);
            if (coupon != null && coupon.getIsDeleted() == 0) {
                String query = "SELECT CASE WHEN ? > GETDATE() THEN 1 ELSE 0 END AS isValid";
                try (Connection conn = couponDAO.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setDate(1, new java.sql.Date(coupon.getExpirationDate().getTime()));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt("isValid") == 1) {
                        BigDecimal discount = coupon.getDiscountAmount();
                        BigDecimal currentTotal = BigDecimal.valueOf(totalBeforeDiscount);
                        BigDecimal newTotal = currentTotal.subtract(discount).max(BigDecimal.ZERO);
                        finalPrice = newTotal.doubleValue(); // Gán FinalPrice
                        order.setCouponId(couponId);
                        couponDAO.incrementTimesUsed(couponId);
                        System.out.println("Applied coupon " + couponId + " with discount " + discount + ", FinalPrice: " + finalPrice);
                    } else {
                        System.out.println("Coupon " + couponId + " is expired");
                    }
                }
            }
        }

        order.setTotal(totalBeforeDiscount); // Giữ Total là giá gốc
        order.setFinalPrice(finalPrice);     // Lưu FinalPrice
        order.setOrderStatus("Completed");
        orderDAO.updateOrder(order);
        customerDAO.incrementNumberOfPayment(order.getCustomerId());
        tableDAO.updateTableStatus(tableId, "Available");

        List<Coupon> coupons = couponDAO.getAvailableCoupons();
        request.setAttribute("order", order);
        request.setAttribute("coupons", coupons);
        request.setAttribute("message", "Đơn hàng đã thanh toán. Tổng mới: " + order.getFinalPrice() + " VND"); // Hiển thị FinalPrice
        request.getRequestDispatcher("/ManageOrder/paymentDetail.jsp").forward(request, response);
    }

    private void payCash(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");
        String couponId = request.getParameter("couponId");

        System.out.println("payCash - OrderId: " + orderId + ", TableId: " + tableId + ", CouponId: " + couponId);

        if (orderId == null || tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || !"Processing".equals(order.getOrderStatus())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order not valid for payment");
            return;
        }

        double totalBeforeDiscount = order.getTotal();
        double finalPrice = totalBeforeDiscount; // Khởi tạo FinalPrice

        if (couponId != null && !couponId.trim().isEmpty()) {
            Coupon coupon = couponDAO.getCouponById(couponId);
            if (coupon != null && coupon.getIsDeleted() == 0) {
                boolean isValid = coupon.getExpirationDate() == null || coupon.getExpirationDate().after(new java.util.Date());
                if (isValid) {
                    BigDecimal discount = coupon.getDiscountAmount();
                    BigDecimal currentTotal = BigDecimal.valueOf(totalBeforeDiscount);
                    BigDecimal newTotal = currentTotal.subtract(discount).max(BigDecimal.ZERO);
                    finalPrice = newTotal.doubleValue(); // Gán FinalPrice
                    order.setCouponId(couponId);
                    couponDAO.incrementTimesUsed(couponId);
                    System.out.println("Applied coupon " + couponId + " with discount " + discount + ", FinalPrice: " + finalPrice);
                } else {
                    System.out.println("Coupon " + couponId + " is expired or invalid");
                }
            } else {
                System.out.println("Coupon " + couponId + " not found or deleted");
            }
        }

        order.setTotal(totalBeforeDiscount); // Giữ Total là giá gốc
        order.setFinalPrice(finalPrice);     // Lưu FinalPrice
        order.setOrderStatus("Completed");
        orderDAO.updateOrder(order);
        customerDAO.incrementNumberOfPayment(order.getCustomerId());
        tableDAO.updateTableStatus(tableId, "Available");

        response.sendRedirect("/printBill?orderId=" + orderId);
    }

    private void payOnline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        String tableId = request.getParameter("tableId");
        String couponId = request.getParameter("couponId");

        if (orderId == null || tableId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || !"Processing".equals(order.getOrderStatus())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order not valid for payment");
            return;
        }

        double totalBeforeDiscount = order.getTotal();
        double finalPrice = totalBeforeDiscount; // Khởi tạo FinalPrice

        if (couponId != null && !couponId.trim().isEmpty()) {
            Coupon coupon = couponDAO.getCouponById(couponId);
            if (coupon != null && coupon.getIsDeleted() == 0) {
                String query = "SELECT CASE WHEN ? > GETDATE() THEN 1 ELSE 0 END AS isValid";
                try (Connection conn = couponDAO.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setDate(1, new java.sql.Date(coupon.getExpirationDate().getTime()));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt("isValid") == 1) {
                        BigDecimal discount = coupon.getDiscountAmount();
                        BigDecimal currentTotal = BigDecimal.valueOf(totalBeforeDiscount);
                        BigDecimal newTotal = currentTotal.subtract(discount).max(BigDecimal.ZERO);
                        finalPrice = newTotal.doubleValue(); // Gán FinalPrice
                        order.setCouponId(couponId);
                        couponDAO.incrementTimesUsed(couponId);
                        System.out.println("Applied coupon " + couponId + " with discount " + discount + ", FinalPrice: " + finalPrice);
                    } else {
                        System.out.println("Coupon " + couponId + " is expired");
                    }
                }
            }
        }

        order.setTotal(totalBeforeDiscount); // Giữ Total là giá gốc
        order.setFinalPrice(finalPrice);     // Lưu FinalPrice
        order.setOrderStatus("Completed");
        orderDAO.updateOrder(order);
        customerDAO.incrementNumberOfPayment(order.getCustomerId());
        tableDAO.updateTableStatus(tableId, "Available");

        List<Coupon> coupons = couponDAO.getAvailableCoupons();
        request.setAttribute("order", order);
        request.setAttribute("coupons", coupons);
        request.setAttribute("message", "Thanh toán online thành công. Tổng mới: " + order.getFinalPrice() + " VNĐ"); // Hiển thị FinalPrice
        request.getRequestDispatcher("/ManageOrder/paymentDetail.jsp").forward(request, response);
    }
}