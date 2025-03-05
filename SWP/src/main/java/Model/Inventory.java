package Model;

public class Inventory {
    private String ItemId; // Tên thuộc tính khớp với tên cột trong DB
    private String ItemName;
    private String ItemType;
    private double ItemPrice;
    private int ItemQuantity;
    private String ItemUnit;
    private String ItemDescription;

    // Constructors
    public Inventory() {}

    public Inventory(String itemId, String itemName, String itemType, double itemPrice, int itemQuantity, String itemUnit, String itemDescription) {
        ItemId = itemId;
        ItemName = itemName;
        ItemType = itemType;
        ItemPrice = itemPrice;
        ItemQuantity = itemQuantity;
        ItemUnit = itemUnit;
        ItemDescription = itemDescription;
    }
public Inventory(String ItemName, String ItemType, double ItemPrice, int ItemQuantity, String ItemUnit, String ItemDescription, String ItemImage) {
        this.ItemName = ItemName;
        this.ItemType = ItemType;
        this.ItemPrice = ItemPrice;
        this.ItemQuantity = ItemQuantity;
        this.ItemUnit = ItemUnit;
        this.ItemDescription = ItemDescription;
      
    }

    // Getters and setters
    public String getItemId() {
        return ItemId;
    }

    public void setItemId(String itemId) {
        ItemId = itemId;
    }

    public String getItemName() {
        return ItemName;
    }

    public void setItemName(String itemName) {
        ItemName = itemName;
    }

    public String getItemType() {
        return ItemType;
    }

    public void setItemType(String itemType) {
        ItemType = itemType;
    }

    public double getItemPrice() {
        return ItemPrice;
    }

    public void setItemPrice(double itemPrice) {
        ItemPrice = itemPrice;
    }

    public int getItemQuantity() {
        return ItemQuantity;
    }

    public void setItemQuantity(int itemQuantity) {
        ItemQuantity = itemQuantity;
    }

    public String getItemUnit() {
        return ItemUnit;
    }

    public void setItemUnit(String itemUnit) {
        ItemUnit = itemUnit;
    }

    public String getItemDescription() {
        return ItemDescription;
    }

    public void setItemDescription(String itemDescription) {
        ItemDescription = itemDescription;
    }
}