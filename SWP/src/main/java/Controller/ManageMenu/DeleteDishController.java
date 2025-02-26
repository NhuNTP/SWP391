package Controller.ManageMenu;

import DAO.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/deletedish")
public class DeleteDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId")); // Get dish ID from the request
            boolean isDeleted = menuDAO.deleteDish(dishId);

            if (isDeleted) {
                // Optionally, set a success message
                request.getSession().setAttribute("message", "Dish deleted successfully!");
            } else {
                // Optionally, set an error message
                request.getSession().setAttribute("errorMessage", "Failed to delete dish.");
            }

        } catch (NumberFormatException e) {
            // Handle invalid dishId (not an integer)
            request.getSession().setAttribute("errorMessage", "Invalid Dish ID.");
            Logger.getLogger(DeleteDishController.class.getName()).log(Level.SEVERE, null, e);
        }

        response.sendRedirect("viewalldish"); // Redirect back to the view all dishes page
    }
}