/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author LxP
 */
public class Inventory {
    private int ItemId;
    private String ItemName;
    private String ItemType;
    private double ItemPrice;
    private int ItemQuantity;
    private String ItemUnit;
    private String ItemDescription;

    public Inventory(int ItemId, String ItemName, String ItemType, double ItemPrice, int ItemQuantity, String ItemUnit, String ItemDescription) {
        this.ItemId = ItemId;
        this.ItemName = ItemName;
        this.ItemType = ItemType;
        this.ItemPrice = ItemPrice;
        this.ItemQuantity = ItemQuantity;
        this.ItemUnit = ItemUnit;
        this.ItemDescription = ItemDescription;
    }

    
    
    public Inventory() {
    }

    public int getItemId() {
        return ItemId;
    }

    public void setItemId(int itemId) {
        this.ItemId = itemId;
    }

    public String getItemName() {
        return ItemName;
    }

    public void setItemName(String itemName) {
        this.ItemName = itemName;
    }

    public String getItemType() {
        return ItemType;
    }

    public void setItemType(String itemType) {
        this.ItemType = itemType;
    }

    public double getItemPrice() {
        return ItemPrice;
    }

    public void setItemPrice(double itemPrice) {
        this.ItemPrice = itemPrice;
    }

    public int getItemQuantity() {
        return ItemQuantity;
    }

    public void setItemQuantity(int itemQuantity) {
        this.ItemQuantity = itemQuantity;
    }

    public String getItemUnit() {
        return ItemUnit;
    }

    public void setItemUnit(String itemUnit) {
        this.ItemUnit = itemUnit;
    }

    public String getItemDescription() {
        return ItemDescription;
    }

    public void setItemDescription(String itemDescription) {
        this.ItemDescription = itemDescription;
    }
}