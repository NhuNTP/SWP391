package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//NGUYEN THANH PHAT CE180119
public class DBContext {

    public Connection connection;

    public DBContext() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=db1;encrypt=true;trustServerCertificate=true";
            String username = "sa";
            String password = "123456";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);

        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println(ex);
        }
    }
    
      public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        if (dbContext.connection != null) {
            System.out.println("Success connection");
        } else {
            System.out.println("Fail connection!");
        }
        
        
    }
}

