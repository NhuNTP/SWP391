package Controller.ManageMenu;

import DAO.MenuDAO;
import Model.Dish;
import Model.DishInventory;
import Model.Inventory;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
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

        List<Inventory> inventoryList = menuDAO.getAllInventory(); // Call without try-catch

        if (inventoryList != null) {
            request.setAttribute("inventoryList", inventoryList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ManageMenu/addnewdish.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Error retrieving inventory. See server logs.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dishName = request.getParameter("dishName");
        String dishType = request.getParameter("dishType");
        double dishPrice = Double.parseDouble(request.getParameter("dishPrice"));
        String dishDescription = request.getParameter("dishDescription");

        // Check if dish name exists
        boolean dishNameExists = menuDAO.dishNameExists(dishName);
        if (dishNameExists) {
            request.getSession().setAttribute("errorMessage", "Dish name already exists. Please choose a different name.");  //Using seesion to pass message to avoid null atribute message
            response.sendRedirect("addnewdish");
            return; // Stop processing if dish name exists
        }

        // Xử lý upload ảnh
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;  // Đường dẫn tuyệt đối đến thư mục
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
            request.getSession().setAttribute("errorMessage", "Error uploading image: " + e.getMessage()); //Using seesion to pass message to avoid null atribute message
            response.sendRedirect("addnewdish");
            return;
        }

        Dish dish = new Dish(dishName, dishType, dishPrice, dishDescription, dishImage);
        int newDishId = menuDAO.addDish(dish); // Call without try-catch

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
                            request.getSession().setAttribute("errorMessage", "Error adding ingredient to dish. See server logs."); //Using seesion to pass message to avoid null atribute message
                            hasError = true;
                            break;
                        }

                    } catch (NumberFormatException e) {
                        // Xử lý lỗi nếu dữ liệu không hợp lệ
                        e.printStackTrace();
                        request.getSession().setAttribute("errorMessage", "Invalid quantity for an ingredient."); //Using seesion to pass message to avoid null atribute message
                        hasError = true;
                        break; // Thoát khỏi vòng lặp nếu có lỗi
                    }
                }
                if (!hasError){
                    request.getSession().setAttribute("message", "Dish added successfully!"); //Using seesion to pass message to avoid null atribute message
                }

            }
            else{
                request.getSession().setAttribute("message", "Dish added successfully but there are no ingredients added!"); //Using seesion to pass message to avoid null atribute message
            }

        } else {
            request.getSession().setAttribute("errorMessage", "Failed to add dish. See server logs."); //Using seesion to pass message to avoid null atribute message
        }
        response.sendRedirect("viewalldish"); // Redirect to viewalldishes after processing
    }
}