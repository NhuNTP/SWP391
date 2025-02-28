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
    private int timesUsed;
    private int isDeleted;

    public Coupon(int couponId, BigDecimal discountAmount, Date expirationDate, int timeUsed) {
        this.couponId = couponId;
        this.discountAmount = discountAmount;
        this.expirationDate = expirationDate;
        this.timesUsed = timeUsed;
    }

    
    
    public Coupon(BigDecimal discountAmount, Date expirationDate, int timeUsed) {
        this.discountAmount = discountAmount;
        this.expirationDate = expirationDate;
        this.timesUsed = timeUsed;
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

    public int getTimesUsed() {
        return timesUsed;
    }

    public void setTimesUsed(int timesUsed) {
        this.timesUsed = timesUsed;
    }

    public int getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(int isDeleted) {
        this.isDeleted = isDeleted;
    }

  

   
 

}
