package Model;

public class Table {

    private String TableId;
    private String TableStatus;
    private int NumberOfSeats;
    private int FloorNumber;
    private boolean IsDeleted;

    // Default constructor
    public Table() {
        this.IsDeleted = false; // Default value for new tables
    }

    // Constructor for creating a new table (without TableId, as it will be generated)
    public Table(String TableStatus, int NumberOfSeats, int FloorNumber) {
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
        this.IsDeleted = false; // Default for new tables
    }

    // Constructor for updating or retrieving a table (with TableId)
    public Table(String TableId, String TableStatus, int NumberOfSeats, int FloorNumber) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
        this.IsDeleted = false; // Default, will be updated if needed
    }

    // Full constructor
    public Table(String TableId, String TableStatus, int NumberOfSeats, int FloorNumber, boolean IsDeleted) {
        this.TableId = TableId;
        this.TableStatus = TableStatus;
        this.NumberOfSeats = NumberOfSeats;
        this.FloorNumber = FloorNumber;
        this.IsDeleted = IsDeleted;
    }

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