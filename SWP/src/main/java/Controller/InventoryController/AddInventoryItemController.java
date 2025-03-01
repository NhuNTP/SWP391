/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.InventoryController;

import DAO.InventoryDAO;
import Model.Inventory;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL-Laptop
 */
@WebServlet(name = "AddInventoryItemController", urlPatterns = {"/AddInventoryItemController"})
public class AddInventoryItemController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddInventoryItemController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddInventoryItemController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemName = request.getParameter("itemName");
        String itemType = request.getParameter("itemType");
        String itemPrice_raw = request.getParameter("itemPrice"); // Get price as String
        String itemQuantity_raw = request.getParameter("itemQuantity"); // Get quantity as String
        String itemUnit = request.getParameter("itemUnit");
        String itemDescription = request.getParameter("itemDescription");

        try {
            double itemPrice = Double.parseDouble(itemPrice_raw); // Parse price to double
            int itemQuantity = Integer.parseInt(itemQuantity_raw); // Parse quantity to int

            Inventory newItem = new Inventory(); // Create new InventoryItem object
            newItem.setItemName(itemName);
            newItem.setItemType(itemType);
            newItem.setItemPrice(itemPrice);
            newItem.setItemQuantity(itemQuantity);
            newItem.setItemUnit(itemUnit);
            newItem.setItemDescription(itemDescription);

            InventoryDAO invDao = new InventoryDAO(); // Create InventoryDAO instance
            invDao.addNewInventoryItem(newItem); // Call addNewInventoryItem method

            response.sendRedirect("ViewInventoryController"); // Redirect to ViewInventoryItemController

        } catch (NumberFormatException e) {
            // Handle NumberFormatException if itemPrice or itemQuantity are not valid numbers
            request.setAttribute("error", "Giá trị Price và Quantity phải là số hợp lệ."); // Set error message
            request.getRequestDispatcher("AddInventoryItem.jsp").forward(request, response); // Forward back to AddInventoryItem.jsp
            e.printStackTrace(); // Log the exception for debugging
        } catch (Exception e) {
            // Handle other exceptions (e.g., database errors)
            request.setAttribute("error", "Đã có lỗi xảy ra khi thêm sản phẩm vào kho."); // Set generic error message
            request.getRequestDispatcher("AddInventoryItem.jsp").forward(request, response); // Forward back to AddInventoryItem.jsp
            e.printStackTrace(); // Log the exception for debugging
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
