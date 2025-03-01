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
            // 1. Lấy dữ liệu từ form
            String itemName = request.getParameter("itemName");
            String itemType = request.getParameter("itemType");
            double itemPrice = Double.parseDouble(request.getParameter("itemPrice"));
            int itemQuantity = Integer.parseInt(request.getParameter("itemQuantity"));
            String itemUnit = request.getParameter("itemUnit");
            String itemDescription = request.getParameter("itemDescription");

            // 2. Xử lý upload hình ảnh
            Part filePart = request.getPart("itemImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // 3. Tạo đường dẫn lưu trữ hình ảnh
            String webAppRoot = getServletContext().getRealPath("/");

            // Đi ngược lên để đến thư mục gốc của project (giả sử cấu trúc thư mục chuẩn)
            File webAppRootDir = new File(webAppRoot);
            File targetDir = webAppRootDir.getParentFile(); // Đi lên thư mục 'target'
            File projectRootDir = targetDir.getParentFile(); // Đi lên thư mục gốc của project

            // Tạo đường dẫn đến thư mục src/main/webapp
            String srcWebAppPath = new File(projectRootDir, "src/main/webapp").getAbsolutePath();
            String relativePath = "ManageInventory/item_images"; // Đường dẫn tương đối trong web app
            String uploadPath = srcWebAppPath + File.separator + relativePath; // Đường dẫn tuyệt đối đến src/main/webapp

            // Kiểm tra và tạo thư mục (giữ nguyên)
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    System.out.println("Directory created successfully: " + uploadPath);
                } else {
                    System.out.println("Failed to create directory: " + uploadPath);
                }
            }

            // 4. Xử lý tên file an toàn (giữ nguyên)
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;
            String relativeImagePath = "ManageInventory/item_images/" + uniqueFileName;

            // Lưu file (giữ nguyên)
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("File saved successfully to: " + filePath);
            }

            // 5. Thêm vào database (giữ nguyên)
            Inventory newItem = new Inventory(itemName, itemType, itemPrice, itemQuantity, itemUnit, itemDescription, relativeImagePath);
            InventoryDAO inventoryDAO = new InventoryDAO();
            inventoryDAO.addNewInventoryItem(newItem);

            // 6. Chuyển hướng (giữ nguyên)
            response.sendRedirect("ViewInventoryController");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Có lỗi xảy ra khi thêm nguyên liệu: " + e.getMessage());
        }
    }
}
