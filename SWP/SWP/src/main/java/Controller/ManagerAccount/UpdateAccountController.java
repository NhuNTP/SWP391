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

    private static final String UPLOAD_DIRECTORY = "img"; // **Đã thêm dòng này**

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
        String userImagePath = null; // Đường dẫn ảnh, ban đầu là null
        try {
            // Step 1: Handle image file upload (COPY TỪ CreateAccountController.java)
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
            }
            // Step 1: Get all form parameters (CODE CŨ - ĐƯỢC CHUYỂN XUỐNG DƯỚI ĐỂ THỨ TỰ LOGIC HƠN)
            int UserId = Integer.parseInt(request.getParameter("UserIdHidden"));
            String UserEmail = request.getParameter("UserEmail");
            String UserPassword = request.getParameter("UserPassword");
            String UserName = request.getParameter("UserName");
            String UserRole = request.getParameter("UserRole");
            String IdentityCard = request.getParameter("IdentityCard");
            String UserAddress = request.getParameter("UserAddress");

            // Lấy tài khoản cũ từ database (CODE CŨ)
            AccountDAO dao = new AccountDAO();
            Account oldAccount = dao.getAccountId(UserId);

            if (userImagePath == null || userImagePath.isEmpty()) { // **KIỂM TRA userImagePath SAU UPLOAD**
                userImagePath = oldAccount.getUserImage(); // Nếu không có file mới, GIỮ NGUYÊN ảnh cũ
            }

            Account account = new Account(UserId, UserEmail, UserPassword, UserName, UserRole, IdentityCard, UserAddress, userImagePath);
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
