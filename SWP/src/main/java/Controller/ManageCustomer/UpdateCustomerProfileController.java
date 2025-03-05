package Controller.ManageCustomer;

import DAO.CustomerDAO;
import Model.Customer;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HuynhPhuBinh
 */
@WebServlet("/UpdateCustomer")
public class UpdateCustomerProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        Customer customer = null;
        try {
            customer = customerDAO.getCustomerById(customerId);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("ManageCustomer/UpdateCustomerProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        String customerName = request.getParameter("CustomerName"); // Corrected parameter name
        String customerPhone = request.getParameter("CustomerPhone"); // Corrected parameter name
        String numberOfPaymentStr = request.getParameter("NumberOfPayment"); // Corrected parameter name

        int numberOfPayment;

        if (numberOfPaymentStr == null || numberOfPaymentStr.isEmpty()) {
            numberOfPayment = 0; // Default value
        } else {
            try {
                numberOfPayment = Integer.parseInt(numberOfPaymentStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Number of Payments.");
                request.getRequestDispatcher("ViewCustomerList").forward(request, response);
                return;
            }
        }

        Customer customer = new Customer(customerId, customerName, customerPhone, numberOfPayment);
        try {
            customerDAO.updateCustomer(customer);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
             request.setAttribute("errorMessage", "Database error during update: " + ex.getMessage());
            request.getRequestDispatcher("ViewCustomerList").forward(request, response);
            return;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Class not found error: " + ex.getMessage());
            request.getRequestDispatcher("ViewCustomerList").forward(request, response);
            return;
        }

        response.sendRedirect("ViewCustomerList");
    }
}