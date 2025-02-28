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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewalldish")
public class ViewAllDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Dish> dishList = menuDAO.getAllDishes();

        if (dishList != null) {
            request.setAttribute("dishList", dishList); // Set dishes as attribute

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/viewalldish.jsp"); // Forward to JSP
            dispatcher.forward(request, response);
        } else {
            // Handle error appropriately (e.g., display an error page)
            request.setAttribute("errorMessage", "Error retrieving dishes.  See server logs for details.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp"); // Create an error.jsp page
            dispatcher.forward(request, response);
        }
    }
}