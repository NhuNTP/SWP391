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

    private static final String UPLOAD_DIRECTORY = "img"; // **Sử dụng đường dẫn tương đối từ project root**

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
        String userImagePath = null; // Đường dẫn ảnh, ban đầu là null (không có ảnh mặc định)
        try {
            // Step 1: Get all text form parameters (giữ nguyên)
            String UserEmail = request.getParameter("UserEmail");
            String UserPassword = request.getParameter("UserPassword");
            String UserName = request.getParameter("UserName");
            String UserRole = request.getParameter("UserRole");
            String IdentityCard = request.getParameter("IdentityCard");
            String UserAddress = request.getParameter("UserAddress");
            // Step 2: Handle image file upload
            Part filePart = request.getPart("UserImage"); // Lấy Part từ input name="UserImage"
            if (filePart != null && filePart.getSize() > 0) { // Kiểm tra nếu có file được upload
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Lấy tên file gốc
                String fileExtension = fileName.substring(fileName.lastIndexOf(".")); // Lấy đuôi file

                // Tạo tên file duy nhất để tránh trùng lặp (ví dụ: timestamp + tên file gốc)
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                String uploadPath = getServletContext().getRealPath("") + UPLOAD_DIRECTORY; // Đường dẫn thư mục img
                System.out.println("uploadPath: " + uploadPath); // **[DEBUG] In ra uploadPath**

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean dirCreated = uploadDir.mkdirs(); // Tạo thư mục nếu chưa tồn tại
                    System.out.println("Thư mục img được tạo: " + dirCreated); // **[DEBUG] Kiểm tra tạo thư mục**
                } else {
                    System.out.println("Thư mục img đã tồn tại."); // **[DEBUG] Thư mục đã tồn tại**
                }

                String filePath = uploadPath + File.separator + uniqueFileName; // Đường dẫn đầy đủ để lưu file
                System.out.println("filePath: " + filePath); // **[DEBUG] In ra filePath**

                // Lưu file lên server
                try (InputStream inputStream = filePart.getInputStream()) {
                    Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File đã được lưu thành công: " + filePath); // **[DEBUG] Lưu file thành công**
                } catch (IOException copyException) {
                    System.err.println("Lỗi khi lưu file: " + copyException.getMessage()); // **[DEBUG] Lỗi Lưu File**
                    copyException.printStackTrace(); // **In stacktrace lỗi**
                    throw copyException; // Re-throw để Servlet xử lý lỗi chung
                }

                userImagePath = "/" + UPLOAD_DIRECTORY + "/" + uniqueFileName; // Đường dẫn tương đối để lưu vào database (ví dụ: /img/...)
                System.out.println("userImagePath (database): " + userImagePath); // **[DEBUG] Đường dẫn DB**

            } // Không có khối else nữa, userImagePath vẫn là null nếu không upload file

            // Step 3: Create Account object
            Account account = new Account(UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, userImagePath);
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
