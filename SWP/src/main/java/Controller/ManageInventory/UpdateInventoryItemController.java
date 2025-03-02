/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageInventory;

import DAO.InventoryDAO;
import Model.Inventory; // Giả định bạn có lớp model Inventory
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 *
 * @author DELL-Laptop
 */
@WebServlet(name = "UpdateInventoryItemController", urlPatterns = {"/UpdateInventoryItemController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 100)    // 100MB
public class UpdateInventoryItemController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final String UPLOAD_DIRECTORY = "ManageInventory/item_images"; // Đảm bảo đường dẫn này khớp với thư mục tải lên mong muốn của bạn

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy tất cả các tham số từ request
        String itemIdStr = request.getParameter("itemId"); // Lấy ID sản phẩm dưới dạng String trước
        int itemId = -1; // Giá trị mặc định trong trường hợp lỗi phân tích cú pháp
        try {
            itemId = Integer.parseInt(itemIdStr); // Phân tích cú pháp itemId thành số nguyên
        } catch (NumberFormatException e) {
            // Xử lý lỗi phân tích cú pháp nếu itemId không phải là số nguyên hợp lệ
            e.printStackTrace(); // Ghi log lỗi
            request.setAttribute("errorMessage", "Định dạng Item ID không hợp lệ.");
            request.getRequestDispatcher("ManageInventory/UpdateInventoryItem.jsp").forward(request, response);
            return; // Dừng xử lý và trả về trang lỗi
        }
        String itemName = request.getParameter("itemName"); // Lưu ý: bạn đã đặt itemName và itemType là readonly trong JSP, cân nhắc xem bạn có muốn cho phép chỉnh sửa không
        String itemType = request.getParameter("itemType"); // Tương tự như itemName, readonly trong JSP
        String itemPriceStr = request.getParameter("itemPrice");
        double itemPrice = 0.0; // Giá mặc định
        try {
            itemPrice = Double.parseDouble(itemPriceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            itemPrice = 0.0; // hoặc xử lý lỗi tùy ý, có thể đặt thông báo lỗi và chuyển hướng trở lại
        }
        String itemQuantityStr = request.getParameter("itemQuantity");
        int itemQuantity = 0;
        try {
            itemQuantity = Integer.parseInt(itemQuantityStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            itemQuantity = 0; // hoặc xử lý lỗi
        }
        String itemUnit = request.getParameter("itemUnit"); // Lưu ý: itemUnit là readonly trong JSP
        String itemDescription = request.getParameter("itemDescription");
        String oldItemImage = request.getParameter("oldItemImage");
        String newItemFilename = request.getParameter("newItemFilename"); // Lấy tên file mới do người dùng cung cấp

        String newImagePath = oldItemImage; // Mặc định là đường dẫn ảnh cũ nếu không có ảnh mới tải lên

        // 2. Xử lý tải lên file
        Part filePart = request.getPart("newItemImage");
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = "";
            int dotIndex = originalFileName.lastIndexOf('.');
            if (dotIndex > 0) {
                fileExtension = originalFileName.substring(dotIndex);
            }

            String uniqueFileName;
            if (newItemFilename != null && !newItemFilename.trim().isEmpty()) {
                uniqueFileName = newItemFilename.trim() + fileExtension; // Sử dụng tên file do người dùng cung cấp
            } else {
                uniqueFileName = itemId + "_" + System.currentTimeMillis() + fileExtension; // Tạo tên file duy nhất
            }

            String webAppRoot = getServletContext().getRealPath("/");
            File webAppRootDir = new File(webAppRoot);
            File targetDir = webAppRootDir.getParentFile();
            File projectRootDir = targetDir.getParentFile();
            String srcWebAppPath = new File(projectRootDir, "src/main/webapp").getAbsolutePath();
            String relativePath = "ManageInventory/item_images";
            String uploadPath = srcWebAppPath + File.separator + relativePath;
            String filePath = uploadPath + File.separator + uniqueFileName;
            newImagePath = UPLOAD_DIRECTORY + File.separator + uniqueFileName;

            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("File saved successfully to: " + filePath);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải lên hình ảnh: " + e.getMessage());
                request.getRequestDispatcher("ManageInventory/UpdateInventoryItem.jsp").forward(request, response);
                return; // Dừng xử lý trong trường hợp lỗi tải lên
            }

            // (Tùy chọn) Xóa file ảnh cũ nếu nó tồn tại và khác với ảnh mới
            if (oldItemImage != null && !oldItemImage.isEmpty() && !oldItemImage.equals(newImagePath) && !oldItemImage.startsWith(UPLOAD_DIRECTORY)) {
                String oldFilePath = getServletContext().getRealPath("") + File.separator + oldItemImage;
                File oldFile = new File(oldFilePath);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
        }

        // 3. Cập nhật sản phẩm trong kho hàng trong database (PLACEHOLDER - Thay thế bằng lệnh gọi DAO/Service thực tế của bạn)
        Inventory updatedItem = new Inventory();
        updatedItem.setItemId(itemId);
        updatedItem.setItemName(itemName);
        updatedItem.setItemType(itemType);
        updatedItem.setItemPrice(itemPrice);
        updatedItem.setItemQuantity(itemQuantity);
        updatedItem.setItemUnit(itemUnit);
        updatedItem.setItemDescription(itemDescription);
        updatedItem.setItemImage(newImagePath); // Sử dụng đường dẫn ảnh mới (hoặc cũ nếu không cập nhật)

        // --- Gọi Inventory Service/DAO của bạn để cập nhật sản phẩm trong database ---
        InventoryDAO updateDao = new InventoryDAO();
        updateDao.updateInventoryItem(updatedItem);
        // Ví dụ (thay thế bằng lệnh gọi service/DAO thực tế của bạn):
        // InventoryService inventoryService = new InventoryService();
        // boolean updateSuccess = inventoryService.updateInventoryItem(updatedItem);
        boolean updateSuccess = true; // Placeholder cho cập nhật thành công

        if (updateSuccess) {
            // 4a. Chuyển hướng đến ViewInventoryItem.jsp khi thành công
            response.sendRedirect("ViewInventoryController"); // Chuyển hướng để xem tất cả sản phẩm trong kho
        } else {
            // 4b. Xử lý lỗi cập nhật (ví dụ: đặt thông báo lỗi và chuyển hướng trở lại form cập nhật)
            request.setAttribute("errorMessage", "Không thể cập nhật sản phẩm trong kho.");
            request.getRequestDispatcher("ManageInventory/UpdateInventoryItem.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Xử lý cập nhật Sản phẩm trong kho hàng, bao gồm tải lên hình ảnh.";
    } // </editor-fold>

}
