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
import java.nio.file.Paths;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 *
 * @author ADMIN
 */
@WebServlet("/UpdateAccount")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 50, // 50MB (tăng từ 10MB)
        maxRequestSize = 1024 * 1024 * 100 // 100MB (tăng từ 50MB)
)
public class UpdateAccountController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final String UPLOAD_DIRECTORY = "ManageAccount/account_img"; // Đảm bảo đường dẫn này khớp với thư mục tải lên mong muốn của bạn

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
            out.println("<title>Servlet UpdateAccountController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAccountController at " + request.getContextPath() + "</h1>");
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
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("ViewAccountList"); // Redirect nếu không có id
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            AccountDAO dao = new AccountDAO();
            Account account = dao.getAccountId(id);

            if (account == null) {
                response.sendRedirect("ViewAccountList"); // Redirect nếu không tìm thấy account
                return;
            }

            request.setAttribute("account", account); // Lưu account vào request attribute
            request.getRequestDispatcher("ManageAccount/UpdateAccount.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewAccountList"); // Redirect nếu id không phải là số
        } catch (Exception e) {
            // Xử lý các exception khác nếu cần thiết, ví dụ log lỗi
            e.printStackTrace();
            response.sendRedirect("ViewAccountList"); // Redirect nếu có lỗi database
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
        response.setContentType("text/html;charset=UTF-8");
        try {
            // Step 1: Get all form parameters (CODE CŨ - ĐƯỢC CHUYỂN XUỐNG DƯỚI ĐỂ THỨ TỰ LOGIC HƠN)
            int UserId = Integer.parseInt(request.getParameter("UserIdHidden"));
            String UserEmail = request.getParameter("UserEmail");
            String UserPassword = request.getParameter("UserPassword");
            String UserName = request.getParameter("UserName");
            String UserRole = request.getParameter("UserRole");
            String IdentityCard = request.getParameter("IdentityCard");
            String UserAddress = request.getParameter("UserAddress");
            String oldImagePath = request.getParameter("oldImagePath"); // Get old image path  <--  CRITICAL FIX

            // 2. Image Upload Handling
            Part filePart = request.getPart("UserImage");
            String UserImage = null;

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                // 2.1 User uploaded a NEW image
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dotIndex = fileName.lastIndexOf('.');
                if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
                    fileExtension = fileName.substring(dotIndex);
                }
                String userImageName = request.getParameter("UserImage"); //User enter image name
                String uniqueFileName;

                if (userImageName != null && !userImageName.trim().isEmpty()) {
                    String sanitizedImageName = userImageName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
                    uniqueFileName = sanitizedImageName + fileExtension;
                } else {
                    uniqueFileName = UUID.randomUUID().toString() + "_" + fileName; //Sử dụng UUID + tên file gốc
                }

                // 2.2 Create Paths
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

                String filePath = uploadPath + File.separator + uniqueFileName;
                UserImage = "ManageAccount/account_img/" + uniqueFileName;

                // 2.3 Save the NEW file
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File saved successfully to: " + filePath);
                }

                // 2.4 DELETE the OLD image (if it exists)
                if (oldImagePath != null && !oldImagePath.isEmpty()) {
                    String oldFilePath = srcWebAppPath + File.separator + oldImagePath; // Đường dẫn đầy đủ tới ảnh cũ
                    File oldFile = new File(oldFilePath);
                    if (oldFile.exists() && !oldFile.isDirectory()) {
                        if (oldFile.delete()) {
                            System.out.println("Old image deleted: " + oldFilePath);
                        } else {
                            System.err.println("Failed to delete old image: " + oldFilePath);
                            // Handle file deletion failure (log, notify, etc.)
                        }
                    }
                }
            } else {
                // 2.5 NO new image -> KEEP the old image
                UserImage = oldImagePath;
                System.out.println("No new image. Keeping old image: " + UserImage);
            }

            AccountDAO dao = new AccountDAO();
            Account oldAccount = dao.getAccountId(UserId);

            Account account = new Account(UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, UserImage);
            int count = dao.updateAccount(UserId, account);

            // Redirect based on whether the update was successful (CODE CŨ)
            if (count > 0) {
                response.sendRedirect("ViewAccountList");
            } else {
                response.sendRedirect("UpdateAccount?id=" + UserId);
            }

        } catch (ServletException | IOException | NumberFormatException e) {
            e.printStackTrace(); // Log lỗi chi tiết hơn (nên dùng logger thay vì printStackTrace trong production)
            response.getWriter().println("Có lỗi xảy ra trong quá trình cập nhật tài khoản: " + e.getMessage()); // Hiển thị thông báo lỗi cho người dùng
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
