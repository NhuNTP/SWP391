/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author DELL-Laptop
 */
public class Coupon {

    private int couponId;

    private BigDecimal discountAmount;
    private Date expirationDate;
    private boolean isUsed;

    public Coupon(int couponId, BigDecimal discountAmount, Date expirationDate, boolean isUsed) {
        this.couponId = couponId;
        this.discountAmount = discountAmount;
        this.expirationDate = expirationDate;
        this.isUsed = isUsed;
    }

    public Coupon(BigDecimal discountAmount, Date expirationDate, boolean isUsed) {
        this.discountAmount = discountAmount;
        this.expirationDate = expirationDate;
        this.isUsed = isUsed;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

 

}
