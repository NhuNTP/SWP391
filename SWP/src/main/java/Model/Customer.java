package Model;
/**
 *
 * @author HuynhPhuBinh
 */
public class Customer {

    private int CustomerId;
    private String CustomerName;
    private String CustomerPhone;
    private int NumberOfPayment;

    public Customer() {
    }

    public Customer(String CustomerName, String CustomerPhone, int NumberOfPayment) {
        this.CustomerName = CustomerName;
        this.CustomerPhone = CustomerPhone;
        this.NumberOfPayment = NumberOfPayment;
    }

    public Customer(int CustomerId, String CustomerName, String CustomerPhone, int NumberOfPayment) {
        this.CustomerId = CustomerId;
        this.CustomerName = CustomerName;
        this.CustomerPhone = CustomerPhone;
        this.NumberOfPayment = NumberOfPayment;
    }

    public int getCustomerId() {
        return CustomerId;
    }

    public void setCustomerId(int CustomerId) {
        this.CustomerId = CustomerId;
    }

    public String getCustomerName() {
        return CustomerName;
    }

    public void setCustomerName(String CustomerName) {
        this.CustomerName = CustomerName;
    }

    public String getCustomerPhone() {
        return CustomerPhone;
    }

    public void setCustomerPhone(String CustomerPhone) {
        this.CustomerPhone = CustomerPhone;
    }

    public int getNumberOfPayment() {
        return NumberOfPayment;
    }

    public void setNumberOfPayment(int NumberOfPayment) {
        this.NumberOfPayment = NumberOfPayment;
    }

}