/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageCoupon;

import DAO.CouponDAO;
import Model.Coupon;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 *
 * @author DELL-Laptop
 */
@WebServlet("/AddCouponController")
public class AddCouponController extends HttpServlet {

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
            out.println("<title>Servlet AddCouponController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCouponController at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String couponId_raw = request.getParameter("couponId");
        String discountAmount_str = request.getParameter("discountAmount");
        String expirationDate_raw = request.getParameter("expirationDate");
        String description = request.getParameter("description"); // Lấy description từ request

        // 1. Validation dữ liệu đầu vào
        if (discountAmount_str == null || discountAmount_str.isEmpty()
                || expirationDate_raw == null || expirationDate_raw.isEmpty()
                || description == null || description.isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin giảm giá và ngày hết hạn.");
            request.getRequestDispatcher("AddCoupon.jsp").forward(request, response); // Quay lại trang thêm coupon
            return;
        }

        BigDecimal discountAmount = null;
        Date sqlDate = null;

        try {
            // 2. Parse discountAmount
            try {
                discountAmount = new BigDecimal(discountAmount_str);
                if (discountAmount.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("error", "Giá trị giảm giá phải là số dương.");
                    request.getRequestDispatcher("addCoupon.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Giá trị giảm giá không hợp lệ.");
                request.getRequestDispatcher("addCoupon.jsp").forward(request, response);
                return;
            }

            // 3. Parse expirationDate
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate;
            try {
                utilDate = sdf.parse(expirationDate_raw);
                sqlDate = new Date(utilDate.getTime()); // Chuyển sang java.sql.Date
            } catch (ParseException e) {
                request.setAttribute("error", "Định dạng ngày hết hạn không hợp lệ (yyyy-MM-dd).");
                request.getRequestDispatcher("addCoupon.jsp").forward(request, response);
                return;
            }

            // 4. Tạo đối tượng Coupon (chú ý: couponId có thể auto-increment trong DB)
            Coupon newCoupon = new Coupon(couponId_raw, discountAmount, sqlDate, 0, 0, description); // Giả sử constructor Coupon phù hợp

            // 5. Gọi CouponDAO để thêm mới
            CouponDAO couponDAO = new CouponDAO();
            couponDAO.addNewCoupon(newCoupon);

            // 6. Chuyển hướng sau khi thêm thành công
            response.sendRedirect("ViewCouponController"); // Chuyển đến trang xem danh sách coupon

        } catch (ServletException | IOException e) {
            throw e; // Re-throw ServletException và IOException
        } catch (Exception e) { // Bắt các Exception khác (ví dụ từ CouponDAO)

            request.setAttribute("error", "Có lỗi xảy ra khi thêm mới Coupon. Vui lòng thử lại sau.");
            request.getRequestDispatcher("error.jsp").forward(request, response); // Chuyển đến trang lỗi
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
