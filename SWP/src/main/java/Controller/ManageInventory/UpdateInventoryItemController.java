package Controller.ManageInventory;

import DAO.InventoryDAO;
import Model.Inventory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UpdateInventoryItemController", urlPatterns = {"/UpdateInventoryItemController"})
public class UpdateInventoryItemController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy tất cả các tham số từ request
        String itemId = request.getParameter("itemId");
        String itemName = request.getParameter("itemName");
        String itemType = request.getParameter("itemType");
        String itemPrice_raw = request.getParameter("itemPrice");
        String itemQuantity_raw = request.getParameter("itemQuantity");
        
        
        String itemUnit = request.getParameter("itemUnit");
        String itemDescription = request.getParameter("itemDescription");

        // 1. Kiểm tra dữ liệu đầu vào (Validation)
        double itemPrice = Double.parseDouble(itemPrice_raw);
        double itemQuantity = Integer.parseInt(itemQuantity_raw);
      
        // 2. Tạo đối tượng Inventory để cập nhật
        Inventory updatedItem = new Inventory();
        updatedItem.setItemId(itemId);
        updatedItem.setItemName(itemName);
        updatedItem.setItemType(itemType);
        updatedItem.setItemPrice(itemPrice);
        updatedItem.setItemQuantity(itemQuantity);
        updatedItem.setItemUnit(itemUnit);
        updatedItem.setItemDescription(itemDescription);

        // 3. Cập nhật sản phẩm trong kho hàng trong database
        InventoryDAO updateDao = new InventoryDAO();
        updateDao.updateInventoryItem(updatedItem);

        // 4. Chuyển hướng đến trang danh sách sản phẩm
        response.sendRedirect("ViewInventoryController");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Xử lý cập nhật sản phẩm trong kho hàng.";
    } // </editor-fold>

}