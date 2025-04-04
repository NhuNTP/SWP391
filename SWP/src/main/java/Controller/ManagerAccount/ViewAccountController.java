package Controller.ManagerAccount;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.mail.MessagingException;
import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@WebServlet("/ViewAccountList")
public class ViewAccountController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Debug classloader
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            try {
                Class<?> messagingExceptionClass = classLoader.loadClass("jakarta.mail.MessagingException");
                System.out.println("jakarta.mail.MessagingException loaded successfully: " + messagingExceptionClass);
            } catch (ClassNotFoundException e) {
                System.out.println("Failed to load jakarta.mail.MessagingException: " + e.getMessage());
            }

            AccountDAO dao = new AccountDAO();
            List<Account> accountList = dao.getAllAccount();
            request.setAttribute("accountList", accountList);
            request.getRequestDispatcher("/ManageAccount/ViewAccountList.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ViewAccountController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading account list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to view account list";
    }
}
