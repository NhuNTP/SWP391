package Controller.ManageTable;

import DAO.TableDAO;
import Model.Table;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/UpdateTable")
public class UpdateTableController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateTableController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateTableController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tableId = request.getParameter("id"); // Lấy ID dưới dạng String

        if (tableId == null || tableId.isEmpty()) {
            response.sendRedirect("ViewTableList"); // Chuyển hướng nếu không có ID
            return;
        }

        try {
            TableDAO dao = new TableDAO();
            Table table = dao.getTableById(tableId); // Sử dụng getTableById(String)

            if (table == null) {
                response.sendRedirect("ViewTableList"); // Chuyển hướng nếu không tìm thấy bàn
                return;
            }

            request.setAttribute("table", table);
            request.getRequestDispatcher("ManageTable/UpdateTable.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // In ra lỗi (cho mục đích debugging)
            response.sendRedirect("ViewTableList"); // Chuyển hướng nếu có lỗi
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String TableId = request.getParameter("TableIdHidden"); // Lấy ID dưới dạng String, từ hidden field
            String TableStatus = request.getParameter("TableStatus");
            int NumberOfSeats = Integer.parseInt(request.getParameter("NumberOfSeats"));
            int FloorNumber = Integer.parseInt(request.getParameter("FloorNumber")); // Lấy FloorNumber

            // Tạo đối tượng Table
            Table table = new Table(TableId, TableStatus, NumberOfSeats, FloorNumber); // Không cần truyền IsDeleted

            TableDAO dao = new TableDAO();
            int count = dao.updateTable(TableId, table); // Truyền ID dạng String

            if (count > 0) {
                response.sendRedirect("ViewTableList"); // Chuyển hướng nếu cập nhật thành công
            } else {
                request.setAttribute("errorMessage", "Update table failed!");
                request.setAttribute("table", table); // Giữ lại thông tin cũ để hiển thị lại trên form
                request.getRequestDispatcher("ManageTable/UpdateTable.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu NumberOfSeats hoặc FloorNumber không phải là số
            request.setAttribute("errorMessage", "Invalid input for Number of Seats or Floor Number.");
            request.getRequestDispatcher("ManageTable/UpdateTable.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException ex) {
            // Xử lý các exception khác
            Logger.getLogger(UpdateTableController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("ManageTable/UpdateTable.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
