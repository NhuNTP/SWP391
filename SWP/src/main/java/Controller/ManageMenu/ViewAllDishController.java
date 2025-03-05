package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.Inventory;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewalldish")
public class ViewAllDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
 private static final Logger LOGGER = Logger.getLogger(AddNewDishController.class.getName());
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Dish> dishList = menuDAO.getAllDishes();
        List<Inventory> inventoryList = menuDAO.getAllInventory();

        LOGGER.log(Level.INFO, "Dish list size: " + (dishList != null ? dishList.size() : "null"));
        LOGGER.log(Level.INFO, "Inventory list size: " + (inventoryList != null ? inventoryList.size() : "null"));

        if (dishList == null) {
            request.setAttribute("errorMessage", "Failed to load dish list.");
        }
        if (inventoryList == null) {
            request.setAttribute("errorMessage", "Failed to load inventory list.");
        } else if (inventoryList.isEmpty()) {
            request.setAttribute("errorMessage", "No ingredients available in inventory.");
        }

        request.setAttribute("dishList", dishList);
        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/ManageMenu/viewalldish.jsp").forward(request, response);
    }
}
//ok