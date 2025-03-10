package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.Inventory;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/addnewdish")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 100)    // 100MB
public class AddNewDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private static final String UPLOAD_DIRECTORY = "images";
    private static final Logger LOGGER = Logger.getLogger(AddNewDishController.class.getName());

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");

    List<Inventory> inventoryList = menuDAO.getAllInventory();
    if (inventoryList != null && !inventoryList.isEmpty()) {
        LOGGER.info("Inventory list retrieved with " + inventoryList.size() + " items.");
        request.setAttribute("inventoryList", inventoryList);
    } else {
        LOGGER.warning("Inventory list is null or empty.");
        request.setAttribute("errorMessage", "No inventory items available.");
    }
    RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/AddNewDish.jsp");
    dispatcher.forward(request, response);
}

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("text/html;charset=UTF-8");

    String dishName = request.getParameter("dishName");
    String dishType = request.getParameter("dishType");
    String dishPriceStr = request.getParameter("dishPrice");
    String dishDescription = request.getParameter("dishDescription");

    double dishPrice;
    try {
        dishPrice = Double.parseDouble(dishPriceStr);
    } catch (NumberFormatException e) {
        request.getSession().setAttribute("errorMessage", "Invalid dish price format.");
        response.sendRedirect(request.getContextPath() + "/viewalldish");
        return;
    }

    boolean dishNameExists = menuDAO.dishNameExists(dishName);
    if (dishNameExists) {
        request.getSession().setAttribute("errorMessage", "Dish name already exists.");
        response.sendRedirect(request.getContextPath() + "/viewalldish");
        return;
    }

    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }

    String dishImage = null;
    try {
        Part filePart = request.getPart("dishImage");
        String fileName = filePart.getSubmittedFileName();
        if (fileName != null && !fileName.isEmpty()) {
            dishImage = UPLOAD_DIRECTORY + "/" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
        }
    } catch (Exception e) {
        request.getSession().setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/viewalldish");
        return;
    }

    Dish dish = new Dish();
    dish.setDishName(dishName);
    dish.setDishType(dishType);
    dish.setDishPrice(dishPrice);
    dish.setDishDescription(dishDescription);
    dish.setDishImage(dishImage);
    dish.setDishStatus("Available"); // Mặc định từ DB

    String newDishId = menuDAO.addDish(dish);
    if (newDishId != null) {
        String[] itemIds = request.getParameterValues("itemId");
        boolean hasError = false;

        if (itemIds != null && itemIds.length > 0) {
            for (String itemId : itemIds) {
                try {
                    String quantityParam = request.getParameter("quantityUsed" + itemId);
                    double quantityUsed = quantityParam != null && !quantityParam.isEmpty() ? Double.parseDouble(quantityParam) : 0;
                    if (quantityUsed > 0) {
                        DishInventory dishInventory = new DishInventory(newDishId, itemId, quantityUsed);
                        if (!menuDAO.addDishInventory(dishInventory)) {
                            hasError = true;
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    hasError = true;
                    break;
                }
            }
        }

        // Tự động cập nhật IngredientStatus
        menuDAO.updateIngredientStatus(newDishId);

        if (!hasError) {
            request.getSession().setAttribute("message", "Dish added successfully!");
        } else {
            request.getSession().setAttribute("errorMessage", "Dish added but some ingredients failed.");
        }
    } else {
        request.getSession().setAttribute("errorMessage", "Failed to add dish.");
    }
    response.sendRedirect(request.getContextPath() + "/viewalldish");
}
}
//ok