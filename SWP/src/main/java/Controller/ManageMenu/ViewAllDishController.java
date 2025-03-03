package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewalldish")
public class ViewAllDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Dish> dishList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search for dishes based on the keyword
            dishList = menuDAO.searchDishes(keyword.trim());
        } else {
            // Retrieve all dishes if no keyword is provided
            dishList = menuDAO.getAllDishes();
        }

        if (dishList != null) {
            request.setAttribute("dishList", dishList); // Set dishes as attribute
        } else {
            // Handle error appropriately (e.g., display an error page)
            request.setAttribute("errorMessage", "Error retrieving dishes. See server logs for details.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/ManageMenu/viewalldish.jsp"); // Forward to JSP
        dispatcher.forward(request, response);
    }
}