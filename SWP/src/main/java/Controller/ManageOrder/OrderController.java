package Controller.ManageOrder;

import DAO.MenuDAO;
import DAO.OrderDAO;
import DAO.TableDAO;
import Model.Account;
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

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

    private final TableDAO tableDAO;
    private MenuDAO dishDAO = new MenuDAO();
    private OrderDAO orderDAO = new OrderDAO();

    public OrderController() {
        try {
            this.tableDAO = new TableDAO();
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Failed to initialize TableDAO", e);
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

        Account account = (Account) session.getAttribute("account");
        String userRole = account.getUserRole();

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("selectTable")) {
                List<Table> tables = tableDAO.getAllTables();
                request.setAttribute("tables", tables);
                request.getRequestDispatcher("ManageOrder/selectTable.jsp").forward(request, response);
            } else if (action.equals("selectDish")) {
                String tableId = request.getParameter("tableId");
                tableDAO.updateTableStatus(tableId, "Occupied");
                List<Dish> dishes = dishDAO.getAllDishes();
                request.setAttribute("dishes", dishes);
                request.setAttribute("tableId", tableId);
                request.getRequestDispatcher("ManageOrder/selectDish.jsp").forward(request, response);
            } else if (action.equals("viewOrder")) {
                String orderId = request.getParameter("orderId");
                Order order = orderDAO.getOrderById(orderId);
                if (order == null) {
                    response.sendRedirect("order?action=selectTable");
                    return;
                }
                request.setAttribute("order", order);
                request.setAttribute("dishes", dishDAO.getAllDishes());
                request.getRequestDispatcher("ManageOrder/orderDetail.jsp").forward(request, response);
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
        String userId = account.getUserId();
        String userRole = account.getUserRole();

        String action = request.getParameter("action");

        try {
            if (action.equals("createOrder")) {
                String tableId = request.getParameter("tableId");
                List<OrderDetail> orderDetails = new ArrayList<>();

                String[] dishIds = request.getParameterValues("dishId");
                if (dishIds != null) {
                    for (String dishId : dishIds) {
                        String quantityParam = request.getParameter("quantity_" + dishId);
                        if (quantityParam != null && !quantityParam.isEmpty() && Integer.parseInt(quantityParam) > 0) {
                            Dish dish = dishDAO.getDishById(dishId);
                            if (dish != null && "Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                                OrderDetail detail = new OrderDetail();
                                detail.setDishId(dish.getDishId());
                                detail.setQuantity(Integer.parseInt(quantityParam));
                                detail.setSubtotal(dish.getDishPrice() * detail.getQuantity());
                                detail.setDishName(dish.getDishName());
                                orderDetails.add(detail);
                            }
                        }
                    }
                }

                request.setAttribute("tableId", tableId);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("dishes", dishDAO.getAllDishes());
                request.getRequestDispatcher("ManageOrder/orderDetail.jsp").forward(request, response);
            } else if (action.equals("confirmOrder")) {
                String tableId = request.getParameter("tableId");
                String customerPhone = request.getParameter("customerPhone");
                String orderId = orderDAO.generateNextOrderId();
                List<OrderDetail> orderDetails = new ArrayList<>();

                String[] dishIds = request.getParameterValues("dishId");
                if (dishIds != null) {
                    for (String dishId : dishIds) {
                        String quantityParam = request.getParameter("quantity_" + dishId);
                        if (quantityParam != null && !quantityParam.isEmpty() && Integer.parseInt(quantityParam) > 0) {
                            Dish dish = dishDAO.getDishById(dishId);
                            if (dish != null && "Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                                OrderDetail detail = new OrderDetail();
                                detail.setOrderId(orderId);
                                detail.setDishId(dish.getDishId());
                                detail.setQuantity(Integer.parseInt(quantityParam));
                                detail.setSubtotal(dish.getDishPrice() * detail.getQuantity());
                                detail.setDishName(dish.getDishName());
                                orderDetails.add(detail);
                            }
                        }
                    }
                }

                String[] tempDishIds = request.getParameterValues("tempDishId");
                if (tempDishIds != null) {
                    for (String tempDishId : tempDishIds) {
                        String tempQuantity = request.getParameter("tempQuantity_" + tempDishId);
                        if (tempQuantity != null && !tempQuantity.isEmpty() && Integer.parseInt(tempQuantity) > 0) {
                            Dish dish = dishDAO.getDishById(tempDishId);
                            if (dish != null && "Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                                OrderDetail existingDetail = orderDetails.stream()
                                    .filter(d -> d.getDishId().equals(tempDishId))
                                    .findFirst()
                                    .orElse(null);
                                if (existingDetail != null) {
                                    existingDetail.setQuantity(existingDetail.getQuantity() + Integer.parseInt(tempQuantity));
                                    existingDetail.setSubtotal(dish.getDishPrice() * existingDetail.getQuantity());
                                } else {
                                    OrderDetail detail = new OrderDetail();
                                    detail.setOrderId(orderId);
                                    detail.setDishId(dish.getDishId());
                                    detail.setQuantity(Integer.parseInt(tempQuantity));
                                    detail.setSubtotal(dish.getDishPrice() * detail.getQuantity());
                                    detail.setDishName(dish.getDishName());
                                    orderDetails.add(detail);
                                }
                            }
                        }
                    }
                }

                Order order = new Order(orderId, userId, null, new Date(), "Pending", "Dine-in", null, null, tableId, orderDetails, customerPhone);
                orderDAO.CreateOrder(order);

                response.sendRedirect("order?action=viewOrder&orderId=" + orderId);
            } else if (action.equals("updateOrder")) {
                String orderId = request.getParameter("orderId");
                String customerPhone = request.getParameter("customerPhone");

                // Lấy Order hiện tại từ DB
                Order order = orderDAO.getOrderById(orderId);
                if (order == null) {
                    response.sendRedirect("order?action=selectTable");
                    return;
                }

                // Danh sách món mới từ form
                List<OrderDetail> orderDetails = new ArrayList<>();

                // Xử lý món hiện tại từ existingDishId
                String[] existingDishIds = request.getParameterValues("existingDishId");
                if (existingDishIds != null) {
                    for (String dishId : existingDishIds) {
                        String quantityParam = request.getParameter("existingQuantity_" + dishId);
                        if (quantityParam != null && !quantityParam.isEmpty() && Integer.parseInt(quantityParam) > 0) {
                            Dish dish = dishDAO.getDishById(dishId);
                            if (dish != null) {
                                OrderDetail detail = new OrderDetail();
                                detail.setOrderId(orderId);
                                detail.setDishId(dish.getDishId());
                                detail.setQuantity(Integer.parseInt(quantityParam));
                                detail.setSubtotal(dish.getDishPrice() * detail.getQuantity());
                                detail.setDishName(dish.getDishName());
                                orderDetails.add(detail);
                            }
                        }
                    }
                }

                // Xử lý món tạm thời từ tempDishId (ưu tiên số lượng từ temp nếu trùng)
                String[] tempDishIds = request.getParameterValues("tempDishId");
                if (tempDishIds != null) {
                    for (String tempDishId : tempDishIds) {
                        String tempQuantity = request.getParameter("tempQuantity_" + tempDishId);
                        if (tempQuantity != null && !tempQuantity.isEmpty() && Integer.parseInt(tempQuantity) > 0) {
                            Dish dish = dishDAO.getDishById(tempDishId);
                            if (dish != null && "Available".equals(dish.getDishStatus()) && "Sufficient".equals(dish.getIngredientStatus())) {
                                OrderDetail existingDetail = orderDetails.stream()
                                    .filter(d -> d.getDishId().equals(tempDishId))
                                    .findFirst()
                                    .orElse(null);
                                if (existingDetail != null) {
                                    // Nếu món đã tồn tại, dùng số lượng từ tempQuantity
                                    existingDetail.setQuantity(Integer.parseInt(tempQuantity));
                                    existingDetail.setSubtotal(dish.getDishPrice() * existingDetail.getQuantity());
                                } else {
                                    // Thêm món mới từ tempDishId
                                    OrderDetail detail = new OrderDetail();
                                    detail.setOrderId(orderId);
                                    detail.setDishId(dish.getDishId());
                                    detail.setQuantity(Integer.parseInt(tempQuantity));
                                    detail.setSubtotal(dish.getDishPrice() * detail.getQuantity());
                                    detail.setDishName(dish.getDishName());
                                    orderDetails.add(detail);
                                }
                            }
                        }
                    }
                }

                // Cập nhật Order với danh sách món mới và số điện thoại
                order.setOrderDetails(orderDetails);
                order.setCustomerPhone(customerPhone);
                orderDAO.updateOrder(order);

                response.sendRedirect("order?action=viewOrder&orderId=" + orderId);
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }
}