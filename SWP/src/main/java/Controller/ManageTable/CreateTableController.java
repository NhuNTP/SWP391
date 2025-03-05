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

@WebServlet("/CreateTable")
public class CreateTableController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateTableController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateTableController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("ManageTable/CreateTable.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String TableStatus = request.getParameter("TableStatus");
            int NumberOfSeats = Integer.parseInt(request.getParameter("NumberOfSeats"));
            int FloorNumber = Integer.parseInt(request.getParameter("FloorNumber")); // Lấy thông tin FloorNumber

            // Tạo đối tượng Table, không truyền ID
            Table table = new Table(TableStatus, NumberOfSeats, FloorNumber);

            TableDAO tableDAO = new TableDAO();
            int count = tableDAO.createTable(table); // Gọi createTable() từ DAO

            if (count > 0) {
                response.sendRedirect("ViewTableList"); // Chuyển hướng đến trang danh sách (thành công)
            } else {
                request.getRequestDispatcher("ManageTable/CreateTable.jsp").forward(request, response); // Quay lại trang tạo
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu NumberOfSeats hoặc FloorNumber không phải là số
            request.setAttribute("errorMessage", "Invalid input for Number of Seats or Floor Number.");
            request.getRequestDispatcher("ManageTable/CreateTable.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException ex) {
            // Xử lý các exception khác (ClassNotFoundException, SQLException)
            Logger.getLogger(CreateTableController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage()); // Thông báo lỗi chi tiết hơn
            request.getRequestDispatcher("ManageTable/CreateTable.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}