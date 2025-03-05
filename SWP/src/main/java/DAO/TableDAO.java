/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DB.DBContext;
import Model.Table;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
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
            // Modified to get only non-deleted tables
            sql = "SELECT * FROM [Table] WHERE IsDeleted = 0";
            rs = st.executeQuery(sql);
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace();
        }
        return rs;
    }

    public int createTable(Table newInfo) {
        int count = 0;
        try {
            sql = "INSERT INTO [Table] (TableStatus, NumberOfSeats) VALUES (?, ?)"; // Corrected table name to [Table]
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getTableStatus());
            pst.setInt(2, newInfo.getNumberOfSeats());
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public Table getTableId(int id) {
        Table obj = null;
        try {
            sql = "SELECT TableId, TableStatus, NumberOfSeats FROM [Table] WHERE TableId = ?"; // Corrected table name to [Table]
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Table();
                obj.setTableId(rs.getInt("TableId"));
                obj.setTableStatus(rs.getString("TableStatus"));
                obj.setNumberOfSeats(rs.getInt("NumberOfSeats"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return obj;
    }

    public int updateTable(int id, Table newInfo) {
        int count = 0;
        try {
            sql = "UPDATE [Table] SET TableStatus=?, NumberOfSeats=? WHERE TableId=?"; // Corrected table name to [Table]
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, newInfo.getTableStatus());
            pst.setInt(2, newInfo.getNumberOfSeats());
            pst.setInt(3, id);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public int deleteTable(int id) {
        int count = 0;
        try {
            // Modified to update IsDeleted instead of deleting
            sql = "UPDATE [Table] SET IsDeleted = 1 WHERE TableId=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }
}
