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

        response.setContentType("text/html;charset=UTF-8"); // Important for AJAX

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            Dish dish = menuDAO.getDishById(dishId);  // Use the method from DAO directly

            if (dish == null) {
                response.getWriter().write("<p>Dish not found with ID: " + dishId + "</p>"); // Send error message
                return;
            }
            request.setAttribute("dish", dish);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/updatedish.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.getWriter().write("<p>Invalid Dish ID.</p>"); // Send error message
        }  catch (Exception e) {
            Logger.getLogger(UpdateDishController.class.getName()).log(Level.SEVERE, null, e);
            response.getWriter().write("<p>An unexpected error occurred.</p>"); // Send generic error
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            String dishName = request.getParameter("dishName");
            String dishType = request.getParameter("dishType");
            double dishPrice = Double.parseDouble(request.getParameter("dishPrice"));
            String dishDescription = request.getParameter("dishDescription");
            String dishStatus = request.getParameter("dishStatus");
            String ingredientStatus = request.getParameter("ingredientStatus");

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
            dish.setDishStatus(dishStatus);
            dish.setIngredientStatus(ingredientStatus);

            boolean isUpdated = menuDAO.updateDish(dish);

            if (isUpdated) {
                response.getWriter().write("<p class='alert alert-success'>Dish updated successfully!</p>");
            } else {
                response.getWriter().write("<p class='alert alert-danger'>Failed to update dish.</p>");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("<p class='alert alert-danger'>Invalid data provided.</p>");
            Logger.getLogger(UpdateDishController.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception e) {
            response.getWriter().write("<p class='alert alert-danger'>An error occurred during update.</p>");
            Logger.getLogger(UpdateDishController.class.getName()).log(Level.SEVERE, null, e);
        }
    }
}