package DAO;

import DB.DBContext;
import Model.Table;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TableDAO {

    private Connection conn;

    public TableDAO() throws ClassNotFoundException, SQLException {
        conn = DB.DBContext.getConnection();
        if (conn == null) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, "Database connection is null");
            throw new SQLException("Failed to establish database connection");
        }
        Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Database connection established");
    }

    public List<Table> getAllTables() throws SQLException {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber, IsDeleted FROM [Table] WHERE IsDeleted = 0";
        try (PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Table table = new Table(
                        rs.getString("TableId"),
                        rs.getString("TableStatus"),
                        rs.getInt("NumberOfSeats"),
                        rs.getInt("FloorNumber"),
                        rs.getBoolean("IsDeleted")
                );
                tables.add(table);
            }
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Found {0} tables", tables.size());
        }
        return tables;
    }

    public List<Table> getAvailableTables() throws SQLException {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber, IsDeleted FROM [Table] WHERE TableStatus = 'Available' AND IsDeleted = 0";
        try (PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Table table = new Table(
                        rs.getString("TableId"),
                        rs.getString("TableStatus"),
                        rs.getInt("NumberOfSeats"),
                        rs.getInt("FloorNumber"),
                        rs.getBoolean("IsDeleted")
                );
                tables.add(table);
            }
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Found {0} available tables", tables.size());
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
        }
    }

    private String getNextTableId(int floorNumber) throws SQLException {
        String maxId = null;
        String nextId;
        String sql = "SELECT MAX(TableId) AS MaxId FROM [Table] WHERE FloorNumber = ?";
        try (PreparedStatement getMaxId = conn.prepareStatement(sql)) {
            getMaxId.setInt(1, floorNumber);
            try (ResultSet rs = getMaxId.executeQuery()) {
                if (rs.next()) {
                    maxId = rs.getString("MaxId");
                }
            }

            String prefix = "TA" + floorNumber;
            if (maxId == null || maxId.trim().isEmpty()) {
                nextId = prefix + "01";
            } else {
                String numericPart = maxId.substring(prefix.length());
                int nextNumber = Integer.parseInt(numericPart) + 1;
                nextId = prefix + String.format("%02d", nextNumber);
            }
        }
        Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Generated TableId: {0} for floor: {1}", new Object[]{nextId, floorNumber});
        return nextId;
    }

    public int createTable(Table newInfo) throws SQLException {
        String sql = "INSERT INTO [Table] (TableId, TableStatus, NumberOfSeats, FloorNumber, IsDeleted) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            int floorNumber = newInfo.getFloorNumber();
            String newTableId = getNextTableId(floorNumber);
            if (newTableId == null) {
                throw new SQLException("Failed to generate TableId for floor: " + floorNumber);
            }

            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO,
                    "Attempting to create table: TableId={0}, TableStatus={1}, NumberOfSeats={2}, FloorNumber={3}",
                    new Object[]{newTableId, newInfo.getTableStatus(), newInfo.getNumberOfSeats(), floorNumber});

            pst.setString(1, newTableId);
            pst.setString(2, newInfo.getTableStatus());
            pst.setInt(3, newInfo.getNumberOfSeats());
            pst.setInt(4, newInfo.getFloorNumber());
            pst.setBoolean(5, false);

            int count = pst.executeUpdate();
            if (count > 0) {
                Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Successfully created table: " + newTableId);
            } else {
                Logger.getLogger(TableDAO.class.getName()).log(Level.WARNING, "No rows affected by INSERT statement");
            }
            return count;
        }
    }

    public int updateTable(String id, Table newInfo) throws SQLException {
        String sql = "UPDATE [Table] SET TableStatus = ?, NumberOfSeats = ?, FloorNumber = ?, IsDeleted = ? WHERE TableId = ?";
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            Table existingTable = getTableById(id);
            if (existingTable == null) {
                Logger.getLogger(TableDAO.class.getName()).log(Level.WARNING, "Table not found: " + id);
                return 0;
            }

            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO,
                    "Updating table: TableId={0}, TableStatus={1}, NumberOfSeats={2}, FloorNumber={3}",
                    new Object[]{id, newInfo.getTableStatus(), newInfo.getNumberOfSeats(), newInfo.getFloorNumber()});

            pst.setString(1, newInfo.getTableStatus());
            pst.setInt(2, newInfo.getNumberOfSeats());
            pst.setInt(3, newInfo.getFloorNumber());
            pst.setBoolean(4, existingTable.isIsDeleted());
            pst.setString(5, id);

            int count = pst.executeUpdate();
            if (count > 0) {
                Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Successfully updated table: " + id);
            } else {
                Logger.getLogger(TableDAO.class.getName()).log(Level.WARNING, "No rows affected by UPDATE statement for TableId: " + id);
            }
            return count;
        }
    }

    public Table getTableById(String tableId) throws SQLException {
        String sql = "SELECT TableId, TableStatus, NumberOfSeats, FloorNumber, IsDeleted FROM [Table] WHERE TableId = ?";
        try (PreparedStatement getPst = conn.prepareStatement(sql)) {
            getPst.setString(1, tableId);
            try (ResultSet rs = getPst.executeQuery()) {
                if (rs.next()) {
                    return new Table(
                            rs.getString("TableId"),
                            rs.getString("TableStatus"),
                            rs.getInt("NumberOfSeats"),
                            rs.getInt("FloorNumber"),
                            rs.getBoolean("IsDeleted")
                    );
                }
            }
        }
        return null;
    }

    public List<Integer> getFloorNumbers() throws SQLException {
        List<Integer> floorNumbers = new ArrayList<>();
        String sql = "SELECT DISTINCT FloorNumber FROM [Table] WHERE IsDeleted = 0 ORDER BY FloorNumber ASC";
        try (PreparedStatement pst = conn.prepareStatement(sql); ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                floorNumbers.add(rs.getInt("FloorNumber"));
            }
        }
        return floorNumbers;
    }

    public int deleteTable(String id) throws SQLException {
        String sql = "UPDATE [Table] SET IsDeleted = 1 WHERE TableId = ?";
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, id);
            int count = pst.executeUpdate();
            Logger.getLogger(TableDAO.class.getName()).log(Level.INFO, "Table soft deleted: " + id);
            return count;
        }
    }
}