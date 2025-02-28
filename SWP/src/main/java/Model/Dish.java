/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author LxP
 */
public class Dish {
    private int DishId;
    private String DishName;
    private String DishType;
    private double DishPrice;
    private String DishDescription;
    private String DishImage;

    public Dish() {
    }

    public Dish(String dishName, String dishType, double dishPrice, String dishDescription, String dishImage) {
        this.DishName = dishName;
        this.DishType = dishType;
        this.DishPrice = dishPrice;
        this.DishDescription = dishDescription;
        this.DishImage = dishImage;
    }

    public int getDishId() {
        return DishId;
    }

    public void setDishId(int dishId) {
        this.DishId = dishId;
    }

    public String getDishName() {
        return DishName;
    }

    public void setDishName(String dishName) {
        this.DishName = dishName;
    }

    public String getDishType() {
        return DishType;
    }

    public void setDishType(String dishType) {
        this.DishType = dishType;
    }

    public double getDishPrice() {
        return DishPrice;
    }

    public void setDishPrice(double dishPrice) {
        this.DishPrice = dishPrice;
    }

    public String getDishDescription() {
        return DishDescription;
    }

    public void setDishDescription(String dishDescription) {
        this.DishDescription = dishDescription;
    }

    public String getDishImage() {
        return DishImage;
    }

    public void setDishImage(String dishImage) {
        this.DishImage = dishImage;
    }
}