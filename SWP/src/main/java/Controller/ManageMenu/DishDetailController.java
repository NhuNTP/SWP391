package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.InventoryItem;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/dishdetail")
public class DishDetailController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private static final Logger LOGGER = Logger.getLogger(DishDetailController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            String dishId = request.getParameter("dishId");

            // Retrieve dish details
            Dish dish = menuDAO.getDishById(dishId);
            if (dish == null) {
                response.getWriter().write("<p class='alert alert-danger'>Dish not found.</p>");
                return;
            }

            // Retrieve dish ingredients
            List<DishInventory> dishIngredients = menuDAO.getDishIngredients(dishId);
            if (dishIngredients == null) {
                response.getWriter().write("<p class='alert alert-danger'>Error retrieving dish ingredients.</p>");
                LOGGER.log(Level.SEVERE, "Error retrieving dish ingredients for dishId: " + dishId);
                return;
            }

            // Retrieve inventory items for the ingredients
            List<InventoryItem> ingredients = new ArrayList<>();
            for (DishInventory dishInventory : dishIngredients) {
                InventoryItem inventoryItem = menuDAO.getInventoryItemById(dishInventory.getItemId());
                if (inventoryItem != null) {
                    ingredients.add(inventoryItem);
                } else {
                    LOGGER.log(Level.WARNING, "Inventory item not found for itemId: " + dishInventory.getItemId());
                    response.getWriter().write("<p class='alert alert-danger'>Error retrieving inventory item.</p>");
                    return;
                }
            }

            request.setAttribute("dish", dish);
            request.setAttribute("dishIngredients", dishIngredients);
            request.setAttribute("ingredients", ingredients);

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/DishDetail.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "An unexpected error occurred", e);
            response.getWriter().write("<p class='alert alert-danger'>An unexpected error occurred.</p>");
        }
    }
}
