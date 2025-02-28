/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author HuynhPhuBinh
 */
import java.util.Date;
public class Order {
    private int OrderId;
    private int UserId; // Liên kết với Account
    private int CustomerId; // Liên kết với Customer (có thể null)
    private Date OrderDate;
    private String OrderStatus;
    private String OrderType;
    private String OrderDescription;
    private int CouponId; // Liên kết với Coupon (có thể null)
    private int TableId; // Liên kết với Table (có thể null)

    public Order() {
    }

    public int getOrderId() {
        return OrderId;
    }

    public void setOrderId(int orderId) {
        this.OrderId = orderId;
    }

    public int getUserId() {
        return UserId;
    }

    public void setUserId(int userId) {
        this.UserId = userId;
    }

    public int getCustomerId() {
        return CustomerId;
    }

    public void setCustomerId(int customerId) {
        this.CustomerId = customerId;
    }

    public Date getOrderDate() {
        return OrderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.OrderDate = orderDate;
    }

    public String getOrderStatus() {
        return OrderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.OrderStatus = orderStatus;
    }

    public String getOrderType() {
        return OrderType;
    }

    public void setOrderType(String orderType) {
        this.OrderType = orderType;
    }

    public String getOrderDescription() {
        return OrderDescription;
    }

    public void setOrderDescription(String orderDescription) {
        this.OrderDescription = orderDescription;
    }

    public int getCouponId() {
        return CouponId;
    }

    public void setCouponId(int couponId) {
        this.CouponId = couponId;
    }

    public int getTableId() {
        return TableId;
    }

    public void setTableId(int tableId) {
        this.TableId = tableId;
    }
}
