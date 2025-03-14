package DAO;

import DB.DBContext;
import Model.Table;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TableDAO {

    private Connection conn;
    private String sql;

    public TableDAO() throws ClassNotFoundException, SQLException {
        conn = DBContext.getConnection();
    }

    public ResultSet getAllTable() {
        ResultSet rs = null;
        try {
            Statement st = conn.createStatement();
            sql = "SELECT * FROM [Table] WHERE IsDeleted = 0";
            rs = st.executeQuery(sql);
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }

    //Hàm lấy id lớn nhất hiện tại
    private String getNextTableId(int floorNumber) throws SQLException {
        String maxId = null;
        String nextId = null;
        PreparedStatement getMaxId = null;

        try {
            // Truy vấn SQL cần lọc theo FloorNumber để lấy MAX(TableId) của tầng cụ thể
            sql = "SELECT MAX(TableId) AS MaxId FROM [Table] WHERE FloorNumber = ?";
            getMaxId = conn.prepareStatement(sql);
            getMaxId.setInt(1, floorNumber); // Set tham số FloorNumber vào câu truy vấn
            ResultSet rs = getMaxId.executeQuery();

            if (rs.next()) {
                maxId = rs.getString("MaxId");
            }

            String prefix = "TA" + floorNumber; // Tạo prefix ID dựa trên tầng

            if (maxId == null) {
                nextId = prefix + "01"; // Nếu chưa có bàn nào ở tầng này, bắt đầu từ TA[Tầng]001 (sửa lại thành 001)
            } else {
                // Lấy phần số từ ID hiện tại (ví dụ: "002" từ "TA002")
                // Cắt bỏ phần prefix "TA[Tầng]" để lấy phần số
                String numericPart = maxId.substring(prefix.length());
                int nextNumber = Integer.parseInt(numericPart) + 1; // Tăng số lên 1
                // Định dạng lại số thành chuỗi 2 chữ số (ví dụ: 003)
                nextId = prefix + String.format("%02d", nextNumber); // Sửa lại thành %03d
            }
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (getMaxId != null) {
                getMaxId.close();
            }
        }
        return nextId;
    }

    public int createTable(Table newInfo) {
        int count = 0;
        PreparedStatement pst = null;
        try {
            // Lấy số tầng từ newInfo
            int floorNumber = newInfo.getFloorNumber();
            // Gọi getNextTableId() với số tầng
            String newTableId = getNextTableId(floorNumber);

            sql = "INSERT INTO [Table] (TableId, TableStatus, NumberOfSeats, FloorNumber) VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newTableId);
            pst.setString(2, newInfo.getTableStatus());
            pst.setInt(3, newInfo.getNumberOfSeats());
            pst.setInt(4, newInfo.getFloorNumber());

            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException ex) {
                    Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return count;
    }

    public int updateTable(String id, Table newInfo) {
        int count = 0;
        PreparedStatement pst = null;

        try {
            // Giữ nguyên TableId, chỉ cập nhật TableStatus và NumberOfSeats
            sql = "UPDATE [Table] SET TableStatus=?, NumberOfSeats=? WHERE TableId=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getTableStatus());
            pst.setInt(2, newInfo.getNumberOfSeats());
            pst.setString(3, id); // WHERE clause dùng ID ban đầu để tìm đúng bản ghi

            count = pst.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException ex) {
                    Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return count;
    }

    // Hàm lấy thông tin bàn theo ID
    public Table getTableById(String tableId) throws SQLException {
        PreparedStatement getPst = null;
        ResultSet rs = null;
        Table table = null;
        try {
            sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber FROM [Table] WHERE TableId = ?"; // Chỉ lấy các cột cần thiết
            getPst = conn.prepareStatement(sql);
            getPst.setString(1, tableId);
            rs = getPst.executeQuery();
            if (rs.next()) {
                table = new Table();
                table.setTableId(rs.getString("TableId"));
                table.setTableStatus(rs.getString("TableStatus"));
                table.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                table.setFloorNumber(rs.getInt("FloorNumber"));
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (getPst != null) {
                getPst.close();
            }
        }
        return table;
    }

    public List<Integer> getFloorNumbers() throws SQLException {
        List<Integer> floorNumbers = new ArrayList<>();
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Thêm WHERE clause để lọc IsDeleted = 0
            sql = "SELECT DISTINCT FloorNumber FROM [Table] WHERE IsDeleted = 0 ORDER BY FloorNumber ASC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            while (rs.next()) {
                floorNumbers.add(rs.getInt("FloorNumber"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
        }
        return floorNumbers;
    }

    public int deleteTable(String id) { // Sửa kiểu tham số thành String
        int count = 0;
        try {
            sql = "UPDATE [Table] SET IsDeleted = 1 WHERE TableId=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }
}