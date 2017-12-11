package database;

import Tools.FilesOperations;
import database.Tables.Certification;
import database.Tables.Commentaire;
import database.Tables.Movies;
import database.Tables.Status;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Pattern;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;

public class oracleDB {

    private Connection Con;
    private CallableStatement callabStat;
    private String dbname;

    private final String Url = "";
    private final String User = "";
    private final String Passwd = "";


    public oracleDB() throws SQLException {

        HashMap ht = new HashMap();

        FilesOperations.load_Properties("oracle");
        String url = "jdbc:oracle:thin:@//localhost:1521/orcl";
        String user = FilesOperations.getUsername();
        String passwd = FilesOperations.getPassword();

        System.out.println("-------- Test de connexion Oracle ------");
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            e.printStackTrace();
        }
        System.out.println("Oracle JDBC Driver instancié");
        try {
            Con = DriverManager.getConnection(url, user, passwd);
        } catch (SQLException e) {
            System.out.println("Impossible d'établir la connexion");
            throw e;
        }
        Con.setAutoCommit(false);

        ht.put("CB.STATUS", Status.class);
        ht.put("CB.MOVIE", Movies.class);
        ht.put("CB.CERTIFICATION", Certification.class);
        ht.put("CB.COMMENTAIRE", Commentaire.class);

        Con.setTypeMap(ht);
        //array_artistsDesc = ArrayDescriptor.createDescriptor("CB.ARRAY_INFOS", con);
        callabStat = null;
        dbname = "CB";
    }

    public void Connect() throws SQLException {
        try {
            Con = DriverManager.getConnection(Url, User, Passwd);
        } catch (SQLException e) {
            System.out.println("Impossible d'établir la connexion!");
            throw e;
        }
    }

    public void Close() {
        try {
            Con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet getMovie(String id)
    {
        ResultSet rs = null;

        try {
            callabStat = Con.prepareCall("? = call RechFilm.GetMovie(?)");
            callabStat.registerOutParameter(1, OracleTypes.CURSOR);
            //ID
            if(Pattern.matches("\\d+", id))
                callabStat.setInt(1, Integer.parseInt(id));
            else callabStat.setNull(1, Types.INTEGER);

            rs = (ResultSet) callabStat.getObject(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rs;
    }

    /*
    * Retourne un tableau contenant tous les films résultant de la recherche.
    */
    public ResultSet getMovies(String titre, ArrayList acteurs, ArrayList producteurs, String date)
    {
        ResultSet rs = null;

        try
        {
            ArrayDescriptor array_artistsDesc = ArrayDescriptor.createDescriptor("CB.ARRAY_INFOS", Con);

            callabStat = Con.prepareCall("? = call  RechFilm.GetMovies(?, ?, ?, ?, ?)");
            callabStat.registerOutParameter(1, OracleTypes.CURSOR);

            //Titre
            callabStat.setString(2, titre);

            //Liste Acteurs
            Array array = new ARRAY(array_artistsDesc, Con, acteurs.toArray());
            callabStat.setArray(3, array);

            //Réalisateur
            Array arrayr = new ARRAY(array_artistsDesc, Con, producteurs.toArray());
            callabStat.setArray(4, arrayr);

            //Date
            callabStat.setString(2, date);

            rs = (ResultSet) callabStat.getObject(1);
        }
        catch (SQLException ex)
        {

        }
        return rs;
    }
}
