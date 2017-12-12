package Tools;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Vector;
import java.util.regex.Pattern;

public class BDRenequinepolis extends Bd {
    public BDRenequinepolis(BdType type) throws IOException, SQLException {
        super(type);
    }

    public BDRenequinepolis(BdType type, boolean autocomit) throws IOException, SQLException {
        super(type, autocomit);
    }

    public ResultSet getMovie(String id) {
        ResultSet rs = null;
        CallableStatement cs;
        try {
            cs = Connection.prepareCall("{? = call RechFilm.GetMovie(?)}");
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            //ID
            if (Pattern.matches("\\d+", id)) cs.setInt(2, Integer.parseInt(id));
            else cs.setNull(2, Types.INTEGER);
            cs.execute();
            return (ResultSet) cs.getObject(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /*
     * Retourne un tableau contenant tous les films résultant de la recherche.
     */
    public ResultSet getMovies(String titre, ArrayList acteurs, ArrayList producteurs, String date) {
        ResultSet rs = null;
        CallableStatement cs;
        try {
            ArrayDescriptor array_artistsDesc = ArrayDescriptor.createDescriptor("CB.NAMEARRAY", Connection);

            cs = Connection.prepareCall("{? = call RechFilm.GetMovies(?, ?, ?, ?, ?)}");
            cs.registerOutParameter(1, OracleTypes.CURSOR);

            //Titre
            if (!titre.equals("")) cs.setString(2, titre);
            else cs.setNull(2, Types.VARCHAR);

            //Liste Acteurs
            if (acteurs != null && acteurs.size() != 0) {
                Array array = new ARRAY(array_artistsDesc, Connection, acteurs.toArray());
                cs.setArray(3, array);
            } else cs.setNull(3, Types.ARRAY,"CB.NAMEARRAY");

            //Réalisateur
            if (producteurs != null && producteurs.size() != 0) {
                Array array = new ARRAY(array_artistsDesc, Connection, producteurs.toArray());
                cs.setArray(4, array);
            } else cs.setNull(4, Types.ARRAY,"CB.NAMEARRAY");

            //Date
            if (!date.equals("")) {
                cs.setString(5, date);
                cs.setString(6, date);
            } else {
                cs.setNull(5, Types.VARCHAR);
                cs.setNull(6, Types.VARCHAR);
            }

            boolean result = cs.execute();

            rs = (ResultSet) cs.getObject(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return rs;
    }

    public Vector<String> getActors(String id){
        Vector<String> actors = null;
        ResultSet rs = null;
        CallableStatement cs;
        try {
            cs = Connection.prepareCall("{? = call RechFilm.GetActorsFromMovie(?)}");
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            //ID
            if (Pattern.matches("\\d+", id)) cs.setInt(2, Integer.parseInt(id));
            else cs.setNull(2, Types.INTEGER);
            cs.execute();
            rs = (ResultSet)cs.getObject(1);

            actors = new Vector<>();
            while (rs.next())
            {
                actors.addElement(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return actors;
    }

    public Vector<String> getDirectors(String id){
        Vector<String> directors = null;
        ResultSet rs = null;
        CallableStatement cs;
        try {
            cs = Connection.prepareCall("{? = call RechFilm.GetDirectorsFromMovie(?)}");
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            //ID
            if (Pattern.matches("\\d+", id)) cs.setInt(2, Integer.parseInt(id));
            else cs.setNull(2, Types.INTEGER);
            cs.execute();
            rs = (ResultSet)cs.getObject(1);

            directors = new Vector<>();
            while (rs.next())
            {
                directors.addElement(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return directors;
    }

    /*public Vector getGenre(String id){

    }*/
}
