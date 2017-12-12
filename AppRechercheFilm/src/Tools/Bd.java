package Tools;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

@SuppressWarnings("ALL")
public class Bd {

    protected Connection Connection;

    /**
     * @param type
     * @throws IOException
     * @throws SQLException
     */
    public Bd(BdType type) throws IOException, SQLException {
        this.Connection = createConnection(type);
    }

    /**
     * @param type
     * @param lockTime
     * @throws IOException
     * @throws SQLException
     */
    public Bd(BdType type, boolean autocomit) throws IOException, SQLException {
        this.Connection = createConnection(type);
        this.Connection.setAutoCommit(autocomit);
    }

    /**
     * @param type
     * @return
     * @throws SQLException
     * @throws IOException
     */
    public synchronized static Connection createConnection(BdType type) throws SQLException, IOException {
        String confFile = Bd.class.getResource("Properties").getFile() + File.separator;
        switch (type) {
            case MySql:
                confFile += "mysql.properties";
                break;
            case Oracle:
                confFile += "oracle.properties";
                break;
            default:
                System.exit(-1);
        }
        Properties p = new Properties();
        p.load(new FileReader(new File(confFile)));
        String url = p.getProperty("url");
        String user = p.getProperty("user");
        String passwd = p.getProperty("password");
        try {
            Class.forName(p.getProperty("driver")).newInstance();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(url, user, passwd);
    }

    /**
     * @param rs
     * @throws SQLException
     */
    public static void AfficheResultSet(ResultSet rs) throws SQLException {
        ResultSetMetaData rsmf = rs.getMetaData();
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= rsmf.getColumnCount(); i++) {
            sb.append(rsmf.getColumnName(i)).append("|");
        }
        sb.deleteCharAt(sb.length() - 1);
        System.out.println(sb);
        while (rs.next()) {
            sb = new StringBuilder();
            for (int i = 1; i <= rsmf.getColumnCount(); i++) {
                sb.append(rs.getObject(i)).append("|");
            }
            sb.deleteCharAt(sb.length() - 1);
            System.out.println(sb);
        }
    }

    /**
     * Fonction qui va prendre toutes les valeurs d'un noeud d'un résultset, et les mettre dans une liste
     *
     * @param rs Resultset à analyser
     * @return null si le RésultSet est fermé<br/>
     * List des valeurs du noeud sur lequel pointe le résultset
     * @throws SQLException Toute exceptions pouvant être lancée
     */
    public static List ToList(ResultSet rs) throws SQLException {
        List l = new LinkedList();
        if (rs.isClosed())
            return null;
        else if (rs.isBeforeFirst())
            rs.next();
        else if (rs.isAfterLast())
            return null;
        ResultSetMetaData rsmd = rs.getMetaData();
        for (int i = 1; i <= rsmd.getColumnCount(); i++) l.add(rs.getObject(i));
        return l;
    }

    /**
     * @param isolationLevel
     * @throws SQLException
     */
    public synchronized void setTransactionIsolationLevel(int isolationLevel) throws SQLException {
        this.Connection.setTransactionIsolation(isolationLevel);
    }

    /**
     * @param rs
     * @return
     * @throws SQLException
     */
    public static Table toTable(ResultSet rs) throws SQLException {
        Vector<String> title = new Vector<>();
        ResultSetMetaData rsmd = rs.getMetaData();
        for (int i = 1; i <= rsmd.getColumnCount(); i++) {
            title.add(rsmd.getColumnName(i));
        }
        Vector<Vector<String>> champs = new Vector<>();
        rs.beforeFirst();
        while (rs.next()) {
            Vector<String> temp = new Vector<>();
            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                try {
                    //Sous MySql, n'importe quel type de données peut être directement converti en String
                    //Le passage via le type ne fonctionne pas
                    if (rsmd.getColumnTypeName(i) == "TINYINT") {
                        temp.add(String.valueOf(rs.getBoolean(i)));
                    } else if (rsmd.getColumnTypeName(i) == "FLOAT") {
                        temp.add(String.valueOf(rs.getFloat(i)));
                    } else {
                        temp.add(rs.getString(i));
                    }
                } catch (SQLException e) {
                    System.out.println(Thread.currentThread().getName() + "> Exception: " + e.getMessage());
                }
            }
            champs.add(temp);
        }
        return new Table(title, champs);
    }

    public synchronized void close() throws SQLException {
        close(false);
    }

    public synchronized void close(boolean commit) throws SQLException {
        if (commit) {
            Connection.commit();
        }
        Connection.close();
    }

    public synchronized void commit() throws SQLException {
        Connection.commit();
    }

    public Connection getConnection() {
        return Connection;
    }

    public synchronized void rollback() throws SQLException {
        Connection.rollback();
    }

    public synchronized void rollback(Savepoint s) throws SQLException {
        Connection.rollback(s);
    }

    public synchronized void setAutoComit(boolean b) throws SQLException {
        Connection.setAutoCommit(b);
    }

    public synchronized Savepoint setSavepoint() throws SQLException {
        return Connection.setSavepoint();
    }
}
