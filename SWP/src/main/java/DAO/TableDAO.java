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
        ResultSet rs = null;
        String newTableId = id; // Giữ ID cũ mặc định

        try {
            // 1. Lấy thông tin bàn hiện tại từ database dựa trên id (TableId)
            Table existingTable = getTableById(id);
            if (existingTable == null) {
                return 0; // Hoặc throw exception, bàn không tồn tại
            }
            int oldFloorNumber = existingTable.getFloorNumber();
            int newFloorNumber = newInfo.getFloorNumber();

            // 2. Kiểm tra xem FloorNumber có thay đổi không
            if (oldFloorNumber != newFloorNumber) {
                // 3. Tạo ID bàn mới tiềm năng dựa trên tầng mới
                String potentialNewTableId = getNextTableId(newFloorNumber);

                // 4. Kiểm tra xem ID mới tiềm năng đã tồn tại chưa
                if (isTableIdExists(potentialNewTableId)) {
                    // 5. Xử lý xung đột ID: Tạo ID mới khác bằng cách tăng số thứ tự
                    int suffixNumber = Integer.parseInt(potentialNewTableId.substring(potentialNewTableId.length() - 3));
                    while (isTableIdExists("TA" + newFloorNumber + String.format("%02d", suffixNumber))) {
                        suffixNumber++;
                        if (suffixNumber > 999) { // Đề phòng trường hợp hết số, cần xử lý lỗi khác nếu cần
                            throw new SQLException("Không thể tạo ID bàn mới, hết số thứ tự trên tầng " + newFloorNumber);
                        }
                    }
                    newTableId = "TA" + newFloorNumber + String.format("%03d", suffixNumber);
                } else {
                    newTableId = potentialNewTableId; // ID tiềm năng chưa tồn tại, dùng nó
                }
            } // Nếu FloorNumber không đổi, giữ nguyên newTableId = id ban đầu

            // 6. Cập nhật thông tin bàn vào database, sử dụng newTableId (có thể là ID mới hoặc ID cũ)
            sql = "UPDATE [Table] SET TableId=?, TableStatus=?, NumberOfSeats=?, FloorNumber=? WHERE TableId=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newTableId); // Set TableId mới (hoặc cũ)
            pst.setString(2, newInfo.getTableStatus());
            pst.setInt(3, newInfo.getNumberOfSeats());
            pst.setInt(4, newInfo.getFloorNumber());
            pst.setString(5, id); // WHERE clause dùng ID ban đầu để tìm đúng bản ghi

            count = pst.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
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

    // Hàm kiểm tra xem TableId đã tồn tại chưa
    private boolean isTableIdExists(String tableId) throws SQLException {
        PreparedStatement checkPst = null;
        ResultSet rs = null;
        try {
            sql = "SELECT 1 FROM [Table] WHERE TableId = ?";
            checkPst = conn.prepareStatement(sql);
            checkPst.setString(1, tableId);
            rs = checkPst.executeQuery();
            return rs.next(); // Nếu có kết quả trả về, tức là ID đã tồn tại
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (checkPst != null) {
                checkPst.close();
            }
        }
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

    /*
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
                nextId = prefix + "101"; // Nếu chưa có bàn nào ở tầng này, bắt đầu từ TA[Tầng]101
            } else {
                // Lấy phần số từ ID hiện tại (ví dụ: "102" từ "TA102")
                // Cắt bỏ phần prefix "TA[Tầng]" để lấy phần số
                String numericPart = maxId.substring(prefix.length());
                int nextNumber = Integer.parseInt(numericPart) + 1; // Tăng số lên 1
                // Định dạng lại số thành chuỗi 3 chữ số (ví dụ: 103)
                nextId = prefix + String.format("%02d", nextNumber);
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

    public Table getTableById(String id) { // Sửa kiểu tham số thành String
        Table obj = null;
        try {
            sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber FROM [Table] WHERE TableId = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Table();
                obj.setTableId(rs.getString("TableId"));
                obj.setTableStatus(rs.getString("TableStatus"));
                obj.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                obj.setFloorNumber(rs.getInt("FloorNumber"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return obj;
    }

    public int updateTable(String id, Table newInfo) {
        int count = 0;
        try {
            // Thêm FloorNumber vào, bỏ IsDeleted
            sql = "UPDATE [Table] SET TableStatus=?, NumberOfSeats=?, FloorNumber=? WHERE TableId=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getTableStatus());
            pst.setInt(2, newInfo.getNumberOfSeats());
            pst.setInt(3, newInfo.getFloorNumber()); // Không cần kiểm tra null
            pst.setString(4, id);

            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    } */
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
