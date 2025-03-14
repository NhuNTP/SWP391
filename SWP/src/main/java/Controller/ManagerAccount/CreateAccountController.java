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
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/CreateAccount")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class CreateAccountController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ViewAccountList");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();

        try {
            String UserEmail = request.getParameter("UserEmail");
            String UserPassword = request.getParameter("UserPassword");
            String UserName = request.getParameter("UserName");
            String UserRole = request.getParameter("UserRole");
            String IdentityCard = request.getParameter("IdentityCard");
            String UserAddress = request.getParameter("UserAddress");

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

            Account account = new Account(null, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage);
            AccountDAO dao = new AccountDAO();

            // Sử dụng hàm gộp, truyền userIdToExclude = null vì không cần loại trừ tài khoản
            if (dao.isEmailExists(UserEmail, null)) {
                jsonResponse.append("{\"success\":false,\"message\":\"Email đã tồn tại. Vui lòng nhập email khác.\"}");
                out.print(jsonResponse.toString());
                return;
            }
            if (IdentityCard != null && !IdentityCard.isEmpty() && dao.isIdentityCardExists(IdentityCard, null)) {
                jsonResponse.append("{\"success\":false,\"message\":\"Số CMND/CCCD đã tồn tại. Vui lòng nhập số khác.\"}");
                out.print(jsonResponse.toString());
                return;
            }

            int count = dao.createAccount(account);

            if (count > 0) {
                jsonResponse.append("{\"success\":true,\"message\":\"Tài khoản được tạo thành công!\"}");
            } else {
                jsonResponse.append("{\"success\":false,\"message\":\"Có lỗi xảy ra trong quá trình tạo tài khoản.\"}");
            }
            out.print(jsonResponse.toString());
        } catch (Exception e) {
            jsonResponse.append("{\"success\":false,\"message\":\"Lỗi không xác định: ").append(escapeJson(e.getMessage())).append("\"}");
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

    @Override
    public String getServletInfo() {
        return "Servlet to create a new account";
    }
}
