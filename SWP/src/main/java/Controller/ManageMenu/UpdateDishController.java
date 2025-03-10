package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.Inventory;
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
                response.getWriter().write("<p class='text-danger'>Dish not found with ID: " + dishId + "</p>");
                return;
            }
            List<DishInventory> dishIngredients = menuDAO.getDishIngredients(dishId);
            List<Inventory> inventoryList = menuDAO.getAllInventory();
            request.setAttribute("dish", dish);
            request.setAttribute("dishIngredients", dishIngredients);
            request.setAttribute("inventoryList", inventoryList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/UpdateDish.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            response.getWriter().write("<p class='text-danger'>An unexpected error occurred.</p>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String dishId = request.getParameter("dishId");
            String dishName = request.getParameter("dishName");
            String dishType = request.getParameter("dishType");
            double dishPrice = Double.parseDouble(request.getParameter("dishPrice"));
            String dishDescription = request.getParameter("dishDescription");
            String dishStatus = request.getParameter("dishStatus");

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

            Dish dish = new Dish();
            dish.setDishId(dishId);
            dish.setDishName(dishName);
            dish.setDishType(dishType);
            dish.setDishPrice(dishPrice);
            dish.setDishDescription(dishDescription);
            dish.setDishImage(dishImage);
            dish.setDishStatus(dishStatus);

            boolean isUpdated = menuDAO.updateDish(dish);
            StringBuilder errorMessage = new StringBuilder();

            String[] itemIds = request.getParameterValues("itemId");
            if (itemIds != null) {
                menuDAO.deleteDishInventory(dishId);
                for (String itemId : itemIds) {
                    String quantityParam = request.getParameter("quantityUsed" + itemId);
                    if (quantityParam != null && !quantityParam.isEmpty()) {
                        double quantityUsed = Double.parseDouble(quantityParam);
                        if (quantityUsed > 0) {
                            DishInventory dishInventory = new DishInventory(dishId, itemId, quantityUsed);
                            if (!menuDAO.addDishInventory(dishInventory)) {
                                errorMessage.append("Failed to add '")
                                        .append(menuDAO.getInventoryItemById(itemId).getItemName())
                                        .append("' due to an error. ");
                            }
                        }
                    }
                }
            }

            menuDAO.updateIngredientStatus(dishId);

            if (isUpdated && errorMessage.length() == 0) {
                response.getWriter().write("<p class='alert alert-success'>Dish updated successfully!</p>");
            } else if (isUpdated) {
                response.getWriter().write("<p class='alert alert-warning'>Dish updated, but some ingredients failed: " + errorMessage.toString() + "</p>");
            } else {
                response.getWriter().write("<p class='alert alert-danger'>Failed to update dish.</p>");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("<p class='alert alert-danger'>Invalid data provided.</p>");
            LOGGER.log(Level.SEVERE, "Invalid number format", e);
        } catch (Exception e) {
            response.getWriter().write("<p class='alert alert-danger'>An error occurred during update.</p>");
            LOGGER.log(Level.SEVERE, "Error in doPost", e);
        }
    }
}