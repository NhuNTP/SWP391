package Controller.ManagerAccount;

import DAO.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteAccount")
public class DeleteAccountController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("UserId");

        if (userId == null || userId.isEmpty()) {
            response.sendRedirect("ViewAccountList");
            return;
        }

        try {
            AccountDAO dao = new AccountDAO();
            int count = dao.deleteAccount(userId);
            if (count > 0) {
                System.out.println("Account with ID " + userId + " deleted successfully.");
            } else {
                System.out.println("Failed to delete account with ID " + userId + " or account not found.");
            }
        } catch (Exception e) {
            System.err.println("Error deleting account: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("ViewAccountList");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to delete an account";
    }
}