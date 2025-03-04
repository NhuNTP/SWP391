/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageInventory;

import DAO.InventoryDAO;
import Model.Inventory;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 *
 * @author DELL-Laptop
 */
@WebServlet(name = "AddInventoryItemController", urlPatterns = {"/AddInventoryItemController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 100)   // 100MB
public class AddInventoryItemController extends HttpServlet {

//    private static final String UPLOAD_DIR = "ManageInventory/item_images"; // Thư mục lưu trữ hình ảnh (trong web app)
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddInventoryItemController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddInventoryItemController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            // 1. Lấy dữ liệu từ form (giữ nguyên)
            String itemName = request.getParameter("itemName");
            String itemType = request.getParameter("itemType");
            double itemPrice = Double.parseDouble(request.getParameter("itemPrice"));
            int itemQuantity = Integer.parseInt(request.getParameter("itemQuantity"));
            String itemUnit = request.getParameter("itemUnit");
            String itemDescription = request.getParameter("itemDescription");

            // 2. Xử lý upload hình ảnh
            Part filePart = request.getPart("itemImage");
            String relativeImagePath = null; // Khởi tạo relativeImagePath là null

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                // Hình ảnh đã được chọn và tải lên

                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
                    fileExtension = fileName.substring(dotIndex);
                }

                // Lấy tên hình ảnh người dùng nhập (nếu có)
                String userImageName = request.getParameter("imageName");
                String uniqueFileName;

                if (userImageName != null && !userImageName.trim().isEmpty()) {
                    String sanitizedImageName = userImageName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
                    uniqueFileName = sanitizedImageName + fileExtension; // Sử dụng tên người dùng, bỏ UUID prefix (nếu bạn muốn)
                } else {
                    uniqueFileName = UUID.randomUUID().toString() + "_" + fileName; // Sử dụng UUID + tên file gốc
                }

                // 3. Tạo đường dẫn lưu trữ hình ảnh (giữ nguyên phần đường dẫn)
                String webAppRoot = getServletContext().getRealPath("/");
                File webAppRootDir = new File(webAppRoot);
                File targetDir = webAppRootDir.getParentFile();
                File projectRootDir = targetDir.getParentFile();
                String srcWebAppPath = new File(projectRootDir, "src/main/webapp").getAbsolutePath();
                String relativePath = "ManageInventory/item_images";
                String uploadPath = srcWebAppPath + File.separator + relativePath;
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 4. Xử lý tên file an toàn
                String filePath = uploadPath + File.separator + uniqueFileName;
                relativeImagePath = "ManageInventory/item_images/" + uniqueFileName; // Cập nhật relativeImagePath ở đây

                // Lưu file
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File saved successfully to: " + filePath);
                }

            } else {
                // Không có hình ảnh nào được chọn
                relativeImagePath = null; // Đặt relativeImagePath thành null khi không có hình ảnh
                System.out.println("No image uploaded for item: " + itemName); // Log để theo dõi
            }

            // 5. Thêm vào database
            
            InventoryDAO inventoryDAO = new InventoryDAO();
            String itemID=inventoryDAO.generateNextInventoryId();
            Inventory newItem = new Inventory(itemID,itemName, itemType, itemPrice, itemQuantity, itemUnit, itemDescription);
            inventoryDAO.addNewInventoryItem(newItem);

            // 6. Chuyển hướng
            
            response.sendRedirect("ViewInventoryController");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Có lỗi xảy ra khi thêm nguyên liệu: " + e.getMessage());
        }
    }
}
