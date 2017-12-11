package Tools;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class FilesOperations {

    public final static String PROPERTIES = "C:\\Users\\Nicolas\\IdeaProjects\\InpresAirport\\Application_Test_JDBC\\config.properties";

    private static Properties properties;

    private static String DbType;

    public static void load_Properties(String dbtype) {

        properties = new Properties();

        if (dbtype.equalsIgnoreCase("mysql") || dbtype.equalsIgnoreCase("oracle"))
            DbType = dbtype;

        try {
            properties.load(new FileInputStream(PROPERTIES));
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public static String getUsername() {
        if (DbType.equalsIgnoreCase("mysql"))
            return properties.getProperty("usernameSQL");
        else
            return properties.getProperty("usernameOracle");
    }

    public static String getPassword() {
        if (DbType.equalsIgnoreCase("mysql"))
            return properties.getProperty("passwordSQL");
        else
            return properties.getProperty("passwordOracle");
    }
}
