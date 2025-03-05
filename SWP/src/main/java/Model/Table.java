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

    private String TableId; // Sửa thành String
    private String TableStatus;
    private int NumberOfSeats;
    private int FloorNumber; // Sửa thành int (cho phép null)
    private boolean IsDeleted;

    // Constructor không tham số (default constructor)
    public Table() {
        this.IsDeleted = false; // Giá trị mặc định
    }

    // Constructor đầy đủ
    public Table(String TableId, String TableStatus, int NumberOfSeats, int FloorNumber, boolean IsDeleted) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
        this.IsDeleted = IsDeleted;
    }

    // Constructor không có TableId (cho trường hợp insert)
    public Table(String TableStatus, int NumberOfSeats, int FloorNumber) {
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
    }

    public Table(String TableId, String TableStatus, int NumberOfSeats, int FloorNumber) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
    }
    
    // Các constructor khác có thể không cần thiết, tùy vào cách bạn sử dụng
    // Getters and Setters
    public String getTableId() {
        return TableId;
    }

    public void setTableId(String TableId) {
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

    public int getFloorNumber() {
        return FloorNumber;
    }

    public void setFloorNumber(int FloorNumber) {
        this.FloorNumber = FloorNumber;
    }

    public boolean isIsDeleted() {
        return IsDeleted;
    }

    public void setIsDeleted(boolean IsDeleted) {
        this.IsDeleted = IsDeleted;
    }
}