package Controller.ManageCustomer;

import DAO.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/DeleteCustomer")
public class DeleteCustomerController extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        boolean success = false;
        System.out.println("Customer deleted successfullyyyyyyyyyyyyyy!");
        try {
            success = customerDAO.deleteCustomer(customerId);
            System.out.println("Customer deleted successfullyyyyyyyyyyyyyy!");
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(DeleteCustomerController.class.getName()).log(Level.SEVERE, null, ex);
            request.getSession().setAttribute("errorMessage", "Database error: " + ex.getMessage());
        }

        if (success) {
          System.out.println("Customer deleted successfully!");
        } else {
            System.out.println("Failed to delete customer.");
        }
        response.sendRedirect(request.getContextPath() + "/ViewCustomerList");
    }
}