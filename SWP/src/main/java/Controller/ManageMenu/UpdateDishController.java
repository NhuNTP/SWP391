package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.InventoryItem;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/updatedish")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 100)
public class UpdateDishController extends HttpServlet {
    private final MenuDAO menuDAO = new MenuDAO();
    private static final String UPLOAD_DIRECTORY = "images";
    private static final Logger LOGGER = Logger.getLogger(UpdateDishController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String dishId = request.getParameter("dishId");
            Dish dish = menuDAO.getDishById(dishId);
            if (dish == null) {
                request.getSession().setAttribute("errorMessage", "Dish not found with ID: " + dishId);
                response.sendRedirect(request.getContextPath() + "/viewalldish");
                return;
            }
            List<DishInventory> dishIngredients = menuDAO.getDishIngredients(dishId);
            List<InventoryItem> inventoryList = menuDAO.getAllInventory();
            List<Dish> dishList = menuDAO.getAllDishes();

            request.setAttribute("dish", dish);
            request.setAttribute("dishIngredients", dishIngredients);
            request.setAttribute("inventoryList", inventoryList);
            request.setAttribute("dishList", dishList);

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/UpdateDish.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred.");
            response.sendRedirect(request.getContextPath() + "/viewalldish");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String dishId = request.getParameter("dishId");
            String dishName = request.getParameter("dishName");
            String dishType = request.getParameter("dishType");
            String dishPriceStr = request.getParameter("dishPrice");
            String dishDescription = request.getParameter("dishDescription");
            String dishStatus = request.getParameter("dishStatus");

            boolean hasError = false;

            // Kiểm tra dishName
            if (dishName == null || dishName.trim().isEmpty()) {
                request.setAttribute("dishNameError", "Dish name is required.");
                hasError = true;
            } else {
                List<Dish> existingDishes = menuDAO.getAllDishes();
                for (Dish d : existingDishes) {
                    if (d.getDishName().equalsIgnoreCase(dishName) && !d.getDishId().equals(dishId)) {
                        request.setAttribute("dishNameError", "Dish name '" + dishName + "' already exists.");
                        hasError = true;
                        break;
                    }
                }
            }

            // Kiểm tra dishType
            if (!"Food".equals(dishType) && !"Drink".equals(dishType)) {
                request.setAttribute("dishTypeError", "Dish type must be either 'Food' or 'Drink'.");
                hasError = true;
            }

            // Kiểm tra dishPrice
            double dishPrice = 0;
            try {
                dishPrice = Double.parseDouble(dishPriceStr);
                if (dishPrice <= 0) {
                    request.setAttribute("dishPriceError", "Price must be greater than 0.");
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("dishPriceError", "Price must be a valid number.");
                hasError = true;
            }

            // Xử lý upload ảnh
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String dishImage = request.getParameter("oldDishImage");
            Part filePart = request.getPart("dishImage");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                dishImage = UPLOAD_DIRECTORY + "/" + fileName;
                filePart.write(uploadPath + File.separator + fileName);
            }

            // Tạo đối tượng Dish
            Dish dish = new Dish();
            dish.setDishId(dishId);
            dish.setDishName(dishName);
            dish.setDishType(dishType);
            dish.setDishPrice(dishPrice);
            dish.setDishDescription(dishDescription);
            dish.setDishImage(dishImage);
            dish.setDishStatus(dishStatus);

            // Cập nhật món ăn
            boolean isUpdated = false;
            StringBuilder ingredientsError = new StringBuilder();

            if (!hasError) {
                isUpdated = menuDAO.updateDish(dish);

                // Xử lý nguyên liệu
                String[] itemIds = request.getParameterValues("itemId");
                if (itemIds != null) {
                    menuDAO.deleteDishInventory(dishId);
                    for (String itemId : itemIds) {
                        String quantityParam = request.getParameter("quantityUsed" + itemId);
                        if (quantityParam != null && !quantityParam.isEmpty()) {
                            try {
                                double quantityUsed = Double.parseDouble(quantityParam);
                                if (quantityUsed <= 0) {
                                    ingredientsError.append("Quantity for '")
                                            .append(menuDAO.getInventoryItemById(itemId).getItemName())
                                            .append("' must be greater than 0. ");
                                    hasError = true;
                                } else {
                                    DishInventory dishInventory = new DishInventory(dishId, itemId, quantityUsed);
                                    if (!menuDAO.addDishInventory(dishInventory)) {
                                        ingredientsError.append("Failed to add '")
                                                .append(menuDAO.getInventoryItemById(itemId).getItemName())
                                                .append("' due to an error. ");
                                        hasError = true;
                                    }
                                }
                            } catch (NumberFormatException e) {
                                ingredientsError.append("Invalid quantity for '")
                                        .append(menuDAO.getInventoryItemById(itemId).getItemName())
                                        .append("'. ");
                                hasError = true;
                            }
                        }
                    }
                } else {
                    request.setAttribute("ingredientsError", "Please select at least one ingredient.");
                    hasError = true;
                }

                // Cập nhật trạng thái nguyên liệu
                if (!hasError) {
                    menuDAO.updateIngredientStatus(dishId);
                }
            }

            // Xử lý kết quả
            request.setAttribute("dish", dish);
            request.setAttribute("dishIngredients", menuDAO.getDishIngredients(dishId));
            request.setAttribute("inventoryList", menuDAO.getAllInventory());
            request.setAttribute("dishList", menuDAO.getAllDishes());

            if (hasError) {
                if (ingredientsError.length() > 0) {
                    request.setAttribute("ingredientsError", ingredientsError.toString());
                }
                if (!isUpdated && !hasError) { // Nếu lỗi không phải từ validate mà từ update
                    request.setAttribute("generalError", "Failed to update dish due to a server error.");
                }
            } else {
                request.setAttribute("successMessage", "Dish updated successfully!");
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/UpdateDish.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost", e);
            request.setAttribute("generalError", "An unexpected error occurred during update.");
            forwardToJsp(request, response, request.getParameter("dishId"));
        }
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response, String dishId) throws ServletException, IOException {
        Dish dish = menuDAO.getDishById(dishId);
        request.setAttribute("dish", dish);
        request.setAttribute("dishIngredients", menuDAO.getDishIngredients(dishId));
        request.setAttribute("inventoryList", menuDAO.getAllInventory());
        request.setAttribute("dishList", menuDAO.getAllDishes());
        RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/UpdateDish.jsp");
        dispatcher.forward(request, response);
    }
}