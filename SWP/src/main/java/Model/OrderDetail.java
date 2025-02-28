/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author HuynhPhuBinh
 */
public class OrderDetail {

    private int orderDetailId;
    private int orderId;
    private int dishId;
    private int quantity;
    private double subtotal;

    public OrderDetail() {

    }

    public OrderDetail(int orderDetailId, int orderId, int dishId, int quantity, double subtotal) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.dishId = dishId;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

}
