package Controller.ManageCustomer;

import DAO.CustomerDAO;
import Model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.text.DecimalFormat;

@WebServlet("/AddCustomer")
public class AddCustomerController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String customerName = request.getParameter("CustomerName");
        String customerPhone = request.getParameter("CustomerPhone");
        String numberOfPaymentStr = request.getParameter("NumberOfPayment");

        int numberOfPayment = 0; // Default value

        if (numberOfPaymentStr != null && !numberOfPaymentStr.isEmpty()) {
            try {
                numberOfPayment = Integer.parseInt(numberOfPaymentStr);
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Log the error
                request.setAttribute("errorMessage", "Invalid Number Of Payment. Please enter a valid number.");
                request.getRequestDispatcher("ViewCustomerList").forward(request, response);
                return; // Stop further processing
            }
        } else {
            // Handle the case where NumberOfPayment is null or empty
            request.setAttribute("errorMessage", "Number Of Payment is required.");
            request.getRequestDispatcher("ViewCustomerList").forward(request, response);
            return; // Stop further processing
        }

        CustomerDAO customerDAO = new CustomerDAO();

        try {

           String customerId  = customerDAO.generateNextCouponId();

            Customer customer = new Customer(customerId, customerName, customerPhone, numberOfPayment);

            customerDAO.addCustomer(customer);

        } catch (SQLException ex) {
            Logger.getLogger(AddCustomerController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("ViewCustomerList").forward(request, response);
            return;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AddCustomerController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Class not found error: " + ex.getMessage());
            request.getRequestDispatcher("ViewCustomerList").forward(request, response);
            return;
        }
        response.sendRedirect("ViewCustomerList"); // Redirect to ViewCustomerList after adding
    }
}