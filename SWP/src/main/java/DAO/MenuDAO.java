package DAO;

import Model.Dish;
import Model.Inventory;
import Model.DishInventory;
import DB.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MenuDAO {

    private static final Logger LOGGER = Logger.getLogger(MenuDAO.class.getName()); // Logger

    // Dish operations
    public int addDish(Dish dish) {
        // Sửa lỗi cú pháp SQL:
        // - Sửa tên bảng thành "Dishe" (theo tên bảng thực tế trong database)
        // - Bỏ dấu phẩy thừa trước ")"
        String sql = "INSERT INTO Dish (DishName, DishType, DishPrice, DishDescription, DishImage, DishStatus, IngredientStatus) VALUES (?, ?, ?, ?, ?, ?, ?); SELECT SCOPE_IDENTITY();";
        try (Connection connection = DBContext.getConnection(); // Giả sử DBContext.getConnection() trả về một Connection
             PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1, dish.getDishName());
            preparedStatement.setString(2, dish.getDishType());
            preparedStatement.setDouble(3, dish.getDishPrice());
            preparedStatement.setString(4, dish.getDishDescription());
            preparedStatement.setString(5, dish.getDishImage());
            preparedStatement.setString(6, dish.getDishStatus());
            preparedStatement.setString(7, dish.getIngredientStatus());

            int affectedRows = preparedStatement.executeUpdate();

            if (affectedRows == 0) {
                LOGGER.log(Level.WARNING, "Creating dish failed, no rows affected.");
                return -1; // Thêm thất bại
            }

            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Trả về ID của món vừa thêm
                } else {
                    LOGGER.log(Level.WARNING, "Creating dish failed, no ID obtained.");
                    return -1; // Không lấy được ID
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error adding dish", e);
            return -1; // Thêm thất bại
        }
    }

    // Check if dish name exists
    public boolean dishNameExists(String dishName) {
        String sql = "SELECT COUNT(*) FROM Dish WHERE DishName = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, dishName);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0; // True if dish name exists
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error checking dish name existence", e);
            return false; // Assume not exists in case of error
        }
        return false; // Assume not exists in case of error
    }

    // View all dishes
    public List<Dish> getAllDishes() {
        List<Dish> dishList = new ArrayList<>();
        String sql = "SELECT DishId, DishName, DishType, DishPrice, DishDescription, DishImage, DishStatus, IngredientStatus  FROM Dish";

        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Dish dish = new Dish();
                dish.setDishId(resultSet.getInt("DishId"));
                dish.setDishName(resultSet.getString("DishName"));
                dish.setDishType(resultSet.getString("DishType"));
                dish.setDishPrice(resultSet.getDouble("DishPrice"));
                dish.setDishDescription(resultSet.getString("DishDescription"));
                dish.setDishImage(resultSet.getString("DishImage"));
                dish.setDishStatus(resultSet.getString("DishStatus"));
                dish.setIngredientStatus(resultSet.getString("IngredientStatus"));
               
                dishList.add(dish);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all dishes", e);
            return null; // Return null to indicate failure
        }
        return dishList;
    }

    private boolean deleteDishInventory(int dishId) {
        String sql = "DELETE FROM Dish_Inventory WHERE DishId = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, dishId);
            int affectedRows = preparedStatement.executeUpdate();
            return affectedRows >= 0; // Consider success even if no rows were deleted (already clean)

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error deleting dish inventory for dishId: " + dishId, e);
            return false;
        }
    }

    // Delete a dish (chỉ xóa nếu không có trong Order Detail)
     // Delete a dish and its related records in DishInventory (nếu không có trong Order Detail)
    public boolean deleteDish(int dishId) {
        Connection connection = null;
        PreparedStatement checkOrderDetailStmt = null;
        PreparedStatement deleteDishInventoryStmt = null;
        PreparedStatement deleteDishStmt = null;
        ResultSet resultSet = null;

        try {
            connection = DBContext.getConnection();
            connection.setAutoCommit(false); // Bắt đầu transaction

            // 1. Kiểm tra xem Dish có tồn tại trong Order Detail không
            String checkOrderDetailSql = "SELECT COUNT(*) FROM [OrderDetail] WHERE DishId = ?";  // nhớ dấu []
            checkOrderDetailStmt = connection.prepareStatement(checkOrderDetailSql);
            checkOrderDetailStmt.setInt(1, dishId);
            resultSet = checkOrderDetailStmt.executeQuery();

            int orderDetailCount = 0;
            if (resultSet.next()) {
                orderDetailCount = resultSet.getInt(1);
            }

            if (orderDetailCount == 0) {
                // 2. Xóa các bản ghi liên quan trong DishInventory
                String deleteDishInventorySql = "DELETE FROM Dish_Inventory WHERE DishId = ?";
                deleteDishInventoryStmt = connection.prepareStatement(deleteDishInventorySql);
                deleteDishInventoryStmt.setInt(1, dishId);
                deleteDishInventoryStmt.executeUpdate();

                // 3. Xóa Dish
                String deleteDishSql = "DELETE FROM Dish WHERE DishId = ?";
                deleteDishStmt = connection.prepareStatement(deleteDishSql);
                deleteDishStmt.setInt(1, dishId);
                int affectedRows = deleteDishStmt.executeUpdate();

                connection.commit(); // Commit transaction
                return affectedRows > 0;
            } else {
                connection.rollback(); // Rollback transaction nếu có trong Order Detail
                return false;
            }

        } catch (SQLException | ClassNotFoundException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.WARNING, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error deleting dish with ID: " + dishId, e);
            return false;
        } finally {
            // Đảm bảo đóng tất cả các resources trong finally block
            try {
                if (resultSet != null) resultSet.close();
                if (checkOrderDetailStmt != null) checkOrderDetailStmt.close();
                if (deleteDishInventoryStmt != null) deleteDishInventoryStmt.close();
                if (deleteDishStmt != null) deleteDishStmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources", e);
            }
        }
    }

    //Update a dish
    public boolean updateDish(Dish dish) {
        String sql = "UPDATE Dish SET DishName = ?, DishType = ?, DishPrice = ?, DishDescription = ?, DishImage = ?, DishStatus = ?, IngredientStatus = ? WHERE DishId = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, dish.getDishName());
            preparedStatement.setString(2, dish.getDishType());
            preparedStatement.setDouble(3, dish.getDishPrice());
            preparedStatement.setString(4, dish.getDishDescription());
            preparedStatement.setString(5, dish.getDishImage());
            preparedStatement.setString(6, dish.getDishStatus());
            preparedStatement.setString(7, dish.getIngredientStatus());
          preparedStatement.setInt(8, dish.getDishId());

            int affectedRows = preparedStatement.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error updating dish", e);
            return false;
        }
    }

    // Method to get a specific dish by ID
    public Dish getDishById(int dishId) {
        String sql = "SELECT DishId, DishName, DishType, DishPrice, DishDescription, DishImage, DishStatus, IngredientStatus FROM Dish WHERE DishId = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, dishId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Dish dish = new Dish();
                    dish.setDishId(resultSet.getInt("DishId"));
                    dish.setDishName(resultSet.getString("DishName"));
                    dish.setDishType(resultSet.getString("DishType"));
                    dish.setDishPrice(resultSet.getDouble("DishPrice"));
                    dish.setDishDescription(resultSet.getString("DishDescription"));
                    dish.setDishImage(resultSet.getString("DishImage"));
                    dish.setDishStatus(resultSet.getString("DishStatus"));
                    dish.setIngredientStatus(resultSet.getString("IngredientStatus"));
                   
                    return dish;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting dish by ID", e);
            return null; // Indicate failure
        }
        return null; // Dish not found
    }

    // Method to get ingredients (DishInventory) for a specific dish
    public List<DishInventory> getDishIngredients(int dishId) {
        List<DishInventory> dishIngredients = new ArrayList<>();
        String sql = "SELECT DishId, ItemId, QuantityUsed FROM Dish_Inventory WHERE DishId = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, dishId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    DishInventory dishInventory = new DishInventory();
                    dishInventory.setDishId(resultSet.getInt("DishId"));
                    dishInventory.setItemId(resultSet.getInt("ItemId"));
                    dishInventory.setQuantityUsed(resultSet.getInt("QuantityUsed"));
                    dishIngredients.add(dishInventory);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting dish ingredients", e);
            return null; // Indicate failure
        }
        return dishIngredients;
    }

    // Inventory operations
    public List<Inventory> getAllInventory() {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT ItemId, ItemName, ItemType, ItemPrice, ItemQuantity, ItemUnit, ItemDescription FROM Inventory";

        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Inventory inventory = new Inventory();
                inventory.setItemId(resultSet.getInt("ItemId"));
                inventory.setItemName(resultSet.getString("ItemName"));
                inventory.setItemType(resultSet.getString("ItemType"));
                inventory.setItemPrice(resultSet.getDouble("ItemPrice"));
                inventory.setItemQuantity(resultSet.getInt("ItemQuantity"));
                inventory.setItemUnit(resultSet.getString("ItemUnit"));
                inventory.setItemDescription(resultSet.getString("ItemDescription"));
                inventoryList.add(inventory);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting all inventory", e);
            return null;
        }
        return inventoryList;
    }

    // DishInventory operations
    public boolean addDishInventory(DishInventory dishInventory) {
        String sql = "INSERT INTO Dish_Inventory (DishId, ItemId, QuantityUsed) VALUES (?, ?, ?)";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, dishInventory.getDishId());
            preparedStatement.setInt(2, dishInventory.getItemId());
            preparedStatement.setInt(3, dishInventory.getQuantityUsed());

            int affectedRows = preparedStatement.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error adding dish inventory", e);
            return false;
        }
    }

    public Inventory getInventoryItemById(int itemId) {
        String sql = "SELECT ItemId, ItemName, ItemType, ItemPrice, ItemQuantity, ItemUnit, ItemDescription FROM Inventory WHERE ItemId = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, itemId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Inventory inventory = new Inventory();
                    inventory.setItemId(resultSet.getInt("ItemId"));
                    inventory.setItemName(resultSet.getString("ItemName"));
                    inventory.setItemType(resultSet.getString("ItemType"));
                    inventory.setItemPrice(resultSet.getDouble("ItemPrice"));
                    inventory.setItemQuantity(resultSet.getInt("ItemQuantity"));
                    inventory.setItemUnit(resultSet.getString("ItemUnit"));
                    inventory.setItemDescription(resultSet.getString("ItemDescription"));
                    return inventory;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory item by ID", e);
            return null;
        }
        return null;
    }

    public List<Dish> searchDishes(String keyword) {
        List<Dish> dishList = new ArrayList<>();
        String query = "SELECT * FROM Dish WHERE (DishName LIKE ? OR DishDescription LIKE ?)"; //

        try (Connection connection = DBContext.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            String searchKeyword = "%" + keyword + "%";
            statement.setString(1, searchKeyword);
            statement.setString(2, searchKeyword);

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Dish dish = new Dish();
                dish.setDishId(resultSet.getInt("DishID"));
                dish.setDishName(resultSet.getString("DishName"));
                dish.setDishType(resultSet.getString("DishType"));
                dish.setDishPrice(resultSet.getDouble("DishPrice"));
                dish.setDishDescription(resultSet.getString("DishDescription"));
                dish.setDishImage(resultSet.getString("DishImage"));
                dish.setDishStatus(resultSet.getString("DishStatus"));
                dish.setIngredientStatus(resultSet.getString("IngredientStatus"));
              
                dishList.add(dish);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dishList;
    }
}