package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
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
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/updatedish")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 100)    // 100MB
public class UpdateDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private static final String UPLOAD_DIRECTORY = "images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            // Fetch the dish details based on dishId
            Dish dish = menuDAO.getDishById(dishId);  // Use the method from DAO directly
            if (dish == null) {
                request.setAttribute("errorMessage", "Dish not found with ID: " + dishId);
                RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
                dispatcher.forward(request, response);
                return;
            }
            request.setAttribute("dish", dish);

            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/updatedish.jsp"); // Create updatedish.jsp
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Dish ID.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            String dishName = request.getParameter("dishName");
            String dishType = request.getParameter("dishType");
            double dishPrice = Double.parseDouble(request.getParameter("dishPrice"));
            String dishDescription = request.getParameter("dishDescription");
            String dishStatus = request.getParameter("dishStatus");  // Get dish status from form
            String ingredientStatus = request.getParameter("ingredientStatus"); // Get ingredient status from form


             // Handle image upload
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String dishImage = request.getParameter("oldDishImage"); // Keep the old image path by default
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
            dish.setDishStatus(dishStatus); // Set dish status
            dish.setIngredientStatus(ingredientStatus); // Set ingredient status



            boolean isUpdated = menuDAO.updateDish(dish);

            if (isUpdated) {
                request.getSession().setAttribute("message", "Dish updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update dish.");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid data provided.");
        }

        response.sendRedirect("viewalldish");
    }
}