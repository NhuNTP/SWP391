package Controller.ManageMenu;

import DAO.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/deletedish")
public class DeleteDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));

            boolean isDeleted = menuDAO.deleteDish(dishId); // Soft delete

            if (isDeleted) {
                request.getSession().setAttribute("message", "Dish deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete dish.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Dish ID.");
        }

        response.sendRedirect("viewalldish");
    }
}