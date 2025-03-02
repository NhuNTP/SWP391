/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author LxP
 */
public class DishInventory {

    private int DishId;
    private int ItemId;
    private int QuantityUsed;

    public DishInventory() {
    }

    public int getDishId() {
        return DishId;
    }

    public void setDishId(int dishId) {
        this.DishId = dishId;
    }

    public int getItemId() {
        return ItemId;
    }

    public void setItemId(int itemId) {
        this.ItemId = itemId;
    }

    public int getQuantityUsed() {
        return QuantityUsed;
    }

    public void setQuantityUsed(int quantityUsed) {
        this.QuantityUsed = quantityUsed;
    }
}
