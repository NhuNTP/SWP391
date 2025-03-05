package DAO;

import Model.Inventory;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InventoryDAO extends DB.DBContext {

    public List<Inventory> getAllInventoryItem() {
        String sql = "SELECT * FROM Inventory WHERE isDeleted = 0";
        List<Inventory> inventoryItemList = new ArrayList<>();
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Inventory inventoryItem = new Inventory(
                            rs.getString("ItemId"),
                            rs.getString("ItemName"),
                            rs.getString("ItemType"),
                            rs.getDouble("ItemPrice"),
                            rs.getInt("ItemQuantity"),
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

    public void addNewInventoryItem(Inventory inventory) { // Changed parameter type to Model.Inventory
        String sql = "INSERT INTO [dbo].[Inventory] (ItemName, ItemType, ItemPrice, ItemQuantity, ItemUnit, ItemDescription) " // Updated column names to Inventory properties
                + "VALUES ( ?, ?, ?, ?, ?, ?)"; // Updated number of placeholders to match the number of columns
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);

            st.setString(1, inventory.getItemName());         // Set ItemName
            st.setString(2, inventory.getItemType());         // Set ItemType
            st.setDouble(3, inventory.getItemPrice());         // Set ItemPrice (assuming ItemPrice is double)
            st.setInt(4, inventory.getItemQuantity());          // Set ItemQuantity (assuming ItemQuantity is int)
            st.setString(5, inventory.getItemUnit());          // Set ItemUnit
            st.setString(6, inventory.getItemDescription());    // Set ItemDescription

            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error adding new inventory item: " + e); // More descriptive error message
            e.printStackTrace(); // Print the full stack trace for debugging
        }
    }

    public void updateInventoryItem(Inventory updatedItem) {
        String sql = "UPDATE Inventory SET ItemName = ?, ItemType = ?, ItemPrice = ?, ItemQuantity = ?, ItemUnit = ?, ItemDescription = ? WHERE ItemId = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {

            st.setString(1, updatedItem.getItemName());
            st.setString(2, updatedItem.getItemType());
            st.setDouble(3, updatedItem.getItemPrice());
            st.setInt(4, updatedItem.getItemQuantity());
            st.setString(5, updatedItem.getItemUnit());
            st.setString(6, updatedItem.getItemDescription());
            st.setString(7, updatedItem.getItemId());

            int rowsUpdated = st.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Cập nhật Inventory Item ID = " + updatedItem.getItemId() + " thành công!");
            } else {
                System.out.println("Không tìm thấy Inventory Item ID = " + updatedItem.getItemId() + " để cập nhật.");
            }

        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật Inventory Item: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(InventoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public int deleteInventoryItemById(String itemId) {
        int count = 0;
        try {
            // Modified to update IsDeleted instead of deleting
            String sql = "UPDATE [Inventory] SET IsDeleted = 1 WHERE ItemId=?";
            PreparedStatement pst = getConnection().prepareStatement(sql);
            pst.setString(1, itemId);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(InventoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(InventoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public Inventory getInventoryItemById(String itemId) {
        String sql = "SELECT * FROM Inventory WHERE ItemId = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setString(1, itemId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Inventory inventoryItem = new Inventory(
                            rs.getString("ItemId"),
                            rs.getString("ItemName"),
                            rs.getString("ItemType"),
                            rs.getDouble("ItemPrice"),
                            rs.getInt("ItemQuantity"),
                            rs.getString("ItemUnit"),
                            rs.getString("ItemDescription")
                    );
                    return inventoryItem;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy Inventory Item theo ID: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(InventoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}