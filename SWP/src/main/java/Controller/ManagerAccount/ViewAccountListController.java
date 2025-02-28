package Controller.ManagerAccount;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
@WebServlet("/ViewAccountList")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 50, // 50MB (tăng từ 10MB)
        maxRequestSize = 1024 * 1024 * 100 // 100MB (tăng từ 50MB)
)
public class ViewAccountListController extends HttpServlet {

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
            out.println("<title>Servlet ViewAccountListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewAccountListController at " + request.getContextPath() + "</h1>");
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
        try {
            AccountDAO dao = new AccountDAO();
            ResultSet rs = dao.getAllAccount();
            List<Account> accountList = new ArrayList<>();
            
            try {
                while (rs.next()) {
                    Account account = new Account();
                    account.setUserId(rs.getInt("UserId"));
                    account.setUserEmail(rs.getString("UserEmail"));
                    account.setUserPassword(rs.getString("UserPassword"));
                    account.setUserName(rs.getString("UserName"));
                    account.setUserRole(rs.getString("UserRole"));
                    account.setIdentityCard(rs.getString("IdentityCard"));
                    account.setUserAddress(rs.getString("UserAddress"));
                    account.setUserImage(rs.getString("UserImage")); // **Quan trọng: Đảm bảo lấy cột UserImage**
                    accountList.add(account);
                }
            } catch (SQLException e) {
                e.printStackTrace(); // In thực tế nên log lỗi thay vì in ra console
            }
            
            request.setAttribute("accountList", accountList); // Lưu danh sách account vào request attribute
            request.getRequestDispatcher("ManageAccount/ViewAccountList.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewAccountListController.class.getName()).log(Level.SEVERE, null, ex); 
        } catch (SQLException ex) {
            Logger.getLogger(ViewAccountListController.class.getName()).log(Level.SEVERE, null, ex);
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
        processRequest(request, response);
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
