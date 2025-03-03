package Model;

public class Dish {
    // Các trường tương ứng với các cột trong bảng Dish
    private int DishId; // Tương ứng với cột DishId
    private String DishName; // Tương ứng với cột DishName
    private String DishType; // Tương ứng với cột DishType
    private double DishPrice; // Tương ứng với cột DishPrice
    private String DishDescription; // Tương ứng với cột DishDescription
    private String DishImage; // Tương ứng với cột DishImage
    private String DishStatus; // Tương ứng với cột DishStatus
    private String IngredientStatus; // Tương ứng với cột IngredientStatus
    private boolean isDeleted; // Tương ứng với cột IsDeleted

    public Dish() {
    }

    public Dish(int DishId, String DishName, String DishType, double DishPrice, String DishDescription, String DishImage, String DishStatus, String IngredientStatus, boolean isDeleted) {
        this.DishId = DishId;
        this.DishName = DishName;
        this.DishType = DishType;
        this.DishPrice = DishPrice;
        this.DishDescription = DishDescription;
        this.DishImage = DishImage;
        this.DishStatus = DishStatus;
        this.IngredientStatus = IngredientStatus;
        this.isDeleted = isDeleted;
    }


    public int getDishId() {
        return DishId;
    }

    public void setDishId(int DishId) {
        this.DishId = DishId;
    }

    public String getDishName() {
        return DishName;
    }

    public void setDishName(String DishName) {
        this.DishName = DishName;
    }

    public String getDishType() {
        return DishType;
    }

    public void setDishType(String DishType) {
        this.DishType = DishType;
    }

    public double getDishPrice() {
        return DishPrice;
    }

    public void setDishPrice(double DishPrice) {
        this.DishPrice = DishPrice;
    }

    public String getDishDescription() {
        return DishDescription;
    }

    public void setDishDescription(String DishDescription) {
        this.DishDescription = DishDescription;
    }

    public String getDishImage() {
        return DishImage;
    }

    public void setDishImage(String DishImage) {
        this.DishImage = DishImage;
    }

    public String getDishStatus() {
        return DishStatus;
    }

    public void setDishStatus(String DishStatus) {
        this.DishStatus = DishStatus;
    }

    public String getIngredientStatus() {
        return IngredientStatus;
    }

    public void setIngredientStatus(String IngredientStatus) {
        this.IngredientStatus = IngredientStatus;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
}