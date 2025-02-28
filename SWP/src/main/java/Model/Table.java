/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ADMIN
 */
public class Table {

    private int TableId;
    private String TableStatus;
    private int NumberOfSeats;
    private boolean IsDeleted; // Add IsDeleted field as boolean

    // Constructor không tham số (default constructor)
    public Table() {
        this.IsDeleted = false; // Initialize IsDeleted to false by default in Java model as well
    }

    // Constructor có tham số
    public Table(int TableId, String TableStatus, int NumberOfSeats, boolean IsDeleted) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.IsDeleted = IsDeleted;
    }

    public Table(String TableStatus, int NumberOfSeats) {
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.IsDeleted = false; // Initialize IsDeleted to false when creating new table
    }

    public Table(int TableId, String TableStatus, int NumberOfSeats) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
    }
    

    public int getTableId() {
        return TableId;
    }

    public void setTableId(int TableId) {
        this.TableId = TableId;
    }

    public String getTableStatus() {
        return TableStatus;
    }

    public void setTableStatus(String TableStatus) {
        this.TableStatus = TableStatus;
    }

    public int getNumberOfSeats() {
        return NumberOfSeats;
    }

    public void setNumberOfSeats(int NumberOfSeats) {
        this.NumberOfSeats = NumberOfSeats;
    }

    public boolean isIsDeleted() {
        return IsDeleted;
    }

    public void setIsDeleted(boolean IsDeleted) {
        this.IsDeleted = IsDeleted;
    }


}