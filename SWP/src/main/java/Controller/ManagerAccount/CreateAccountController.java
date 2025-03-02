/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

/**
 *
 * @author ADMIN
 */
@WebServlet("/CreateAccount")

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 50, // 50MB (tăng từ 10MB)
        maxRequestSize = 1024 * 1024 * 100 // 100MB (tăng từ 50MB)
)

public class CreateAccountController extends HttpServlet {

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
            out.println("<title>Servlet CreateAccountController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateAccountController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("ManageAccount/CreateAccount.jsp").forward(request, response);
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
        response.setContentType("text/html;charset=UTF-8");
        try {
            // Step 1: Get all text form parameters (giữ nguyên)
            String UserEmail = request.getParameter("UserEmail");
            String UserPassword = request.getParameter("UserPassword");
            String UserName = request.getParameter("UserName");
            String UserRole = request.getParameter("UserRole");
            String IdentityCard = request.getParameter("IdentityCard");
            String UserAddress = request.getParameter("UserAddress");
            
            // 2. Xử lý upload hình ảnh
            Part filePart = request.getPart("UserImage");
            String UserImage = null; // Khởi tạo relativeImagePath là null

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                // Hình ảnh đã được chọn và tải lên

                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
                    fileExtension = fileName.substring(dotIndex);
                }

                // Lấy tên hình ảnh người dùng nhập (nếu có)
                String userImageName = request.getParameter("UserImage");
                String uniqueFileName;

                if (userImageName != null && !userImageName.trim().isEmpty()) {
                    String sanitizedImageName = userImageName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
                    uniqueFileName = sanitizedImageName + fileExtension; // Sử dụng tên người dùng, bỏ UUID prefix (nếu bạn muốn)
                } else {
                    uniqueFileName = UUID.randomUUID().toString() + "_" + fileName; // Sử dụng UUID + tên file gốc
                }

                // 3. Tạo đường dẫn lưu trữ hình ảnh (giữ nguyên phần đường dẫn)
                String webAppRoot = getServletContext().getRealPath("/");
                File webAppRootDir = new File(webAppRoot);
                File targetDir = webAppRootDir.getParentFile();
                File projectRootDir = targetDir.getParentFile();
                String srcWebAppPath = new File(projectRootDir, "src/main/webapp").getAbsolutePath();
                String relativePath = "ManageAccount/account_img";
                String uploadPath = srcWebAppPath + File.separator + relativePath;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 4. Xử lý tên file an toàn
                String filePath = uploadPath + File.separator + uniqueFileName;
                UserImage = "ManageAccount/account_img/" + uniqueFileName; // Cập nhật relativeImagePath ở đây

                // Lưu file
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File saved successfully to: " + filePath);
                }

            } else {
                // Không có hình ảnh nào được chọn
                UserImage = null; // Đặt relativeImagePath thành null khi không có hình ảnh
                System.out.println("No image uploaded for item: " + UserName); // Log để theo dõi
            }

            // Step 3: Create Account object
            Account account = new Account(UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage);
            AccountDAO dao = new AccountDAO();

            // Step 4: Create account in database
            int count = dao.createAccount(account);

            // Step 5: Handle result and redirect
            if (count > 0) {
                response.sendRedirect("ViewAccountList");
            } else {
                response.sendRedirect("CreateAccount"); // Có thể forward lại trang create và hiển thị thông báo lỗi
            }

        } catch (ServletException | IOException | NumberFormatException e) {
            e.printStackTrace(); // Log lỗi chi tiết hơn (nên dùng logger thay vì printStackTrace trong production)
            response.getWriter().println("Có lỗi xảy ra trong quá trình tạo tài khoản: " + e.getMessage()); // Hiển thị thông báo lỗi cho người dùng
        } catch (Exception e) { // Bắt các exception khác (ví dụ SQLException)
            e.printStackTrace();
            response.getWriter().println("Lỗi không xác định: " + e.getMessage());
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
