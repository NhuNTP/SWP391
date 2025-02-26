/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.CustomerController;

import DAO.CustomerDAO;
import Model.Customer;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet("/UpdateCustomerProfile")
public class UpdateCustomerProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = null;
        try {
            customer = customerDAO.getCustomerById(customerId);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/ManageCustomer/UpdateCustomerProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        int numberOfPayment = Integer.parseInt(request.getParameter("numberOfPayment"));

        Customer customer = new Customer(customerId, customerName, customerPhone, numberOfPayment);
        try {
            customerDAO.updateCustomer(customer);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateCustomerProfileController.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect("ViewCustomerList");
    }
}