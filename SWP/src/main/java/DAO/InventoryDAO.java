/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import static DB.DBContext.getConnection;
import Model.Coupon;
import Model.Inventory;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL-Laptop
 */
public class InventoryDAO extends DB.DBContext {

    public List<Inventory> getAllInventoryItem() {
        String sql = "SELECT * FROM Inventory";
        List<Inventory> inventoryItemList = new ArrayList<>();
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Inventory inventoryItem = new Inventory(
                            rs.getInt("ItemId"),
                            rs.getString("ItemName"),
                            rs.getString("ItemType"),
                            rs.getDouble("ItemPrice"),
                            rs.getInt("ItemQuantity"),
                            rs.getString("ItemUnit"),
                            rs.getString("ItemDescription"),
                            rs.getString("ItemImage")
                    );
                    //    System.out.println("--- Inventory Item " + rowCount + " ---");
                    System.out.println("ItemId: " + inventoryItem.getItemId());
                    System.out.println("ItemName: " + inventoryItem.getItemName());
                    System.out.println("ItemType: " + inventoryItem.getItemType());
                    System.out.println("ItemPrice: " + inventoryItem.getItemPrice());
                    System.out.println("ItemQuantity: " + inventoryItem.getItemQuantity());
                    System.out.println("ItemUnit: " + inventoryItem.getItemUnit());
                    System.out.println("ItemDescription: " + inventoryItem.getItemDescription());
                    System.out.println("ItemImage: " + inventoryItem.getItemImage());
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

    public void addNewInventoryItem(Inventory inventory) { // Changed parameter type to Model.InventoryItem
        String sql = "INSERT INTO [dbo].[Inventory] (ItemName, ItemType, ItemPrice, ItemQuantity, ItemUnit, ItemDescription,ItemImage) " // Updated column names to InventoryItem properties
                + "VALUES ( ?, ?, ?, ?, ?, ?, ?)"; // Updated number of placeholders to match the number of columns
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);

            st.setString(1, inventory.getItemName());         // Set ItemName
            st.setString(2, inventory.getItemType());         // Set ItemType
            st.setDouble(3, inventory.getItemPrice());         // Set ItemPrice (assuming ItemPrice is double)
            st.setInt(4, inventory.getItemQuantity());          // Set ItemQuantity (assuming ItemQuantity is int)
            st.setString(5, inventory.getItemUnit());          // Set ItemUnit
            st.setString(6, inventory.getItemDescription());    // Set ItemDescription
            st.setString(7, inventory.getItemImage());    // Set ItemDescription

            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error adding new inventory item: " + e); // More descriptive error message
            e.printStackTrace(); // Print the full stack trace for debugging
        }
    }

    public void updateInventoryItem(Inventory updatedItem) {
        String sql = "UPDATE Inventory SET itemName = ?, itemType = ?, itemPrice = ?, itemQuantity = ?, itemUnit = ?, itemDescription = ?, itemImage = ? WHERE itemId = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {

            st.setString(1, updatedItem.getItemName());
            st.setString(2, updatedItem.getItemType());
            st.setDouble(3, updatedItem.getItemPrice());
            st.setInt(4, updatedItem.getItemQuantity());
            st.setString(5, updatedItem.getItemUnit());
            st.setString(6, updatedItem.getItemDescription());
            st.setString(7, updatedItem.getItemImage());
            st.setInt(8, updatedItem.getItemId());

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
}
