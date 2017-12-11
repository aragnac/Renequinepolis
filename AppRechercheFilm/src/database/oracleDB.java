package database;

import Tools.FilesOperations;
import database.Tables.Certification;
import database.Tables.Commentaire;
import database.Tables.Movies;
import database.Tables.Status;

import java.sql.*;
import java.util.HashMap;
import java.util.regex.Pattern;
import oracle.jdbc.OracleTypes;

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
    /*private Object[] getMovies(String titre)
    {
        try
        {
            // Ici il faut modifier le nom de la procedure et le nombre de param
            callabStat = Con.prepareCall("{call " + dbname + ".EVALFILM_GETMOVIE(?, ?, ?, ?, ?)}");

            //Titre
            callabStat.setString(1, '%' + SearchBox.getText().toLowerCase() + '%');
            //Acteurs
            ArrayList<Infos> actors = new ArrayList<>();
            if(!ActorsBox.getText().isEmpty())
            {
                String[] tmp = ActorsBox.getText().toLowerCase().split(";");
                for (String s : tmp)
                    actors.add(new Infos(s));
                if(!actors.isEmpty())
                {
                    Array array = new ARRAY(array_artistsDesc, con, actors.toArray());
                    prepStat.setArray(4, array);
                }
                else prepStat.setNull(4, Types.ARRAY, "ARRAY_INFOS");
            }
            else prepStat.setNull(4, Types.ARRAY, "ARRAY_INFOS");

            //Réalisateur
            ArrayList<Infos> real = new ArrayList<>();
            if(!DirBox.getText().isEmpty())
            {
                String[] tmp = DirBox.getText().toLowerCase().split(";");
                System.out.println(java.util.Arrays.toString(tmp));
                for (String s : tmp)
                    real.add(new Infos(s));
                if(!real.isEmpty())
                {
                    Array array = new ARRAY(array_artistsDesc, con, real.toArray());
                    prepStat.setArray(6, array);
                }
                else prepStat.setNull(6, Types.ARRAY, "ARRAY_INFOS");
            }
            else prepStat.setNull(6, Types.ARRAY, "ARRAY_INFOS");

            //Date
            prepStat.setInt(7, ComboDate.getSelectedIndex());
            if(Pattern.matches("\\d+", DateBox.getText()))
                prepStat.setInt(8, Integer.parseInt(DateBox.getText()));
            else prepStat.setNull(8, Types.INTEGER);

            //Movies
            prepStat.registerOutParameter(9, Types.ARRAY, "ARRAY_MOVIES");

            System.out.println("--Execute");
            prepStat.execute();
            System.out.println("--Executed");

            Movies = (Object[])(((Array)prepStat.getObject(9)).getArray());
        }
        catch (SQLException ex)
        {
            System.out.println(ex);
            if(ex.getClass() == SQLRecoverableException.class)
            {
                ConnectToCB();
                getMovies();
            }
        }

        DefaultTableModel dtm;
        FilmTable.setModel(dtm = new DefaultTableModel(
                new String []
                        {
                                "Title",
                                "Release_Date",
                                "Runtime"
                        },0)
        {
            @Override
            public boolean isCellEditable(int row, int col)
            {
                return false;
            }
        });
        if(Movies == null)return;
        for(Object o : Movies)
        {
            Movies m = (Movies)o;
            dtm.addRow(new Object[]
                    {
                            m.getTitle(),
                            m.getRelease_Date(),
                            m.getRuntime()
                    });
        }
    }*/
}
