/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManagerAccount;

import DAO.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ADMIN
 */
@WebServlet("/DeleteAccount")

public class DeleteAccountController extends HttpServlet {

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
            out.println("<title>Servlet DeleteAccountController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteAccountController at " + request.getContextPath() + "</h1>");
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
       String UserId = request.getParameter("UserId"); // Lấy ID dưới dạng String

        if (UserId == null || UserId.isEmpty()) {
            response.sendRedirect("ViewAccountList"); // Chuyển hướng nếu không có ID
            return;
        }

        try {
            AccountDAO tableDAO = new AccountDAO();
            int count = tableDAO.deleteAccount(UserId); // Gọi deleteAccount(String)
            if (count > 0) {
                System.out.println("Account with ID " + UserId + " deleted successfully."); // Log success
            } else {
                System.out.println("Failed to delete table with ID " + UserId + " or table not found."); // Log failure
            }

        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + UserId); // Log invalid ID format error
        } catch (Exception e) {
            System.err.println("Error deleting table: " + e.getMessage()); // Log general error
            e.printStackTrace(); // Print stack trace for debugging
        }

        response.sendRedirect("ViewAccountList"); // Redirect to ViewAccountList after deletion attempt
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
            response.sendRedirect("ViewListAccount");
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
