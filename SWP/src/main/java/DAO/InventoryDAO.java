/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import static DB.DBContext.getConnection;
import Model.Coupon;
import Model.Inventory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL-Laptop
 */
public class InventoryDAO extends DB.DBContext {

    public List<Inventory> getAllInventoryItem() {
        String sql = "SELECT * FROM Inventory Where isDeleted = 0";
        List<Inventory> inventoryItemList = new ArrayList<>();
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Inventory inventoryItem = new Inventory(
                            rs.getString("ItemId"),
                            rs.getString("ItemName"),
                            rs.getString("ItemType"),
                            rs.getDouble("ItemPrice"),
                            rs.getDouble("ItemQuantity"),
                            rs.getString("ItemUnit"),
                            rs.getString("ItemDescription")
                    );
                    //    System.out.println("--- Inventory Item " + rowCount + " ---");
                    System.out.println("ItemId: " + inventoryItem.getItemId());
                    System.out.println("ItemName: " + inventoryItem.getItemName());
                    System.out.println("ItemType: " + inventoryItem.getItemType());
                    System.out.println("ItemPrice: " + inventoryItem.getItemPrice());
                    System.out.println("ItemQuantity: " + inventoryItem.getItemQuantity());
                    System.out.println("ItemUnit: " + inventoryItem.getItemUnit());
                    System.out.println("ItemDescription: " + inventoryItem.getItemDescription());
                    System.out.println("-----------------------");
                    inventoryItemList.add(inventoryItem);
                }
                return inventoryItemList;
            }

        } catch (Exception e) {
            System.out.println("Error when querying by ID: " + e.getMessage());
        }
        return null;
    }

    public String generateNextInventoryId() throws SQLException, ClassNotFoundException {
        String lastInventoryId = getLastInventoryIdFromDB();
        int nextNumber = 1; // Số bắt đầu nếu chưa có coupon nào

        if (lastInventoryId != null && !lastInventoryId.isEmpty()) {
            try {
                String numberPart = lastInventoryId.substring(2); // Loại bỏ "CP"
                nextNumber = Integer.parseInt(numberPart) + 1;
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu phần số không đúng định dạng (ví dụ: log lỗi hoặc ném exception)
                System.err.println("Lỗi định dạng CouponId cuối cùng: " + lastInventoryId);
                // Trong trường hợp lỗi định dạng, vẫn nên tạo mã mới bắt đầu từ CP001 để đảm bảo tiếp tục hoạt động
                return "000";
            }
        }

        // Định dạng số thành chuỗi 3 chữ số (ví dụ: 1 -> "001", 10 -> "010", 100 -> "100")
        String numberStr = String.format("%03d", nextNumber);
        return "IN" + numberStr; // **Sửa thành "CP" thay vì "CO"**
    }

    private String getLastInventoryIdFromDB() throws SQLException, ClassNotFoundException {
        String lastCouponId = null;
        // **Sửa câu SQL cho đúng tên bảng và cột, và dùng TOP 1 cho SQL Server**
        String sql = "SELECT TOP 1 ItemId FROM [db1].[dbo].[Inventory] ORDER BY ItemId DESC";
        Connection connection = null; // Khai báo connection để quản lý đóng kết nối trong finally
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = getConnection(); // Gọi phương thức getConnection() để lấy Connection - **Cần đảm bảo getConnection() được implement đúng**
            preparedStatement = connection.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                lastCouponId = resultSet.getString("ItemId"); // **Sửa thành "CouponId" cho đúng tên cột**
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi hoặc xử lý lỗi kết nối database
            throw e; // Re-throw để servlet xử lý nếu cần
        } finally {
            // Đóng resources trong finally block để đảm bảo giải phóng kết nối và resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return lastCouponId;
    }

    public void addNewInventoryItem(Inventory inventory) { // Changed parameter type to Model.InventoryItem
        String sql = "INSERT INTO [dbo].[Inventory] (ItemId,ItemName, ItemType, ItemPrice, ItemQuantity, ItemUnit, ItemDescription) " // Updated column names to InventoryItem properties
                + "VALUES ( ?, ?, ?, ?, ?, ?,?)"; // Updated number of placeholders to match the number of columns
        try (PreparedStatement st = getConnection().prepareStatement(sql)) { // Try-with-resources để tự động đóng PreparedStatement
            st.setString(1, inventory.getItemId());
            st.setString(2, inventory.getItemName());
            st.setString(3, inventory.getItemType());
            st.setDouble(4, inventory.getItemPrice());
            st.setDouble(5, inventory.getItemQuantity());
            st.setString(6, inventory.getItemUnit());
            st.setString(7, inventory.getItemDescription());

            System.out.println("Câu truy vấn SQL đang thực thi:");
            System.out.println(sql);
            System.out.println("Tham số:");
            System.out.println("  @P1 (ItemId): " + inventory.getItemId());
            System.out.println("  @P2 (ItemName): " + inventory.getItemName());
            System.out.println("  @P3 (ItemType): " + inventory.getItemType());
            System.out.println("  @P4 (ItemPrice): " + inventory.getItemPrice());
            System.out.println("  @P5 (ItemQuantity): " + inventory.getItemQuantity());
            System.out.println("  @P6 (ItemUnit): " + inventory.getItemUnit());
            System.out.println("  @P7 (ItemDescription): " + inventory.getItemDescription());
            int rowsInserted = st.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("Thêm mới Item thành công!");
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Lỗi khi thêm mới Item: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateInventoryItem(Inventory updatedItem) {
        String sql = "UPDATE Inventory SET itemName = ?, itemType = ?, itemPrice = ?, itemQuantity = ?, itemUnit = ?, itemDescription = ? WHERE itemId = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {

            st.setString(1, updatedItem.getItemName());
            st.setString(2, updatedItem.getItemType());
            st.setDouble(3, updatedItem.getItemPrice());
            st.setDouble(4, updatedItem.getItemQuantity());
            st.setString(5, updatedItem.getItemUnit());
            st.setString(6, updatedItem.getItemDescription());
            st.setString(7, updatedItem.getItemId());

            int rowsUpdated = st.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Cập nhật Inventory Item ID = " + updatedItem.getItemId() + " thành công!");
            } else {
                System.out.println("Không tìm thấy Inventory Item ID = " + updatedItem.getItemId() + " để cập nhật.");
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Lỗi cập nhật Inventory Item: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int deleteInventoryItemById(int itemId) throws ClassNotFoundException {
        int count = 0;
        try {
            // Modified to update IsDeleted instead of deleting
            String sql = "UPDATE [Inventory] SET IsDeleted = 1 WHERE itemId=?";
            PreparedStatement pst = getConnection().prepareStatement(sql);
            pst.setInt(1, itemId);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CouponDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }
}