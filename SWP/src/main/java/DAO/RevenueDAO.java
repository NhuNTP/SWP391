package DAO;

import DB.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RevenueDAO {

    private static final Logger LOGGER = Logger.getLogger(RevenueDAO.class.getName());
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    // Lấy doanh thu hôm nay
    public double getTodayRevenue() {
        String sql = "SELECT SUM(TotalRevenue) as TodayRevenue FROM Revenue WHERE OrderDate = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("TodayRevenue");
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting today's revenue", e);
        }
        return 0.0;
    }

    // Lấy doanh thu theo giờ trong ngày hôm nay
    public Map<String, Double> getRevenueByHourToday() {
        Map<String, Double> revenueByHour = new HashMap<>();
        String sql = "SELECT DATEPART(HOUR, o.OrderDate) as Hour, SUM(r.TotalRevenue) as Revenue " +
                     "FROM [Order] o JOIN Revenue r ON o.OrderId = r.OrderId " +
                     "WHERE CAST(o.OrderDate AS DATE) = CAST(GETDATE() AS DATE) " +
                     "GROUP BY DATEPART(HOUR, o.OrderDate)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String hour = String.format("%02d:00", rs.getInt("Hour"));
                double revenue = rs.getDouble("Revenue");
                revenueByHour.put(hour, revenue);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting revenue by hour", e);
        }
        return revenueByHour;
    }

    // Lấy tổng doanh thu tuần
    public double getWeeklyRevenueTotal() {
        String sql = "SELECT SUM(TotalRevenue) as WeeklyRevenue FROM Revenue WHERE OrderDate >= DATEADD(day, -6, CAST(GETDATE() AS DATE))";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("WeeklyRevenue");
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting weekly revenue total", e);
        }
        return 0.0;
    }

    // Lấy doanh thu 7 ngày gần nhất
    public Map<String, Double> getWeeklyRevenue() {
        Map<String, Double> revenueData = new HashMap<>();
        String sql = "SELECT OrderDate, SUM(TotalRevenue) as Revenue " +
                     "FROM Revenue " +
                     "WHERE OrderDate >= DATEADD(day, -6, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY OrderDate " +
                     "ORDER BY OrderDate ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String date = DATE_FORMAT.format(rs.getDate("OrderDate"));
                double revenue = rs.getDouble("Revenue");
                revenueData.put(date, revenue);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting weekly revenue", e);
        }
        return revenueData;
    }

    // Lấy tổng doanh thu tháng
    public double getMonthlyRevenueTotal() {
        String sql = "SELECT SUM(TotalRevenue) as MonthlyRevenue FROM Revenue WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("MonthlyRevenue");
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly revenue total", e);
        }
        return 0.0;
    }

    // Lấy doanh thu theo tuần trong tháng
    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> revenueData = new HashMap<>();
        String sql = "SELECT DATEPART(WEEK, OrderDate) as Week, SUM(TotalRevenue) as Revenue " +
                     "FROM Revenue " +
                     "WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) " +
                     "GROUP BY DATEPART(WEEK, OrderDate)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String week = "Week " + rs.getInt("Week");
                double revenue = rs.getDouble("Revenue");
                revenueData.put(week, revenue);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly revenue", e);
        }
        return revenueData;
    }

    // Lấy tổng doanh thu năm
    public double getYearlyRevenueTotal() {
        String sql = "SELECT SUM(TotalRevenue) as YearlyRevenue FROM Revenue WHERE YEAR(OrderDate) = YEAR(GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("YearlyRevenue");
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting yearly revenue total", e);
        }
        return 0.0;
    }

    // Lấy doanh thu theo tháng trong năm
    public Map<String, Double> getYearlyRevenue() {
        Map<String, Double> revenueData = new HashMap<>();
        String sql = "SELECT MONTH(OrderDate) as Month, SUM(TotalRevenue) as Revenue " +
                     "FROM Revenue " +
                     "WHERE YEAR(OrderDate) = YEAR(GETDATE()) " +
                     "GROUP BY MONTH(OrderDate)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String month = "Month " + rs.getInt("Month");
                double revenue = rs.getDouble("Revenue");
                revenueData.put(month, revenue);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting yearly revenue", e);
        }
        return revenueData;
    }
}