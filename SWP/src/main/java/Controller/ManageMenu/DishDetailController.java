package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.Inventory;
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

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));

            // Retrieve dish details
            Dish dish = menuDAO.getDishById(dishId);
            if (dish == null) {
                request.setAttribute("errorMessage", "Dish not found.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Retrieve dish ingredients
            List<DishInventory> dishIngredients = menuDAO.getDishIngredients(dishId);
            if (dishIngredients == null) {
                 request.setAttribute("errorMessage", "Error retrieving dish ingredients. See server logs.");
                 RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Retrieve inventory items for the ingredients
            List<Inventory> ingredients = new ArrayList<>();
            for (DishInventory dishInventory : dishIngredients) {
                Inventory inventoryItem = menuDAO.getInventoryItemById(dishInventory.getItemId());
                if (inventoryItem != null) {
                    ingredients.add(inventoryItem);
                } else {
                    LOGGER.log(Level.WARNING, "Inventory item not found for itemId: " + dishInventory.getItemId());
                    request.setAttribute("errorMessage", "Error retrieving inventory item. See server logs.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            request.setAttribute("dish", dish);
            request.setAttribute("dishIngredients", dishIngredients);
            request.setAttribute("ingredients", ingredients);

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/dishdetail.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Dish ID.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
            dispatcher.forward(request, response);
        }
    }
}