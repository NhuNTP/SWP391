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
    private static final Logger LOGGER = Logger.getLogger(DeleteDishController.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));

            boolean isDeleted = menuDAO.deleteDish(dishId);

            if (isDeleted) {
                response.getWriter().write("<p class='alert alert-success'>Dish deleted successfully!</p>");
            } else {
                response.getWriter().write("<p class='alert alert-danger'>Failed to delete dish. See server logs.</p>");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("<p class='alert alert-danger'>Invalid Dish ID.</p>");
            LOGGER.log(Level.SEVERE, "Invalid dish ID format", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "An unexpected error occurred", e);
            response.getWriter().write("<p class='alert alert-danger'>An unexpected error occurred.</p>");
        }
    }
}