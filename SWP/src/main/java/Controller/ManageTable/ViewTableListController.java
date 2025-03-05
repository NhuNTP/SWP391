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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ViewTableList")
public class ViewTableListController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewTableListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewTableListController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            TableDAO tableDAO = new TableDAO();
            ResultSet rs = tableDAO.getAllTable(); // Giữ nguyên việc lấy danh sách bàn
            List<Table> tableList = new ArrayList<>();
            List<Integer> floorNumberList = tableDAO.getFloorNumbers(); // **Thêm dòng này: Lấy danh sách tầng**

            while (rs.next()) {
                // Tạo đối tượng Table và lấy đầy đủ thông tin
                Table table = new Table();
                table.setTableId(rs.getString("TableId"));
                table.setTableStatus(rs.getString("TableStatus"));
                table.setNumberOfSeats(rs.getInt("NumberOfSeats"));
                table.setFloorNumber(rs.getInt("FloorNumber")); // Lấy FloorNumber
                tableList.add(table);
            }

            request.setAttribute("tableList", tableList);
            request.setAttribute("floorNumberList", floorNumberList); // **Thêm dòng này: Truyền danh sách tầng vào request**
            request.getRequestDispatcher("ManageTable/ViewTableList.jsp").forward(request, response);

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ViewTableListController.class.getName()).log(Level.SEVERE, null, ex);
            // Xử lý lỗi tốt hơn: hiển thị trang lỗi, hoặc log lỗi vào file...
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response); // Ví dụ chuyển đến trang error.jsp
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
