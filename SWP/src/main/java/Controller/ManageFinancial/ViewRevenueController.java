/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.ManageFinancial;

import DAO.RevenueDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewrevenue")
public class ViewRevenueController extends HttpServlet {

    private final RevenueDAO revenueDAO = new RevenueDAO(); // Use RevenueDAO
    private static final Logger LOGGER = Logger.getLogger(ViewRevenueController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Total Revenue
        double totalRevenue = revenueDAO.getTotalRevenue();
        if (totalRevenue == -1) {
            request.setAttribute("errorMessage", "Error retrieving total revenue. See server logs.");
        } else {
            request.setAttribute("totalRevenue", totalRevenue);
        }

        // Daily Revenue
        try {
            LocalDate dailyDate = LocalDate.now(); // Default to today
            String dateParam = request.getParameter("dailyDate");
            if (dateParam != null && !dateParam.isEmpty()) {
                dailyDate = LocalDate.parse(dateParam);
            }
            double dailyRevenue = revenueDAO.getDailyRevenue(dailyDate);
            if (dailyRevenue == -1) {
                request.setAttribute("dailyRevenueError", "Error retrieving daily revenue for " + dailyDate + ". See server logs.");
            } else {
                request.setAttribute("dailyRevenue", dailyRevenue);
                request.setAttribute("dailyDate", dailyDate);
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("dailyRevenueError", "Invalid date format. Please use YYYY-MM-DD.");
        }

        // Monthly Revenue
        try {
            YearMonth monthlyYearMonth = YearMonth.now(); // Default to current month
            String monthParam = request.getParameter("monthlyYear");
            if (monthParam != null && !monthParam.isEmpty()) {
                monthlyYearMonth = YearMonth.parse(monthParam);
            }
            double monthlyRevenue = revenueDAO.getMonthlyRevenue(monthlyYearMonth);
            if (monthlyRevenue == -1) {
                request.setAttribute("monthlyRevenueError", "Error retrieving monthly revenue for " + monthlyYearMonth + ". See server logs.");
            } else {
                request.setAttribute("monthlyRevenue", monthlyRevenue);
                request.setAttribute("monthlyYear", monthlyYearMonth);
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("monthlyRevenueError", "Invalid month format. Please use YYYY-MM.");
        }

        // Yearly Revenue
        try {
            int yearlyYear = LocalDate.now().getYear(); // Default to current year
            String yearParam = request.getParameter("yearlyYear");
            if (yearParam != null && !yearParam.isEmpty()) {
                yearlyYear = Integer.parseInt(yearParam);
            }
            double yearlyRevenue = revenueDAO.getYearlyRevenue(yearlyYear);
            if (yearlyRevenue == -1) {
                request.setAttribute("yearlyRevenueError", "Error retrieving yearly revenue for " + yearlyYear + ". See server logs.");
            } else {
                request.setAttribute("yearlyRevenue", yearlyRevenue);
                request.setAttribute("yearlyYear", yearlyYear);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("yearlyRevenueError", "Invalid year format. Please use a number (e.g., 2023).");
        }
        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("ManageFinancial/viewrevenue.jsp");
        dispatcher.forward(request, response);
    }
}