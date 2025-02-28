package DAO;

import DB.DBContext;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.LocalDate;
import java.time.YearMonth;

public class RevenueDAO {

    private static final Logger LOGGER = Logger.getLogger(RevenueDAO.class.getName());

    public double getTotalRevenue() {
        String sql = "SELECT SUM(TotalRevenue) AS Total FROM Revenue";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            if (resultSet.next()) {
                return resultSet.getDouble("Total");
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting total revenue", e);
            return -1;
        }
        return 0; // Default if no revenue found
    }

    public double getDailyRevenue(LocalDate date) {
        String sql = "SELECT SUM(TotalRevenue) AS Total FROM Revenue WHERE CAST(OrderDate AS DATE) = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setDate(1, Date.valueOf(date));
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble("Total");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting daily revenue for date: " + date, e);
            return -1; // Indicate error
        }
        return 0; // Return 0 if no revenue found for the date
    }

    public double getMonthlyRevenue(YearMonth yearMonth) {
        String sql = "SELECT SUM(TotalRevenue) AS Total FROM Revenue WHERE YEAR(OrderDate) = ? AND MONTH(OrderDate) = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, yearMonth.getYear());
            preparedStatement.setInt(2, yearMonth.getMonthValue());

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble("Total");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly revenue for month: " + yearMonth, e);
            return -1;
        }
        return 0;
    }

    public double getYearlyRevenue(int year) {
        String sql = "SELECT SUM(TotalRevenue) AS Total FROM Revenue WHERE YEAR(OrderDate) = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, year);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble("Total");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting yearly revenue for year: " + year, e);
            return -1;
        }
        return 0;
    }
}