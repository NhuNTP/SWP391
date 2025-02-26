/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Coupon;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import DB.DBContext;
/**
 *
 * @author DELL-Laptop
 */
public class CouponDAO extends DB.DBContext {

    public List<Coupon> getAllCoupon() {

        String sql = "SELECT * FROM Coupon";
        List<Coupon> coupons = new ArrayList<>();
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Coupon coupon = new Coupon(
                            rs.getInt("couponId"),
                            rs.getBigDecimal("discountAmount"),
                            rs.getDate("expirationDate"),
                            rs.getBoolean("isUsed")
                    );
                    coupons.add(coupon);
                }
                return coupons;
            }

        } catch (Exception e) {
            System.out.println("Error when querying by ID: " + e.getMessage());
        }
        return null;
    }

    public void addNewCoupon(Coupon coupon) {
        String sql = "INSERT INTO [dbo].[Coupon] ( [discountAmount], [expirationDate], [isUsed]) "
                + "VALUES ( ?, ?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
//            st.setInt(1, coupon.getCustomerId());
            st.setBigDecimal(1, coupon.getDiscountAmount());
            st.setDate(2, new java.sql.Date(coupon.getExpirationDate().getTime()));
            st.setBoolean(3, coupon.isIsUsed());
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void updateCoupon(Coupon coupon) throws SQLException, ClassNotFoundException {
        // 1. SQL UPDATE statement, now including customerId in SET clause
        String sql = "UPDATE [dbo].[Coupon] "
                + "SET [discountAmount] = ?, "
                + "[expirationDate] = ?, "
                + "[isUsed] = ? "
                + "WHERE [couponId] = ?";

        try (PreparedStatement st = getConnection().prepareStatement(sql)) {

            // 2. Set parameters, including customerId
//            st.setInt(1, coupon.getCustomerId());    // Set customerId as the first parameter
            st.setBigDecimal(1, coupon.getDiscountAmount());
            Date expirationDateUtil = coupon.getExpirationDate();
            st.setDate(2, coupon.getExpirationDate());
            st.setBoolean(3, coupon.isIsUsed());
            st.setInt(4, coupon.getCouponId()); // couponId remains the last parameter for WHERE clause

            // 3. Execute the UPDATE statement
            int rowsUpdated = st.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Coupon with ID " + coupon.getCouponId() + " updated successfully!");
            } else {
                System.out.println("No Coupon found with ID " + coupon.getCouponId() + " to update.");
            }

        } catch (SQLException e) {
            System.err.println("Error updating Coupon: " + e.getMessage());
            // e.printStackTrace();
        }

    }

    public void deleteCouponById(int couponId) {
        String sql = "DELETE FROM [dbo].[Coupon] WHERE couponId=?";

        try {
            // Kiểm tra kết nối
            if (getConnection() == null) {
                System.out.println("Connection is null!");
                return;
            }

            System.out.println("Executing SQL: " + sql);

            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, couponId);

            // Thực hiện xóa
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Successfully deleted employee with ID: ");
            } else {
                System.out.println("No employee found with ID: ");
            }
        } catch (Exception e) {
            System.out.println("Error during deletion: " + e.getMessage());
            e.printStackTrace(); // In ra stack trace để dễ dàng theo dõi lỗi
        }
    }
}
