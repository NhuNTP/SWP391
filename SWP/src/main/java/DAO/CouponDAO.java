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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL-Laptop
 */
public class CouponDAO extends DB.DBContext {

    public List<Coupon> getAllCoupon() {
        String sql = "SELECT couponId, discountAmount, expirationDate, timesUsed FROM Coupon Where isDeleted = 0"; // Liệt kê rõ ràng các cột
        List<Coupon> coupons = new ArrayList<>();
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Coupon coupon = new Coupon( // Tạo đối tượng Coupon với đúng thứ tự tham số
                            rs.getInt("couponId"),
                            rs.getBigDecimal("discountAmount"),
                            rs.getDate("expirationDate"),
                            rs.getInt("timesUsed")
                    );
                    coupons.add(coupon);
                }
                return coupons;
            }

        } catch (SQLException | ClassNotFoundException e) { // Bắt cả 2 loại Exception có thể xảy ra
            System.err.println("Lỗi khi truy vấn tất cả Coupon: " + e.getMessage()); // Sử dụng System.err cho lỗi
            e.printStackTrace(); // In stack trace để debug dễ hơn
        }
        return null; // Trả về null khi có lỗi hoặc không có Coupon nào
    }
    
    public void addNewCoupon(Coupon coupon) {
        String sql = "INSERT INTO Coupon (discountAmount, expirationDate, timesUsed) VALUES (?, ?, ?)"; // Thêm timeUsed vào INSERT và bỏ isUsed
        try (PreparedStatement st = getConnection().prepareStatement(sql)) { // Try-with-resources để tự động đóng PreparedStatement
            st.setBigDecimal(1, coupon.getDiscountAmount());
            st.setDate(2, new java.sql.Date(coupon.getExpirationDate().getTime())); // Chuyển java.util.Date sang java.sql.Date
            st.setInt(3, coupon.getTimesUsed()); // Sử dụng timeUsed
            int rowsInserted = st.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("Thêm mới Coupon thành công!");
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Lỗi khi thêm mới Coupon: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateCoupon(Coupon coupon) { // Loại bỏ throws Exception không cần thiết, bắt và xử lý bên trong
        String sql = "UPDATE Coupon SET discountAmount = ?, expirationDate = ?, timesUsed = ? WHERE couponId = ?"; // Sửa thành timeUsed và bỏ isUsed
        try (PreparedStatement st = getConnection().prepareStatement(sql)) { // Try-with-resources

            st.setBigDecimal(1, coupon.getDiscountAmount());
            st.setDate(2, new java.sql.Date(coupon.getExpirationDate().getTime())); // Chuyển java.util.Date sang java.sql.Date
            st.setInt(3, coupon.getTimesUsed()); // Sử dụng timeUsed
            st.setInt(4, coupon.getCouponId());

            int rowsUpdated = st.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Cập nhật Coupon ID = " + coupon.getCouponId() + " thành công!");
            } else {
                System.out.println("Không tìm thấy Coupon ID = " + coupon.getCouponId() + " để cập nhật.");
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Lỗi cập nhật Coupon: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int deleteCouponById(int couponId) throws ClassNotFoundException {
        int count = 0;
        try {
            // Modified to update IsDeleted instead of deleting
             String sql = "UPDATE [Coupon] SET IsDeleted = 1 WHERE couponId=?";
            PreparedStatement pst = getConnection().prepareStatement(sql);
            pst.setInt(1, couponId);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CouponDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }
}
