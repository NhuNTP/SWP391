package DAO;

import DB.DBContext;
import Model.Revenue;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RevenueDAO {

    private static final Logger LOGGER = Logger.getLogger(RevenueDAO.class.getName());
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    // Lấy doanh thu hôm nay (tổng hợp)
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
    public List<Revenue> getRevenueByHourToday() {
        List<Revenue> revenueList = new ArrayList<>();
        String sql = "SELECT 'R' + CAST(DATEPART(HOUR, o.OrderDate) AS NVARCHAR) as RevenueId, " +
                     "NULL as OrderId, " + // Không cần OrderId cụ thể khi tổng hợp
                     "SUM(r.TotalRevenue) as TotalRevenue, " +
                     "CAST(o.OrderDate AS DATE) as OrderDate " +
                     "FROM [Order] o JOIN Revenue r ON o.OrderId = r.OrderId " +
                     "WHERE CAST(o.OrderDate AS DATE) = CAST(GETDATE() AS DATE) " +
                     "GROUP BY DATEPART(HOUR, o.OrderDate), CAST(o.OrderDate AS DATE)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String revenueId = rs.getString("RevenueId");
                String orderId = rs.getString("OrderId");
                double totalRevenue = rs.getDouble("TotalRevenue");
                java.sql.Date sqlDate = rs.getDate("OrderDate");
                java.util.Date orderDate = new java.util.Date(sqlDate.getTime());
                revenueList.add(new Revenue(revenueId, orderId, totalRevenue, orderDate));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting revenue by hour", e);
        }
        return revenueList;
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
    public List<Revenue> getWeeklyRevenue() {
        List<Revenue> revenueList = new ArrayList<>();
        String sql = "SELECT 'R' + CAST(ROW_NUMBER() OVER (ORDER BY OrderDate) AS NVARCHAR) as RevenueId, " +
                     "NULL as OrderId, " + // Không cần OrderId cụ thể khi tổng hợp
                     "SUM(TotalRevenue) as TotalRevenue, " +
                     "OrderDate " +
                     "FROM Revenue " +
                     "WHERE OrderDate >= DATEADD(day, -6, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY OrderDate " +
                     "ORDER BY OrderDate ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String revenueId = rs.getString("RevenueId");
                String orderId = rs.getString("OrderId");
                double totalRevenue = rs.getDouble("TotalRevenue");
                java.sql.Date sqlDate = rs.getDate("OrderDate");
                java.util.Date orderDate = new java.util.Date(sqlDate.getTime());
                revenueList.add(new Revenue(revenueId, orderId, totalRevenue, orderDate));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting weekly revenue", e);
        }
        return revenueList;
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
    public List<Revenue> getMonthlyRevenue() {
        List<Revenue> revenueList = new ArrayList<>();
        String sql = "SELECT 'R' + CAST(DATEPART(WEEK, OrderDate) AS NVARCHAR) as RevenueId, " +
                     "NULL as OrderId, " + // Không cần OrderId cụ thể khi tổng hợp
                     "SUM(TotalRevenue) as TotalRevenue, " +
                     "CAST(GETDATE() AS DATE) as OrderDate " + // Dùng ngày hiện tại làm đại diện
                     "FROM Revenue " +
                     "WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) " +
                     "GROUP BY DATEPART(WEEK, OrderDate)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String revenueId = rs.getString("RevenueId");
                String orderId = rs.getString("OrderId");
                double totalRevenue = rs.getDouble("TotalRevenue");
                java.sql.Date sqlDate = rs.getDate("OrderDate");
                java.util.Date orderDate = new java.util.Date(sqlDate.getTime());
                revenueList.add(new Revenue(revenueId, orderId, totalRevenue, orderDate));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly revenue", e);
        }
        return revenueList;
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
    public List<Revenue> getYearlyRevenue() {
        List<Revenue> revenueList = new ArrayList<>();
        String sql = "SELECT 'R' + CAST(MONTH(OrderDate) AS NVARCHAR) as RevenueId, " +
                     "NULL as OrderId, " + // Không cần OrderId cụ thể khi tổng hợp
                     "SUM(TotalRevenue) as TotalRevenue, " +
                     "CAST(GETDATE() AS DATE) as OrderDate " + // Dùng ngày hiện tại làm đại diện
                     "FROM Revenue " +
                     "WHERE YEAR(OrderDate) = YEAR(GETDATE()) " +
                     "GROUP BY MONTH(OrderDate)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String revenueId = rs.getString("RevenueId");
                String orderId = rs.getString("OrderId");
                double totalRevenue = rs.getDouble("TotalRevenue");
                java.sql.Date sqlDate = rs.getDate("OrderDate");
                java.util.Date orderDate = new java.util.Date(sqlDate.getTime());
                revenueList.add(new Revenue(revenueId, orderId, totalRevenue, orderDate));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting yearly revenue", e);
        }
        return revenueList;
    }
}