package Controller.ManagerAccount;

import DAO.AccountDAO;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/CreateAccount")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 100
)
public class CreateAccountController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();

        try {
            String action = request.getParameter("action");

            if ("submitForm".equals(action)) {
                String UserEmail = request.getParameter("UserEmail");
                String UserPassword = request.getParameter("UserPassword");
                String UserName = request.getParameter("UserName");
                String UserRole = request.getParameter("UserRole");
                String IdentityCard = request.getParameter("IdentityCard");
                String UserAddress = request.getParameter("UserAddress");
                String UserPhone = request.getParameter("UserPhone");

                Part filePart = request.getPart("UserImage");
                String UserImage = null;

                if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

                    String webAppRoot = getServletContext().getRealPath("/");
                    File webAppRootDir = new File(webAppRoot);
                    File targetDir = webAppRootDir.getParentFile();
                    File projectRootDir = targetDir.getParentFile();
                    String srcWebAppPath = new File(projectRootDir, "src/main/webapp").getAbsolutePath();
                    String uploadPath = srcWebAppPath + File.separator + "ManageAccount/account_img";

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + uniqueFileName;
                    UserImage = "ManageAccount/account_img/" + uniqueFileName;

                    try (InputStream fileContent = filePart.getInputStream()) {
                        Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    }
                }

                Account account = new Account(null, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserPhone, UserImage, false);
                AccountDAO dao = new AccountDAO();

                if (dao.isEmailExists(UserEmail, null)) {
                    jsonResponse.append("{\"success\":false,\"message\":\"Email already exists. Please enter a different email.\"}");
                } else if (IdentityCard != null && !IdentityCard.isEmpty() && dao.isIdentityCardExists(IdentityCard, null)) {
                    jsonResponse.append("{\"success\":false,\"message\":\"Identity card/CCCD already exists. Please enter a different number.\"}");
                } else {
                    int count = dao.createAccount(account);
                    if (count > 0) {
                        request.getSession().setAttribute("tempAccount", account);
                        jsonResponse.append("{\"success\":true,\"message\":\"A confirmation code has been sent to your email. Please enter it within 3 minutes to complete registration.\"}");
                    } else if (count == -3) {
                        jsonResponse.append("{\"success\":false,\"message\":\"Failed to send email. Please check if the email address is valid.\"}");
                    } else {
                        jsonResponse.append("{\"success\":false,\"message\":\"An error occurred while processing your request.\"}");
                    }
                }
            } else if ("confirmCode".equals(action)) {
                String confirmationCode = request.getParameter("confirmationCode");
                Account tempAccount = (Account) request.getSession().getAttribute("tempAccount");
                AccountDAO dao = new AccountDAO();

                if (tempAccount != null) {
                    int result = dao.confirmAndCreateAccount(tempAccount, confirmationCode);
                    if (result > 0) {
                        request.getSession().removeAttribute("tempAccount");
                        jsonResponse.append("{\"success\":true,\"message\":\"Account created successfully. Check your email for account details.\"}");
                    } else if (result == -4) {
                        jsonResponse.append("{\"success\":false,\"message\":\"Confirmation code has expired. Please try again.\"}");
                    } else {
                        jsonResponse.append("{\"success\":false,\"message\":\"Invalid confirmation code.\"}");
                    }
                } else {
                    jsonResponse.append("{\"success\":false,\"message\":\"Session expired. Please try again.\"}");
                }
            }

            out.print(jsonResponse.toString());
        } catch (Exception e) {
            jsonResponse.append("{\"success\":false,\"message\":\"Unknown error: ").append(escapeJson(e.getMessage())).append("\"}");
            out.print(jsonResponse.toString());
        } finally {
            out.close();
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}