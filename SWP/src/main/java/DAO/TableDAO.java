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

    // Thêm phương thức mới: lấy tất cả các bàn
    public List<Table> getAllTables() {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber FROM [Table] WHERE IsDeleted = 0";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getString("TableId"));
                table.setTableStatus(rs.getString("TableStatus"));
                table.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                table.setFloorNumber(rs.getInt("FloorNumber"));
                tables.add(table);
            }
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Found {0} tables", tables.size());
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, "Error fetching all tables", ex);
        }
        return tables;
    }

    public List<Table> getAvailableTables() {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber FROM [Table] WHERE TableStatus = 'Available' AND IsDeleted = 0";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getString("TableId"));
                table.setTableStatus(rs.getString("TableStatus"));
                table.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                table.setFloorNumber(rs.getInt("FloorNumber"));
                tables.add(table);
            }
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Found {0} available tables", tables.size());
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, "Error fetching available tables", ex);
        }
        return tables;
    }

    public void updateTableStatus(String tableId, String status) throws SQLException {
        String sql = "UPDATE [Table] SET TableStatus = ? WHERE TableId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, tableId);
            pstmt.executeUpdate();
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Updated table {0} status to {1}", new Object[]{tableId, status});
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, "Error updating table status", ex);
            throw ex;
        }
    }

    private String getNextTableId(int floorNumber) throws SQLException {
        String maxId = null;
        String nextId = null;
        PreparedStatement getMaxId = null;

        try {
            sql = "SELECT MAX(TableId) AS MaxId FROM [Table] WHERE FloorNumber = ?";
            getMaxId = conn.prepareStatement(sql);
            getMaxId.setInt(1, floorNumber);
            ResultSet rs = getMaxId.executeQuery();

            if (rs.next()) {
                maxId = rs.getString("MaxId");
            }

            String prefix = "TA" + floorNumber;
            if (maxId == null) {
                nextId = prefix + "01";
            } else {
                String numericPart = maxId.substring(prefix.length());
                int nextNumber = Integer.parseInt(numericPart) + 1;
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
            int floorNumber = newInfo.getFloorNumber();
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
        String newTableId = id;

        try {
            Table existingTable = getTableById(id);
            if (existingTable == null) {
                return 0;
            }
            int oldFloorNumber = existingTable.getFloorNumber();
            int newFloorNumber = newInfo.getFloorNumber();

            if (oldFloorNumber != newFloorNumber) {
                String potentialNewTableId = getNextTableId(newFloorNumber);
                if (isTableIdExists(potentialNewTableId)) {
                    int suffixNumber = Integer.parseInt(potentialNewTableId.substring(potentialNewTableId.length() - 2));
                    while (isTableIdExists("TA" + newFloorNumber + String.format("%02d", suffixNumber))) {
                        suffixNumber++;
                        if (suffixNumber > 99) {
                            throw new SQLException("Không thể tạo ID bàn mới, hết số thứ tự trên tầng " + newFloorNumber);
                        }
                    }
                    newTableId = "TA" + newFloorNumber + String.format("%02d", suffixNumber);
                } else {
                    newTableId = potentialNewTableId;
                }
            }

            sql = "UPDATE [Table] SET TableId=?, TableStatus=?, NumberOfSeats=?, FloorNumber=? WHERE TableId=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newTableId);
            pst.setString(2, newInfo.getTableStatus());
            pst.setInt(3, newInfo.getNumberOfSeats());
            pst.setInt(4, newInfo.getFloorNumber());
            pst.setString(5, id);

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

    private boolean isTableIdExists(String tableId) throws SQLException {
        PreparedStatement checkPst = null;
        ResultSet rs = null;
        try {
            sql = "SELECT 1 FROM [Table] WHERE TableId = ?";
            checkPst = conn.prepareStatement(sql);
            checkPst.setString(1, tableId);
            rs = checkPst.executeQuery();
            return rs.next();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (checkPst != null) {
                checkPst.close();
            }
        }
    }

    public Table getTableById(String tableId) throws SQLException {
        PreparedStatement getPst = null;
        ResultSet rs = null;
        Table table = null;
        try {
            sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber FROM [Table] WHERE TableId = ?";
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

    public int deleteTable(String id) {
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