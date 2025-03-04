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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemId_raw = request.getParameter("itemId");
        String itemName_raw = request.getParameter("itemName");
        String itemType_raw = request.getParameter("itemType");
        String itemPrice_raw = request.getParameter("itemPrice");
        String itemQuantity_raw = request.getParameter("itemQuantity");
        String itemUnit_raw = request.getParameter("itemUnit");
        String itemDescription_raw = request.getParameter("itemDescription");

        // 1. Kiểm tra dữ liệu đầu vào (Validation)
        double itemPrice = Double.parseDouble(itemPrice_raw);
        int itemQuantity = Integer.parseInt(itemQuantity_raw);

        Inventory upInventory = new Inventory(itemId_raw, itemName_raw, itemType_raw, itemPrice, itemQuantity, itemUnit_raw, itemDescription_raw);
        InventoryDAO updateItem = new InventoryDAO();
        updateItem.updateInventoryItem(upInventory);

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
