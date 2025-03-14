package Controller.ManagerAccount;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewAccountList")
public class ViewAccountListController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ajaxRequest = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(ajaxRequest)) {
            // Xử lý yêu cầu AJAX
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder jsonResponse = new StringBuilder("[");

            try {
                AccountDAO dao = new AccountDAO();
                ResultSet rs = dao.getAllAccount();
                List<Account> accountList = new ArrayList<>();
                boolean first = true;

                while (rs.next()) {
                    Account account = new Account();
                    account.setUserId(rs.getString("UserId"));
                    account.setUserEmail(rs.getString("UserEmail"));
                    account.setUserPassword(rs.getString("UserPassword"));
                    account.setUserName(rs.getString("UserName"));
                    account.setUserRole(rs.getString("UserRole"));
                    account.setIdentityCard(rs.getString("IdentityCard"));
                    account.setUserAddress(rs.getString("UserAddress"));
                    account.setUserImage(rs.getString("UserImage"));
                    accountList.add(account);

                    if (!first) {
                        jsonResponse.append(",");
                    } else {
                        first = false;
                    }
                    jsonResponse.append("{")
                            .append("\"userId\":\"").append(escapeJson(account.getUserId())).append("\",")
                            .append("\"userEmail\":\"").append(escapeJson(account.getUserEmail())).append("\",")
                            .append("\"userPassword\":\"").append(escapeJson(account.getUserPassword())).append("\",")
                            .append("\"userName\":\"").append(escapeJson(account.getUserName())).append("\",")
                            .append("\"userRole\":\"").append(escapeJson(account.getUserRole())).append("\",")
                            .append("\"identityCard\":\"").append(escapeJson(account.getIdentityCard())).append("\",")
                            .append("\"userAddress\":\"").append(escapeJson(account.getUserAddress())).append("\",")
                            .append("\"userImage\":\"").append(escapeJson(account.getUserImage())).append("\"")
                            .append("}");
                }

                jsonResponse.append("]");
                out.print(jsonResponse.toString());
            } catch (ClassNotFoundException | SQLException ex) {
                Logger.getLogger(ViewAccountListController.class.getName()).log(Level.SEVERE, null, ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading account list");
            } finally {
                out.close();
            }
        } else {
            // Xử lý yêu cầu thông thường (truy cập trang lần đầu)
            try {
                AccountDAO dao = new AccountDAO();
                ResultSet rs = dao.getAllAccount();
                List<Account> accountList = new ArrayList<>();

                while (rs.next()) {
                    Account account = new Account();
                    account.setUserId(rs.getString("UserId"));
                    account.setUserEmail(rs.getString("UserEmail"));
                    account.setUserPassword(rs.getString("UserPassword"));
                    account.setUserName(rs.getString("UserName"));
                    account.setUserRole(rs.getString("UserRole"));
                    account.setIdentityCard(rs.getString("IdentityCard"));
                    account.setUserAddress(rs.getString("UserAddress"));
                    account.setUserImage(rs.getString("UserImage"));
                    accountList.add(account);
                }

                request.setAttribute("accountList", accountList);
                request.getRequestDispatcher("ManageAccount/ViewAccountList.jsp").forward(request, response);
            } catch (ClassNotFoundException | SQLException ex) {
                Logger.getLogger(ViewAccountListController.class.getName()).log(Level.SEVERE, null, ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading account list");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Hàm thoát ký tự đặc biệt để đảm bảo JSON hợp lệ
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    public String getServletInfo() {
        return "Servlet to view account list";
    }
}