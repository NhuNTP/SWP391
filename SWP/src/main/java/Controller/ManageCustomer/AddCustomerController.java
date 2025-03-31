package Controller.ManageCustomer;

import DAO.CustomerDAO;
import Model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AddCustomer")
public class AddCustomerController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String customerName = request.getParameter("CustomerName");
        String customerPhone = request.getParameter("CustomerPhone");
        String numberOfPaymentStr = request.getParameter("NumberOfPayment");

        System.out.println("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK9999999999999999999");
        System.out.println(customerName);
        System.out.println(customerPhone);
        System.out.println(numberOfPaymentStr);
        // Server-side validation
//        // Validate customer name
//        if (customerName == null || customerName.trim().length() < 2) {
//            session.setAttribute("errorMessage", "Customer name must be at least 2 characters.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//      
//
//        // Validate customer phone
//        if (customerPhone == null || customerPhone.trim().isEmpty()) {
//            session.setAttribute("errorMessage", "Phone number cannot be empty.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//
//        // Check if phone number contains only digits
//        if (!customerPhone.matches("\\d+")) {
//            session.setAttribute("errorMessage", "Invalid phone number format. Only digits are allowed.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//
//        // Check phone number length (must be 10 or 11 digits)
//        if (customerPhone.length() < 10 || customerPhone.length() > 11) {
//            session.setAttribute("errorMessage", "Phone number must be 10 or 11 digits.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//
//        // Check if phone number is a valid number and not negative
//        try {
//            long phoneNumber = Long.parseLong(customerPhone);
//            if (phoneNumber < 0) {
//                session.setAttribute("errorMessage", "Phone number cannot be negative.");
//                response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//                return;
//            }
//        } catch (NumberFormatException e) {
//            session.setAttribute("errorMessage", "Invalid phone number format.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//
//        // Validate number of payments
//        int numberOfPayment = 0;
//        if (numberOfPaymentStr == null || numberOfPaymentStr.trim().isEmpty()) {
//            session.setAttribute("errorMessage", "Number of payments cannot be empty.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }
//
//        try {
//            numberOfPayment = Integer.parseInt(numberOfPaymentStr);
//            if (numberOfPayment < 0) {
//                session.setAttribute("errorMessage", "Number of payments cannot be negative.");
//                response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//                return;
//            }
//            if (numberOfPayment == 0) {
//                session.setAttribute("errorMessage", "Number of payments must be greater than 0.");
//                response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//                return;
//            }
//            if (numberOfPayment > 1000) {
//                session.setAttribute("errorMessage", "Number of payments cannot exceed 1000.");
//                response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//                return;
//            }
//        } catch (NumberFormatException e) {
//            session.setAttribute("errorMessage", "Invalid number of payments.");
//            response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
//            return;
//        }

        CustomerDAO customerDAO = new CustomerDAO();
        int numberOfPayment = Integer.parseInt(numberOfPaymentStr);
        try {
            // Check for duplicate phone number
            System.out.println(customerDAO.isPhoneExists(customerPhone, null));
            if (customerDAO.isPhoneExists(customerPhone, null)) {
                System.out.println(customerDAO.isPhoneExists(customerPhone, null));
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Customer phone already exists. Please check agains.");
               
                return;
            }

            // If all validations pass, add the customer
            String customerId = customerDAO.generateNextCustomerId();
            Customer customer = new Customer(customerId, customerName, customerPhone, numberOfPayment);
            customerDAO.addCustomer(customer);
            session.setAttribute("message", "Customer added successfully!");
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(AddCustomerController.class.getName()).log(Level.SEVERE, null, ex);
            session.setAttribute("errorMessage", "Database error: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
    }
}
