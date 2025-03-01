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
    private String ItemImage;

    public Inventory() {
    }

    
    public Inventory(int ItemId, String ItemName, String ItemType, double ItemPrice, int ItemQuantity, String ItemUnit, String ItemDescription, String ItemImage) {
        this.ItemId = ItemId;
        this.ItemName = ItemName;
        this.ItemType = ItemType;
        this.ItemPrice = ItemPrice;
        this.ItemQuantity = ItemQuantity;
        this.ItemUnit = ItemUnit;
        this.ItemDescription = ItemDescription;
        this.ItemImage = ItemImage;
    }

    public Inventory(String ItemName, String ItemType, double ItemPrice, int ItemQuantity, String ItemUnit, String ItemDescription, String ItemImage) {
        this.ItemName = ItemName;
        this.ItemType = ItemType;
        this.ItemPrice = ItemPrice;
        this.ItemQuantity = ItemQuantity;
        this.ItemUnit = ItemUnit;
        this.ItemDescription = ItemDescription;
        this.ItemImage = ItemImage;
    }

    
    public int getItemId() {
        return ItemId;
    }

    public void setItemId(int ItemId) {
        this.ItemId = ItemId;
    }

    public String getItemName() {
        return ItemName;
    }

    public void setItemName(String ItemName) {
        this.ItemName = ItemName;
    }

    public String getItemType() {
        return ItemType;
    }

    public void setItemType(String ItemType) {
        this.ItemType = ItemType;
    }

    public double getItemPrice() {
        return ItemPrice;
    }

    public void setItemPrice(double ItemPrice) {
        this.ItemPrice = ItemPrice;
    }

    public int getItemQuantity() {
        return ItemQuantity;
    }

    public void setItemQuantity(int ItemQuantity) {
        this.ItemQuantity = ItemQuantity;
    }

    public String getItemUnit() {
        return ItemUnit;
    }

    public void setItemUnit(String ItemUnit) {
        this.ItemUnit = ItemUnit;
    }

    public String getItemDescription() {
        return ItemDescription;
    }

    public void setItemDescription(String ItemDescription) {
        this.ItemDescription = ItemDescription;
    }

    public String getItemImage() {
        return ItemImage;
    }

    public void setItemImage(String ItemImage) {
        this.ItemImage = ItemImage;
    }


}