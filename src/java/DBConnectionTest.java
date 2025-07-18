import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnectionTest {
    public static void main(String[] args) {
        try {
            // Replace with your actual database URL, username, and password
            String url = "jdbc:mysql://localhost:3306/pahana_education";
            String user = "root";
            String password = "";

            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            Connection conn = DriverManager.getConnection(url, user, password);

            if (conn != null) {
                System.out.println("✅ Database connection successful!");
                conn.close();
            } else {
                System.out.println("❌ Failed to connect to the database.");
            }
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
