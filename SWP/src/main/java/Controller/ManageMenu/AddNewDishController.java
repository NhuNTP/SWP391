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
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 *
 * @author LxP
 */
@WebServlet("/addnewdish")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 100)    // 100MB
public class AddNewDishController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private static final String UPLOAD_DIRECTORY = "images"; // Thư mục lưu trữ ảnh (trong webapp)
    private static final Logger LOGGER = Logger.getLogger(AddNewDishController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Inventory> inventoryList = menuDAO.getAllInventory();
        if (inventoryList != null && !inventoryList.isEmpty()) {
            request.setAttribute("inventoryList", inventoryList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/addnewdish.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "No inventory items found or error retrieving inventory. See server logs.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dishName = request.getParameter("dishName");
        String dishType = request.getParameter("dishType");
        String dishPriceStr = request.getParameter("dishPrice"); // Get as String first
        String dishDescription = request.getParameter("dishDescription");
        String dishStatus = request.getParameter("dishStatus"); // Get dish status from form
        String ingredientStatus = request.getParameter("ingredientStatus"); // Get ingredient status from form

        double dishPrice;
        try {
            dishPrice = Double.parseDouble(dishPriceStr);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid dish price format. Please enter a valid number.");
            response.sendRedirect("addnewdish");
            return;
        }

        // Check if dish name exists
        boolean dishNameExists = menuDAO.dishNameExists(dishName);
        if (dishNameExists) {
            request.getSession().setAttribute("errorMessage", "Dish name already exists. Please choose a different name.");
            response.sendRedirect("addnewdish");
            return; // Stop processing if dish name exists
        }

        // Xử lý upload ảnh
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String dishImage = null;
        try {
            Part filePart = request.getPart("dishImage"); // Lấy file từ form
            String fileName = filePart.getSubmittedFileName();  // Lấy tên file
            if (fileName != null && !fileName.isEmpty()) {
                dishImage = UPLOAD_DIRECTORY + "/" + fileName;  // Lưu đường dẫn tương đối vào DB
                filePart.write(uploadPath + File.separator + fileName); // Lưu file lên server
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error uploading image: " + e.getMessage());
            response.sendRedirect("addnewdish");
            return;
        }

        Dish dish = new Dish(); // Use the no-argument constructor and set properties
        dish.setDishName(dishName);
        dish.setDishType(dishType);
        dish.setDishPrice(dishPrice);
        dish.setDishDescription(dishDescription);
        dish.setDishImage(dishImage);
        dish.setDishStatus(dishStatus);
        dish.setIngredientStatus(ingredientStatus);

        int newDishId;
        newDishId = menuDAO.addDish(dish);
        if (newDishId > 0) {
            // Lấy danh sách các nguyên liệu đã chọn
            String[] itemIds = request.getParameterValues("itemId");
            
            if (itemIds != null && itemIds.length > 0) {
                
                boolean hasError = false;
                
                // Lọc ra các itemId và quantityUsed hợp lệ
                List<Integer> validItemIds = Arrays.stream(itemIds)
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
                
                for (Integer itemId : validItemIds) {
                    try {
                        // Tìm quantity tương ứng với itemId
                        String quantityParam = request.getParameter("quantityUsed" + itemId);
                        if (quantityParam == null || quantityParam.isEmpty()) {
                            // Bỏ qua nếu không có quantity, người dùng có thể không nhập
                            continue;
                        }
                        int quantityUsed = Integer.parseInt(quantityParam);
                        
                        DishInventory dishInventory = new DishInventory();
                        dishInventory.setDishId(newDishId);
                        dishInventory.setItemId(itemId);
                        dishInventory.setQuantityUsed(quantityUsed);
                        
                        if (!menuDAO.addDishInventory(dishInventory)) {
                            LOGGER.log(Level.SEVERE, "Failed to add DishInventory for dishId: " + newDishId + ", itemId: " + itemId);
                            request.getSession().setAttribute("errorMessage", "Error adding ingredient to dish. See server logs.");
                            hasError = true;
                            break;
                        }
                        
                    } catch (NumberFormatException e) {
                        // Xử lý lỗi nếu dữ liệu không hợp lệ
                        e.printStackTrace();
                        request.getSession().setAttribute("errorMessage", "Invalid quantity for an ingredient.");
                        hasError = true;
                        break; // Thoát khỏi vòng lặp nếu có lỗi
                    }
                }
                if (!hasError) {
                    request.getSession().setAttribute("message", "Dish added successfully!");
                }
                
            } else {
                request.getSession().setAttribute("message", "Dish added successfully but there are no ingredients added!");
            }
            
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to add dish. See server logs.");
        }

        response.sendRedirect("viewalldish"); // Redirect to viewalldishes after processing
    }
}