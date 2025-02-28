/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageTable;

import DAO.TableDAO;
import Model.Table;
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
 * @author ADMIN
 */
@WebServlet("/UpdateTable") // <-- **Corrected URL mapping**
public class UpdateTableController extends HttpServlet {

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
            out.println("<title>Servlet UpdateTableController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateTableController at " + request.getContextPath() + "</h1>");
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
        String idParam = request.getParameter("id");
        System.out.println(">>> DEBUG (UpdateTableController): Giá trị idParam nhận được: " + idParam); // **Dòng 1**
        if (idParam == null || idParam.isEmpty()) {
            System.out.println(">>> DEBUG (UpdateTableController): idParam là NULL hoặc rỗng, redirect ViewTableList"); // **Dòng 2**
            response.sendRedirect("ViewTableList");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            TableDAO dao = new TableDAO();
            Table table = dao.getTableId(id);
            System.out.println(">>> DEBUG (UpdateTableController): Đối tượng Table nhận được: " + table); // **Dòng 3**

            if (table == null) {
                System.out.println(">>> DEBUG (UpdateTableController): Table là NULL, redirect ViewTableList"); // **Dòng 4**
                response.sendRedirect("ViewTableList");
                return;
            }

            request.setAttribute("table", table);
            request.getRequestDispatcher("ManageTable/UpdateTable.jsp").forward(request, response);
            System.out.println(">>> DEBUG (UpdateTableController): Forwarding to UpdateTable.jsp"); // **Dòng 5**

        } catch (NumberFormatException e) {
            System.out.println(">>> DEBUG (UpdateTableController): NumberFormatException, redirect ViewTableList"); // **Dòng 6**
            response.sendRedirect("ViewTableList");
        } catch (Exception e) {
            System.out.println(">>> DEBUG (UpdateTableController): Exception, redirect ViewTableList"); // **Dòng 7**
            e.printStackTrace(); // **Quan trọng: Giữ lại stack trace**
            response.sendRedirect("ViewTableList");
        }
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
        try {
            int TableId = Integer.parseInt(request.getParameter("TableIdHidden")); // Get NumberOfSeats as String    }
            String TableStatus = request.getParameter("TableStatus");
            int NumberOfSeats = Integer.parseInt(request.getParameter("NumberOfSeats")); // Get NumberOfSeats as String    }
            
            TableDAO dao = new TableDAO();
            Table table = new Table(TableId, TableStatus, NumberOfSeats);
            int count = dao.updateTable(TableId, table);
            
            // Redirect based on whether the update was successful
            if (count > 0) {
                response.sendRedirect("ViewTableList");
            } else {
                response.sendRedirect("UpdateTable?id=" + TableId);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UpdateTableController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateTableController.class.getName()).log(Level.SEVERE, null, ex);
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
