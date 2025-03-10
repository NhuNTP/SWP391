package Controller;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "Login", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang login khi truy cập bằng GET
        request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.login(username, password);

            if (account != null) {
                HttpSession session = request.getSession();
                session.setAttribute("account", account);

                // Chuyển hướng theo vai trò
                switch (account.getUserRole()) {
                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/dashboard");
                        break;
                    case "Manager":
                        response.sendRedirect(request.getContextPath() + "/Dashboard/ManagerDashboard.jsp");
                        break;
                    case "Cashier":
                        response.sendRedirect(request.getContextPath() + "/Dashboard/CashierDashboard.jsp");
                        break;
                    case "Waiter":
                        response.sendRedirect(request.getContextPath() + "/Dashboard/WaiterDashboard.jsp");
                        break;
                    case "kitchen staff":
                        response.sendRedirect(request.getContextPath() + "/Dashboard/KitchenstaffDashboard.jsp");
                        break;
                    default:
                        LOGGER.warning("Unknown role for user: " + username);
                        response.sendRedirect(request.getContextPath() + "/LoginPage.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Incorrect username, password or account has been deleted!");
                request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "Database driver not found", ex);
            request.setAttribute("error", "System error, please try again later!");
            request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL error during login", ex);
            request.setAttribute("error", "System error, please try again later!");
            request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Controller for user authentication";
    }
}